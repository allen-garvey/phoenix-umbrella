export const disableMultipleFormSubmit = () => {
    document.querySelectorAll('form').forEach(form => {
        let hasSubmitted = false;
        form.addEventListener('submit', e => {
            if (hasSubmitted) {
                e.preventDefault();
            } else {
                hasSubmitted = true;
            }
        });
    });
};
