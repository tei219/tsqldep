-- EXPECT: C=; R=A,B; U=; D=
SELECT *
FROM A
JOIN B ON B.id = A.id;
