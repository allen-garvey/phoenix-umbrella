export const initializeYesterdayButton = () => {
    const yesterdayButton = document.querySelector('[data-button="yesterday"]');
    if (!yesterdayButton) {
        return;
    }
    const dateInput = yesterdayButton
        .closest('form')
        .querySelector('input[type="date"]');

    const dateYesterday = new Date();
    dateYesterday.setDate(dateYesterday.getDate() - 1);

    yesterdayButton.onclick = () => {
        dateInput.value = dateYesterday.toISOString().split('T')[0];
    };
};
