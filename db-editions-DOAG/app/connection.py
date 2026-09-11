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
PORT_DEFAULT=5000
PORT_BLUE=5000
PORT_GREEN=8000

