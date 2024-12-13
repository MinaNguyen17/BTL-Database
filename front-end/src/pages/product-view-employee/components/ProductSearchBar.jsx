import React from 'react';
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const ProductSearchBar = () => {
  return (
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
      <Button className="gap-2 bg-primary hover:bg-primary/90">
        <span>+</span>
        Add Product
      </Button>
    </div>
  );
};

export default ProductSearchBar;
