BEGIN
   EXECUTE IMMEDIATE 'DROP USER bl_cl_dm CASCADE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
END;
/

CREATE USER bl_cl_dm IDENTIFIED BY bl_cl_dm
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users
TEMPORARY TABLESPACE temp
PROFILE default;

GRANT connect TO bl_cl_dm;
GRANT resource TO bl_cl_dm;
GRANT CREATE SYNONYM TO bl_cl_dm;

GRANT SELECT ON bl_3nf.ce_packaging_types TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_shipping_couriers TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_countries TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_cities TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_streets TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_postal_codes TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_products TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_buildings TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_users TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_invoices TO bl_cl_dm;
GRANT SELECT ON bl_3nf.ce_order_items TO bl_cl_dm;

GRANT SELECT ON bl_dm.dim_date TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.dim_delivery_addresses TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.dim_packaging_types TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.dim_products_scd TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.dim_shipping_couriers TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.dim_users TO bl_cl_dm;
GRANT SELECT, INSERT, UPDATE ON bl_dm.fct_order_items TO bl_cl_dm;

GRANT SELECT ON bl_dm.dim_delivery_addresses_seq TO bl_cl_dm;
GRANT SELECT ON bl_dm.dim_packaging_types_seq TO bl_cl_dm;
GRANT SELECT ON bl_dm.dim_products_scd_seq TO bl_cl_dm;
GRANT SELECT ON bl_dm.dim_shipping_couriers_seq TO bl_cl_dm;
GRANT SELECT ON bl_dm.dim_users_seq TO bl_cl_dm;
