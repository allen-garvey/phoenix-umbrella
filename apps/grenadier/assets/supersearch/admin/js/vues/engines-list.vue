<template>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="engine in engines">
                <td>
                    <a :href="`${adminEnginesUrlBase}/${engine.id}`">{{
                        engine.name
                    }}</a>
                </td>

                <td :class="$style.buttonCell">
                    <a
                        :href="`${adminEnginesUrlBase}/${engine.id}/edit`"
                        class="btn btn-primary"
                        >Edit</a
                    >
                </td>
            </tr>
        </tbody>
    </table>
</template>

<style lang="scss" module>
th,
td {
    padding: 0.5em 0;
}
.buttonCell {
    padding-left: 4em;
}
</style>

<script>
export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        reorderEnginesUrl: {
            type: String,
            required: true,
        },
        enginesApiUrl: {
            type: String,
            required: true,
        },
        adminEnginesUrlBase: {
            type: String,
            required: true,
        },
    },
    created() {
        fetch(this.enginesApiUrl)
            .then(res => res.json())
            .then(json => {
                this.engines = json.data;
            });
    },
    data() {
        return {
            engines: [],
        };
    },
    computed: {},
    methods: {},
};
</script>
