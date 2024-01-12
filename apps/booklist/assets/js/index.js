// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.scss';

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
// import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import { initializeDeleteModals } from './delete-modals.js';
import { initializeQRCodeButtons } from './qr-code-modal.js';
import { initializeBooksPerWeekChart } from './reports/books-per-week-chart';
import { initializeYesterdayButton } from 'umbrella-common-js/date-input.js';
import { initializeTitleSplitButton } from './forms.js';

initializeDeleteModals();
initializeQRCodeButtons();
initializeBooksPerWeekChart();
initializeYesterdayButton();
initializeTitleSplitButton();
