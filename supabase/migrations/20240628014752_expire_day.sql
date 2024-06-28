CREATE OR REPLACE FUNCTION shorten_url(_original TEXT) RETURNS TEXT AS $$
DECLARE
    short_code TEXT;
BEGIN
    DELETE FROM urls WHERE created_at < NOW() - INTERVAL '7 days';

    short_code := generate_short_code();
    INSERT INTO urls (original_url, short_code) VALUES (_original, short_code);
    RETURN short_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER ;