-- EXPECT: C=; R=B; U=A; D=
UPDATE A
SET x = B.x
FROM A
JOIN B ON B.id = A.id;
