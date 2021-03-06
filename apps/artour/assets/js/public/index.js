// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../../css/main.scss"

import { initializeDisplayAlbumLightbox } from './display_album.js';
initializeDisplayAlbumLightbox();

import { initializeImageLazyLoading } from './lazy-load-images';
initializeImageLazyLoading();