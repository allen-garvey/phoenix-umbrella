export const initializeTitleInputSplit = () => {
    const titleEl = document.getElementById('book_title');
    if (!titleEl) {
        return;
    }

    const subtitleEl = document.getElementById('book_subtitle');
    let previousTitle = '';

    titleEl.onblur = (e) => {
        const titleRaw = e.target.value;
        if (!previousTitle) {
            const titleSplit = titleRaw.split(':');
            const title = titleSplit[0];

            titleEl.value = title;
            if (titleSplit.length > 1) {
                subtitleEl.value = titleSplit[1].replace(/^\s+/, '');
            }
        }
        previousTitle = titleRaw;
    };
};
