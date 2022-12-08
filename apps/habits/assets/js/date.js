export const getTodaysDate = () => {
    // based on: https://stackoverflow.com/questions/23593052/format-javascript-date-as-yyyy-mm-dd
    const now = new Date();
    const timezoneOffset = now.getTimezoneOffset();
    return new Date(now.getTime() - (timezoneOffset*60*1000));
};

// get the sunday before the first of the month
export const getMonthSunday = (date) => {
    const firstDay = new Date(date.getTime());
    firstDay.setDate(1);
    const dayOfWeek = firstDay.getDay();
    firstDay.setDate(firstDay.getDate() - dayOfWeek);
    
    return firstDay;
};

// takes Javascript date and returns string in yyyy-mm-dd format
// based on: https://stackoverflow.com/questions/23593052/format-javascript-date-as-yyyy-mm-dd
export const formatDate = (date) => date.toISOString().split('T')[0];

export const monthName = (monthNum) => 
    ['January', 'February', 'March', 'April', 'May', 'June',
'July', 'August', 'September', 'October', 'November', 'December'
][monthNum];