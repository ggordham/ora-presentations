/* actualize_all.sql */

SET SERVEROUTPUT ON

declare
     type obj_t is record(
         object_name user_objects.object_name%type,
         object_type   user_objects.object_type%type);
     type obj_tt is table of obj_t;

     l_obj_list obj_tt;
     l_obj_count binary_integer := 0;
     v_sql VARCHAR2(4000);

begin
    loop
        select object_name, object_type 
        bulk   collect
        into   l_obj_list
        from   user_objects
        where  edition_name != sys_context('userenv', 'session_edition_name')
          AND object_type NOT IN ('TABLE', 'INDEX', 'SEQUENCE', 'PARTITION')
           or status = 'INVALID';

        exit when l_obj_list.count = l_obj_count;

        l_obj_count := l_obj_list.count;

        for i in 1 .. l_obj_count
        loop
            v_sql := 'ALTER '||l_obj_list(i).object_type||' '||l_obj_list(i).object_name||' COMPILE';
            IF l_obj_list(i).object_type IN ('FUNCTION', 'PACKAGE', 'PROCEDURE', 'LIBRARY', 'TYPE', 'TRIGGER') THEN
               v_sql := v_sql || ' REUSE SETTINGS';
            END IF;
            dbms_output.put_line(v_sql);
            EXECUTE IMMEDIATE v_sql;
        end loop;
    end loop;
end;
/

