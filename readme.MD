# 🚕 NYC Taxi Data Warehouse – Snowflake + dbt

<div align="center">

![NYC Taxi](https://i0.wp.com/w42st.com/wp-content/uploads/2022/09/david-becker-6rWCc5h7Y7o-unsplash.jpg?resize=1024%2C541&ssl=1?auto=compress&cs=tinysrgb&w=1200&h=300&fit=crop)

### Modern Data Warehouse Architecture for NYC Yellow Taxi Dataset

[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](https://www.snowflake.com/)
[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)](https://en.wikipedia.org/wiki/SQL)

**40M+ Records** | **Medallion Architecture** | **Production-Ready Analytics Engineering**

</div>

---

## 📌 Project Overview

This project implements a **production-grade Data Warehouse architecture** leveraging the NYC Yellow Taxi dataset containing **40+ million records**.

### 🎯 Project Objectives

| Objective | Status |
|-----------|--------|
| 📥 Ingest raw parquet files into Snowflake | ✅ Complete |
| 🧹 Apply data cleaning and validation | ✅ Complete |
| 🏗️ Build layered transformation architecture | ✅ Complete |
| ⚙️ Industrialize transformations with dbt Core | ✅ Complete |
| ✅ Implement data quality testing | ✅ Complete |
| 📚 Generate automated documentation & lineage | ✅ Complete |

This project follows industry-standard **Analytics Engineering best practices** and demonstrates professional-grade data architecture patterns.

---

## 🏗️ Architecture Overview

### The Medallion Architecture Pattern

The project implements the **Medallion Architecture** (also known as Delta Lake's medallion approach), a proven three-layer data organization pattern:

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│    RAW       │  →   │   STAGING    │  →   │ INTERMEDIATE │  →   │    MART      │
│  (Bronze)    │      │   (Silver)   │      │   (Silver)   │      │    (Gold)    │
└──────────────┘      └──────────────┘      └──────────────┘      └──────────────┘
  Source Truth       Data Cleaning        Business Logic       BI & Analytics
```

---

### 🔹 RAW Layer (Bronze) – Source of Truth

**Schema:** `RAW`

The RAW layer is the **immutable source of truth** containing an exact replica of the source parquet files with zero transformations applied.

```yaml
Key Characteristics:
  • Direct copy of parquet source files
  • No transformations or cleaning
  • Immutable data layer
  • Full audit trail of ingestion
  • Stored in Snowflake schema: RAW
```

**Use Case:** Data recovery, debugging, historical analysis

---

### 🔹 STAGING Layer (Silver) – Data Cleaning

**Schema:** `ANALYTICS_STAGING`

The STAGING layer performs essential data **normalization and quality filtering**. This layer ensures only valid, standardized data flows downstream.

**Transformations Applied:**

- ✓ Column renaming to business naming conventions
- ✓ Timestamp conversion and timezone normalization
- ✓ Data type casting and standardization
- ✓ Quality filtering:
  - Remove negative fares
  - Remove zero or invalid distances
  - Validate dropoff time > pickup time
  - Remove incomplete records

**Materialization:** dbt Views (optimized for flexibility)

**Use Case:** Data quality assurance, upstream data debugging

---

### 🔹 INTERMEDIATE Layer (Silver) – Business Logic

**Schema:** `ANALYTICS_INTERMEDIATE`

The INTERMEDIATE layer applies **business-level enrichment** and derives key metrics. This layer bridges raw data and analytics-ready datasets.

**Enrichments & Metrics:**

- 📊 **trip_duration_minutes** – Calculated trip duration
- 💰 **fare_per_km** – Revenue efficiency metric
- 🗓️ **Date/time dimensions** – Temporal breakdowns (year, month, day, hour)
- 🎯 **Business rule application** – Domain-specific logic
- 🧹 **Data deduplication** – Removal of duplicate records

**Materialization:** dbt Tables (optimized for performance)

**Use Case:** Feature engineering, analytics foundation, business metric calculation

---

### 🔹 MART Layer (Gold) – Analytics-Ready Datasets

**Schema:** `ANALYTICS_MART`

The MART layer contains **final, business-ready fact tables** optimized for consumption by BI tools, dashboards, and reporting systems.

**Features:**

- 🎯 Aggregated metrics and KPIs
- 📈 Fact tables with dimensional context
- ⚡ Denormalized for query performance
- 📝 Business-friendly naming conventions
- 🔄 Referential integrity maintained

**Materialization:** dbt Tables (indexed for analytics queries)

**Use Case:** Dashboard creation, executive reporting, analytics queries

---

## 🧊 Snowflake Setup

The `/sql` directory contains all foundational Snowflake setup scripts executed in sequence:

### Setup Scripts

| Script | Purpose |
|--------|---------|
| `01_warehouse_setup.sql` | Create warehouse & database |
| `02_schema_creation.sql` | Initialize schemas (RAW, STAGING, INTERMEDIATE, MART) |
| `03_file_format.sql` | Define parquet file format |
| `04_internal_stage.sql` | Configure internal stage for file loading |
| `05_parquet_ingestion.sql` | COPY INTO raw tables |
| `06_initial_validation.sql` | Data quality checks post-ingestion |

**Execution Order:** Scripts must be executed sequentially to maintain proper initialization.

> **Note:** These SQL scripts document the manual Snowflake implementation phase. After this foundation, dbt took over transformation responsibilities.

---

## ⚙️ dbt Implementation

The `/dbt/nyc_taxi_project/` directory contains the **industrialized transformation layer**, enabling version control, testing, and documentation.

### Project Structure

```
dbt/nyc_taxi_project/
│
├── models/
│   ├── staging/
│   │   └── stg_trips.sql          # Cleaned and standardized trip data
│   │
│   ├── intermediate/
│   │   └── int_trips_enriched.sql  # Enriched with business metrics
│   │
│   └── marts/
│       └── fact_trips.sql          # Final analytics-ready fact table
│
├── tests/
│   ├── assert_positive_fares.sql
│   └── assert_valid_distances.sql
│
├── macros/
│   └── generate_alias_name.sql     # Custom jinja macros
│
├── analyses/
│   └── exploratory_queries.sql
│
├── seeds/
│   └── reference_data.csv          # Static reference tables
│
├── dbt_project.yml                 # Project configuration
└── profiles.yml                    # Connection credentials
```

### Model Dependency Graph

```
source(raw.yellow_taxi_trips)
        ↓
    stg_trips (STAGING)
        ↓
int_trips_enriched (INTERMEDIATE)
        ↓
   fact_trips (MART)
```

**Dependency Flow:**

1. **stg_trips** – Cleans raw data, applies business naming
2. **int_trips_enriched** – Enriches with calculated fields
3. **fact_trips** – Materializes final analytics table

---

## 🧪 Data Quality Framework

Comprehensive data quality testing is embedded at each layer using dbt's testing framework.

### Test Suite

```yaml
Tests Implemented:
  ✅ not_null              → Ensures critical fields are populated
  ✅ unique                → Validates primary key uniqueness
  ✅ relationships         → Enforces referential integrity
  ✅ accepted_values       → Validates domain constraints
  ✅ custom_range_checks   → Fare and distance validation
  ✅ freshness_checks      → Ensures data currency
```

### Running Tests

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test -s stg_trips

# Run tests and fail fast
dbt test --fail-fast
```

**Test Results:** All tests pass on the current dataset ✅

---

## 📊 Documentation & Lineage

Documentation is automatically generated and hosted via dbt's documentation portal.

### Generate & Serve Documentation

```bash
# Generate documentation
dbt docs generate

# Launch local documentation server
dbt docs serve
```

### Documentation Includes

| Item | Description |
|------|-------------|
| **DAG Lineage** | Visual dependency graph of all models |
| **Model Descriptions** | Business logic explanation for each model |
| **Column Documentation** | Data dictionary with field-level metadata |
| **Test Coverage** | Visibility of all implemented tests |
| **Source Definitions** | Raw table schema and lineage |

---

## 🚀 Getting Started

### Prerequisites

- Python 3.8+
- Snowflake account with appropriate permissions
- Git

### Installation & Setup

#### 1️⃣ Clone the Repository

```bash
git clone https://github.com/EliandyDumortier/nyc-taxi-dw.git
cd nyc-taxi-dw
```

#### 2️⃣ Create Python Virtual Environment

```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

#### 3️⃣ Install dbt

```bash
pip install dbt-core dbt-snowflake
```

#### 4️⃣ Configure Snowflake Connection

Edit `~/.dbt/profiles.yml`:

```yaml
nyc_taxi:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: [YOUR_SNOWFLAKE_ACCOUNT]
      user: [YOUR_USERNAME]
      password: [YOUR_PASSWORD]
      warehouse: COMPUTE_WH
      database: NYC_TAXI
      schema: ANALYTICS_DEV
      threads: 4
      client_session_keep_alive: false
```

#### 5️⃣ Execute Snowflake Setup

```bash
# Run SQL setup scripts in order
# (See Snowflake Setup section above)
```

#### 6️⃣ Run dbt Transformations

```bash
# Install dependencies
dbt deps

# Run all models
dbt run

# Run all tests
dbt test

# Generate documentation
dbt docs generate
dbt docs serve  # Opens http://localhost:8000
```

---

## 📈 Dataset Details

| Attribute | Value |
|-----------|-------|
| **Source** | NYC Taxi & Limousine Commission |
| **Period Analyzed** | 2024 |
| **Total Records** | 39M+ |
| **File Format** | Parquet |
| **Ingestion Method** | Snowflake Internal Stage + COPY INTO |
| **Storage** | Snowflake Warehouse |

### Key Fields

```
pickup_datetime, dropoff_datetime, passenger_count, trip_distance,
fare_amount, extra, mta_tax, tip_amount, tolls_amount, total_amount,
payment_type, vendor_id, rate_code_id, pickup_location_id,
dropoff_location_id, congestion_surcharge
```

---

## 🧠 Key Learnings & Best Practices

### Analytics Engineering Mastery

- ✅ **Medallion Architecture** – Multi-layer data organization for scalability
- ✅ **dbt Fundamentals** – Sources, refs, models, tests, documentation
- ✅ **Snowflake Expertise** – Warehouse configuration, staging, COPY INTO
- ✅ **Data Quality** – Automated testing, data validation frameworks
- ✅ **Version Control** – Infrastructure-as-code for data pipelines
- ✅ **Documentation** – Auto-generated lineage and metadata
- ✅ **Materialization Strategies** – Views vs tables for performance optimization
- ✅ **Schema Management** – Logical separation of concerns

### Technical Achievements

- Processed 40M+ records efficiently
- Implemented end-to-end data pipeline
- Built comprehensive testing suite
- Established documentation standards
- Created production-ready architecture

---

## ✨ Current Status

| Component | Status | Details |
|-----------|--------|---------|
| RAW Ingestion | ✅ Complete | 40M+ records loaded |
| STAGING Layer | ✅ Complete | Data cleaning implemented |
| INTERMEDIATE Layer | ✅ Complete | Business metrics calculated |
| MART Layer | ✅ Complete | Analytics tables ready |
| Data Quality Tests | ✅ Complete | All tests passing |
| Documentation | ✅ Complete | Full DAG & metadata |
| Deployment Ready | ✅ Yes | Production-grade setup |

---

## 💡 Future Enhancements

### Planned Improvements

- 📈 **Incremental Loading** – Only process new/changed records
- 📅 **Dimension Tables** – `dim_date`, `dim_location`, `dim_payment_type`
- 🔄 **CI/CD Pipeline** – GitHub Actions automation
- 🔐 **RBAC Implementation** – Production role-based access control
- 🗺️ **Geospatial Analysis** – Location-based aggregations
- 📊 **Advanced Metrics** – Revenue forecasting, demand prediction
- 🎯 **dbt Cloud Integration** – Managed orchestration and scheduling

---

## 🛠️ Tech Stack

<div align="center">

| Technology | Purpose | Version |
|-----------|---------|---------|
| ![Snowflake](https://img.shields.io/badge/Snowflake-Cloud%20Warehouse-29B5E8?logo=snowflake&logoColor=white) | Cloud Data Warehouse | Current |
| ![dbt](https://img.shields.io/badge/dbt-Transformation-FF694B?logo=dbt&logoColor=white) | Data Transformation Framework | 1.5+ |
| ![Python](https://img.shields.io/badge/Python-Scripting-3776AB?logo=python&logoColor=white) | Data Ingestion | 3.8+ |
| ![SQL](https://img.shields.io/badge/SQL-Query%20Language-4479A1?logo=postgresql&logoColor=white) | Data Querying | Standard |
| ![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?logo=git&logoColor=white) | Repository Management | Latest |

</div>

---

## 📚 Resources & References

### Official Documentation

- [Snowflake Documentation](https://docs.snowflake.com/)
- [dbt Core Documentation](https://docs.getdbt.com/)
- [Medallion Architecture Guide](https://www.databricks.com/blog/2022/06/24/redefining-delta-lake-medallion-architecture-best-practices.html)
- [NYC Taxi Dataset](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

### Learning Resources

- Analytics Engineering fundamentals
- Data warehouse design patterns
- SQL optimization techniques
- dbt best practices

---

## 👨‍💼 Author

**Eliandy Dumortier**

Analytics Engineer & Data Architect specializing in scalable data warehouse solutions and modern transformation frameworks.

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-Profile-100000?style=for-the-badge&logo=github)](https://github.com/EliandyDumortier/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/eliandy-r-4a0592a8)

</div>

---

## 📄 License

This project is open source and available under the **MIT License**. See the LICENSE file for details.

---

<div align="center">

### ⭐ If this project helped you, please consider giving it a star!

Built with dedication to analytics engineering best practices.

**Happy Analyzing! 📊**

</div>
