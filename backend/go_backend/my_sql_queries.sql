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
    id int,
    picture varchar(100) not null,
    name varchar(100) not null,
    rating double precision not null,
    description text not null,
    status int not null,
    user_description text default '',
    user_rating double precision default null,
    film_url text default '',
    primary key (user_id, id)
);

insert into film
values (1, 2, '', '86', 10.0, 'cool', 1);

delete from film where id = 4;

update film set user_id = 2, picture = 'pic', name = '87', rating = 9.9, description = 'very cool', status = 2 where id = 4;

truncate table film;

drop table film;