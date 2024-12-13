import React, { useState, useMemo, useEffect } from 'react';
import EmployeeService from '../../services/employeeService';
import ProductFilterSection from './components/ProductFilterSection';
import ProductSearchBar from './components/ProductSearchBar';
import ProductActionButtons from './components/ProductActionButtons';
import ProductTable from './components/ProductTable';

const EmployeeView = () => {
  // Price range state - moved before other states
  const [priceRange, setPriceRange] = useState([0, 200]);
  
  const [employees, setEmployees] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  // State for filter items
  const [positionFilters, setPositionFilters] = useState([]);
  const [sexFilters, setSexFilters] = useState([]);

  // Sorting state
  const [sortConfig, setSortConfig] = useState({
    key: null,
    direction: 'ascending'
  });

  // State for pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  useEffect(() => {
    const fetchEmployees = async () => {
      try {
        setIsLoading(true);
        const fetchedEmployees = searchTerm 
          ? await EmployeeService.searchEmployeeById(searchTerm)
          : await EmployeeService.getAllEmployees();
        
        console.log('Fetched Employees:', fetchedEmployees);
        setEmployees(fetchedEmployees);

        // Generate unique filter categories dynamically
        const uniquePositions = [...new Set(fetchedEmployees.map(e => e.Position).filter(Boolean))];
        const uniqueSexes = [...new Set(fetchedEmployees.map(e => e.Sex).filter(Boolean))];

        // Initialize filter states with all items checked
        setPositionFilters(uniquePositions.map((position, index) => ({
          id: `position-${index}`,
          label: position,
          checked: true
        })));

        setSexFilters(uniqueSexes.map((sex, index) => ({
          id: `sex-${index}`,
          label: sex,
          checked: true
        })));

        setIsLoading(false);
      } catch (err) {
        console.error('Failed to fetch employees:', err);
        setIsLoading(false);
        setEmployees([]); // Clear employees on error
      }
    };

    fetchEmployees();
  }, [searchTerm]);

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

  // Handle sorting
  const handleSort = (key) => {
    let direction = 'ascending';
    if (sortConfig.key === key && sortConfig.direction === 'ascending') {
      direction = 'descending';
    }
    setSortConfig({ key, direction });
  };

  // Handle search
  const handleSearch = (term) => {
    setSearchTerm(term);
    setCurrentPage(1); // Reset to first page when searching
  };

  // Filter employees based on selected filters
  const filteredEmployees = useMemo(() => {
    if (!employees.length) return [];

    return employees.filter(employee => {
      // Check if employee passes position filter
      const positionMatch = positionFilters.length === 0 || 
        positionFilters.some(pos => pos.checked && pos.label === employee.Position);

      // Check if employee passes sex filter
      const sexMatch = sexFilters.length === 0 || 
        sexFilters.some(sex => sex.checked && sex.label === employee.Sex);

      return positionMatch && sexMatch;
    });
  }, [employees, positionFilters, sexFilters]);

  // Sort employees
  const sortedEmployees = useMemo(() => {
    let sortableEmployees = [...filteredEmployees];
    if (sortConfig.key !== null) {
      sortableEmployees.sort((a, b) => {
        if (a[sortConfig.key] < b[sortConfig.key]) {
          return sortConfig.direction === 'ascending' ? -1 : 1;
        }
        if (a[sortConfig.key] > b[sortConfig.key]) {
          return sortConfig.direction === 'ascending' ? 1 : -1;
        }
        return 0;
      });
    }
    return sortableEmployees;
  }, [filteredEmployees, sortConfig]);

  // Pagination logic
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentEmployees = sortedEmployees.slice(indexOfFirstItem, indexOfLastItem);

  // Change page
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  return (
    <div className="flex flex-col gap-6 p-6 bg-gray-50">
      <div className="flex gap-6 h-[calc(100vh-8rem)]">
        <ProductFilterSection 
          isLoading={isLoading}
          positionFilters={positionFilters}
          sexFilters={sexFilters}
          toggleFilterItem={toggleFilterItem}
          setPositionFilters={setPositionFilters}
          setSexFilters={setSexFilters}
        />

        <div className="overflow-y-auto flex-1 p-5 bg-white rounded-lg scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
          <ProductSearchBar 
            data={sortedEmployees}
            searchKeys={['ID_Card_Num']}
            onSearch={handleSearch}
          />
          <ProductActionButtons />

          <ProductTable 
            data={currentEmployees} 
            isLoading={isLoading}
            currentPage={currentPage}
            itemsPerPage={itemsPerPage}
            totalItems={sortedEmployees.length}
            paginate={paginate}
            sortConfig={sortConfig}
            onSort={handleSort}
          />
        </div>
      </div>
    </div>
  );
};

export default EmployeeView;
