// Ouve o carregamento do DOM para ter certeza que o HTML já existe antes do JS rodar
document.addEventListener('DOMContentLoaded', () => {

    // ── Elementos do modal (inalterados) ─────────────────────────────────────

    let scrollPosition = 0;
    const modal        = document.getElementById('photo-modal');
    const btnClose     = document.getElementById('close-modal');
    const modalImage   = document.getElementById('modal-image');
    const metaDate     = document.getElementById('meta-date');
    const metaSensor   = document.getElementById('meta-sensor');
    const metaAperture = document.getElementById('meta-aperture');
    const metaSize     = document.getElementById('meta-size');

    // O grid agora é populado via JS — o HTML entrega só o <ul> vazio
    const photoGrid = document.querySelector('.photo-grid');


    // ── Formatação de dados brutos do JSON ────────────────────────────────────

    // Converte "YYYY-MM-DD" (ISO 8601) para "DD Mês, YYYY" em pt-BR
    function formatDate(isoDate) {
        if (!isoDate) return '—';
        const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
        const [year, month, day] = isoDate.split('-');
        return `${day} ${months[parseInt(month, 10) - 1]}, ${year}`;
    }

    // Converte size_bytes (inteiro) para "X.X MB"
    function formatSize(bytes) {
        if (!bytes) return '—';
        return (bytes / 1048576).toFixed(1) + ' MB';
    }

    // Combina make + model; evita repetição quando o model já inclui o make
    // ex: make="Xiaomi", model="Xiaomi Mi A3" → "Xiaomi Mi A3" (não "Xiaomi Xiaomi Mi A3")
    function formatSensor(make, model) {
        if (!make && !model) return '—';
        if (!make)  return model;
        if (!model) return make;
        if (model.startsWith(make)) return model;
        return `${make} ${model}`;
    }

    // Texto alternativo da imagem para acessibilidade
    function photoAlt(photo) {
        if (photo.date) return `Foto de ${photo.date.slice(0, 4)}`;
        return 'Foto sem data';
    }


    // ── Construção do elemento de foto ────────────────────────────────────────

    // Cria um <li> completo para cada registro do photos.json.
    // Os dados vêm do objeto photo diretamente — sem data-* attributes no HTML.
    // A referência ao btn é capturada pelo closure do addEventListener abaixo,
    // o que permite alterar o visual do botão específico que foi clicado.
    function createPhotoItem(photo) {
        const fullSrc = `images/${photo.filename}`;
        const miniSrc = `images/mini/${photo.filename}`;

        const li          = document.createElement('li');
        const btn         = document.createElement('button');
        const figure      = document.createElement('figure');
        const img         = document.createElement('img');
        const figcaption  = document.createElement('figcaption');

        btn.className        = 'photo-btn';
        img.src              = miniSrc;
        img.alt              = photoAlt(photo);
        img.loading          = 'lazy';
        figcaption.textContent = formatDate(photo.date);

        figure.append(img, figcaption);
        btn.appendChild(figure);
        li.appendChild(btn);

        btn.addEventListener('click', () => {

            // Feedback visual: botão fica opaco e cursor muda enquanto baixa a imagem
            btn.style.opacity = '0.5';
            document.body.style.cursor = 'wait';

            // Imagem "fantasma" força o browser a baixar a imagem real em background
            // antes de abrir o modal — elimina o tranco de redimensionamento
            const preloadImg = new Image();

            preloadImg.onload = () => {
                btn.style.opacity = '1';
                document.body.style.cursor = 'default';

                modalImage.src             = fullSrc;
                metaDate.textContent       = formatDate(photo.date);
                metaSensor.textContent     = formatSensor(photo.make, photo.model);
                metaAperture.textContent   = photo.aperture ?? '—';
                metaSize.textContent       = formatSize(photo.size_bytes);

                scrollPosition = window.scrollY;
                modal.showModal();
            };

            preloadImg.onerror = () => {
                btn.style.opacity = '1';
                document.body.style.cursor = 'default';
                console.error('Erro ao carregar imagem:', fullSrc);
            };

            preloadImg.src = fullSrc;
        });

        return li;
    }


    // ── Carregamento do JSON e renderização do grid ───────────────────────────

    // fetch é a forma nativa do browser de buscar recursos — sem biblioteca.
    // DocumentFragment acumula todos os <li> antes de inserir no DOM,
    // evitando um reflow a cada elemento adicionado.
    fetch('images/photos.json')
        .then(response => {
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return response.json();
        })
        .then(photos => {
            const fragment = document.createDocumentFragment();
            photos.forEach(photo => fragment.appendChild(createPhotoItem(photo)));
            photoGrid.appendChild(fragment);
        })
        .catch(err => {
            console.error('Erro ao carregar photos.json:', err);
            photoGrid.innerHTML = '<li style="padding:1em">Erro ao carregar as fotos.</li>';
        });


    // ── Modal: fechar ─────────────────────────────────────────────────────────

    btnClose.addEventListener('click', () => {
        modal.close();
        window.scrollTo(0, scrollPosition);
    });

    // Fechar clicando fora do conteúdo do modal (no backdrop)
    modal.addEventListener('click', event => {
        if (event.target === modal) {
            modal.close();
            window.scrollTo(0, scrollPosition);
        }
    });

});
