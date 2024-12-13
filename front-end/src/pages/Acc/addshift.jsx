import React, { useState } from "react";
import "./addshift.css";

function EmpShift() {
  const [hoveredData, setHoveredData] = useState(null);
  const [hoverPosition, setHoverPosition] = useState({ x: 0, y: 0 });
  const [currentWeekStart, setCurrentWeekStart] = useState(new Date("2024-12-02")); // Start from Monday
  const [timetableData, setTimetableData] = useState([
    {
      shift: {
        Shift_ID: 1,
        Shift_Type: "1", // 1: 7:00 - 12:00
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
        Shift_Type: "2", // 2: 12:00 - 17:00
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
        Shift_Type: "3", // 3: 17:00 - 22:00
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
  ]);

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
  const handleSubmit = (e) => {
    e.preventDefault();
    const { startTime, endTime } = getShiftTimes(newShift.label);
    const newShiftData = {
      shift: {
        Shift_ID: timetableData.length + 1, // Assuming Shift_ID is auto-incremented
        Shift_Type: newShift.label, // Assign Shift Type from the label (1, 2, 3)
        Date: newShift.date,
        E_Num: newShift.E_Num,
        Rate: newShift.Rate,
      },
      employees: newShift.employees,
      startTime,
      endTime,
      label: newShift.label,
      color: "blue", // Default color for the shift
    };
    setTimetableData((prev) => [...prev, newShiftData]); // Add new shift to timetable
    setNewShift({ label: "", startTime: "", endTime: "", date: "", employees: [], E_Num: 0, Rate: 1 }); // Reset form
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

  const handleMouseEnter = (e, data) => {
    setHoveredData(data);
    setHoverPosition({ x: e.clientX + 15, y: e.clientY + 15 });
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

        <button type="submit">Add Shift</button>
      </form>
    </div>
  );
}

export default EmpShift;
