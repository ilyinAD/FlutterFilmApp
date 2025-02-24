SELECT * from users;

select users.username from users group by username having username = 'testuser';

drop table users;

CREATE TABLE IF NOT EXISTS users (
                                     id SERIAL PRIMARY KEY,
                                     username VARCHAR(100) UNIQUE NOT NULL,
                                     password VARCHAR(100) NOT NULL,
                                    email varchar(100) unique not null
);

select users.id from users where username = 'q' and password = '1111111qq';

create table if not exists film (
    user_id int,
    id int primary key,
    picture varchar(100),
    name varchar(100) not null,
    rating double precision,
    description text,
    status int not null
);

insert into film
values (1, 2, '', '86', 10.0, 'cool', 1);

truncate table film;