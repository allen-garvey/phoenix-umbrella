import TextList from '../base/text-list.vue';

export default function mixinBuilder(pageTitle){
    return {
        props: {
            setWindowTitle: {
                type: Function,
                required: true,
            },
            getModel: {
                type: Function,
                required: true,
            },
        },
        components: {
            'Text-List': TextList,
        },
        created(){
            this.setup();
        },
        data() {
            return {
                model: [],
                //need this property or there will be errors when we switch routes and new models haven't been loaded yet
                isInitialLoadComplete: false,
                pageTitle: pageTitle,
            }
        },
        computed: {
            itemsList(){
                if(!this.isInitialLoadComplete){
                    return [];
                }
                return this.model;
            },
        },
        watch: {
            '$route'(to, from){
                this.setup();
            }
        },
        methods: {
            setup(){
                this.setWindowTitle(this.pageTitle);
                this.isInitialLoadComplete = false;
                this.getModel(this.modelPath).then((itemsJson)=>{
                    this.model = itemsJson;
                    this.isInitialLoadComplete = true;
                });
            },
            showRouteFor(item){
                return {
                    name: this.showRouteName,
                    params: {
                        id: item.id,
                    },
                };
            },
            titleFor(item){
                return item.name;
            },
        }
    };
}