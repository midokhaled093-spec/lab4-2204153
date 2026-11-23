// Library website - Lab 4 search pages F2.1 - F2.6.
// Every query is the same SQL as in ../problem2_Queries.sql.
const express = require('express');
const path = require('path');
const db = require('./db');

const app = express();
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: false }));

// Small helper: run a query (optionally with ? placeholders) and return the rows.
async function rows(sql, params = []) {
  const [result] = await db.execute(sql, params);
  return result;
}

// ---------- Home ----------
app.get('/', (req, res) => res.render('index', { title: 'Library' }));

// ---------- F2.1 Search books (WHERE, LIKE, BETWEEN) - prepared statement (bonus) ----------
app.get('/search', async (req, res, next) => {
  try {
    const categories = await rows('SELECT category_id, name FROM category ORDER BY name');
    const form = {
      keyword: (req.query.keyword || '').trim(),
      min: (req.query.min || '').trim(),
      max: (req.query.max || '').trim(),
      category: (req.query.category || '').trim()
    };
    const searched = Object.keys(req.query).length > 0;
    let books = [];
    let error = null;

    if (searched) {
      const min = form.min === '' ? 0 : Number(form.min);
      const max = form.max === '' ? 99999999 : Number(form.max);
      if (Number.isNaN(min) || Number.isNaN(max)) {
        error = 'The minimum and maximum price must be numbers.';
      } else if (min > max) {
        error = 'The minimum price is larger than the maximum price.';
      } else {
        // What the user typed only goes through ? placeholders, never into the SQL text.
        let sql = `SELECT b.book_id, b.title, b.price, c.name AS category
                   FROM book b
                   JOIN category c ON b.category_id = c.category_id
                   WHERE b.title LIKE ?
                     AND b.price BETWEEN ? AND ?`;
        const params = [`%${form.keyword}%`, min, max];
        if (form.category !== '') {
          sql += ' AND b.category_id = ?';
          params.push(Number(form.category));
        }
        sql += ' ORDER BY b.price ASC';
        books = await rows(sql, params);
      }
    }
    res.render('search', { title: 'Search books', categories, form, books, searched, error });
  } catch (err) { next(err); }
});

// ---------- F2.2 Catalogue (JOIN) ----------
app.get('/catalogue', async (req, res, next) => {
  try {
    const books = await rows(
      `SELECT b.book_id, b.title, a.name AS author, p.name AS publisher, c.name AS category,
              b.price, b.publish_year
       FROM book b
       JOIN author    a ON b.author_id    = a.author_id
       JOIN publisher p ON b.publisher_id = p.publisher_id
       JOIN category  c ON b.category_id  = c.category_id
       ORDER BY b.book_id`);
    res.render('catalogue', { title: 'Catalogue', books });
  } catch (err) { next(err); }
});

// ---------- F2.3 Reports (GROUP BY, HAVING) ----------
app.get('/reports', async (req, res, next) => {
  try {
    const byCategory = await rows(
      `SELECT c.name AS category, COUNT(b.book_id) AS books, AVG(b.price) AS average_price
       FROM category c
       LEFT JOIN book b ON b.category_id = c.category_id
       GROUP BY c.category_id, c.name
       ORDER BY c.name`);
    const prolific = await rows(
      `SELECT a.author_id, a.name, COUNT(*) AS books
       FROM author a
       JOIN book b ON b.author_id = a.author_id
       GROUP BY a.author_id, a.name
       HAVING COUNT(*) >= 2
       ORDER BY books DESC, a.name`);
    const totals = (await rows(
      `SELECT SUM(price) AS total_price, MIN(price) AS smallest_price, MAX(price) AS largest_price
       FROM book`))[0];
    res.render('reports', { title: 'Reports', byCategory, prolific, totals });
  } catch (err) { next(err); }
});

// ---------- F2.4 Loans (JOIN, LEFT JOIN) ----------
app.get('/loans', async (req, res, next) => {
  try {
    const open = await rows(
      `SELECT l.loan_id, b.title, m.name AS member, l.loan_date
       FROM loan l
       JOIN book   b ON l.book_id   = b.book_id
       JOIN member m ON l.member_id = m.member_id
       WHERE l.return_date IS NULL
       ORDER BY l.loan_date`);
    const idleMembers = await rows(
      `SELECT m.member_id, m.name, m.email
       FROM member m
       LEFT JOIN loan l ON l.member_id = m.member_id
       WHERE l.loan_id IS NULL`);
    const idleBooks = await rows(
      `SELECT b.book_id, b.title
       FROM book b
       LEFT JOIN loan l ON l.book_id = b.book_id
       WHERE l.loan_id IS NULL
       ORDER BY b.book_id`);
    res.render('loans', { title: 'Loans', open, idleMembers, idleBooks });
  } catch (err) { next(err); }
});

// ---------- F2.5 Most borrowed (GROUP BY, ORDER BY, LIMIT) ----------
app.get('/most-borrowed', async (req, res, next) => {
  try {
    const topBooks = await rows(
      `SELECT b.book_id, b.title, COUNT(*) AS loans
       FROM loan l
       JOIN book b ON l.book_id = b.book_id
       GROUP BY b.book_id, b.title
       ORDER BY loans DESC, b.title
       LIMIT 3`);
    const topMember = (await rows(
      `SELECT m.member_id, m.name, COUNT(*) AS loans
       FROM loan l
       JOIN member m ON l.member_id = m.member_id
       GROUP BY m.member_id, m.name
       ORDER BY loans DESC, m.name
       LIMIT 1`))[0];
    res.render('most-borrowed', { title: 'Most borrowed', topBooks, topMember });
  } catch (err) { next(err); }
});

// ---------- F2.6 Authors and books (LEFT JOIN, JOIN) ----------
app.get('/authors', async (req, res, next) => {
  try {
    const authors = await rows(
      `SELECT a.author_id, a.name, a.country, COUNT(b.book_id) AS books
       FROM author a
       LEFT JOIN book b ON b.author_id = a.author_id
       GROUP BY a.author_id, a.name, a.country
       ORDER BY books DESC, a.name`);
    const sameCountry = await rows(
      `SELECT b.book_id, b.title, a.name AS author, p.name AS publisher, a.country
       FROM book b
       JOIN author    a ON b.author_id    = a.author_id
       JOIN publisher p ON b.publisher_id = p.publisher_id
       WHERE a.country = p.country
       ORDER BY b.title`);
    res.render('authors', { title: 'Authors and books', authors, sameCountry });
  } catch (err) { next(err); }
});

// ---------- Errors ----------
app.use((err, req, res, next) => {
  console.error(err);
  const hint = err.code === 'ER_ACCESS_DENIED_ERROR' ? 'The MySQL password is wrong. Set DB_PASSWORD (see README).'
    : err.code === 'ER_BAD_DB_ERROR' ? 'The database "library" does not exist. Run problem2_DDL.sql first.'
    : err.code === 'ECONNREFUSED' ? 'MySQL is not running on this machine.'
    : err.message;
  res.status(500).render('error', { title: 'Something went wrong', hint });
});

const port = Number(process.env.PORT || 3000);
app.listen(port, () => console.log(`Library website: http://localhost:${port}`));
