CREATE TABLE IF NOT EXISTS students(
student_id SERIAL PRIMARY KEY,
name VARCHAR(60) NOT NULL,
phone_number CHAR(10) UNIQUE NOT NULL,
gender CHAR(1) CHECK(gender in ('M', 'F')),
email VARCHAR(50) UNIQUE NOT NULL,
address VARCHAR(30)
);


CREATE TABLE IF NOT EXISTS professors(
professor_id SERIAL PRIMARY KEY,
name VARCHAR(60) NOT NULL,
phone_number CHAR(10) UNIQUE NOT NULL,
department VARCHAR(20) NOT NULL,
email VARCHAR(50) UNIQUE NOT NULL,
title VARCHAR(30) NOT NULL
);


CREATE TABLE IF NOT EXISTS courses(
course_id SERIAL PRIMARY KEY,
professor_id INT REFERENCES professors(professor_id),
name VARCHAR(60) NOT NULL,
code CHAR(10) UNIQUE NOT NULL,
department VARCHAR(20) NOT NULL,
credits INT NOT NULL,
description TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS registration(
registration_id SERIAL PRIMARY KEY,
course_id INT REFERENCES courses(course_id),
student_id INT REFERENCES students(student_id),
academic_year INT CHECK(academic_year > 2000),
semester INT CHECK(semester in (1, 2))
);