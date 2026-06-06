# Northwind Enterprise BI Solution
### 🚀 A Full-Stack Microsoft Business Intelligence Implementation

This project demonstrates a complete end-to-end Business Intelligence (BI) lifecycle using the Northwind dataset. It covers the entire pipeline from ETL and Data Warehousing to advanced semantic modeling and enterprise-grade reporting.

---

## 🏗️ Project Architecture
The solution is built across three distinct layers to ensure scalability and performance:

1. **Data Engineering Layer:** SSIS & SQL Server (OLTP to Data Warehouse)
2. **Semantic Layer:** SSAS Multidimensional & SSAS Tabular
3. **Presentation Layer:** Power BI, Excel, and SSRS

---

## 🛠️ Implementation Steps

### 1. Data Integration & ETL (SSIS)
**Objective:** Transform the Northwind OLTP database into a structured analytical Data Warehouse.  
- **Tool:** SQL Server Integration Services (SSIS)  
- **Process:** Extracted data from relational tables, applied cleansing and business rules, and loaded a **Snowflake Schema** Data Warehouse by normalizing hierarchies such as Product → Category → Supplier.

### 2. OLAP Cube Development (SSAS Multidimensional)
**Objective:** Enable high-performance analytical querying and sophisticated multidimensional analysis.  
- **Tool:** SSAS Multidimensional Mode  
- **Key Features:** Designed hierarchies such as Region → Country → City, created calculated members and KPIs, and enabled fast slicing, dicing, drill-down, and roll-up analysis.

### 3. Automation & Scheduling (SQL Server Agent)
**Objective:** Automate the full data refresh and processing cycle.  
- **Tool:** SQL Server Agent Jobs  
- **Tasks:** Scheduled SSIS ETL execution and automated cube processing to keep the analytical environment refreshed without manual intervention.

### 4. SSAS Tabular Model (In-Memory Semantic Layer)
**Objective:** Build a modern, high-speed semantic layer using the xVelocity in-memory engine.  
- **Tool:** SSAS Tabular Mode  
- **Highlights:** Implemented **DAX measures**, KPIs, and Time Intelligence calculations such as YoY, MoM, and YTD. Optimized for Power BI live connections and modern BI reporting scenarios.

### 5. Multi-Channel Presentation Layer
- **Power BI:** Interactive dashboards using Live Connection to the SSAS Tabular model, with cross-filtering, drill-through, and rich visual analytics.  
- **Excel:** Self-service analysis using PivotTables connected to the SSAS Multidimensional model.  
- **SSRS:** Pixel-perfect paginated reports for operational and print-ready reporting needs.

---

## 💻 Tech Stack
- **Database:** SQL Server (T-SQL)  
- **ETL:** SSIS  
- **Semantic Modeling:** SSAS Multidimensional, SSAS Tabular  
- **Visualization & Reporting:** Power BI, Excel, SSRS  
- **Languages:** T-SQL, MDX, DAX  

---

## 📊 Business Insights Delivered
- **Sales Performance:** Analysis of trends, patterns, and seasonal changes in sales.  
- **Product Analysis:** Evaluation of category and supplier contribution to overall revenue.  
- **Customer Segmentation:** Grouping customers by revenue contribution and order behavior.  
- **Geographic Insights:** Tracking regional performance across multi-level geographic hierarchies.  

---

## 📁 Repository Structure
- `/01-Database/` - SQL scripts for creating and populating the Data Warehouse, including supporting T-SQL objects.  
- `/02-ETL-SSIS/` - SSIS solution and ETL packages for extraction, transformation, and loading.  
- `/03-SSAS-Multidimensional/` - SSAS Multidimensional project for OLAP cube development.  
- `/04-SSAS-Tabular/` - SSAS Tabular project containing the in-memory semantic model and DAX logic.  
- `/05-Reports/` - Power BI, Excel, and SSRS reporting assets.  
- `/06-Docs/` - Architecture diagrams, screenshots, and supporting documentation.  

---

## Contact

A complete walkthrough of the architecture, implementation, and reporting layers is included in the recorded project demo shared on LinkedIn.

If you'd like to connect, collaborate, or discuss this project:

- **Email:** artamohammadbeigi@gmail.com  
- **LinkedIn:** [Arta Mohammadbeigi](https://www.linkedin.com/in/arta-mohammadbeigi/)
