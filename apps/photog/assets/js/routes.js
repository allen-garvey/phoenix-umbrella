import getPageRoutes from './routes/pages.js';
import getAlbumRoutes from './routes/albums.js';
import getClanRoutes from './routes/clans.js';
import getImageRoutes from './routes/images.js';
import getImportsRoutes from './routes/imports.js';
import getPersonRoutes from './routes/persons.js';
import getResourceImageDetailRoutes from './routes/resource-image-details.js';
import getSlideshowRoutes from './routes/slideshows.js';
import getTagsRoutes from './routes/tags.js';

export default {
    routes: getPageRoutes().concat(
        getAlbumRoutes(),
        getClanRoutes(),
        getImageRoutes(),
        getImportsRoutes(),
        getPersonRoutes(),
        getResourceImageDetailRoutes(),
        getSlideshowRoutes(),
        getTagsRoutes()
    ),
};
