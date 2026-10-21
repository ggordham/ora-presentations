# connection.py
# connection information for EBR demo ap

# Oracle Database Connection Configuration
# Replace credentials and connection string with your environment details
DB_USER = "hr"
DB_PASSWORD = "Ora#42_dbP"
DB_DSN = "10.88.0.2:1521/orclpdb1" # default connection
DB_DSN_BLUE = "10.88.0.2:1521/hr_b" # blue app tier
DB_DSN_GREEN = "10.88.0.2:1521/hr_g" # green app tier

# web server information
SRVR_HOST='10.88.0.3'
PORT_DEFAULT=8000
PORT_BLUE=8000
PORT_GREEN=9000

