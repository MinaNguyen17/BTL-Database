import React, { useState, useEffect } from 'react';
import "./empInfo.css"
import  EmployeeService  from "@/services/employeeService";
import {accountService} from "@/services/accountService";
import { toast } from "sonner";

const EmployeeInfo = () => {
    
  const [isEditing, setIsEditing] = useState(false);
  const [user, setUser] = useState({
    idCardNum: '',
    fname: '',
    lname: '',
    position: '',
    password: '********',
    avatar: 'src/assets/empAvatar/default.jpg', // Default avatar
  });
  const [payroll, setPayroll] = useState([]);

  useEffect(() => {
    const fetchUserInfo = async () => {
      try {
        // const idCardNum = localStorage.getItem('ID_Card_Num');
        const idCardNum = localStorage.getItem('UserID');
        console.log('User ID:', idCardNum);

        if (!idCardNum) {
          toast.error('No user ID found. Please log in.');
          return;
        }

        // const userData = await accountService.getAccountById(idCardNum);
        
        // setUser({
        //   idCardNum: userData.ID_Card_Num || '',
        //   fname: userData.Fname || '',
        //   lname: userData.Lname || '',
        //   position: userData.Position || '',
        //   password: '********',
        //   avatar: userData.avatar || 'src/assets/empAvatar/default.jpg'
        // });

        // Fetch salary data
        
        const salaryData = await EmployeeService.getSalary(idCardNum.toString());
        console.log('Salary Data:', salaryData);
        // Transform salary data for display
        const formattedPayroll = salaryData.map(salary => ({
          month: new Date(salary.Year, salary.Month - 1).toLocaleString('default', { month: 'long' }),
          salary: salary.Amount,
          year: salary.Year
        }));

        setPayroll(formattedPayroll);
      } catch (error) {
        console.error('Error fetching user info:', error);
        toast.error('Failed to fetch user information');
      }
    };

    fetchUserInfo();
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setUser((prevUser) => ({
      ...prevUser,
      [name]: value,
    }));
  };

  const toggleEdit = async () => {
    if (isEditing) {
      try {
        // Implement password change logic
        await accountService.changePassword({
          ID_Card_Num: user.idCardNum,
          newPassword: user.password
        });
        toast.success('Password updated successfully');
      } catch (error) {
        console.error('Password change error:', error);
        toast.error('Failed to update password');
      }
    }
    setIsEditing((prev) => !prev);
  };

  return (
    <div className="account-view">
      <div className="account-section">
        
        <div className="account-image">
          <img
            src={user.avatar || 'src/assets/empAvatar/default.jpg'}
            alt="User Avatar"
            className="account-avatar"
          />
        </div>
        <div className="account-info">
        <h2>Employee's Information</h2>
          <label className="account-label">ID Card Number:</label>
          <input
            type="text"
            name="idCardNum"
            value={user.idCardNum}
            onChange={handleInputChange}
            disabled={true}
            className="account-input"
          />

          <label className="account-label">First Name:</label>
          <input
            type="text"
            name="fname"
            value={user.fname}
            onChange={handleInputChange}
            disabled={true}
            className="account-input"
          />

          <label className="account-label">Last Name:</label>
          <input
            type="text"
            name="lname"
            value={user.lname}
            onChange={handleInputChange}
            disabled={true}
            className="account-input"
          />

          <label className="account-label">Position:</label>
          <input
            type="text"
            name="position"
            value={user.position}
            onChange={handleInputChange}
            disabled={true}
            className="account-input"
          />

          <label className="account-label">Password:</label>
          <input
            type="password"
            name="password"
            value={user.password}
            onChange={handleInputChange}
            disabled={!isEditing}
            className="account-input"
          />

          <button onClick={toggleEdit} className="edit-button">
            {isEditing ? 'Save' : 'Change Password'}
          </button>
        </div>
      </div>

    {/* Payroll Section */}
      <div className="payroll-section">
        <h2 style={{textAlign: 'center'}}>Payroll</h2>
        <table className="payroll-table">
          <thead>
            <tr>
              <th>Month</th>
              <th>Year</th>
              <th>Salary</th>
            </tr>
          </thead>
          <tbody>
            {payroll.map((entry, index) => (
              <tr key={index}>
                <td>{entry.month}</td>
                <td>{entry.year}</td>
                <td>${entry.salary.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default EmployeeInfo;