DROP TABLE IF EXISTS user;
CREATE TABLE user (
    user     integer not null primary key autoincrement,
    email    text not null,
    password text,
    key      text,
    active   integer,
    UNIQUE(email),
    UNIQUE(key)
);
