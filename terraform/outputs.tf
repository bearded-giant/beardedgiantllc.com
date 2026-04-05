output "site_ips" {
  description = "static IPs for DNS A records"
  value = {
    for key, site in var.sites : site.domain => google_compute_global_address.site[key].address
  }
}

output "dns_instructions" {
  description = "DNS records to create"
  value = <<-EOT
    For each domain, create an A record pointing to the corresponding IP:

    %{for key, site in var.sites~}
    ${site.domain} -> A -> ${google_compute_global_address.site[key].address}
    %{endfor~}

    SSL certs are Google-managed and will auto-provision once DNS propagates.
    CDN is enabled on all backend buckets.
  EOT
}
