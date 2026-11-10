# Normalisation of the Digital Wallet and Remittance System

**Christopher Akinsanmi** · Student ID 301903606
MIT 8103 Advanced Database Systems · Portfolio 1

## 1. Purpose

Normalisation is the process of organising relations so that each fact is recorded once and in the place where it belongs (Codd, 1970). Doing so reduces redundancy and protects a database from update, insertion and deletion anomalies. This document applies the first three normal forms to the Digital Wallet and Remittance System, using the fictional sample records from the portfolio. It starts from a deliberately denormalised arrangement and shows, step by step, how the final design of three tables (`customers`, `wallets` and `remittances`) is reached. The full field definitions are in the design document and the schema script.

## 2. Starting point: an unnormalised arrangement

A natural first attempt at recording wallets is to keep one row per customer and list that customer's wallets inside a single cell.

| customer_id | wallets (list) |
| --- | --- |
| 1 | [101, 102] |
| 2 | [103] |

This arrangement is not in first normal form. The `wallets` cell holds a set of values instead of one atomic value, so it cannot be queried, constrained or indexed reliably. For example, a foreign key cannot point at an individual wallet inside a list, and finding the owner of wallet 102 would require parsing text.

## 3. First normal form (1NF)

A relation is in 1NF when every attribute holds a single atomic value and every row can be identified by a key (Codd, 1970). Giving each wallet its own row satisfies both conditions. The table below also carries the customer's name alongside each wallet, since the original arrangement was intended to show who owns what.

| wallet_id | customer_id | currency | full_name |
| --- | --- | --- | --- |
| 101 | 1 | USD | Maya Chen |
| 102 | 1 | EUR | Maya Chen |
| 103 | 2 | USD | Owen Patel |

The key is `wallet_id`. Each cell now holds one value, so the relation is in 1NF. It is not yet well designed, however: the name "Maya Chen" appears twice because she owns two wallets.

## 4. Second normal form (2NF)

A relation is in 2NF when it is in 1NF and no non-key attribute depends on only part of a candidate key (Kent, 1983). The key here is the single column `wallet_id`, and a single-column key has no proper subset, so a partial dependency cannot occur. The relation therefore already satisfies 2NF, and the rows are unchanged at this step.

The check is still worth making explicit, because the next step depends on its result. The redundancy noted above has not been removed by 2NF; it belongs to a different kind of dependency, examined next.

## 5. Third normal form (3NF)

A relation is in 3NF when it is in 2NF and no non-key attribute depends on another non-key attribute, that is, there are no transitive dependencies (Kent, 1983). The 1NF table contains one:

> `wallet_id` → `customer_id` → `full_name`

A wallet determines its owner, and the owner determines the owner's name. The name is therefore a fact about the *customer*, not about the wallet, and storing it in every wallet row is the source of the repetition. Left in place, it would permit three anomalies:

- **Update anomaly.** If Maya Chen changes her name, every one of her wallet rows must be edited, and missing one leaves the data inconsistent.
- **Insertion anomaly.** A customer cannot be recorded until they have opened a wallet.
- **Deletion anomaly.** Closing a customer's only wallet would erase all record of the customer.

Decomposing the relation so that each entity keeps its own attributes removes the dependency. Wallets keep only a foreign key to their owner.

### customers

| customer_id | full_name | email | registered_date |
| --- | --- | --- | --- |
| 1 | Maya Chen | maya.chen@example.test | 2026-01-10 |
| 2 | Owen Patel | owen.patel@example.test | 2026-01-11 |

### wallets

| wallet_id | customer_id | currency | balance | opened_date | active |
| --- | --- | --- | --- | --- | --- |
| 101 | 1 | USD | 1250.50 | 2026-01-12 | true |
| 102 | 1 | EUR | 800.00 | 2026-01-13 | true |
| 103 | 2 | USD | 950.75 | 2026-01-14 | true |

### remittances

| remittance_id | external_reference | sender_wallet_id | recipient_wallet_id | amount | currency | status | initiated_at | settled_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 201 | REM-2026-0001 | 101 | 103 | 125.25 | USD | settled | 2026-02-01T10:15:00Z | 2026-02-01T10:20:00Z |
| 202 | REM-2026-0002 | 103 | 101 | 75.00 | USD | pending | 2026-02-02T09:00:00Z | NULL |

A remittance refers to its two wallets through foreign keys, so wallet and customer details are never repeated inside it. The `NULL` in `settled_at` is intentional: a pending transfer has no settlement time yet.

## 6. Functional dependencies of the final design

Each determinant below is the primary key of its table, and every non-key attribute depends on that key alone.

| Relation | Functional dependency |
| --- | --- |
| `customers` | `customer_id` → `full_name`, `email`, `registered_date` |
| `wallets` | `wallet_id` → `customer_id`, `currency`, `balance`, `opened_date`, `active` |
| `remittances` | `remittance_id` → `external_reference`, `sender_wallet_id`, `recipient_wallet_id`, `amount`, `currency`, `status`, `initiated_at`, `settled_at` |

`email` in `customers` and `external_reference` in `remittances` are additional candidate keys, since each is declared unique. They determine the remaining attributes of their rows as well, which does not violate 3NF because the determinant is a candidate key in each case.

## 7. Verification

The decomposition was checked by rejoining the three tables on their foreign keys. The join reproduces the three wallet rows of the 1NF table exactly (101 with Maya Chen, 102 with Maya Chen and 103 with Owen Patel), so no information was lost. This is the lossless-join property, and it holds here because every join is on a key.

## 8. Limitations and design decisions

- **Dependencies are assumed, not proven.** Functional dependencies come from the business rules, not from the data. The sample is too small to confirm them, so the design is only as sound as the stated rules.
- **A deliberate residual redundancy.** The design assumes that a remittance's `currency` matches the currency of both its wallets. If that assumption holds, `currency` is derivable from `sender_wallet_id`, which is technically a transitive dependency. I retained it as a recorded attribute of the transfer, because it fixes the currency at the moment of initiation, simplifies currency-based reporting (a stated analyst requirement) and avoids a join on every report. The cost is that the database does not itself enforce the match; it relies on the application, so this is a known trade-off rather than a verified guarantee.
- **Wallet uniqueness is a rule, not a key.** Allowing one active wallet per customer and currency is enforced by a conditional unique index, not by the primary key, so it does not alter the normal-form analysis above.

## References

- Codd, E. F. (1970) 'A relational model of data for large shared data banks', *Communications of the ACM*, 13(6), pp. 377–387.
- Kent, W. (1983) 'A simple guide to five normal forms in relational database theory', *Communications of the ACM*, 26(2), pp. 120–125.
- PostgreSQL Global Development Group (2025) *PostgreSQL 17 documentation: Constraints*. Available at: https://www.postgresql.org/docs/17/ddl-constraints.html
