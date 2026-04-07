terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# --- enable required apis ---

resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "api_propagation" {
  depends_on      = [google_project_service.compute, google_project_service.storage]
  create_duration = "60s"
}

# --- storage buckets (one per site) ---

resource "google_storage_bucket" "site" {
  for_each   = var.sites
  depends_on = [time_sleep.api_propagation]

  name          = each.value.domain
  project       = var.project_id
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

# public read access
resource "google_storage_bucket_iam_member" "public_read" {
  for_each = var.sites

  bucket = google_storage_bucket.site[each.key].name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# --- ssl certs (google-managed, one per domain) ---

resource "google_compute_managed_ssl_certificate" "site" {
  for_each   = var.sites
  depends_on = [time_sleep.api_propagation]

  name = "cert-${each.key}-v2"

  managed {
    domains = [each.value.domain, "www.${each.value.domain}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# --- backend buckets ---

resource "google_compute_backend_bucket" "site" {
  for_each   = var.sites
  depends_on = [time_sleep.api_propagation]

  name        = "backend-${each.key}"
  bucket_name = google_storage_bucket.site[each.key].name
  enable_cdn  = true
}

# --- url maps (one per site) ---

resource "google_compute_url_map" "site" {
  for_each = var.sites

  name            = "urlmap-${each.key}"
  default_service = google_compute_backend_bucket.site[each.key].self_link
}

# --- https proxy + forwarding rule per site ---

resource "google_compute_target_https_proxy" "site" {
  for_each = var.sites

  name             = "https-proxy-${each.key}"
  url_map          = google_compute_url_map.site[each.key].self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.site[each.key].self_link]
}

resource "google_compute_global_address" "site" {
  for_each   = var.sites
  depends_on = [time_sleep.api_propagation]

  name = "ip-${each.key}"
}

resource "google_compute_global_forwarding_rule" "https" {
  for_each = var.sites

  name       = "fwd-https-${each.key}"
  target     = google_compute_target_https_proxy.site[each.key].self_link
  ip_address = google_compute_global_address.site[each.key].address
  port_range = "443"
}

# --- http -> https redirect ---

resource "google_compute_url_map" "redirect" {
  for_each = var.sites

  name = "urlmap-redirect-${each.key}"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  for_each = var.sites

  name    = "http-proxy-${each.key}"
  url_map = google_compute_url_map.redirect[each.key].self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  for_each = var.sites

  name       = "fwd-http-${each.key}"
  target     = google_compute_target_http_proxy.redirect[each.key].self_link
  ip_address = google_compute_global_address.site[each.key].address
  port_range = "80"
}
