import React, { useState } from "react";
import Import from "./import"; // Import component
import Return from "./return"; // Return component
import ImportBill from "./importBill"; // ImportBill component
import ReturnBill from "./returnBill"; // ReturnBill component
import "./inventory.css"; // Import the stylesheet

const Inventory = () => {
  // Set default state so only one component is true at a time
  const [showImport, setShowImport] = useState(true); // Initially show Import
  const [showReturn, setShowReturn] = useState(false);
  const [showImportBill, setShowImportBill] = useState(false);
  const [showReturnBill, setShowReturnBill] = useState(false);

  // Toggle functions for each component
  const toggleImport = () => {
    setShowImport(true);
    setShowReturn(false);
    setShowImportBill(false);
    setShowReturnBill(false);
  };
  const toggleReturn = () => {
    setShowImport(false);
    setShowReturn(true);
    setShowImportBill(false);
    setShowReturnBill(false);
  };
  const toggleImportBill = () => {
    setShowImport(false);
    setShowReturn(false);
    setShowImportBill(true);
    setShowReturnBill(false);
  };
  const toggleReturnBill = () => {
    setShowImport(false);
    setShowReturn(false);
    setShowImportBill(false);
    setShowReturnBill(true);
  };

  return (
    <div className="inventory-container">
      <h1>Inventory Management</h1>
      
      {/* Buttons to toggle visibility of components */}
      <div className="inventory-buttons">
        <button onClick={toggleImport}>Toggle Import</button>
        <button onClick={toggleReturn}>Toggle Return</button>
        <button onClick={toggleImportBill}>Toggle Import Bill</button>
        <button onClick={toggleReturnBill}>Toggle Return Bill</button>
      </div>

      {/* Inventory components */}
      <div className="inventory-row">
        <div className="inventory-item">
          {showImport && <Import />}
        </div>
        <div className="inventory-item">
          {showReturn && <Return />}
        </div>
        <div className="inventory-item">
          {showImportBill && <ImportBill />}
        </div>
        <div className="inventory-item">
          {showReturnBill && <ReturnBill />}
        </div>
      </div>
    </div>
  );
};

export default Inventory;
