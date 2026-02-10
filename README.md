# petshop-db-oracle
# Pet Shop Management Database (Oracle)

A relational database project for managing a pet shop: products, categories, customers, loyalty cards, employees, orders, and stock updates.  
The repository includes DDL for schema creation, sample data inserts, and testing/validation queries.

> Academic project (University). Focus: database modeling + SQL/DDL/DML + business rules.

## Features (What the database supports)

- Products & categories (each product belongs to exactly one category)
- Customers from different cities
- Optional loyalty card per customer (not required for placing orders)
- Orders placed by customers
- Order assignment to employees (basic activity tracking)
- Stock management (restocking / supplier deliveries)
- Alerts/queries for low-stock products
- Business rules such as:
  - No selling more than current stock
  - Quantities are integers
  - Max 10 units of the same product per order line
  - Fixed product prices (no time-based price history)
  - No promotions/discount system
  - No warranty tracking

## Tech / Tools

- **Oracle SQL** (DDL + DML)
- **Oracle SQL Developer** (recommended) or **SQL\*Plus**
- (Optional) **Oracle Data Modeler** files included (if you use it)

## Repository structure

Typical files you may find in this repo:

- `creare_tabele.ddl` – schema creation (tables, constraints, sequences, etc.)
- `inserari_date.sql` – sample data inserts
- `testare_vizualizare_validare.sql` – tests, validations, useful queries
- `Petshop_DataModeler/` or `Petshop_DataModeler.dmd` – modeling artifacts (optional)
- `Gestiune_Petshop_Documentatie.pdf` – documentation (optional)


## Quick start (Run locally)

### Prerequisites
1. An Oracle Database instance (local / Docker / university environment)
2. A SQL client: **Oracle SQL Developer** (easiest) or `sqlplus`

### Steps
1. **Create a schema/user** (or use an existing one) and connect to it in SQL Developer.
2. Run the scripts in this order:

```sql
-- 1) Create tables and constraints
@creare_tabele.ddl

-- 2) Insert sample data
@inserari_date.sql

-- 3) Run tests / validations / queries
@testare_vizualizare_validare.sql
