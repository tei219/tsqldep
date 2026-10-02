-- EXPECT: C=; R=B; U=A; D=
UPDATE A
SET x = (
    SELECT B.x
    FROM B
    WHERE B.id = A.id
);
