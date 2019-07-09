//based on: https://stackoverflow.com/questions/10073699/pad-a-number-with-leading-zeros-in-javascript
function padNumber(n, width, z) {
	z = z || '0';
	n = n + '';
	return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function isEmpty(value){
	return value === null || value === undefined;
}

function formatUtcDateToUs(date){
	if(!date){
		return date;
	}
	const dateSplit = date.split('-');
	return `${dateSplit[1]}/${dateSplit[2]}/${dateSplit[0]}`;
}

function formatTrackLength(trackLength){
    const totalSeconds = Math.floor(trackLength / 1000);
    let hours = 0;
    let minutes = Math.floor(totalSeconds / 60);
    if(minutes > 59){
        hours = Math.floor(minutes / 60);
        minutes = minutes % 60;
    }
    let seconds = totalSeconds % 60;
    if(hours > 0){
        return `${hours}:${padNumber(minutes, 2)}:${padNumber(seconds, 2)}`;
    }
    return `${minutes}:${padNumber(seconds, 2)}`;
}

export default {
    isEmpty,
    formatUtcDateToUs,
    formatTrackLength,
};