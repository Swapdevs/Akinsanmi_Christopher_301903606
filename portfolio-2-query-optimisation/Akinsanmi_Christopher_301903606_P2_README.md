# Digital Wallet and Remittance System — SQL queries

## 1. Show related remittances, wallets, customers records (up to 20).

```sql
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
```

| remittances_remittance_id | remittances_external_reference | wallets_wallet_id | wallets_currency | customers_customer_id | customers_full_name |
| --- | --- | --- | --- | --- | --- |
| 201 | REM-2026-0001 | 101 | USD | 1 | Maya Chen |
| 202 | REM-2026-0002 | 103 | USD | 2 | Owen Patel |

## 2. Find remittances records where status matches "settled" (up to 20).

```sql
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;
```

| remittance_id | external_reference | sender_wallet_id | recipient_wallet_id | amount | currency | status | initiated_at | settled_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | REM-2026-0001 | 101 | 103 | 125.25 | USD | settled | 2026-02-01T10:15:00+00:00 | 2026-02-01T10:20:00+00:00 |

## 3. Count remittances records for each sender_wallet_id (up to 20 groups).

```sql
SELECT "sender_wallet_id", count(*) AS record_count
FROM portfolio."remittances"
GROUP BY "sender_wallet_id"
ORDER BY record_count DESC, "sender_wallet_id" NULLS LAST
LIMIT 20;
```

| sender_wallet_id | record_count |
| --- | --- |
| 101 | 1 |
| 103 | 1 |

## 4. Find remittances records where status matches "settled" (up to 20).

```sql
SELECT * FROM portfolio."remittances"
WHERE "status" IS NOT DISTINCT FROM 'settled'
ORDER BY "remittance_id"
LIMIT 20;
```

| remittance_id | external_reference | sender_wallet_id | recipient_wallet_id | amount | currency | status | initiated_at | settled_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | REM-2026-0001 | 101 | 103 | 125.25 | USD | settled | 2026-02-01T10:15:00+00:00 | 2026-02-01T10:20:00+00:00 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.495 | 1.11, 1.495, 1.797 | Sort → Seq Scan | 131 |
| After index | 0.18 | 0.18, 0.186, 0.178 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.495 ms to 0.18 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.061..1.062 rows=20 loops=1)
  Seq Scan on remittances (actual time=0.016..1.024 rows=20 loops=1)
Planning Time: 0.371 ms
Execution Time: 1.11 ms
```

### Before index, run 2

```text
Sort (actual time=1.465..1.467 rows=20 loops=1)
  Seq Scan on remittances (actual time=0.016..1.43 rows=20 loops=1)
Planning Time: 0.373 ms
Execution Time: 1.495 ms
```

### Before index, run 3

```text
Sort (actual time=1.756..1.758 rows=20 loops=1)
  Seq Scan on remittances (actual time=0.027..1.708 rows=20 loops=1)
Planning Time: 0.569 ms
Execution Time: 1.797 ms
```

### After index, run 1

```text
Sort (actual time=0.133..0.135 rows=20 loops=1)
  Bitmap Heap Scan on remittances (actual time=0.028..0.099 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=20 loops=1)
Planning Time: 0.602 ms
Execution Time: 0.18 ms
```

### After index, run 2

```text
Sort (actual time=0.138..0.14 rows=20 loops=1)
  Bitmap Heap Scan on remittances (actual time=0.028..0.101 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.61 ms
Execution Time: 0.186 ms
```

### After index, run 3

```text
Sort (actual time=0.13..0.132 rows=20 loops=1)
  Bitmap Heap Scan on remittances (actual time=0.026..0.095 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.588 ms
Execution Time: 0.178 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Akinsanmi_Christopher_301903606_P2_Queries.sql, then Akinsanmi_Christopher_301903606_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Akinsanmi_Christopher_301903606_P2_QueryResults.png) · [Index comparison](screenshots/Akinsanmi_Christopher_301903606_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

