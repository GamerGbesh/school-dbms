/*
Name: Mensah Philemon Edem Yao
Id: 22042860
*/

-- Creating the books entity
CREATE TABLE IF NOT EXISTS "books"(
"id" SERIAL PRIMARY KEY,
"title" VARCHAR(100) NOT NULL,
"author" VARCHAR(40),
"year_released" INTEGER CHECK("year_released" > 1000)
);


-- Creating the members entity
CREATE TABLE IF NOT EXISTS "members"(
"id" SERIAL PRIMARY KEY,
"name" VARCHAR(40) NOT NULL,
"date_of_membership" DATE NOT NULL DEFAULT CURRENT_DATE,
"email" VARCHAR(50) UNIQUE
);


-- Creating the library staff entity
CREATE TABLE IF NOT EXISTS "library staff"(
"id" SERIAL PRIMARY KEY,
"name" VARCHAR(40) NOT NULL,
"email" VARCHAR(50) UNIQUE
);


-- Creating the book loans entity
CREATE TABLE IF NOT EXISTS "book loans"(
"id" SERIAL PRIMARY KEY,
"loan_date" DATE NOT NULL DEFAULT CURRENT_DATE,
"due_date" DATE NOT NULL,
"return_date" DATE,
"member_id" INTEGER NOT NULL,
"book_id" INTEGER NOT NULL,
"staff_id" INTEGER NOT NULL,
CONSTRAINT "fk_member" FOREIGN KEY ("member_id") REFERENCES "members"("id") ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT "fk_staff" FOREIGN KEY ("staff_id") REFERENCES "library staff"("id") ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT "fk_book" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE
);


-- Adding sample data to the database to query
INSERT INTO "books" ("title", "author", "year_released")
VALUES 
    ('1984', 'George Orwell', 1949),
    ('To Kill a Mockingbird', 'Harper Lee', 1960),
    ('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
    ('Pride and Prejudice', 'Jane Austen', 1813),
    ('Moby-Dick', 'Herman Melville', 1851);
	
INSERT INTO "members" ("name", "date_of_membership", "email")
VALUES 
    ('Alice Smith', '2024-01-15', 'alice.smith@example.com'),
    ('Bob Johnson', '2023-05-20', 'bob.johnson@example.com'),
    ('Catherine Lee', '2023-09-10', 'catherine.lee@example.com'),
    ('David Wilson', '2024-02-01', 'david.wilson@example.com'),
    ('Emma Brown', '2022-11-25', 'emma.brown@example.com');
	
INSERT INTO "library staff" ("name", "email")
VALUES 
    ('John Doe', 'john.doe@example.com'),
    ('Sarah Taylor', 'sarah.taylor@example.com'),
    ('Michael Green', 'michael.green@example.com');
	
INSERT INTO "book loans" ("loan_date", "due_date", "return_date", "member_id", "book_id", "staff_id")
VALUES 
    ('2024-11-01', '2024-11-15', NULL, 1, 1, 1), -- Alice borrowed '1984'
    ('2024-11-05', '2024-11-20', NULL, 2, 3, 2), -- Bob borrowed 'The Great Gatsby'
    ('2024-10-15', '2024-10-29', '2024-10-28', 3, 2, 1), -- Catherine returned 'To Kill a Mockingbird'
    ('2024-09-01', '2024-09-15', NULL, 4, 4, 3), -- David borrowed 'Pride and Prejudice'
    ('2024-08-10', '2024-08-24', '2024-08-23', 5, 5, 2); -- Emma returned 'Moby-Dick'


INSERT INTO "books" ("title", "author", "year_released")
VALUES 
    ('Harry Potter and the Sorcerers Stone', 'J.K. Rowling', 1997),
    ('The Catcher in the Rye', 'J.D. Salinger', 1951),
    ('The Lord of the Rings', 'J.R.R. Tolkien', 1954);

-- Adding multiple loan records for the same books
-- Harry Potter and the Sorcerer's Stone
INSERT INTO "book loans" ("loan_date", "due_date", "return_date", "member_id", "book_id", "staff_id")
VALUES
    ('2024-01-10', '2024-01-20', '2024-01-19', 1, 6, 2), -- Borrowed and returned by Alice
    ('2024-02-15', '2024-02-25', '2024-02-24', 2, 6, 3), -- Borrowed and returned by Bob
    ('2024-03-05', '2024-03-15', NULL, 3, 6, 1);         -- Currently borrowed by Catherine

-- The Catcher in the Rye
INSERT INTO "book loans" ("loan_date", "due_date", "return_date", "member_id", "book_id", "staff_id")
VALUES
    ('2024-04-01', '2024-04-11', '2024-04-10', 4, 7, 3), -- Borrowed and returned by David
    ('2024-05-05', '2024-05-15', '2024-05-14', 5, 7, 1), -- Borrowed and returned by Emma
    ('2024-06-01', '2024-06-11', NULL, 1, 7, 2);         -- Currently borrowed by Alice

-- The Lord of the Rings
INSERT INTO "book loans" ("loan_date", "due_date", "return_date", "member_id", "book_id", "staff_id")
VALUES
    ('2024-07-10', '2024-07-20', '2024-07-19', 2, 8, 3), -- Borrowed and returned by Bob
    ('2024-08-15', '2024-08-25', '2024-08-24', 3, 8, 1), -- Borrowed and returned by Catherine
    ('2024-09-05', '2024-09-15', NULL, 4, 8, 2);         -- Currently borrowed by David



-- Writing sample queries to be used in the database
-- 1. Listing all overdue books
SELECT "title" AS "Overdue Books" FROM "books"
WHERE "id" IN (
	SELECT "book_id" FROM "book loans"
	WHERE "book loans"."return_date" > "due_date"
	OR (CURRENT_DATE > "due_date" AND "return_date" IS NULL)
);

-- 2. Listing all books not returned yet alongside the person who borrowed it
SELECT "title" AS "Overdue Books", ("name") AS "Borrowed by" FROM "book loans"
JOIN "members" ON "members"."id" = "book loans"."member_id"
JOIN "books" ON "books"."id" = "book loans"."book_id"
WHERE "books"."id" IN (
	SELECT "book_id" FROM "book loans"
	WHERE "book loans"."return_date" > "due_date"
	OR (CURRENT_DATE > "due_date" AND "return_date" IS NULL)
)
AND "book loans"."return_date" IS NULL;

-- 3. Finding the most borrowed book
SELECT "title" AS "Most Borrowed Book", COUNT("title") AS "Times borrowed" FROM "books"
JOIN "book loans" ON "book loans"."book_id" = "books"."id"
GROUP BY "books"."id", "title"
ORDER BY "Times borrowed" DESC LIMIT 1;


-- 4. Getting the total late fee
-- A late fee would be 50 pesewas per day that passes after due date
SELECT ("name") AS "Borrowed by", SUM((CURRENT_DATE - "book loans"."due_date") * 0.5) AS "Total late fees" FROM "book loans"
JOIN "members" ON "members"."id" = "book loans"."member_id"
WHERE "due_date" < "return_date"
OR "book loans"."return_date" IS NULL
GROUP BY "name";