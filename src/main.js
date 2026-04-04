const elements = document.querySelectorAll('.line, .output')

const reveal = () => {
  elements.forEach((el) => {
    const delay = parseInt(el.dataset.delay || '0', 10)
    setTimeout(() => el.classList.add('visible'), delay)
  })
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', reveal)
} else {
  reveal()
}
