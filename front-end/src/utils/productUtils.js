// Product-related utility functions

/**
 * Formats product price
 * @param {number} price - The price to format
 * @param {string} locale - The locale to use for formatting (default: 'en-US')
 * @returns {string} Formatted price string
 */
export const formatProductPrice = (price, locale = 'en-US') => {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: 'USD'
  }).format(price);
};

/**
 * Validates product data before submission
 * @param {Object} productData - The product data to validate
 * @returns {Object} Validation result with success status and error messages
 */
export const validateProductData = (productData) => {
  const errors = {};

  // Name validation
  if (!productData.name || productData.name.trim() === '') {
    errors.name = 'Product name is required';
  }

  // Price validation
  if (!productData.price || isNaN(parseFloat(productData.price)) || parseFloat(productData.price) <= 0) {
    errors.price = 'Valid price is required';
  }

  // Category validation
  if (!productData.category || productData.category.trim() === '') {
    errors.category = 'Product category is required';
  }

  return {
    isValid: Object.keys(errors).length === 0,
    errors
  };
};

/**
 * Generates a unique product ID
 * @returns {string} A unique product identifier
 */
export const generateProductId = () => {
  return `PRD-${Date.now().toString(36)}-${Math.random().toString(36).substr(2, 5)}`.toUpperCase();
};

/**
 * Filters products based on multiple criteria
 * @param {Array} products - List of products to filter
 * @param {Object} filters - Filtering criteria
 * @returns {Array} Filtered products
 */
export const filterProducts = (products, filters) => {
  return products.filter(product => {
    // Price range filter
    if (filters.minPrice && product.price < filters.minPrice) return false;
    if (filters.maxPrice && product.price > filters.maxPrice) return false;

    // Category filter
    if (filters.category && product.category !== filters.category) return false;

    // Brand filter
    if (filters.brand && product.brand !== filters.brand) return false;

    // Size filter
    if (filters.size && !product.sizes.includes(filters.size)) return false;

    // Color filter
    if (filters.color && !product.colors.includes(filters.color)) return false;

    return true;
  });
};

/**
 * Sorts products by a given criteria
 * @param {Array} products - List of products to sort
 * @param {string} sortBy - Sorting criteria (price, name, etc.)
 * @param {string} order - Sort order ('asc' or 'desc')
 * @returns {Array} Sorted products
 */
export const sortProducts = (products, sortBy = 'price', order = 'asc') => {
  return [...products].sort((a, b) => {
    if (a[sortBy] < b[sortBy]) return order === 'asc' ? -1 : 1;
    if (a[sortBy] > b[sortBy]) return order === 'asc' ? 1 : -1;
    return 0;
  });
};
