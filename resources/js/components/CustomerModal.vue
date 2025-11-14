<template>
  <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click.self="$emit('close')">
    <div class="relative top-20 mx-auto p-5 border w-full max-w-2xl shadow-lg rounded-md bg-white">
      <!-- Modal Header -->
      <div class="flex justify-between items-center pb-3 border-b">
        <h3 class="text-xl font-semibold text-gray-900">
          {{ isEdit ? 'Edit Customer' : 'Create Customer' }}
        </h3>
        <button @click="$emit('close')" class="text-gray-400 hover:text-gray-600">
          <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
           </svg>
        </button>
      </div>

      <!-- Modal Body -->
      <div class="mt-4">
        <form @submit.prevent="handleSubmit">
          <!-- General Section -->
          <div class="mb-6">
            <h4 class="text-lg font-medium text-gray-900 mb-4">General</h4>
            
            <div class="grid grid-cols-2 gap-4">
              <!-- Name -->
              <div class="col-span-2 sm:col-span-1">
                <label class="block text-sm font-medium text-gray-700 mb-1">Name *</label>
                <input
                  v-model="formData.name"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :class="{ 'border-red-500': errors.name }"
                />
                <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name[0] }}</p>
              </div>

              <!-- Reference -->
              <div class="col-span-2 sm:col-span-1">
                <label class="block text-sm font-medium text-gray-700 mb-1">Reference *</label>
                <input
                  v-model="formData.reference"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :class="{ 'border-red-500': errors.reference }"
                />
                <p v-if="errors.reference" class="mt-1 text-sm text-red-600">{{ errors.reference[0] }}</p>
              </div>

              <!-- Category -->
              <div class="col-span-2 sm:col-span-1">
                <label class="block text-sm font-medium text-gray-700 mb-1">Category *</label>
                <select
                  v-model="formData.category_id"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :class="{ 'border-red-500': errors.category_id }"
                >
                  <option value="">Select...</option>
                  <option v-for="category in categories" :key="category.id" :value="category.id">
                    {{ category.name }}
                  </option>
                </select>
                <p v-if="errors.category_id" class="mt-1 text-sm text-red-600">{{ errors.category_id[0] }}</p>
              </div>

              <!-- Start Date -->
              <div class="col-span-2 sm:col-span-1">
                <label class="block text-sm font-medium text-gray-700 mb-1">Start Date</label>
                <input
                  v-model="formData.start_date"
                  type="date"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :class="{ 'border-red-500': errors.start_date }"
                />
                <p v-if="errors.start_date" class="mt-1 text-sm text-red-600">{{ errors.start_date[0] }}</p>
              </div>

              <!-- Description -->
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea
                  v-model="formData.description"
                  rows="3"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  :class="{ 'border-red-500': errors.description }"
                ></textarea>
                <p v-if="errors.description" class="mt-1 text-sm text-red-600">{{ errors.description[0] }}</p>
              </div>
            </div>
          </div>

          <!-- Contacts Section -->
          <div v-if="isEdit" class="mb-6 border-t pt-6">
            <div class="flex justify-between items-center mb-4">
              <h4 class="text-lg font-medium text-gray-900">Contacts</h4>
              <button
                type="button"
                @click="openContactModal()"
                class="px-4 py-2 bg-green-600 text-white text-sm rounded-md hover:bg-green-700 transition-colors"
              >
                Add Contact
              </button>
            </div>

            <div class="bg-gray-50 rounded-lg p-4">
              <table class="min-w-full" v-if="contacts.length > 0">
                <thead>
                  <tr class="border-b border-gray-200">
                    <th class="text-left text-xs font-medium text-gray-500 uppercase pb-2">First Name</th>
                    <th class="text-left text-xs font-medium text-gray-500 uppercase pb-2">Last Name</th>
                    <th class="text-right text-xs font-medium text-gray-500 uppercase pb-2">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="contact in contacts" :key="contact.id" class="border-b border-gray-100 last:border-0">
                    <td class="py-2 text-sm">{{ contact.first_name }}</td>
                    <td class="py-2 text-sm">{{ contact.last_name }}</td>
                    <td class="py-2 text-sm text-right space-x-2">
                      <button type="button" @click="openContactModal(contact)" class="text-blue-600 hover:text-blue-900">Edit</button>
                      <span class="text-gray-300">|</span>
                      <button type="button" @click="deleteContact(contact)" class="text-red-600 hover:text-red-900">Delete</button>
                    </td>
                  </tr>
                </tbody>
              </table>
              <p v-else class="text-sm text-gray-500 text-center py-4">No contacts yet</p>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="flex justify-end space-x-3 pt-4 border-t">
            <button
              type="button"
              @click="$emit('close')"
              class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 transition-colors"
            >
              Back
            </button>
            <button
              type="submit"
              :disabled="saving"
              class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors disabled:opacity-50"
            >
              {{ saving ? 'Saving...' : 'Save' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Contact Modal -->
    <ContactModal
      v-if="showContactModal"
      :contact="selectedContact"
      :customer-id="formData.id"
      @close="closeContactModal"
      @save="handleContactSave"
    />

    <!-- Delete Contact Confirmation -->
    <DeleteConfirmModal
      v-if="showDeleteContactModal"
      title="Delete Contact"
      :message="`Are you sure you want to delete ${contactToDelete?.first_name} ${contactToDelete?.last_name}?`"
      @confirm="handleDeleteContact"
      @cancel="closeDeleteContactModal"
    />
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import axios from 'axios';
import ContactModal from './ContactModal.vue';
import DeleteConfirmModal from './DeleteConfirmModal.vue';

const props = defineProps({
  customer: {
    type: Object,
    default: null
  },
  categories: {
    type: Array,
    required: true
  }
});

const emit = defineEmits(['close', 'save']);

const formData = ref({
  id: null,
  name: '',
  reference: '',
  category_id: '',
  start_date: '',
  description: ''
});

const contacts = ref([]);
const errors = ref({});
const saving = ref(false);
const showContactModal = ref(false);
const showDeleteContactModal = ref(false);
const selectedContact = ref(null);
const contactToDelete = ref(null);

const isEdit = computed(() => !!formData.value.id);

// Initialize form data
watch(() => props.customer, (newCustomer) => {
  if (newCustomer) {
    formData.value = {
      id: newCustomer.id,
      name: newCustomer.name,
      reference: newCustomer.reference,
      category_id: newCustomer.category_id,
      start_date: newCustomer.start_date || '',
      description: newCustomer.description || ''
    };
    contacts.value = newCustomer.contacts || [];
  }
}, { immediate: true });

const handleSubmit = async () => {
  errors.value = {};
  saving.value = true;

  try {
    await emit('save', formData.value);
  } catch (error) {
    if (error.response?.data?.errors) {
      errors.value = error.response.data.errors;
    } else {
      alert('An error occurred while saving');
    }
  } finally {
    saving.value = false;
  }
};

const openContactModal = (contact = null) => {
  selectedContact.value = contact;
  showContactModal.value = true;
};

const closeContactModal = () => {
  showContactModal.value = false;
  selectedContact.value = null;
};

const handleContactSave = async (contactData) => {
  try {
    if (contactData.id) {
      // Update contact
      await axios.put(`/api/contacts/${contactData.id}`, contactData);
    } else {
      // Create contact
      await axios.post(`/api/customers/${formData.value.id}/contacts`, contactData);
    }
    // Refresh contacts
    const response = await axios.get(`/api/customers/${formData.value.id}/contacts`);
    contacts.value = response.data;
    closeContactModal();
  } catch (error) {
    console.error('Error saving contact:', error);
    throw error;
  }
};

const deleteContact = (contact) => {
  contactToDelete.value = contact;
  showDeleteContactModal.value = true;
};

const closeDeleteContactModal = () => {
  showDeleteContactModal.value = false;
  contactToDelete.value = null;
};

const handleDeleteContact = async () => {
  try {
    await axios.delete(`/api/contacts/${contactToDelete.value.id}`);
    contacts.value = contacts.value.filter(c => c.id !== contactToDelete.value.id);
    closeDeleteContactModal();
  } catch (error) {
    console.error('Error deleting contact:', error);
    alert('Failed to delete contact');
  }
};
</script>
