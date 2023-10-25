DECLARE
  numer_max NUMBER;
BEGIN
  SELECT MAX(department_id) INTO numer_max FROM departments;
  INSERT INTO departments (department_id, department_name)
  VALUES (numer_max + 10, 'EDUCATION');
  COMMIT;
END;
/
DECLARE
  numer_max NUMBER;
BEGIN
  SELECT MAX(department_id) INTO numer_max FROM departments;
  UPDATE departments
  SET location_id = 3000
  WHERE department_id = numer_max + 10;
  COMMIT;
END;
/
CREATE TABLE nowa (wartosc VARCHAR2(10));
BEGIN
  FOR i IN 1..10 LOOP
    IF i NOT IN (4, 6) THEN
      INSERT INTO nowa (wartosc) VALUES (TO_CHAR(i));
    END IF;
  END LOOP;
  COMMIT;
END;
/
DECLARE
  kraj countries%ROWTYPE;
BEGIN
  SELECT * INTO kraj FROM countries WHERE country_id = 'CA';
  DBMS_OUTPUT.PUT_LINE('Kraj: ' || kraj.country_name || ', Region ID: ' || kraj.region_id);
END;
/
DECLARE
  TYPE departament_tab IS TABLE OF departments.department_name%TYPE INDEX BY PLS_INTEGER;
  departamenty departament_tab;
BEGIN
  FOR i IN 10..100 LOOP
    IF MOD(i, 10) = 0 THEN
      SELECT department_name INTO departamenty(i) FROM departments WHERE department_id = i;
    END IF;
  END LOOP;
  
  FOR i IN departamenty.FIRST..departamenty.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Numer: ' || i || ', Departament: ' || departamenty(i));
  END LOOP;
END;
/

DECLARE
  TYPE departament_tab IS TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER;
  departamenty departament_tab;
BEGIN
  FOR i IN 10..100 LOOP
    IF MOD(i, 10) = 0 THEN
      SELECT * INTO departamenty(i) FROM departments WHERE department_id = i;
    END IF;
  END LOOP;
  
  FOR i IN departamenty.FIRST..departamenty.LAST LOOP
    DBMS_OUTPUT.PUT_LINE('Numer: ' || i || ', Departament: ' || departamenty(i).department_name || ', Lokacja: ' || departamenty(i).location_id);
  END LOOP;
END;
/

DECLARE
  CURSOR cur_wynagrodzenie IS
    SELECT last_name, salary
    FROM employees
    WHERE department_id = 50;

  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  FOR rec IN cur_wynagrodzenie LOOP
    v_last_name := rec.last_name;
    v_salary := rec.salary;
    
    IF v_salary > 3100 THEN
      DBMS_OUTPUT.PUT_LINE(v_last_name || ' - nie dawaæ podwy¿ki');
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_last_name || ' - daæ podwy¿kê');
    END IF;
  END LOOP;
END;
/


DECLARE
  CURSOR cur_zarobki (min_salary NUMBER, max_salary NUMBER, partial_name VARCHAR2) IS
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary BETWEEN min_salary AND max_salary
    AND (first_name LIKE partial_name OR first_name LIKE UPPER(partial_name));
    
  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  -- a. Pracownicy z zarobkami 1000-5000 i czêœci¹ imienia 'a' lub 'A'
  FOR rec IN cur_zarobki(1000, 5000, '%a%') LOOP
    v_first_name := rec.first_name;
    v_last_name := rec.last_name;
    v_salary := rec.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
  END LOOP;

  -- b. Pracownicy z zarobkami 5000-20000 i czêœci¹ imienia 'u' lub 'U'
  FOR rec IN cur_zarobki(5000, 20000, '%u%') LOOP
    v_first_name := rec.first_name;
    v_last_name := rec.last_name;
    v_salary := rec.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ', Zarobki: ' || v_salary);
  END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE dodaj_job(
  p_job_id jobs.job_id%TYPE,
  p_job_title jobs.job_title%TYPE
)
AS
BEGIN
  INSERT INTO jobs (job_id, job_title) VALUES (p_job_id, p_job_title);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE modyfikuj_job_title(
  p_job_id jobs.job_id%TYPE,
  p_new_title jobs.job_title%TYPE
)
AS
BEGIN
  UPDATE jobs
  SET job_title = p_new_title
  WHERE job_id = p_job_id;
  
  IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Brak wierszy zaktualizowanych (no Jobs updated).');
  ELSE
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE usun_job(
  p_job_id jobs.job_id%TYPE
)
AS
BEGIN
  DELETE FROM jobs WHERE job_id = p_job_id;
  
  IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Brak wierszy usuniêtych (no Jobs deleted).');
  ELSE
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE pobierz_zarobki(
  p_employee_id employees.employee_id%TYPE,
  o_last_name OUT employees.last_name%TYPE,
  o_salary OUT employees.salary%TYPE
)
AS
BEGIN
  SELECT last_name, salary INTO o_last_name, o_salary
  FROM employees
  WHERE employee_id = p_employee_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Brak pracownika o ID ' || p_employee_id);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
/


CREATE SEQUENCE employee_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE dodaj_pracownika(
  p_first_name employees.first_name%TYPE,
  p_last_name employees.last_name%TYPE,
  p_salary employees.salary%TYPE,
  p_email employees.email%TYPE DEFAULT 'NA',
  p_job_id employees.job_id%TYPE DEFAULT 'ST_CLERK',
  p_manager_id employees.employee_id%TYPE DEFAULT NULL,
  p_department_id employees.department_id%TYPE DEFAULT NULL
)
AS
BEGIN
  IF p_salary > 20000 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Wynagrodzenie przekracza 20000, nie mo¿na dodaæ pracownika.');
  ELSE
    INSERT INTO employees (employee_id, first_name, last_name, salary, email, job_id, manager_id, department_id)
    VALUES (employee_seq.NEXTVAL, p_first_name, p_last_name, p_salary, p_email, p_job_id, p_manager_id, p_department_id);
    COMMIT;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
/



