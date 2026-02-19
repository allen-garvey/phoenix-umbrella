export const initializeSummaryTagsList = () => {
    const summaryTagsListContainerEl = document.getElementById(
        'summary_tags_list_container'
    );

    if (!summaryTagsListContainerEl) {
        return;
    }

    const checkboxes = summaryTagsListContainerEl.querySelectorAll(
        'input[type="checkbox"]'
    );

    document
        .getElementById('button_clear_all_tags')
        ?.addEventListener('click', () => {
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
        });

    document
        .getElementById('button_select_all_tags')
        ?.addEventListener('click', () => {
            checkboxes.forEach(checkbox => {
                checkbox.checked = true;
            });
        });
};
