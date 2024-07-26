SELECT 
    m.id,
    m.title,
    m.release_date,
    m.duration,
    m.description,
    COALESCE(
    (
        SELECT jsonb_build_object(
            'id', f.id,
            'file_name', f.file_name,
            'mime_type', f.mime_type,
            'file_key', f.file_key,
            'file_url', f.file_url
        )
        FROM file f
        WHERE f.id = m.poster_id
    ), 'null'::jsonb
    ) AS "poster",
    jsonb_build_object(
        'id', p.id,
        'first_name', p.first_name,
        'last_name', p.last_name
    ) AS "director"
FROM movie m
LEFT JOIN file f ON m.poster_id = f.id
LEFT JOIN person p ON m.director_id = p.id
WHERE 
    m.country_id = 9
    AND m.release_date >= '2022-01-01'
    AND m.duration > 2 * 60 + 15
    AND EXISTS (
        SELECT 1
        FROM movie_genre mg
        JOIN genre g ON mg.genre_id = g.id
        WHERE mg.movie_id = m.id
        AND g.name IN ('Action', 'Drama')
    );