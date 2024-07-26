SELECT 
    u.id,
    u.username,
    COALESCE(ARRAY_AGG(fm.movie_id) FILTER (WHERE fm.movie_id IS NOT NULL), ARRAY[]::INT[]) AS "favorite movie IDs"
FROM "user" u
LEFT JOIN favorite_movie fm ON u.id = fm.user_id
GROUP BY u.id, u.username;