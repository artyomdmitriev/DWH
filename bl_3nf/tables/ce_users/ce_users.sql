BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_users (
    user_id              NUMBER(10) NOT NULL,
    user_code            NVARCHAR2(50) NOT NULL,
    user_first_name      NVARCHAR2(255) NOT NULL,
    user_last_name       NVARCHAR2(255) NOT NULL,
    user_email           NVARCHAR2(255) NOT NULL,
    user_gender          NVARCHAR2(20) NOT NULL,
    user_date_of_birth   DATE NOT NULL,
    user_update_dt       DATE NOT NULL,
    user_insert_dt       DATE NOT NULL,
    building_id          NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_users ADD CONSTRAINT users_pk PRIMARY KEY ( user_id );

ALTER TABLE bl_3nf.ce_users
    ADD CONSTRAINT users_buildings_fk FOREIGN KEY ( building_id )
        REFERENCES bl_3nf.ce_buildings ( building_id );

INSERT INTO bl_3nf.ce_users (
    user_id,
    user_code,
    user_first_name,
    user_last_name,
    user_email,
    user_gender,
    user_date_of_birth,
    user_update_dt,
    user_insert_dt,
    building_id
) VALUES (
    -1,
    'N/D',
    'N/D',
    'N/D',
    'N/D',
    'N/D',
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    -1
);

COMMIT;