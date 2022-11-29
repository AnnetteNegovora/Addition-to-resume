--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 14.0

-- Started on 2021-12-28 18:35:48 MSK

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
-- TOC entry 3341 (class 1262 OID 82217)
-- Name: visa; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE visa WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';


ALTER DATABASE visa OWNER TO postgres;

\connect visa

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
-- TOC entry 210 (class 1255 OID 106607)
-- Name: form_application(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.form_application() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
IF NEW.tipo_visto = 

'C' THEN INSERT INTO tipo_C(app_no) VALUES (NEW.app_no);
END IF; IF NEW.tipo_visto = 'D' THEN INSERT INTO tipo_d(app_no) VALUES(NEW.app_no);
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.form_application() OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 106590)
-- Name: new_pair(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.new_pair() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO applicant_operator(app_no, visit_date)
 VALUES (NEW.app_no, NEW.visit_date);
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.new_pair() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 200 (class 1259 OID 90405)
-- Name: applicant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant (
    surname text NOT NULL,
    name text NOT NULL,
    second_name text,
    rp_id character(10) NOT NULL,
    fp_id character(9) NOT NULL,
    teleph character varying(15) NOT NULL,
    mail character varying(30),
    tipo_visto character(1) NOT NULL,
    app_no character varying(15) NOT NULL,
    form_date_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    visit_date timestamp without time zone NOT NULL,
    CONSTRAINT applicant_check CHECK ((visit_date > form_date_time)),
    CONSTRAINT applicant_fp_id_check CHECK ((char_length(fp_id) = 9)),
    CONSTRAINT applicant_rp_id_check CHECK ((char_length(rp_id) = 10)),
    CONSTRAINT applicant_tipo_visto_check CHECK ((tipo_visto = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))
);


ALTER TABLE public.applicant OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 98419)
-- Name: applicant_operator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_operator (
    app_no character varying(15) NOT NULL,
    visit_date timestamp without time zone NOT NULL,
    operator_id character varying(6) DEFAULT NULL::character varying
);


ALTER TABLE public.applicant_operator OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 98383)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_code integer NOT NULL,
    addres text NOT NULL,
    postal_code integer NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 90444)
-- Name: foreign_passoporto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foreign_passoporto (
    surname text NOT NULL,
    name text NOT NULL,
    second_name text,
    fp_id character(9) NOT NULL,
    date_birth date NOT NULL,
    date_issued_fp date,
    date_till_fp date,
    CONSTRAINT foreign_passoporto_check CHECK (((date_part('year'::text, age((date_till_fp)::timestamp with time zone, (date_issued_fp)::timestamp with time zone)) = (5)::double precision) OR (date_part('year'::text, age((date_till_fp)::timestamp with time zone, (date_issued_fp)::timestamp with time zone)) = (10)::double precision))),
    CONSTRAINT foreign_passoporto_fp_id_check CHECK ((char_length(fp_id) = 9)),
    CONSTRAINT validity_check CHECK ((date_till_fp > CURRENT_DATE))
);


ALTER TABLE public.foreign_passoporto OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 98374)
-- Name: operators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.operators (
    surname text NOT NULL,
    name text NOT NULL,
    operator_id character varying(6) NOT NULL,
    date_birth_operator date NOT NULL,
    education text NOT NULL,
    date_work_since date NOT NULL,
    department integer,
    amount integer,
    CONSTRAINT operators_operator_id_check CHECK ((char_length((operator_id)::text) = 6))
);


ALTER TABLE public.operators OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 90418)
-- Name: passoporto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passoporto (
    surname text NOT NULL,
    name text NOT NULL,
    second_name text,
    sex character(1) NOT NULL,
    rp_id character(10) NOT NULL,
    date_birth date NOT NULL,
    date_issued date NOT NULL,
    code character(6) NOT NULL,
    department_issuance text NOT NULL,
    place_birth text NOT NULL,
    CONSTRAINT passoporto_check CHECK ((date_issued > date_birth)),
    CONSTRAINT passoporto_code_check CHECK ((char_length(code) = 5)),
    CONSTRAINT passoporto_date_birth_check CHECK ((date_part('year'::text, age((CURRENT_DATE)::timestamp with time zone, (date_birth)::timestamp with time zone)) >= (18)::double precision)),
    CONSTRAINT passoporto_rp_id_check CHECK ((char_length(rp_id) = 10)),
    CONSTRAINT passoporto_sex_check CHECK ((sex = ANY (ARRAY['М'::bpchar, 'Ж'::bpchar])))
);


ALTER TABLE public.passoporto OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 106564)
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    region_no character(2) NOT NULL,
    central_city text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 98459)
-- Name: tipo_c; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_c (
    status text,
    app_no character varying(15) NOT NULL,
    bilet_no character varying(15),
    sum_schet_euro integer,
    avg_salary integer,
    avg_salary_relative integer,
    quitation_no text,
    region_first_stay character(2),
    days_of_stay integer
);


ALTER TABLE public.tipo_c OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 98470)
-- Name: tipo_d; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_d (
    status text,
    app_no character varying(15) NOT NULL,
    bilet_no character varying(15),
    sum_schet_euro integer,
    avg_salary integer,
    avg_salary_relative integer,
    quitation_no character varying(15),
    region_first_stay numeric,
    university text,
    days_stay integer,
    reason character(20),
    CONSTRAINT tipo_d_days_stay_check CHECK ((days_stay > 90))
);


ALTER TABLE public.tipo_d OWNER TO postgres;

--
-- TOC entry 3327 (class 0 OID 90405)
-- Dependencies: 200
-- Data for Name: applicant; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.applicant VALUES ('Григорьев', 'Никита', 'Олегович', '4515607707', '534501240', '+79082101321', 'n.grigorieff@gmail.com', 'C', '01.00304.3981', '2021-11-19 00:00:00', '2021-11-25 00:00:00');
INSERT INTO public.applicant VALUES ('Вознесенская', 'Арина', 'Александровна', '4515776010', '529895221', '+79618677904', 'voznesenskaya.ar@gmail.it', 'C', '12.09021.8705', '2021-05-23 00:00:00', '2021-06-13 00:00:00');
INSERT INTO public.applicant VALUES ('Грей', 'Мередит', NULL, '4515823485', '536798732', '+36837404331', 'mer.grey@sg.com', 'D', '13.97382.0978', '2021-02-13 00:00:00', '2021-02-19 00:00:00');
INSERT INTO public.applicant VALUES ('Воронов', 'Владислав', 'Николаевич', '4515232109', '532186540', '+76045604331', 'voronov.v@gmail.it', 'D', '01.02102.3406', '2021-08-18 00:00:00', '2021-09-01 00:00:00');
INSERT INTO public.applicant VALUES ('Семенова', 'Валерия', 'Андреевна', '4515098423', '530176301', '+79093995447', 'semenova.v@gmail.it', 'D', '01.32987.0107', '2021-12-12 00:00:00', '2021-12-29 00:00:00');
INSERT INTO public.applicant VALUES ('Lubimov', 'Alexey', 'Alexandrovich', '4515828040', '539098475', '+79368472663', 'lubimov.alex@mail.ru', 'C', '12.230.3920', '2021-12-01 00:00:00', '2021-12-31 00:00:00');


--
-- TOC entry 3332 (class 0 OID 98419)
-- Dependencies: 205
-- Data for Name: applicant_operator; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.applicant_operator VALUES ('01.02102.3406', '2021-09-01 00:00:00', '213789');
INSERT INTO public.applicant_operator VALUES ('01.00304.3981', '2021-11-25 00:00:00', '300001');
INSERT INTO public.applicant_operator VALUES ('01.32987.0107', '2021-12-29 00:00:00', NULL);
INSERT INTO public.applicant_operator VALUES ('12.09021.8705', '2021-06-13 00:00:00', '120501');
INSERT INTO public.applicant_operator VALUES ('13.97382.0978', '2021-02-19 00:00:00', '300001');
INSERT INTO public.applicant_operator VALUES ('12.230.3920', '2021-12-31 00:00:00', NULL);
INSERT INTO public.applicant_operator VALUES ('12.230.3920', '2021-12-31 00:00:00', NULL);


--
-- TOC entry 3331 (class 0 OID 98383)
-- Dependencies: 204
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departments VALUES (3, 'Санкт-Петербург, ул. Казанская, 1/25', 191186);
INSERT INTO public.departments VALUES (1, 'Москва, М. Толмачевский пер., д. 6, стр.1', 119017);
INSERT INTO public.departments VALUES (2, 'Москва, ул. Киевская, вл. 2', 188302);


--
-- TOC entry 3329 (class 0 OID 90444)
-- Dependencies: 202
-- Data for Name: foreign_passoporto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.foreign_passoporto VALUES ('Voronov', 'Vladislav', 'Nikolaevich', '532186540', '1995-03-04', '2015-01-20', '2025-01-20');
INSERT INTO public.foreign_passoporto VALUES ('Grigorev', 'Nikita', 'Olegovich', '534501240', '2002-04-19', '2018-09-10', '2023-09-10');
INSERT INTO public.foreign_passoporto VALUES ('Voznesenskaya', 'Arina', 'Aleksandrovna', '529895221', '1999-07-09', '2013-04-07', '2023-04-07');
INSERT INTO public.foreign_passoporto VALUES ('Grey', 'Meredith', NULL, '536798732', '2001-09-12', '2013-12-12', '2023-12-12');
INSERT INTO public.foreign_passoporto VALUES ('Semenova', 'Valeria', 'Andreevna', '530176301', '1981-11-18', '2017-03-24', '2022-03-24');


--
-- TOC entry 3330 (class 0 OID 98374)
-- Dependencies: 203
-- Data for Name: operators; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.operators VALUES ('Bakova', 'Olga', '213789', '1991-08-02', 'International Relationship Faculty of MSU', '2015-04-27', 2, 95000);
INSERT INTO public.operators VALUES ('Allesio', 'Luca', '120501', '1981-02-28', 'International Relationship Faculty of MGIMO', '2002-05-08', 1, 120000);
INSERT INTO public.operators VALUES ('Damiano', 'David', '300001', '1993-10-14', 'International Relationship Faculty of UNIMI', '2018-02-10', 3, 105001);


--
-- TOC entry 3328 (class 0 OID 90418)
-- Dependencies: 201
-- Data for Name: passoporto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.passoporto VALUES ('Воронов', 'Владислав', 'Николаевич', 'М', '4515232109', '1995-03-04', '2015-05-18', '77000 ', 'МВД РОССИИ ПО Г КАЛИНИНГРАД', 'Калиниград');
INSERT INTO public.passoporto VALUES ('Григорьев', 'Никита', 'Олегович', 'М', '4515607707', '2002-04-19', '2016-05-04', '77700 ', 'ГУ МВД РОССИИ ПО Г МОСКВЕ Р-Н ЮЖНОПОРТОВЫЙ', 'Москва');
INSERT INTO public.passoporto VALUES ('Семенова', 'Валерия', 'Андреевна', 'Ж', '4515098423', '1981-11-18', '2001-12-22', '34200 ', 'ГУ МВД РОССИИ ПО Г ПЕРМЬ', 'Перемь');
INSERT INTO public.passoporto VALUES ('Вознесенская', 'Арина', 'Александровна', 'Ж', '4515776010', '1999-07-09', '2019-08-11', '02601 ', 'ГУ МВД РОССИИ ПО Г РОСТОВ-НА-ДОНУ', 'Ростов-на-Дону');
INSERT INTO public.passoporto VALUES ('Грей', 'Мередит', NULL, 'Ж', '4515823485', '2001-09-12', '2021-10-13', '08001 ', 'ООФМС РОССИИ ПО РЕСПУБЛИКЕ КАЛМЫКИЯ И АСТРАХАНСКОЙ ОБЛАСТИ', 'Элиста');


--
-- TOC entry 3335 (class 0 OID 106564)
-- Dependencies: 208
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.regions VALUES ('1 ', 'Abruzzo', 'LAquila');
INSERT INTO public.regions VALUES ('2 ', 'Aosta Valley', 'Aosta');
INSERT INTO public.regions VALUES ('3 ', 'Apulia', 'Bari');
INSERT INTO public.regions VALUES ('4 ', 'Basilicata', 'Potenza');
INSERT INTO public.regions VALUES ('5 ', 'Calabria', 'Catanzaro');
INSERT INTO public.regions VALUES ('6 ', 'Campania', 'Naples');
INSERT INTO public.regions VALUES ('7 ', 'Emilia-Romagna', 'Bologna');
INSERT INTO public.regions VALUES ('8 ', 'Friuli-Venezia Giulia', 'Trieste');
INSERT INTO public.regions VALUES ('9 ', 'Lazio', 'Rome');
INSERT INTO public.regions VALUES ('10', 'Liguria', 'Genoa');
INSERT INTO public.regions VALUES ('11', 'Lombardy', 'Milan');
INSERT INTO public.regions VALUES ('12', 'Marche', 'Ancona');
INSERT INTO public.regions VALUES ('13', 'Molise', 'Campobasso');
INSERT INTO public.regions VALUES ('14', 'Piedmont', 'Turin');
INSERT INTO public.regions VALUES ('15', 'Sardinia', 'Cagliari');
INSERT INTO public.regions VALUES ('16', 'Sicily', 'Palermo');
INSERT INTO public.regions VALUES ('17', 'Tuscany', 'Florence');
INSERT INTO public.regions VALUES ('18', 'Trentino-Alto Adige/Südtirol', 'Trento');
INSERT INTO public.regions VALUES ('19', 'Umbria', 'Perugia');
INSERT INTO public.regions VALUES ('20', 'Veneto', 'Venice');


--
-- TOC entry 3333 (class 0 OID 98459)
-- Dependencies: 206
-- Data for Name: tipo_c; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_c VALUES ('issued', '01.00304.3981', 'AR2021HY', 3000, 0, 2000, '120.0233', '5 ', 30);
INSERT INTO public.tipo_c VALUES ('cancelled', '12.09021.8705', 'YK9201PO921', 1000, 0, 500, '928.102', '4 ', 90);
INSERT INTO public.tipo_c VALUES (NULL, '12.230.3920', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 3334 (class 0 OID 98470)
-- Dependencies: 207
-- Data for Name: tipo_d; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tipo_d VALUES ('issued', '13.97382.0978', 'UI1982GT210', 15000, 600, NULL, '128.32093', 1, 'Bocconi', 190, 'study               ');
INSERT INTO public.tipo_d VALUES ('issued', '01.02102.3406', 'AU8928PO0192', 32000, 0, 1700, '320.920382', 8, NULL, 365, 'family              ');
INSERT INTO public.tipo_d VALUES ('waiting to apply', '01.32987.0107', NULL, NULL, NULL, NULL, '392.3290', 12, NULL, 138, NULL);


--
-- TOC entry 3174 (class 2606 OID 98458)
-- Name: applicant applicant_app_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT applicant_app_no_key UNIQUE (app_no);


--
-- TOC entry 3176 (class 2606 OID 98431)
-- Name: applicant applicant_app_no_visit_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT applicant_app_no_visit_date_key UNIQUE (app_no, visit_date);


--
-- TOC entry 3178 (class 2606 OID 90417)
-- Name: applicant applicant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT applicant_pkey PRIMARY KEY (rp_id);


--
-- TOC entry 3184 (class 2606 OID 98390)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_code);


--
-- TOC entry 3182 (class 2606 OID 98382)
-- Name: operators operators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operators
    ADD CONSTRAINT operators_pkey PRIMARY KEY (operator_id);


--
-- TOC entry 3186 (class 2606 OID 106582)
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_no);


--
-- TOC entry 3180 (class 2606 OID 90443)
-- Name: applicant unique_fp; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant
    ADD CONSTRAINT unique_fp UNIQUE (fp_id);


--
-- TOC entry 3194 (class 2620 OID 106593)
-- Name: applicant applicant_to_operator; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER applicant_to_operator AFTER INSERT ON public.applicant FOR EACH ROW EXECUTE FUNCTION public.new_pair();


--
-- TOC entry 3195 (class 2620 OID 106591)
-- Name: applicant applicants_to_operators; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER applicants_to_operators AFTER INSERT ON public.applicant FOR EACH ROW EXECUTE FUNCTION public.new_pair();


--
-- TOC entry 3196 (class 2620 OID 106608)
-- Name: applicant division; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER division AFTER INSERT ON public.applicant FOR EACH ROW EXECUTE FUNCTION public.form_application();


--
-- TOC entry 3191 (class 2606 OID 98439)
-- Name: applicant_operator applicant_operator_app_no_visit_date_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_operator
    ADD CONSTRAINT applicant_operator_app_no_visit_date_fkey FOREIGN KEY (app_no, visit_date) REFERENCES public.applicant(app_no, visit_date);


--
-- TOC entry 3190 (class 2606 OID 98425)
-- Name: applicant_operator applicant_operator_operator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_operator
    ADD CONSTRAINT applicant_operator_operator_id_fkey FOREIGN KEY (operator_id) REFERENCES public.operators(operator_id);


--
-- TOC entry 3188 (class 2606 OID 90452)
-- Name: foreign_passoporto foreign_passoporto_fp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foreign_passoporto
    ADD CONSTRAINT foreign_passoporto_fp_id_fkey FOREIGN KEY (fp_id) REFERENCES public.applicant(fp_id) ON DELETE CASCADE;


--
-- TOC entry 3189 (class 2606 OID 98396)
-- Name: operators operators_department_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operators
    ADD CONSTRAINT operators_department_fkey FOREIGN KEY (department) REFERENCES public.departments(department_code) ON DELETE RESTRICT;


--
-- TOC entry 3187 (class 2606 OID 90429)
-- Name: passoporto passoporto_rp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passoporto
    ADD CONSTRAINT passoporto_rp_id_fkey FOREIGN KEY (rp_id) REFERENCES public.applicant(rp_id) ON DELETE CASCADE;


--
-- TOC entry 3192 (class 2606 OID 98465)
-- Name: tipo_c tipo_c_app_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_c
    ADD CONSTRAINT tipo_c_app_no_fkey FOREIGN KEY (app_no) REFERENCES public.applicant(app_no);


--
-- TOC entry 3193 (class 2606 OID 98477)
-- Name: tipo_d tipo_d_app_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_d
    ADD CONSTRAINT tipo_d_app_no_fkey FOREIGN KEY (app_no) REFERENCES public.applicant(app_no);


-- Completed on 2021-12-28 18:35:49 MSK

--
-- PostgreSQL database dump complete
--

