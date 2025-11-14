<template>
  <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-[60]" @click.self="$emit('close')">
    <div class="relative top-32 mx-auto p-5 border w-full max-w-md shadow-lg rounded-md bg-white">
      <!-- Modal Header -->
      <div class="flex justify-between items-center pb-3 border-b">
        <h3 class="text-lg font-semibold text-gray-900">
          {{ isEdit  ? 'Edit Contact' : 'Add Contact' }}
        </h3>
        <button @click="$emit('close')" class="text-gray-400 hover:text-gray-600">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>

      <!-- Modal Body -->
      <div class="mt-4">
        <form @submit.prevent="handleSubmit">
          <!-- First Name -->
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>
            <input
              v-model="formData.first_name"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              :class="{ 'border-red-500': errors.first_name }"
            />
            <p v-if="errors.first_name" class="mt-1 text-sm text-red-600">{{ errors.first_name[0] }}</p>
          </div>

          <!-- Last Name -->
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
            <input
              v-model="formData.last_name"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              :class="{ 'border-red-500': errors.last_name }"
            />
            <p v-if="errors.last_name" class="mt-1 text-sm text-red-600">{{ errors.last_name[0] }}</p>
          </div>

          <!-- Modal Footer -->
          <div class="flex justify-end space-x-3 pt-4 border-t">
            <button
              type="button"
              @click="$emit('close')"
              class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 transition-colors"
            >
              Cancel
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
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';

const props = defineProps({
  contact: {
    type: Object,
    default: null
  },
  customerId: {
    type: Number,
    required: true
  }
});

const emit = defineEmits(['close', 'save']);

const formData = ref({
  id: null,
  first_name: '',
  last_name: ''
});

const errors = ref({});
const saving = ref(false);

const isEdit = computed(() => !!formData.value.id);

// Initialize form data
watch(() => props.contact, (newContact) => {
  if (newContact) {
    formData.value = {
      id: newContact.id,
      first_name: newContact.first_name,
      last_name: newContact.last_name
    };
  } else {
    formData.value = {
      id: null,
      first_name: '',
      last_name: ''
    };
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
</script>
