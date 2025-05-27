<template>
    <dt :class="$style.label">
        {{ label }}
    </dt>
    <dd>
        <div :class="$style.flexContainer" v-if="!isEditing">
            <slot> </slot>
            <button @click="edit()" class="btn btn-outline-primary btn-xs">
                Edit
            </button>
        </div>
        <form
            @submit.prevent="update()"
            :class="[$style.editContainer, $style.flexContainer]"
            v-if="isEditing"
        >
            <div class="form-group">
                <input
                    :type="inputType"
                    :class="inputClass"
                    v-model="model"
                    ref="input"
                />
            </div>
            <button
                @click="cancelEdit()"
                type="button"
                class="btn btn-outline-secondary btn"
            >
                Cancel
            </button>
            <button type="submit" class="btn btn-success btn">Save</button>
        </form>
    </dd>
</template>

<style lang="scss" module>
.label {
    margin-bottom: 1.5em;
}
.flexContainer {
    display: flex;
    flex-wrap: wrap;
    gap: 1em;
    align-items: flex-start;
}

.editContainer {
    .form-control {
        max-width: 14em;
    }
    .form-group {
        margin-right: 1rem;
    }
}
</style>

<script>
import { nextTick } from 'vue';

export default {
    props: {
        label: {
            type: String,
            required: true,
        },
        inputType: {
            type: String,
            default: 'text',
        },
        modelKey: {
            type: String,
            required: true,
        },
        imageId: {
            type: [String, Number],
            required: true,
        },
        value: {
            type: [String, Number],
        },
        updateImage: {
            type: Function,
            required: true,
        },
    },
    data() {
        return {
            model: null,
            isEditing: false,
        };
    },
    computed: {
        inputClass() {
            if (this.inputType === 'checkbox') {
                return 'form-check-input';
            }

            return 'form-control';
        },
    },
    watch: {
        value() {
            this.isEditing = false;
            this.model = this.value;
        },
    },
    created() {
        this.model = this.value;
    },
    methods: {
        update() {
            const value = this.model === '' ? null : this.model;
            const data = {
                image: {
                    id: this.imageId,
                    [this.modelKey]: value,
                },
            };
            this.updateImage(data).then(response => {
                this.isEditing = false;
            });
        },
        edit() {
            this.isEditing = true;
            nextTick().then(() => {
                this.$refs.input.focus();
            });
        },
        cancelEdit() {
            this.isEditing = false;
        },
    },
};
</script>
