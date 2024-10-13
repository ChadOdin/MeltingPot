# SQL Cheatsheet

```markdown
### SELECT: Retrieve data from a database
- **Explanation**: The SELECT statement retrieves data from one or more tables in a database. It allows you to specify the columns you want to retrieve and apply filtering conditions using the WHERE clause.
- **Example 1**: Retrieve all columns from a table:
  ```sql
  SELECT * FROM table_name;
  ```
- **Example 2**: Retrieve specific columns with a filtering condition:
  ```sql
  SELECT column1, column2 FROM table_name WHERE condition;
  ```

### INSERT: Insert data into a table
- **Explanation**: The INSERT statement is used to add new records into a table. It allows you to specify the columns into which you want to insert data and provide the corresponding values.
- **Example**: Insert a new record into a table:
  ```sql
  INSERT INTO table_name (column1, column2) VALUES (value1, value2);
  ```

### UPDATE: Update existing data in a table
- **Explanation**: The UPDATE statement modifies existing records in a table. It allows you to set new values for specific columns based on a filtering condition.
- **Example**: Update existing records in a table:
  ```sql
  UPDATE table_name SET column1 = value1 WHERE condition;
  ```

### DELETE: Delete data from a table
- **Explanation**: The DELETE statement removes records from a table based on a specified condition.
- **Example**: Delete records from a table:
  ```sql
  DELETE FROM table_name WHERE condition;
  ```

### CREATE TABLE: Create a new table
- **Explanation**: The CREATE TABLE statement creates a new table in the database. It allows you to specify the table's structure by defining the column names and data types.
- **Example**: Create a new table:
  ```sql
  CREATE TABLE table_name (
      column1 datatype,
      column2 datatype,
      ...
  );
  ```

### ALTER TABLE: Add, modify, or drop columns in an existing table
- **Explanation**: The ALTER TABLE statement allows you to add, modify, or drop columns in an existing table.
- **Examples**:
  - Add a new column to a table:
    ```sql
    ALTER TABLE table_name ADD column_name datatype;
    ```
  - Modify an existing column:
    ```sql
    ALTER TABLE table_name MODIFY column_name new_datatype;
    ```
  - Drop a column from a table:
    ```sql
    ALTER TABLE table_name DROP column_name;
    ```

### DROP TABLE: Delete a table
- **Explanation**: The DROP TABLE statement removes a table and all its data from the database.
- **Example**: Delete a table:
  ```sql
  DROP TABLE table_name;
  ```

### JOIN: Combine rows from multiple tables
- **Explanation**: The JOIN clause is used to combine rows from two or more tables based on a related column between them.
- **Example**: Perform an inner join between two tables:
  ```sql
  SELECT columns FROM table1 INNER JOIN table2 ON table1.column = table2.column;
  ```

### GROUP BY: Group rows that have the same values into summary rows
- **Explanation**: The GROUP BY clause groups rows that have the same values into summary rows. It is often used with aggregate functions like COUNT, SUM, AVG, etc.
- **Example**: Group rows by a specific column and count the occurrences:
  ```sql
  SELECT column1, COUNT(*) FROM table_name GROUP BY column1;
  ```

### ORDER BY: Sort the result set
- **Explanation**: The ORDER BY clause is used to sort the result set in ascending or descending order based on one or more columns.
- **Example**: Sort the result set by a specific column in descending order:
  ```sql
  SELECT * FROM table_name ORDER BY column1 DESC;
  ```

### WHERE: Filter records
- **Explanation**: The WHERE clause is used to filter records based on a specified condition.
- **Example**: Filter records based on a condition:
  ```sql
  SELECT * FROM table_name WHERE condition;
  ```

### LIKE: Search for a pattern in a column
- **Explanation**: The LIKE operator is used to search for a specified pattern in a column.
- **Example**: Search for a pattern in a column:
  ```sql
  SELECT * FROM table_name WHERE column1 LIKE 'pattern%';
  ```

### LIMIT: Limit the number of records returned
- **Explanation**: The LIMIT clause is used to restrict the number of rows returned by a query.
- **Example**: Limit the number of records returned:
  ```sql
  SELECT * FROM table_name LIMIT 10;
  ```

### DISTINCT: Return unique values
- **Explanation**: The DISTINCT keyword is used to return unique values in a specified column or columns.
- **Example**: Return unique values from a column:
  ```sql
  SELECT DISTINCT column1 FROM table_name;
  ```

### COUNT: Count the number of rows
- **Explanation**: The COUNT function is used to count the number of rows in a result set or the number of occurrences of a value in a column.
- **Example**: Count the number of rows in a table:
  ```sql
  SELECT COUNT(*) FROM table_name;
  ```

### MAX/MIN: Find the maximum/minimum value
- **Explanation**: The MAX and MIN functions are used to find the maximum and minimum values in a column, respectively.
- **Examples**:
  - Find the maximum value in a column:
    ```sql
    SELECT MAX(column1) FROM table_name;
    ```
  - Find the minimum value in a column:
    ```sql
    SELECT MIN(column1) FROM table_name;
    ```

### AVG: Calculate the average value
- **Explanation**: The AVG function is used to calculate the average value of a numeric column.
- **Example**: Calculate the average value of a column:
  ```sql
  SELECT AVG(column1) FROM table_name;
  ```

### SUM: Calculate the sum of values
- **Explanation**: The SUM function is used to calculate the sum of values in a numeric column.
- **Example**: Calculate the sum of values in a column:
  ```sql
  SELECT SUM(column1) FROM table_name;
  ```
