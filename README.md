# Lab 4 — Search Queries in SQL

**Students:**

- Ahmed Khaled Habib — 2204153
- Mohamed Elhussiny — 2204073
- (third group member — add name and ID)

**Course:** Introduction to Database Systems, Fall 2026 (Dr. Yasser Fouad)

```
lab4-2204153/
  problem1_DDL.sql       # Problem 1 – COMPANY database (5 tables)
  problem1_DML.sql       # rows for the five tables
  problem1_Answers.txt   # SQL and output/error for Q1.1 – Q1.12
  problem2_DDL.sql       # Problem 2 – library database (6 tables)
  problem2_DML.sql       # seed data
  problem2_Queries.sql   # the SQL of the pages F2.1 – F2.6
  website/               # Express + MySQL website with the new search pages
  README.md
```

## Requirements

- **MySQL Server 8.0** (the `mysql` client must be on your PATH)
- **Node.js 18+** (comes with `npm`)

## 1. Problem 1 — COMPANY database

Run from the repository folder:

```
mysql -u root -p < problem1_DDL.sql     # drops and recreates the database `company`
mysql -u root -p < problem1_DML.sql     # inserts the rows
mysql -u root -p company                # type queries by hand
```

Both scripts can be re-run at any time. `problem1_Answers.txt` holds the SQL and the real output
(or error message) of Q1.1 – Q1.12. It was produced on fresh data, in the order of the questions, so
the changes of Q1.1 – Q1.3 (new employee 123456789, new project 60, 10% raise in department 2, project 20
moved to Giza, one dependent and one `works_on` row deleted) are visible in the later answers.

## 2. Problem 2 — library database

```
mysql -u root -p < problem2_DDL.sql       # drops and recreates the database `library`, 6 tables
mysql -u root -p < problem2_DML.sql       # seed data
mysql -u root -p library < problem2_Queries.sql   # runs the query of every page (comments -- F2.1 ... -- F2.6)
```

### Schema

| Table     | Columns                                                                    | Keys                                                                    |
| --------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| AUTHOR    | `author_id`, `name`, `country`                                             | PK `author_id`                                                          |
| PUBLISHER | `publisher_id`, `name`, `country`                                          | PK `publisher_id`                                                       |
| CATEGORY  | `category_id`, `name`                                                      | PK `category_id`                                                        |
| BOOK      | `book_id`, `title`, `price`, `publish_year`, `author_id`, `publisher_id`, `category_id` | PK `book_id`; FK to AUTHOR (**ON DELETE CASCADE**), PUBLISHER, CATEGORY |
| MEMBER    | `member_id`, `name`, `email`, `join_date`                                  | PK `member_id`                                                          |
| LOAN      | `loan_id`, `book_id`, `member_id`, `loan_date`, `return_date`              | PK `loan_id`; FK to BOOK (**ON DELETE CASCADE**), MEMBER                |

`return_date` is `NULL` while the book is still borrowed.

### Seed data (what it contains)

5 authors, 3 publishers, 3 categories, 10 books, 6 members, 13 loans, including: two authors from Egypt,
an author with no books, authors with 2 and 3 books, an author and a publisher from Egypt (and from the UK),
books priced between 15 and 20, books never borrowed, a member with no loans, and 3 loans not returned yet.

## 3. The website

### Step 1 — install packages (first time only)

```
cd website
npm install
```

### Step 2 — tell the website your MySQL password

The website connects as `root` on `localhost:3306` to the database `library`. Set your password in an
environment variable before starting:

| Shell              | Command                            |
| ------------------ | ---------------------------------- |
| Windows PowerShell | `$env:DB_PASSWORD="your_password"` |
| Windows CMD        | `set DB_PASSWORD=your_password`    |
| macOS / Linux      | `export DB_PASSWORD=your_password` |

Other optional variables: `DB_USER`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `PORT`.

### Step 3 — start it

```
npm start
```

Open **http://localhost:3000**

### Pages

| Feature                                                                  | Where             |
| ------------------------------------------------------------------------ | ----------------- |
| **F2.1** Search books: title (LIKE), price (BETWEEN), category, cheapest first | `/search`         |
| **F2.2** Catalogue: author, publisher and category names (JOIN)          | `/catalogue`      |
| **F2.3** Reports: per category, authors with ≥ 2 books, price totals     | `/reports`        |
| **F2.4** Loans: not returned, members and books with no loans            | `/loans`          |
| **F2.5** Most borrowed: top 3 books and top member                       | `/most-borrowed`  |
| **F2.6** Authors with their number of books, same-country books          | `/authors`        |
| **Bonus** Prepared statements in F2.1                                    | `server.js`, route `/search` |

**Bonus:** the search form of F2.1 uses `db.execute(sql, params)` with `?` placeholders for the keyword, both
prices and the category, so what the user types never becomes part of the SQL text. Try the keyword
`' OR 1=1 --`: it simply finds no title.

The SQL of every page is the same as in `problem2_Queries.sql`.

## Troubleshooting

- **`Access denied for user 'root'@'localhost'`** — `DB_PASSWORD` is wrong or not set in the same terminal you ran `npm start` from.
- **`Unknown database 'library'`** — run `problem2_DDL.sql` first.
- **Port 3000 already in use** — start with another port, e.g. `PORT=4000 npm start` (PowerShell: `$env:PORT=4000; npm start`).
