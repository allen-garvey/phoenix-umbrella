export const getTodaysDate = () => {
    // based on: https://stackoverflow.com/questions/23593052/format-javascript-date-as-yyyy-mm-dd
    const now = new Date();
    const timezoneOffset = now.getTimezoneOffset();
    return new Date(now.getTime() - timezoneOffset * 60 * 1000);
};

// takes date string in format yyyy-mm-dd and returns date object
// adds timestamp to fix bug where date is not parsed correctly
// https://stackoverflow.com/questions/2488313/javascripts-getdate-returns-wrong-date
export const dateFromIso = (dateString) => new Date(`${dateString}T00:00:00`);

// takes Javascript date and returns string in yyyy-mm-dd format
// can't use toISOString since returns wrong values around midnight due to time zones
export const formatDate = (date) =>
    `${date.getFullYear()}-${(date.getMonth() + 1)
        .toString()
        .padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;

export const monthNames = () => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
];

export const monthName = (monthNum) => monthName()[monthNum];
