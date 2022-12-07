export const getTodaysDate = () => {
    // based on: https://stackoverflow.com/questions/23593052/format-javascript-date-as-yyyy-mm-dd
    const now = new Date();
    const timezoneOffset = now.getTimezoneOffset();
    return new Date(now.getTime() - (timezoneOffset*60*1000));
};

// returns the date n weeks ago from given date
// the returned date is always the sunday 
export const getPastSundayFromDate = (date, weeksAgo) => {
    const dayOfWeek = date.getDay();
    const daysAgo = weeksAgo * 7 + dayOfWeek;

    const pastDate = new Date();
    pastDate.setDate(date.getDate() - daysAgo);
    
    return pastDate;
};

// takes Javascript date and returns string in yyyy-mm-dd format
// based on: https://stackoverflow.com/questions/23593052/format-javascript-date-as-yyyy-mm-dd
export const formatDate = (date) => date.toISOString().split('T')[0];