/* clean-up.sql */

connect / as sysdba

@purge-cursor.sql fua0hb5hfst77
@drop-baselines.sql
DROP user perflab cascade


