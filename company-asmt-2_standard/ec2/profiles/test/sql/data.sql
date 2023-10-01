-- COMMENT POPULATION
-- Long id;
-- String message;
-- String username;
INSERT INTO comments (username, message) VALUES
    ('Jayne_Kuhic@sydney.com', 'laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium'),
    ('Nikita@garfield.biz', 'est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et'),
    ('Hayden@althea.biz', 'et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut'),
    ('Presley.Mueller@myrl.com', 'ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit'),
    ('Dallas@ole.me', 'repudiandae veniam quaerat sunt sed\nalias aut fugiat sit autem sed est\nvoluptatem omnis possimus esse voluptatibus quis\nest aut tenetur dolor neque'),
    ('Nikita@garfield.biz', 'harum non quasi et ratione\ntempore iure ex voluptates in ratione\nharum architecto fugit inventore cupiditate\nvoluptates magni quo et'),
    ('Mallory_Kunze@marie.org', 'doloribus at sed quis culpa deserunt consectetur qui praesentium\naccusamus fugiat dicta\nvoluptatem rerum ut voluptate autem\nvoluptatem repellendus aspernatur dolorem in'),
    ('Meghan_Littel@rene.us', 'sapiente assumenda molestiae atque\nadipisci laborum distinctio aperiam et ab ut omnis\net occaecati aspernatur odit sit rem expedita\nquas enim ipsam minus'),
    ('Carmen_Keeling@caroline.name', 'voluptate iusto quis nobis reprehenderit ipsum amet nulla\nquia quas dolores velit et non\naut quia necessitatibus\nnostrum quaerat nulla et accusamus nisi facilis'),
    ('Veronica_Goodwin@timmothy.net', 'ut dolorum nostrum id quia aut est\nfuga est inventore vel eligendi explicabo quis consectetur\naut occaecati repellat id natus quo est\nut blanditiis quia ut vel ut maiores ea'),
    ('Oswald.Vandervort@leanne.org', 'expedita maiores dignissimos facilis\nipsum est rem est fugit velit sequi\neum odio dolores dolor totam\noccaecati ratione eius rem velit'),
    ('Kariane@jadyn.tv', 'fuga eos qui dolor rerum\ninventore corporis exercitationem\ncorporis cupiditate et deserunt recusandae est sed quis culpa\neum maiores corporis et'),
    ('Nathan@solon.io', 'vel quae voluptas qui exercitationem\nvoluptatibus unde sed\nminima et qui ipsam aspernatur\nexpedita magnam laudantium et et quaerat ut qui dolorum'),
    ('Maynard.Hodkiewicz@roberta.com', 'ihil ut voluptates blanditiis autem odio dicta rerum\nquisquam saepe et est\nsunt quasi nemo laudantium deserunt\nmolestias tempora quo quia'),
    ('Christine@ayana.info', 'iste ut laborum aliquid velit facere itaque\nquo ut soluta dicta voluptate\nerror tempore aut et\nsequi reiciendis dignissimos expedita consequuntur libero sed fugiat facilis'),
    ('Preston_Hudson@blaise.tv', 'consequatur necessitatibus totam sed sit dolorum\nrecusandae quae odio excepturi voluptatum harum voluptas\nquisquam sit ad eveniet delectus\ndoloribus odio qui non labore'),
    ('Vincenza_Klocko@albertha.name', 'eritatis voluptates necessitatibus maiores corrupti\nneque et exercitationem amet sit et\nullam velit sit magnam laborum\nmagni ut molestias'),
    ('Madelynn.Gorczany@darion.biz', '"doloribus est illo sed minima aperiam\nut dignissimos accusantium tempore atque et aut molestiae\nmagni ut accusamus voluptatem quos ut voluptates\nquisquam porro sed architecto ut"'),
    ('Mariana_Orn@preston.org', 'qui harum consequatur fugiat\net eligendi perferendis at molestiae commodi ducimus\ndoloremque asperiores numquam qui\nut sit dignissimos reprehenderit tempore'),
    ('Noemie@marques.me', '"deleniti aut sed molestias explicabo\ncommodi odio ratione nesciunt\nvoluptate doloremque est\nnam autem error delectus"');

-- BLOGS POPULATION
-- Long id;
-- String username;
-- String title;
-- String message;
-- LocalDateTime createDate;
INSERT INTO blog (username, title, message, create_date) VALUES
    ('Jayne_Kuhic@sydney.com', 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit', 'quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto', current_timestamp),
    ('Nathan@solon.io', 'qui est esse', 'est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla', current_timestamp),
    ('Vincenza_Klocko@albertha.name', 'ea molestias quasi exercitationem repellat qui ipsa sit aut', 'et iusto sed quo iure\nvoluptatem occaecati omnis eligendi aut ad\nvoluptatem doloribus vel accusantium quis pariatur\nmolestiae porro eius odio et labore et velit aut', current_timestamp),
    ('Noemie@marques.me', 'eum et est occaecati', 'ullam et saepe reiciendis voluptatem adipisci\nsit amet autem assumenda provident rerum culpa\nquis hic commodi nesciunt rem tenetur doloremque ipsam iure\nquis sunt voluptatem rerum illo velit', current_timestamp);

-- BLOGS & COMMENTS UNION
-- Long blog;
-- Long comment;
INSERT INTO blog_comments (blog, comment) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (1, 5),
    (2, 6),
    (3, 7),
    (4, 8),
    (1, 9),
    (2, 10),
    (3, 11),
    (4, 12),
    (1, 13),
    (2, 14),
    (3, 15),
    (4, 16),
    (1, 17),
    (2, 18),
    (3, 19),
    (4, 20);