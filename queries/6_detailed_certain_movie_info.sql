SELECT 
    m.id,
    m.title,
    m.release_date,
    m.duration,
    m.description,
    CASE 
        WHEN f.id IS NOT NULL THEN
            json_build_object(
                'id', f.id,
                'file_name', f.file_name,
                'mime_type', f.mime_type,
                'file_key', f.file_key,
                'file_url', f.file_url
            )
        ELSE NULL
    END AS "poster",
    json_build_object(
        'id', p.id,
        'first_name', p.first_name,
        'last_name', p.last_name,
        'photo', (
            SELECT json_build_object(
                'id', pf.id,
                'file_name', pf.file_name,
                'mime_type', pf.mime_type,
                'file_key', pf.file_key,
                'file_url', pf.file_url
            )
            FROM file pf
            JOIN person_file ppf ON pf.id = ppf.file_id
            WHERE ppf.person_id = p.id AND ppf.is_primary = TRUE
        )
    ) AS "director",
    (SELECT json_agg(json_build_object(
        'id', pa.id,
        'first_name', pa.first_name,
        'last_name', pa.last_name,
        'photo', (
            SELECT json_build_object(
                'id', pf.id,
                'file_name', pf.file_name,
                'mime_type', pf.mime_type,
                'file_key', pf.file_key,
                'file_url', pf.file_url
            )
            FROM file pf
            JOIN person_file ppf ON pf.id = ppf.file_id
            WHERE ppf.person_id = pa.id AND ppf.is_primary = TRUE
        )
    ))
    FROM person pa
    JOIN movie_character_actor mca ON pa.id = mca.actor_id
    WHERE mca.movie_id = m.id
    ) AS "actors",
    (SELECT json_agg(json_build_object(
        'id', g.id,
        'name', g.name
    ))
    FROM genre g
    JOIN movie_genre mg ON g.id = mg.genre_id
    WHERE mg.movie_id = m.id
    ) AS "genres"
FROM movie m
JOIN person p ON m.director_id = p.id
LEFT JOIN file f ON m.poster_id = f.id
WHERE m.id = 9;
