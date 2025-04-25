export const sortImagesCallback = (itemsList, sortDirection, reorderMode) => {
    if (reorderMode === 'NAME') {
        itemsList.sort((a, b) => {
            const aName = a.mini_thumbnail_path.replace(/^.*\//, '');
            const bName = b.mini_thumbnail_path.replace(/^.*\//, '');

            return sortDirection
                ? aName.localeCompare(bName)
                : bName.localeCompare(aName);
        });
    } else {
        itemsList.sort((a, b) => {
            const aTime = new Date(a.creation_time.raw).getTime();
            const bTime = new Date(b.creation_time.raw).getTime();

            return sortDirection ? aTime - bTime : bTime - aTime;
        });
    }
};

export const sortAlbumsCallback = (itemsList, sortDirection, reorderMode) => {
    if (reorderMode === 'NAME') {
        itemsList.sort((a, b) => {
            const aName = a.name.toLowerCase();
            const bName = b.name.toLowerCase();

            return sortDirection
                ? aName.localeCompare(bName)
                : bName.localeCompare(aName);
        });
    } else {
        itemsList.sort((a, b) => {
            if (!sortDirection) {
                const yearDiff = a.year - b.year;
                if (!isNaN(yearDiff) && yearDiff !== 0) {
                    return yearDiff;
                }
                return a.id - b.id;
            }
            const yearDiff = b.year - a.year;
            if (!isNaN(yearDiff) && yearDiff !== 0) {
                return yearDiff;
            }
            return b.id - a.id;
        });
    }
};
