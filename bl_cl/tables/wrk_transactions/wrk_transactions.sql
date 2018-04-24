BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.wrk_transactions';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.wrk_transactions (
    invoice_no           NVARCHAR2(200),
    quantity             NVARCHAR2(200),
    tax_amount           NVARCHAR2(200),
    total_price          NVARCHAR2(200),
    transaction_date     NVARCHAR2(200),
    user_id              NVARCHAR2(200),
    product_id           NVARCHAR2(200),
    country              NVARCHAR2(200),
    city_code            NVARCHAR2(200),
    city                 NVARCHAR2(200),
    street_code          NVARCHAR2(200),
    street_name          NVARCHAR2(200),
    building_code        NVARCHAR2(200),
    building             NVARCHAR2(200),
    postal_code          NVARCHAR2(200)
);