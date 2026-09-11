/* cr_departments.sql */

CREATE SEQUENCE departments_seq
 START WITH     280
 INCREMENT BY   10
 MAXVALUE       9990
 NOCACHE
 NOCYCLE;

CREATE TABLE departments$0
    (department_id    NUMBER(4) DEFAULT departments_seq.NEXTVAL CONSTRAINT dept_id_pk PRIMARY KEY, 
     department_name  VARCHAR2(30) CONSTRAINT  dept_name_nn  NOT NULL,
     manager_id       NUMBER(6));

CREATE EDITIONING VIEW departments AS
    SELECT department_id, department_name, manager_id FROM departments$0;


INSERT INTO departments VALUES ( 10, 'Administration', 200);
INSERT INTO departments VALUES ( 20 , 'Marketing' , 201);
INSERT INTO departments VALUES ( 30 , 'Purchasing' , 114);
INSERT INTO departments VALUES ( 40 , 'Human Resources' , 203);
INSERT INTO departments VALUES ( 50 , 'Shipping' , 121);
INSERT INTO departments VALUES ( 60 , 'IT' , 103);
INSERT INTO departments VALUES ( 70 , 'Public Relations' , 204);
INSERT INTO departments VALUES ( 80 , 'Sales' , 145);
INSERT INTO departments VALUES ( 90 , 'Executive' , 100);
INSERT INTO departments VALUES ( 100 , 'Finance' , 108);
INSERT INTO departments VALUES ( 110 , 'Accounting' , 205);
INSERT INTO departments VALUES ( 120 , 'Treasury' , NULL);
INSERT INTO departments VALUES ( 130 , 'Corporate Tax' , NULL);
INSERT INTO departments VALUES ( 140 , 'Control And Credit' , NULL);
INSERT INTO departments VALUES ( 150 , 'Shareholder Services' , NULL);
INSERT INTO departments VALUES ( 160 , 'Benefits' , NULL);
INSERT INTO departments VALUES ( 170 , 'Manufacturing' , NULL);
INSERT INTO departments VALUES ( 180 , 'Construction' , NULL);
INSERT INTO departments VALUES ( 190 , 'Contracting' , NULL);
INSERT INTO departments VALUES ( 200 , 'Operations' , NULL);
INSERT INTO departments VALUES ( 220 , 'NOC' , NULL);
INSERT INTO departments VALUES ( 240 , 'Government Sales' , NULL);
INSERT INTO departments VALUES ( 250 , 'Retail Sales' , NULL);
INSERT INTO departments VALUES ( 260 , 'Recruiting' , NULL);
INSERT INTO departments VALUES ( 270 , 'Payroll' , NULL);

COMMIT;

