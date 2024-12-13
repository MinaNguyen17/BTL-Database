import React from 'react';
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import CollapsibleFilter from './CollapsibleFilter';
import PriceRangeFilter from './PriceRangeFilter';

const ProductFilterSection = ({
  isLoading,
  categoryFilters,
  brandFilters,
  seasonFilters,
  styleTagFilters,
  priceRange,
  toggleFilterItem,
  setCategoryFilters,
  setBrandFilters,
  setSeasonFilters,
  setStyleTagFilters,
  setPriceRange,
  clearAllFilters
}) => {
  return (
    <div className="flex overflow-y-auto flex-col gap-4 p-5 pt-0 max-h-full bg-white rounded-lg w-64 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
      <div className="flex sticky top-0 z-10 justify-between items-center bg-white">
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
        {isLoading ? (
          <div className="space-y-2 animate-pulse">
            <div className="flex justify-between items-center">
              <Skeleton className="h-6 w-3/4" />
              <Skeleton className="h-4 w-4" />
            </div>
            <div className="space-y-2">
              {[1, 2, 3, 4].map((_, index) => (
                <div key={index} className="flex items-center space-x-2">
                  <Skeleton className="h-4 w-4 rounded" />
                  <Skeleton className="h-4 w-1/2" />
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div className="space-y-4">
            <CollapsibleFilter 
              title="Category" 
              items={categoryFilters} 
              onToggle={(id) => toggleFilterItem(categoryFilters, setCategoryFilters, id)} 
              isLoading={isLoading}
            />

            <CollapsibleFilter 
              title="Brand" 
              items={brandFilters} 
              onToggle={(id) => toggleFilterItem(brandFilters, setBrandFilters, id)} 
              isLoading={isLoading}
            />

            <CollapsibleFilter 
              title="Season" 
              items={seasonFilters} 
              onToggle={(id) => toggleFilterItem(seasonFilters, setSeasonFilters, id)} 
              isLoading={isLoading}
            />

            <CollapsibleFilter 
              title="Style Tag" 
              items={styleTagFilters} 
              onToggle={(id) => toggleFilterItem(styleTagFilters, setStyleTagFilters, id)} 
              isLoading={isLoading}
            />

            <PriceRangeFilter 
              priceRange={priceRange}
              setPriceRange={setPriceRange}
            />
          </div>
        )}
      </div>
    </div>
  );
};

export default ProductFilterSection;
