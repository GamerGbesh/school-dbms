DROP TABLE students;
CREATE TABLE IF NOT EXISTS students(
	id SERIAL PRIMARY KEY,
	name VARCHAR(32),
	Year_of_birth INTEGER,
	Year_of_admission INTEGER,
	gender char(1)
	
);

INSERT INTO students ("year_of_admission", "gender")
VALUES (2024, 'M');

SELECT * FROM students;


SELECT ((2025 - Year_of_admission) * 100 ) AS 'level' FROM students;

DELETE FROM students WHERE "id" = 1;

SELECT * FROM students;