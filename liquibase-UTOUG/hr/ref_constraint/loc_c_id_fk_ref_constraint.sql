ALTER TABLE "LOCATIONS" ADD CONSTRAINT "LOC_C_ID_FK" FOREIGN KEY ("COUNTRY_ID")
	  REFERENCES "COUNTRIES" ("COUNTRY_ID") ENABLE;