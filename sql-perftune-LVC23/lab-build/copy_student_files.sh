#!/bin/bash
# copy_student_files.sh
#
#
# Need to get files from trace diretory
# Oraganize by PDB (student ID)
# Make sure file is done (not still being written to)
# create web page with links to files
# 
# Trace file example
# /u01/app/oracle/diag/rdbms/lvcdb1/lvcdb1/trace/lvcdb1_ora_13198_fixq1.trc

LAB_NAME=sql-perftune-LVC23
TRACE_LIST="histogram nostats stats profile no_profile basic student"

DIAG_DIR=/u01/app/oracle/diag
DB_NAME=lvcdb1
WEB_DIR=/u01/app/oracle/ords/static

TRACE_DIR="${DIAG_DIR}/rdbms/${DB_NAME}/${DB_NAME}/trace"
trace_web_dir="${WEB_DIR}/traces"
if [ ! -d "${trace_web_dir}" ]; then mkdir -p "${trace_web_dir}" ; fi

# make an html page in the given directory
mk_html(){
    my_target_dir=$1
    my_html_file=$2
    chdir "${my_target_dir}" || return 1

    my_dir_title="$( basename "${my_target_dir}" )"
    my_tgt_file="${my_target_dir}/${my_html_file}"

    # generate a list of files for HTML downlaod
    {
        echo "<HTML><TITLE>$my_dir_title</TITLE><BODY>" 
        echo "<H1>Files for $my_dir_title </H1><br><br>"
        echo "<TABLE>"
        for my_file in *; do
            echo "<TD><TR><a href=\"$my_file\">$my_file</a></TR></TD>"
        done

        echo "<br><br> page generated at: $( date +%Y%m%d.%H%M%S ) <br><br>"
        echo "</BODY></HTML>"
    } > "${my_tgt_file}"

    # make the new file readable by web server
    chmod o+r "${my_tgt_file}"
}

# loop forever looking for files
while true; do

    gen_html=N

    # for each user see if they have any HTML files in their sqlplus directory
    for user_dir in /home/student*; do
        student_name=$( basename "$user_dir" )
        target_dir="${WEB_DIR}/${student_name}"
        if [ !  -d "${target_dir}" ]; then mkdir -p "${target_dir}"; fi

        # Copy over any HTML files generated in the student directory
        for html_file in "${user_dir}/${LAB_NAME}"/sqlplus/*.html; do
            file_name="$( basename "${html_file}" )"
            if  [ "${html_file}" -nt "${target_dir}/${file_name}" ] || [ ! -f "${target_dir}/${file_name}" ]; then
                cp "${html_file}" "${target_dir}/"
                chmod o+r "${target_dir}/${file_name}"
                gen_html=Y
            fi
        done

        # Copy over any zip files generated in the student directory
        for zip_file in "${user_dir}/${LAB_NAME}"/sqlplus/*.zip; do
            file_name="$( basename "${zip_file}" )"
            if  [ "${zip_file}" -nt "${target_dir}/${file_name}" ] || [ ! -f "${target_dir}/${file_name}" ]; then
                cp "${zip_file}" "${target_dir}/"
                chmod o+r "${target_dir}/${file_name}"
                gen_html=Y
            fi
 
        done

        # if a new file was copied generate the HTML for the given user
        if [ "$gen_html" == "Y" ]; then mk_html "${target_dir}" index.html; fi
    done

    gen_html=N
    # look for trace files
    for trace_pattern in $TRACE_LIST; do
        for trace_file in "${TRACE_DIR}/*${$trace_pattern}.trc"; do
           file_name="$( basename "${trace_file}" )"
           if [ "${trace_file}" -nt "${trace_web_dir}/${file_name}" ] || [ ! -f "${trace_web_dir}/${file_name}" ]; then
               cp "${trace_file}" "${trace_web_dir}/"
               chmod o+r "${trace_web_dir}/${file_name}"
               gen_html=Y
            fi
        done
    done

    # if a new file was copied generate the HTML for the given user
    if [ "$gen_html" == "Y" ]; then mk_html "${trace_web_dir}" index.html; fi

    # sleep for 15 seconds before we try again
    sleep 15
done

# END
