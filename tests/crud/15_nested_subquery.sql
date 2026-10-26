-- EXPECT: C=; R=A,B,C; U=; D=
SELECT *
FROM A
WHERE A.id IN (
    SELECT B.id
    FROM B
    WHERE B.id IN (
        SELECT C.id
        FROM C
    )
);
