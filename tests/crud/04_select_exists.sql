-- EXPECT: C=; R=A,B; U=; D=
SELECT *
FROM A
WHERE EXISTS (
    SELECT 1
    FROM B
    WHERE B.id = A.id
);
