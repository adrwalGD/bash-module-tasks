# bash-module-tasks


1. The Fibonacci numbers are the numbers in the following integer sequence. 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, …….. In mathematical terms, the sequence Fn of Fibonacci numbers is defined by the recurrence relation Fn = Fn-1 + Fn-2 with seed values F0 = 0 and F1 = 1. Write a function fib that returns Fn. For example:
- if n = 0, then fib should return 0
- if n = 1, then it should return 1
- if n > 1, it should return Fn-1 + Fn-2

2. Write bash script accepting operation parameter (“-”, “+”, “*”, “%”), sequence of numbers and debug flag. For example:
- ./your_script.sh -o % -n 5 3 -d > Result: 2
- ./your_script.sh -o + -n 3 5 7 -d > Result: 15
If -d flag is passed, script must print additional information:

- User: <username of the user running the script>
- Script: <script name>        
- Operation: <operation>
- Numbers: <all space-separated numbers>

3. You need to write a script that prints the numbers from 1 to 100 such that:
- If the number is a multiple of 3, you need to print "Fizz" instead of that number.
- If the number is a multiple of 5, you need to print "Buzz" instead of that number.
- If the number is a multiple of both 3 and 5, you need to print "FizzBuzz" instead of that number.

4. Write caesar cipher script accepting three parameters -s <shift> -i <input file> -o <output file>

5. Write script with following functionality:
- If -v tag is passed, replaces lowercase characters with uppercase and vise versa
- If -s is passed, script substitutes <A_WORD> with <B_WORD> in text (case sensitive)
- If -r is passed, script reverses text lines
- If -l is passed, script converts all the text to lower case
- If -u is passed, script converts all the text to upper case
- Script should work with -i <input file> -o <output file> tags

6. Create script, that generates report file with following information:
- current date and time;
- name of current user;
- internal IP address and hostname;
- external IP address;
- name and version of Linux distribution;
- system uptime;
- information about used and free space in / in GB;
- information about total and free RAM;
- number and frequency of CPU cores

## *Advanced practical task - Bash (Database Service in Bash):


1. Create Database:
- Implement a function to create a new database.
- Accept the database name as a command-line argument.
- Create a file for the database with the given name (e.g., example_db.txt).
2. Create Table:
- Implement a function to create a table within the database.
- Accept the table name and fields as command-line arguments.
- Ensure the table adheres to the specified format.
3. Select Data:
- Implement a function to select and display data from the table.
- Ensure proper formatting and adhere to the specified row length.
4. Delete Data:
- Implement a function to delete data from the table.
- Accept criteria for deletion as command-line arguments.
5. Insert Data:
- Implement a function to insert data into the table.
- Accept data values as command-line arguments.
- Ensure proper formatting and adherence to the specified row length.

**Database Structure**:

- Ensure the database file adheres to the specified structure: Maximum line length of 39 characters.
- One row length of 8 characters (including spaces, excluding stars).
- Two stars at the start and end of each row.
- One space before text starts.
**Error Handling**:

- Implement error handling for cases such as invalid commands, missing arguments, etc.
- Provide meaningful error messages for better user understanding.
**Testing:**

- Test the database service with various scenarios to ensure its functionality and reliability.

**Documentation:**

- Document the usage of each function and the overall structure of the database service.
**Code Organization:**

- Organize the code in a modular and readable manner.

**Examples of task execution:**

\# Create a new database

./database.sh create_db example_db

\# Create a table in the database

./database.sh create_table example_db persons id name height age

\# Insert data into the table

./database.sh insert_data example_db persons 0 Igor 180 36
./database.sh insert_data example_db persons 1 Pyotr 178 25

\# Select and display data

./database.sh select_data example_db persons

\# Delete data from the table

./database.sh delete_data example_db persons "id=1"
