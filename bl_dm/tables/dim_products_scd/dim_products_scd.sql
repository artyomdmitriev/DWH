/**===============================================*\
Name...............:   dim_products_scd
Contents...........:   Contains products information
Author.............:   Artsemi Dzmitryieu
Date...............:   04/05/2018
\*=============================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_products_scd';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.dim_products_scd (
    product_id_dm        NUMBER(10) NOT NULL,
    product_id           NUMBER(10) NOT NULL,
    product_code         NVARCHAR2(50) NOT NULL,
    product_name         NVARCHAR2(255) NOT NULL,
    product_price        NUMBER(8,2) NOT NULL,
    product_is_in_sale   CHAR(1 CHAR) NOT NULL,
    product_start_date   DATE NOT NULL,
    product_end_date     DATE NOT NULL,
    product_is_current   CHAR(1 CHAR) NOT NULL,
    product_insert_dt    DATE NOT NULL,
    product_update_dt    DATE NOT NULL
);

ALTER TABLE bl_dm.dim_products_scd ADD CONSTRAINT products_pk PRIMARY KEY ( product_id_dm );

COMMENT ON TABLE bl_dm.dim_products_scd
IS
  'Table Content: products
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.dim_products_scd.product_id_dm         IS 'Dimension surrogate key';
COMMENT ON column bl_dm.dim_products_scd.product_id            IS 'Surrogate key for products';
COMMENT ON column bl_dm.dim_products_scd.product_code          IS 'Business key for products';
COMMENT ON column bl_dm.dim_products_scd.product_name          IS 'Name of the product';
COMMENT ON column bl_dm.dim_products_scd.product_price         IS 'Price of the product';
COMMENT ON column bl_dm.dim_products_scd.product_is_in_sale    IS 'Sales status of the product';
COMMENT ON column bl_dm.dim_products_scd.product_start_date    IS 'Start date for SCD2';
COMMENT ON column bl_dm.dim_products_scd.product_end_date      IS 'End date for SCD2';
COMMENT ON column bl_dm.dim_products_scd.product_is_current    IS 'Status of the record for SCD2';
COMMENT ON column bl_dm.dim_products_scd.product_insert_dt     IS 'Insert date of the record';
COMMENT ON column bl_dm.dim_products_scd.product_update_dt     IS 'Update date of the record';