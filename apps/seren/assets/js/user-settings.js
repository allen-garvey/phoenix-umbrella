const VOLUME_SETTING_KEY = 'SEREN_USER_VOLUME';
let volumeTimeout = null;

export const getUserVolume = () => {
    const volume = parseFloat(localStorage.getItem(VOLUME_SETTING_KEY));

    if (isNaN(volume)) {
        return 1;
    }

    return Math.max(Math.min(volume, 1), 0);
};

export const saveUserVolume = volume => {
    clearTimeout(volumeTimeout);

    volumeTimeout = setTimeout(() => {
        localStorage.setItem(VOLUME_SETTING_KEY, volume);
    }, 1000);
};
