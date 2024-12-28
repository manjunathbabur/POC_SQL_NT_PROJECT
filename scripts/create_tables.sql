-- Create a simple employees table
CREATE OR REPLACE TABLE employees (
    id INT,
    name STRING,
    department STRING,
    salary DECIMAL(10, 2)
);

-- Create a simple departments table
CREATE OR REPLACE TABLE departments (
    department_id INT,
    department_name STRING
);
