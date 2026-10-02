-- EXPECT: C=; R=B; U=; D=A;
DELETE A
FROM A
JOIN B ON B.id = A.id;
