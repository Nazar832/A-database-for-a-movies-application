SELECT 
    m.id,
    m.title,
    COUNT(mca.actor_id) AS "actors count"
FROM movie m
LEFT JOIN movie_character_actor mca ON m.id = mca.movie_id
WHERE m.release_date >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY m.id, m.title;