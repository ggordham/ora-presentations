# EBR simple HR app

This is the instructions for a very simple web based application for the Oracle database demo schema HR.

This is a python appilcation and will run it's own web server using flask.

## Install APP tier
To run this application you will need python and the required modules installed.

For debian run the following:

```bash
apt install python3-oracledb python3-flask
```

For OEL 8 run the following

```bash
dnf -y install oraclelinux-developer-release-el8
dnf -y install python3.11-oracledb python3-pip python3.11
alternatives --set python3 /usr/bin/python3.11
pip-3 install flask

python3.11 -m flask --version
```

Download the application code.

```bash
cd
curl -L https://github.com/ggordham/ora-presentations/tarball/master | tar xz --strip=1 --wildcards "ggordham-ora-presentations-???????/db-editions-DOAG/app"

cd db-editions-DOAG/app
chmod +x *.py
```

## Configuration

In the ```connection.py``` update the required connection information for the Oracle database.  Also you can update any port numbers and server host IP for accessing the application as needed.

```python
# connection.py
# connection information for EBR demo ap

# Oracle Database Connection Configuration
# Replace credentials and connection string with your environment details
DB_USER = "hr"
DB_PASSWORD = "Ora#42_dbP"
DB_DSN = "srvr11:1521/freepdb1" # default connection
DB_DSN_BLUE = "srvr11:1521/hr_b" # blue app tier
DB_DSN_GREEN = "srvr11:1521/hr_g" # green app tier

# web server information
SRVR_HOST='192.168.0.102'
PORT_DEFAULT=7000
PORT_BLUE=7000
PORT_GREEN=8000
```
## Running the applications

Login to the server and run the application script.  Run the appropriate script based on what version of the application you have deployed to the database.

```bash
# Default application without editions
./app.py

# same application but with editions enabled (db service)
./app_blue.py

# Green version v1 of application
./app_green.py

# Blue version v1_1 of application
./app_blue_v1.1.py
```

_Note you may need to change the file to executable_

```bash
chmod +x *.py
```
