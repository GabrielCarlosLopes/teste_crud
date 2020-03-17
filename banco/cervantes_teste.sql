--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: deletecadastro(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.deletecadastro(_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	delete from cadastro
	where id = _id;
	if found then 
		return 1;
	else 
		return 0;
	end if;
end
$$;


ALTER FUNCTION public.deletecadastro(_id integer) OWNER TO postgres;

--
-- Name: insertcadastro(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertcadastro(descricao character varying, num integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	insert into cadastro(descricao, num)
	values(descricao, num);
	if (num < 1)then
	return 0;
	else 
	return 1;
	
	end if;
end
$$;


ALTER FUNCTION public.insertcadastro(descricao character varying, num integer) OWNER TO postgres;

--
-- Name: logfunc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.logfunc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF (TG_OP = 'INSERT') THEN
      INSERT INTO log(operation, data, id_cadastro) VALUES ('insert', current_timestamp, new.id);
   ELSEIF(TG_OP = 'UPDATE') THEN
   	  INSERT INTO log(operation, data, id_cadastro) VALUES ('update', current_timestamp, new.id);
   ELSEIF(TG_OP = 'DELETE') THEN
      INSERT INTO log(operation, data, id_cadastro, isdeleted) VALUES ('delete', current_timestamp, old.id, 1);
   END IF;
	  RETURN NEW;
   END;
   $$;


ALTER FUNCTION public.logfunc() OWNER TO postgres;

--
-- Name: selectcadastro(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.selectcadastro() RETURNS TABLE(idcadastro integer, "descrição" character varying, "numérico" integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select id, descricao, num from Cadastro order by id;
end
$$;


ALTER FUNCTION public.selectcadastro() OWNER TO postgres;

--
-- Name: updatecadastro(integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.updatecadastro(idnew integer, descricaonew character varying, numnew integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	update cadastro
	set 
		id = idnew,
		descricao = descricaonew,
		num = numnew
	where id = idnew;
	if (numnew < 1) then
		return 0;
	else return 1;
	end if;
end
$$;


ALTER FUNCTION public.updatecadastro(idnew integer, descricaonew character varying, numnew integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cadastro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cadastro (
    id integer NOT NULL,
    descricao character varying(100) NOT NULL,
    num integer NOT NULL
);


ALTER TABLE public.cadastro OWNER TO postgres;

--
-- Name: cadastro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cadastro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cadastro_id_seq OWNER TO postgres;

--
-- Name: cadastro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cadastro_id_seq OWNED BY public.cadastro.id;


--
-- Name: log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log (
    id integer NOT NULL,
    operation text NOT NULL,
    data text NOT NULL,
    isdeleted integer DEFAULT 0,
    id_cadastro integer
);


ALTER TABLE public.log OWNER TO postgres;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_id_seq OWNER TO postgres;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_id_seq OWNED BY public.log.id;


--
-- Name: cadastro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastro ALTER COLUMN id SET DEFAULT nextval('public.cadastro_id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: cadastro cadastro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastro
    ADD CONSTRAINT cadastro_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: cadastro logcontrollerdelete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logcontrollerdelete AFTER DELETE ON public.cadastro FOR EACH ROW EXECUTE FUNCTION public.logfunc();


--
-- Name: cadastro logcontrollerinsert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logcontrollerinsert AFTER INSERT ON public.cadastro FOR EACH ROW EXECUTE FUNCTION public.logfunc();


--
-- Name: cadastro logcontrollerupdate; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER logcontrollerupdate AFTER UPDATE ON public.cadastro FOR EACH ROW EXECUTE FUNCTION public.logfunc();


--
-- PostgreSQL database dump complete
--

