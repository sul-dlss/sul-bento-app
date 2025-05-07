document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('nav button:has(+ .hidden)').forEach((button) => {
    button.addEventListener('click', (evt) => {
      const button = evt.target.closest('button')
      button.querySelector('svg').classList.toggle('scale-y-[-1]')
      button.nextSibling.classList.toggle('hidden')
    })
  })
})
