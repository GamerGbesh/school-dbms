INSERT INTO students (name, email, department, programme_of_study)
VALUES
    ('Alice Johnson', 'alice.johnson@example.com', 'CSE', 'Computer Science'),
    ('Bob Smith', 'bob.smith@example.com', 'ECE', 'Electronics'),
    ('Carol Lee', 'carol.lee@example.com', 'ME', 'Mechanical Engineering');

INSERT INTO instructors (name, email, department)
VALUES
    ('Dr. John Doe', 'john.doe@example.com', 'CSE'),
    ('Dr. Emily Davis', 'emily.davis@example.com', 'ECE'),
    ('Dr. Michael Brown', 'michael.brown@example.com', 'ME');

INSERT INTO courses (course_name, description)
VALUES
    ('CS101', 'Introduction to Computer Science'),
    ('ECE202', 'Fundamentals of Electronics'),
    ('ME303', 'Thermodynamics');

INSERT INTO enrollments (student_id, course_id, instructor_id, date_of_enrollment, grade)
VALUES
    (1, 1, 1, '2025-01-15', 'A'),
    (2, 2, 2, '2025-01-16', 'B'),
    (3, 3, 3, '2025-01-17', 'C');


UPDATE enrollments SET grade = 'B'
WHERE student_id = 1;