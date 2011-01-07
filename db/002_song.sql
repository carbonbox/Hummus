DROP TABLE IF EXISTS song;
CREATE TABLE song (
    song     integer not null primary key autoincrement,
    title    text,
    artist   text,
    content  text
);
