export const getApiPathForTodaysImages = () => {
    const today = new Date();
    return `/images/date/${today.getMonth() + 1}/${today.getDate()}`;
};

export const todaysImagesTitle = 'On This Day';
