select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

-- PROJECT TASK!

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
insert into BOOKS (isbn,book_title,category,rental_price,status,author,publisher)
values
('978-1-60129-456-2','To Kill a Mockingbird','Classic','6.00','yes','Harper Lee','J.B Lipppincott & Co.');


-- Task 2: Update an Existing Member's Address
update members set member_address = '7890 Maharashtra street'
where member_id = 'C102';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
delete from issued_status
where issued_id= 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status where issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_member_id as Member_ID,count(*) as count from issued_status group by issued_member_id having count(*)>1;


-- CTAS - CREATE TABLE AS SELECT
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
create table book_counts
as
select 
	b.isbn, b.book_title,count(ist.issued_id) as no_issued
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by b.isbn;

select * from book_counts;


-- DATA ANALYSIS AND FINDINGS
-- Task 7. Retrieve All Books in a Specific Category:
select  * from books where category = 'Dystopian';

-- Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;

-- Task 9: List Members Who Registered in the Last 880 Days:
select * from members where reg_date >= current_date() - interval 880 day;

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

select 
	e1.*,
	e2.emp_name as manager,
    b.manager_id
from employees as e1
join branch as b
on e1.branch_id = b.branch_id
join employees as e2
on e2.emp_id =  b.manager_id;

-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold:
create table Expensive_books as
select isbn,book_title, category, rental_price from books where rental_price>=5.5;

select * from return_status;


-- Task 12: Retrieve the List of Books Not Yet Returned
select isbn, book_title, category,status from books where status<>'yes';
