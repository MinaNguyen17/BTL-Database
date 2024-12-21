import React, { useState, useEffect} from "react";
import axiosInstance from "@/utils/axiosInstance";
import "./shift.css";

function EmpShift() {
  const [hoveredData, setHoveredData] = useState(null);
  const [hoverPosition, setHoverPosition] = useState({ x: 0, y: 0 });
  const [currentWeekStart, setCurrentWeekStart] = useState(new Date("2024-12-16")); // Bắt đầu từ ngày thứ hai
  const [shiftStatus, setShiftStatus] = useState({}); // Track the checked-in status of each shift
  const [timetableData, setTimetableData] = useState([]);

 // Fetch shift data from API
 useEffect(() => {
  const fetchShifts = async () => {
    try {
      const idCardNum = localStorage.getItem("UserID");
      if (!idCardNum) {
        console.error("UserID not found in localStorage.");
        return;
      }

      const response = await axiosInstance.get(`/shift/view/${idCardNum}`);
      // Kiểm tra nếu API trả về đối tượng có thuộc tính `shifts`
      if (response.data && Array.isArray(response.data.shifts)) {
        // Trích xuất mảng shifts và map dữ liệu
        const fetchedShifts = response.data.shifts.map((shift) => ({
          shift: {
            Shift_ID: shift.Shift_ID,
            Shift_Type: shift.Shift_Type,
            Date: shift.Date,
            E_Num: shift.E_Num,
            Rate: shift.Rate,
          },
          employees: [], // Có thể cập nhật sau
          label: `Shift ${shift.Shift_Type}`,
          color: "blue",
        }));

        setTimetableData(fetchedShifts); // Cập nhật state
      } else {
        console.error("API response does not contain shifts array or is invalid:", response.data);
        setTimetableData([]); // Xử lý khi không có dữ liệu hợp lệ
      }
    } catch (err) {
      console.error("Failed to fetch shifts:", err.message);
      setTimetableData([]); // Xử lý lỗi và đặt giá trị mặc định
    }
  };

  fetchShifts();
}, []);

  const daysOfWeek = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
  const hours = Array.from({ length: 17 }, (_, index) => `${7 + index}:00`); // Time slots from 7:00 to 23:00

  // Function to determine start and end time based on Shift_Type
  const getShiftTimes = (shiftType) => {
    switch (shiftType) {
      case "1":
        return { startTime: "7:00", endTime: "12:00" };
      case "2":
        return { startTime: "12:00", endTime: "17:00" };
      case "3":
        return { startTime: "17:00", endTime: "22:00" };
      default:
        return { startTime: "7:00", endTime: "12:00" }; // Default to type 1 if unknown
    }
  };

  const calculateRowSpan = (startTime, endTime) => {
    const [startHour, startMinute] = startTime.split(":");
    const [endHour, endMinute] = endTime.split(":");
    return (parseInt(endHour) * 60 + parseInt(endMinute) - (parseInt(startHour) * 60 + parseInt(startMinute))) / 60;
  };

  const calculateGridRow = (startTime) => {
    const [hour] = startTime.split(":");
    return parseInt(hour) - 7 + 1;
  };

  const getCurrentShift = (currentDate) => {
    const currentDateObj = new Date(currentDate);
    const formattedCurrentDate = currentDateObj.toISOString().split("T")[0];
  
    const todayShift = timetableData.filter((shift) => {
      // Sử dụng optional chaining để bảo vệ không truy cập vào thuộc tính Date nếu shift hoặc shift.shift không tồn tại
      const shiftDate = shift?.shift?.Date ? new Date(shift.shift.Date).toISOString().split("T")[0] : null;
      return shiftDate === formattedCurrentDate;
    });
  
    return todayShift.length ? todayShift[0] : null; // Return null if no shift found
  };
  

  const getDayOfWeek = (dateStr) => {
    const dateObj = new Date(dateStr);
    const daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    return daysOfWeek[dateObj.getUTCDay()];
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

  const handleMouseEnter = (e, data) => {
    setHoveredData(data);
    setHoverPosition({ x: e.clientX + 15, y: e.clientY + 15 });
  };

  const handleMouseLeave = () => {
    setHoveredData(null);
  };
  const handleClockIn = async (shiftId) => {
    try {
      // Lấy ID_Card_Num từ localStorage
      const idCardNum = localStorage.getItem("UserID");
      if (!idCardNum) {
        console.error("UserID not found in localStorage.");
        return;
      }
  
      // Gửi yêu cầu tới API
      const response = await axiosInstance.post("/shift/checkIn", {
        Shift_ID: shiftId,
        ID_Card_Num: idCardNum,
      });
  
      // Kiểm tra phản hồi từ API
      if (response.status === 200) {
        console.log("Check-in successful:", response.data);
        setShiftStatus((prevState) => ({
          ...prevState,
          [shiftId]: true, // Đánh dấu ca làm việc đã được check-in
        }));
      } else {
        console.error("Check-in failed with status:", response.status);
      }
    } catch (error) {
      console.error("Failed to check-in:", error.response?.data || error.message);
    }
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

    // Kiểm tra timetableData có phải là mảng và chứa dữ liệu hợp lệ
    if (Array.isArray(timetableData) && timetableData.length > 0) {
      return timetableData
        .filter((item) => {
          const shiftDate = item?.shift?.Date ? new Date(item.shift.Date).toISOString().split("T")[0] : null;
          return shiftDate === currentDate;
        })
        .map((data, index) => {
          const { startTime, endTime } = getShiftTimes(data.shift.Shift_Type || "1"); // Mặc định Shift_Type là "1" nếu không tồn tại
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
              <span>{data.label || "No Label"}</span>
            </div>
          );
        });
    } else {
      return null; // Không render gì nếu timetableData không hợp lệ
    }
  })}
</div>


          {hoveredData && (
            <div
              className="hover-box"
              style={{ top: `${hoverPosition.y}px`, left: `${hoverPosition.x}px` }}
            >
              <p><strong>Shift Type: {hoveredData.shift.Shift_Type}</strong></p>
              <p><strong>Shift ID:</strong> {hoveredData.shift.Shift_ID}</p>
            </div>
          )}
        </div>

        {/* Week navigation buttons */}
        <div className="week-navigation">
          <button onClick={() => handleWeekChange(-1)}>{"<"}</button>
          <button onClick={() => handleWeekChange(1)}>{">"}</button>
        </div>
      </div>

      {/* List of shifts (right side of timetable) */}
      <div className="shift-list">
        {currentWeekDates.map((date) => {
          const currentShift = getCurrentShift(date.toISOString().split("T")[0]);
          return currentShift ? (
            <div key={date} className="shift-box">
              <h4>{getDayOfWeek(date.toISOString())}</h4>
              <p><strong>Shift Type:</strong> {currentShift.shift.Shift_Type}</p>
              <p><strong>Employees:</strong></p>
              <ul>
                {currentShift.employees.map((employee) => (
                  <li key={employee.Employee_ID}>
                    {employee.Fname} {employee.Lname} - {employee.Position}
                  </li>
                ))}
              </ul>
              <button
                onClick={() => handleClockIn(currentShift.shift.Shift_ID)}
                disabled={shiftStatus[currentShift.shift.Shift_ID]}
              >
                {shiftStatus[currentShift.shift.Shift_ID] ? "Chấm công thành công" : "Chấm công"}
              </button>
            </div>
          ) : null;
        })}
      </div>
    </div>
  );
}

export default EmpShift;
