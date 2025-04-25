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
