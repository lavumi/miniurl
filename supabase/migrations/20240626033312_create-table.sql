CREATE TABLE urls (
                      id SERIAL PRIMARY KEY,
                      original_url TEXT NOT NULL,
                      short_code TEXT NOT NULL UNIQUE,
                      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE urls ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION generate_short_code() RETURNS TEXT AS $$
DECLARE
    code TEXT;
BEGIN
    code := substring(md5(random()::text), 1, 6);
    RETURN code;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION shorten_url(_original TEXT) RETURNS TEXT AS $$
DECLARE
    short_code TEXT;
BEGIN
    short_code := generate_short_code();
    INSERT INTO urls (original_url, short_code) VALUES (_original, short_code);
    RETURN short_code;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER ;



create or replace function get_url(code text) returns text as $$
declare
    original text;
begin
    select original_url into original from urls where short_code = code;
    return original;
end;
$$ language plpgsql SECURITY DEFINER ;

grant execute  on function get_url to public;
grant execute  on function shorten_url to public;