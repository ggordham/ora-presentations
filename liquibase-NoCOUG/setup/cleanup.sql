/* cleanup.sql */

connect / as sysdba

alter pluggable database hrprd close immediate;
alter pluggable database hrtst close immediate;
alter pluggable database hrdev close immediate;

drop pluggable database hrprd including datafiles;
drop pluggable database hrtst including datafiles;
drop pluggable database hrdev including datafiles;

/* end */
