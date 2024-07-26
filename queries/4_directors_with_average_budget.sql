SELECT 
    p.id,
    p.first_name || ' ' || p.last_name AS "director name",
    ROUND(AVG(m.budget)) AS "average budget"
FROM person p
JOIN movie m ON p.id = m.director_id
GROUP BY p.id, p.first_name, p.last_name;