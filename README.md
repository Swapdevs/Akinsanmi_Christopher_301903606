# Digital Wallet and Remittance System

**MIT 8103 Advanced Database Systems** · Individual portfolio
**Christopher Akinsanmi** · Student ID 301903606 · [Repository](https://github.com/Swapdevs/Akinsanmi_Christopher_301903606)

## Overview

This repository holds my individual portfolio for MIT 8103. It consists of five pieces of work, all built around one case study: a digital wallet and remittance system. Together they cover relational design, query optimisation, transaction management, a NoSQL event store, and the design considerations for a distributed deployment. Every customer, wallet, identifier, balance and event in the repository is fictional.

I chose a remittance system because it combines requirements that pull in different directions. Money movements must be exact and consistent, which suits a relational database. Operational events are varied and append-only, which suits a document store. Reporting needs to be fast, which brings in indexing, while concurrent transfers raise questions of isolation and locking. One case therefore supports a meaningful discussion of each topic in the module.

## The case study

In the system, customers hold wallets that are each tied to a single currency, and they send remittances to other customers' wallets. Three groups of people use it.

| User group | Needs |
| --- | --- |
| Customers | Manage wallets, and send and receive remittances |
| Operations staff | Review pending, failed and settled transfers |
| Analysts | Aggregate remittance activity by currency and status |

The main operations are: registering customers and wallets, initiating transfers between wallets, updating a transfer's status and settlement timestamp, reviewing exceptions and completed transfers, and measuring transfer counts and values by currency.

### Data model

The relational design has three PostgreSQL tables in the `portfolio` schema. One customer owns many wallets, and one wallet takes part in many remittances as either sender or recipient.

```
customers (1) ──< wallets (1) ──< remittances (sender_wallet_id, recipient_wallet_id)
```

| Table | Purpose |
| --- | --- |
| `customers` | People who own wallets; email is unique |
| `wallets` | Currency-specific accounts owned by a customer |
| `remittances` | Transfers between two different wallets, with status and timestamps |

Remittance lifecycle events are stored separately, as documents in a MongoDB collection named `remittance_events` (Portfolio 4).

## The five portfolios

| # | Topic | Technology | Principal finding |
| --- | --- | --- | --- |
| [1](portfolio-1-database-design/) | Database design and modelling | PostgreSQL | Three normalised tables; all 29 deliberately invalid inserts were rejected |
| [2](portfolio-2-query-optimisation/) | Query processing and optimisation | PostgreSQL | An index reduced the median lookup time from 1.495 ms to 0.18 ms |
| [3](portfolio-3-transactions-concurrency/) | Transactions and concurrency | PostgreSQL | Row locking with `SELECT ... FOR UPDATE` prevented a lost update |
| [4](portfolio-4-nosql/) | NoSQL and advanced data models | MongoDB | Four events inserted and four queries answered; validation rejected malformed data |
| [5](portfolio-5-distributed-cloud/) | Distributed and cloud databases | MongoDB (design discussion) | A proposed replica set, with consistency and sharding trade-offs |

Each folder has its own README that explains the method, the results and the steps to reproduce them.

## Repository structure

```
.
├── README.md
├── Akinsanmi_Christopher_301903606_FinalSummary.md / .pdf
├── portfolio-1-database-design/            schema, sample data, constraint tests, design documents
├── portfolio-2-query-optimisation/         queries, index experiment, execution plans
├── portfolio-3-transactions-concurrency/   transaction script and two-session scripts
├── portfolio-4-nosql/                      MongoDB script, document model, queries
└── portfolio-5-distributed-cloud/          proposed replica-set design
```

Every portfolio folder also contains a `screenshots/` directory with the evidence for its results.

## Reproducing the work

**Requirements.** PostgreSQL 17 with `psql` is needed for Portfolios 1 to 3, and MongoDB with `mongosh` for Portfolio 4. Portfolio 5 is a written proposal and needs no software.

The portfolios depend on one another, so the order matters.

1. Create a fresh PostgreSQL database.
2. Run the Portfolio 1 schema script, and then the sample data script.
3. Run Portfolios 2 and 3 against the same database. Portfolio 3 adds a temporary helper column to `remittances`, so use a fresh database if you want to return to the clean Portfolio 1 state.
4. Run the Portfolio 4 script in `mongosh`. It uses the database `portfolio_nosql` and stops if the collection already exists, so use a fresh database or drop the collection first.

The exact commands and the expected output are in each portfolio's README. Timings in Portfolio 2 depend on the machine, so the plan shapes and buffer counts are the reliable points of comparison, not the exact milliseconds.

## Final summary

The final summary draws the five portfolios together. It contains my individual reflection, the AI-use declaration and the reference list.

- [Final summary (Markdown)](Akinsanmi_Christopher_301903606_FinalSummary.md)
- [Final summary (PDF)](Akinsanmi_Christopher_301903606_FinalSummary.pdf)

## Scope and limitations

- All data are synthetic and carry no real personal or financial information.
- Portfolio 5 is a design discussion. No cloud service, replica set, failover, sharding or recovery test was deployed, so its claims are reasoned from documentation and not measured.
- The Portfolio 2 timings come from one environment and one lookup pattern. They show how an index changes the execution plan, and they do not support a general claim about performance.
- The MongoDB event documents hold snapshots of SQL records and are not synchronised with PostgreSQL. PostgreSQL remains the authority for the relational rules.

## Use of AI tools

I used GitHub Copilot and a portfolio generator to help prepare the database model, scripts and explanations. The generator ran the PostgreSQL and MongoDB exercises, checked the outputs and captured the result images. I am responsible for checking and explaining the submitted work. The [final summary](Akinsanmi_Christopher_301903606_FinalSummary.md) contains the full declaration.

## Selected references

- PostgreSQL Global Development Group. *PostgreSQL 17 documentation*: [constraints](https://www.postgresql.org/docs/17/ddl-constraints.html), [EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html), [transaction isolation](https://www.postgresql.org/docs/17/transaction-iso.html) and [explicit locking](https://www.postgresql.org/docs/17/explicit-locking.html).
- MongoDB, Inc. *MongoDB manual*: [data modelling](https://www.mongodb.com/docs/manual/data-modeling/), [replication](https://www.mongodb.com/docs/manual/replication/) and [sharding](https://www.mongodb.com/docs/manual/sharding/).

The full reference list is in the final summary.
