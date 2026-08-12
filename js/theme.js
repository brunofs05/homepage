
// document.documentElement retorna o elemento raiz, o html
const html = document.documentElement;

// query selector procura um elemento usando um seletor css
// neste caso por id
const lightButton = document.querySelector("#theme-light");
const darkButton = document.querySelector("#theme-dark");


// adciona um evento ouvinte
// faz sentido esse nome kkkk
darkButton.addEventListener("click", () => {
  html.setAttribute("data-theme", "dark")
})

lightButton.addEventListener("click", () => {
  html.setAttribute("data-theme", "light")
})
