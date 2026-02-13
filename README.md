/
├──
.gitignore # Ignorar archivos del sistema/temporales
├── README.md # Portada del proyecto (Team names, Project desc)
├── ROLES.md # El Team Charter (ver punto 3)
├── /docs # Documentation
│ ├── dictionary.md # Data Dictionary (English)
│ └── erd
_
diagram.mmd # Entity-Relationship Diagram (Mermaid code)
├── /src # Source Code
│ ├── 01
_
schema.sql # DDL: CREATE TABLES, Constraints
│ ├── 02
_
seed.sql # DML: INSERT initial mock data
│ └── 03
_
users.sql # DCL: CREATE USER, GRANT permissions
├── /queries # Consultas requeridas
│ ├── report
_
sales.sql # Example complex query
│ └── analysis.sql # Aggregations & Joins
└── /tests # Quality Assurance
├── bug_
report.md # Registro de errores encontrados
└── test
_
cases.sql # Scripts para intentar "romper" la BD