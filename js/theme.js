// DOM := Document Object Model
// é uma interface que representa página web em formato
// de objetos, permitindo que linguagens como o js modifiquem
// a estrutura

// query selector procura um elemento usando um seletor css
// neste caso por id
const lightButton = document.querySelector("#theme-light");
const darkButton = document.querySelector("#theme-dark");
const systemButton = document.querySelector("#theme-system");

const html = document.documentElement;
const metaTag = document.querySelector('[name="color-scheme"]');
const savedScheme = localStorage.getItem("colorScheme");

if (savedScheme) {
  metaTag.setAttribute("content", savedScheme)
}

function setTheme(theme) {
  if (theme == "system") {
    html.removeAttribute("data-theme");
    metaTag.setAttribute("content", "light dark");
    localStorage.removeItem("colorScheme");
    return;
  }

  console.log("teste")

  html.setAttribute("data-theme", theme);
  metaTag.setAttribute("content", theme);
  localStorage.setItem("colorScheme", theme);
}

if (savedScheme ){
 setTheme(savedScheme); 
}

lightButton.addEventListener("click", ()=> {
  setTheme("light"); 
})

darkButton.addEventListener("click", () => {
  setTheme("dark");
})

systemButton.addEventListener("click", () => {
  setTheme("system")
})
