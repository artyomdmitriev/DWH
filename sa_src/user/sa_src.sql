BEGIN
   EXECUTE IMMEDIATE 'DROP USER sa_src CASCADE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
END;
/

CREATE USER sa_src IDENTIFIED BY sa_src
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users
TEMPORARY TABLESPACE temp
PROFILE default;

GRANT connect TO sa_src;
GRANT resource TO sa_src;
GRANT CREATE SYNONYM TO sa_src;
GRANT CREATE ANY DIRECTORY TO sa_src;