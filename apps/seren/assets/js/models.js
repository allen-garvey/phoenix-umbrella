import { fetchJson } from 'umbrella-common-js/ajax.js';
import Util from './util';
import { API_URL_BASE } from './api-helpers';

//item columns for tracks
function getTrackItemColumns() {
    return [
        { title: 'Title', sort: 'title' },
        { title: 'Artist', sort: 'artist' },
        { title: 'Album', sort: 'album_title' },
        { title: 'Length', sort: 'length' },
        { title: 'Genre', sort: 'genre' },
        { title: 'Composer', sort: 'composer' },
        { title: 'Bit Rate', sort: 'bit_rate' },
        { title: 'Play Count', sort: 'play_count' },
        { title: 'Date Added', sort: 'date_added' },
    ];
}

//item columns for everything except tracks and albums
function getDefaultItemColumns() {
    return [{ title: 'Name', sort: 'name' }];
}

function getAlbumItemColumns() {
    return [
        { title: 'Title', sort: 'title' },
        { title: 'Artist', sort: 'artist' },
    ];
}

function defaultItemFields(item) {
    return [item.name];
}

function albumItemFields(album) {
    return [album.title, this.artistsMap.get(album.artist_id).name];
}

function trackItemFields(track) {
    const genre =
        track.genre_id !== null ? this.genresMap.get(track.genre_id).name : '';
    const composer =
        track.composer_id !== null
            ? this.composersMap.get(track.composer_id).name
            : '';
    const albumTitle =
        track.album_id !== null ? this.albumsMap.get(track.album_id).title : '';
    return [
        track.title,
        this.artistsMap.get(track.artist_id).name,
        albumTitle,
        Util.formatTrackLength(track.length),
        genre,
        composer,
        track.bit_rate,
        track.play_count,
        Util.formatUtcDateToUs(track.date_added),
    ];
}

function sortItems(items, sortKey, sortAsc, relatedFields) {
    function getRelatedFieldValueBuilder(
        itemKey,
        relatedFieldIdMap,
        relatedFieldKey = 'name'
    ) {
        return item => {
            //relatedFieldId might be null
            const relatedFieldId = item[itemKey];
            return Util.isEmpty(relatedFieldId)
                ? null
                : relatedFieldIdMap.get(relatedFieldId)[relatedFieldKey];
        };
    }

    const getValueByKey = item => {
        return item[sortKey];
    };
    let itemValueFunc;
    switch (sortKey) {
        case 'artist':
            itemValueFunc = getRelatedFieldValueBuilder(
                'artist_id',
                relatedFields.artists
            );
            break;
        case 'composer':
            itemValueFunc = getRelatedFieldValueBuilder(
                'composer_id',
                relatedFields.composers
            );
            break;
        case 'genre':
            itemValueFunc = getRelatedFieldValueBuilder(
                'genre_id',
                relatedFields.genres
            );
            break;
        default:
            itemValueFunc = getValueByKey;
            break;
    }

    return items.sort((a, b) => {
        let value1;
        let value2;
        if (!sortAsc) {
            value1 = itemValueFunc(b);
            value2 = itemValueFunc(a);
        } else {
            value1 = itemValueFunc(a);
            value2 = itemValueFunc(b);
        }
        if (Util.isEmpty(value1)) {
            if (Util.isEmpty(value2)) {
                return 0;
            }
            return -1;
        } else if (Util.isEmpty(value2)) {
            return 1;
        }
        if (typeof value1 === 'number') {
            return value1 - value2;
        }
        if (typeof value1 === 'string') {
            value1 = value1.toUpperCase();
            value2 = value2.toUpperCase();
        }
        if (value1 > value2) {
            return 1;
        } else if (value1 < value2) {
            return -1;
        }
        return 0;
    });
}

function loadModelAndMap(modelName, target, itemsMap) {
    const url = `${API_URL_BASE}/${modelName}`;
    return fetchJson(url).then(items => {
        target[modelName] = items;

        items.forEach(item => {
            itemsMap.set(item.id, item);
        });
    });
}

export default {
    trackItemColumns: getTrackItemColumns(),
    defaultItemColumns: getDefaultItemColumns(),
    albumItemColumns: getAlbumItemColumns(),
    defaultItemFields,
    albumItemFields,
    trackItemFields,
    sortItems,
    loadModelAndMap,
};
