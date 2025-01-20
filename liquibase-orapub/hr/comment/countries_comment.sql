
   COMMENT ON TABLE "COUNTRIES"  IS 'country table. Contains 25 rows. References with locations table.';
   COMMENT ON COLUMN "COUNTRIES"."COUNTRY_ID" IS 'Primary key of countries table.';
   COMMENT ON COLUMN "COUNTRIES"."COUNTRY_NAME" IS 'Country name';
   COMMENT ON COLUMN "COUNTRIES"."REGION_ID" IS 'Region ID for the country. Foreign key to region_id column in the departments table.';