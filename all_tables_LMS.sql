-- LIBRARY MANAGEMENT SYSTEM

CREATE DATABASE LMS_PROJECT;
USE LMS_PROJECT;

DROP TABLE IF EXISTS BRANCH;
CREATE TABLE BRANCH(
branch_id	VARCHAR(10),
manager_id	VARCHAR(10),
branch_address	VARCHAR(45),
contact_no VARCHAR(10)

);

ALTER TABLE BRANCH
ADD PRIMARY KEY(branch_id);

alter table BRANCH
modify column contact_no varchar(15);


DROP TABLE IF EXISTS EMPLOYEES;
CREATE TABLE EMPLOYEES(
emp_id	VARCHAR(15) PRIMARY KEY,
emp_name VARCHAR(35),
position VARCHAR(25),
salary	INT, 
branch_id VARCHAR(20)			-- FK

);


DROP TABLE IF EXISTS BOOKS;
CREATE TABLE  BOOKS(
isbn VARCHAR(20) primary key ,
book_title varchar(75),
category varchar(20),
rental_price float,
status	varchar(10),
author	varchar(30),
publisher varchar(30)

);

DROP TABLE IF EXISTS MEMBERS;
CREATE TABLE  MEMBERS(
member_id varchar(25) primary key,
member_name varchar(30),
member_address varchar(50),
reg_date date

);

DROP TABLE IF EXISTS ISSUED_STATUS;
CREATE TABLE  ISSUED_STATUS(
issued_id	VARCHAR(30) PRIMARY KEY,
issued_member_id	varchar(20), 		-- FK
issued_book_name	varchar(40),
issued_date	date,
issued_book_isbn varchar(30),			-- FK
issued_emp_id varchar(10)				-- FK

);

alter table issued_status
modify column issued_book_name varchar(75);


DROP TABLE IF EXISTS RETURN_STATUS;
CREATE TABLE  RETURN_STATUS(
return_id	VARCHAR(20) PRIMARY KEY,
issued_id	VARCHAR(20), 				-- FK
return_book_name	VARCHAR(75),
return_date	DATE,
return_book_isbn VARCHAR(20)

);

-- FOREIGN KEYS
ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES MEMBERS(member_id);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES BOOKS(isbn);

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES EMPLOYEES(emp_id);

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES BRANCH(branch_id);

ALTER TABLE RETURN_STATUS
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES ISSUED_STATUS(issued_id);