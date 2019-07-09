export function isoFormattedDateToUs(isoDate, separator='/'){
    if(!isoDate){
        return '';
    }
    const dateSplit = isoDate.split('-');
    return `${dateSplit[1]}${separator}${dateSplit[2]}${separator}${dateSplit[0]}`;
}