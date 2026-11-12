# Digital Wallet and Remittance System

**MIT 8103 Advanced Database Systems** • Individual portfolio

**Christopher Akinsanmi** • Student ID 301903606 • [Repository Link](https://github.com/Swapdevs/Akinsanmi_Christopher_301903606)

This portfolio comprises five sections, each focused on a single case study involving a digital wallet and remittance system. It addresses relational design, query optimisation, transaction management, implementation of a NoSQL event store, and considerations for distributed databases. All data utilized are fictitious.

## Case study

Customers hold currency-specific wallets and send remittances to other customers' wallets. The system serves three groups of users:

| User | What they do |
| --- | --- |
| Customers | Manage wallets, send and receive remittances |
| Operations staff | Review pending, failed and settled transfers |
| Analysts | Aggregate remittance activity by currency and status |

Main operations: register customers and wallets, initiate transfers between wallets, update transfer status and settlement timestamps, review exceptions and completed transfers, and measure transfer counts and values by currency.

### Data model

Three PostgreSQL tables in the `portfolio` schema:

```
customers (1) ──< wallets (1) ──< remittances (sender_wallet_id, recipient_wallet_id)
```

| Table | Purpose |
| --- | --- |
| `customers` | People who own wallets (unique email) |
| `wallets` | Currency-specific accounts owned by a customer |
| `remittances` | Transfers between two different wallets, with status and timestamps |

Remittance lifecycle events are also stored as documents in a MongoDB collection, `remittance_events` (Portfolio 4).

## Portfolios

| # | Topic | Technology | Key result |
| --- | --- | --- | --- |
| [1](portfolio-1-database-design/) | Database design and modelling | PostgreSQL | 3 normalised tables; all 29 invalid inserts rejected |
| [2](portfolio-2-query-optimisation/) | Query processing and optimisation | PostgreSQL | Median lookup 1.495 ms → 0.18 ms with an index |
| [3](portfolio-3-transactions-concurrency/) | Transactions and concurrency | PostgreSQL | `SELECT FOR UPDATE` prevents a lost update |
| [4](portfolio-4-nosql/) | NoSQL and advanced data models | MongoDB | 4 events inserted, 4 queries, validation rejects bad data |
| [5](portfolio-5-distributed-cloud/) | Distributed and cloud databases | MongoDB (design discussion) | Replica set, consistency and sharding proposal |

## Repository layout

```
.
├── README.md
├── Akinsanmi_Christopher_301903606_FinalSummary.md / .pdf
├── portfolio-1-database-design/            schema, sample data, constraint tests, design docs
├── portfolio-2-query-optimisation/         queries, index experiment, execution plans
├── portfolio-3-transactions-concurrency/   transaction script and two-session scripts
├── portfolio-4-nosql/                      MongoDB script, document model, queries
└── portfolio-5-distributed-cloud/          proposed replica-set design
```

Each portfolio folder has its own README, its scripts and a `screenshots/` folder with evidence.

## Running the exercises

**Requirements:** PostgreSQL 17 with `psql` (Portfolios 1–3) and MongoDB with `mongosh` (Portfolio 4). Portfolio 5 is a written proposal and needs nothing installed.

1. Create a fresh PostgreSQL database.
2. Run the Portfolio 1 schema, then the sample data.
3. Run Portfolios 2 and 3 against that same database. Portfolio 3 adds a temporary helper column to `remittances`, so use a fresh database again if you want a clean P1 state.
4. Run the Portfolio 4 script in `mongosh` against a fresh exercise database. It uses the database `portfolio_nosql` and stops if the collection already exists.

Exact commands and ordering are in each portfolio's README.

## Final summary

- [Final summary (Markdown)](Akinsanmi_Christopher_301903606_FinalSummary.md)
- [Final summary (PDF)](Akinsanmi_Christopher_301903606_FinalSummary.pdf)

It includes the reflection, the AI-use declaration and the reference list.

## Scope and limitations

- All customers, wallets, identifiers, balances and events are synthetic.
- Portfolio 5 is a design discussion. No cloud service, replica set, failover, sharding or recovery test was deployed.
- The MongoDB event documents hold snapshots of SQL records. They are not kept in sync with PostgreSQL, and PostgreSQL stays authoritative for the relational rules.

## AI-use declaration

GitHub Copilot and a portfolio generator helped prepare the database model, scripts and explanations. The generator ran the PostgreSQL and MongoDB exercises, checked the outputs and captured the result images. I am responsible for checking and explaining the submitted work. See the [final summary](Akinsanmi_Christopher_301903606_FinalSummary.md) for the full declaration.
