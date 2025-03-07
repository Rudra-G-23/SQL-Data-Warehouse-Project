## Gold Layer Tables 🗄️

This section describes the tables in the Gold layer of the data warehouse, along with their columns and metadata.

### ➡️  `dim_customers` 👤

| Column Name        | Data Type             | Description                                                                     |
|-------------------|----------------------|---------------------------------------------------------------------------------|
| `customer_key`   | `INT` (PK)           | Primary key for the customer dimension. 🔑                                      |
| `customer_id`    | `INT`                 | Unique identifier for the customer. 🆔                                         |
| `customer_number` | `VARCHAR(255)`       | Customer number from the source system. #️⃣                                      |
| `first_name`     | `VARCHAR(255)`       | Customer's first name. 🧑                                                       |
| `last_name`      | `VARCHAR(255)`       | Customer's last name. 👨                                                        |
| `country`        | `VARCHAR(255)`       | Customer's country of residence. 🌎                                              |
| `marital_status` | `VARCHAR(255)`       | Customer's marital status. 💍                                                   |
| `gender`         | `VARCHAR(255)`       | Customer's gender. 🚻                                                         |
| `birth_date`     | `DATE`                | Customer's birth date. 🎂                                                        |
| `create_date`    | `TIMESTAMP WITH TIME ZONE` | Timestamp of when the customer record was created. 📅                         |

### ➡️ `dim_products` 📦

| Column Name     | Data Type      | Description                                                                     |
|-----------------|---------------|---------------------------------------------------------------------------------|
| `product_key` | `INT` (PK)   | Primary key for the product dimension. 🔑                                       |
| `product_id`  | `INT`           | Unique identifier for the product. 🆔                                          |
| `product_number`| `VARCHAR(255)`| Product number from the source system. #️⃣                                      |
| `product_name`  | `VARCHAR(255)`| Name of the product. 🏷️                                                       |
| `category_id` | `INT`           | ID of the product category. 📁                                                  |
| `category`    | `VARCHAR(255)`| Name of the product category. 📂                                                 |
| `subcategory` | `VARCHAR(255)`| Name of the product subcategory. 🗂️                                                 |
| `maintenance` | `INT`           | Maintenance cost or frequency (details to be defined). 🛠️                       |
| `product_cost`| `NUMERIC`      | Cost of the product. 💰                                                         |
| `product_line`| `VARCHAR(255)`| Product line or group. 📈                                                        |
| `start_dt`    | `DATE`          | Date when the product was introduced or became active. 📅                        |

### ➡️ `fact_sales` 📈

| Column Name   | Data Type      | Description                                                                                     |
|---------------|---------------|-------------------------------------------------------------------------------------------------|
| `order_number`| `VARCHAR(255)`| Order number. #️⃣                                                                            |
| `product_key` | `INT` (FK)   | Foreign key referencing `dim_products`. 🔗                                                        |
| `customer_key`| `INT` (FK)   | Foreign key referencing `dim_customers`. 🔗                                                       |
| `customer_id` | `INT`           | Customer ID (may be redundant, but included for context). 🆔                                        |
| `order_date`  | `DATE`          | Date of the order. 📅                                                                         |
| `shipping_date`| `DATE`          | Date when the order was shipped. 🚚                                                              |
| `due_date`    | `DATE`          | Date when the order was due. ⏰                                                                 |
| `sales_amount`| `NUMERIC`      | Total sales amount for the order. 💲                                                             |
| `quantity`    | `INT`           | Quantity of products sold in the order. 🔢                                                           |
| `price`       | `NUMERIC`      | Price per unit of the product. 💵                                                                |

➡️**Key:**

* PK: Primary Key
* FK: Foreign Key
* More Info about the gold layer : [docs/gold](https://github.com/Rudra-G-23/SQL-Data-Warehouse-Project/tree/main/docs/gold)
* More info about the gold scripts : [scripts/gold](https://github.com/Rudra-G-23/SQL-Data-Warehouse-Project/tree/main/scripts/gold)
