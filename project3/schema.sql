CREATE TABLE IF NOT EXISTS engineers(
id SERIAL PRIMARY KEY,
first_name VARCHAR(40),
last_name VARCHAR(40),
field VARCHAR(40)
);


CREATE TABLE IF NOT EXISTS materials(
material_id SERIAL PRIMARY KEY,
name VARCHAR(60),
quantity INT
);


CREATE TABLE IF NOT EXISTS clients(
client_id SERIAL PRIMARY KEY,
first_name VARCHAR(40),
last_name VARCHAR(40),
phone_number CHAR(10) UNIQUE
);


CREATE TABLE IF NOT EXISTS projects(
project_id SERIAL PRIMARY KEY,
project_name VARCHAR(50) NOT NULL,
budget NUMERIC NOT NULL,
engineer_id INT REFERENCES engineers(id),
client_id INT REFERENCES clients(client_id)
);


CREATE TYPE task_status AS ENUM('COMPLETED', 'IN PROGRESS', 'CANCELED', 'NOT STARTED');
CREATE TABLE IF NOT EXISTS tasks(
task_id SERIAL PRIMARY KEY,
project_id INT REFERENCES projects(project_id),
material_id INT REFERENCES materials(material_id),
task_description TEXT,
status task_status
);