CREATE TABLE t1 (x INTEGER);
CREATE TABLE t2 (x INTEGER);

INSERT INTO t1 VALUES (1), (1), (2), (3);
INSERT INTO t2 VALUES (2), (1), (3), (2);

-- If t1=t2 (meaning they are the same bag/multiset), then the following should return nothing.

-- Sanity check: do they contain the same *set* of elements (ignoring duplicates)?

SELECT * FROM t1 EXCEPT SELECT * FROM t2;
SELECT * FROM t2 EXCEPT SELECT * FROM t1;

-- Now compare the moments/power sums

CREATE TABLE t1_moments AS

WITH RECURSIVE r1 AS (
  -- First iteration, return t1 as-is
  SELECT 1 AS i, t1.*
    FROM t1

  UNION ALL

  -- Iterations i+1 joins together i+1 copies of t1
  SELECT r1.i + 1 AS i, t1.*
    FROM r1 NATURAL JOIN t1
  -- We could have stopped at |t1| (number of distinct elements in t1)
   WHERE i < (SELECT COUNT(*) FROM t1)
)

-- Compute the power sum with COUNT
SELECT COUNT(*) FROM r1 GROUP BY i;


-- Repeat for the other table...
CREATE TABLE t2_moments AS

WITH RECURSIVE r2 AS (
  SELECT 1 AS i, t2.*
    FROM t2

  UNION ALL

  SELECT r2.i + 1 AS i, t2.*
    FROM r2 NATURAL JOIN t2
   WHERE i < (SELECT COUNT(*) FROM t2)
)

SELECT COUNT(*) FROM r2 GROUP BY i;

SELECT * FROM t1_moments EXCEPT SELECT * FROM t2_moments;
SELECT * FROM t2_moments EXCEPT SELECT * FROM t1_moments;

-- To rule out the case where they have the same moments, but are "permutations" of each other
SELECT (SELECT COUNT(*) FROM t1 NATURAL JOIN t1) - (SELECT COUNT(*) FROM t1 NATURAL JOIN t2) AS d WHERE d <> 0;
SELECT (SELECT COUNT(*) FROM t2 NATURAL JOIN t2) - (SELECT COUNT(*) FROM t1 NATURAL JOIN t2) AS d WHERE d <> 0;

