CREATE OR REPLACE FUNCTION trig_function()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO audit_trail(trail_id, old_student_name, new_student_name)
	VALUES (OLD.id, OLD.name, NEW.name);
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_update
	BEFORE UPDATE ON students
	FOR EACH ROW
	EXECUTE FUNCTION trig_function();


UPDATE students SET name = 'Fredric'
WHERE id = 3;

SELECT * FROM audit_trail;
SELECT * FROM students;

SELECT id, old_student_name, new_student_name, age, gpa FROM students
JOIN audit_trail ON audit_trail.trail_id = students.id;


CREATE OR REPLACE TRIGGER check_after_update
	AFTER UPDATE ON students
	FOR EACH ROW
	EXECUTE FUNCTION trig_function();


CREATE OR REPLACE FUNCTION delete_data()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO deleted(student_name)
	VALUES(OLD.name);
	RETURN OLD;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_deleted
	BEFORE DELETE ON students
	FOR EACH ROW
	EXECUTE FUNCTION delete_data();

DELETE FROM students
WHERE id = 2;

SELECT * FROM deleted;


CREATE OR REPLACE FUNCTION insert_data()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO inserted(student_name)
	VALUES(NEW.name);
	RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER add_insert
	AFTER INSERT ON students
	FOR EACH ROW
	EXECUTE FUNCTION insert_data();


SELECT data('Thomas', 'Finance', 26, 78);

SELECT * FROM inserted;