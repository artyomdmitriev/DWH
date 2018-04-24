/**===============================================*\
Name...............:   dim_packaging_types
Contents...........:   Contains packaging types for orders
Author.............:   Artsemi Dzmitryieu
Date...............:   04/08/2018
\*=============================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_packaging_types';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.dim_packaging_types (
    packaging_type_id_dm       NUMBER(10) NOT NULL,
    packaging_type_id          NUMBER(10) NOT NULL,
    packaging_type_code        NVARCHAR2(50) NOT NULL,
    packaging_type_name        NVARCHAR2(255) NOT NULL,
    packaging_type_update_dt   DATE NOT NULL,
    packaging_type_insert_dt   DATE NOT NULL
);

ALTER TABLE bl_dm.dim_packaging_types ADD CONSTRAINT dim_packaging_type_pk PRIMARY KEY ( packaging_type_id_dm );

COMMENT ON TABLE bl_dm.dim_packaging_types
IS
  'Table Content: packaging types
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.dim_packaging_types.packaging_type_id_dm     IS 'Dimension surrogate key';
COMMENT ON column bl_dm.dim_packaging_types.packaging_type_id        IS 'Surrogate key for packaging types';
COMMENT ON column bl_dm.dim_packaging_types.packaging_type_code      IS 'Business key of the packaging type';
COMMENT ON column bl_dm.dim_packaging_types.packaging_type_name      IS 'Name of the packaging type';
COMMENT ON column bl_dm.dim_packaging_types.packaging_type_update_dt IS 'Update date of the packaging type';
COMMENT ON column bl_dm.dim_packaging_types.packaging_type_insert_dt IS 'Insert date of the packaging type';