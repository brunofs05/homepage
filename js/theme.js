// DOM := Document Object Model
// é uma interface que representa página web em formato
// de objetos, permitindo que linguagens como o js modifiquem
// a estrutura

// querySelector é um método do objetivo documet, ele recebe um
// - CSS selector - e retorna o primeiro elemento correspondente
// pode ser  id, classe, elemento, atributo
const lightButton = document.querySelector("#theme-light");
const darkButton = document.querySelector("#theme-dark");
const systemButton = document.querySelector("#theme-system");

// color-scheme é o nome de um atributo html, lembre-se:
// <meta name="color-scheme" content="light dark">
const metaTag = document.querySelector('[name="color-scheme"]');

// document é uma instância da classe HTMLDocument
// documentElement é uma propriedade de acesso (getter) desse objeto
// retorna o elemento raiz do documento html, que é a tag html
const html = document.documentElement;


const savedScheme = localStorage.getItem("colorScheme");

if (savedScheme) {
  metaTag.setAttribute("content", savedScheme)
}

function setTheme(theme) {
  if (theme == "system") {

    // 'data-' indicia um atributo destinado a armazenar informação
    // própria da apliaçaão, <html data-theme="dark"> é o estilo que
    // o css utiliza
    html.removeAttribute("data-theme");
    metaTag.setAttribute("content", "light dark");
    localStorage.removeItem("colorScheme");
    return;
  }

  html.setAttribute("data-theme", theme);
  metaTag.setAttribute("content", theme);

  // colorScheme é o primeiro elemento 
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

// -- GABARITO -- 
// HTML
// ├── color-scheme  → atributo HTML
// ├── data-theme    → atributo HTML personalizado
// └── content       → atributo HTML

// JavaScript
// ├── colorScheme   → nome de uma chave que você escolheu
// ├── querySelector → método
// ├── setAttribute  → método
// └── localStorage  → API/objeto do navegador
