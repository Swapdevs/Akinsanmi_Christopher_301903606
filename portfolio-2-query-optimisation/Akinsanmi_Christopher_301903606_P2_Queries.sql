-- Show related remittances, wallets, customers records (up to 20).
SELECT t0."remittance_id" AS "remittances_remittance_id",
       t0."external_reference" AS "remittances_external_reference",
       t1."wallet_id" AS "wallets_wallet_id",
       t1."currency" AS "wallets_currency",
       t2."customer_id" AS "customers_customer_id",
       t2."full_name" AS "customers_full_name"
FROM portfolio."remittances" t0
JOIN portfolio."wallets" t1 ON t0."sender_wallet_id" = t1."wallet_id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."remittance_id", t1."wallet_id", t2."customer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."remittance_id" AS "remittances_remittance_id",
       t0."external_reference" AS "remittances_external_reference",
       t1."wallet_id" AS "wallets_wallet_id",
       t1."currency" AS "wallets_currency",
       t2."customer_id" AS "customers_customer_id",
       t2."full_name" AS "customers_full_name"
FROM portfolio."remittances" t0
JOIN portfolio."wallets" t1 ON t0."sender_wallet_id" = t1."wallet_id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."remittance_id", t1."wallet_id", t2."customer_id"
LIMIT 20;

-- Find remittances records where status matches "settled" (up to 20).
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;

-- Count remittances records for each sender_wallet_id (up to 20 groups).
SELECT "sender_wallet_id", count(*) AS record_count
FROM portfolio."remittances"
GROUP BY "sender_wallet_id"
ORDER BY record_count DESC, "sender_wallet_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "sender_wallet_id", count(*) AS record_count
FROM portfolio."remittances"
GROUP BY "sender_wallet_id"
ORDER BY record_count DESC, "sender_wallet_id" NULLS LAST
LIMIT 20;

-- Find remittances records where status matches "settled" (up to 20).
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;
