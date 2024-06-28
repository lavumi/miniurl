CREATE OR REPLACE FUNCTION is_valid_url(url TEXT) RETURNS BOOLEAN AS $$
DECLARE
    pattern TEXT := '^https?://([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(/[^ ]*)?$';
BEGIN
    RETURN url ~ pattern;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION shorten_url(_original TEXT) RETURNS TEXT AS $$
DECLARE
    short_code TEXT;
BEGIN

    IF NOT is_valid_url(_original) THEN
        RETURN 'invalid url';
    END IF;

    short_code := generate_short_code();
    INSERT INTO urls (original_url, short_code) VALUES (_original, short_code);
    RETURN short_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER ;