-- EXPECT: C=; R=B; U=; D=A;
DELETE FROM A
WHERE EXISTS (
    SELECT 1
    FROM B
    WHERE B.id = A.id
);
