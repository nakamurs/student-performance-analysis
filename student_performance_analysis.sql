-- =========================================================================
-- Analyze my student performance at McMaster University from transcript
-- =========================================================================

/* Table: transcript
 * Contains performance data for each course
 * Columns:
 * 		term		: Academic term 
 * 		course		: Subject prefix and course code
 * 		title		: Course title
 *		attm_units	: Attempted units
 *		earned_units: Earned units
 *		grade		: Letter grade (A+ to F)
 */ 
CREATE TABLE transcript
(
	term VARCHAR(20) NOT NULL,
	course VARCHAR(20) PRIMARY KEY,
	title TEXT NOT NULL,
	attm_units FLOAT NOT NULL,
	earned_units FLOAT NOT NULL,
	grade VARCHAR(5) 
);

-- Insert values from my transcript into the table
INSERT INTO transcript
VALUES  
	('2022 Fall', 'ANTHROP 1AA3', 'Sex, Food & Death', 3.00, 3.00, 'C+'),
	('2022 Fall', 'COMPSCI 1JC3', 'Intro To Comput Thinking', 3.00, 3.00, 'A-'),
	('2022 Fall', 'COMPSCI 1MD3', 'Introduction To Programming', 3.00, 3.00, 'C'),
	('2022 Fall', 'ENGINEER 1EE0', 'Engineer Co-op Prm', 0.00, 0.00, 'COM'),
	('2022 Fall', 'MATH 1B03', 'Linear Algebra 1', 3.00, 3.00, 'A+'),
	('2022 Fall', 'MATH 1ZA3', 'Engineering Mathematics I', 3.00, 3.00, 'A+'),
	('2022 Fall', 'WHMIS 1A00', 'Intro To Health And Safety', 0.00, 0.00, 'COM'),
	('2023 Winter', 'COMPSCI 1DM3', 'Discrete Math for Comp Sci', 3.00, 3.00, 'A+'),
	('2023 Winter', 'COMPSCI 1XC3', 'Development Basics', 3.00, 3.00, 'A'),
	('2023 Winter', 'COMPSCI 1XD3', 'Intro to Sfwr Using Web Prog', 3.00, 3.00, 'A'),
	('2023 Winter', 'MATH 1ZB3', 'Engineering Mathematics II-A', 3.00, 3.00, 'A+'),
	('2023 Winter', 'PHILOS 1F03', 'Meaning in Life', 0.00, 0.00, 'W'), 
	('2023 Spring/Summer', 'MATH 2X03', 'Advanced Calculus I', 3.00, 3.00, 'A+'), 
	('2023 Spring/Summer', 'STATS 2D03', 'Intro To Probability', 3.00, 3.00, 'A+'),
	('2023 Fall', 'COMPSCI 2C03', 'Data Struct & Algorithms', 3.00, 3.00, 'A'),
	('2023 Fall', 'COMPSCI 2GA3', 'Computer Architecture', 3.00, 3.00, 'A+'),
	('2023 Fall', 'COMPSCI 2LC3', 'Logical Reasoning: Comp Sci', 3.00, 3.00, 'A+'),
	('2023 Fall', 'COMPSCI 2ME3', 'Intro To Software Development', 3.00, 3.00, 'B'),
	('2023 Fall', 'MATH 2LA3', 'Applications of Linear Algebra', 3.00, 3.00, 'A+'),
	('2024 Winter', 'COMPSCI 2AC3', 'Automata and Computability', 3.00, 3.00, 'A-'),
	('2024 Winter', 'COMPSCI 2DB3', 'Databases', 3.00, 3.00, 'A+'),
	('2024 Winter', 'COMPSCI 2SD3', 'Concurrent Systems', 3.00, 3.00, 'B+'),
	('2024 Winter', 'COMPSCI 2XC3', 'Algorithms and Software Design', 3.00, 3.00, 'A+'),
	('2024 Spring/Summer', 'MATH 2Z03', 'Engineering Math III', 3.00, 3.00, 'A+'),
	('2024 Fall', 'COMPSCI 3MI3', 'Prncpl: Programming Languages', 3.00, 3.00, 'A+'),
	('2024 Fall', 'COMPSCI 3SH3', 'Operating Systems', 3.00, 3.00, 'A'),
	('2024 Fall', 'COMPSCI 4X03', 'Scientific Computation', 3.00, 3.00, 'A+'),
	('2024 Fall', 'MATH 3C03', 'Mathematical Physics I', 3.00, 3.00, 'A+'),
	('2025 Winter', 'COMPSCI 3AC3', 'Algorithms and Complexity', 3.00, 3.00, 'A+'),
	('2025 Winter', 'COMPSCI 3N03', 'Computer Networks and Security', 3.00, 3.00, 'A+'),
	('2025 Winter', 'COMPSCI 3TB3', 'Syntax-Based Tools & Compilers', 3.00, 3.00, 'A+'),
	('2025 Winter', 'DATASCI 3ML3', 'Neural Netwrks & Machine Lrnig', 3.00, 3.00, 'A+'),
	('2025 Winter', 'STATS 2MB3', 'Stats Methods&Application', 3.00, 3.00, 'A+'),
	('2025 Spring/Summer', 'PHYSICS 1A03', 'Introductory Physics', 3.00, 0.00, NULL),
	('2025 Spring/Summer', 'PHYSICS 1AA3', 'Introduction To Modern Physics', 3.00, 0.00, NULL);

/* Table: scheme
 * Contains the grading scheme that maps letter grades to numeric point values.
 * Columns:
 * 		grade		: Letter grade (A+ to F)
 * 		points		: Corresponding point value (A+ = 12, ..., F = 0)
 */ 
CREATE TABLE scheme 
(
	grade VARCHAR(5) PRIMARY KEY,
	points INT NOT NULL
);

--  Insert based on McMaster’s official grading scale
INSERT INTO scheme
VALUES 	
	('A+', 12),
	('A', 11),
	('A-', 10),
	('B+', 9),
	('B', 8),
	('B-', 7),
	('C+', 6),
	('C', 5),
	('C-', 4),
	('D+', 3),
	('D', 2),
	('D-', 1),
	('F', 0);

/* Query 1 : Compute cumulative GPA in 4.0 scale
 * 
 * Official formula by McMaster: GPA = (total points) / (total units),
 * where total points are the sum of (point × units) for each taken course.
 * Non-numeric grades (e.g., 'COM', 'W') are excluded from the calculation.
 * GPA is first computed on a 12-point scale, then divided by 3 to get the 4.0 scale GPA.
 */
SELECT 
	COUNT(course) AS course_count,
	SUM(s.points*t.earned_units) AS total_points,
	SUM(t.earned_units) AS total_units,
	SUM(s.points*t.earned_units)/SUM(t.earned_units) AS gpa_12_scale,
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa_4_scale
FROM transcript t JOIN scheme s --  Use JOIN to exclude courses that have non-numeric grades or not been taken yet.
ON t.grade = s.grade;

/* Observations: 
 * 
 * I have taken 30 courses and achieved a cumulative GPA of ≈3.7/4.0.
 */

/* Query 2 : Compare performance by each term
 * 
 * Calculate the number of courses and GPA for each term.
 */
SELECT 
	t.term,
	COUNT(t.course) AS course_count, 
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa
FROM transcript t JOIN scheme s
ON t.grade = s.grade
GROUP BY t.term
ORDER BY gpa DESC; -- Order from highest grade

/* Observations: 
 * 
 * I performed the weakest in the first semester (2022 Fall).
 * This is likely due to the difficulty of transitioning to university.
 * I tend to perform well in Spring/Summer semeters.
 * Now, let's verify this by comparing performance for each season.
 */

/* Query 3 : Compare performance by each season
 * 
 * Calculate the number of courses and GPA for each season.
 */
SELECT 
	SPLIT_PART(t.term, ' ', 2) AS season, -- Extract season from term (e.g., Fall from 2022 Fall)
	COUNT(t.course) AS course_count, 
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa
FROM transcript t JOIN scheme s
ON t.grade = s.grade
GROUP BY season
ORDER BY gpa DESC;

/* Observations: 
 * 
 * My intuition was correct. I record a 4.0/4,0 GPA for Spring/Summer.
 */

/* Query 4 : Compare performance by each year
 * 
 * Calculate the number of courses and GPA for each year.
 */

SELECT 
	SPLIT_PART(t.term, ' ', 1) AS year, -- Extract year from term (e.g., 2022 from 2022 Fall)
	COUNT(t.course) AS course_count, 
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa
FROM transcript t JOIN scheme s
ON t.grade = s.grade
GROUP BY YEAR 
ORDER BY year ASC; -- Sort them in ascending order of year

/* Observation: 
 * 
 * It seems that my performance is improving each year.
 * However, there is a variety in the number of courses for each year.
 * To address this, we compare for each academic year (e.g., 1st year, 2nd year).
 */

/* Query 5 : Compare performance by each academic year
 * 
 * Calculate the number of courses taken and gpa for each academic year.
 */

SELECT 
	CASE -- Classify each term into academic year
		WHEN t.term IN ('2022 Fall', '2023 Winter', '2023 Spring/Summer') THEN '1st Year'
		WHEN t.term IN ('2023 Fall', '2024 Winter', '2024 Spring/Summer') THEN '2nd Year'
		WHEN t.term IN ('2024 Fall', '2025 Winter', '2025 Spring/Summer') THEN '3rd Year'
	END AS academic_year,
	COUNT(t.course) AS course_count, 
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa
FROM transcript t JOIN scheme s
ON t.grade = s.grade
GROUP BY academic_year
ORDER BY academic_year;

/* Observations:
 * 
 * It's become more obvious that my performance improved each year.
 */

/* Query 6 : Compare performance by each subject
 * 
 * Calculate the number of courses taken and GPA for each subject.
 */

SELECT 
	SPLIT_PART(t.course, ' ', 1) AS subject, -- Extract prefix from course (e.g., COMPSCI from COMPSCI 1JC3)
	COUNT(t.course) AS course_count, 
	SUM(s.points*t.earned_units)/SUM(t.earned_units)/3 AS gpa  
FROM transcript t JOIN scheme s
ON t.grade = s.grade
GROUP BY subject
ORDER BY course_count DESC;

/* Observations:
 * 
 * I achieved perfect GPAs (4.0/4.0) for Math despite taking 7 courses.
 * From 2.0 GPA, It's clear that Anthropology didn't align well with my strengths.
 */

/* Conclusions:
 * 
 * Cumulative GPA	: 3.7 / 4.0
 * Strong eason	: Spring/Summer
 * Strong subject	: Math
 * Attribute		: Consistent yearly improvement
 */