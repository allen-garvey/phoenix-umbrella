export const initializeYesterdayButton = () => {
    const yesterdayButton = document.querySelector('[data-button="yesterday"]');
    if (!yesterdayButton) {
        return;
    }
    const dateInput = yesterdayButton
        .closest('[data-date-input-group]')
        .querySelector('input[type="date"]');

    yesterdayButton.onclick = () => {
        const dateYesterday = new Date();
        dateYesterday.setDate(dateYesterday.getDate() - 1);
        dateInput.value = dateYesterday.toISOString().split('T')[0];
    };
};
