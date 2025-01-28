CREATE TABLE IF NOT EXISTS "medical department"(
"id" SERIAL PRIMARY KEY,
"name" VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS "doctor"(
"id" SERIAL PRIMARY KEY,
"first name" VARCHAR(32),
"last name" VARCHAR(32),
"specialty" VARCHAR(32),
"department_id" INT,
CONSTRAINT "fk_department" FOREIGN KEY ("department_id")
REFERENCES "medical department"("id")
);

CREATE TABLE IF NOT EXISTS "patient"(
"id" SERIAL PRIMARY KEY,
"first name" VARCHAR(32),
"last name" VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS "appointment"(
"id" SERIAL PRIMARY KEY,
"datetime" TIMESTAMP,
"doctor_id" INT,
"patient_id" INT,
CONSTRAINT "fk_patient" FOREIGN KEY ("patient_id")
REFERENCES "patient"("id"),

CONSTRAINT "fk_doctor" FOREIGN KEY ("doctor_id")
REFERENCES "doctor"("id")
);