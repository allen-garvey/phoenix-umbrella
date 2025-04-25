import getPageRoutes from './routes/pages';
import getAlbumRoutes from './routes/albums';
import getClanRoutes from './routes/clans';
import getImageRoutes from './routes/images';
import getImportsRoutes from './routes/imports';
import getPersonRoutes from './routes/persons';
import getResourceImageDetailRoutes from './routes/resource-image-details';
import getSlideshowRoutes from './routes/slideshows';
import getTagsRoutes from './routes/tags';

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
