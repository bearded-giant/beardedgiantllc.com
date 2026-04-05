const elements = document.querySelectorAll(
  '.hero-content, .about-inner, .gallery, .connect-inner'
)

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible')
        observer.unobserve(entry.target)
      }
    })
  },
  { threshold: 0.1 }
)

elements.forEach((el) => observer.observe(el))
