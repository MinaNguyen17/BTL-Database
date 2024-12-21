import React, { useState, useEffect } from "react";
import axiosInstance from "@/utils/axiosInstance";
import "./addshift.css";

function CreateShift() {
  const [hoveredData, setHoveredData] = useState(null);
  const [hoverPosition, setHoverPosition] = useState({ x: 0, y: 0 });
  const [currentWeekStart, setCurrentWeekStart] = useState(new Date("2024-12-16")); // Start from Monday
  const [timetableData, setTimetableData] = useState([]);

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
    ID: "", // Shift_ID
  });
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
  

  // Handle form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewShift((prevState) => ({
      ...prevState,
      [name]: value, // Gán giá trị từ trường nhập liệu
    }));
  };

  // Handle form submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    const idCardNum = localStorage.getItem("UserID");
      if (!idCardNum) {
        console.error("UserID not found in localStorage.");
        return;
      }
  
    try {
      const shiftData = {
        Shift_ID: newShift.ID, // Sử dụng Shift ID từ biểu mẫu
        ID_Card_Num: idCardNum, // ID Card Number có thể được thay thế từ logic của bạn
      };
  
      console.log(shiftData);
      const response = await axiosInstance.post("/shift/add", shiftData);

  
      if (response.status === 200 || response.status === 201) {
        alert("Shift has been successfully added.");
        setNewShift({ ID: "" }); // Reset form
      } else {
        throw new Error("Failed to create shift.");
      }
    } catch (error) {
      console.error("Error creating shift:", error.response?.data || error.message);
      alert(`Failed to add shift: ${error.response?.data?.message || error.message}`);
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
          <label>Shift ID :</label>
          <input
            type="number"
            name="ID"
            value={newShift.ID}
            onChange={handleInputChange}
            required
          />
        </div>


        <button type="submit">Đăng ký Shift</button>
      </form>
    </div>
  );
}

export default CreateShift;
