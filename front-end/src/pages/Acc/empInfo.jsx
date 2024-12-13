import React, { useState } from 'react';
import "./empInfo.css"

const EmployeeInfo = () => {
    
  const [isEditing, setIsEditing] = useState(false);
  const [user, setUser] = useState({
    idCardNum: '123456789',
    fname: 'Go',
    lname: 'Min SiSi',
    position: 'Software Engineer',
    password: '********',
    avatar: 'src/assets/empAvatar/gominsi.jpg', // Default avatar
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setUser((prevUser) => ({
      ...prevUser,
      [name]: value,
    }));
  };
  const [payroll, setPayroll] = useState([
    { month: 'January', salary: 5000 },
    { month: 'February', salary: 5000 },
    { month: 'March', salary: 5000 },
    { month: 'April', salary: 5000 },
  ]);

  const toggleEdit = () => {
    setIsEditing((prev) => !prev);
  };

  return (
    <div className="account-view">
      <div className="account-section">
        
        <div className="account-image">
          <img
            src={user.avatar || 'src/assets/empAvatar/gominsi.jpg'}
            alt="User Avatar"
            className="account-avatar"
          />
        </div>
        <div className="account-info">
        <h2>Employee's Infomation</h2>
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
              <th>Salary</th>
            </tr>
          </thead>
          <tbody>
            {payroll.map((entry, index) => (
              <tr key={index}>
                <td>{entry.month}</td>
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

// AccountView.css
/*
.account-view {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  background-color: #f9f9f9;
  font-family: Arial, sans-serif;
}

.account-section {
  display: flex;
  width: 100%;
  max-width: 800px;
  margin-bottom: 20px;
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.account-image {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.account-avatar {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  object-fit: cover;
}

.account-info {
  flex: 2;
  padding-left: 20px;
}

.account-name {
  font-size: 1.8rem;
  margin-bottom: 10px;
}

.account-email,
.account-phone,
.account-address {
  font-size: 1rem;
  margin: 5px 0;
  color: #555;
}

.account-salary {
  width: 100%;
  max-width: 800px;
  background: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.salary-title {
  font-size: 1.5rem;
  margin-bottom: 15px;
}

.salary-table {
  width: 100%;
  border-collapse: collapse;
}

.salary-table th,
.salary-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: left;
}

.salary-table th {
  background-color: #f4f4f4;
}
*/