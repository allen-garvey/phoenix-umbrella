import { fetchJson } from 'umbrella-common-js/ajax.js';

export const initializeActivityFormLoadTags = () => {
    const tagSelectEl = document.querySelector('[data-id="activity_tag_id"]');
    const categorySelectEl = document.querySelector(
        '[data-id="activity_category_id"]'
    );

    if (!tagSelectEl || !categorySelectEl) {
        return;
    }

    const updateTagSelect = () => {
        const categoryId = categorySelectEl.value;
        tagSelectEl.replaceChildren();

        fetchJson(`/api/categories/${categoryId}/tags`).then(data => {
            const fragment = document.createDocumentFragment();

            for (let tag of data) {
                const option = document.createElement('option');
                option.value = tag.id;
                option.textContent = tag.name;
                fragment.appendChild(option);
            }
            tagSelectEl.appendChild(fragment);
        });
    };

    categorySelectEl.addEventListener('change', e => {
        updateTagSelect();
    });
};
