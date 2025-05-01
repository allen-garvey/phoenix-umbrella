import { API_URL_BASE } from '../../request-helpers';

import FormSection from '../form/form-section.vue';
import FormInput from '../form/form-input.vue';

export function formMixinBuilder() {
    return {
        props: {
            getModel: {
                type: Function,
                required: true,
            },
            putFlash: {
                type: Function,
                required: true,
            },
            sendJson: {
                type: Function,
                required: true,
            },
            itemsUrl: {
                type: String,
            },
        },
        components: {
            'Form-Input': FormInput,
            'Form-Section': FormSection,
        },
        data() {
            return {
                isInitialLoadComplete: false,
                model: null,
                items: [],
                errors: {},
            };
        },
        created() {
            this.setup();
        },
        computed: {
            isEditForm() {
                return typeof this.modelId === 'number';
            },
            isCreateForm() {
                return !this.isEditForm;
            },
        },
        watch: {
            $route(to, from) {
                this.setup();
            },
        },
        methods: {
            setup() {
                this.isInitialLoadComplete = false;
                this.errors = {};
                if (this.isEditForm) {
                    this.loadModel().then(([model, items]) => {
                        this.model = model;
                        this.items = items;
                        this.setupModel(model);
                        this.isInitialLoadComplete = true;
                    });
                } else {
                    this.model = null;
                    this.setupModel();
                    this.isInitialLoadComplete = true;
                }
            },
            loadModel() {
                const apiUrl = `${this.resourceApiUrlBase}/${this.modelId}`;
                const modelPromise = this.getModel(apiUrl);
                const itemsPromise = this.itemsUrl
                    ? this.getModel(this.itemsUrl)
                    : Promise.resolve(null);

                return Promise.all([modelPromise, itemsPromise]);
            },
            save() {
                let apiUrl = `${API_URL_BASE}/${this.resourceApiUrlBase}`;
                let apiMethod = 'POST';
                if (this.isEditForm) {
                    apiUrl = `${apiUrl}/${this.modelId}`;
                    apiMethod = 'PATCH';
                }
                const resource = this.getResourceForSave();

                this.sendJson(apiUrl, apiMethod, resource).then(response => {
                    if (response.errors) {
                        this.errors = response.errors;
                    } else {
                        this.saveSuccessful(response.data);
                    }
                });
            },
            onKeyPressed(key) {
                if (key === 'Escape') {
                    const route = { name: `${this.routeBase}Index` };
                    if (this.isEditForm) {
                        route.name = `${this.routeBase}Show`;
                        route.params = {
                            id: this.modelId,
                        };
                    }
                    this.$router.push(route);
                }
            },
        },
    };
}
