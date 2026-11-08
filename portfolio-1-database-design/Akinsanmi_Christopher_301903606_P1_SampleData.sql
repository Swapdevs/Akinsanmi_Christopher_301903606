-- Fictional sample records for Digital Wallet and Remittance System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date") VALUES (1, 'Maya Chen', 'maya.chen@example.test', '2026-01-10');
INSERT INTO portfolio."customers" ("customer_id", "full_name", "email", "registered_date") VALUES (2, 'Owen Patel', 'owen.patel@example.test', '2026-01-11');
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active") VALUES (101, 1, 'USD', 1250.5, '2026-01-12', TRUE);
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active") VALUES (102, 1, 'EUR', 800, '2026-01-13', TRUE);
INSERT INTO portfolio."wallets" ("wallet_id", "customer_id", "currency", "balance", "opened_date", "active") VALUES (103, 2, 'USD', 950.75, '2026-01-14', TRUE);
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at") VALUES (201, 'REM-2026-0001', 101, 103, 125.25, 'USD', 'settled', '2026-02-01T10:15:00Z', '2026-02-01T10:20:00Z');
INSERT INTO portfolio."remittances" ("remittance_id", "external_reference", "sender_wallet_id", "recipient_wallet_id", "amount", "currency", "status", "initiated_at", "settled_at") VALUES (202, 'REM-2026-0002', 103, 101, 75, 'USD', 'pending', '2026-02-02T09:00:00Z', NULL);
COMMIT;
