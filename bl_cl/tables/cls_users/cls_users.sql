BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_users (
    user_id              NUMBER(10,0) NOT NULL,
    user_code            NVARCHAR2(50) NOT NULL,
    user_first_name      NVARCHAR2(255) NOT NULL,
    user_last_name       NVARCHAR2(255) NOT NULL,
    user_email           NVARCHAR2(255) NOT NULL,
    user_gender          NVARCHAR2(20) NOT NULL,
    user_date_of_birth   DATE NOT NULL,
    building_id         NUMBER(10,0) NOT NULL
);