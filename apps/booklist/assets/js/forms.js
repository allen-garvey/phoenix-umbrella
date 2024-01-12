export const initializeTitleSplitButton = () => {
    const button = document.querySelector('[data-button="split-title"]');
    if (!button) {
        return;
    }

    button.onclick = () => {
        const titleEl = document.getElementById('book_title');
        const subtitleEl = document.getElementById('book_subtitle');

        const titleSplit = titleEl.value.split(':');
        const title = titleSplit[0];

        titleEl.value = title;
        if (titleSplit.length > 1) {
            subtitleEl.value = titleSplit[1].replace(/^\s+/, '');
        }
    };
};
