export const disableMultipleFormSubmit = () => {
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', () => {
            form.querySelectorAll(
                'input[type="submit"], button[type="submit"]'
            ).forEach(button => {
                button.disabled = true;
            });
        });
    });
};
