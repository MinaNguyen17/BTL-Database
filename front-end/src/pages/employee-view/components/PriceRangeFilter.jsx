import React from 'react';
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const PriceRangeFilter = ({ priceRange, setPriceRange }) => {
  return (
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
        <div className="flex gap-4 justify-between">
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
        <Button 
          className="w-full bg-primary hover:bg-primary/90"
          onClick={() => setPriceRange([0, 200])}
        >
          Reset Price
        </Button>
      </div>
    </div>
  );
};

export default PriceRangeFilter;
