/*
===============================
	WINDOW FUNCTION
	LAB 04 
	MSSV: 22280060
	Họ và tên: Võ Duy Nghĩa
===============================
Script Purpose
	- Tìm hiểu về window function
	- Những hàm basic
	- Sử dụng chia partition by, chia order by, chia frame
	- Kết hợp window function với group by
	- Tìm hiểu Lead lag
===============================
*/


set role hradmin;
set search_path = hrschema;
show search_path;


-- a. Hiển thị job_title, số lượng nhân viên và lương trung bình theo từng job_title.
SELECT 
    j.job_title
    , COUNT(e.employee_id) AS num_employees
    , ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN jobs j 
	ON e.job_id = j.job_id
GROUP BY j.job_title
ORDER BY num_employees DESC;

-- b. Với mỗi nhân viên, hiển thị first_name, last_name, salary và tổng salary của các nhân viên trong công ty.
SELECT 
	first_name
	, last_name
	, salary
	, SUM(salary) OVER() as total_salary
FROM employees

-- c. Với mỗi nhân viên, hiển thị first_name, last_name, salary, trung bình lương của các nhân viên trong công ty và sự chênh lệch lương của từng nhân viên với lương trung bình của công ty.
SELECT 
		first_name
		, last_name
		, salary
		, ROUND(AVG(salary) OVER() , 2) as avg_salary
		, ROUND(salary - AVG(salary) OVER (), 2) AS salary_difference
FROM employeeS e

-- d. Với mỗi nhân viên của phòng ban ‘IT': hiển thị first_name, last_name, salary và chênh lệch giữa lương của từng nhân viên với lương trung bình của các nhân viên trong phòng ban ‘IT'.
WITH it_employees AS (
    SELECT 
        e.employee_id
        , e.first_name
        , e.last_name
        , e.salary
    FROM 
        employees e
    JOIN departments d 
		ON e.department_id = d.department_id
    WHERE 
        d.department_name = 'IT'
)
SELECT 
    first_name
    , last_name
    , salary
    , ROUND(AVG(salary) OVER (), 2) AS avg_it_salary
    , ROUND(salary - AVG(salary) OVER (), 2) AS salary_diff
FROM it_employees;


-- e. Với mỗi nhân viên có mức lương hơn 7000, hiển thị first_name, last_name, salary và số lượng nhân viên có lương cao hơn 7000, sắp xếp theo lương từ cao đến thấp.
WITH high_salary_employees AS (
    SELECT 
        first_name
        , last_name
        , salary
    FROM employees
    WHERE salary > 7000
)
SELECT 
    first_name
    , last_name
    , salary
    , COUNT(*) OVER () AS number_high_employees
FROM high_salary_employees
ORDER BY salary DESC;

-- f. Hiển thị first_name, last_name, tháng nhân viên đó được tuyển và số lượng nhân viên được tuyển trong tháng đó.
SELECT 
    first_name
    , last_name
    , TO_CHAR(hire_date, 'MM-YYYY') AS hire_month
    , COUNT(*) OVER (PARTITION BY TO_CHAR(hire_date, 'YYYY-MM')) AS hires_in_month
FROM employees
ORDER BY hire_month;

-- g. Hiển thị employee_id, first_name, last_name, tháng được tuyển, salary, manager_id, tên manager, lương cao nhất trong nhóm các nhân viên được tuyển cùng tháng và cùng manager, sắp xếp theo manager_id và tháng được tuyển.

SELECT 
    e_main.first_name
    , e_main.last_name
    , TO_CHAR(e_main.hire_date, 'YYYY-MM') AS hire_month
	, e_main.salary
	, e_main.manager_id
	, e_temp.first_name AS manager_name
	, COUNT(*) OVER (PARTITION BY TO_CHAR(e_main.hire_date, 'YYYY-MM')) AS hires_in_month
	, MAX(e_main.salary) OVER (PARTITION BY TO_CHAR(e_main.hire_date, 'YYYY-MM'), e_main.manager_id) AS max_salary_both_month_manager
FROM employees AS e_main
JOIN employees AS e_temp
	ON e_main.manager_id = e_temp.employee_id

-- h. Với mỗi nhân viên, hiển thị employee_ id, job_title, tên phòng ban nhân viên đó làm việc, số lượng nhân viên trong phòng ban cùng job_title và số lượng nhân viên cùng phòng ban.
SELECT 
    e.employee_id
    , j.job_title
    , d.department_name
    , COUNT(*) OVER (PARTITION BY d.department_id, j.job_title) as employees_both_dep_job
    , COUNT(*) OVER (PARTITION BY d.department_id) as employees_by_dep
FROM employees e
JOIN jobs j 
	ON e.job_id = j.job_id
JOIN departments d 
	ON e.department_id = d.department_id
ORDER BY e.employee_id;

-- i. Với mỗi nhân viên, hiển thị employee_id, salary, department_name, và ratio. Ratio được tính bằng lương của nhân viên trên tổng lương nhân viên trong cùng phòng ban, sắp xếp theo phòng ban.
SELECT 
    e.employee_id
    , e.salary
    , d.department_name
    , ROUND(e.salary / (SUM(e.salary) OVER (PARTITION BY d.department_id)) * 100, 2) as ratio
FROM employees e
JOIN departments d 
	ON e.department_id = d.department_id
ORDER BY d.department_name, e.employee_id;

-- j. Sắp xếp nhân viên tăng dần theo salary, và tìm 20% nhân viên có lương cao nhất (Dùng ROW_NUMBER )
WITH RankedEmployees AS (
    SELECT 
        employee_id
        , salary
        , ROW_NUMBER() OVER (ORDER BY salary DESC) as rank_salary
        , COUNT(*) OVER () as total_count
    FROM employees
)
SELECT 
    employee_id
    , salary
    , rank_salary
    , total_count
FROM RankedEmployees
WHERE rank_salary <= (total_count * 0.2)
ORDER BY salary DESC;

-- k. Với thành phố ’Seattle‘, hiển thị tên thành phố, tên các phòng ban và số lượng nhân viên trong từng phòng ban, đồng thời hiển thị số phần trăm nhân viên của phòng ban đó trên tổng nhân viên trong thành phố.
-- Kết hợp Group By và Window Function, group by thực hiện trước sau đó mới tới window function
SELECT 
    l.city
    , d.department_name,
    , COUNT(e.employee_id) as employee_count
    ROUND(
        (COUNT(e.employee_id) / 
         SUM(COUNT(e.employee_id)) OVER ()) * 100
        , 2
    ) as percentage_of_total
FROM locations l
JOIN departments d 
	ON l.location_id = d.location_id
LEFT JOIN employees e 
	ON d.department_id = e.department_id
WHERE l.city = 'Seattle'
GROUP BY 
    l.city, d.department_name
ORDER BY 
    d.department_name;
	
-- l. Hiển thị first_name, last_name, tên phòng ban, phân hạng DENSE_RANK theo lương từ cao đến thấp và chia thành 3 nhóm theo lương từ cao đến thấp (chia thành 3 nhóm dùng hàm NTILE()).
SELECT 
    e.first_name
    , e.last_name
    , d.department_name
    , e.salary
    , DENSE_RANK() OVER (ORDER BY e.salary DESC) as salary_rank
    , NTILE(3) OVER (ORDER BY e.salary DESC) as salary_group
FROM employees e
LEFT JOIN departments d 
	ON e.department_id = d.department_id

-- m. Với mỗi quốc gia, hiển thị số lượng nhân viên, tổng lương phải trả, lương trung bình và sự chênh lệch lương trung bình giữa 2 quốc gia liền kề nhau, sắp xếp theo thứ tự lương trung bình giảm dần.
-- Dùng lead lag, cte
WITH CountryStats AS (
    SELECT 
        c.country_name,
        , COUNT(e.employee_id) as employee_count
        , SUM(e.salary) as total_salary
        , ROUND(AVG(e.salary), 2) as avg_salary
    FROM countries c
	LEFT JOIN locations l 
		ON c.country_id = l.country_id
	LEFT JOIN departments d 
		ON l.location_id = d.location_id
	LEFT JOIN employees e 
		ON d.department_id = e.department_id
    GROUP BY 
        c.country_name
)
SELECT 
    country_name
    , employee_count
    , total_salary
    , avg_salary
    , ROUND(
        avg_salary - LEAD(avg_salary) OVER (ORDER BY avg_salary DESC)
        , 2
    ) as salary_diff
FROM CountryStats
ORDER BY avg_salary DESC;
