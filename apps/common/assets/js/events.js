export const addListener = (selector, eventName, callback) => {
    document.querySelectorAll(selector).forEach((element) => {
        element.addEventListener(
            eventName,
            (e) => {
                callback(e, element);
            },
            false
        );
    });
};
