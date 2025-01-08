<template>
    <div :class="$style.activeTrackDisplay" v-if="activeTrack.track">
        <router-link
            :to="{
                name: 'artistTracks',
                params: { id: activeArtist.id },
            }"
        >
            {{ activeArtist.name }}
        </router-link>
        <span>
            {{ activeTrackTitle }}
        </span>
        <router-link
            :to="{
                name: 'albumTracks',
                params: { id: activeAlbum.id },
            }"
            v-if="activeAlbum"
        >
            {{ activeAlbum.title }}
        </router-link>
    </div>
</template>

<style lang="scss" module>
.activeTrackDisplay {
    margin-bottom: 8px;
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 1em;
}
</style>

<script>
export default {
    props: {
        artistsMap: {
            type: Map,
            required: true,
        },
        albumsMap: {
            type: Map,
            required: true,
        },
        activeTrack: {
            type: Object,
            required: true,
        },
    },
    computed: {
        activeArtist() {
            return this.artistsMap.get(this.activeTrack.track.artist_id);
        },
        activeTrackTitle() {
            console.log(this.activeTrack.track);
            return this.activeTrack.track.title;
        },
        activeAlbum() {
            return this.albumsMap.get(this.activeTrack.track.album_id);
        },
    },
};
</script>
