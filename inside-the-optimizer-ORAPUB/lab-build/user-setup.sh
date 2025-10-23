#!/bin/bash
# user-setup.sh

mode=$1

NUM_STUDENTS=14
FIRST_STUDENT=1
GROUP_LIST="oinstall,dba"
LAB_NAME=inside-the-optimizer-ORAPUB

# SSH key for Bastillion
KEY_SRC=/opt/labsrc/student-key.key
AUTH_KEY_SRC=/opt/labsrc/authorized_keys

LAB_SRC=/opt/labsrc

mk_student(){

  local my_user_name=$1
  local my_user_num=$2
  groupadd -g "${my_user_num}" "${my_user_name}"
  useradd -u "${my_user_num}" -g "${my_user_name}" -G "${GROUP_LIST}" "${my_user_name}"
  mkdir -p "/home/${my_user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp -r "$LAB_SRC"/sqlt/run/* "/home/${my_user_name}/${LAB_NAME}/sqlplus/sqlt"
  chown -R "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}"
  chgrp -R "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}"
  chown -R "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}/sqlplus/sqlt"
  chgrp -R "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}/sqlplus/sqlt"
  cp "$LAB_SRC/sqlt/utl/coe_xfr_sql_profile.sql" "/home/${my_user_name}/${LAB_NAME}/sqlplus"
  chown "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}/sqlplus/coe_xfr_sql_profile.sql"
  chgrp "${my_user_name}" "/home/${my_user_name}/${LAB_NAME}/sqlplus/coe_xfr_sql_profile.sql"

  cp "${LAB_SRC}/${LAB_NAME}"/lab-build/labstart.sh "/home/${my_user_name}"
  chown "$my_user_name" "/home/${my_user_name}"/labstart.sh 
  chgrp "$my_user_name" "/home/${my_user_name}"/labstart.sh 
  chmod u+x "/home/${my_user_name}"/labstart.sh 
  chmod u+r "/home/${my_user_name}"/labstart.sh 

  echo "if [ -t 0 ]; then /home/${my_user_name}/labstart.sh; fi" >> /home/"${my_user_name}"/.bashrc
  chown "$my_user_name" "/home/${my_user_name}"/.bashrc

  # add ssh key for Bastillion
  mkdir -p "/home/${my_user_name}/.ssh"
  chown -R "${my_user_name}" "/home/${my_user_name}/.ssh"
  chgrp -R "${my_user_name}" "/home/${my_user_name}/.ssh"
  chmod 700 "/home/${my_user_name}/.ssh"
  cp "${KEY_SRC}" "/home/${my_user_name}/.ssh/id_rsa"
  chown -R "${my_user_name}" "/home/${my_user_name}/.ssh/id_rsa"
  chgrp -R "${my_user_name}" "/home/${my_user_name}/.ssh/id_rsa"
  chmod 600 "/home/${my_user_name}/.ssh/id_rsa"
  cp "${AUTH_KEY_SRC}" "/home/${my_user_name}/.ssh/authorized_keys"
  chown -R "${my_user_name}" "/home/${my_user_name}/.ssh/authorized_keys"
  chgrp -R "${my_user_name}" "/home/${my_user_name}/.ssh/authorized_keys"
  chmod 600 "/home/${my_user_name}/.ssh/authorized_keys"

}

mk_teacher(){

  mk_student "teacher" "70001"
}

mk_students(){

  for i in $( seq ${FIRST_STUDENT} 1 ${NUM_STUDENTS} ); do
    user_num=$((60000 + i))
    if (( i > 9 )); then
        user_name=student${i}
    else
        user_name=student0${i}
    fi
  
    mk_student "${user_name}" "${user_num}"

  done;
}

##################################

case "${mode}" in
  "A")
    mk_teacher
    mk_students
    ;;
  "T")
    mk_teacher
    ;;
  "S")
    mk_students
    ;;
  *)
    echo "Error, must provide mode [A | T | S]" >&2
    echo "  A=all, T=teacher, S=students      " >&2
    exit 1
    ;;
esac


echo "When ready to set automatic SQL Plus for students run:"
echo "for i in /home/student0?; do sed -e '/labstart/s/^#//g' -i   $i/.bashrc; done"
echo "To turn off automatic sqlplus run:"
echo "for i in /home/student0?; do sed -e '/labstart/s/^/#/g' -i   $i/.bashrc; done"

# END
