CREATE TABLE test1 (a int, b text);
INSERT INTO test1 VALUES (1, 'one');
CREATE INDEX test1_a_idx ON test1 USING brin (a);

SELECT brin_page_type(get_raw_page('test1_a_idx', 0));
SELECT brin_page_type(get_raw_page('test1_a_idx', 1));
SELECT brin_page_type(get_raw_page('test1_a_idx', 2));

SELECT * FROM brin_metapage_info(get_raw_page('test1_a_idx', 0));
SELECT * FROM brin_metapage_info(get_raw_page('test1_a_idx', 1));

SELECT * FROM brin_revmap_data(get_raw_page('test1_a_idx', 0)) LIMIT 5;
SELECT * FROM brin_revmap_data(get_raw_page('test1_a_idx', 1)) LIMIT 5;

SELECT * FROM brin_page_items(get_raw_page('test1_a_idx', 2), 'test1_a_idx')
    ORDER BY blknum, attnum LIMIT 5;

-- Failure for non-BRIN index.
CREATE INDEX test1_a_btree ON test1 (a);
SELECT brin_page_items(get_raw_page('test1_a_btree', 0), 'test1_a_btree');

-- Mask DETAIL messages as these are not portable across architectures.
\set VERBOSITY terse
-- Invalid special area size
SELECT brin_page_type(get_raw_page('test1', 0));
SELECT * FROM brin_metapage_info(get_raw_page('test1', 0));
SELECT * FROM brin_revmap_data(get_raw_page('test1', 0));
\set VERBOSITY default

DROP TABLE test1;
