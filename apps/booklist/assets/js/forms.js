/**
 *
 * @param {string} titleRaw
 * @returns {string[]}
 */
export const splitTitle = titleRaw => {
    const lastColonIndex = titleRaw.lastIndexOf(':');
    if (lastColonIndex === -1 || lastColonIndex === titleRaw.length - 1) {
        return [titleRaw, ''];
    }
    return [
        titleRaw.slice(0, lastColonIndex),
        titleRaw.slice(lastColonIndex + 1).trimStart(),
    ];
};

export const initializeTitleInputSplit = () => {
    const titleEl = document.getElementById('book_title');
    if (!titleEl) {
        return;
    }

    const subtitleEl = document.getElementById('book_subtitle');

    titleEl.onblur = e => {
        const titleRaw = e.target.value;
        if (!subtitleEl.value) {
            const [title, subtitle] = splitTitle(titleRaw);
            titleEl.value = title;
            subtitleEl.value = subtitle;
        }
    };
};
