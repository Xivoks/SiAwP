
CREATE OR REPLACE PACKAGE employee_pkg IS
  FUNCTION get_job_title(p_job_id jobs.job_id%TYPE) RETURN jobs.job_title%TYPE;
  FUNCTION calculate_annual_salary(p_employee_id employees.employee_id%TYPE) RETURN NUMBER;
  FUNCTION extract_area_code(p_phone VARCHAR2) RETURN VARCHAR2;
  FUNCTION capitalize_first_last(p_string VARCHAR2) RETURN VARCHAR2;
  FUNCTION pesel_to_dob(p_pesel CHAR) RETURN DATE;
  FUNCTION count_employees_departments(p_country_name VARCHAR2) RETURN VARCHAR2;
END employee_pkg;
/


CREATE OR REPLACE PACKAGE BODY employee_pkg IS

  FUNCTION get_job_title(p_job_id jobs.job_id%TYPE) RETURN jobs.job_title%TYPE IS
    v_job_title jobs.job_title%TYPE;
  BEGIN
    SELECT job_title INTO v_job_title FROM jobs WHERE job_id = p_job_id;
    RETURN v_job_title;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Job with provided ID does not exist');
  END get_job_title;

  FUNCTION calculate_annual_salary(p_employee_id employees.employee_id%TYPE) RETURN NUMBER IS
    v_annual_salary NUMBER;
    v_commission_pct employees.commission_pct%TYPE;
  BEGIN
    SELECT salary, NVL(commission_pct, 0) INTO v_annual_salary, v_commission_pct 
    FROM employees WHERE employee_id = p_employee_id;
    v_annual_salary := v_annual_salary * (12 + v_commission_pct);
    RETURN v_annual_salary;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Employee with provided ID does not exist');
  END calculate_annual_salary;

  FUNCTION extract_area_code(p_phone VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN SUBSTR(p_phone, 1, INSTR(p_phone, ')') - 1);
  END extract_area_code;

  FUNCTION capitalize_first_last(p_string VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN UPPER(SUBSTR(p_string, 1, 1)) ||
           LOWER(SUBSTR(p_string, 2, LENGTH(p_string) - 2)) ||
           UPPER(SUBSTR(p_string, LENGTH(p_string), 1));
  END capitalize_first_last;

  FUNCTION pesel_to_dob(p_pesel CHAR) RETURN DATE IS
    v_birth_date DATE;
  BEGIN
    v_birth_date := TO_DATE(SUBSTR(p_pesel, 1, 6), 'YYMMDD');
    RETURN v_birth_date;
  END pesel_to_dob;

  FUNCTION count_employees_departments(p_country_name VARCHAR2) RETURN VARCHAR2 IS
    v_employee_count NUMBER;
    v_department_count NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_employee_count
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    SELECT COUNT(*)
    INTO v_department_count
    FROM departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    WHERE c.country_name = p_country_name;

    RETURN 'Employees: ' || TO_CHAR(v_employee_count) || ' Departments: ' || TO_CHAR(v_department_count);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005, 'No country with the provided name exists');
  END count_employees_departments;

END employee_pkg;
/


CREATE OR REPLACE PACKAGE regions_pkg IS
  PROCEDURE create_region(p_region_id REGIONS.REGION_ID%TYPE, p_region_name REGIONS.REGION_NAME%TYPE);
  PROCEDURE update_region(p_region_id REGIONS.REGION_ID%TYPE, p_region_name REGIONS.REGION_NAME%TYPE);
  PROCEDURE delete_region(p_region_id REGIONS.REGION_ID%TYPE);
  FUNCTION read_region(p_region_id REGIONS.REGION_ID%TYPE DEFAULT NULL, p_region_name REGIONS.REGION_NAME%TYPE DEFAULT NULL) RETURN SYS_REFCURSOR;
END regions_pkg;
/


CREATE OR REPLACE PACKAGE BODY regions_pkg IS

  PROCEDURE create_region(p_region_id REGIONS.REGION_ID%TYPE, p_region_name REGIONS.REGION_NAME%TYPE) IS
  BEGIN
    INSERT INTO REGIONS (REGION_ID, REGION_NAME) VALUES (p_region_id, p_region_name);
  END create_region;

  PROCEDURE update_region(p_region_id REGIONS.REGION_ID%TYPE, p_region_name REGIONS.REGION_NAME%TYPE) IS
  BEGIN
    UPDATE REGIONS SET REGION_NAME = p_region_name WHERE REGION_ID = p_region_id;
  END update_region;

  PROCEDURE delete_region(p_region_id REGIONS.REGION_ID%TYPE) IS
  BEGIN
    DELETE FROM REGIONS WHERE REGION_ID = p_region_id;
  END delete_region;

  FUNCTION read_region(p_region_id REGIONS.REGION_ID%TYPE DEFAULT NULL, p_region_name REGIONS.REGION_NAME%TYPE DEFAULT NULL) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR 
      SELECT * 
      FROM REGIONS 
      WHERE (p_region_id IS NULL OR REGION_ID = p_region_id) 
      AND (p_region_name IS NULL OR REGION_NAME LIKE p_region_name || '%');
    RETURN v_cursor;
  END read_region;

END regions_pkg;
/

