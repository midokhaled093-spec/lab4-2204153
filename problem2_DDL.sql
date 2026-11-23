-- Lab 4 - Problem 2: LIBRARY database (6 tables)
-- Run: mysql -u root -p < problem2_DDL.sql
DROP DATABASE IF EXISTS library;
CREATE DATABASE library;
USE library;

CREATE TABLE author (
    author_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL,
    country   VARCHAR(50)  NOT NULL,
    PRIMARY KEY (author_id)
);

CREATE TABLE publisher (
    publisher_id INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    country      VARCHAR(50)  NOT NULL,
    PRIMARY KEY (publisher_id)
);

CREATE TABLE category (
    category_id INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    PRIMARY KEY (category_id)
);

-- Deleting an author deletes all of the author's books (ON DELETE CASCADE).
CREATE TABLE book (
    book_id      INT           NOT NULL AUTO_INCREMENT,
    title        VARCHAR(150)  NOT NULL,
    price        DECIMAL(8,2)  NOT NULL,
    publish_year INT           NULL,
    author_id    INT           NOT NULL,
    publisher_id INT           NOT NULL,
    category_id  INT           NOT NULL,
    PRIMARY KEY (book_id),
    FOREIGN KEY (author_id)    REFERENCES author (author_id)       ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES publisher (publisher_id),
    FOREIGN KEY (category_id)  REFERENCES category (category_id)
);

CREATE TABLE member (
    member_id INT          NOT NULL AUTO_INCREMENT,
    name      VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NOT NULL,
    join_date DATE         NOT NULL,
    PRIMARY KEY (member_id),
    UNIQUE (email)
);

-- return_date is NULL while the book is still borrowed.
-- Deleting a book deletes its loans (ON DELETE CASCADE).
CREATE TABLE loan (
    loan_id     INT  NOT NULL AUTO_INCREMENT,
    book_id     INT  NOT NULL,
    member_id   INT  NOT NULL,
    loan_date   DATE NOT NULL,
    return_date DATE NULL,
    PRIMARY KEY (loan_id),
    FOREIGN KEY (book_id)   REFERENCES book (book_id)     ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member (member_id)
);
