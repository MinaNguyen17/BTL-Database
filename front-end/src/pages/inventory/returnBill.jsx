import React, { useState, useEffect } from "react";
import axiosInstance from "@/utils/axiosInstance";
import "./returnbill.css";

const ReturnBill = () => {
  const [returnBills, setReturnBills] = useState([]);

  // Fetch danh sách Return Bill từ API
  useEffect(() => {
    axiosInstance
      .get("/returnBill/all")
      .then((response) => {
        setReturnBills(response.data || []); // Lưu danh sách return bill
      })
      .catch((error) => {
        console.error("Error fetching return bills:", error);
        setReturnBills([]);
      });
  }, []);

  return (
    <div className="return-bill-container">
      <h1>Return Bill List</h1>
      <table className="return-bill-table">
        <thead>
          <tr>
            <th>Return ID</th>
            <th>Total Refund</th>
            <th>Reason</th>
          </tr>
        </thead>
        <tbody>
          {returnBills.length > 0 ? (
            returnBills.map((bill) => (
              <tr key={bill.RETURN_ID}>
                <td>{bill.RETURN_ID}</td>
                <td>{bill.REFUND_FEE.toLocaleString()} VND</td>
                <td>{bill.REASON}</td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan="3">No Return Bills Available</td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default ReturnBill;
