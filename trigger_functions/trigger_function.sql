CREATE TABLE IF NOT EXISTS courses(
course_id SERIAL PRIMARY KEY,
course_code INT NOT NULL,
course_name VARCHAR(10)
);



/*
	int input(int code, string name){
		insert into courses(code, name);
		return 0;
	}
*/

CREATE OR REPLACE FUNCTION input(code INT, name VARCHAR)
RETURNS INT 
AS $$
BEGIN
	INSERT INTO courses(course_code, course_name)
	VALUES (code, name);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

SELECT input(210, 'Something');
SELECT input(214, 'Chicken');
SELECT input(21, 'Some');


SELECT * FROM courses;



CREATE TABLE IF NOT EXISTS scores(
score_id SERIAL PRIMARY KEY,
student_name VARCHAR(40) NOT NULL,
score INT NOT NULL,
gpa NUMERIC NOT NULL
);


/*
Take a name, score from score it will calculate the gpa.
value 1-100
gpa 4.00
score * 0.04
*/

CREATE OR REPLACE FUNCTION gpa_calc(name VARCHAR, class_score INT)
RETURNS TEXT AS $$
DECLARE
	calc NUMERIC;
BEGIN
	calc = class_score * 0.04;
	INSERT INTO scores(student_name, score, gpa)
	VALUES(name, class_score, calc);
	RETURN 'Score added successfully';
END;
$$ LANGUAGE plpgsql;

SELECT gpa_calc('Fredric', 68);
SELECT gpa_calc('James', 100);
SELECT gpa_calc('Sam', 96);
SELECT gpa_calc('Jamie', 40);
SELECT * FROM scores;

/*
UPDATE - BEFORE/AFTER
INSERT - AFTER
DELETE - BEFORE
TRUNCATE
IF AFTER/BEFORE insert:
	info()

OLD - state of the table before the operation
NEW - state of the table after the operation
*/

CREATE TABLE IF NOT EXISTS track(
id SERIAL PRIMARY KEY,
names VARCHAR(40) NOT NULL
);

CREATE OR REPLACE FUNCTION info()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO track(names)
	VALUES(NEW.student_name);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*
RETURN NEW
RETURN OLD
RETURN NULL
*/

CREATE TRIGGER log_track
AFTER INSERT ON scores
FOR EACH ROW
EXECUTE FUNCTION info();


SELECT gpa_calc('Micheal', 60);
SELECT gpa_calc('Jeff', 19);
SELECT gpa_calc('Alfreda', 70);




SELECT * FROM track;
SELECT * FROM scores;



CREATE TABLE IF NOT EXISTS change_name(
id INT REFERENCES courses(course_id),
old_name VARCHAR(10),
new_name VARCHAR(10)
);

/*
some-> Fire
change_name
old name ----- new name
  some           fire
*/


CREATE OR REPLACE FUNCTION change()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO change_name(id, old_name, new_name)
	VALUES(OLD.course_id, OLD.course_name, NEW.course_name);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_change_name
BEFORE UPDATE ON courses
FOR EACH ROW
EXECUTE FUNCTION change();

/*
1  213 discrete
update
change()
1  213 farming 

*/


SELECT input(123, 'science');
SELECT * FROM courses;

UPDATE courses SET course_name = 'Algebra'
WHERE course_id = 5;

UPDATE courses SET course_name = 'French'
WHERE course_name = 'Some';

SELECT * FROM change_name;
SELECT * FROM scores;
-- DELETE FROM scores;


SELECT gpa_calc('Michelle', 54);
