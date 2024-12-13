import React, { useState } from 'react';
import { ChevronDown, ChevronRight } from 'lucide-react';
import { Checkbox } from "@/components/ui/checkbox";
import { Skeleton } from "@/components/ui/skeleton";

const CollapsibleFilter = ({ title, items, onToggle, isLoading = false }) => {
  const [isOpen, setIsOpen] = useState(true);

  if (isLoading) {
    return (
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
    );
  }

  return (
    <div className="space-y-2">
      <div 
        className="flex justify-between items-center cursor-pointer"
        onClick={() => setIsOpen(!isOpen)}
      >
        <h3 className="font-medium">{title}</h3>
        {isOpen ? <ChevronDown /> : <ChevronRight />}
      </div>
      {isOpen && (
        <div className="space-y-2">
          {items.map((item) => (
            <div key={item.id} className="flex items-center space-x-2">
              <Checkbox 
                id={`filter-${item.id}`}
                checked={item.checked}
                onCheckedChange={() => onToggle(item.id)}
              />
              <label 
                htmlFor={`filter-${item.id}`}
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
              >
                {item.label}
              </label>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default CollapsibleFilter;
