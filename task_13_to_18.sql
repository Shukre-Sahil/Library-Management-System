use lms_project;
SELECT * from employees;
SELECT * from books;
SELECT * from members;
SELECT * from issued_status;

-- Task 13 to 20
 
/*Task 13: Identify Members with Overdue Books
 Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
*/

select 
	ist.issued_member_id, m.member_name, bk.book_title, ist.issued_date, rs.return_date , 
    datediff(current_date(),ist.issued_date) as Overdue_days
from issued_status as ist
join members as m on m.member_id = ist.issued_member_id
join books as bk on bk.isbn = ist.issued_book_isbn
left join return_status as rs on rs.issued_id = ist.issued_id

where rs.return_date is null
and datediff(current_date(),ist.issued_date)>30
order by Overdue_days;

/*
 Task 14: Update Book Status on Return
 Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/

delimiter $$
create procedure add_return_records(
in p_return_id varchar(20),
in p_issued_id varchar(20),
in p_book_quality varchar(20)
)

begin

declare v_isbn varchar(50);
declare v_book_name varchar(80);

-- inserting into return based on user input
insert into return_status(return_id, issued_id, return_date, book_quality)
values
(p_return_id, p_issued_id,current_date(), p_book_quality);

-- storing a value in a variable
select issued_book_isbn, issued_book_name into v_isbn, v_book_name
from issued_status
where issued_id = p_issued_id;

update books
set status = 'yes'
where isbn = v_isbn;

select concat('Thank you for returing the book:', v_book_name) as log_message;

end $$

delimiter ; 
select * from return_status where issued_id = 'IS135';

-- testing first record
call add_return_records('RS131', 'IS135', 'Good');


-- testing another record.
select * from books where isbn = '978-0-330-25864-8';  -- checking a book status

update books
set status = 'no'		-- updating return status to NO for specific book id
where isbn = '978-0-330-25864-8';

select * from issued_status where issued_book_isbn = '978-0-330-25864-8';		-- verifying the status changed to NO

call add_return_records('RS147', 'IS140', 'Good');		-- calling the stored procedure 
select * from return_status;		-- return status is changed back to yes

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

create table branch_report as
select 
b.branch_id, b.manager_id, count(ist.issued_id) as number_book_issued, count(rs.return_id) as number_of_books_returned,sum(bk.rental_price) as total_revenue
from issued_status as ist
join employees as e on e.emp_id = ist.issued_emp_id
join branch as b on e.branch_id = b.branch_id
left join return_status as rs on rs.issued_id = ist.issued_id
join books as bk on ist.issued_book_isbn = bk.isbn
group by b.branch_id, b.manager_id;

select * from branch_report;


/*
Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
*/

create table active_members as
select * from members
where member_id in (
	select distinct(issued_member_id)
	from issued_status
	where issued_date >= current_date - interval 2 month
    );

select * from active_members;

select *  from branch;

/*
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/

select e.emp_name, b.branch_id, b.manager_id, b.branch_address, b.contact_no, count(ist.issued_id) as books_processed
from issued_status as ist
join employees as e on e.emp_id = ist.issued_emp_id 
join branch as b on e.branch_id = b.branch_id
group by e.emp_name, b.branch_id, b.manager_id, b.branch_address, b.contact_no
order by count(ist.issued_id) desc 
limit 3;



/*
Task 18: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/


delimiter $$
drop procedure if exists issue_book;
create procedure issue_book(
    in p_issued_id varchar(50),
    in p_issued_member_id varchar(30),
    in p_issued_book_isbn varchar(50),
    in p_issued_emp_id varchar(50)
)
begin
    declare v_status varchar(20);

    -- 1. Added LIMIT 1 to prevent "Result consisted of more than one row" error
    select status into v_status  
    from books 
    where isbn = p_issued_book_isbn
    limit 1;

    IF v_status = 'yes' THEN 
        -- 2. Insert record
        insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        values (p_issued_id, p_issued_member_id, current_date(), p_issued_book_isbn, p_issued_emp_id);
    
        -- 3. Corrected column name to p_issued_book_isbn
        update books
        set status = 'no'
        where isbn = p_issued_book_isbn;
        
        select concat('Book records added successfully for book isbn: ', p_issued_book_isbn) as Message;
    
    ELSE
        select concat('Sorry! The book is not available: ', p_issued_book_isbn) as Message;
    END IF; 

end $$
delimiter ; 


-- testing
call issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104' );		-- when book is available, it simply adds the book record
call issue_book('IS155', 'C108', '978-0-7432-7357-1', 'E104' );		-- when book is not available, it throws a message.
