CREATE TABLE IF NOT EXISTS students(
id SERIAL PRIMARY KEY,
name VARCHAR(40),
class VARCHAR(10),
age INT,
gpa NUMERIC
);

CREATE TABLE IF NOT EXISTS audit_trail(
trail_id INT REFERENCES students(id),
old_student_name VARCHAR(40),
new_student_name VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS deleted(
student_name VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS inserted(
student_name VARCHAR(40)
);

CREATE OR REPLACE FUNCTION data(name VARCHAR, class VARCHAR, age INTEGER, score INTEGER)
RETURNS TEXT AS $$
DECLARE
	gpa NUMERIC;
BEGIN
	gpa = score * 0.04;
	INSERT INTO students(name, class, age, gpa)
	VALUES (name, class, age, gpa);
	
	RETURN 'Added student successfully!';
END; $$ LANGUAGE plpgsql;

SELECT data('Jeff', 'Database', 23, 100);

SELECT data('Micheal', 'Calculus', 18, 84);

SELECT data('James', 'Maths', 20, 50);

SELECT * FROM students;