import React, { useState, useMemo, useEffect } from 'react';
import ProductService from '../../services/productService';
import ProductFilterSection from './components/ProductFilterSection';
import ProductSearchBar from './components/ProductSearchBar';
import ProductActionButtons from './components/ProductActionButtons';
import ProductTable from './components/ProductTable';

const ProductView = () => {
  // Price range state - moved before other states
  const [priceRange, setPriceRange] = useState([0, 200]);
  
  const [products, setProducts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // State for filter items
  const [categoryFilters, setCategoryFilters] = useState([]);
  const [brandFilters, setBrandFilters] = useState([]);
  const [seasonFilters, setSeasonFilters] = useState([]);
  const [styleTagFilters, setStyleTagFilters] = useState([]);

  // State for pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setIsLoading(true);
        const fetchedProducts = await ProductService.getAllProducts();
        setProducts(fetchedProducts);

        // Generate unique filter categories dynamically
        const uniqueCategories = [...new Set(fetchedProducts.map(p => p.CATEGORY).filter(Boolean))];
        const uniqueBrands = [...new Set(fetchedProducts.map(p => p.BRAND).filter(Boolean))];
        const uniqueSeasons = [...new Set(fetchedProducts.map(p => p.SEASON).filter(Boolean))];
        const uniqueStyleTags = [...new Set(fetchedProducts.map(p => p.STYLE_TAG).filter(Boolean))];

        // Initialize filter states with all items checked
        setCategoryFilters(uniqueCategories.map((category, index) => ({
          id: `category-${index}`,
          label: category,
          checked: true
        })));

        setBrandFilters(uniqueBrands.map((brand, index) => ({
          id: `brand-${index}`,
          label: brand,
          checked: true
        })));

        setSeasonFilters(uniqueSeasons.map((season, index) => ({
          id: `season-${index}`,
          label: season,
          checked: true
        })));

        setStyleTagFilters(uniqueStyleTags.map((tag, index) => ({
          id: `tag-${index}`,
          label: tag,
          checked: true
        })));

        setIsLoading(false);
      } catch (err) {
        console.error('Failed to fetch products:', err);
        setIsLoading(false);
      }
    };

    fetchProducts();
  }, []);

  // Toggle filter item
  const toggleFilterItem = (filters, setFilters, id) => {
    setFilters(prevFilters => 
      prevFilters.map(filter => 
        filter.id === id 
          ? { ...filter, checked: !filter.checked }
          : filter
      )
    );
  };

  // Filter products based on selected filters
  const filteredProducts = useMemo(() => {
    if (!products.length) return [];

    return products.filter(product => {
      // Check if product passes category filter
      const categoryMatch = categoryFilters.length === 0 || 
        categoryFilters.some(cat => cat.checked && cat.label === product.CATEGORY);

      // Check if product passes brand filter
      const brandMatch = brandFilters.length === 0 || 
        brandFilters.some(brand => brand.checked && brand.label === product.BRAND);

      // Check if product passes season filter
      const seasonMatch = seasonFilters.length === 0 || 
        seasonFilters.some(season => season.checked && season.label === product.SEASON);

      // Check if product passes style tag filter
      const styleTagMatch = styleTagFilters.length === 0 || 
        styleTagFilters.some(tag => tag.checked && tag.label === product.STYLE_TAG);

      // Check if product passes price range filter
      const priceMatch = !product.PRICE || (product.PRICE >= priceRange[0] && product.PRICE <= priceRange[1]);

      // Return true only if all filters pass
      return categoryMatch && brandMatch && seasonMatch && styleTagMatch && priceMatch;
    });
  }, [
    products, 
    categoryFilters, 
    brandFilters, 
    seasonFilters, 
    styleTagFilters, 
    priceRange
  ]);

  // Paginate products
  const paginatedProducts = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return filteredProducts.slice(startIndex, endIndex);
  }, [filteredProducts, currentPage]);

  // Page change handler
  const handlePageChange = (pageNumber) => {
    const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
    
    // Ensure page number is within valid range
    if (pageNumber >= 1 && pageNumber <= totalPages) {
      setCurrentPage(pageNumber);
    }
  };

  // Toggle product status
  const toggleProductStatus = (index) => {
    const updatedProducts = [...products];
    updatedProducts[index].status = !updatedProducts[index].status;
    setProducts(updatedProducts);
  };

  // Clear all filters
  const clearAllFilters = () => {
    setCategoryFilters(prev => prev.map(f => ({ ...f, checked: false })));
    setBrandFilters(prev => prev.map(f => ({ ...f, checked: false })));
    setSeasonFilters(prev => prev.map(f => ({ ...f, checked: false })));
    setStyleTagFilters(prev => prev.map(f => ({ ...f, checked: false })));
    setPriceRange([0, 200]);
  };

  return (
    <div className="flex flex-col gap-6 p-6 bg-gray-50">
      <div className="flex gap-6 h-[calc(100vh-8rem)]">
        <ProductFilterSection 
          isLoading={isLoading}
          categoryFilters={categoryFilters}
          brandFilters={brandFilters}
          seasonFilters={seasonFilters}
          styleTagFilters={styleTagFilters}
          priceRange={priceRange}
          toggleFilterItem={toggleFilterItem}
          setCategoryFilters={setCategoryFilters}
          setBrandFilters={setBrandFilters}
          setSeasonFilters={setSeasonFilters}
          setStyleTagFilters={setStyleTagFilters}
          setPriceRange={setPriceRange}
          clearAllFilters={clearAllFilters}
        />

        <div className="overflow-y-auto flex-1 p-5 bg-white rounded-lg scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
          <ProductSearchBar />
          <ProductActionButtons />

          <ProductTable 
            products={paginatedProducts} 
            onToggleStatus={toggleProductStatus} 
            currentPage={currentPage} 
            itemsPerPage={itemsPerPage} 
            totalItems={filteredProducts.length} 
            onPageChange={handlePageChange} 
            currentPage={currentPage}
          />
        </div>
      </div>
    </div>
  );
};

export default ProductView;
