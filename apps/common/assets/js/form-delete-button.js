/*
 * Used in edit form to delete items
 */

import { addListener } from './events.js';

export const initializeFormDeleteButton = () => {
    addListener("[data-button='delete']", 'click', (event, element) => {
        event.preventDefault();
        const deleteForm = document.querySelector("[data-form='delete']");
        if (
            !deleteForm ||
            !window.confirm('Are you sure you want to delete this item?')
        ) {
            return;
        }
        deleteForm.submit();
    });
};
