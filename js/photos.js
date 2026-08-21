// Ouve o carregamento do DOM para ter certeza que o HTML já existe antes do JS rodar
document.addEventListener('DOMContentLoaded', () => {
    
    // 1. Captura os elementos principais que vamos manipular
    let scrollPosition = 0;
    const modal = document.getElementById('photo-modal');
    const btnClose = document.getElementById('close-modal');
    const modalImage = document.getElementById('modal-image');
    
    // 2. Captura os elementos de texto onde colocaremos os metadados
    const metaDate = document.getElementById('meta-date');
    const metaSensor = document.getElementById('meta-sensor');
    const metaAperture = document.getElementById('meta-aperture');
    const metaSize = document.getElementById('meta-size');

    // 3. Captura todos os botões (as miniaturas das fotos)
    const photoButtons = document.querySelectorAll('.photo-btn');

    // 4. Para cada botão de foto, adicionamos a ação de "clique"
    photoButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            
            // Lemos os atributos data-* que nós escrevemos no HTML
            const fullSrc = btn.getAttribute('data-full-src');
            const date = btn.getAttribute('data-date');
            const sensor = btn.getAttribute('data-sensor');
            const aperture = btn.getAttribute('data-aperture');
            const size = btn.getAttribute('data-size');

            // Feedback visual: O botão fica meio transparente e o cursor muda 
            // indicando pro usuário que a foto está baixando
            btn.style.opacity = '0.5';
            document.body.style.cursor = 'wait';

            // Truque de polimento: criamos uma imagem "fantasma" na memória
            // Isso força o navegador a fazer o download da imagem em background
            const preloadImg = new Image();
            
            // Dispara assim que a imagem terminar de baixar
            preloadImg.onload = () => {
                // Restauramos o visual do botão e do cursor
                btn.style.opacity = '1';
                document.body.style.cursor = 'default';

                // Agora injetamos a imagem carregada no Modal
                modalImage.src = fullSrc;
                metaDate.textContent = date;
                metaSensor.textContent = sensor;
                metaAperture.textContent = aperture;
                metaSize.textContent = size;

                // Ao abrir o modal agora, a imagem já está no cache do navegador.
                // Isso elimina o tranco/travada de redimensionamento abrindo o modal polido.
                scrollPosition = window.scrollY;
                modal.showModal();
            };

            // Boa prática: e se a foto não existir ou a internet cair?
            preloadImg.onerror = () => {
                btn.style.opacity = '1';
                document.body.style.cursor = 'default';
                console.error("Error loading the original image.");
            };

            // Mandamos o navegador começar a baixar a imagem real
            preloadImg.src = fullSrc;
        });
    });

    btnClose.addEventListener('click', () => {
        modal.close();
        window.scrollTo(0, scrollPosition);
    });

    // fechar o modal clicando fora dele
    modal.addEventListener('click', (event) => {
        // Se o elemento clicado for estritamente o próprio dialog (que funciona como a área do backdrop)
        if (event.target === modal) {
            modal.close();
            window.scrollTo(0, scrollPosition);
        }
    });

});
