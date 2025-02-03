DROP TABLE IF EXISTS products purge;
DROP TABLE IF EXISTS sources purge;

CREATE TABLE products (p_category varchar2(100), tpmethod varchar2(100), prod_category varchar2(100), method_typ varchar2(100),scid varchar2(10), tp varchar2(100));
CREATE TABLE sources (p_category varchar2(100), tpmethod varchar2(100), scid varchar2(100),carrier varchar2(100), s_area char(4));

CREATE INDEX prod_cat_idx on products(prod_category);
CREATE INDEX prod_mtyp_idx on products(method_typ);
CREATE INDEX src_carr_idx on sources(carrier);
CREATE INDEX s_area_idx on sources (s_area);

INSERT INTO products values('A','B','C','D','E','F');
INSERT INTO sources values('A','B','C','D',1);

begin
  for i in 1..10
  loop
     insert into products select * from products;
     insert into sources select p_category,tpmethod,scid,rownum*i,i from sources;
  end loop;
end;
/
commit;

exec dbms_stats.gather_table_Stats(user,'sources')
exec dbms_stats.gather_table_Stats(user,'products')


