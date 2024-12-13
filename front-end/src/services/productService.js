import axiosInstance from '@/utils/axiosInstance';

// Product service for handling product-related API calls
const ProductService = {
  // Fetch all products
  getAllProducts: async (params = {}) => {
    try {
      const response = await axiosInstance.get('/product/all');
      return response.data;
    } catch (error) {
      console.error('Error fetching products:', error);
      throw error;
    }
  },

  // Get product by ID
  getProductById: async (productId) => {
    try {
      const response = await axiosInstance.get(`/product/get/${productId}`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching product ${productId}:`, error);
      throw error;
    }
  },

  // Create a new product
  createProduct: async (productData) => {
    try {
      const response = await axiosInstance.post('product/create', productData);
      return response.data;
    } catch (error) {
      console.error('Error creating product:', error);
      throw error;
    }
  },

  // Update an existing product
  updateProduct: async (productId, productData) => {
    try {
      const response = await axiosInstance.post(`/product/update/${productId}`, productData);
      return response.data;
    } catch (error) {
      console.error(`Error updating product ${productId}:`, error);
      throw error;
    }
  },

  // Delete a product
  deleteProduct: async (productId) => {
    try {
      const response = await axiosInstance.delete(`/product/${productId}`);
      return response.data;
    } catch (error) {
      console.error(`Error deleting product ${productId}:`, error);
      throw error;
    }
  },

  // Toggle product status (active/inactive)
  toggleProductStatus: async (productId, status) => {
    try {
      const response = await axiosInstance.patch(`/product/${productId}/status`, { status });
      return response.data;
    } catch (error) {
      console.error(`Error toggling product ${productId} status:`, error);
      throw error;
    }
  },

  // Search products
  searchProducts: async (searchTerm) => {
    try {
      const response = await axiosInstance.get('/product/search', { 
        params: { query: searchTerm } 
      });
      return response.data;
    } catch (error) {
      console.error('Error searching products:', error);
      throw error;
    }
  },

  // Filter products
  filterProducts: async (filters) => {
    try {
      const response = await axiosInstance.get('/product/filter', { params: filters });
      return response.data;
    } catch (error) {
      console.error('Error filtering products:', error);
      throw error;
    }
  }
};

export default ProductService;
