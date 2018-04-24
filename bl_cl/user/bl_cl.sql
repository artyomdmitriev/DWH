BEGIN
   EXECUTE IMMEDIATE 'DROP USER bl_cl CASCADE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
END;
/

CREATE USER bl_cl IDENTIFIED BY bl_cl
DEFAULT TABLESPACE users
QUOTA UNLIMITED ON users
TEMPORARY TABLESPACE temp
PROFILE default;

GRANT connect TO bl_cl;
GRANT resource TO bl_cl;
GRANT CREATE SYNONYM TO bl_cl;

GRANT READ, WRITE ON DIRECTORY data_source_dir TO bl_cl;
GRANT SELECT ON sa_src.ext_invoices to bl_cl;
GRANT SELECT ON sa_src.ext_products to bl_cl;
GRANT SELECT ON sa_src.ext_users to bl_cl;
GRANT SELECT ON sa_src.ext_countries_codes to bl_cl;
GRANT SELECT ON sa_src.ext_transactions to bl_cl;

GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_packaging_types TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_shipping_couriers TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_countries TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_cities TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_streets TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_postal_codes TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_products TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_buildings TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_users TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_invoices TO bl_cl;
GRANT SELECT, INSERT, UPDATE ON bl_3nf.ce_order_items TO bl_cl;

GRANT SELECT ON bl_3nf.ce_packaging_types_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_shipping_couriers_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_countries_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_cities_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_streets_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_postal_codes_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_products_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_buildings_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_users_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_invoices_seq TO bl_cl;
GRANT SELECT ON bl_3nf.ce_order_items_seq TO bl_cl;