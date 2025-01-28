-- DROP TABLE "Book Loan";
-- DROP TABLE Members;
-- DROP TABLE "Library staff";
-- DROP TABLE Books;
CREATE TABLE IF NOT EXISTS Members(
	Member_ID SERIAL PRIMARY KEY,
	Member_Name VARCHAR(100) NOT NULL,
	"Year_of_Membership(YOM)" DATE NOT NULL,
	CONTACT CHAR(13) NOT NULL UNIQUE,
	Address TEXT
);

CREATE TABLE IF NOT EXISTS Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100) NOT NULL,
	Author VARCHAR(100) NOT NULL,
	Genre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS "Library staff"(
	Librarian_ID SERIAL PRIMARY KEY,
	Staff_name VARCHAR(100) NOT NULL,
	CONTACT CHAR(13) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS "Book Loan"(
	Loan_date DATE NOT NULL,
	Due_date DATE NOT NULL,
	Return_date DATE,
	Book_ID INT NOT NULL,
	Member_ID INT NOT NULL,
	Staff_ID INT NOT NULL,
	CONSTRAINT fk_b FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_m FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_s FOREIGN KEY (Staff_ID) REFERENCES "Library staff"(Librarian_ID) ON DELETE CASCADE ON UPDATE CASCADE
	
);

-- Inserting into Members Table
INSERT INTO Members (Member_Name, "Year_of_Membership(YOM)", Contact, Address)
VALUES
  ('John Doe', '2020-05-15', '+23324367890', '123 Main St'),
  ('Jane Smith', '2021-06-20', '+233205493210', '456 Elm St'),
  ('Alice Johnson', '2022-08-25', '+233544569790', '789 Oak St');

-- Inserting into Books Table
INSERT INTO Books (Title, Author, Genre)
VALUES
  ('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
  ('1984', 'George Orwell', 'Dystopian'),
  ('To Kill a Mockingbird', 'Harper Lee', 'Fiction'),
  ('Pride and Prejudice', 'Jane Austen', 'Romance'),
  ('Moby Dick', 'Herman Melville', 'Adventure'),
  ('The Catcher in the Rye', 'J.D. Salinger', 'Fiction'),
  ('The Hobbit', 'J.R.R. Tolkien', 'Fantasy'),
  ('Fahrenheit 451', 'Ray Bradbury', 'Dystopian'),
  ('War and Peace', 'Leo Tolstoy', 'Historical Fiction'),
  ('Crime and Punishment', 'Fyodor Dostoevsky', 'Psychological Fiction'),
  ('Brave New World', 'Aldous Huxley', 'Science Fiction'),
  ('The Odyssey', 'Homer', 'Epic Poetry'),
  ('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy');

-- Inserting into Library Staff Table
INSERT INTO "Library staff" (Staff_name, CONTACT)
VALUES
  ('Alice Brown', '+233507890123'),
  ('Bob Green', '+233248901234');

-- Inserting more loan records into the Book Loan Table
INSERT INTO "Book Loan" (Loan_date, Due_date, Return_date, Book_ID, Member_ID, Staff_ID)
VALUES
	('2024-12-01', '2024-12-10', '2024-12-15', 1, 1, 1),  -- John Doe, overdue by 5 days
	('2024-11-01', '2024-11-15', '2024-11-15', 2, 2, 2),  -- Jane Smith, returned on time
	('2024-12-05', '2024-12-15', NULL, 3, 3, 1),  -- Alice Johnson, currently borrowed
	('2024-12-03', '2024-12-10', '2024-12-12', 4, 1, 1),  -- John Doe, borrowed 'The Hobbit', returned late
	('2024-11-15', '2024-11-30', '2024-12-02', 5, 2, 2),  -- Jane Smith, borrowed 'Fahrenheit 451', returned late
	('2024-11-20', '2024-12-05', '2024-12-05', 6, 3, 1),  -- Alice Johnson, borrowed 'War and Peace', returned on time
	('2024-12-01', '2024-12-15', NULL, 7, 1, 1),          -- John Doe, borrowed 'Crime and Punishment', currently borrowed
	('2024-11-10', '2024-11-20', '2024-11-25', 8, 2, 2),  -- Jane Smith, borrowed 'Brave New World', returned late
	('2024-12-05', '2024-12-15', NULL, 9, 3, 1),          -- Alice Johnson, borrowed 'The Odyssey', currently borrowed
	('2024-12-02', '2024-12-10', '2024-12-08', 10, 1, 1),  -- John Doe, borrowed 'The Lord of the Rings', returned on time
		
	('2024-01-05', '2024-01-12', '2024-01-11', 1, 1, 1),  -- John Doe
	('2024-02-10', '2024-02-17', '2024-02-18', 1, 2, 2),  -- Jane Smith
	('2024-03-15', '2024-03-22', '2024-03-25', 1, 3, 1), ('2024-01-12', '2024-01-19', '2024-01-21', 3, 1, 1),  -- John Doe
  ('2024-02-15', '2024-02-22', '2024-02-24', 3, 2, 2),  -- Jane Smith
  ('2024-03-25', '2024-04-01', '2024-04-03', 3, 3, 1),  -- Alice Johnson
  ('2024-04-10', '2024-04-17', NULL, 3, 1, 2),          -- John Doe
  ('2024-05-15', '2024-05-22', '2024-05-24', 3, 2, 1),  -- Jane Smith -- Alice Johnson
	('2024-01-12', '2024-01-19', '2024-01-21', 3, 1, 1),  -- John Doe
  ('2024-01-05', '2024-01-12', '2024-01-14', 4, 1, 1),  -- John Doe
  ('2024-02-20', '2024-02-27', '2024-02-28', 4, 2, 2),  -- Jane Smith
  ('2024-03-10', '2024-03-17', '2024-03-19', 4, 3, 1),  -- Alice Johnson
  ('2024-04-20', '2024-04-27', NULL, 4, 1, 2),          -- John Doe
  ('2024-05-30', '2024-06-06', '2024-06-08', 4, 2, 1);  -- Jane Smith
  
SELECT Title AS "Overdue Books" FROM Books
JOIN "Book Loan" ON Books.Book_ID = "Book Loan".Book_ID
WHERE "Book Loan".Return_date > "Book Loan".Due_date
OR (CURRENT_DATE > "Book Loan".Due_date AND "Book Loan".Return_date IS NULL);

SELECT Title AS "Most Borrowed Book" , COUNT(TITLE) FROM Books
JOIN "Book Loan" ON Books.Book_ID = "Book Loan".Book_ID
GROUP BY Title ORDER BY COUNT(TITLE) DESC LIMIT 1;

SELECT Member_Name AS "Borrowed by", SUM((CURRENT_DATE - "Book Loan".Due_date) * 1) AS "Total late fees" FROM "Book Loan"
JOIN Members ON Members.Member_ID = "Book Loan".Member_ID
WHERE Due_date < Return_date
OR "Book Loan".Return_date IS NULL
GROUP BY Members.Member_Name;
