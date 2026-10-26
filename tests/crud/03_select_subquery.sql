-- EXPECT: C=; R=A,B; U=; D=
SELECT *
FROM A
WHERE A.id IN (
    SELECT B.id
    FROM B
);
