var bind1 CHAR(4);
exec :bind1 := '1';

SELECT t1.p_category, t2.tpmethod
  FROM products t1, products t2
  WHERE t1.prod_category  = 'SFD'
    AND t2.method_typ != 'SEA'
UNION ALL
SELECT t3.p_category, t4.tpmethod
  FROM products t3, sources t4
  WHERE t3.scid = t4.scid
    AND t4.carrier   = 'AAC'
    AND t4.s_area    = :bind1;

