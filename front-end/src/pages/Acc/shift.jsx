import React, { useState } from "react";
import "./shift.css";

function EmpShift() {
  const [hoveredData, setHoveredData] = useState(null);
  const [hoverPosition, setHoverPosition] = useState({ x: 0, y: 0 });
  const [currentWeekStart, setCurrentWeekStart] = useState(new Date("2024-12-02")); // Bắt đầu từ ngày thứ hai
  const [shiftStatus, setShiftStatus] = useState({}); // Track the checked-in status of each shift
  const timetableData = [
    {
      shift: {
        Shift_ID: 1,
        Shift_Type: "1", // Shift type 1 is 7:00 - 12:00
        Date: "2024-12-05T00:00:00.000Z",
        E_Num: 2,
        Rate: 1,
      },
      employees: [
        {
          ID_Card_Num: "079203478901",
          Employee_ID: "EMP00002",
          Position: "Senior",
          Wage: 30000,
          Fname: "Tran Van",
          Lname: "Binh",
        },
        {
          ID_Card_Num: "079304008477",
          Employee_ID: "EMP00001",
          Position: "Senior",
          Wage: 35000,
          Fname: "Nguyen Minh",
          Lname: "Hoa",
        },
      ],
      label: "Shift 1",
      color: "green",
    },
    {
      shift: {
        Shift_ID: 2,
        Shift_Type: "2", // Shift type 2 is 12:00 - 17:00
        Date: "2024-12-06T00:00:00.000Z",
        E_Num: 2,
        Rate: 1,
      },
      employees: [
        {
          ID_Card_Num: "079203478901",
          Employee_ID: "EMP00002",
          Position: "Senior",
          Wage: 30000,
          Fname: "Tran Van",
          Lname: "Binh",
        },
        {
          ID_Card_Num: "079304008477",
          Employee_ID: "EMP00001",
          Position: "Senior",
          Wage: 35000,
          Fname: "Nguyen Minh",
          Lname: "Hoa",
        },
      ],
      label: "Shift 2",
      color: "pink",
    },
    {
      shift: {
        Shift_ID: 3,
        Shift_Type: "3", // Shift type 3 is 17:00 - 22:00
        Date: "2024-12-07T00:00:00.000Z",
        E_Num: 2,
        Rate: 1,
      },
      employees: [
        {
          ID_Card_Num: "079203478901",
          Employee_ID: "EMP00002",
          Position: "Senior",
          Wage: 30000,
          Fname: "Tran Van",
          Lname: "Binh",
        },
        {
          ID_Card_Num: "079304008477",
          Employee_ID: "EMP00001",
          Position: "Senior",
          Wage: 35000,
          Fname: "Nguyen Minh",
          Lname: "Hoa",
        },
      ],
      label: "Shift 3",
      color: "orange",
    },
  ];

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
      const shiftDate = new Date(shift.shift.Date).toISOString().split("T")[0];
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

  const handleClockIn = (shiftId) => {
    setShiftStatus((prevState) => ({
      ...prevState,
      [shiftId]: !prevState[shiftId],
    }));
  };

  const currentWeekDates = getDatesForWeek(currentWeekStart);

  return (
    <div className="container">
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
              <p><strong>Shift Type: {hoveredData.shift.Shift_Type}</strong></p>
              <p>Employees:</p>
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
