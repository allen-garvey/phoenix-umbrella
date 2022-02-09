export const ALBUM_FILTER_QUERY_PARAM_NAME = 'album-filter-mode';

export const PERSON_FILTER_QUERY_PARAM_NAME = 'person-filter-mode';

export const getPersonsInAlbum = (album, images) => {
    const personsMap = new Map();

    images.forEach((image) => {
        image.persons.forEach((person) => {
            personsMap.set(person.name, person);
        });
    });

    return [...personsMap.keys()].sort((a, b) => a.localeCompare(b)).map((name) => personsMap.get(name));
};

export const albumRelatedFields = [
    {
        name: 'tags',
        getItems(album, images){
            return album.tags.map(tag => ({
                name: tag.name,
                to: {
                    name: 'tagsShow',
                    params: { id: tag.id }
                },
            }));
        },
    },
    {
        name: 'persons',
        getItems(album, images){
            return getPersonsInAlbum(album, images).map(person => ({
                name: person.name,
                to: {
                    name: 'personsShow',
                    params: { id: person.id }
                },
            }))
        },
    }
];

export const sortImagesCallback = (itemsList, sortDirection, reorderMode) => {
    if(reorderMode === 'NAME'){
        itemsList.sort((a, b) => {
            const aName = a.master_path.replace(/^.*\//, '');
            const bName = b.master_path.replace(/^.*\//, '');
            
            if(aName === bName){
                return 0;
            }
            const isAGreater = aName > bName;
            return sortDirection && isAGreater || (!sortDirection && !isAGreater) ? 1 : -1;
        });
    }
    else {
        itemsList.sort((a, b) => {
            const aTime = new Date(a.creation_time.raw).getTime();
            const bTime = new Date(b.creation_time.raw).getTime();
            
            return sortDirection ? aTime - bTime : bTime - aTime;
        });
    }
    
};

export const sortAlbumsCallback = (itemsList, sortDirection, reorderMode) => {
    if(reorderMode === 'NAME'){
        itemsList.sort((a, b) => {
            const aName = a.name.toLowerCase();
            const bName = b.name.toLowerCase();

            if(aName === bName){
                return 0;
            }

            const isAGreater = aName > bName;
            return sortDirection && isAGreater || (!sortDirection && !isAGreater) ? 1 : -1;
        });
    }
    else {
        itemsList.sort((a, b) => {
            if(!sortDirection){
                const yearDiff = a.year - b.year;
                if(yearDiff !== 0){
                    return yearDiff;
                }
                return a.id - b.id;
            }
            const yearDiff = b.year - a.year;
            if(yearDiff !== 0){
                return yearDiff;
            }
            return b.id - a.id;
        });
    }
};