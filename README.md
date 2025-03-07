# 🌟 **Modern Data Warehouse & Analytics Project**  

👋 Hello, Data Points! 
- My name is **Rudra Prasad Bhuyan** ! 😄
- I am a Kaggle expert and a Google Certified Data Analyst.

Welcome to this **Modern Data Warehouse** project using **PostgreSQL**! 🎯  

This repository provides a **step-by-step** approach to building a **scalable, efficient, and analytics-ready data warehouse**. It covers:  
✅ **ETL Pipelines** (Extract, Transform, Load)  
✅ **Data Modeling** (Star Schema)  
✅ **Exploratory Data Analysis (EDA)**  
✅ **SQL-based Reporting & Analytics**  
✅ **Advanced-Data Analytsis & Reporting**  
📝 **[Project Notion Page](https://www.notion.so/rudra-12345g/SQL-Data-Warehouse-Project-By-Rudra-1a65c069c4db80aeacecf558aeeb2c78)**

---

## 🏗️ **Data Architecture Overview**  

The project follows the **Medallion Architecture** with three layers:  

📌 **Bronze Layer (Raw Data)** – Stores data directly from the source (CSV files).  
📌 **Silver Layer (Cleansed & Transformed Data)** – Data is cleaned, structured, and normalized.  
📌 **Gold Layer (Business-Ready Data)** – Optimized for analytics and reporting using a **star schema**.  

### **🌐 Architecture Diagram:**  

![Data_Architecture](https://github.com/user-attachments/assets/08e761c2-de49-4d74-89d8-394b55878095)

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
├── datasets/             # Raw data from ERP and CRM systems.
│
├── docs/                 # Project documentation, architecture diagrams, and outputs.
│   ├── bronze/
│   │   ├── data_flow_bronze.drawio   # Data flow diagram: Source -> Bronze (Draw.io).
│   │   ├── bronze_data_schema.md # Schema of the bronze layer tables.
│   │   └── bronze_output_examples/ # Example of the data after the bronze layer processing.
│   ├── silver/
│   │   ├── data_cleaning_output/   # Examples of data after cleaning.
│   │   ├── data_flow_silver.drawio   # Data flow diagram: Bronze -> Silver (Draw.io).
│   │   ├── Data_Integration.drawio   # Data integration diagram (Draw.io).
│   │   └── silver_data_schema.md # Schema of the silver layer tables.
│   ├── gold/
│   │   ├── output/             # Examples of the data after the gold layer processing.
│   │   ├── data_catalog.md     # Data dictionary for the Gold layer, including field descriptions.
│   │   ├── data_flow_gold.drawio   # Data flow diagram: Silver -> Gold (Draw.io).
│   │   ├── data_models.drawio   # Star schema diagram (Draw.io).
│   │   └── gold_data_schema.md  # Schema of the gold layer tables.
│   └── warehouse/
│       ├── naming_conventions.md # Naming conventions for tables, columns, etc.
│       ├── data_architecture.drawio # Overall data warehouse architecture diagram (Draw.io).
│       └── etl.drawio         # ETL process diagram, showcasing techniques and methods (Draw.io).
│
├── scripts/              # SQL scripts for ETL and transformations.
│   ├── bronze/
│   │   └── load_raw_data.sql # Scripts to load data from the 'datasets' directory into the bronze layer.
│   ├── silver/
│   │   └── transform_clean_data.sql # Scripts to clean and transform the data in the bronze layer.
│   └── gold/
│       ├── create_analytical_views.sql # Scripts to create views for analysis in the gold layer.
│       └── populate_dimensions.sql # Scripts to populate dimension tables.
│   └── init_database.sql   # Script to create the database and schemas.
│
├── tests/                 # Test scripts and quality control files (e.g., data quality checks).
│   └── data_quality_checks.sql # SQL scripts for data quality checks.
│
├── report/                # Analysis scripts and reports.
│   ├── 1_gold_layer_datasets/   # Datasets used for reporting and analysis.
│   ├── 2_eda_scripts/        # Exploratory Data Analysis (EDA) scripts.
│   │   └── basic_eda.ipynb # Jupyter notebook containing basic EDA.
│   ├── 3_advanced_eda/       # Advanced EDA scripts and analyses.
│   │   └── advanced_eda.ipynb # Jupyter notebook containing advanced EDA.
│   ├── output/             # Output from the analysis (e.g., charts, tables).
│   ├── 12_report_customers.sql # SQL script for the customer report.
│   └── 13_report_products.sql # SQL script for the product report.
│
├── README.md              # Project overview, instructions, and report summaries.
├── LICENSE                # License information.
└── requirements.txt        # Project dependencies (e.g.pgsql libraries).
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

## 📰 Report - Data Analysis and Business Insights

This section summarizes the data analysis process and the resulting reports, providing valuable business insights.

![analysis](https://github.com/user-attachments/assets/c897de5d-f094-4234-ba85-62a622b2a4cd)

## 🎏 Data Exploration and Analysis

The analysis followed a structured approach, covering various aspects of the data:

1.  **Database Exploration:** Understanding the structure and relationships within the database.
2.  **Dimensions Exploration:** Analyzing the characteristics of the dimension tables (customers, products).
3.  **Date Range Exploration:** Identifying the time period covered by the data.
4.  **Measures Exploration:** Examining key metrics and their distributions.
5.  **Magnitude Exploration:** Understanding the scale of different measures.
6.  **Ranking Analysis:** Identifying top performers (e.g., customers, products).
7.  **Change Over Time Analysis:** Tracking trends and patterns over time.
8.  **Cumulative Analysis:** Examining the accumulated values of metrics.
9.  **Performance Analysis:** Evaluating the performance of different aspects of the business.
10. **Data Segmentation:** Grouping data into meaningful segments for targeted analysis.
11. **Part-to-Whole Analysis:** Understanding the contribution of different parts to the overall picture.


The EDA process was conducted using  SQL queries. The results of the EDA are stored in the `output` directory within the `report` folder.

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
A special thank you to my instructor, Baraa Khatib Salkini.IT Project Manager | Lead Big Data, Data Lakehouse and BI at Mercedes-Benz AG. I learned many things from him.
*   [LinkedIn](https://www.linkedin.com/in/baraa-khatib-salkini-845b1b55/)
*   [YouTube](https://www.youtube.com/@DataWithBaraa) 



## 📌 **Follow me on:**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/rudra-prasad-bhuyan-44a388235)  
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/Rudra-G-23)  
[![Kaggle](https://img.shields.io/badge/Kaggle-Explore-blue?logo=kaggle)](https://www.kaggle.com/rudraprasadbhuyan)  

📧 Email me at: [rudraprasadbhuyan000@gmail.com](mailto:rudraprasadbhuyan000@gmail.com)  

