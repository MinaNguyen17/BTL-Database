# Fashion Store Management System

## Overview

This system is designed to manage a chain of fashion stores efficiently. It streamlines operations across four main workflows: employee management, shift management, product management, and inventory management. The system is built with the following technologies:

- Database: SQL Server
- Backend: Node.js
- Frontend: React.js

## Features
### 1. Employee Management
- Add, update, employee records.
- Assign roles and responsibilities.

### 2. Shift Management
- Schedule employee shifts.
- Manage shift swaps and replacements.

### 3. Product Management
- Add, update product information.
- Categorize products by type, size, and season.

### 4. Inventory Management
- Track stock levels in each store and central warehouse.
- Record import/export transactions.

## Getting Started
To run the HCMUT Student Smart Printing Service (HCMUT_SSPS) locally, follow these steps:

### Prerequisites
- Install [Node.js](https://nodejs.org/) if you haven't already.
#### Steps
- Clone the repository (if not already done):

``` bash
git clone https://github.com/MinaNguyen17/BTL-Database.git
```
- Setup file `.env` in backend:
```bash
SECRET_KEY = <your_key>
PORT = <port>
```
- Start the backend server:
``` bash
npm install
npm start
```
- Setup file `.env` in frontend:
```bash
VITE_BASE_URL = '<link to backend>'
```
- Start the frontend server:
``` bash
cd front-end
npm install
npm run dev
```
- Start the application:
``` bash
npm start
```
The system should now be running locally. Open your web browser and visit: `http://localhost:5173/`

You should now be able to use the system on your local machine.
