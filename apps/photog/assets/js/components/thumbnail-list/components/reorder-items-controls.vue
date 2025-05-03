<template>
    <div :class="$style.container">
        <div :class="{ [$style.actionButtonContainer]: isReordering }">
            <button
                class="btn"
                :class="reorderButtonCssClass"
                v-show="shouldShowReorderButton"
                @click="reorderButtonAction()"
                :disabled="isCurrentlySavingOrder"
            >
                {{ reorderButtonText }}
            </button>
            <spinner-button
                v-show="isReordering && isListReordered"
                @buttonClick="saveOrder()"
                :isLoading="isCurrentlySavingOrder"
                :buttonClasses="['btn-success', $style.saveButton]"
                buttonText="Save order"
                spinnerText="Saving..."
            />
        </div>
        <div
            :class="$style.sortContainer"
            v-if="enableReorderBySort && isReordering"
        >
            <div :class="$style.selectContainer">
                <select
                    class="form-control"
                    :class="$style.select"
                    v-model="selectedReorderMode"
                    :disabled="isCurrentlySavingOrder"
                >
                    <option
                        v-for="reorderMode in reorderModes"
                        :key="reorderMode.key"
                        :value="reorderMode.key"
                    >
                        {{ reorderMode.name }}
                    </option>
                </select>
            </div>
            <div>
                <button
                    class="btn btn-outline-warning"
                    @click="$emit('reorder-by-sort', selectedReorderMode)"
                    :disabled="isCurrentlySavingOrder"
                >
                    Sort
                </button>
            </div>
        </div>
    </div>
</template>

<style lang="scss" module>
.container {
    display: flex;
    justify-content: space-between;
}

.saveButton {
    margin-left: 1em;
}

.actionButtonContainer {
    margin-right: 1em;
}

.sortContainer {
    display: flex;
}

.selectContainer {
    margin-right: 1em;
}

.select {
    height: 100%;
    appearance: auto;
}
</style>

<script>
import reorderModes from '../models/reorder-modes.js';
import SpinnerButton from '../../form/spinner-button.vue';

export default {
    props: {
        shouldShowReorderButton: {
            type: Boolean,
            required: true,
        },
        isReordering: {
            type: Boolean,
            required: true,
        },
        isCurrentlySavingOrder: {
            type: Boolean,
            required: true,
        },
        isListReordered: {
            type: Boolean,
            required: true,
        },
        reorderButtonAction: {
            type: Function,
            required: true,
        },
        saveOrder: {
            type: Function,
            required: true,
        },
        enableReorderBySort: {
            type: Boolean,
            default: false,
        },
    },
    components: {
        SpinnerButton,
    },
    data() {
        return {
            selectedReorderMode: reorderModes[0].key,
        };
    },
    computed: {
        reorderButtonCssClass() {
            return {
                'btn-outline-primary': !this.isReordering,
                'btn-outline-secondary': this.isReordering,
            };
        },
        reorderButtonText() {
            return this.isReordering ? 'Cancel' : 'Reorder';
        },
        reorderModes() {
            return reorderModes;
        },
    },
};
</script>
