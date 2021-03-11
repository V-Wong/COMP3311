-- Count of all movies
CREATE OR REPLACE VIEW Q1(movie_count) AS
SELECT COUNT(*) FROM Movies;

-- All movie titles
CREATE OR REPLACE VIEW Q2(movie_title) AS
SELECT title FROM Movies;

-- Year of earliest movie
CREATE OR REPLACE VIEW Q3(earliest_year) AS
SELECT MIN(year) FROM Movies;

-- Count of all actors
CREATE OR REPLACE VIEW Q4(actor_count) AS
SELECT COUNT(*) FROM Actors;

-- Actor with given family name
CREATE OR REPLACE VIEW Q5(id, familyName, givenNames, gender) AS
SELECT * FROM Actors
WHERE familyName = 'Zeta-Jones';

-- Count of genres
CREATE OR REPLACE VIEW Q6(genre) AS
SELECT DISTINCT(genre)
FROM BelongsTo;

-- All movies directed by Spielberg
CREATE OR REPLACE VIEW Q7(title, year) AS
SELECT title, year
FROM Directors
INNER JOIN Directs ON Directs.director = Directors.id
INNER JOIN Movies ON Movies.id = Directs.movie
WHERE familyName = 'Spielberg';

-- Actors that have acted in all movies
CREATE OR REPLACE VIEW Q8(id, familyName, givenNames) AS
SELECT id, familyName, givenNames
FROM Actors a
WHERE NOT EXISTS (
    -- Set difference
    -- {All movies} - {Movies a has acted in}
    SELECT id FROM Movies
    EXCEPT
	SELECT movie AS id FROM AppearsIn WHERE actor = a.id
);

-- Directors that have directed no movies
CREATE OR REPLACE VIEW Q9(id, familyName, givenName) AS
SELECT id, familyName, givenNames
FROM Directors d
WHERE NOT EXISTS (
    SELECT *
    FROM Directors
    LEFT JOIN Directs ON Directs.director = Directors.id
    WHERE Directors.id = d.id AND director IS NOT NULL
);