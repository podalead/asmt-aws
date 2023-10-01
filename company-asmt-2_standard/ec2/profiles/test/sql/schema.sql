DROP TABLE blog IF EXISTS;
DROP TABLE blog_comments IF EXISTS;
DROP TABLE comments IF EXISTS;

CREATE TABLE blog (
    id bigserial not null primary key,
    create_date timestamp,
    message varchar(255),
    title varchar(255),
    username varchar(255)
);

CREATE TABLE comments (
    id bigserial not null primary key,
    message varchar(255),
    username varchar(255)
);

CREATE TABLE blog_comments (
    blog bigint not null,
    comment bigint not null
);

ALTER TABLE blog_comments ADD CONSTRAINT UK_th8pket2x59vxp1vakl47n4s UNIQUE (comment);
ALTER TABLE blog_comments ADD CONSTRAINT FK2t5hjofkedpmvytmi9gtuytnt FOREIGN KEY (comment) REFERENCES comments;
ALTER TABLE blog_comments ADD CONSTRAINT FKk2nsoji114n8sulcsnyjn1041 FOREIGN KEY (blog) REFERENCES blog;