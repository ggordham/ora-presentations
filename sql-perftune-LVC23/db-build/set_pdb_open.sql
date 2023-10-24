

DECLARE
  v_pdb   varchar2(64);
  v_i     number;
  v_start number;
  v_end   number;
BEGIN
  v_start := 1;
  v_end := 9;

  FOR v_i IN v_start .. v_end
  LOOP
      IF v_i < 10 THEN
          v_pdb := 'pdb0' || v_i;
      ELSE
          v_pdb := 'pdb' || v_i;
      END IF;

      EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ' || v_pdb || ' OPEN';
      EXECUTE IMMEDIATE 'ALTER PLUGGABLE DATABASE ' || v_pdb || ' SAVE STATE';
  END LOOP;
END;
/

