SELECT 
    p.id,
    p.first_name,
    p.last_name,
    COALESCE(SUM(m.budget), 0) AS "total movies budget"
FROM person p
LEFT JOIN movie_character_actor mca ON p.id = mca.actor_id
LEFT JOIN movie m ON mca.movie_id = m.id
GROUP BY p.id, p.first_name, p.last_name;