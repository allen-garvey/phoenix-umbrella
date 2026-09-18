import path from 'path';
import webpack from 'webpack';

import { VueLoaderPlugin } from 'vue-loader';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';

import pathHelpers from './path.js';
import { generateFaviconsPlugin } from './generate-favicons-plugin.js';

export default {
    mode: 'development',
    entry: {
        habits: pathHelpers.defaultEntrypointForApp('habits'),
        pluginista: pathHelpers.defaultEntrypointForApp('pluginista'),
        photog: pathHelpers.defaultEntrypointForApp('photog'),
        seren: pathHelpers.defaultEntrypointForApp('seren'),
        booklist: pathHelpers.defaultEntrypointForApp('booklist'),
        bookmarker: pathHelpers.defaultEntrypointForApp('bookmarker'),
        movielist: pathHelpers.defaultEntrypointForApp('movielist'),
        grenadier: `${
            import.meta.dirname
        }/../apps/grenadier/assets/grenadier/js/index.js`,
        supersearch_admin: `${
            import.meta.dirname
        }/../apps/grenadier/assets/supersearch/admin/js/index.js`,
        supersearch_public: `${
            import.meta.dirname
        }/../apps/grenadier/assets/supersearch/public/app.scss`,
        blockquote: pathHelpers.defaultEntrypointForApp('blockquote'),
        artour_admin: `${
            import.meta.dirname
        }/../apps/artour/assets/js/admin/index.js`,
        artour_public: `${
            import.meta.dirname
        }/../apps/artour/assets/js/public/index.js`,
        startpage_admin: `${
            import.meta.dirname
        }/../apps/startpage/assets/js/admin/index.js`,
        startpage_public: `${
            import.meta.dirname
        }/../apps/startpage/assets/js/public/index.js`,
    },
    output: {
        path: path.join(import.meta.dirname, '..', 'apps'),
        // for dynamic imports
        chunkFilename: ({ chunk }) => {
            return `assets/${chunk.name}.js`;
        },
        filename: ({ chunk }) => {
            return pathHelpers.outputPathForApp(chunk.name, 'js', chunk.hash);
        },
    },
    resolve: {
        alias: {
            'umbrella-common-js': path.resolve(
                import.meta.dirname,
                '../apps/common/assets/js/'
            ),
            'umbrella-common-styles': path.resolve(
                import.meta.dirname,
                '../apps/common/assets/css/'
            ),
            'bootstrap-custom': path.resolve(
                import.meta.dirname,
                '../apps/common/assets/css/lib/bootstrap/scss'
            ),
            bootstrap: path.resolve(
                import.meta.dirname,
                '../node_modules/bootstrap/scss'
            ),
            'photog-styles': path.resolve(
                import.meta.dirname,
                '../apps/photog/assets/sass/'
            ),
            'seren-styles': path.resolve(
                import.meta.dirname,
                '../apps/seren/assets/sass/'
            ),
        },
    },
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader',
            },
            {
                test: /\.scss$/,
                oneOf: [
                    // this matches `<style module>`
                    {
                        resourceQuery: /module/,
                        use: [
                            'vue-style-loader',
                            {
                                loader: 'css-loader',
                                options: {
                                    url: false,
                                    esModule: false,
                                    modules: {
                                        localIdentName:
                                            '[local]_[hash:base64:8]',
                                    },
                                },
                            },
                            {
                                loader: 'sass-loader',
                            },
                        ],
                    },
                    {
                        use: [
                            'vue-style-loader',
                            {
                                loader: MiniCssExtractPlugin.loader,
                                options: {
                                    esModule: false,
                                },
                            },
                            {
                                loader: 'css-loader',
                                options: {
                                    url: false,
                                    esModule: false,
                                },
                            },
                            'sass-loader',
                        ],
                    },
                ],
            },
        ],
    },
    plugins: [
        new VueLoaderPlugin(),
        new MiniCssExtractPlugin({
            filename: ({ chunk }) => {
                return pathHelpers.outputPathForApp(chunk.name, 'css');
            },
        }),
        generateFaviconsPlugin([
            'artour',
            'blockquote',
            'booklist',
            'bookmarker',
            'grenadier',
            'movielist',
            'photog',
            'seren',
            'startpage',
        ]),
        new webpack.DefinePlugin({
            __VUE_OPTIONS_API__: true,
            __VUE_PROD_DEVTOOLS__: false,
            __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: false,
        }),
    ],
};
