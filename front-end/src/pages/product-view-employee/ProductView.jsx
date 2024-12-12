import React, { useState, useMemo } from 'react';
import { ChevronDown, ChevronRight } from 'lucide-react';
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import { Switch } from "@/components/ui/switch";

// Custom hook for managing filter state
const useFilterState = (initialItems) => {
  const [items, setItems] = useState(initialItems);

  const toggleItem = (id) => {
    setItems(prevItems => 
      prevItems.map(item => 
        item.id === id 
          ? { ...item, checked: !item.checked }
          : item
      )
    );
  };

  const resetItems = () => {
    setItems(prevItems => 
      prevItems.map(item => ({ ...item, checked: false }))
    );
  };

  const selectedItems = useMemo(() => 
    items.filter(item => item.checked), 
    [items]
  );

  return { 
    items, 
    toggleItem, 
    resetItems, 
    selectedItems 
  };
};

// Reusable CollapsibleFilter component
const CollapsibleFilter = ({ title, items, onToggle }) => {
  const [isOpen, setIsOpen] = useState(true);

  return (
    <div className="space-y-2">
      <div 
        className="flex items-center justify-between cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        <h3 className="font-medium">{title}</h3>
        {isOpen ? <ChevronDown className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
      </div>
      {isOpen && (
        <div className="space-y-2">
          {items.map((item) => (
            <div key={item.id} className="flex items-center gap-2">
              <Checkbox 
                id={item.id}
                checked={item.checked}
                onCheckedChange={() => onToggle(item.id)}
              />
              <label htmlFor={item.id}>{item.label}</label>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

// Product Table Component
const ProductTable = ({ products, onToggleStatus }) => {
  return (
    <div className="bg-white rounded-lg">
      <table className="w-full">
        <thead>
          <tr className="border-b">
            <th className="text-left p-4">ID</th>
            <th className="text-left p-4">Product</th>
            <th className="text-left p-4">Total Buyer</th>
            <th className="text-left p-4">Price</th>
            <th className="text-left p-4">Stock</th>
            <th className="text-left p-4">Status</th>
          </tr>
        </thead>
        <tbody>
          {products.map((product, index) => (
            <tr 
              key={index} 
              className={`
                ${index % 2 === 0 ? 'bg-[#FAFCF3]' : 'bg-white'}
                ${product.isEditing ? 'pointer-events-none opacity-50' : ''}
              `}
            >
              <td className="p-4">{product.id}</td>
              <td className="p-4">{product.name}</td>
              <td className="p-4">{product.totalBuyers}</td>
              <td className="p-4">${product.price.toFixed(2)}</td>
              <td className="p-4">{product.stock}</td>
              <td className="p-4">
                <div className="flex items-center gap-2">
                  <Switch 
                    checked={product.status} 
                    onCheckedChange={() => onToggleStatus(index)}
                  />
                  <span className=''>{product.status ? 'Active' : 'Inactive'}</span>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <div className="p-4 flex justify-between items-center border-t">
        <span className="text-sm text-gray-500">Showing 1 to 10 of 10 entries</span>
        <div className="flex gap-2">
          <Button variant="outline" size="sm">1</Button>
          <Button variant="ghost" size="sm">2</Button>
          <Button variant="ghost" size="sm">...</Button>
          <Button variant="ghost" size="sm">9</Button>
          <Button variant="ghost" size="sm">10</Button>
          <Button variant="ghost" size="sm">→</Button>
        </div>
      </div>
    </div>
  );
};

const ProductView = () => {
  // Initial state for products
  const [products, setProducts] = useState(
    Array(8).fill(null).map((_, index) => ({
      id: `P${909 + index}`,
      name: 'bodycare',
      totalBuyers: 2456,
      price: 34.00,
      stock: 249,
      status: true
    }))
  );

  // Use custom hook for filter states
  const categoriesFilter = useFilterState([
    { id: 'category1', label: 'Category 1', checked: false },
    { id: 'category2', label: 'Category 2', checked: false },
    { id: 'category4', label: 'Category 4', checked: true }
  ]);

  const brandsFilter = useFilterState([
    { id: 'brandA', label: 'Brand A', checked: false },
    { id: 'brandB', label: 'Brand B', checked: false },
    { id: 'brandE', label: 'Brand E', checked: true }
  ]);

  const seasonsFilter = useFilterState([
    { id: 'spring', label: 'Spring', checked: false },
    { id: 'summer', label: 'Summer', checked: false },
    { id: 'autumn', label: 'Autumn', checked: false },
    { id: 'winter', label: 'Winter', checked: false }
  ]);

  const styleTagsFilter = useFilterState([
    { id: 'casual', label: 'Casual', checked: false },
    { id: 'formal', label: 'Formal', checked: false },
    { id: 'sporty', label: 'Sporty', checked: false },
    { id: 'elegant', label: 'Elegant', checked: false }
  ]);

  // Price range state
  const [priceRange, setPriceRange] = useState([0, 200]);

  // Toggle product status
  const toggleProductStatus = (index) => {
    const updatedProducts = [...products];
    updatedProducts[index].status = !updatedProducts[index].status;
    setProducts(updatedProducts);
  };

  // Clear all filters
  const clearAllFilters = () => {
    categoriesFilter.resetItems();
    brandsFilter.resetItems();
    seasonsFilter.resetItems();
    styleTagsFilter.resetItems();
    setPriceRange([0, 200]);
  };

  return (
    <div className="flex bg-gray-50 flex-col p-6 gap-6">
      <h1 className="text-2xl font-semibold">Product</h1>

      <div className="flex gap-6 h-[calc(100vh-8rem)]">
        {/* Filters Section - Static Sidebar */}
        <div className="w-54 bg-white p-5 pt-0 rounded-lg flex flex-col gap-4 overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100 max-h-full">
          <div className="flex items-center justify-between sticky top-0 bg-white z-10">
            <h2 className="text-lg font-medium">Filter By</h2>
            <Button 
              variant="ghost" 
              size="icon" 
              onClick={clearAllFilters}
            >
              <img src="/refresh.svg" alt="refresh" className="w-5 h-5" />
            </Button>
          </div>

          <div className="flex flex-col gap-4 pb-4">
            <CollapsibleFilter 
              title="Category" 
              items={categoriesFilter.items} 
              onToggle={categoriesFilter.toggleItem} 
            />

            <CollapsibleFilter 
              title="Brand" 
              items={brandsFilter.items} 
              onToggle={brandsFilter.toggleItem} 
            />

            <CollapsibleFilter 
              title="Season" 
              items={seasonsFilter.items} 
              onToggle={seasonsFilter.toggleItem} 
            />

            <CollapsibleFilter 
              title="Style Tag" 
              items={styleTagsFilter.items} 
              onToggle={styleTagsFilter.toggleItem} 
            />

            <div className="space-y-2">
              <h3 className="font-medium">Price</h3>
              <div className="space-y-4">
                <input
                  type="range"
                  min="0"
                  max="200"
                  className="w-full"
                  value={priceRange[1]}
                  onChange={(e) => setPriceRange([priceRange[0], parseInt(e.target.value)])}
                />
                <div className="flex justify-between gap-4">
                  <Input 
                    type="number" 
                    placeholder="Min" 
                    value={priceRange[0]}
                    onChange={(e) => setPriceRange([parseInt(e.target.value), priceRange[1]])}
                    className="w-24"
                  />
                  <Input 
                    type="number" 
                    placeholder="Max" 
                    value={priceRange[1]}
                    onChange={(e) => setPriceRange([priceRange[0], parseInt(e.target.value)])}
                    className="w-24"
                  />
                </div>
                <Button className="w-full bg-primary hover:bg-primary/90">Apply</Button>
              </div>
            </div>
          </div>
        </div>

        {/* Product Table Section - Scrollable */}
        <div className="flex-1 bg-white rounded-lg p-5 overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
          <div className="flex gap-4 mb-6">
            <Input 
              type="text" 
              placeholder="Search Product" 
              className="max-w-md"
            />
            <Button variant="outline" className="gap-2">
              <span className="text-lg">⋮</span>
              Bulk Action
            </Button>
            <Button variant="ghost" className="gap-2">
              <span>↓</span>
              Export Product
            </Button>
            <Button className="bg-primary hover:bg-primary/90 gap-2">
              <span>+</span>
              Add Product
            </Button>
          </div>

          <div className="flex gap-4 mb-6">
            <Button variant="ghost" className="hover:bg-[#8B9B7E]/10">All Product</Button>
            <Button variant="ghost" className="hover:bg-[#8B9B7E]/10">Live</Button>
            <Button variant="ghost" className="hover:bg-[#8B9B7E]/10">Archive</Button>
            <Button variant="ghost" className="hover:bg-[#8B9B7E]/10">Out of stock</Button>
          </div>

          <ProductTable 
            products={products} 
            onToggleStatus={toggleProductStatus} 
          />
        </div>
      </div>
    </div>
  );
};

export default ProductView;
