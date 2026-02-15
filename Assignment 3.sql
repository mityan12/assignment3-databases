-- query 1 --
CREATE TABLE "MusicVideo" (
    track_id INTEGER NOT NULL,
    video_director TEXT NOT NULL,
    PRIMARY KEY (track_id),
    FOREIGN KEY (track_id) REFERENCES tracks(TrackId)
);
-- Query 2 --
INSERT INTO MusicVideo (track_id, video_director) VALUES
(1, 'Melina Matsoukas'),
(2, 'Hype Williams'),
(3, 'Dave Meyers'),
(4, 'Joseph Kahn'),
(5, 'Mark Romanek'),
(6, 'Spike Jonze'),
(7, 'Mark Romanek'),
(8, 'Floria Sigismondi'),
(9, 'Michel Gondry'),
(10, 'Cole Bennett');

-- Query 3 --
INSERT INTO "MusicVideo" (track_id, video_director)
SELECT TrackId, "Spike Jonze"
FROM tracks
WHERE Name == "Voodoo";

-- Query 4 --
SELECT Name FROM tracks
WHERE Name LIKE '%á%'
   OR Name LIKE '%é%'
   OR Name LIKE '%í%'
   OR Name LIKE '%ó%'
   OR Name LIKE '%ú%';
   
  -- Query 5 -- Lists all tracks with their album & artist name
SELECT tracks.Name AS TrackName, albums.Title AS AlbumTitle, artists.Name AS ArtistName
FROM tracks
JOIN albums ON tracks.AlbumId = albums.AlbumId
JOIN artists ON albums.ArtistId = artists.ArtistId;
  
  -- Query 6 -- List each artist & the total duration of all their tracks
SELECT artists.Name AS ArtistName, SUM(tracks.Milliseconds) / 60000 AS TotalDurationMinutes
FROM tracks
JOIN albums ON tracks.AlbumId = albums.AlbumId
JOIN artists ON albums.ArtistId = artists.ArtistId
GROUP BY artists.ArtistId
ORDER BY TotalDurationMinutes DESC;

-- Query 7 -- Lists all customers that listen to longer than average tracks
SELECT DISTINCT customers.FirstName, customers.LastName
FROM customers
JOIN invoices ON customers.CustomerId = invoices.CustomerId
JOIN invoice_items ON invoices.InvoiceId = invoice_items.InvoiceId
JOIN tracks ON invoice_items.TrackId = tracks.TrackId
WHERE tracks.Milliseconds > (SELECT AVG(Milliseconds) FROM tracks WHERE Milliseconds < 900000)
AND tracks.Milliseconds < 900000;

-- Query 8 -- Lists all tracks not in the top 5 genres
SELECT tracks.Name AS TrackName, genres.Name AS Genre
FROM tracks
JOIN genres ON tracks.GenreId = genres.GenreId
WHERE genres.GenreId NOT IN (
    SELECT genres.GenreId
    FROM tracks
    JOIN genres ON tracks.GenreId = genres.GenreId
    GROUP BY genres.GenreId
    ORDER BY AVG(tracks.Milliseconds) DESC
    LIMIT 5
);