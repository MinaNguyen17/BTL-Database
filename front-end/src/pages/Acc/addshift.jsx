import React, { useState, useEffect } from "react";
import axiosInstance from "@/utils/axiosInstance";
import "./addshift.css";

function EmpShift() {
  const [hoveredData, setHoveredData] = useState(null);
  const [hoverPosition, setHoverPosition] = useState({ x: 0, y: 0 });
  const [currentWeekStart, setCurrentWeekStart] = useState(new Date("2024-12-16")); // Start from Monday
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [timetableData, setTimetableData] = useState([
    // Initial dummy data
  ]);

  
 // Fetch shift data from API
   useEffect(() => {
     const fetchShifts = async () => {
       try {
         const response = await axiosInstance.get("/shift/all");
         if (response.data) {
           const fetchedShifts = response.data.map((shift) => ({
             shift: {
               Shift_ID: shift.Shift_ID,
               Shift_Type: shift.Shift_Type,
               Date: shift.Date,
               E_Num: shift.E_Num,
               Rate: shift.Rate,
             },
             employees: [], // Employees sẽ được lấy khi hover
             label: `Shift ${shift.Shift_Type}`,
             color: "blue", // Màu mặc định cho các block
           }));
           setTimetableData(fetchedShifts);
         }
       } catch (err) {
         console.error("Failed to fetch shifts:", err.message);
       }
     };
     fetchShifts();
   }, []);

  


  const daysOfWeek = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
  const hours = Array.from({ length: 17 }, (_, index) => `${7 + index}:00`); // Time slots from 7:00 to 23:00

  const calculateRowSpan = (startTime, endTime) => {
    const [startHour, startMinute] = startTime.split(":");
    const [endHour, endMinute] = endTime.split(":");
    return (parseInt(endHour) * 60 + parseInt(endMinute) - (parseInt(startHour) * 60 + parseInt(startMinute))) / 60;
  };

  const calculateGridRow = (startTime) => {
    const [hour] = startTime.split(":");
    return parseInt(hour) - 7 + 1;
  };

  const getShiftTimes = (shiftType) => {
    switch (shiftType) {
      case "1":
        return { startTime: "7:00", endTime: "12:00" }; // Shift 1: 7:00 - 12:00
      case "2":
        return { startTime: "12:00", endTime: "17:00" }; // Shift 2: 12:00 - 17:00
      case "3":
        return { startTime: "17:00", endTime: "22:00" }; // Shift 3: 17:00 - 22:00
      default:
        return { startTime: "", endTime: "" };
    }
  };

  const [newShift, setNewShift] = useState({
    label: "",
    startTime: "",
    endTime: "",
    date: "",
    employees: [],
    E_Num: 0,  // Number of employees
    Rate: 1,   // Shift rate
  });

  // Handle form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewShift((prev) => ({ ...prev, [name]: value }));
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault(); // Ngăn chặn hành vi mặc định của form
  
    try {
      // Chuẩn bị dữ liệu gửi đi
      const shiftData = {
        Shift_Type: newShift.label,
        S_Date: newShift.date,
        E_Num: parseInt(newShift.E_Num, 10),
        Rate: parseFloat(newShift.Rate),
      };
      console.log(shiftData);
  
      // Gửi yêu cầu POST tới API
      const response = await axiosInstance.post("/shift", shiftData);
  
      // Kiểm tra phản hồi từ API
      if (response?.data?.shift) {
        const addedShift = response.data.shift;
  
        // Chuẩn bị dữ liệu mới để thêm vào timetable
        const newShiftEntry = {
          shift: {
            Shift_ID: addedShift.Shift_ID,
            Shift_Type: addedShift.Shift_Type,
            Date: addedShift.Date,
            E_Num: addedShift.E_Num,
            Rate: addedShift.Rate,
          },
          employees: [], // Danh sách nhân viên ban đầu là rỗng
          label: `Shift ${addedShift.Shift_Type}`,
          color: "blue", // Màu mặc định
        };
  
        // Cập nhật state với dữ liệu mới
        setTimetableData((prev) => [...prev, newShiftEntry]);
  
        // Reset form về trạng thái ban đầu
        setNewShift({ label: "", date: "", E_Num: 0, Rate: 1 });
  
        // Thông báo thành công
        alert("Shift has been successfully added.");
      } else {
        // Xử lý trường hợp phản hồi không mong muốn
        throw new Error("Unexpected response from the server.");
      }
    } catch (error) {
      // Bắt lỗi và hiển thị thông báo
      console.error("Error creating shift:", error.message);
      alert("Failed to add shift. Please try again.");
    }
  };
  const [upShift, setupShift] = useState({
      ID: "", // Shift_ID
      E_Num: 0,  // Number of employees
      Rate: 1,   // Shift rate
    });
    
  
    // Handle form input changes
    const handleInputChangeU = (e) => {
      const { name, value } = e.target;
      setupShift((prevState) => ({
        ...prevState,
        [name]: value, // Gán giá trị từ trường nhập liệu
      }));
    };
  const handleSubmitChange = async (e) => {
    e.preventDefault(); // Ngăn chặn hành vi mặc định của form
  
    try {
      // Chuẩn bị dữ liệu gửi đi
      const shiftData = {
        Shift_ID: upShift.id,
        E_Num: parseInt(upShift.E_Num, 10),
        Rate: parseFloat(upShift.Rate),
      };
      console.log(shiftData);
  
      // Gửi yêu cầu POST tới API
      const response = await axiosInstance.post("/shift", shiftData);
  
      // Kiểm tra phản hồi từ API
      if (response?.data?.shift) {
        const addedShift = response.data.shift;
  
        
  
        // Reset form về trạng thái ban đầu
        setNewShift({ label: "", date: "", E_Num: 0, Rate: 1 });
  
        // Thông báo thành công
        alert("Shift has been successfully added.");
      } else {
        // Xử lý trường hợp phản hồi không mong muốn
        throw new Error("Unexpected response from the server.");
      }
    } catch (error) {
      // Bắt lỗi và hiển thị thông báo
      console.error("Error creating shift:", error.message);
      alert("Failed to add shift. Please try again.");
    }
  };
  const fetchShiftDetails = async (shiftId) => {
      try {
        const response = await axiosInstance.get(`/shift/${shiftId}`);
        if (response.data) {
          return response.data; // Trả về dữ liệu chi tiết của shift
        }
      } catch (err) {
        console.error("Failed to fetch shift details:", err.message);
        return null;
      }
    };

  const getCurrentShift = (currentDate) => {
    const currentDateObj = new Date(currentDate);
    const formattedCurrentDate = currentDateObj.toISOString().split("T")[0];

    const todayShift = timetableData.filter((shift) => {
      const shiftDate = new Date(shift.shift.Date).toISOString().split("T")[0];
      return shiftDate === formattedCurrentDate;
    });

    return todayShift.length ? todayShift[0] : null;
  };

  const getDatesForWeek = (startDate) => {
    return Array.from({ length: 7 }, (_, i) => {
      const date = new Date(startDate);
      date.setDate(date.getDate() + i);
      return date;
    });
  };

  const handleWeekChange = (direction) => {
    const newStartDate = new Date(currentWeekStart);
    newStartDate.setDate(newStartDate.getDate() + direction * 7);
    setCurrentWeekStart(newStartDate);
  };

  const handleMouseEnter = async (e, data) => {
    const shiftDetails = await fetchShiftDetails(data.shift.Shift_ID); // Lấy chi tiết shift
    if (shiftDetails) {
      setHoveredData({
        shift: shiftDetails.shift,
        employees: shiftDetails.employees,
      });
      setHoverPosition({ x: e.clientX + 15, y: e.clientY + 15 });
    }
  };

  const handleMouseLeave = () => {
    setHoveredData(null);
  };

  const currentWeekDates = getDatesForWeek(currentWeekStart);

  return (
    <div className="scontainer">
      <div className="timetable-container">
        <div className="timetable">
          <div className="week-names">
            {currentWeekDates.map((date, index) => (
              <div key={index} className={index >= 5 ? "weekend" : ""}>
                {daysOfWeek[index]} ({date.toLocaleDateString()})
              </div>
            ))}
          </div>

          <div className="time-interval">
            {hours.map((hour, index) => (
              <div key={index}>{hour}</div>
            ))}
          </div>

          <div className="content">
  {daysOfWeek.map((day, dayIndex) => {
    const currentDate = currentWeekDates[dayIndex].toISOString().split("T")[0];
    return timetableData
      .filter((item) => item.shift.Date.split("T")[0] === currentDate)
      .map((data, index) => {
        const { startTime, endTime } = getShiftTimes(data.shift.Shift_Type);
        return (
          <div
            key={index}
            className={`cell accent-${data.color}-gradient`}
            style={{
              gridRow: `${calculateGridRow(startTime)} / span ${calculateRowSpan(startTime, endTime)}`,
              gridColumn: dayIndex + 1,
            }}
            onMouseEnter={(e) => handleMouseEnter(e, data)}
            onMouseLeave={handleMouseLeave}
          >
            <span>{data.label}</span>
          </div>
        );
      });
  })}
</div>

{hoveredData && (
  <div
    className="hover-box"
    style={{ top: `${hoverPosition.y}px`, left: `${hoverPosition.x}px` }}
  >
    <p><strong>Shift Type:</strong> {hoveredData.shift.Shift_Type}</p>
    <p><strong>Shift ID:</strong> {hoveredData.shift.Shift_ID}</p>
    <p><strong>Date:</strong> {new Date(hoveredData.shift.Date).toLocaleDateString()}</p>
    <p><strong>Employees:</strong></p>
    <ul>
      {hoveredData.employees.map((employee) => (
        <li key={employee.Employee_ID}>
          {employee.Fname} {employee.Lname} - {employee.Position}
        </li>
      ))}
    </ul>
  </div>
)}
        </div>

        <div className="week-navigation">
          <button onClick={() => handleWeekChange(-1)}>{"<"}</button>
          <button onClick={() => handleWeekChange(1)}>{">"}</button>
        </div>
      </div>

      {/* Create Shift Form */}
      <form onSubmit={handleSubmit} className="shift-form">
        <div>
          <label>Shift Type (1, 2, 3):</label>
          <input
            type="text"
            name="label"
            value={newShift.label}
            onChange={handleInputChange}
            required
          />
        </div>

        <div>
          <label>Date:</label>
          <input
            type="date"
            name="date"
            value={newShift.date}
            onChange={handleInputChange}
            required
          />
        </div>

        <div>
          <label>Employees:</label>
          <input
            type="number"
            name="E_Num"
            value={newShift.E_Num}
            onChange={handleInputChange}
            required
          />
        </div>

        <div>
          <label>Rate:</label>
          <input
            type="number"
            name="Rate"
            value={newShift.Rate}
            onChange={handleInputChange}
            required
          />
        </div>

        <button type="submit">Update Shift</button>
      </form>
      <form onSubmit={handleSubmitChange} className="shift-form">
        <div>
          <label>Shift ID(1, 2, 3):</label>
          <input
            type="number"
            name="id"
            value={upShift.ID}
            onChange={handleInputChangeU}
            required
          />
        </div>

      
        <div>
          <label>Employees:</label>
          <input
            type="number"
            name="E_Num"
            value={newShift.E_Num}
            onChange={handleInputChangeU}
            required
          />
        </div>

        <div>
          <label>Rate:</label>
          <input
            type="number"
            name="Rate"
            value={newShift.Rate}
            onChange={handleInputChangeU}
            required
          />
        </div>

        <button type="submit">Update</button>
      </form>
    </div>
  );
}

export default EmpShift;
