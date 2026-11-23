-- Lab 4 - Problem 2: seed data for the library database
-- 5 authors, 3 publishers, 3 categories, 10 books, 6 members, 13 loans
USE library;

-- Two authors from Egypt; an author with no books (Márquez);
-- an author (Mahfouz) and a publisher (Dar El Shorouk) from Egypt,
-- and an author (Christie) and a publisher (Penguin) from the UK.
INSERT INTO author (author_id, name, country) VALUES
(1, 'Naguib Mahfouz',           'Egypt'),
(2, 'Taha Hussein',             'Egypt'),
(3, 'Agatha Christie',          'UK'),
(4, 'Paulo Coelho',             'Brazil'),
(5, 'Gabriel Garcia Marquez',   'Colombia');

INSERT INTO publisher (publisher_id, name, country) VALUES
(1, 'Dar El Shorouk', 'Egypt'),
(2, 'Penguin Books',  'UK'),
(3, 'HarperCollins',  'USA');

INSERT INTO category (category_id, name) VALUES
(1, 'Fiction'),
(2, 'Mystery'),
(3, 'Non-fiction');

-- Authors 1 and 3 wrote several books. Books 7, 9 and 10 are never borrowed.
-- Prices between 15 and 20: books 1, 2, 5, 8.
INSERT INTO book (book_id, title, price, publish_year, author_id, publisher_id, category_id) VALUES
(1,  'Palace Walk',                        18.50, 1956, 1, 1, 1),
(2,  'Children of the Alley',              16.00, 1959, 1, 1, 1),
(3,  'The Days',                           12.00, 1929, 2, 1, 3),
(4,  'Murder on the Orient Express',       14.99, 1934, 3, 2, 2),
(5,  'And Then There Were None',           17.50, 1939, 3, 2, 2),
(6,  'The Alchemist',                      22.00, 1988, 4, 3, 1),
(7,  'The Pilgrimage',                     25.00, 1987, 4, 3, 3),
(8,  'Midaq Alley',                        13.75, 1947, 1, 1, 1),
(9,  'The Mysterious Affair at Styles',     9.99, 1920, 3, 2, 2),
(10, 'On Pre-Islamic Poetry',              21.00, 1926, 2, 1, 3);

-- Member 5 (Mostafa Reda) has no loans.
INSERT INTO member (member_id, name, email, join_date) VALUES
(1, 'Ahmed Fathy',   'ahmed.fathy@example.com',   '2025-09-01'),
(2, 'Mariam Saad',   'mariam.saad@example.com',   '2025-10-12'),
(3, 'Khaled Younes', 'khaled.younes@example.com', '2025-11-03'),
(4, 'Hana Ali',      'hana.ali@example.com',      '2026-01-15'),
(5, 'Mostafa Reda',  'mostafa.reda@example.com',  '2026-02-20'),
(6, 'Dina Wael',     'dina.wael@example.com',     '2026-03-08');

-- Loans 9, 11 and 12 are not returned yet (return_date IS NULL).
-- Book 4 has 4 loans, book 1 has 3, book 5 has 2. Member 1 has 4 loans.
INSERT INTO loan (loan_id, book_id, member_id, loan_date, return_date) VALUES
(1,  4, 1, '2026-01-05', '2026-01-19'),
(2,  1, 2, '2026-01-10', '2026-01-24'),
(3,  5, 1, '2026-02-01', '2026-02-15'),
(4,  4, 3, '2026-02-03', '2026-02-17'),
(5,  2, 4, '2026-02-12', '2026-02-26'),
(6,  1, 1, '2026-03-01', '2026-03-15'),
(7,  4, 2, '2026-03-05', '2026-03-19'),
(8,  3, 3, '2026-03-20', '2026-04-03'),
(9,  6, 2, '2026-04-02', NULL),
(10, 1, 4, '2026-04-10', '2026-04-24'),
(11, 5, 3, '2026-05-01', NULL),
(12, 4, 1, '2026-05-12', NULL),
(13, 8, 6, '2026-05-20', '2026-06-03');
