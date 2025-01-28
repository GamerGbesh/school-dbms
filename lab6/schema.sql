CREATE TABLE IF NOT EXISTS students(
student_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(50) UNIQUE,
department VARCHAR(10),
programme_of_study VARCHAR(30)
);


CREATE TABLE IF NOT EXISTS instructors(
instructor_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(50) UNIQUE,
department VARCHAR(10)
);


CREATE TABLE IF NOT EXISTS courses(
course_id SERIAL PRIMARY KEY,
course_name VARCHAR(20) NOT NULL,
description TEXT NOT NULL
);


CREATE TYPE grades AS ENUM ('A', 'B', 'C', 'D', 'E', 'F');
CREATE TABLE IF NOT EXISTS enrollments(
enrollment_id SERIAL PRIMARY KEY,
student_id INT REFERENCES students(student_id),
course_id INT REFERENCES courses(course_id),
instructor_id INT REFERENCES instructors(instructor_id),
date_of_enrollment DATE,
grade grades NOT NULL
);


CREATE TYPE operations AS ENUM ('INSERT', 'DELETE', 'UPDATE');
CREATE TABLE IF NOT EXISTS audit_trail(
operation_performed operations NOT NULL,
time_of_operation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
enrollment_id INT REFERENCES enrollments(enrollment_id),
description_of_changes TEXT
);



CREATE OR REPLACE FUNCTION insertFunc()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
	VALUES('INSERT', NEW.enrollment_id, 'A new student was added to the enrollments table');
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateFunc()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
	VALUES('UPDATE', OLD.enrollment_id, 'Enrollment record was updated');
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION deleteFunc()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
	VALUES('DELETE', OLD.enrollment_id, 'Enrollment record was deleted');
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER insertTrigger
AFTER INSERT ON enrollments
FOR EACH ROW
EXECUTE FUNCTION insertFunc();

CREATE OR REPLACE TRIGGER updateTrigger
AFTER UPDATE ON enrollments
FOR EACH ROW
EXECUTE FUNCTION updateFunc();

CREATE OR REPLACE TRIGGER deleteTrigger
BEFORE DELETE ON enrollments
FOR EACH ROW
EXECUTE FUNCTION deleteFunc();



SELECT * FROM audit_trail; 
SELECT * FROM enrollments;
SELECT * FROM students;
SELECT * FROM instructors;


CREATE OR REPLACE FUNCTION log_details()
RETURNS TRIGGER AS $$
BEGIN
	IF tg_op = 'INSERT' THEN
		INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
		VALUES('INSERT', NEW.enrollment_id, 'A new student was added to the enrollments table');
		RETURN NEW;
	ELSIF tg_op = 'UPDATE' THEN
		INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
		VALUES('UPDATE', OLD.enrollment_id, 'Enrollment record was updated');
		RETURN NEW;
	ELSIF tg_op = 'DELETE' THEN
		INSERT INTO audit_trail(operation_performed, enrollment_id, description_of_changes)
		VALUES('DELETE', OLD.enrollment_id, 'Enrollment record was deleted');
		RETURN OLD;
	END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trigThings
AFTER INSERT OR UPDATE ON enrollments
FOR EACH ROW
EXECUTE FUNCTION log_details();

CREATE OR REPLACE TRIGGER trigDelThings
BEFORE DELETE ON enrollments
FOR EACH ROW
EXECUTE FUNCTION log_details();