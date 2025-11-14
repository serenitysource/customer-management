import './bootstrap';
import { createApp } from 'vue';
import CustomerList from './components/CustomerList.vue';

const app = createApp({});

app.component('customer-list', CustomerList);

app.mount('#app');
