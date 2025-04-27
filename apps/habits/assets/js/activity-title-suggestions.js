import { fetchJson } from 'umbrella-common-js/ajax.js';

export const initializeActivityTitleSuggestions = () => {
    const activityTitlesListEl = document.getElementById(
        'recent_activity_titles_list'
    );
    const activityCategoryIdEl = document.getElementById(
        'activity_category_id'
    );

    if (!activityTitlesListEl || !activityCategoryIdEl) {
        return;
    }

    const updateTitleSuggestions = () => {
        const categoryId = activityCategoryIdEl.value;
        activityTitlesListEl.textContent = '';

        fetchJson(`/api/categories/${categoryId}/activities/recent`).then(
            data => {
                const fragment = document.createDocumentFragment();

                for (let activity of data) {
                    const option = document.createElement('option');
                    option.value = activity.title;
                    fragment.appendChild(option);
                }
                activityTitlesListEl.appendChild(fragment);
            }
        );
    };

    activityCategoryIdEl.addEventListener('change', e => {
        updateTitleSuggestions();
    });

    updateTitleSuggestions();
};
