export const ALBUM_FILTER_QUERY_PARAM_NAME = 'item-filter-mode';

export const PERSON_FILTER_QUERY_PARAM_NAME = 'person-filter-mode';

export const albumRelatedFields = [
    {
        name: 'tags',
        getItems(item, images) {
            const year = [
                {
                    name: item.year,
                    to: {
                        name: 'albumsForYear',
                        params: { year: item.year },
                    },
                },
            ];

            return year.concat(
                item.tags.map((tag) => ({
                    name: tag.name,
                    to: {
                        name: 'tagsShow',
                        params: { id: tag.id },
                    },
                }))
            );
        },
    },
    {
        name: 'persons',
        getItems(item, images) {
            return item.persons.map((person) => ({
                name: person.name,
                to: {
                    name: 'personsShow',
                    params: { id: person.id },
                },
            }));
        },
    },
];

const itemsToRoutesList = (items, showRouteName) =>
    items.map((item) => ({
        name: item.name,
        to: {
            name: showRouteName,
            params: { id: item.id },
        },
    }));

export const importRelatedFields = [
    {
        name: 'albums',
        getItems(importModel, images) {
            return itemsToRoutesList(importModel.albums, 'albumsShow');
        },
    },
    {
        name: 'persons',
        getItems(importModel, images) {
            return itemsToRoutesList(importModel.persons, 'personsShow');
        },
    },
];

export const sortImagesCallback = (itemsList, sortDirection, reorderMode) => {
    if (reorderMode === 'NAME') {
        itemsList.sort((a, b) => {
            const aName = a.mini_thumbnail_path.replace(/^.*\//, '');
            const bName = b.mini_thumbnail_path.replace(/^.*\//, '');

            if (aName === bName) {
                return 0;
            }
            const isAGreater = aName > bName;
            return (sortDirection && isAGreater) ||
                (!sortDirection && !isAGreater)
                ? 1
                : -1;
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

            if (aName === bName) {
                return 0;
            }

            const isAGreater = aName > bName;
            return (sortDirection && isAGreater) ||
                (!sortDirection && !isAGreater)
                ? 1
                : -1;
        });
    } else {
        itemsList.sort((a, b) => {
            if (!sortDirection) {
                const yearDiff = a.year - b.year;
                if (yearDiff !== 0) {
                    return yearDiff;
                }
                return a.id - b.id;
            }
            const yearDiff = b.year - a.year;
            if (yearDiff !== 0) {
                return yearDiff;
            }
            return b.id - a.id;
        });
    }
};
