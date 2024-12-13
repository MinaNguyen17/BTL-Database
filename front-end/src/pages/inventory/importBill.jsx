import React, { useState, useEffect } from "react";
import axiosInstance from "@/utils/axiosInstance";
import "./ImportBill.css";

const ImportBill = () => {
  const [importBills, setImportBills] = useState([]);

  // Fetch danh sách Import Bill từ API
  useEffect(() => {
    axiosInstance
      .get("/importBill/all")
      .then((response) => {
        setImportBills(response.data || []); // Lưu danh sách import bill
      })
      .catch((error) => {
        console.error("Error fetching import bills:", error);
        setImportBills([]);
      });
  }, []);

  // Hàm xử lý xác nhận nhập kho
  const handleConfirmImport = async (importId) => {
    try {
      // Lấy thông tin Import Bill tương ứng
      const currentBill = importBills.find((bill) => bill.IMPORT_ID === importId);
      if (!currentBill) {
        alert("Import Bill not found!");
        return;
      }
  
      // Dữ liệu gửi đến API
      const requestData = {
        itemID: currentBill.IMPORT_ID, // Thay đổi nếu cần dữ liệu khác
        newState: "Approved",
      };
  
      // Xác nhận Import Bill
      await axiosInstance.post(`/importBill/update/${importId}`, requestData);
      alert(`Import Bill ID ${importId} has been confirmed!`);
  
      // Gọi API cập nhật stock
      await axiosInstance.post(`/importBill/updateStock/${importId}`);
      alert(`Stock for Import Bill ID ${importId} has been updated!`);
  
      // Cập nhật trạng thái danh sách
      setImportBills((prev) =>
        prev.map((bill) =>
          bill.IMPORT_ID === importId
            ? { ...bill, IMPORT_STATE: "Approved" }
            : bill
        )
      );
    } catch (error) {
      console.error(`Error processing Import Bill ID ${importId}:`, error);
      alert("Failed to process the import bill. Please try again.");
    }
  };

  return (
    <div className="import-bill-container">
      <h1>Import Bill List</h1>
      <table className="import-bill-table">
        <thead>
          <tr>
            <th>Import ID</th>
            <th>State</th>
            <th>Total Fee</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {importBills.length > 0 ? (
            importBills.map((bill) => (
              <tr key={bill.IMPORT_ID}>
                <td>{bill.IMPORT_ID}</td>
                <td>{bill.IMPORT_STATE}</td>
                <td>{bill.TOTAL_FEE.toLocaleString()} VND</td>
                <td>
                  {bill.IMPORT_STATE === "Pending" ? (
                    <button
                      className="confirm-btn"
                      onClick={() => handleConfirmImport(bill.IMPORT_ID)}
                    >
                      Confirm
                    </button>
                  ) : (
                    <span className="confirmed-text">Approved</span>
                  )}
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan="4">No Import Bills Available</td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default ImportBill;
