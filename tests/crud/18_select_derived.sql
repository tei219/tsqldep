-- EXPECT: C=; R=A,B; U=; D=
SELECT *
FROM (
    SELECT *
    FROM A
) AS D
JOIN B ON B.id = D.id;
