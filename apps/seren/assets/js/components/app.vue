<template>
    <div class="app-container">
        <search-bar :initialValue="searchQuery"> </search-bar>
        <Nav-Tabs :search-query="searchQuery" />
        <router-view
            v-if="isInitialLoadComplete"
            :load-more-tracks="loadMoreTracks"
            :is-track-playing="isTrackPlaying"
            :play-track="playTrack"
            :stop-track="stop"
            :get-items="getItems"
            :artists-map="artistsMap"
            :albums-map="albumsMap"
            :composers-map="composersMap"
        />
        <Media-Controls
            :elapsed-time="elapsedTime"
            :is-playing="isPlaying"
            :is-initial-load-complete="isInitialLoadComplete"
            :has-active-track="hasActiveTrack"
            :has-previous-track="hasPreviousTrack"
            :has-next-track="hasNextTrack"
            :artists-map="artistsMap"
            :active-track="activeTrack"
            :play-next-track="playNextTrack"
            :play-button-action="playButtonAction"
            :previous-button-action="previousButtonAction"
            :audio-volume="audioVolume"
            @volume-changed="adjustVolume"
        />
    </div>
</template>

<script>
import SearchBar from './search-bar.vue';
import NavTabs from './nav-tabs.vue';
import MediaControls from './media-controls.vue';

import { loadModelAndMap } from '../models';
import { fetchJson } from 'umbrella-common-js/ajax.js';
import { API_URL_BASE } from '../api-helpers';
import { getUserVolume, saveUserVolume } from '../user-settings';

let audio = null;

export default {
    components: {
        SearchBar,
        NavTabs,
        MediaControls,
    },
    created() {
        audio = new Audio();
        audio.volume = this.audioVolume;
        audio.addEventListener('ended', () => {
            if (this.hasNextTrack) {
                this.playNextTrack();
            } else {
                this.displayTrackStopped();
            }
        });
        audio.addEventListener('timeupdate', e => {
            this.elapsedTime = Math.floor(e.target.currentTime * 1000);
        });

        Promise.all([
            loadModelAndMap('artists', this, this.artistsMap),
            loadModelAndMap('composers', this, this.composersMap),
            loadModelAndMap('albums', this, this.albumsMap),
            this.loadMoreTracks(),
        ]).then(() => {
            this.isInitialLoadComplete = true;
        });
    },
    data() {
        return {
            audioVolume: getUserVolume(),
            tracks: [],
            artists: [],
            albums: [],
            composers: [],
            artistsMap: new Map(),
            albumsMap: new Map(),
            composersMap: new Map(),
            displayTracks: [],
            //activeTrackTrackList: the track list when the currently playing track started playing
            //this is so that when pages are changed, the correct next track will play
            activeTrackTrackList: [],
            //initializing activeTrack to empty objects simplifies logic since we can reduce null checks
            activeTrack: {
                track: {},
            },
            isPlaying: false,
            elapsedTime: 0,
            searchQuery: '',
            searchResults: [],
            savedSearchResultsQuery: '',
            isInitialLoadComplete: false,
        };
    },
    computed: {
        hasActiveTrack() {
            return 'id' in this.activeTrack.track;
        },
        hasPreviousTrack() {
            return this.hasActiveTrack && this.activeTrack.index > 0;
        },
        hasNextTrack() {
            return (
                this.hasActiveTrack &&
                this.activeTrack.index < this.activeTrackTrackList.length - 1
            );
        },
    },
    methods: {
        getItems(key) {
            if (typeof key === 'object') {
                const apiUrl = `${API_URL_BASE}/${key.apiPath}`;
                return fetchJson(apiUrl);
            }

            if (key === 'searchTracks') {
                const searchQuery = this.$route.query.q;
                if (
                    !searchQuery ||
                    this.savedSearchResultsQuery === searchQuery
                ) {
                    const searchResults = !searchQuery
                        ? []
                        : this.searchResults;
                    return Promise.resolve(searchResults);
                }
                const searchUrl = `${API_URL_BASE}/search/tracks?q=${encodeURIComponent(
                    searchQuery
                )}`;
                return fetchJson(searchUrl).then(searchResults => {
                    this.searchResults = searchResults;
                    this.savedSearchResultsQuery = searchQuery;
                    this.searchQuery = searchQuery;
                    return this.searchResults;
                });
            }
            return Promise.resolve(this[key]);
        },
        loadMoreTracks() {
            const offset = this.tracks ? this.tracks.length : false;

            let url = `${API_URL_BASE}/tracks?limit=100`;
            if (offset) {
                url = `${url}&offset=${offset}`;
            }
            return fetchJson(url).then(tracks => {
                if (offset) {
                    this.tracks = this.tracks.concat(tracks);
                } else {
                    this.tracks = tracks;
                }
            });
        },
        isTrackPlaying(track) {
            return (
                this.isPlaying &&
                this.hasActiveTrack &&
                track.id === this.activeTrack.track.id
            );
        },
        playTrack(track, trackIndex, items) {
            this.play(track, trackIndex, this.$route.path, items);
        },
        play(track, trackIndex, trackPath, items) {
            if (this.activeTrack.path !== trackPath) {
                //if we are on tracks page, we only want to reference the tracks,
                //otherwise we want to copy it
                if (this.$route.name === 'tracksIndex') {
                    this.activeTrackTrackList = this.tracks;
                } else {
                    this.activeTrackTrackList = items.slice();
                }
            }
            if (this.activeTrack.track.id !== track.id) {
                this.activeTrack = {
                    track,
                    path: trackPath,
                    index: trackIndex,
                };
                this.isPlaying = true;
                this.elapsedTime = 0;
                // const mediaUrl = '/media/' + encodeURI(track.file_path).replace('#', '%23').replace('?', '%3F');
                //quick fix for bad encoding of non-ascii characters in file paths
                //example sql query to get all bad file paths: select title, file_path from tracks where file_path ~ '[^[:ascii:]]';
                const mediaUrl =
                    '/media/' +
                    encodeURI(
                        track.file_path
                            .replace(/é/g, 'é')
                            .replace(/ö/g, 'ö')
                            .replace(/è/g, 'è')
                            .replace(/ř/g, 'ř')
                            .replace(/í/g, 'í')
                            .replace(/á/g, 'á')
                    );
                audio.src = mediaUrl;
                audio.load();
                audio.play();
            } else {
                this.isPlaying = true;
                audio.play();
            }
        },
        stop() {
            this.displayTrackStopped();
            audio.pause();
        },
        displayTrackStopped() {
            this.isPlaying = false;
        },
        playButtonAction() {
            if (this.isPlaying) {
                this.stop();
            } else {
                this.play(
                    this.activeTrack.track,
                    this.activeTrack.index,
                    this.activeTrack.path
                );
            }
        },
        previousButtonAction() {
            //go back to beginning of track
            //if more than a fixed amount has played
            if (this.elapsedTime > 4000) {
                this.elapsedTime = 0;
                audio.currentTime = 0;
            } else {
                this.playPreviousTrack();
            }
        },
        playPreviousTrack() {
            if (!this.hasPreviousTrack) {
                return;
            }
            const trackIndex = this.activeTrack.index - 1;
            const track = this.activeTrackTrackList[trackIndex];
            this.play(track, trackIndex, this.activeTrack.path);
        },
        playNextTrack() {
            if (!this.hasNextTrack) {
                return;
            }
            const trackIndex = this.activeTrack.index + 1;
            const track = this.activeTrackTrackList[trackIndex];
            this.play(track, trackIndex, this.activeTrack.path);
        },
        adjustVolume(value) {
            audio.volume = value;
            this.audioVolume = value;
            saveUserVolume(value);
        },
    },
};
</script>
