#!/usr/bin/python3
# app-green.py
#
# EBR demo application, green application after EBR setup
# v 1.0

from flask import Flask, request, jsonify, render_template_string, render_template
import oracledb
import connection
import time, sys

from jinja2 import Environment, StrictUndefined
env = Environment(undefined=StrictUndefined)

app = Flask(__name__)

# set the application port
my_port=connection.PORT_GREEN

def get_db_connection():
    """Establishes and returns a connection to the Oracle Database."""
    return oracledb.connect(user=connection.DB_USER, password=connection.DB_PASSWORD, dsn=connection.DB_DSN_GREEN)

# 1. READ ALL & HTML INTERFACE
@app.route('/')
def index():

    # optionally get a wait time so we can see the session open longer
    wait_time = request.args.get('wait', default=0, type=int)

     # lookup employees
    employees = []
    conn = get_db_connection()
    emp_cursor = conn.cursor()
    # Fetching limited columns for simplicity
    emp_cursor.execute("""
        SELECT employee_id, manager_id, department_id, first_name, last_name, email, phone_number, job_name
        FROM employees
        ORDER BY employee_id DESC
        """)
    for emp in emp_cursor.fetchall():
        employees.append({"employee_id": emp[0], "manager_id": emp[1], "department_id": emp[2],
                          "first_name": emp[3], "last_name": emp[4], "email": emp[5], "phone_number": emp[6],
                          "job_name": emp[7]})
    emp_cursor.close()

    # lookup departments
    departments = []
    dep_cursor = conn.cursor()
    dep_cursor.execute("""
         SELECT department_id, department_name FROM departments ORDER BY department_name
         """)

    # loop through all the records assign column names to array
    for dep in dep_cursor.fetchall():
        departments.append({"department_id": dep[0], "department_name": dep[1]})
    dep_cursor.close()

    time.sleep(wait_time)  # pause for 10 seconds so we can see the session

    conn.close()

    # Simple HTML Template injected inline for easy deployment
    html_template = """
    <!DOCTYPE html>
    <html>
    <head><title>Oracle HR Green v1.0</title></head>
    <body style="font-family: Arial, sans-serif; margin: 30px;">
        <h1>Green App v 1.0</h1>
        <h2>Oracle HR Schema - Employees Management</h2>
        <h4>GREEN app pool</h4>

        <h3>Add New Employee</h3>
        <form action="/create" method="POST">
            <!-- <input type="text" name="employee_code" placeholder="Employee Code" required> -->
            <select name="dept_id_new">
              <option value="">--Select--</option>
              {% for dept in departments %}
                 <option value="{{ dept.department_id }}" >{{ dept.department_name }}</option>
              {% endfor %}
            </select>

            <input type="text" name="mgr_id" placeholder="Manager ID" required>
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
                <th>ID</th><th>Manager ID</th><th>Department</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>Job Name</th><th>Actions</th>
            </tr>
            {% for emp in employees %}
            <tr>
                <!-- Employee records
                     0 employee_id, 1 mgr_id, 2 dept_id, 3 first_name, 4 last_name, 5 email, 6 phone_number, 7 job_name -->

                <td>{{ emp.employee_id }}</td>
                <td>{{ emp.manager_id }}</td>
                <td>{{ emp.department_id }}</td>
                <td>{{ emp.first_name }}</td>
                <td>{{ emp.last_name }}</td>
                <td>{{ emp.email }}</td>
                <td>{{ emp.phone_number }}</td>
                <td>{{ emp.job_name }}</td>
                <td>
                    <!-- Update Action Form -->
                    <form action="/update/{{ emp.employee_id }}" method="POST" style="display:inline;">
                        <select name="dept_id">
                            <option values="">--Select Department --</option>
                            {% for dept in departments %}
                               <option value="{{ dept.department_id }}"
                                 {% if dept.department_id == emp.department_id %} selected {% endif %}>
                                 {{ dept.department_name }}</option>
                            {% endfor %}
                        </select>
                        <input type="text" name="email" value="{{ emp.email }}" required>
                        <button type="submit">Update</button>
                    </form>
                    |
                    <!-- Delete Action Link -->
                    <a href="/delete/{{ emp.employee_id }}" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
            {% endfor %}
        </table>
    </body>
    </html>
    """
    return render_template_string(html_template, employees=employees, departments=departments)

# 2. CREATE
@app.route('/create', methods=['POST'])
def create_employee():
    dept_id = request.form['dept_id_new']
    mgr_id = request.form['mgr_id']
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
            INSERT INTO employees (employee_id, department_id, manager_id, first_name, last_name, email, phone_number, hire_date, job_name)
            VALUES (employees_seq.NEXTVAL, :1, :2, :3, :4, :5, :6, SYSDATE, :7)
        """, (dept_id, mgr_id, first_name, last_name, email, phone, job_name))
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
    new_dept = request.form.get('dept_id', type=int)
    new_email = request.form['email']

    print(emp_id, file=sys.stderr, flush=True)
    print(new_dept, file=sys.stderr, flush=True)
    print(new_email, file=sys.stderr, flush=True)

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            UPDATE employees
            SET email = :new_email, department_id = :new_dept
            WHERE employee_id = :emp_id
        """, emp_id=emp_id, new_email=new_email, new_dept=new_dept)
#            SET email = :new_email, department_id = :new_dept
#        """, emp_id=emp_id, new_email=new_email, new_dept=new_dept)
        conn.commit()
    except Exception as e:
        return f"Database Error: {str(e)}", 800
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

