/* 23ai time_bucket example

  https://livesql.oracle.com/next/library/scripts/count-rows-in-n-minute-intervals-JU8xpi
  https://blogs.oracle.com/sql/post/group-rows-into-n-minute-intervals-with-sql#cheat-sheet
*/

create table time_data as  
select * from (   
  select date'2022-08-01'   
           + numtodsinterval ( level , 'minute' )   
           + ( mod ( level, 17 ) / 60 / 24 )  
           + ( sin ( level ) / 24 ) datetime  
  from   dual  
  connect by level <= 200  
  union  all  
  select date'2022-08-02'  
           + ( level / 4 )  
           + ( sin ( level ) / 24 ) datetime  
  from   dual  
  connect by level <= 100  
  
)  
where  datetime >= date'2022-08-01'  
and    datetime not between date'2022-08-01' + 15/24/60 and date'2022-08-01' + 19/24/60   
order  by datetime;


