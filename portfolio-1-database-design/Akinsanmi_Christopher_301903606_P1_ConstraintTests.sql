-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customers pk duplicate. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (1, 'Duplicate Customer', 'duplicate.pk@example.test', '2026-03-01');

-- 2. customers email duplicate. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (301, 'Duplicate Email', 'maya.chen@example.test', '2026-03-02');

-- 3. customers customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (NULL, 'Missing Identifier', 'missing.id@example.test', '2026-03-03');

-- 4. customers full name null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (302, NULL, 'missing.name@example.test', '2026-03-04');

-- 5. customers email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (303, 'Missing Email', NULL, '2026-03-05');

-- 6. customers registered date null. Expected: registered_date, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date")
VALUES (304, 'Missing Date', 'missing.date@example.test', NULL);

-- 7. wallets pk duplicate. Expected: pk_wallets, SQLSTATE 23505.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (101, 2, 'GBP', 10, '2026-03-06', FALSE);

-- 8. wallets customer fk invalid. Expected: fk_wallets_0, SQLSTATE 23503.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (305, 9991, 'GBP', 10, '2026-03-07', FALSE);

-- 9. wallets wallet id null. Expected: wallet_id, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (NULL, 2, 'GBP', 10, '2026-03-08', FALSE);

-- 10. wallets customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (306, NULL, 'GBP', 10, '2026-03-09', FALSE);

-- 11. wallets currency null. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (307, 2, NULL, 10, '2026-03-10', FALSE);

-- 12. wallets balance null. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (308, 2, 'GBP', NULL, '2026-03-11', FALSE);

-- 13. wallets opened date null. Expected: opened_date, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (309, 2, 'GBP', 10, NULL, FALSE);

-- 14. wallets active null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (310, 2, 'GBP', 10, '2026-03-12', NULL);

-- 15. remittances pk duplicate. Expected: pk_remittances, SQLSTATE 23505.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (201, 'REM-2026-0301', 101, 103, 5, 'USD', 'pending', '2026-03-13T10:00:00Z', NULL);

-- 16. remittances reference duplicate. Expected: uq_remittances_0, SQLSTATE 23505.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (311, 'REM-2026-0001', 103, 101, 5, 'USD', 'pending', '2026-03-14T10:00:00Z', NULL);

-- 17. remittances sender fk invalid. Expected: fk_remittances_0, SQLSTATE 23503.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (312, 'REM-2026-0312', 9992, 101, 5, 'USD', 'pending', '2026-03-15T10:00:00Z', NULL);

-- 18. remittances recipient fk invalid. Expected: fk_remittances_1, SQLSTATE 23503.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (313, 'REM-2026-0313', 101, 9993, 5, 'USD', 'pending', '2026-03-16T10:00:00Z', NULL);

-- 19. remittances id null. Expected: remittance_id, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (NULL, 'REM-2026-0314', 101, 103, 5, 'USD', 'pending', '2026-03-17T10:00:00Z', NULL);

-- 20. remittances reference null. Expected: external_reference, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (315, NULL, 101, 103, 5, 'USD', 'pending', '2026-03-18T10:00:00Z', NULL);

-- 21. remittances sender null. Expected: sender_wallet_id, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (316, 'REM-2026-0316', NULL, 103, 5, 'USD', 'pending', '2026-03-19T10:00:00Z', NULL);

-- 22. remittances recipient null. Expected: recipient_wallet_id, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (317, 'REM-2026-0317', 101, NULL, 5, 'USD', 'pending', '2026-03-20T10:00:00Z', NULL);

-- 23. remittances amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (318, 'REM-2026-0318', 101, 103, NULL, 'USD', 'pending', '2026-03-21T10:00:00Z', NULL);

-- 24. remittances currency null. Expected: currency, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (319, 'REM-2026-0319', 101, 103, 5, NULL, 'pending', '2026-03-22T10:00:00Z', NULL);

-- 25. remittances status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (320, 'REM-2026-0320', 101, 103, 5, 'USD', NULL, '2026-03-23T10:00:00Z', NULL);

-- 26. remittances initiated null. Expected: initiated_at, SQLSTATE 23502.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (321, 'REM-2026-0321', 101, 103, 5, 'USD', 'pending', NULL, NULL);

-- 27. wallets active currency duplicate. Expected: active_currency_unique, SQLSTATE 23505.
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active")
VALUES (322, 1, 'USD', 20, '2026-03-24', TRUE);

-- 28. remittances nonpositive amount. Expected: positive_remittance_amount, SQLSTATE 23514.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (323, 'REM-2026-0323', 101, 103, 0, 'USD', 'pending', '2026-03-25T10:00:00Z', NULL);

-- 29. remittances same wallet roles. Expected: distinct_wallet_roles, SQLSTATE 23514.
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at")
VALUES (324, 'REM-2026-0324', 101, 101, 5, 'USD', 'pending', '2026-03-26T10:00:00Z', NULL);
