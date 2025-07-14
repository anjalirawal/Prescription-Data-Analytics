# Prescription Data Analytics Using SQL

## Project Overview

This project focuses on transforming raw prescription data into a clean, normalized relational database, uploading it into MySQL, and running analytical queries to derive meaningful insights. The final schema follows a star schema model, separating fact and dimension tables, and maintaining database integrity using proper key constraints.

### Repository Contents

- `prescription_project.sql`: SQL file with schema creation, data loading, and analytical queries.
- `ERD.png`: Entity Relationship Diagram of the schema (optional if you want to include a visual).
- `README.md`: Project documentation.

---

## Objectives & Methodology

### 1. Data Normalization & Preparation

- Converted unstructured raw data into 3NF-compliant relational tables.
- Created CSV files for each logical table (fact and dimension).
- Example tables:
  - `fact_member_data.csv`
  - `dim_prescription.csv`
  - `dim_drug.csv`

### 2. MySQL Database Setup

- Imported normalized CSVs into MySQL.
- Designed a star schema with:
  - Primary Keys (`mem_drug_id`, `prescription_id`)
  - Foreign Keys linking dimension and fact tables.
- Used `CASCADE` for update/delete actions to ensure referential integrity.

### 3. Entity Relationship Diagram (ERD)

- Designed an ERD to visualize table relationships, keys, and schema structure.

### 4. Analytics & SQL Queries

#### Sample Business Questions Answered:

- **How many prescriptions were filled for the drug 'Ambien'?**
- **How many unique members are over 65, and how many prescriptions did they fill?**
- **For Member ID 10003, what was the most recent drug filled and how much did insurance pay?**

---

## Tools Used

- MySQL
- SQL Workbench / CLI
- Excel or Python (for CSV generation – optional)
- Draw.io / Lucidchart (for ERD – optional)

---
