import React, { useState } from 'react';
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search } from 'lucide-react';

const ProductSearchBar = ({ 
  data, 
  searchKeys = ['ID_Card_Num'], 
  onSearch 
}) => {
  const [searchTerm, setSearchTerm] = useState('');

  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };

  const handleSearchSubmit = () => {
    // Trigger search in parent component, focusing on ID search
    onSearch(searchTerm);
  };

  // Optional: Filter data for local preview (not used for API search)
  const filteredData = data.filter(item => 
    searchKeys.some(key => 
      item[key] && 
      item[key].toString().toLowerCase().includes(searchTerm.toLowerCase())
    )
  );

  return (
    <div className="flex gap-4 mb-6">
      <div className="relative flex-grow">
        <Input 
          type="text" 
          placeholder="Search by Employee ID" 
          className="max-w-md pr-10"
          value={searchTerm}
          onChange={handleSearchChange}
          onKeyPress={(e) => e.key === 'Enter' && handleSearchSubmit()}
        />
        <Button 
          variant="ghost" 
          size="icon" 
          className="absolute right-0 top-1/2 -translate-y-1/2"
          onClick={handleSearchSubmit}
        >
          <Search className="h-5 w-5 text-gray-500" />
        </Button>
      </div>
      <Button variant="outline" className="gap-2">
        <span className="text-lg">⋮</span>
        Bulk Action
      </Button>
      <Button variant="ghost" className="gap-2">
        <span>↓</span>
        Export Employees
      </Button>
      <Button className="gap-2 bg-primary hover:bg-primary/90">
        <span>+</span>
        Add Employee
      </Button>
    </div>
  );
};

export default ProductSearchBar;
