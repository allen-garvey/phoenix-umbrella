// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../../css/public.scss"

document.querySelectorAll('.menu_container .menu_title').forEach((caller)=>{
    caller.addEventListener('click', ()=>{
        const menuContainer = caller.parentElement;
        menuContainer.classList.toggle('active');

        //scroll to start of contents on mobile
        if(window.innerWidth <= 600 && menuContainer.classList.contains('active')){
            const menuContents = menuContainer.querySelector('.menu_contents');
            window.scrollTo(0, menuContents.offsetTop);
        }
    }); 
});