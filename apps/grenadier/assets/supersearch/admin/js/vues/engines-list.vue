<template>
    <div
        :class="$style.reorderControls"
        :style="{
            visibility: haveItemsBeenReordered ? 'visible' : 'hidden',
        }"
    >
        <button class="btn btn-light" @click="resetOrder()">Reset Order</button>
        <button class="btn btn-primary" @click="saveOrder()">Save Order</button>
    </div>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="(engine, index) in enginesReordered">
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
                <td
                    :class="$style.listItemDragger"
                    draggable="true"
                    @dragstart="onDragStart(index)"
                    @dragover="onDraggedOver($event, index)"
                    @drop="onDrop($event)"
                >
                    &#9776;
                </td>
            </tr>
        </tbody>
    </table>
</template>

<style lang="scss" module>
table,
th,
td {
    border: none;
    border-collapse: collapse;
}
tbody tr:nth-child(odd) {
    background-color: var(--color-background-secondary);
}
th,
td {
    padding: 0.5em;
}
.buttonCell {
    padding-left: 4em;
}
.listItemDragger {
    padding-left: 1em;
    font-size: 2em;
    cursor: move;
}
.reorderControls {
    display: flex;
    margin: 2em 0.5em 1em;
    gap: 1em;
}
</style>

<script>
import { sendJson, fetchJson } from 'umbrella-common-js/ajax.js';

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
        fetchJson(this.enginesApiUrl).then(data => {
            this.engines = data;
            this.enginesReordered = data;
        });
    },
    data() {
        return {
            engines: [],
            enginesReordered: [],
            currentDragIndex: -1,
            haveItemsBeenReordered: false,
        };
    },
    methods: {
        resetOrder() {
            this.enginesReordered = this.engines;
            this.haveItemsBeenReordered = false;
        },
        saveOrder() {
            this.haveItemsBeenReordered = false;
            this.engines = this.enginesReordered;
            const engine_ids = this.engines.map(engine => engine.id);
            sendJson(this.reorderEnginesUrl, this.csrfToken, 'PATCH', {
                engine_ids,
            });
        },
        onDragStart(index) {
            this.currentDragIndex = index;
        },
        onDrop(e) {
            e.preventDefault();
        },
        onDraggedOver(e, index) {
            e.preventDefault();
            e.stopPropagation();

            if (this.currentDragIndex != index) {
                let engines = this.enginesReordered.slice();
                const draggedEngine = engines.splice(
                    this.currentDragIndex,
                    1
                )[0];
                engines.splice(index, 0, draggedEngine);
                this.enginesReordered = engines;
                this.currentDragIndex = index;
                this.haveItemsBeenReordered = true;
            }
        },
    },
};
</script>
