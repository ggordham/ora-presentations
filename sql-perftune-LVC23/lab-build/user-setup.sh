#!/bin/bash
# user-setup.sh

NUM_STUDENTS=9
FIRST_STUDENT=2
GROUP_LIST="oinstall,dba"
LAB_NAME=sql-perftune-LVC23

LAB_SRC=/opt/labsrc


for i in $( seq ${FIRST_STUDENT} 1 ${NUM_STUDENTS} ); do
  user_num=$((60000 + i))
  if (( i > 9 )); then
      user_name=student${i}
  else
      user_name=student0${i}
  fi


  useradd -u "$user_num" -G "$GROUP_LIST" "$user_name"
  mkdir -p "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp -r "$LAB_SRC"/sqlt/run/* "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  chown -R "$user_name" "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  chgrp -R "$user_name" "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp "$LAB_SRC/sqlt/utl/coe_xfr_profile.sql" "/home/${user_name}/${LAB_NAME}/sqlplus"
  chown "$user_name" "/home/${user_name}/${LAB_NAME}/sqlplus/coe_xfr_profile.sql"
  chgrp "$user_name" "/home/${user_name}/${LAB_NAME}/sqlplus/coe_xfr_profile.sql"

  cp "${LAB_SRC}"/labstart.sh "/home/${user_name}"
  chown "$user_name" "/home/${user_name}"/labstart.sh 
  chmod u+x u+r "/home/${user_name}"/labstart.sh 

  echo "/home/$user_name/labstart.sh" >> /home/"$user_name"/.bashrc
done;

