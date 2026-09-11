#!/usr/bin/python3
# app-blue.py
#
# EBR demo application, blue application after EBR setup
# v 0.0

from flask import Flask, request, jsonify, render_template_string
import oracledb
import connection
import time

app = Flask(__name__)

# set the application port
my_port=connection.PORT_BLUE

def get_db_connection():
    """Establishes and returns a connection to the Oracle Database."""
    return oracledb.connect(user=connection.DB_USER, password=connection.DB_PASSWORD, dsn=connection.DB_DSN_BLUE)

# 1. READ ALL & HTML INTERFACE
@app.route('/')
def index():

    # optionally get a wait time so we can see the session open longer
    wait_time = request.args.get('wait', default=0, type=int)

    conn = get_db_connection()
    cursor = conn.cursor()
    # Fetching limited columns for simplicity
    cursor.execute("""
        SELECT employee_id, employee_code, first_name, last_name, email, phone_number, job_name
        FROM employees
        ORDER BY employee_id DESC
    """)
    employees = cursor.fetchall()
    cursor.close()
    time.sleep(wait_time)  # pause for 10 seconds so we can see the session
    conn.close()

    # Simple HTML Template injected inline for easy deployment
    html_template = """
    <!DOCTYPE html>
    <html>
    <head><title>Oracle HR Blue</title></head>
    <body style="font-family: Arial, sans-serif; margin: 30px;">
        <h1>Blue App v 0.0</h1>
        <h2>Oracle HR Schema - Employees Management</h2>
        <h4>BLUE app pool</h4>

        <h3>Add New Employee</h3>
        <form action="/create" method="POST">
            <input type="text" name="employee_code" placeholder="Employee Code" required>
            <input type="text" name="first_name" placeholder="First Name" required>
            <input type="text" name="last_name" placeholder="Last Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="phone" placeholder="Phone" required>
            <input type="text" name="job_name" placeholder="Job Name" required>
            <button type="submit">Add</button>
        </form>

        <h3>Employee Directory</h3>
        <table border="1" cellpadding="5" style="border-collapse: collapse; width: 100%;">
            <tr>
                <th>ID</th><th>Code</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>Job Name</th><th>Actions</th>
            </tr>
            {% for emp in employees %}
            <tr>
                <!-- Employee records
                     0 employee_id, 1 employee_code, 2 first_name, 3 last_name, 4 email, 5 phone_number, 6 job_name -->

                <td>{{ emp[0] }}</td>
                <td>{{ emp[1] }}</td>
                <td>{{ emp[2] }}</td>
                <td>{{ emp[3] }}</td>
                <td>{{ emp[4] }}</td>
                <td>{{ emp[5] }}</td>
                <td>{{ emp[6] }}</td>
                <td>
                    <!-- Update Action Form -->
                    <form action="/update/{{ emp[0] }}" method="POST" style="display:inline;">
                        <input type="text" name="email" value="{{ emp[4] }}" required>
                        <button type="submit">Update Email</button>
                    </form>
                    |
                    <!-- Delete Action Link -->
                    <a href="/delete/{{ emp[0] }}" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
            {% endfor %}
        </table>
    </body>
    </html>
    """
    return render_template_string(html_template, employees=employees)

# 2. CREATE
@app.route('/create', methods=['POST'])
def create_employee():
    employee_code = request.form['employee_code']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    phone = request.form['phone']
    job_name = request.form['job_name']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # Note: Oracle HR schema uses standard sequence 'employees_seq' for automatic IDs
        cursor.execute("""
            INSERT INTO employees (employee_id, employee_code, first_name, last_name, email, phone_number, hire_date, job_name)
            VALUES (employees_seq.NEXTVAL, :1, :2, :3, :4, :5, SYSDATE, :6)
        """, (employee_code, first_name, last_name, email, phone, job_name))
        conn.commit()
    except Exception as e:
        return f"Database Error: {str(e)}", 400
    finally:
        cursor.close()
        conn.close()
    return '<script>alert("Added successfully!"); window.location="/";</script>'

# 3. UPDATE
@app.route('/update/<int:emp_id>', methods=['POST'])
def update_employee(emp_id):
    new_email = request.form['email']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            UPDATE employees
            SET email = :1
            WHERE employee_id = :2
        """, (new_email, emp_id))
        conn.commit()
    except Exception as e:
        return f"Database Error: {str(e)}", 400
    finally:
        cursor.close()
        conn.close()
    return '<script>alert("Updated successfully!"); window.location="/";</script>'

# 4. DELETE
@app.route('/delete/<int:emp_id>')
def delete_employee(emp_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM employees WHERE employee_id = :1", (emp_id,))
        conn.commit()
    except Exception as e:
        return f"Database Error: Integrity constraints might prevent deletion (e.g., historical records exist). Details: {str(e)}", 400
    finally:
        cursor.close()
        conn.close()
    return '<script>alert("Deleted successfully!"); window.location="/";</script>'

if __name__ == '__main__':
    # Start web server
    app.run(debug=True, port=my_port, host=connection.SRVR_HOST)

