# FMCG-Manufacturing-Pricing-Profitability-Analytics-System-powerbi-mssql
## 📸 Dashboard Preview

### 🏭 Manufacturing Unit Performance Analysis
https://app.fabric.microsoft.com/reportEmbed?reportId=8afc1694-24fd-462e-a603-8c43c792ff4a&autoAuth=true&ctid=0c93e3f2-a488-4632-a9b2-99ec3931cb62
<img width="1366" height="768" alt="Manufacturing Unit Overview" src="https://github.com/user-attachments/assets/cb19f446-e653-48ac-9614-6ab0a1fe20c8" />



### 💰 Manufacturing Cost & Production Analysis
https://app.fabric.microsoft.com/reportEmbed?reportId=a7584148-ce17-4a4f-9ae8-2ce894dcc063&autoAuth=true&ctid=0c93e3f2-a488-4632-a9b2-99ec3931cb62
<img width="1366" height="768" alt="Manufacturing Cost   Production Overview" src="https://github.com/user-attachments/assets/9a5ef5ec-e150-4dbf-ac3b-c1dc9846a682" />

---

## 📌 Overview

This project is an end-to-end **Manufacturing, Pricing & Profitability Analytics Platform** built using **SQL Server + Power BI**, designed to solve real-world challenges in the FMCG (Food & Beverages) industry.

It provides a **centralized decision-making system** by integrating:

- Manufacturing capacity tracking  
- Cost computation & variance analysis  
- Pricing ladder automation  
- Tax logic (Pre-GST & GST)  
- Profitability insights  

---

## 🎯 Business Problem

FMCG organizations often struggle with:

- ❌ No visibility into plant utilization  
- ❌ Manual & error-prone price calculations  
- ❌ Inconsistent margins across categories  
- ❌ Lack of profitability insights per product  
- ❌ No unified tax logic (Pre-GST vs GST)  
- ❌ Difficulty in comparing Actual vs Plan vs Target  

---

## 💡 Solution

Designed a **scalable analytics system** that:

- ✔ Tracks production & capacity utilization across plants  
- ✔ Automates end-to-end pricing ladder (Base Cost → MRP)  
- ✔ Implements category-based margin rules  
- ✔ Integrates GST & Pre-GST tax logic  
- ✔ Calculates profit per pack & per quintal  
- ✔ Enables variance & scenario analysis  

---

## 🏗️ Data Architecture

- **Fact Table:** `FACT_PRD_MANU_PROD_MASTER_MAIN_NEW_DATA`  

- **Dimension Tables:**
  - Manufacturing Unit  
  - Product Category / Subcategory  
  - State  
  - Plant Manager  
  - Product Pack  

---

## 📊 Key Metrics

- Capacity Utilization %  
- Packs Per Quintal  
- Total Retail Packs Produced  
- Base Cost Per Pack  
- MRP & Net Selling Price  
- Profit Per Pack  
- Variance (Actual vs Plan vs Target)  

---
## ⚙️ Core Logic

### 📦 Packs Per Quintal
100000 / PackSize

### ⚙️ Capacity Utilization
Produced / Installed Capacity

### 💰 Pricing Flow
Base Cost → Ex-Factory → Wholesale → Pre-Tax MRP → Final MRP

---

# 📊 Power BI Reports

This project includes **two separate Power BI reports (.pbix files)** designed for different business functions.

---

## 📁 Report 1: Manufacturing Performance Dashboard
- https://app.fabric.microsoft.com/reportEmbed?reportId=a7584148-ce17-4a4f-9ae8-2ce894dcc063&autoAuth=true&ctid=0c93e3f2-a488-4632-a9b2-99ec3931cb62
### 🔹 Pages:

### 1️⃣ Manufacturing Unit Overview
- Plant-wise production & performance  
- Capacity distribution
 
  <img width="1366" height="768" alt="Manufacturing Unit Overview" src="https://github.com/user-attachments/assets/cb19f446-e653-48ac-9614-6ab0a1fe20c8" />

### 2️⃣ Actual vs Plan vs Target
- Production comparison across scenarios  
- Performance benchmarking
  
<img width="1366" height="768" alt="Actual vs Plan vs Target" src="https://github.com/user-attachments/assets/25c72578-2fbe-4c82-bf7e-4326ecca8eed" />

### 3️⃣ Variance (Actual vs Plan vs Target)
- Gap analysis  
- Over/under-performance tracking
-  
<img width="1366" height="768" alt="Variance (Actual vs Plan vs Target)" src="https://github.com/user-attachments/assets/b19b548d-a4ba-404a-b762-134a0a9c18c8" />

### 4️⃣ Capacity Utilization
- Utilization % by plant  
- Under-utilized vs optimal classification
- 
<img width="1366" height="768" alt="Capacity Utilization" src="https://github.com/user-attachments/assets/bb738277-1ffc-4658-963a-31e8ff34f818" />

---

## 📁 Report 2: Cost, Pricing & Profitability Dashboard
https://app.fabric.microsoft.com/reportEmbed?reportId=a7584148-ce17-4a4f-9ae8-2ce894dcc063&autoAuth=true&ctid=0c93e3f2-a488-4632-a9b2-99ec3931cb62
### 🔹 Pages:

### 1️⃣ Manufacturing Cost & Production Overview
- Total operational cost  
- Production output

- <img width="1366" height="768" alt="Manufacturing Cost   Production Overview" src="https://github.com/user-attachments/assets/9a5ef5ec-e150-4dbf-ac3b-c1dc9846a682" />

### 2️⃣ Retail Pack vs Base Cost
- Cost per pack analysis  
- Unit economics
- 
<img width="1366" height="768" alt="Retail Pack vs Base Cost" src="https://github.com/user-attachments/assets/49f56a95-93cc-4ec3-8dfe-d8e6bef59adb" />

### 3️⃣ Production Variance & Performance Bridge
- Variance breakdown (waterfall/bridge view)  
- Cost & production drivers
- 
-  <img width="1366" height="768" alt="Production Variance   Performance Bridge" src="https://github.com/user-attachments/assets/a4c9b2bc-6095-40c7-9705-5e5ac0250a39" />

### 4️⃣ Base Cost Variance (Actual vs Plan vs Target)
- Cost deviation analysis  
- Efficiency insights
- 
<img width="1366" height="768" alt="Base Cost Variance (Actual vs Plan vs Target)" src="https://github.com/user-attachments/assets/983885c5-bea3-4f84-801b-f128f6dcc505" />

### 5️⃣ Gross Margin Analysis
- Margin % by category  
- Profitability comparison
- 
<img width="1366" height="768" alt="Gross Margin Analysis" src="https://github.com/user-attachments/assets/90db39d8-05b6-4316-a7eb-d2c7d83c9c16" />
---

## 🧠 Advanced Analytics

- SQL Window Functions (Monthly Avg Production)  
- Scenario Analysis (Produced vs Expected vs Installed)  
- Variance Analysis (Actual vs Plan vs Target)  
- Cost Leakage Detection  
- Profit Optimization  

---

## 📈 Business Impact

- 📉 Identified under-utilized plants improving operational efficiency  
- 💰 Improved pricing accuracy & margin consistency  
- 📊 Enabled data-driven decision-making across operations & finance  
- ⚡ Reduced manual effort through pricing automation  
- 📦 Improved visibility into cost, production, and profitability  

---

## 🛠️ Tech Stack

- **SQL Server** (CTEs, Views, Window Functions)  
- **Power BI** (DAX, Data Modeling, Visualization)  
- **Power Query**  
- **Excel**  

---

## 🚀 Future Enhancements

- Real-time data integration (DirectQuery / streaming)  
- Demand forecasting (Power BI / Python)  
- Inventory optimization (Stock & Reorder KPIs)  
- ERP integration (Sales, Inventory, Production systems)  

---

## 👨‍💻 Author

**Rishabh Jain**  
Data Analyst | Power BI Developer  
📍 India  

---

## 🔗 Connect With Me

- LinkedIn: www.linkedin.com/in/rishabh-jain-a3534b20a
