## 🌟 **Modern Data Warehouse & Analytics Project**  

👋 Hello, Data Points!

Welcome to this **Modern Data Warehouse** project using **PostgreSQL**! 🎯  

This repository provides a **step-by-step** approach to building a **scalable, efficient, and analytics-ready data warehouse**. It covers:  
✅ **ETL Pipelines** (Extract, Transform, Load)  
✅ **Data Modeling** (Star Schema)  
✅ **Exploratory Data Analysis (EDA)**  
✅ **SQL-based Reporting & Analytics**  
📝 **[Project Notion Page](https://www.notion.so/rudra-12345g/SQL-Data-Warehouse-Project-By-Rudra-1a65c069c4db80aeacecf558aeeb2c78)**

---

## 🏗️ **Data Architecture Overview**  

The project follows the **Medallion Architecture** with three layers:  

📌 **Bronze Layer (Raw Data)** – Stores data directly from the source (CSV files).  
📌 **Silver Layer (Cleansed & Transformed Data)** – Data is cleaned, structured, and normalized.  
📌 **Gold Layer (Business-Ready Data)** – Optimized for analytics and reporting using a **star schema**.  

### **🔹 Architecture Diagram:**  
![Data Architecture](https://github.com/Rudra-G-23/SQL-Data-Warehouse-Project/blob/main/docs/warehouse/Data_Architecture.png)  

---

## 📖 **Project Overview**  

### 🔍 **Key Features & Learnings:**  
🔹 **SQL Development** – Writing optimized SQL queries for analytics.  
🔹 **Data Engineering** – Designing ETL pipelines for seamless data movement.  
🔹 **Data Architecture** – Structuring a robust and scalable **data warehouse**.  
🔹 **ETL Pipeline Development** – Extracting, transforming, and loading data efficiently.  
🔹 **Data Modeling** – Implementing **fact and dimension tables**.  
🔹 **Data Analytics** – Running advanced analytical queries for insights.  

### 🛠️ **Tech Stack:**  
- **Database:** PostgreSQL  
- **ETL Processing:** SQL, Python (optional)  
- **Data Visualization:** Power BI / Tableau (optional)  
- **Documentation & Diagramming:** Draw.io, Notion  

---

## 📂 **Repository Structure**  

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets (ERP & CRM data)
│
├── docs/                               # Documentation & architecture details
│   ├── bronze/                         
│   |   ├── data_flow_bronze.drawio      # Data flow diagram (Source → Bronze)                        
│   ├── silver/
│   |   ├── data_flow_silver.drawio      # Data flow diagram (Bronze → Silver)
│   |   ├── data_cleaning_output/        # Sample outputs after cleaning                          
│   ├── gold/ 
│   |   ├── data_flow_gold.drawio        # Data flow diagram (Silver → Gold)                        
│   |   ├── data_models.drawio           # Star schema model                    
│   |   ├── data_catalog.md              # Metadata & dataset field descriptions
│   ├── warehouse/                            
│       ├── naming-conventions.md           # Standardized naming guidelines
│       ├── etl.drawio                      # ETL process diagrams
│
├── scripts/                            # SQL scripts for ETL & transformation
│   ├── bronze/                         # Extract & Load scripts
│   ├── silver/                         # Data cleansing & transformation scripts
│   ├── gold/                           # Data modeling scripts
│   ├── init_database.sql               # Initial database creation script
│
├── tests/                              # Quality check scripts
│
├── README.md                           # Project overview & instructions
├── LICENSE                             # Licensing details
└── requirements.txt                    # Dependencies & tools
```  

---

## 🚀 **Project Requirements**  

### 👨‍💻 **Data Engineering: Building the Data Warehouse**  
**Goal:** Develop a **PostgreSQL-based** data warehouse consolidating **sales data** for analytical reporting.  

✔️ **Data Sources:** Import from **ERP & CRM (CSV files)**  
✔️ **Data Quality:** Cleaning & handling missing values  
✔️ **Integration:** Merging datasets into a **single analytical model**  
✔️ **Data Modeling:** Implementing a **star schema** (Fact & Dimension tables)  
✔️ **Documentation:** Clear **metadata & model descriptions**  


## 📊 **BI: Analytics & Reporting**  

📌 **Key Business Insights:**  
🔸 **Customer Behavior Analysis** – Understanding buying patterns  
🔸 **Product Performance Metrics** – Evaluating top-performing items  
🔸 **Sales Trend Analysis** – Identifying revenue patterns  

**Outcome:** 📈 Actionable reports for data-driven **business decisions**!  

---

## 🛠️ **Setup & Installation Guide**  

### **🔹 Prerequisites:**  
- Install **PostgreSQL** → [Download PostgreSQL](https://www.postgresql.org/download/)  
- Clone this repository:  
  ```bash
  git clone https://github.com/Rudra-G-23/SQL-Data-Warehouse-Project.git
  ```
- Load sample datasets from the `/datasets/` folder.  

### **🔹 Running SQL Scripts:**  
1️⃣ **Initialize Database:**  
   ```
   \i init_database.sql;
   ```
2️⃣ **Run ETL Scripts:**  
   ```
   \i scripts/bronze/       -- load data
   \i scripts/silver/       -- transform data
   \i scripts/gold/         -- final model
   ```
3️⃣ **Start Analysis:** Query tables to generate insights!  

---

## 🔗 **Useful Links & Resources**  

📌 **Project Assets:**  
- 📂 [Dataset Folder](https://github.com/Rudra-G-23/SQL-Data-Warehouse-Project/tree/main/datasets)  
- 📝 [Project Notion Page](https://www.notion.so/rudra-12345g/SQL-Data-Warehouse-Project-By-Rudra-1a65c069c4db80aeacecf558aeeb2c78)  
- 🎨 [Diagramming Tool (Draw.io)](https://www.drawio.com/)  

---

## 📢 **Connect & Collaborate!**  

💡 **Want to contribute?** Fork this repo and submit a **pull request**!  
📩 **Got questions?** Open an **issue** or reach out to me!  


## 🙏 Thank you
A special thank you to my instructor, Baraa Khatib Salkini, IT Project Manager | Lead Big Data, Data Lakehouse and BI at Mercedes-Benz AG. I learned many things from him.
*   [LinkedIn](https://www.linkedin.com/in/baraa-khatib-salkini-845b1b55/)
*   [YouTube](https://www.youtube.com/@DataWithBaraa) 



## 📌 **Follow me on:**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/rudra-prasad-bhuyan-44a388235)  
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/Rudra-G-23)  
[![Kaggle](https://img.shields.io/badge/Kaggle-Explore-blue?logo=kaggle)](https://www.kaggle.com/rudraprasadbhuyan)  

📧 Email me at: [rudraprasadbhuyan000@gmail.com](mailto:rudraprasadbhuyan000@gmail.com)  

