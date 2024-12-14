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
                item.tags.map(tag => ({
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
            return item.persons.map(person => ({
                name: person.name,
                to: {
                    name: 'personsShow',
                    params: { id: person.id },
                },
            }));
        },
    },
];

export const imageListRelatedFields = [
    {
        name: 'albums',
        getItems(model, itemsModel) {
            const albumsMap = new Map(
                model.flatMap(image =>
                    image.albums.map(album => [album.id, album.name])
                )
            );

            return Array.from(albumsMap)
                .sort(([aId, aName], [bId, bName]) =>
                    aName.localeCompare(bName)
                )
                .map(([id, name]) => ({
                    name,
                    to: {
                        name: 'albumsShow',
                        params: { id },
                    },
                }));
        },
    },
];

const itemsToRoutesList = (items, showRouteName) =>
    items.map(item => ({
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

export const getApiPathForTodaysImages = () => {
    const today = new Date();
    return `/images/date/${today.getMonth() + 1}/${today.getDate()}`;
};

export const todaysImagesTitle = 'On This Day';
