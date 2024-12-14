import axiosInstance from '@/utils/axiosInstance';

const EmployeeService = {
  // Get all employees
  getAllEmployees: async () => {
    try {
      const response = await axiosInstance.get('/employee/all');
      return response.data;
    } catch (error) {
      console.error('Error fetching employees:', error);
      throw error;
    }
  },

  // Search employees by ID
  searchEmployeeById: async (idCardNum) => {
    try {
      const response = await axiosInstance.get(`/employee/${idCardNum}`);
      // If the API returns a single employee, wrap it in an array
      return Array.isArray(response.data) ? response.data : [response.data];
    } catch (error) {
      console.error('Error searching employee by ID:', error);
      // Return empty array if no employee found
      if (error.response && error.response.status === 404) {
        return [];
      }
      throw error;
    }
  },

  // Get employee by ID
  getEmployeeById: async (employeeId) => {
    try {
      const response = await axiosInstance.get(`/employee/${employeeId}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching employee:', error);
      throw error;
    }
  },

  // Add a new employee
  addEmployee: async (employeeData) => {
    try {
      const response = await axiosInstance.post('/employee', employeeData);
      return response.data;
    } catch (error) {
      console.error('Error adding employee:', error);
      throw error;
    }
  },

  // Update an existing employee
  updateEmployee: async (employeeData) => {
    try {
      const response = await axiosInstance.put('/employee', employeeData);
      return response.data;
    } catch (error) {
      console.error('Error updating employee:', error);
      throw error;
    }
  },

  // Get salary information for an employee
  getSalary: async (idCardNum, year = new Date().getFullYear()) => {
    try {
      console.log('Fetching salary for ID:', idCardNum);
      const response = await axiosInstance.get(`/employee/salary/${idCardNum}`);
      
      console.log('Salary response:', response.data);
      
      // Transform salary data to a more readable format
      const salaries = response.data.salaries.map(salary => ({
        employeeId: salary.Employee_ID,
        month: salary.Month,
        year: salary.Year,
        amount: salary.Amount,
        position: salary.Position
      }));

      return {
        idCardNum: idCardNum,
        salaries: salaries
      };
    } catch (error) {
      console.error('Error fetching salary information:', error);
      
      // Handle specific error cases
      if (error.response && error.response.status === 404) {
        return {
          idCardNum: idCardNum,
          salaries: [],
          error: 'No salary information found'
        };
      }
      
      throw error;
    }
  }
};

export default EmployeeService;
