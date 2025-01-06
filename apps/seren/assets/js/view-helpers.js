/**
 *
 * @param {number} trackLength
 * @returns {string}
 */
export const formatTrackLength = trackLength => {
    const totalSeconds = Math.floor(trackLength / 1000);
    const minutes = Math.floor(totalSeconds / 60) % 60;
    const hours = Math.floor(minutes / 60);
    const seconds = `${totalSeconds % 60}`.padStart(2, '0');

    if (hours > 0) {
        return `${hours}:${`${minutes}`.padStart(2, '0')}:${seconds}`;
    }
    return `${minutes}:${seconds}`;
};

/**
 *
 * @param {string} date
 * @returns {string}
 */
export const formatUtcDateToUs = date => {
    if (!date) {
        return date;
    }
    const dateSplit = date.split('-');
    return `${dateSplit[1]}/${dateSplit[2]}/${dateSplit[0]}`;
};
