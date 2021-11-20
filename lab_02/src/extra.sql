DROP TABLE IF EXISTS table1;
DROP TABLE IF EXISTS table2;
CREATE TABLE table1 (
    id INT,
    var1 VARCHAR,
    valid_from_dttm date,
    valid_to_dttm date
);

CREATE TABLE table2 (
    id INT,
    var2 VARCHAR,
    valid_from_dttm date,
    valid_to_dttm date
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-15'), (1, 'B', '2018-09-16', '5999-12-31');

INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-18'), (1, 'B', '2018-09-19', '5999-12-31');

SELECT t1.id, var1, var2,
	GREATEST(t1.valid_from_dttm, t2.valid_from_dttm) as valid_from_dttm,
	LEAST(t1.valid_to_dttm, t2.valid_to_dttm) as valid_to_dttm
FROM Table1 t1 join Table2 t2 on t1.id = t2.id
WHERE t1.valid_from_dttm <= t2.valid_to_dttm
    AND t2.valid_from_dttm <= t1.valid_to_dttm;