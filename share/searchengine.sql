--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.sitewords DROP CONSTRAINT sitewords_id_site_fkey;
ALTER TABLE ONLY public.sitewords DROP CONSTRAINT sitewords_id_keyword_fkey;
ALTER TABLE ONLY public.linksto DROP CONSTRAINT linksto_id_to_fkey;
ALTER TABLE ONLY public.linksto DROP CONSTRAINT linksto_id_from_fkey;
DROP INDEX public.websites_spamminess_key;
DROP INDEX public.websites_failed_key;
DROP INDEX public.websites_authority_key;
DROP INDEX public.sitewords_ratio_key;
DROP INDEX public.sitewords_id_site_key;
DROP INDEX public.sitewords_id_keyword_site_key;
DROP INDEX public.sitewords_id_keyword_key;
DROP INDEX public.sitewords_count_key;
DROP INDEX public.linksto_id_to_key;
DROP INDEX public.linksto_id_from_to_key;
DROP INDEX public.linksto_id_from_key;
ALTER TABLE ONLY public.websites DROP CONSTRAINT websites_url_key;
ALTER TABLE ONLY public.websites DROP CONSTRAINT websites_pkey;
ALTER TABLE ONLY public.sitewords DROP CONSTRAINT sitewords_pkey;
ALTER TABLE ONLY public.linksto DROP CONSTRAINT linksto_pkey;
ALTER TABLE ONLY public.keywords DROP CONSTRAINT keywords_word_key;
ALTER TABLE ONLY public.keywords DROP CONSTRAINT keywords_pkey;
ALTER TABLE ONLY public.authinfo DROP CONSTRAINT authinfo_pkey;
ALTER TABLE public.websites ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.sitewords ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.linksto ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.keywords ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.authinfo ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.websites_id_seq;
DROP SEQUENCE public.sitewords_id_seq;
DROP SEQUENCE public.linksto_id_seq;
DROP SEQUENCE public.keywords_id_seq;
DROP SEQUENCE public.authinfo_id_seq;
DROP TABLE public.websites;
DROP TABLE public.sitewords;
DROP TABLE public.linksto;
DROP TABLE public.keywords;
DROP TABLE public.authinfo;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pgsql
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pgsql;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pgsql
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authinfo; Type: TABLE; Schema: public; Author: caoimhe; Tablespace:
--

CREATE TABLE authinfo (
    id bigint NOT NULL,
    url character varying(1024) NOT NULL,
    userid character varying(64) NOT NULL,
    password character varying(64) NOT NULL,
    realm character varying(256),
    userparm character varying(64),
    passparm character varying(64)
);


--
-- Name: keywords; Type: TABLE; Schema: public; Author: caoimhe; Tablespace:
--

CREATE TABLE keywords (
    id bigint NOT NULL,
    word text NOT NULL
);


--
-- Name: linksto; Type: TABLE; Schema: public; Author: caoimhe; Tablespace:
--

CREATE TABLE linksto (
    id bigint NOT NULL,
    id_from bigint NOT NULL,
    id_to bigint NOT NULL
);


--
-- Name: sitewords; Type: TABLE; Schema: public; Author: caoimhe; Tablespace:
--

CREATE TABLE sitewords (
    id bigint NOT NULL,
    id_site bigint NOT NULL,
    id_keyword bigint NOT NULL,
    count bigint NOT NULL,
    ratio integer NOT NULL
);


--
-- Name: websites; Type: TABLE; Schema: public; Author: caoimhe; Tablespace:
--

CREATE TABLE websites (
    id bigint NOT NULL,
    url character varying(1024) NOT NULL,
    title character varying(1024),
    abstract text,
    lastindex timestamp with time zone,
    failed boolean DEFAULT false NOT NULL,
    authority bigint DEFAULT 0 NOT NULL,
    spamminess bigint
);


--
-- Name: authinfo_id_seq; Type: SEQUENCE; Schema: public; Author: caoimhe
--

CREATE SEQUENCE authinfo_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: authinfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Author: caoimhe
--

ALTER SEQUENCE authinfo_id_seq OWNED BY authinfo.id;


--
-- Name: keywords_id_seq; Type: SEQUENCE; Schema: public; Author: caoimhe
--

CREATE SEQUENCE keywords_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: keywords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Author: caoimhe
--

ALTER SEQUENCE keywords_id_seq OWNED BY keywords.id;


--
-- Name: linksto_id_seq; Type: SEQUENCE; Schema: public; Author: caoimhe
--

CREATE SEQUENCE linksto_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: linksto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Author: caoimhe
--

ALTER SEQUENCE linksto_id_seq OWNED BY linksto.id;


--
-- Name: sitewords_id_seq; Type: SEQUENCE; Schema: public; Author: caoimhe
--

CREATE SEQUENCE sitewords_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sitewords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Author: caoimhe
--

ALTER SEQUENCE sitewords_id_seq OWNED BY sitewords.id;


--
-- Name: websites_id_seq; Type: SEQUENCE; Schema: public; Author: caoimhe
--

CREATE SEQUENCE websites_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Author: caoimhe
--

ALTER SEQUENCE websites_id_seq OWNED BY websites.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Author: caoimhe
--

ALTER TABLE authinfo ALTER COLUMN id SET DEFAULT nextval('authinfo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Author: caoimhe
--

ALTER TABLE keywords ALTER COLUMN id SET DEFAULT nextval('keywords_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Author: caoimhe
--

ALTER TABLE linksto ALTER COLUMN id SET DEFAULT nextval('linksto_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Author: caoimhe
--

ALTER TABLE sitewords ALTER COLUMN id SET DEFAULT nextval('sitewords_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Author: caoimhe
--

ALTER TABLE websites ALTER COLUMN id SET DEFAULT nextval('websites_id_seq'::regclass);


--
-- Name: authinfo_pkey; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY authinfo
    ADD CONSTRAINT authinfo_pkey PRIMARY KEY (id);


--
-- Name: keywords_pkey; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY keywords
    ADD CONSTRAINT keywords_pkey PRIMARY KEY (id);


--
-- Name: keywords_word_key; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY keywords
    ADD CONSTRAINT keywords_word_key UNIQUE (word);


--
-- Name: linksto_pkey; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY linksto
    ADD CONSTRAINT linksto_pkey PRIMARY KEY (id);


--
-- Name: sitewords_pkey; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY sitewords
    ADD CONSTRAINT sitewords_pkey PRIMARY KEY (id);


--
-- Name: websites_pkey; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY websites
    ADD CONSTRAINT websites_pkey PRIMARY KEY (id);


--
-- Name: websites_url_key; Type: CONSTRAINT; Schema: public; Author: caoimhe; Tablespace:
--

ALTER TABLE ONLY websites
    ADD CONSTRAINT websites_url_key UNIQUE (url);


--
-- Name: linksto_id_from_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX linksto_id_from_key ON linksto USING btree (id_from);


--
-- Name: linksto_id_from_to_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE UNIQUE INDEX linksto_id_from_to_key ON linksto USING btree (id_from, id_to);


--
-- Name: linksto_id_to_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX linksto_id_to_key ON linksto USING btree (id_to);


--
-- Name: sitewords_count_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX sitewords_count_key ON sitewords USING btree (count);


--
-- Name: sitewords_id_keyword_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX sitewords_id_keyword_key ON sitewords USING btree (id_keyword);


--
-- Name: sitewords_id_keyword_site_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX sitewords_id_keyword_site_key ON sitewords USING btree (id_keyword, id_site);


--
-- Name: sitewords_id_site_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX sitewords_id_site_key ON sitewords USING btree (id_site);


--
-- Name: sitewords_ratio_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX sitewords_ratio_key ON sitewords USING btree (ratio);


--
-- Name: websites_authority_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX websites_authority_key ON websites USING btree (authority);


--
-- Name: websites_failed_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX websites_failed_key ON websites USING btree (failed);


--
-- Name: websites_spamminess_key; Type: INDEX; Schema: public; Author: caoimhe; Tablespace:
--

CREATE INDEX websites_spamminess_key ON websites USING btree (spamminess);


--
-- Name: linksto_id_from_fkey; Type: FK CONSTRAINT; Schema: public; Author: caoimhe
--

ALTER TABLE ONLY linksto
    ADD CONSTRAINT linksto_id_from_fkey FOREIGN KEY (id_from) REFERENCES websites(id) ON DELETE CASCADE;


--
-- Name: linksto_id_to_fkey; Type: FK CONSTRAINT; Schema: public; Author: caoimhe
--

ALTER TABLE ONLY linksto
    ADD CONSTRAINT linksto_id_to_fkey FOREIGN KEY (id_to) REFERENCES websites(id) ON DELETE CASCADE;


--
-- Name: sitewords_id_keyword_fkey; Type: FK CONSTRAINT; Schema: public; Author: caoimhe
--

ALTER TABLE ONLY sitewords
    ADD CONSTRAINT sitewords_id_keyword_fkey FOREIGN KEY (id_keyword) REFERENCES keywords(id);


--
-- Name: sitewords_id_site_fkey; Type: FK CONSTRAINT; Schema: public; Author: caoimhe
--

ALTER TABLE ONLY sitewords
    ADD CONSTRAINT sitewords_id_site_fkey FOREIGN KEY (id_site) REFERENCES websites(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: authinfo; Type: ACL; Schema: public; Author: caoimhe
--

REVOKE ALL ON TABLE authinfo FROM PUBLIC;
GRANT SELECT ON TABLE authinfo TO www;
GRANT SELECT ON TABLE authinfo TO _httpd;


--
-- Name: keywords; Type: ACL; Schema: public; Author: caoimhe
--

REVOKE ALL ON TABLE keywords FROM PUBLIC;
GRANT SELECT ON TABLE keywords TO www;
GRANT SELECT ON TABLE keywords TO _httpd;


--
-- Name: linksto; Type: ACL; Schema: public; Author: caoimhe
--

REVOKE ALL ON TABLE linksto FROM PUBLIC;
GRANT SELECT ON TABLE linksto TO www;
GRANT SELECT ON TABLE linksto TO _httpd;


--
-- Name: sitewords; Type: ACL; Schema: public; Author: caoimhe
--

REVOKE ALL ON TABLE sitewords FROM PUBLIC;
GRANT SELECT ON TABLE sitewords TO www;
GRANT SELECT ON TABLE sitewords TO _httpd;


--
-- Name: websites; Type: ACL; Schema: public; Author: caoimhe
--

REVOKE ALL ON TABLE websites FROM PUBLIC;
GRANT SELECT ON TABLE websites TO www;
GRANT SELECT ON TABLE websites TO _httpd;


--
-- PostgreSQL database dump complete
--
