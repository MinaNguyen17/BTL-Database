import axiosInstance from '@/utils/axiosInstance';

const ItemService = {
  // Create a new item
  createItem: async (itemData) => {
    try {
      const response = await axiosInstance.post('/item/create', itemData);
      return response.data;
    } catch (error) {
      console.error('Error creating item:', error);
      throw error;
    }
  }
};

export default ItemService;
