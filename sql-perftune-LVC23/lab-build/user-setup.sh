#!/bin/bash
# user-setup.sh

NUM_STUDENTS=9
FIRST_STUDENT=1
GROUP_LIST="oinstall,dba"
LAB_NAME=sql-perftune-LVC23

# SSH key for Bastillion
KEY_SRC=/opt/labsrc/student-key.key
AUTH_KEY_SRC=/opt/labsrc/authorized_keys

LAB_SRC=/opt/labsrc


for i in $( seq ${FIRST_STUDENT} 1 ${NUM_STUDENTS} ); do
  user_num=$((60000 + i))
  if (( i > 9 )); then
      user_name=student${i}
  else
      user_name=student0${i}
  fi

  groupadd -g "${user_num}" "${user_name}"
  useradd -u "${user_num}" -g "${user_name}" -G "${GROUP_LIST}" "${user_name}"
  mkdir -p "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp -r "$LAB_SRC"/sqlt/run/* "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  chown -R "${user_name}" "/home/${user_name}/${LAB_NAME}"
  chgrp -R "${user_name}" "/home/${user_name}/${LAB_NAME}"
  chown -R "${user_name}" "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  chgrp -R "${user_name}" "/home/${user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp "$LAB_SRC/sqlt/utl/coe_xfr_sql_profile.sql" "/home/${user_name}/${LAB_NAME}/sqlplus"
  chown "${user_name}" "/home/${user_name}/${LAB_NAME}/sqlplus/coe_xfr_sql_profile.sql"
  chgrp "${user_name}" "/home/${user_name}/${LAB_NAME}/sqlplus/coe_xfr_sql_profile.sql"

  cp "${LAB_SRC}/${LAB_NAME}"/lab-build/labstart.sh "/home/${user_name}"
  chown "$user_name" "/home/${user_name}"/labstart.sh 
  chgrp "$user_name" "/home/${user_name}"/labstart.sh 
  chmod u+x "/home/${user_name}"/labstart.sh 
  chmod u+r "/home/${user_name}"/labstart.sh 

  echo "if [ -t 0 ]; then /home/student01/labstart.sh; fi" >> /home/"$user_name"/.bashrc
  chown "$user_name" "/home/${user_name}"/.bashrc

  # add ssh key for Bastillion
  mkdir -p "/home/${user_name}/.ssh"
  chown -R "${user_name}" "/home/${user_name}/.ssh"
  chgrp -R "${user_name}" "/home/${user_name}/.ssh"
  chmod 700 "/home/${user_name}/.ssh"
  cp "${KEY_SRC}" "/home/${user_name}/.ssh/id_rsa"
  chown -R "${user_name}" "/home/${user_name}/.ssh/id_rsa"
  chgrp -R "${user_name}" "/home/${user_name}/.ssh/id_rsa"
  chmod 600 "/home/${user_name}/.ssh/id_rsa"
  cp "${AUTH_KEY_SRC}" "/home/${user_name}/.ssh/authorized_keys"
  chown -R "${user_name}" "/home/${user_name}/.ssh/authorized_keys"
  chgrp -R "${user_name}" "/home/${user_name}/.ssh/authorized_keys"
  chmod 600 "/home/${user_name}/.ssh/authorized_keys"

done;


echo "When ready to set automatic SQL Plus for students run:"
echo "for i in /home/student0?; do sed -e '/labstart/s/^#//g' -i   $i/.bashrc; done"
echo "To turn off automatic sqlplus run:"
echo "for i in /home/student0?; do sed -e '/labstart/s/^/#/g' -i   $i/.bashrc; done"

# END
