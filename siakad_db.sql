--
-- PostgreSQL database dump
--

\restrict VoI5oiORpIxw5c2lhsAfgJBBrodW82PaoGX62wAPK3wlcozoEFr6YailBfV7jSk

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-11-25 11:18:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 58854)
-- Name: dosen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dosen (
    id_dosen integer NOT NULL,
    id_user integer,
    nidn character varying(20) NOT NULL,
    nama character varying(100) NOT NULL,
    email character varying(100),
    no_hp character varying(20),
    alamat text,
    id_jurusan integer NOT NULL
);


ALTER TABLE public.dosen OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 58853)
-- Name: dosen_id_dosen_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dosen_id_dosen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dosen_id_dosen_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 223
-- Name: dosen_id_dosen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dosen_id_dosen_seq OWNED BY public.dosen.id_dosen;


--
-- TOC entry 234 (class 1259 OID 58984)
-- Name: jadwal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jadwal (
    id_jadwal integer NOT NULL,
    id_kelas integer NOT NULL,
    id_ruangan integer NOT NULL,
    hari character varying(15) NOT NULL,
    jam_mulai time without time zone NOT NULL,
    jam_selesai time without time zone NOT NULL,
    CONSTRAINT jadwal_check CHECK ((jam_selesai > jam_mulai)),
    CONSTRAINT jadwal_hari_check CHECK (((hari)::text = ANY ((ARRAY['Senin'::character varying, 'Selasa'::character varying, 'Rabu'::character varying, 'Kamis'::character varying, 'Jumat'::character varying, 'Sabtu'::character varying])::text[])))
);


ALTER TABLE public.jadwal OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 58983)
-- Name: jadwal_id_jadwal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jadwal_id_jadwal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jadwal_id_jadwal_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 233
-- Name: jadwal_id_jadwal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jadwal_id_jadwal_seq OWNED BY public.jadwal.id_jadwal;


--
-- TOC entry 222 (class 1259 OID 58840)
-- Name: jurusan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jurusan (
    id_jurusan integer NOT NULL,
    kode character varying(10) NOT NULL,
    nama_jurusan character varying(100) NOT NULL,
    jenjang character varying(5) NOT NULL,
    ketua_jurusan character varying(100),
    CONSTRAINT jurusan_jenjang_check CHECK (((jenjang)::text = ANY ((ARRAY['D3'::character varying, 'S1'::character varying])::text[])))
);


ALTER TABLE public.jurusan OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 58839)
-- Name: jurusan_id_jurusan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jurusan_id_jurusan_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jurusan_id_jurusan_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 221
-- Name: jurusan_id_jurusan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jurusan_id_jurusan_seq OWNED BY public.jurusan.id_jurusan;


--
-- TOC entry 232 (class 1259 OID 58958)
-- Name: kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kelas (
    id_kelas integer NOT NULL,
    nama_kelas character varying(10) NOT NULL,
    id_mk integer NOT NULL,
    id_dosen integer NOT NULL,
    tahun_ajaran character varying(15) NOT NULL,
    semester character varying(10) NOT NULL,
    kuota integer NOT NULL,
    CONSTRAINT kelas_kuota_check CHECK ((kuota > 0)),
    CONSTRAINT kelas_semester_check CHECK (((semester)::text = ANY ((ARRAY['ganjil'::character varying, 'genap'::character varying])::text[])))
);


ALTER TABLE public.kelas OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 58957)
-- Name: kelas_id_kelas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kelas_id_kelas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kelas_id_kelas_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 231
-- Name: kelas_id_kelas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kelas_id_kelas_seq OWNED BY public.kelas.id_kelas;


--
-- TOC entry 236 (class 1259 OID 59009)
-- Name: krs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.krs (
    id_krs integer NOT NULL,
    id_mhs integer NOT NULL,
    id_kelas integer NOT NULL,
    tahun_ajaran character varying(15) NOT NULL,
    status character varying(15) DEFAULT 'diajukan'::character varying NOT NULL,
    CONSTRAINT krs_status_check CHECK (((status)::text = ANY ((ARRAY['diajukan'::character varying, 'disetujui'::character varying, 'ditolak'::character varying])::text[])))
);


ALTER TABLE public.krs OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 59008)
-- Name: krs_id_krs_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.krs_id_krs_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.krs_id_krs_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 235
-- Name: krs_id_krs_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.krs_id_krs_seq OWNED BY public.krs.id_krs;


--
-- TOC entry 226 (class 1259 OID 58883)
-- Name: mahasiswa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mahasiswa (
    id_mhs integer NOT NULL,
    id_user integer,
    nim character varying(20) NOT NULL,
    nama character varying(100) NOT NULL,
    tgl_lahir date,
    jenis_kelamin character(1),
    alamat text,
    angkatan integer NOT NULL,
    id_jurusan integer NOT NULL,
    id_dosen_wali integer,
    status character varying(15) DEFAULT 'aktif'::character varying NOT NULL,
    CONSTRAINT mahasiswa_jenis_kelamin_check CHECK ((jenis_kelamin = ANY (ARRAY['L'::bpchar, 'P'::bpchar]))),
    CONSTRAINT mahasiswa_status_check CHECK (((status)::text = ANY ((ARRAY['aktif'::character varying, 'cuti'::character varying, 'lulus'::character varying])::text[])))
);


ALTER TABLE public.mahasiswa OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 58882)
-- Name: mahasiswa_id_mhs_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mahasiswa_id_mhs_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mahasiswa_id_mhs_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 225
-- Name: mahasiswa_id_mhs_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mahasiswa_id_mhs_seq OWNED BY public.mahasiswa.id_mhs;


--
-- TOC entry 228 (class 1259 OID 58920)
-- Name: mata_kuliah; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mata_kuliah (
    id_mk integer NOT NULL,
    kode_mk character varying(15) NOT NULL,
    nama_mk character varying(100) NOT NULL,
    sks integer NOT NULL,
    semester integer NOT NULL,
    id_jurusan integer NOT NULL,
    CONSTRAINT mata_kuliah_semester_check CHECK (((semester >= 1) AND (semester <= 8))),
    CONSTRAINT mata_kuliah_sks_check CHECK (((sks >= 1) AND (sks <= 6)))
);


ALTER TABLE public.mata_kuliah OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 58919)
-- Name: mata_kuliah_id_mk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mata_kuliah_id_mk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mata_kuliah_id_mk_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 227
-- Name: mata_kuliah_id_mk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mata_kuliah_id_mk_seq OWNED BY public.mata_kuliah.id_mk;


--
-- TOC entry 238 (class 1259 OID 59035)
-- Name: nilai; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nilai (
    id_nilai integer NOT NULL,
    id_krs integer NOT NULL,
    tugas numeric(5,2) DEFAULT 0,
    uts numeric(5,2) DEFAULT 0,
    uas numeric(5,2) DEFAULT 0,
    nilai_akhir numeric(5,2),
    nilai_huruf character varying(2),
    CONSTRAINT nilai_tugas_check CHECK (((tugas >= (0)::numeric) AND (tugas <= (100)::numeric))),
    CONSTRAINT nilai_uas_check CHECK (((uas >= (0)::numeric) AND (uas <= (100)::numeric))),
    CONSTRAINT nilai_uts_check CHECK (((uts >= (0)::numeric) AND (uts <= (100)::numeric)))
);


ALTER TABLE public.nilai OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 59034)
-- Name: nilai_id_nilai_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nilai_id_nilai_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nilai_id_nilai_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 237
-- Name: nilai_id_nilai_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nilai_id_nilai_seq OWNED BY public.nilai.id_nilai;


--
-- TOC entry 230 (class 1259 OID 58942)
-- Name: ruangan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruangan (
    id_ruangan integer NOT NULL,
    nama_ruangan character varying(50) NOT NULL,
    gedung character varying(50) NOT NULL,
    kapasitas integer NOT NULL,
    jenis character varying(10) NOT NULL,
    CONSTRAINT ruangan_jenis_check CHECK (((jenis)::text = ANY ((ARRAY['kelas'::character varying, 'lab'::character varying])::text[]))),
    CONSTRAINT ruangan_kapasitas_check CHECK ((kapasitas > 0))
);


ALTER TABLE public.ruangan OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 58941)
-- Name: ruangan_id_ruangan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ruangan_id_ruangan_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ruangan_id_ruangan_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 229
-- Name: ruangan_id_ruangan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ruangan_id_ruangan_seq OWNED BY public.ruangan.id_ruangan;


--
-- TOC entry 220 (class 1259 OID 58826)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'dosen'::character varying, 'mahasiswa'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 58825)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_user_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- TOC entry 4903 (class 2604 OID 58857)
-- Name: dosen id_dosen; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen ALTER COLUMN id_dosen SET DEFAULT nextval('public.dosen_id_dosen_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 58987)
-- Name: jadwal id_jadwal; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal ALTER COLUMN id_jadwal SET DEFAULT nextval('public.jadwal_id_jadwal_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 58843)
-- Name: jurusan id_jurusan; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan ALTER COLUMN id_jurusan SET DEFAULT nextval('public.jurusan_id_jurusan_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 58961)
-- Name: kelas id_kelas; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas ALTER COLUMN id_kelas SET DEFAULT nextval('public.kelas_id_kelas_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 59012)
-- Name: krs id_krs; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.krs ALTER COLUMN id_krs SET DEFAULT nextval('public.krs_id_krs_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 58886)
-- Name: mahasiswa id_mhs; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa ALTER COLUMN id_mhs SET DEFAULT nextval('public.mahasiswa_id_mhs_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 58923)
-- Name: mata_kuliah id_mk; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mata_kuliah ALTER COLUMN id_mk SET DEFAULT nextval('public.mata_kuliah_id_mk_seq'::regclass);


--
-- TOC entry 4912 (class 2604 OID 59038)
-- Name: nilai id_nilai; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nilai ALTER COLUMN id_nilai SET DEFAULT nextval('public.nilai_id_nilai_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 58945)
-- Name: ruangan id_ruangan; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan ALTER COLUMN id_ruangan SET DEFAULT nextval('public.ruangan_id_ruangan_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 58829)
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- TOC entry 5139 (class 0 OID 58854)
-- Dependencies: 224
-- Data for Name: dosen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dosen (id_dosen, id_user, nidn, nama, email, no_hp, alamat, id_jurusan) FROM stdin;
1	\N	1234567890	Dosen 1	dosenif1@gmail.com	081234586457	Jl. abc	1
\.


--
-- TOC entry 5149 (class 0 OID 58984)
-- Dependencies: 234
-- Data for Name: jadwal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jadwal (id_jadwal, id_kelas, id_ruangan, hari, jam_mulai, jam_selesai) FROM stdin;
1	1	4	Rabu	15:00:00	17:30:00
\.


--
-- TOC entry 5137 (class 0 OID 58840)
-- Dependencies: 222
-- Data for Name: jurusan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jurusan (id_jurusan, kode, nama_jurusan, jenjang, ketua_jurusan) FROM stdin;
1	IF	Teknik Informatika	S1	Pak X
\.


--
-- TOC entry 5147 (class 0 OID 58958)
-- Dependencies: 232
-- Data for Name: kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kelas (id_kelas, nama_kelas, id_mk, id_dosen, tahun_ajaran, semester, kuota) FROM stdin;
1	A	1	1	2026/2027	ganjil	30
\.


--
-- TOC entry 5151 (class 0 OID 59009)
-- Dependencies: 236
-- Data for Name: krs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.krs (id_krs, id_mhs, id_kelas, tahun_ajaran, status) FROM stdin;
2	3	1	2026/2027	disetujui
\.


--
-- TOC entry 5141 (class 0 OID 58883)
-- Dependencies: 226
-- Data for Name: mahasiswa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mahasiswa (id_mhs, id_user, nim, nama, tgl_lahir, jenis_kelamin, alamat, angkatan, id_jurusan, id_dosen_wali, status) FROM stdin;
3	7	5025251150	Made Joshua Ama Ede	2007-03-20	L	Jl. Arief Rahman Hakim, No. 110	2025	1	1	aktif
\.


--
-- TOC entry 5143 (class 0 OID 58920)
-- Dependencies: 228
-- Data for Name: mata_kuliah; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mata_kuliah (id_mk, kode_mk, nama_mk, sks, semester, id_jurusan) FROM stdin;
1	EF234041	Web Programming	3	3	1
\.


--
-- TOC entry 5153 (class 0 OID 59035)
-- Dependencies: 238
-- Data for Name: nilai; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nilai (id_nilai, id_krs, tugas, uts, uas, nilai_akhir, nilai_huruf) FROM stdin;
2	2	100.00	70.00	80.00	83.00	B
\.


--
-- TOC entry 5145 (class 0 OID 58942)
-- Dependencies: 230
-- Data for Name: ruangan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruangan (id_ruangan, nama_ruangan, gedung, kapasitas, jenis) FROM stdin;
4	IF-107	Gedung Teknik Informatika	30	lab
6	IF-105	Gedung Teknik Informatika	100	kelas
\.


--
-- TOC entry 5135 (class 0 OID 58826)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, username, password_hash, role) FROM stdin;
1	admin	e10adc3949ba59abbe56e057f20f883e	admin
2	dosen1	e10adc3949ba59abbe56e057f20f883e	dosen
3	mhs1	e10adc3949ba59abbe56e057f20f883e	mahasiswa
7	5025251150	ab56b4d92b40713acc5af89985d4b786	mahasiswa
\.


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 223
-- Name: dosen_id_dosen_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dosen_id_dosen_seq', 1, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 233
-- Name: jadwal_id_jadwal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jadwal_id_jadwal_seq', 1, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 221
-- Name: jurusan_id_jurusan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jurusan_id_jurusan_seq', 1, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 231
-- Name: kelas_id_kelas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kelas_id_kelas_seq', 1, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 235
-- Name: krs_id_krs_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.krs_id_krs_seq', 2, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 225
-- Name: mahasiswa_id_mhs_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mahasiswa_id_mhs_seq', 3, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 227
-- Name: mata_kuliah_id_mk_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mata_kuliah_id_mk_seq', 1, true);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 237
-- Name: nilai_id_nilai_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nilai_id_nilai_seq', 2, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 229
-- Name: ruangan_id_ruangan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ruangan_id_ruangan_seq', 6, true);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_user_seq', 7, true);


--
-- TOC entry 4941 (class 2606 OID 58871)
-- Name: dosen dosen_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_email_key UNIQUE (email);


--
-- TOC entry 4943 (class 2606 OID 58867)
-- Name: dosen dosen_id_user_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_id_user_key UNIQUE (id_user);


--
-- TOC entry 4945 (class 2606 OID 58869)
-- Name: dosen dosen_nidn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_nidn_key UNIQUE (nidn);


--
-- TOC entry 4947 (class 2606 OID 58865)
-- Name: dosen dosen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_pkey PRIMARY KEY (id_dosen);


--
-- TOC entry 4965 (class 2606 OID 58997)
-- Name: jadwal jadwal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal
    ADD CONSTRAINT jadwal_pkey PRIMARY KEY (id_jadwal);


--
-- TOC entry 4937 (class 2606 OID 58852)
-- Name: jurusan jurusan_kode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan
    ADD CONSTRAINT jurusan_kode_key UNIQUE (kode);


--
-- TOC entry 4939 (class 2606 OID 58850)
-- Name: jurusan jurusan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jurusan
    ADD CONSTRAINT jurusan_pkey PRIMARY KEY (id_jurusan);


--
-- TOC entry 4963 (class 2606 OID 58972)
-- Name: kelas kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (id_kelas);


--
-- TOC entry 4967 (class 2606 OID 59023)
-- Name: krs krs_id_mhs_id_kelas_tahun_ajaran_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.krs
    ADD CONSTRAINT krs_id_mhs_id_kelas_tahun_ajaran_key UNIQUE (id_mhs, id_kelas, tahun_ajaran);


--
-- TOC entry 4969 (class 2606 OID 59021)
-- Name: krs krs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.krs
    ADD CONSTRAINT krs_pkey PRIMARY KEY (id_krs);


--
-- TOC entry 4949 (class 2606 OID 58901)
-- Name: mahasiswa mahasiswa_id_user_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_id_user_key UNIQUE (id_user);


--
-- TOC entry 4951 (class 2606 OID 58903)
-- Name: mahasiswa mahasiswa_nim_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_nim_key UNIQUE (nim);


--
-- TOC entry 4953 (class 2606 OID 58899)
-- Name: mahasiswa mahasiswa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (id_mhs);


--
-- TOC entry 4955 (class 2606 OID 58935)
-- Name: mata_kuliah mata_kuliah_kode_mk_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mata_kuliah
    ADD CONSTRAINT mata_kuliah_kode_mk_key UNIQUE (kode_mk);


--
-- TOC entry 4957 (class 2606 OID 58933)
-- Name: mata_kuliah mata_kuliah_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mata_kuliah
    ADD CONSTRAINT mata_kuliah_pkey PRIMARY KEY (id_mk);


--
-- TOC entry 4971 (class 2606 OID 59050)
-- Name: nilai nilai_id_krs_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nilai
    ADD CONSTRAINT nilai_id_krs_key UNIQUE (id_krs);


--
-- TOC entry 4973 (class 2606 OID 59048)
-- Name: nilai nilai_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nilai
    ADD CONSTRAINT nilai_pkey PRIMARY KEY (id_nilai);


--
-- TOC entry 4959 (class 2606 OID 58956)
-- Name: ruangan ruangan_nama_ruangan_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_nama_ruangan_key UNIQUE (nama_ruangan);


--
-- TOC entry 4961 (class 2606 OID 58954)
-- Name: ruangan ruangan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangan
    ADD CONSTRAINT ruangan_pkey PRIMARY KEY (id_ruangan);


--
-- TOC entry 4933 (class 2606 OID 58836)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 4935 (class 2606 OID 58838)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4974 (class 2606 OID 58877)
-- Name: dosen dosen_id_jurusan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_id_jurusan_fkey FOREIGN KEY (id_jurusan) REFERENCES public.jurusan(id_jurusan) ON DELETE RESTRICT;


--
-- TOC entry 4975 (class 2606 OID 58872)
-- Name: dosen dosen_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen
    ADD CONSTRAINT dosen_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE SET NULL;


--
-- TOC entry 4982 (class 2606 OID 58998)
-- Name: jadwal jadwal_id_kelas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal
    ADD CONSTRAINT jadwal_id_kelas_fkey FOREIGN KEY (id_kelas) REFERENCES public.kelas(id_kelas) ON DELETE CASCADE;


--
-- TOC entry 4983 (class 2606 OID 59003)
-- Name: jadwal jadwal_id_ruangan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal
    ADD CONSTRAINT jadwal_id_ruangan_fkey FOREIGN KEY (id_ruangan) REFERENCES public.ruangan(id_ruangan) ON DELETE RESTRICT;


--
-- TOC entry 4980 (class 2606 OID 58978)
-- Name: kelas kelas_id_dosen_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_id_dosen_fkey FOREIGN KEY (id_dosen) REFERENCES public.dosen(id_dosen) ON DELETE RESTRICT;


--
-- TOC entry 4981 (class 2606 OID 58973)
-- Name: kelas kelas_id_mk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_id_mk_fkey FOREIGN KEY (id_mk) REFERENCES public.mata_kuliah(id_mk) ON DELETE CASCADE;


--
-- TOC entry 4984 (class 2606 OID 59029)
-- Name: krs krs_id_kelas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.krs
    ADD CONSTRAINT krs_id_kelas_fkey FOREIGN KEY (id_kelas) REFERENCES public.kelas(id_kelas) ON DELETE CASCADE;


--
-- TOC entry 4985 (class 2606 OID 59024)
-- Name: krs krs_id_mhs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.krs
    ADD CONSTRAINT krs_id_mhs_fkey FOREIGN KEY (id_mhs) REFERENCES public.mahasiswa(id_mhs) ON DELETE CASCADE;


--
-- TOC entry 4976 (class 2606 OID 58914)
-- Name: mahasiswa mahasiswa_id_dosen_wali_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_id_dosen_wali_fkey FOREIGN KEY (id_dosen_wali) REFERENCES public.dosen(id_dosen) ON DELETE SET NULL;


--
-- TOC entry 4977 (class 2606 OID 58909)
-- Name: mahasiswa mahasiswa_id_jurusan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_id_jurusan_fkey FOREIGN KEY (id_jurusan) REFERENCES public.jurusan(id_jurusan) ON DELETE RESTRICT;


--
-- TOC entry 4978 (class 2606 OID 58904)
-- Name: mahasiswa mahasiswa_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE SET NULL;


--
-- TOC entry 4979 (class 2606 OID 58936)
-- Name: mata_kuliah mata_kuliah_id_jurusan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mata_kuliah
    ADD CONSTRAINT mata_kuliah_id_jurusan_fkey FOREIGN KEY (id_jurusan) REFERENCES public.jurusan(id_jurusan) ON DELETE CASCADE;


--
-- TOC entry 4986 (class 2606 OID 59051)
-- Name: nilai nilai_id_krs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nilai
    ADD CONSTRAINT nilai_id_krs_fkey FOREIGN KEY (id_krs) REFERENCES public.krs(id_krs) ON DELETE CASCADE;


-- Completed on 2026-11-25 11:18:20

--
-- PostgreSQL database dump complete
--

\unrestrict VoI5oiORpIxw5c2lhsAfgJBBrodW82PaoGX62wAPK3wlcozoEFr6YailBfV7jSk

