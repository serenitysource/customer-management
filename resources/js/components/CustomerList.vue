<template>
  <div class="min-h-screen bg-gray-100 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Customer Management</h1>
        <p class="mt-2 text-sm text-gray-600">Manage your customers and their contacts</p>
      </div>

      <!-- Search and Create Section -->
      <div class="bg-white rounded-lg shadow mb-6 p-6">
        <div class="flex items-center gap-4">
          <div class="flex-1 max-w-md">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search customers..."
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          <div class="w-48">
            <select
              v-model="categoryFilter"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">All Categories</option>
              <option v-for="category in categories" :key="category.id" :value="category.id">
                {{ category.name }}
              </option>
            </select>
          </div>
          <button
            @click="clearFilters"
            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors duration-200 font-medium whitespace-nowrap"
          >
            Clear
          </button>
          <button
            @click="applyFilters"
            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 font-medium whitespace-nowrap"
          >
            Apply
          </button>
          <button
            @click="openCreateModal"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 font-medium whitespace-nowrap"
          >
            Create Customer
          </button>
        </div>
      </div>

      <!-- Customers Table -->
      <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Reference</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Category</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Contacts</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-if="loading">
              <td colspan="5" class="px-6 py-4 text-center text-gray-500">Loading...</td>
            </tr>
            <tr v-else-if="filteredCustomers.length === 0">
              <td colspan="5" class="px-6 py-4 text-center text-gray-500">No customers found</td>
            </tr>
            <tr v-else v-for="customer in filteredCustomers" :key="customer.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ customer.name }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ customer.reference }}</td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="getCategoryBadgeClass(customer.category?.name)" class="px-2 py-1 text-xs font-semibold rounded-full">
                  {{ customer.category?.name }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ customer.contacts?.length || 0 }}</td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                <button @click="openEditModal(customer)" class="text-blue-600 hover:text-blue-900">Edit</button>
                <span class="text-gray-300">|</span>
                <button @click="openDeleteModal(customer)" class="text-red-600 hover:text-red-900">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Customer Modal -->
    <CustomerModal
      v-if="showCustomerModal"
      :customer="selectedCustomer"
      :categories="categories"
      @close="closeCustomerModal"
      @save="handleSaveCustomer"
    />

    <!-- Delete Confirmation Modal -->
    <DeleteConfirmModal
      v-if="showDeleteModal"
      :title="'Delete Customer'"
      :message="`Are you sure you want to delete ${customerToDelete?.name}? This will also delete all associated contacts.`"
      @confirm="handleDeleteCustomer"
      @cancel="closeDeleteModal"
    />
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import CustomerModal from './CustomerModal.vue';
import DeleteConfirmModal from './DeleteConfirmModal.vue';

const customers = ref([]);
const categories = ref([]);
const searchQuery = ref('');
const categoryFilter = ref('');
const appliedSearchQuery = ref('');
const appliedCategoryFilter = ref('');
const loading = ref(false);
const showCustomerModal = ref(false);
const showDeleteModal = ref(false);
const selectedCustomer = ref(null);
const customerToDelete = ref(null);

const filteredCustomers = computed(() => {
  let filtered = customers.value;
  
  // Apply search filter
  if (appliedSearchQuery.value) {
    const query = appliedSearchQuery.value.toLowerCase();
    filtered = filtered.filter(customer => 
      customer.name.toLowerCase().includes(query) ||
      customer.reference.toLowerCase().includes(query)
    );
  }
  
  // Apply category filter
  if (appliedCategoryFilter.value) {
    filtered = filtered.filter(customer => 
      customer.category_id === appliedCategoryFilter.value
    );
  }
  
  return filtered;
});

const fetchCustomers = async () => {
  loading.value = true;
  try {
    const response = await axios.get('/api/customers');
    customers.value = response.data;
  } catch (error) {
    console.error('Error fetching customers:', error);
    alert('Failed to load customers');
  } finally {
    loading.value = false;
  }
};

const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/categories');
    categories.value = response.data;
  } catch (error) {
    console.error('Error fetching categories:', error);
  }
};

const applyFilters = () => {
  appliedSearchQuery.value = searchQuery.value;
  appliedCategoryFilter.value = categoryFilter.value;
};

const clearFilters = () => {
  searchQuery.value = '';
  categoryFilter.value = '';
  appliedSearchQuery.value = '';
  appliedCategoryFilter.value = '';
};

const handleSearch = () => {
  // Deprecated - keeping for compatibility
};

const openCreateModal = () => {
  selectedCustomer.value = null;
  showCustomerModal.value = true;
};

const openEditModal = (customer) => {
  selectedCustomer.value = { ...customer };
  showCustomerModal.value = true;
};

const closeCustomerModal = () => {
  showCustomerModal.value = false;
  selectedCustomer.value = null;
};

const handleSaveCustomer = async (customerData) => {
  try {
    if (customerData.id) {
      // Update existing customer
      await axios.put(`/api/customers/${customerData.id}`, customerData);
    } else {
      // Create new customer
      await axios.post('/api/customers', customerData);
    }
    await fetchCustomers();
    closeCustomerModal();
  } catch (error) {
    console.error('Error saving customer:', error);
    throw error;
  }
};

const openDeleteModal = (customer) => {
  customerToDelete.value = customer;
  showDeleteModal.value = true;
};

const closeDeleteModal = () => {
  showDeleteModal.value = false;
  customerToDelete.value = null;
};

const handleDeleteCustomer = async () => {
  try {
    await axios.delete(`/api/customers/${customerToDelete.value.id}`);
    await fetchCustomers();
    closeDeleteModal();
  } catch (error) {
    console.error('Error deleting customer:', error);
    alert('Failed to delete customer');
  }
};

const getCategoryBadgeClass = (categoryName) => {
  const classes = {
    'Gold': 'bg-yellow-100 text-yellow-800',
    'Silver': 'bg-gray-100 text-gray-800',
    'Bronze': 'bg-orange-100 text-orange-800',
  };
  return classes[categoryName] || 'bg-gray-100 text-gray-800';
};

onMounted(() => {
  fetchCustomers();
  fetchCategories();
});
</script>
