--
-- PostgreSQL database dump
--

\restrict Epe08ZFwJnEwmBhKKZrKXdnbwqWsUIhJ0kY56uCPJtqZqyI1NODcyF3Y3WS4Hjx

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.3

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
-- Name: client_contracts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_contracts (
    id integer NOT NULL,
    client_id integer,
    package text,
    mrr numeric(10,2) DEFAULT 0,
    hours_sold_per_month numeric(6,1) DEFAULT 0,
    contract_start date,
    contract_end date,
    status text DEFAULT 'active'::text,
    contact_name text,
    contact_phone text,
    contact_email text,
    notes text,
    updated_at timestamp with time zone DEFAULT now(),
    target_brand_universe integer DEFAULT 0,
    target_carrousel integer DEFAULT 0,
    target_authority integer DEFAULT 0
);


--
-- Name: client_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_contracts_id_seq OWNED BY public.client_contracts.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name text NOT NULL,
    mazine_start_date date,
    created_at timestamp with time zone DEFAULT now(),
    meeting_notes text DEFAULT ''::text,
    monthly_events text DEFAULT ''::text
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: content_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_items (
    id integer NOT NULL,
    client_id integer,
    title text NOT NULL,
    status text DEFAULT 'brief'::text,
    hook_type text,
    objective text,
    format text,
    cta_type text,
    shoot_date date,
    post_date date,
    assigned_to integer,
    tiktok_views integer,
    tiktok_likes integer,
    tiktok_shares integer,
    performance_score numeric(4,1),
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    video_type text DEFAULT 'brand_universe'::text,
    type_of_action text DEFAULT 'awareness'::text,
    actors text DEFAULT ''::text,
    voice_over text DEFAULT ''::text
);


--
-- Name: content_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.content_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.content_items_id_seq OWNED BY public.content_items.id;


--
-- Name: content_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_tasks (
    id integer NOT NULL,
    content_item_id integer,
    client_id integer,
    stage text NOT NULL,
    title text NOT NULL,
    assigned_to integer,
    default_hours numeric(5,2) DEFAULT 0,
    status text DEFAULT 'todo'::text,
    due_date date,
    done_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: content_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.content_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.content_tasks_id_seq OWNED BY public.content_tasks.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_items (
    id integer NOT NULL,
    invoice_id integer,
    description text NOT NULL,
    quantity numeric(8,2) DEFAULT 1,
    unit_price numeric(10,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    sort_order integer DEFAULT 0
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_items_id_seq OWNED BY public.invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    quote_id integer,
    client_id integer,
    invoice_number text NOT NULL,
    title text NOT NULL,
    status text DEFAULT 'draft'::text,
    issue_date date DEFAULT CURRENT_DATE,
    due_date date,
    notes text,
    subtotal numeric(12,2) DEFAULT 0,
    tax_rate numeric(5,2) DEFAULT 15,
    total numeric(12,2) DEFAULT 0,
    paid_amount numeric(12,2) DEFAULT 0,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    company text NOT NULL,
    contact_name text,
    phone text,
    email text,
    source text DEFAULT 'referral'::text,
    status text DEFAULT 'new'::text,
    estimated_mrr numeric(10,2),
    service_type text,
    probability integer DEFAULT 20,
    close_date date,
    owner_id integer,
    next_action_date date,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    body text,
    link text,
    read boolean DEFAULT false,
    target_member_id integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    invoice_id integer,
    client_id integer,
    amount numeric(12,2) NOT NULL,
    method text DEFAULT 'bank'::text,
    reference text,
    paid_at date DEFAULT CURRENT_DATE,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text,
    category text DEFAULT 'Service'::text,
    unit_price numeric(10,2) DEFAULT 0 NOT NULL,
    unit text DEFAULT 'forfait'::text,
    active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: quote_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quote_items (
    id integer NOT NULL,
    quote_id integer,
    description text NOT NULL,
    quantity numeric(8,2) DEFAULT 1,
    unit_price numeric(10,2) DEFAULT 0,
    total numeric(12,2) DEFAULT 0,
    sort_order integer DEFAULT 0
);


--
-- Name: quote_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quote_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quote_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quote_items_id_seq OWNED BY public.quote_items.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quotes (
    id integer NOT NULL,
    lead_id integer,
    client_id integer,
    quote_number text NOT NULL,
    title text NOT NULL,
    status text DEFAULT 'draft'::text,
    valid_until date,
    notes text,
    subtotal numeric(12,2) DEFAULT 0,
    tax_rate numeric(5,2) DEFAULT 15,
    total numeric(12,2) DEFAULT 0,
    created_by integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    subtitle text DEFAULT ''::text
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quotes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quotes_id_seq OWNED BY public.quotes.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    client_id integer,
    month_key text NOT NULL,
    ai_result jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: task_defaults; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_defaults (
    stage text NOT NULL,
    label text NOT NULL,
    emoji text DEFAULT '📋'::text,
    default_hours numeric(5,2) DEFAULT 1,
    sort_order integer DEFAULT 0
);


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    name text NOT NULL,
    role text,
    hourly_rate numeric(8,2) DEFAULT 0 NOT NULL,
    color text DEFAULT '#618F9B'::text,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- Name: tiktok_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_activity (
    client_id integer NOT NULL,
    date date NOT NULL,
    hour smallint NOT NULL,
    active_followers integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_content (
    client_id integer NOT NULL,
    title text NOT NULL,
    views integer DEFAULT 0,
    likes integer DEFAULT 0,
    comments integer DEFAULT 0,
    shares integer DEFAULT 0,
    post_time text,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_followers (
    client_id integer NOT NULL,
    date date NOT NULL,
    followers integer DEFAULT 0,
    diff integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_gender; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_gender (
    client_id integer NOT NULL,
    gender text NOT NULL,
    distribution numeric(6,2) DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_overview; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_overview (
    client_id integer NOT NULL,
    date date NOT NULL,
    views integer DEFAULT 0,
    likes integer DEFAULT 0,
    comments integer DEFAULT 0,
    shares integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_territories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_territories (
    client_id integer NOT NULL,
    territory text NOT NULL,
    distribution numeric(8,4) DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: tiktok_viewers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tiktok_viewers (
    client_id integer NOT NULL,
    date date NOT NULL,
    new_viewers integer DEFAULT 0,
    returning_viewers integer DEFAULT 0,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: time_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_entries (
    id integer NOT NULL,
    team_member_id integer,
    client_id integer,
    content_item_id integer,
    task_type text NOT NULL,
    hours numeric(5,2) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    content_type text DEFAULT ''::text,
    internal_project text DEFAULT ''::text
);


--
-- Name: time_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_entries_id_seq OWNED BY public.time_entries.id;


--
-- Name: client_contracts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_contracts ALTER COLUMN id SET DEFAULT nextval('public.client_contracts_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: content_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_items ALTER COLUMN id SET DEFAULT nextval('public.content_items_id_seq'::regclass);


--
-- Name: content_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tasks ALTER COLUMN id SET DEFAULT nextval('public.content_tasks_id_seq'::regclass);


--
-- Name: invoice_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_items_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: quote_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_items ALTER COLUMN id SET DEFAULT nextval('public.quote_items_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes ALTER COLUMN id SET DEFAULT nextval('public.quotes_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: time_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries ALTER COLUMN id SET DEFAULT nextval('public.time_entries_id_seq'::regclass);


--
-- Data for Name: client_contracts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_contracts (id, client_id, package, mrr, hours_sold_per_month, contract_start, contract_end, status, contact_name, contact_phone, contact_email, notes, updated_at, target_brand_universe, target_carrousel, target_authority) FROM stdin;
4	3	Starter	19000.00	10.0	2025-01-01	\N	active	Kris Mame	+23057843317	mananagement@lariviere.mu		2026-04-04 11:31:56.597509+00	4	1	1
1	1	Growth	32000.00	20.0	2025-10-15	\N	active	Adam Sohawon	+230 5746 1861	asohawon@polytolpaints.com		2026-04-04 12:02:53.564584+00	4	2	2
3	4	Starter	19000.00	10.0	2025-07-01	\N	active	Samuel  De Maroussem	+23054233937	restaurant-tamarin@rmclub.mu		2026-04-04 12:09:18.300332+00	3	3	2
7	7	Starter	19000.00	10.0	2026-04-09	\N	active	Abraham Narainen	+23055009123	abraham@developers.institute		2026-04-09 13:50:53.986861+00	4	1	1
8	6	Growth	32000.00	20.0	2026-04-09	\N	active	Florent Masson	+23052598846	fmasson@mips.mu		2026-04-22 10:59:17.384511+00	4	2	2
2	5	Starter	19000.00	10.0	2025-09-01	\N	active	Théo Ferriere	+33603644207			2026-04-22 11:00:24.627546+00	4	1	1
9	8	\N	0.00	0.0	2026-01-01	\N	active	Amberine Sohawon	+230 5746 3258	av@mazine.mu		2026-04-22 17:10:46.11575+00	0	0	0
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clients (id, name, mazine_start_date, created_at, meeting_notes, monthly_events) FROM stdin;
3	La Rivière Restaurant	2025-01-01	2026-03-23 12:10:20.499829+00		
4	Ava Bistrot Tamarin	2025-07-01	2026-03-23 12:11:34.589776+00		
5	Ava Beach	2025-09-01	2026-03-23 12:12:49.562174+00		
6	MIPS IT Digital	2026-04-01	2026-03-23 14:16:58.519599+00		
1	Polytol  Paints	2025-10-15	2026-03-20 12:32:31.625128+00		
7	Developers.Institute.Mauritius	2026-04-09	2026-03-24 16:30:33.727348+00		
8	Mazine (interne)	2026-01-01	2026-04-22 17:10:08.746376+00		
\.


--
-- Data for Name: content_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_items (id, client_id, title, status, hook_type, objective, format, cta_type, shoot_date, post_date, assigned_to, tiktok_views, tiktok_likes, tiktok_shares, performance_score, notes, created_at, updated_at, video_type, type_of_action, actors, voice_over) FROM stdin;
7	4	Aesthetic lieu	script	\N	\N	\N	\N	2026-04-07	2026-04-17	1	\N	\N	\N	\N	lieu\n\npov: you found your go to place in Mauritius	2026-04-06 05:43:38.071585+00	2026-04-06 09:22:10.811723+00	brand_universe	awareness		
2	4	Friday Afterwork	posted	Storytelling	Brand	\N	\N	2026-04-04	2026-04-07	1	\N	\N	\N	\N		2026-04-04 11:50:16.483781+00	2026-04-04 12:13:54.139073+00	brand_universe	awareness		
1	1	Fabrication peinture	script	\N	\N	\N	\N	2026-04-10	2026-04-25	1	\N	\N	\N	\N	seeing the process makes me want to paint my house again \n1. ajout matieres\n2. mix\n3. couleurs \n4. mix again\n5. on your house (maison de la couleur) "	2026-03-23 10:48:48.876239+00	2026-04-14 09:42:34.400502+00	brand_universe	awareness		
5	3	Evènements La Rivière	editing	\N	\N	\N	\N	2026-04-04	2026-04-08	1	\N	\N	\N	\N	Lately in La Rivière (Indépendance, concert) 	2026-04-05 15:07:01.38526+00	2026-04-05 15:07:01.38526+00	brand_universe	awareness		
8	4	Bluberry Matcha	script	\N	\N	\N	\N	2026-04-07	2026-04-21	1	\N	\N	\N	\N	process bluberry matcha qui se fait:\n I'm craving a blueberry matcha, but a real good one, like the ones you see on tiktok 	2026-04-06 05:48:43.676772+00	2026-04-06 05:48:43.676772+00	brand_universe	awareness		
10	4	Pool Party Voix off	script	\N	\N	\N	\N	2026-04-07	2026-04-09	1	\N	\N	\N	\N	Imagine this (photo pool party) but right here.\nRight on the main road I drive at every day, I just found out they're organising a Pool party with free entrance for every one, members of the club or non members. It will be on April 12  during the day from 12pm to 4pm. Gotta go early to save a spot 	2026-04-06 06:02:43.842888+00	2026-04-06 06:02:43.842888+00	brand_universe	awareness		
13	6	Over the years	script	\N	\N	\N	\N	2026-04-09	2026-04-19	1	\N	\N	\N	\N	watch life become easier over the years\n\n1. pièces\n2. chèques\n3. borne mips 	2026-04-07 19:12:29.496969+00	2026-04-07 19:12:29.496969+00	carrousel	awareness		
11	6	FinTech Robots	script	\N	\N	\N	\N	2026-04-09	2026-04-22	1	\N	\N	\N	\N	shot of the building and exterior of the office\nText on screen:\n“it’s a FinTech company, it's probably run by robots”\nCut to employees inside	2026-04-06 13:11:21.624343+00	2026-04-07 19:14:37.255554+00	brand_universe	awareness		
12	6	Steps Ouverture Magasin	script	\N	\N	\N	\N	2026-04-09	2026-04-16	1	\N	\N	\N	\N	Bann zafer ki bizin pa blie kan to ouvert to magasin \n1. fer sire to bann prix bien defini pou ki to profit rest stable \n2. mett en place enn sel borne pou payment: ena compagnie ena bokou machine carte + systeme qr code, to kapav pren enn sel machine mips kot tout reuni\n3. pa blie met en place enn systeme pou reconcilie to bann paiement  avec to lavente \n\nsi to ena question poz nou en commentaire 	2026-04-07 19:10:38.232765+00	2026-04-09 07:44:28.123049+00	authority	consideration	Voix live - Hans	none
9	4	Afterwork	script	\N	\N	Voiceover	\N	2026-04-07	2026-04-24	1	\N	\N	\N	\N	Voix off Courtney \nScript: This is what was really missing in Tamarin.\nAfter work we are all tired, and wouldn’t it be nice if once a week we could have a happy hour and watch the sunset at an afterwork?\nThey just started doing it every Friday at Ava Bistrot in Tamarin. It’s right on the main road, open to everyone, and it’s on the terrace. oh and there is plenty of parking. \nThe vibe is chill, I think this is my new Friday spot"	2026-04-06 05:56:48.378105+00	2026-04-06 06:17:06.73977+00	brand_universe	awareness		
14	6	how to create a website in 2026	script	\N	\N	\N	\N	2026-04-09	2026-04-25	\N	\N	\N	\N	\N	This is how I would create my website mo meme en 2026:\nPremièrement mo asste mo nom de domaine, moi mo enn compagnie fleur local, flerlokal.mu trouv enn ki libre \nDeuxieme mo pou trouv enn plateforme pou build le website\nTroisiemement mo pou rod enn solution pou mett le payement lor mo website, à maurice nou servi mips.	2026-04-07 19:18:01.542031+00	2026-04-09 08:50:03.083164+00	authority	consideration	Voix Live - Qui? 	
6	4	Client UGC	script	Storytelling	Engagement	UGC	\N	2026-04-07	2026-04-14	1	\N	\N	\N	\N	Script: There's so many places to visit but which ones are really worth going? \nI'm talking GOOD food, service and a nice place? \nToday I'm at Ava Bistrot, I love that it's spacious, there's an inside and a terace, it's really huge and love the design \nI just ordered a poke bowl with a mango matcha, healthy life altho i don't go to the gym. i should. but the cool thing is Ava is opened to every one.\nso the poke was really good, the matcha is a real good matcha latte, i head the brand they use take it directly from a farm in Japan. \nthe staff is alway sweet to me. so for me Ava is definitly worth going to.	2026-04-06 05:39:43.225952+00	2026-04-06 09:22:01.843177+00	brand_universe	awareness		
15	6	Day in my life	script	\N	\N	\N	\N	2026-04-09	2026-04-29	1	\N	\N	\N	\N	Exemple: A day in my life as a 23 yo Account Manager 	2026-04-07 19:39:02.351489+00	2026-04-07 19:39:02.351489+00	carrousel	awareness	Qui? 	
16	6	Come Shopping with me	script	\N	\N	\N	\N	2026-04-16	2026-04-29	\N	\N	\N	\N	\N	Come shopping with me in Mauritius. \n(boutiques, sacs, terminal paiement MIPS pour le paiement) Liste magasins qui l'ont dans un mall 	2026-04-07 19:46:44.398831+00	2026-04-07 19:46:44.398831+00	brand_universe	awareness		
17	6	A day in my life - curepipe edition	script	\N	\N	\N	\N	2026-04-09	2026-04-23	1	\N	\N	\N	\N	A day in my life - curepipe edition\n\n1. Put 3 jackets on \n2. Prepare my umbrella because surprisignly there's 100% chance of rain today \n3. Happy to arrive at the warm office \n3. Work on....\n4. Eat ....\n5. ...	2026-04-07 19:53:08.819303+00	2026-04-07 19:53:08.819303+00	brand_universe	awareness	Qui? même personne que pour le carrousel	
18	6	A day in my life - curepipe edition	script	\N	\N	\N	\N	2026-04-09	2026-04-23	1	\N	\N	\N	\N	A day in my life - curepipe edition\n\n1. Put 3 jackets on \n2. Prepare my umbrella because surprisignly there's 100% chance of rain today \n3. Happy to arrive at the warm office \n3. Work on....\n4. Eat ....\n5. ...	2026-04-07 19:53:11.066791+00	2026-04-07 19:53:11.066791+00	brand_universe	awareness	Qui? même personne que pour le carrousel	
19	6	A day in my life - curepipe edition	script	\N	\N	\N	\N	2026-04-09	2026-04-23	1	\N	\N	\N	\N	A day in my life - curepipe edition\n\n1. Put 3 jackets on \n2. Prepare my umbrella because surprisignly there's 100% chance of rain today \n3. Happy to arrive at the warm office \n3. Work on....\n4. Eat ....\n5. ...	2026-04-07 19:53:14.232871+00	2026-04-07 19:53:14.232871+00	brand_universe	awareness	Qui? même personne que pour le carrousel	
20	6	The beauty of the center	script	\N	\N	\N	\N	2026-04-16	2026-04-30	1	\N	\N	\N	\N	Everybody's talking about the coast but can we admire the beauty of the center for a second \n\n(vues de curepipe - trou aux cerfs, metro, rues floreal) 	2026-04-07 19:59:02.590269+00	2026-04-07 19:59:02.590269+00	brand_universe	awareness		
22	5	From morning to night	posted	\N	\N	\N	\N	2026-04-10	2026-04-11	1	\N	\N	\N	\N	love a restaurant that's open every day from morning to night that i can just show up to without booking\n\nlégende: have you tried Ava Beach's new menu? 	2026-04-08 11:49:30.258689+00	2026-04-11 12:24:44.821134+00	brand_universe	awareness		
4	3	Concert	posted	\N	\N	\N	\N	2026-04-04	2026-04-06	1	\N	\N	\N	\N	a saturday night at La Rivière	2026-04-05 15:05:50.228282+00	2026-04-08 12:01:14.659841+00	brand_universe	awareness		
3	4	Vidéo Pool Party	posted	\N	\N	\N	\N	2026-04-07	2026-04-08	1	\N	\N	\N	\N	Aesthetic - piscine\ntexte tiktok: what if we do a pool party here for everyone?  	2026-04-05 14:43:56.607175+00	2026-04-08 12:01:23.981709+00	brand_universe	awareness		
23	5	Mise en scène Interview	script	\N	\N	\N	\N	2026-04-17	2026-04-21	\N	\N	\N	\N	\N	Ma voix: Sorry monsieur what are you wearing today?\nYaseen:sorry  mo pena letemps la mo pe al travay\nMa voix: mo kapav vinn or ou? \nYassen: aller\nYassen (au resto): nou a kote la plage Trou aux biches, dans le nouveau restaurant qui appelle Ava Beach kot mo travay en tant que chef, ici nou fer le petit dejeuner, le dejeuner et le diner \nVoix Théo: Yaseen\nYaseen: sorry boss pe kriyé moi  \n	2026-04-08 11:54:47.353428+00	2026-04-18 06:55:49.044612+00	authority	awareness	Yasseen	
26	1	Waterproofing	script	\N	\N	\N	\N	\N	2026-04-22	1	\N	\N	\N	\N	Scène 1: eau qui coule du mur, flaque par terre, application  \nVoix off:\nPlus bann zour passé, + delo pou koulé dan lakaz dimounn kot ena bann infiltration.\nEna bokou choix waterproofing lor marché, mai zot bizin bien soiziré. sa ki important:\n1. enn fibrated waterproofing\n2. une marque reconnue (non, sa pa kav aster lor KEMU) \n3. le produit avec le meilleur rendemen. \nnou ena ce produit. :) 	2026-04-10 07:45:47.774568+00	2026-04-10 07:45:47.774568+00	authority	awareness		
29	1	Indication chemin Flacq	script	\N	\N	\N	\N	2026-05-02	2026-05-23	1	\N	\N	\N	\N	couma renov mo lakaz si mo rest dans l'est? \n1. trouv enn bato pour al ziska port-louis\n2. non menti, pa bizin al bien loin. mo pass par...., mo diriz moi vers.... et là mo pou trouv showroom Polytol Paints dan Flacq pou trouv mo la peinture pou tou type de surface. bon kapav guet lor google map, ou soi save sa video la. 	2026-04-10 11:05:55.942264+00	2026-04-10 11:05:55.942264+00	brand_universe	awareness		internal
30	1	Flacq	ideas	\N	\N	\N	\N	2026-05-09	2026-04-22	1	\N	\N	\N	\N	pov: you need to renovate your house and you live in the east \npin Polytol Paints Flacq, Mauritius	2026-04-10 11:06:54.777748+00	2026-04-10 11:06:54.777748+00	brand_universe	awareness		
33	5	hidden terrace	posted	\N	\N	\N	\N	2026-04-10	\N	1	\N	\N	\N	\N		2026-04-11 08:13:55.090991+00	2026-04-11 12:03:53.873262+00	brand_universe	awareness		
27	1	Waterproofing Crack Filler	script	\N	\N	\N	\N	\N	2026-04-22	1	\N	\N	\N	\N	Voix off Eiman: eski nou pa konn construir lakaz? Li très commun gagn crak dan miray, moi sak kout avan mo ti demann moi "sa ve dir dimounn pa konn constrir lakaz?" en fait rien à voir. c'est le beton ki bouze c'est enn phenomene natirel. mais ca veut pas dir nou lakaz bizin kass kasse. \nPolytol Paints inn ecout le marché et est le premier kinn develop enn  produi pou repar bann krak ki en mem temps enn waterproofing. le Waterproofing Crack Filler de Polycolor. 	2026-04-10 07:47:57.228091+00	2026-04-10 11:35:14.59633+00	authority	awareness		internal
28	1	Quicaillerie Grand Baie	script	\N	\N	\N	\N	2026-04-17	2026-04-24	1	\N	\N	\N	\N	I just found a new one-stop shop in Grand Baie where there is every thing I need to renovate my house 	2026-04-10 07:49:55.795618+00	2026-04-10 11:36:59.001863+00	brand_universe	awareness		
31	1	Grand Baie - house reno	script	\N	\N	\N	\N	2026-04-17	2026-04-25	1	\N	\N	\N	\N	(pas mettre owatrol) \nLet's build my dream house in Grand Baie	2026-04-10 11:39:44.550991+00	2026-04-10 11:39:44.550991+00	brand_universe	consideration		
32	1	Fabrication peinture	script	\N	\N	\N	\N	2026-04-17	2026-04-18	1	\N	\N	\N	\N		2026-04-10 11:44:11.268878+00	2026-04-10 11:44:11.268878+00	carrousel	awareness		
25	1	Waterproofing, Aqualock	script	\N	\N	\N	\N	\N	2026-04-14	1	\N	\N	\N	\N	VO Courtney: If rain is leaking into your house in mauritius, you have two options, and the second one might surprise you.\nFirst, you can use a quality fibrated waterproofing, I recommend the Fibrated waterproofing from Polycolor. \nIf you want to know the price, comment "ready" and we'll DM it to you \nAnd the second option is completely new to the mauritian market, Polytol Paints has created the first interior waterproofing solution for interior walls, you'll find it under the name Aqualock by Polycolor, it really is a game changer.     	2026-04-10 07:43:20.331463+00	2026-04-10 13:56:10.228141+00	authority	consideration		internal
36	3	LR: Indication depuis le Sud	shooting	\N	\N	\N	\N	2026-04-23	2026-04-25	\N	\N	\N	\N	\N	So my great grandpa knows how to use TikTok but not Google Maps. And if you’re like him, here’s how to get to our favorite restaurant, La Rivière\nWe’re from the south, so when we’re in Tamarin, we cross the bridge and take the first left before the roundabout. Then we turn left again right away. We keep going, annnd we're here. There’s a big parking space, which is non-negotiable	2026-04-17 08:11:05.155077+00	2026-04-22 18:05:17.911013+00	authority	consideration		external
34	4	Review	script	\N	\N	\N	\N	\N	2026-04-14	1	\N	\N	\N	\N	Qui a dit que manger healthy et bon c'etait pas compatible? Ici je mange mes meilleurs poke bowls, je bois les meilleurs matcha, et des vrais matcha. En plus on utilise Nami matcha, qui est directement sourcé d'une ferme au japon. Ya de l'espace, un grand parking (et oui ça change tout)! j'y vais souvent, et même pour télé travailler comme ils sont ouverts tous tous les jours 	2026-04-13 14:16:13.909046+00	2026-04-13 17:22:36.552524+00	authority	consideration		internal
21	5	Voix off Amberine	script	\N	\N	\N	\N	2026-04-10	2026-04-12	1	\N	\N	\N	\N	et si mo dir zot le chef kinn fer la carte ti travay dan restaurants étoilés, zot croire moi? \nÇa, c'est Ava Beach\nMai zot ti deza kone.  \nEnn dimounn inn dir moi "non be li nouvo, design, chic, sirmen li cher" et en fait non zistemen, li enn perle ror. so prix rest abordable, et so manze qualité. le chef kinn aide fer la carte ti travay dan bann restaurants étoilés lor la cote d'azur. sa veut dire nou kouma hannah montana, nou get the best of both worlds. \nena enn nouvo menu,  avek boukou choix, mo ti kapav dir zot ki enan ladan mai mo manze inn paré. 	2026-04-08 11:46:34.360673+00	2026-04-14 09:47:58.137691+00	authority	consideration		internal
35	1	Aqualock + Crack filler	editing	\N	\N	\N	\N	\N	2026-04-21	\N	\N	\N	\N	\N	Courtney: Isn't the weather so scary lately? I don't know about you, but the rain has been pouring, and I even had water leaking through my roof, even into my walls!! Oh and I also have cracks in my walls, it's all such a mess. \nSo I kept putting it off instead of doing something about it. But I finally decided to get proper waterproofing. And for my walls, we're applying two things: a waterproofing for interior walls and a crack filler. In this video you’ve seen all the products I used.	2026-04-17 07:34:41.260377+00	2026-04-17 07:34:41.260377+00	authority	consideration		external
38	5	Indication chemin	shooting	\N	\N	\N	\N	2026-04-17	2026-04-28	1	\N	\N	\N	\N		2026-04-22 06:33:35.271067+00	2026-04-22 06:33:35.271067+00	authority	consideration		internal
39	5	Matcha  Process - Nouveauté	shooting	\N	\N	\N	\N	2026-04-18	2026-04-26	1	\N	\N	\N	\N		2026-04-22 06:36:42.20109+00	2026-04-22 06:36:52.71463+00	authority	consideration		internal
40	5	Matcha  Aesthetic	editing	\N	\N	\N	\N	2026-04-18	2026-04-29	1	\N	\N	\N	\N		2026-04-22 06:38:53.163795+00	2026-04-22 06:38:53.163795+00	brand_universe	consideration		
24	3	Food by the pool while it's still summer	script	\N	\N	\N	\N	2026-04-10	2026-04-17	1	\N	\N	\N	\N	En cuisine pendant que le chef prepare à manger, puis à une table à côté de la piscine "fish of the day (ou autre) by the pool while it's still summer"	2026-04-08 12:00:11.640853+00	2026-04-22 14:53:48.436447+00	brand_universe	consideration		
37	3	Sunset on my way	posted	\N	\N	\N	\N	2026-04-17	2026-04-17	1	\N	\N	\N	\N		2026-04-22 06:32:01.259655+00	2026-04-22 14:54:24.132328+00	brand_universe	awareness		
43	3	Un dîner dans le jardin	script	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	un dîner dans le jardin au bord d'une rivière  	2026-04-22 18:10:08.232708+00	2026-04-22 18:10:08.232708+00	brand_universe	awareness		
41	3	Live Cooking	ideas	\N	\N	\N	\N	2026-04-29	2026-05-01	1	\N	\N	\N	\N	15h rdv LR	2026-04-22 18:03:18.739+00	2026-04-22 18:03:18.739+00	brand_universe	consideration		
42	3	Diner romantique	editing	\N	\N	\N	\N	2026-04-04	2026-04-22	1	\N	\N	\N	\N	date night idea: a private patio, our own waiter and a special set menu for us 2	2026-04-22 18:07:22.744368+00	2026-04-22 18:07:22.744368+00	brand_universe	awareness		
\.


--
-- Data for Name: content_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_tasks (id, content_item_id, client_id, stage, title, assigned_to, default_hours, status, due_date, done_at, notes, created_at) FROM stdin;
6	1	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-03-23 10:48:48.876239+00
64	10	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
65	10	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
8	2	4	ideas	Idéation	\N	1.00	done	\N	2026-04-04 12:03:23.160559+00		2026-04-04 11:50:16.483781+00
66	10	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
67	10	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
10	2	4	shooting	Tournage	\N	1.00	done	\N	2026-04-04 12:10:02.953752+00		2026-04-04 11:50:16.483781+00
11	2	4	editing	Montage	\N	1.00	done	\N	2026-04-04 12:10:03.880872+00		2026-04-04 11:50:16.483781+00
12	2	4	ready	Ready to Post	\N	1.00	done	\N	2026-04-04 12:10:05.102737+00		2026-04-04 11:50:16.483781+00
13	2	4	posted	Publication	\N	1.00	done	\N	2026-04-04 12:10:05.883107+00		2026-04-04 11:50:16.483781+00
9	2	4	script	Script	\N	1.00	done	\N	2026-04-04 12:10:09.183214+00		2026-04-04 11:50:16.483781+00
34	5	3	posted	Publication	\N	1.00	done	\N	2026-04-14 07:58:18.38128+00		2026-04-05 15:07:01.38526+00
68	10	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
69	10	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 06:02:43.842888+00
15	3	4	ideas	Idéation	\N	1.00	done	\N	2026-04-05 15:00:00.666039+00		2026-04-05 14:43:56.607175+00
18	3	4	editing	Montage	\N	1.00	done	\N	2026-04-08 11:56:50.329708+00		2026-04-05 14:43:56.607175+00
16	3	4	script	Script	\N	1.00	done	\N	2026-04-05 15:02:05.463535+00		2026-04-05 14:43:56.607175+00
29	5	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-05 15:07:01.38526+00
30	5	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-05 15:07:01.38526+00
31	5	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-05 15:07:01.38526+00
32	5	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-05 15:07:01.38526+00
33	5	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-05 15:07:01.38526+00
36	6	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
37	6	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
38	6	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
39	6	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
40	6	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
41	6	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 05:39:43.225952+00
43	7	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
44	7	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
45	7	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
46	7	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
47	7	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
48	7	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 05:43:38.071585+00
50	8	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
51	8	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
52	8	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
53	8	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
54	8	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
55	8	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 05:48:43.676772+00
57	9	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
58	9	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
59	9	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
60	9	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
61	9	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
62	9	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 05:56:48.378105+00
74	11	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-06 13:11:21.624343+00
75	11	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-06 13:11:21.624343+00
76	11	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-06 13:11:21.624343+00
81	12	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:10:38.232765+00
82	12	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:10:38.232765+00
83	12	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:10:38.232765+00
85	13	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:12:29.496969+00
87	13	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:12:29.496969+00
22	4	3	ideas	Idéation	\N	1.00	done	\N	2026-04-08 11:55:21.921156+00		2026-04-05 15:05:50.228282+00
23	4	3	script	Script	\N	1.00	done	\N	2026-04-08 11:55:23.109329+00		2026-04-05 15:05:50.228282+00
24	4	3	shooting	Tournage	\N	1.00	done	\N	2026-04-08 11:55:23.912689+00		2026-04-05 15:05:50.228282+00
26	4	3	ready	Ready to Post	\N	1.00	done	\N	2026-04-08 11:55:25.681963+00		2026-04-05 15:05:50.228282+00
17	3	4	shooting	Tournage	\N	1.00	done	\N	2026-04-08 11:56:47.309557+00		2026-04-05 14:43:56.607175+00
19	3	4	ready	Ready to Post	\N	1.00	done	\N	2026-04-08 11:56:51.527874+00		2026-04-05 14:43:56.607175+00
20	3	4	posted	Publication	\N	1.00	done	\N	2026-04-08 11:56:54.284955+00		2026-04-05 14:43:56.607175+00
86	13	6	script	Script	1	0.50	todo	\N	\N	watch life become easier over the years\n\n1. pièces\n2. chèques\n3. borne mips 	2026-04-07 19:12:29.496969+00
78	12	6	ideas	Idéation	\N	1.00	done	\N	2026-04-09 08:04:00.981345+00		2026-04-07 19:10:38.232765+00
80	12	6	shooting	Tournage	\N	1.00	done	\N	2026-04-09 08:04:03.852542+00		2026-04-07 19:10:38.232765+00
71	11	6	ideas	Idéation	\N	1.00	done	\N	2026-04-09 08:14:25.274497+00		2026-04-06 13:11:21.624343+00
73	11	6	shooting	Tournage	\N	1.00	done	\N	2026-04-09 08:15:38.483235+00		2026-04-06 13:11:21.624343+00
4	1	1	editing	Montage	\N	1.00	done	\N	2026-04-14 10:03:49.451317+00		2026-03-23 10:48:48.876239+00
5	1	1	ready	Ready to Post	\N	1.00	done	\N	2026-04-14 10:03:50.769134+00		2026-03-23 10:48:48.876239+00
3	1	1	shooting	Tournage	\N	1.00	done	\N	2026-04-14 10:03:53.025058+00		2026-03-23 10:48:48.876239+00
1	1	1	ideas	Idéation	\N	1.00	done	\N	2026-04-14 10:03:55.199655+00		2026-03-23 10:48:48.876239+00
2	1	1	script	Script	\N	1.00	done	\N	2026-04-14 10:03:57.370372+00		2026-03-23 10:48:48.876239+00
88	13	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:12:29.496969+00
89	13	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:12:29.496969+00
90	13	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:12:29.496969+00
92	14	6	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-07 19:18:01.542031+00
94	14	6	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-07 19:18:01.542031+00
95	14	6	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-07 19:18:01.542031+00
96	14	6	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-07 19:18:01.542031+00
97	14	6	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-07 19:18:01.542031+00
99	15	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:39:02.351489+00
101	15	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:39:02.351489+00
102	15	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:39:02.351489+00
103	15	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:39:02.351489+00
104	15	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:39:02.351489+00
106	16	6	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
107	16	6	script	Script	\N	2.00	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
108	16	6	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
109	16	6	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
110	16	6	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
111	16	6	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-07 19:46:44.398831+00
113	17	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
114	17	6	script	Script	1	2.00	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
115	17	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
116	17	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
117	17	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
118	17	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:08.819303+00
120	18	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
121	18	6	script	Script	1	2.00	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
122	18	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
123	18	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
124	18	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
125	18	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:11.066791+00
127	19	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:53:14.232871+00
129	19	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:53:14.232871+00
130	19	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:53:14.232871+00
131	19	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:14.232871+00
132	19	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:53:14.232871+00
134	20	6	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-07 19:59:02.590269+00
136	20	6	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-07 19:59:02.590269+00
137	20	6	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-07 19:59:02.590269+00
138	20	6	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-07 19:59:02.590269+00
139	20	6	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-07 19:59:02.590269+00
141	21	5	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
142	21	5	script	Script	1	2.00	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
143	21	5	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
144	21	5	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
145	21	5	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
146	21	5	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-08 11:46:34.360673+00
148	22	5	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-08 11:49:30.258689+00
149	22	5	script	Script	1	2.00	todo	\N	\N	\N	2026-04-08 11:49:30.258689+00
150	22	5	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-08 11:49:30.258689+00
151	22	5	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-08 11:49:30.258689+00
152	22	5	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-08 11:49:30.258689+00
155	23	5	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
156	23	5	script	Script	\N	2.00	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
157	23	5	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
158	23	5	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
159	23	5	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
160	23	5	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-08 11:54:47.353428+00
27	4	3	posted	Publication	\N	1.00	done	\N	2026-04-08 11:55:20.641161+00		2026-04-05 15:05:50.228282+00
25	4	3	editing	Montage	\N	1.00	done	\N	2026-04-08 11:55:24.838605+00		2026-04-05 15:05:50.228282+00
162	24	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
163	24	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
164	24	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
165	24	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
166	24	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
167	24	3	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-08 12:00:11.640853+00
100	15	6	script	Script	1	1.00	todo	2026-04-16	\N	Exemple: A day in my life as a 23 yo Account Manager 	2026-04-07 19:39:02.351489+00
135	20	6	script	Script	1	1.00	todo	2026-04-16	\N	Everybody's talking about the coast but can we admire the beauty of the center for a second \n\n(vues de curepipe - trou aux cerfs, metro, rues floreal) 	2026-04-07 19:59:02.590269+00
79	12	6	script	Script	\N	1.00	done	\N	2026-04-09 08:04:01.531373+00		2026-04-07 19:10:38.232765+00
153	22	5	posted	Publication	\N	1.00	done	\N	2026-04-14 09:25:09.802249+00		2026-04-08 11:49:30.258689+00
250	36	3	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
251	36	3	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
252	36	3	boosted	Boost Ads	\N	1.00	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
253	37	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
254	37	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
255	37	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
256	37	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
257	37	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
258	37	3	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
259	37	3	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 06:32:01.259655+00
260	38	5	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
261	38	5	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
262	38	5	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
263	38	5	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
264	38	5	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
265	38	5	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
128	19	6	script	Script	1	1.00	todo	\N	\N	A day in my life - curepipe edition\n\n1. Put 3 jackets on \n2. Prepare my umbrella because surprisignly there's 100% chance of rain today \n3. Happy to arrive at the warm office \n3. Work on....\n4. Eat ....\n5. ...	2026-04-07 19:53:14.232871+00
93	14	6	script	Script	1	1.00	todo	\N	\N	This is how I would create my website in 2026:\nFirst I would use.... \nSecond I would buy a domain\nThird I would incorporate payment methods, in mauritius you do it with MIPS	2026-04-07 19:18:01.542031+00
72	11	6	script	Script	\N	1.00	done	\N	2026-04-09 08:14:24.71992+00		2026-04-06 13:11:21.624343+00
173	25	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 07:43:20.331463+00
174	25	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 07:43:20.331463+00
175	25	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 07:43:20.331463+00
176	26	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
177	26	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
178	26	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
179	26	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
180	26	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
181	26	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
182	26	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 07:45:47.774568+00
183	27	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
184	27	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
185	27	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
186	27	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
187	27	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
188	27	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
189	27	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 07:47:57.228091+00
190	28	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
191	28	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
192	28	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
193	28	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
194	28	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
195	28	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
196	28	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 07:49:55.795618+00
197	29	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
198	29	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
199	29	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
200	29	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
201	29	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
202	29	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
203	29	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 11:05:55.942264+00
204	30	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
205	30	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
206	30	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
207	30	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
208	30	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
209	30	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
210	30	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 11:06:54.777748+00
211	31	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
212	31	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
213	31	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
214	31	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
215	31	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
216	31	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
217	31	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 11:39:44.550991+00
218	32	1	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
219	32	1	script	Script	1	2.00	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
220	32	1	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
221	32	1	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
222	32	1	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
223	32	1	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
224	32	1	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-10 11:44:11.268878+00
225	33	5	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
226	33	5	script	Script	1	2.00	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
227	33	5	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
228	33	5	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
229	33	5	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
230	33	5	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-11 08:13:55.090991+00
232	34	4	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
233	34	4	script	Script	1	2.00	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
234	34	4	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
235	34	4	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
236	34	4	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
237	34	4	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
238	34	4	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-13 14:16:13.909046+00
231	33	5	boosted	Boost Ads	\N	1.00	done	\N	2026-04-14 09:25:18.584034+00		2026-04-11 08:13:55.090991+00
172	25	1	editing	Montage	\N	1.00	done	\N	2026-04-17 07:03:16.494988+00		2026-04-10 07:43:20.331463+00
171	25	1	shooting	Tournage	\N	1.00	done	\N	2026-04-17 07:03:20.271086+00		2026-04-10 07:43:20.331463+00
170	25	1	script	Script	\N	1.00	done	\N	2026-04-17 07:03:21.531985+00		2026-04-10 07:43:20.331463+00
169	25	1	ideas	Idéation	\N	1.00	done	\N	2026-04-17 07:03:22.325274+00		2026-04-10 07:43:20.331463+00
239	35	1	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
240	35	1	script	Script	\N	2.00	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
241	35	1	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
242	35	1	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
243	35	1	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
244	35	1	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
245	35	1	boosted	Boost Ads	\N	1.00	todo	\N	\N	\N	2026-04-17 07:34:41.260377+00
246	36	3	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
247	36	3	script	Script	\N	2.00	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
248	36	3	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
249	36	3	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-17 08:11:05.155077+00
266	38	5	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 06:33:35.271067+00
267	39	5	ideas	Idéation	\N	1.00	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
268	39	5	script	Script	\N	2.00	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
269	39	5	shooting	Tournage	\N	4.00	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
270	39	5	editing	Montage	\N	3.00	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
271	39	5	ready	Ready to Post	\N	0.50	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
272	39	5	posted	Publication	\N	0.50	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
273	39	5	boosted	Boost Ads	\N	1.00	todo	\N	\N	\N	2026-04-22 06:36:42.20109+00
274	40	5	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
275	40	5	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
276	40	5	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
277	40	5	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
278	40	5	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
279	40	5	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
280	40	5	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 06:38:53.163795+00
281	41	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
282	41	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
283	41	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
284	41	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
285	41	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
286	41	3	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
287	41	3	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 18:03:18.739+00
288	42	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
289	42	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
290	42	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
291	42	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
292	42	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
293	42	3	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
294	42	3	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 18:07:22.744368+00
295	43	3	ideas	Idéation	1	1.00	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
296	43	3	script	Script	1	2.00	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
297	43	3	shooting	Tournage	1	4.00	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
298	43	3	editing	Montage	1	3.00	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
299	43	3	ready	Ready to Post	1	0.50	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
300	43	3	posted	Publication	1	0.50	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
301	43	3	boosted	Boost Ads	1	1.00	todo	\N	\N	\N	2026-04-22 18:10:08.232708+00
\.


--
-- Data for Name: invoice_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_items (id, invoice_id, description, quantity, unit_price, total, sort_order) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (id, quote_id, client_id, invoice_number, title, status, issue_date, due_date, notes, subtotal, tax_rate, total, paid_amount, paid_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leads (id, company, contact_name, phone, email, source, status, estimated_mrr, service_type, probability, close_date, owner_id, next_action_date, notes, created_at, updated_at) FROM stdin;
2	Thymos Holding	Monia Tamrani	+23052502269	monia@thymosholding.com	referral	new	\N	TikTok	50	\N	\N	\N		2026-04-04 11:42:00.298122+00	2026-04-04 11:42:00.298122+00
3	Bagnodesign Mauritius	Anwar Sohawon 	+971 56 6982676		referral	qualified	\N		50	\N	\N	2026-04-16		2026-04-09 05:17:40.984826+00	2026-04-09 05:17:53.187679+00
1	Minimelts	Romans	+230 5513 0033	romans@minimelts.mu	referral	lost	32000.00	Full Package	50	\N	2	2026-03-30	Vu pour un package Growth de 32,000 MUR + informer qu'on peut passer a 55,000 MUR pour ++ de contenu et un reshare sur les plateformes Meta. \n\nPas le bon moment. 	2026-03-23 11:27:40.650345+00	2026-04-22 05:21:46.652764+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, type, title, body, link, read, target_member_id, created_at) FROM stdin;
1	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-03-30 14:47:35.500467+00
2	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-02 12:09:32.947156+00
3	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-04 07:13:20.624718+00
32	shoot_tomorrow	🎬 Tournage demain	Ava Beach · Mise en scène Interview	/business.html	f	\N	2026-04-16 07:43:56.421927+00
12	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-06 17:27:19.804103+00
33	shoot_tomorrow	🎬 Tournage demain	Polytol  Paints · Quicaillerie Grand Baie	/business.html	f	\N	2026-04-16 07:43:56.425643+00
9	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Aesthetic lieu	/business.html	t	\N	2026-04-06 09:22:13.187862+00
4	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-05 14:37:43.832293+00
5	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Vidéo Pool Party	/business.html	t	\N	2026-04-05 14:59:54.685725+00
6	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Bluberry Matcha	/business.html	t	\N	2026-04-06 05:49:08.196593+00
7	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Afterwork	/business.html	t	\N	2026-04-06 05:57:08.175352+00
8	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Pool Party Voix off	/business.html	t	\N	2026-04-06 06:03:08.390534+00
10	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Client UGC	/business.html	t	\N	2026-04-06 09:22:13.225499+00
11	shoot_tomorrow	🎬 Tournage demain	Ava Bistrot Tamarin · Vidéo Pool Party	/business.html	t	\N	2026-04-06 17:27:19.792477+00
13	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-07 18:36:36.038233+00
14	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · Over the years	/business.html	t	\N	2026-04-08 00:07:00.142842+00
15	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · FinTech Robots	/business.html	t	\N	2026-04-08 00:07:00.148337+00
16	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · how to create a website in 2026	/business.html	t	\N	2026-04-08 00:07:00.151754+00
17	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · Steps Ouverture Magasin	/business.html	t	\N	2026-04-08 00:07:00.15891+00
18	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · Day in my life	/business.html	t	\N	2026-04-08 00:07:00.163603+00
19	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · A day in my life - curepipe edition	/business.html	t	\N	2026-04-08 00:07:00.166739+00
20	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-08 19:00:17.484706+00
21	shoot_tomorrow	🎬 Tournage demain	Ava Beach · Mise en scène Interview	/business.html	t	\N	2026-04-09 05:11:27.205896+00
22	shoot_tomorrow	🎬 Tournage demain	Ava Beach · From morning to night	/business.html	t	\N	2026-04-09 05:11:27.218276+00
23	shoot_tomorrow	🎬 Tournage demain	La Rivière Restaurant · Food by the pool while it's still summer	/business.html	t	\N	2026-04-09 05:11:27.221745+00
24	shoot_tomorrow	🎬 Tournage demain	Ava Beach · Voix off Amberine	/business.html	t	\N	2026-04-09 05:11:27.225484+00
25	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-09 19:06:40.415523+00
26	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	t	\N	2026-04-11 08:02:31.329299+00
27	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-12 09:20:53.661474+00
28	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-13 11:37:25.370945+00
29	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · Come Shopping with me	/business.html	f	\N	2026-04-15 04:46:30.63025+00
30	shoot_tomorrow	🎬 Tournage demain	MIPS IT Digital · The beauty of the center	/business.html	f	\N	2026-04-15 04:46:30.637096+00
31	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-15 04:46:30.64627+00
34	shoot_tomorrow	🎬 Tournage demain	Polytol  Paints · Grand Baie - house reno	/business.html	f	\N	2026-04-16 07:43:56.42771+00
35	shoot_tomorrow	🎬 Tournage demain	Polytol  Paints · Fabrication peinture	/business.html	f	\N	2026-04-16 07:43:56.429956+00
36	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-16 07:43:56.435813+00
37	lead_followup	📞 Suivi lead	Relancer Bagnodesign Mauritius	/business.html	f	\N	2026-04-16 07:43:56.439114+00
38	task_due	📋 Tâche en retard	MIPS IT Digital · script · Day in my life	/business.html	f	\N	2026-04-17 07:02:48.697108+00
39	task_due	📋 Tâche en retard	MIPS IT Digital · script · The beauty of the center	/business.html	f	\N	2026-04-17 07:02:48.700737+00
40	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-17 07:44:51.707044+00
41	lead_followup	📞 Suivi lead	Relancer Bagnodesign Mauritius	/business.html	f	\N	2026-04-17 07:44:51.710363+00
42	task_due	📋 Tâche en retard	MIPS IT Digital · script · Day in my life	/business.html	f	\N	2026-04-18 07:04:27.499202+00
43	task_due	📋 Tâche en retard	MIPS IT Digital · script · The beauty of the center	/business.html	f	\N	2026-04-18 07:04:27.503047+00
44	task_due	📋 Tâche en retard	MIPS IT Digital · script · Day in my life	/business.html	f	\N	2026-04-21 09:53:57.983414+00
45	task_due	📋 Tâche en retard	MIPS IT Digital · script · The beauty of the center	/business.html	f	\N	2026-04-21 09:53:57.98654+00
46	lead_followup	📞 Suivi lead	Relancer Minimelts	/business.html	f	\N	2026-04-21 09:53:57.990962+00
47	lead_followup	📞 Suivi lead	Relancer Bagnodesign Mauritius	/business.html	f	\N	2026-04-21 09:53:57.993242+00
48	task_due	📋 Tâche en retard	MIPS IT Digital · script · Day in my life	/business.html	f	\N	2026-04-22 10:05:38.896148+00
49	task_due	📋 Tâche en retard	MIPS IT Digital · script · The beauty of the center	/business.html	f	\N	2026-04-22 10:05:38.900413+00
50	lead_followup	📞 Suivi lead	Relancer Bagnodesign Mauritius	/business.html	f	\N	2026-04-22 10:05:38.90378+00
51	shoot_tomorrow	🎬 Tournage demain	La Rivière Restaurant · LR: Indication depuis le Sud	/business.html	f	\N	2026-04-22 18:05:42.4401+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, invoice_id, client_id, amount, method, reference, paid_at, notes, created_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, description, category, unit_price, unit, active, sort_order, created_at) FROM stdin;
1	Mazine – TikTok Starter Package	6 monthly TikTok deliverables including 4 brand universe videos, 1 carousel and 1 authority video (face-to-camera or voice-over). Includes up to 3 hours of shooting, 1 production session, caption strategy, posting and monthly performance snapshot. Designed for consistent content presence and brand visibility on TikTok.	Service	19000.00	mois	t	0	2026-03-24 15:37:47.272667+00
2	Mazine – TikTok Growth Package	8 monthly deliverables including 4 brand universe videos, 2 strategic carousels and 2 authority videos. Includes up to 5 hours of shooting, up to 2 production sessions, content optimization and monthly strategic performance review. Designed to build authority and drive measurable growth on TikTok.	Service	32000.00	mois	t	0	2026-03-24 15:38:09.120869+00
3	Mazine – TikTok Performance Package	13 monthly deliverables including brand universe videos, carousels and 6 authority videos. Includes up to 8 hours of shooting, up to 3 production sessions, advanced content optimization and full strategic performance review with engagement and retention analysis. Designed to scale content production and dominate TikTok presence.	Service	50000.00	mois	t	0	2026-03-24 15:38:38.530491+00
5	Advanced Revenue & Performance Analytics	Cross-analysis between TikTok engagement and sales performance including attribution insights and strategic recommendations.	Stratégie	7000.00	mois	t	0	2026-03-24 15:41:16.090046+00
6	Multi-Platform Content Usage	Rights to reuse and adapt TikTok content across additional platforms including Instagram, Facebook and other social media channels. Includes format optimization and platform-specific adjustments.	Add-On	5000.00	mois	t	0	2026-03-24 15:41:41.049483+00
7	Professional Photography Pack	15 professionally shot and edited images with creative direction and professional equipment.	Add-On	10000.00	session	t	0	2026-03-24 15:42:13.775839+00
8	Professional Camera Upgrade	Upgrade from smartphone to professional camera equipment for higher production quality.	Add-On	5000.00	mois	t	0	2026-03-24 15:42:44.246277+00
9	Content Strategy Sprint	TikTok content strategy workshop including positioning, content pillars, hooks framework and 30-day content roadmap.	Stratégie	8500.00	session	t	0	2026-03-24 15:43:54.392634+00
10	Scriptwriting & Hooks Optimization	Scriptwriting & Hooks Optimization	Service	4000.00	mois	t	0	2026-03-24 15:44:26.638823+00
11	Priority Delivery	Priority production and faster turnaround on content delivery and revisions.	Add-On	4000.00	vidéo	t	0	2026-03-24 15:45:01.932806+00
12	Extra Production Session	Additional on-site production session beyond package limits.	Production	3000.00	vidéo	t	0	2026-03-24 15:46:05.543126+00
4	Additional Face-to-Camera / Voice-Over Video	Additional authority-format video including scripting, shooting and editing. Recommended for conversion-focused or positioning content.	Production	3500.00	vidéo	t	0	2026-03-24 15:39:07.441288+00
\.


--
-- Data for Name: quote_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quote_items (id, quote_id, description, quantity, unit_price, total, sort_order) FROM stdin;
67	1	Brand Universe Videos	4.00	2000.00	8000.00	0
68	1	Strategic Caroussel	2.00	1500.00	3000.00	1
69	1	Conversion-Focused Authority Videos (Face-to-Camera / Voice- Over)	2.00	4000.00	8000.00	2
70	1	On-site shooting (hours)	5.00	1500.00	7500.00	3
71	1	Publishing & Optimization	1.00	2500.00	2500.00	4
72	1	Strategic Performance Review	1.00	3000.00	3000.00	5
\.


--
-- Data for Name: quotes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quotes (id, lead_id, client_id, quote_number, title, status, valid_until, notes, subtotal, tax_rate, total, created_by, created_at, updated_at, subtitle) FROM stdin;
1	1	\N	DEV-2026-001	TikTok Content - Growth Package (Minimum Engagement: 3 Months)	draft	2026-04-15	- 1 revision round per video included\n- Any additional revisions will be billed separately\n- Client validation (scripts, edits, content) must be provided within 48 hours to maintain the agreed posting schedule\n- Delays in validation may impact delivery timelines and content calendar\n\nTalent & Voice-Over: Voice-over recordings and on-screen talent are not included in the package\n\nIf required, the following fees will apply:\n- Voice-Over Production: from 2,000 MUR per video\n- On-Screen Talent (Figurant): 1,500 MUR per hour\n--ADDONS--\n- Additional Authority Video: 3,500 MUR per video\n- Community Management: 3,000 MUR / month\n- Advanced Revenue & Performance Analytics: 7,000 MUR / month\n- Multi-Platform Repurposing: 3,500 MUR / month\n- Professional Photography Pack: 10,000 MUR\n- Professional Camera Upgrade: 5,000 MUR / month	32000.00	0.00	32000.00	\N	2026-03-23 11:45:49.862118+00	2026-04-11 11:49:11.705194+00	
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reports (id, client_id, month_key, ai_result, created_at, updated_at) FROM stdin;
1	1	all	{"videos": [{"rank": 1, "format": "Vidéo de démonstration produit", "pourquoi": "Bonne utilisation des hashtags locaux pertinents et démonstration visuelle attrayante"}], "synthese": "Durant la période analysée, le compte TikTok a généré 1.3M vues avec une augmentation notable des abonnés (+193.0%). L'engagement global est de 4.3% sur 15 vidéos publiées, reflétant une bonne interaction avec l'audience.", "diagnostic": {"points_forts": ["Croissance des abonnés de 10.0K depuis le partenariat", "Performances élevées de la vidéo \\"are you planning to do redo your floors\\" avec 657.3K vues", "Engagement moyen solide de 4.3%"], "points_amelioration": ["Améliorer le taux de viralité global", "Augmenter le nombre de partages sur les vidéos ayant moins de viralité"]}, "recommandations": ["Renforcer l'utilisation des hashtags locaux pour augmenter la portée", "Expérimenter des collaborations avec des influenceurs locaux", "Optimiser les heures de publication pour les soirs, conformément aux habitudes mauriciennes", "Augmenter l'interactivité par des appels à l'action clairs"], "analyse_viralite": "Le ratio partages/vues de 1.01% indique une diffusion correcte mais peut être amélioré pour atteindre une audience plus large. Les vidéos avec une bonne viralité, comme la deuxième, montrent le potentiel en exploitant des accroches efficaces.", "brief_prochain_contenu": {"a_eviter": "Contenus sans lien direct avec les préférences locales", "accroche_type": "Question engageante", "angle_prioritaire": "Promotions et événements locaux", "format_recommande": "Courtes démonstrations pratiques"}}	2026-03-20 18:51:34.073524+00	2026-03-20 18:51:34.073524+00
2	1	2026-03	{"videos": [{"rank": 1, "format": "Tuto DIY", "pourquoi": "Utilisation de hashtags spécifiques et tendance du bricolage"}], "synthese": "En mars 2026, le compte a enregistré 60.9K vues et une croissance de 237 abonnés, portant le total à 15.2K abonnés. Depuis le début du partenariat avec Mazine, les abonnés ont augmenté de 193%, démontrant un impact significatif de la stratégie déployée.", "diagnostic": {"points_forts": ["Vidéo 'are you planning to do redo your floors?' a généré 657.3K vues", "Taux d'engagement global à 4.3%", "Croissance des abonnés de +193% depuis le partenariat avec Mazine"], "points_amelioration": ["Améliorer la viralité générale (actuellement à 1.01%)", "Augmenter le nombre de partages (actuellement à 323)"]}, "recommandations": ["Augmenter l'incitation à partager dans les vidéos", "Continuer à exploiter les tendances locales et hashtags spécifiques", "Publier pendant les pics d'activité en soirée", "Explorer des collaborations avec des influenceurs locaux"], "analyse_viralite": "Le ratio de partages par vue reste faible avec une viralité à 1.01%. Une optimisation des incitations à partager pourrait améliorer ce taux.", "brief_prochain_contenu": {"a_eviter": "Contenu promotionnel simple", "accroche_type": "Question engageante", "angle_prioritaire": "Contenu éducatif et pratique", "format_recommande": "Tutoriel"}}	2026-03-20 18:52:54.67128+00	2026-03-20 18:52:54.67128+00
3	1	2025-12	{"videos": [{"rank": 1, "format": "Tutoriel produit", "pourquoi": "Contenu informatif avec une démonstration claire"}], "synthese": "En décembre 2025, le total des vues atteint 396.7K, avec un engagement moyen de 4.3%. Depuis le début du partenariat avec Mazine en octobre, les abonnés ont bondi de 10.0K, atteignant 15.2K, soit une croissance de 193.0%.", "diagnostic": {"points_forts": ["Hausse significative des abonnés depuis oct (+193%)", "Viralité la plus élevée sur la vidéo #2 à 1.54%", "Engagement élevé sur le contenu promotionnel local"], "points_amelioration": ["Augmenter la fréquence des publications à haute viralité", "Améliorer l'utilisation des tendances TikTok pour augmenter la viralité"]}, "recommandations": ["Intégrer plus d'appels à l'action dans les vidéos", "Utiliser des influenceurs locaux pour accroître la portée", "Expérimenter avec du contenu généré par les utilisateurs", "Optimiser les publications pour les pics d'activité en soirée"], "analyse_viralite": "Le ratio partages/vues est faible, suggérant une opportunité d'amélioration en augmentant les incitations au partage. La vidéo #2 a un bon score de viralité grâce à son appel à l'action clair.", "brief_prochain_contenu": {"a_eviter": "Vidéos sans appel à l'action clair", "accroche_type": "Appel émotionnel fort", "angle_prioritaire": "Promotions locales et événements saisonniers", "format_recommande": "Tutoriel produit"}}	2026-03-21 07:09:46.037034+00	2026-03-21 07:09:46.037034+00
4	1	2025-08	{"videos": [{"rank": 1, "format": "DIY & tutoriels", "pourquoi": "Contenu utile et pratique qui capte l'intérêt et génère des visites répétées."}], "synthese": "En août 2025, notre compte TikTok a totalisé 6.4K vues, 133 likes, et 8 partages à travers 15 vidéos. Le taux d'engagement s'élève à 4.3% avec une viralité de 1.01%. Nous avons gagné 10.0K abonnés, augmentant notre total à 15.2K (+193.0%).", "diagnostic": {"points_forts": ["Augmentation significative du nombre d'abonnés.", "Contenu de niche bien ciblé améliorant le taux d'engagement.", "Top vidéos avec des vues supérieures à 100K."], "points_amelioration": ["Augmenter le nombre de partages pour améliorer la viralité.", "Optimiser les légendes pour maximiser les interactions."]}, "recommandations": ["Utiliser davantage de vidéos explicatives et tutoriels.", "Continuer à exploiter les hashtags tendance et segmentés.", "Collaborer avec des influenceurs pour accroître la portée.", "Inclure des appels à l'action clairs pour inciter au partage et à l'engagement."], "analyse_viralite": "Les vidéos axées sur des sujets spécifiques comme l'aménagement et les rénovations ont généré des vues impressionnantes. L'utilisation de hashtags pertinents a contribué à un meilleur engagement.", "brief_prochain_contenu": {"a_eviter": "Éviter les vidéos trop longues sans valeur ajoutée.", "accroche_type": "Questions engageantes ou défis liés à la rénovation.", "angle_prioritaire": "Focus sur les solutions pratiques pour la maison.", "format_recommande": "Vidéo courte et dynamique avec une démonstration."}}	2026-03-25 13:36:20.996756+00	2026-03-25 13:36:20.996756+00
5	1	2025-06	{"videos": [{"rank": 1, "format": "Instructionnel", "pourquoi": "Le contenu informatif et pratique sur la rénovation des sols a capté l'attention d'un large public, poussant à l'engagement et aux vues élevées."}], "synthese": "En juin 2025, Mazine.mu a généré 16.7K vues, 378 likes et 30 partages sur TikTok à travers 15 vidéos, avec un taux d'engagement de 4.3% et une viralité de 1.01%. Le nombre d'abonnés est passé de 5.2K à 15.2K, marquant une augmentation significative de 193.0%.", "diagnostic": {"points_forts": ["La vidéo 'are you planning to do redo your floors?' a généré un impact considérable avec ses 657.3K vues.", "Taux d'engagement supérieur à 5% sur plusieurs vidéos, indiquant une bonne interaction.", "Croissance notable du nombre d'abonnés, témoignant de l'attrait des contenus."], "points_amelioration": ["Améliorer la viralité globale des vidéos pour dépasser le 1.01%.", "Augmenter le nombre de partages pour accroître la portée organique."]}, "recommandations": ["Produire plus de contenus axés sur le bricolage et la résolution de problèmes quotidiens.", "Intégrer des appels à l'action clairs pour encourager le partage.", "Analyser les commentaires pour identifier des thèmes et questions populaires.", "Utiliser des hashtags spécifiques pour atteindre des audiences ciblées."], "analyse_viralite": "La vidéo 'are you planning to do redo your floors?' a largement contribué à la visibilité du profil, avec un nombre élevé de vues par rapport aux autres vidéos. Cependant, le taux de partage reste une opportunité d'amélioration pour renforcer l'impact des campagnes futures.", "brief_prochain_contenu": {"a_eviter": "Contenus trop généralistes sans valeur ajoutée pratique.", "accroche_type": "Questions engageantes ou défis pour inciter à l'engagement.", "angle_prioritaire": "Mettre l'accent sur des contenus DIY et informatifs qui démontrent des solutions simples à des problèmes communs.", "format_recommande": "Tutoriels vidéo"}}	2026-03-25 14:36:33.751621+00	2026-03-25 14:36:33.751621+00
7	5	all	{"videos": [{"rank": 1, "format": "Utilisation des hashtags ciblant des lieux spécifiques", "pourquoi": "Les hashtags centrés sur un lieu spécifique comme 'Trou aux Biches' ont généré une plus grande audience."}], "synthese": "Durant cette période, nous avons atteint un total de 402.8K vues sur 15 vidéos publiées, avec un taux d'engagement général de 7.9% et un taux de viralité de 1.46%. Les abonnés ont augmenté pour atteindre un total de 2.6K.", "diagnostic": {"points_forts": ["Contenu lié aux nouveaux restaurants attire particulièrement l'attention.", "Le taux d'engagement est généralement bon, notamment avec des vidéos spécifiques dépassant 8%.", "Augmentation régulière des abonnés sur la période."], "points_amelioration": ["Améliorer la cohérence du taux d'engagement sur toutes les vidéos.", "Explorer de nouveaux angles de narration pour élargir l'audience."]}, "recommandations": ["Capitaliser sur les vidéos qui montrent de nouveaux lieux à Maurice pour attirer la curiosité.", "Augmenter la fréquence des publications pour maintenir l'engagement.", "Utiliser des collaborations avec des influenceurs locaux pour élargir l'audience.", "Essayer d'intégrer des appels à l'action clairs pour encourager plus d'interaction."], "analyse_viralite": "Le taux de viralité de 1.46% indique que nos vidéos sont principalement vues par notre audience existante. Pour augmenter le potentiel viral, il pourrait être bénéfique de se concentrer sur des tendances locales et des hashtags plus populaires.", "brief_prochain_contenu": {"a_eviter": "Contenus trop génériques sans valeur ajoutée locale.", "accroche_type": "Des accroches engageantes autour de nouvelles ouvertures ou événements uniques.", "angle_prioritaire": "Présenter de nouveaux lieux et événements à Maurice.", "format_recommande": "Vidéo immersive avec un appel à l'action fort."}}	2026-04-04 11:25:04.053097+00	2026-04-04 11:25:04.053097+00
8	1	2025-10	{"videos": [{"rank": 1, "format": "promotion de produit", "pourquoi": "Le sujet de la rénovation des sols a suscité un grand intérêt et un engagement élevé, indiquant un besoin ou une tendance chez le public cible."}], "synthese": "En octobre 2025, Mazine.mu a généré un total de 41.8K vues et 1.3K likes sur TikTok, répartis sur 15 vidéos. Le taux d'engagement moyen était de 4.3%, avec une viralité de 1.01%. Le nombre d'abonnés a considérablement augmenté de 5.2K à 15.2K, soit une croissance de 193%.", "diagnostic": {"points_forts": ["Croissance significative du nombre d'abonnés", "Haut niveau d'engagement sur la vidéo 'Trouv nou waterproofing'", "Utilisation efficace des hashtags spécifiques à la niche"], "points_amelioration": ["Augmenter la diversité des formats vidéo", "Améliorer la cohérence des publications"]}, "recommandations": ["Diversifiez les sujets pour inclure des solutions écologiques et des astuces DIY.", "Collaborez avec des influenceurs locaux pour atteindre de nouveaux publics.", "Augmentez la fréquence de publication pour maintenir l'engagement du public.", "Utilisez des effets et des tendances TikTok actuelles pour rester pertinent."], "analyse_viralite": "La vidéo 'are you planning to do redo your floors?' a été particulièrement virale avec 657.3K vues, contribuant grandement à la viralité globale. Cependant, se concentrer davantage sur des sujets variés pourrait augmenter encore la portée.", "brief_prochain_contenu": {"a_eviter": "Évitez de surcharger la vidéo avec trop de hashtags génériques", "accroche_type": "Posez une question engageante ou provocatrice", "angle_prioritaire": "Mettez l'accent sur les solutions innovantes pour l'amélioration de la maison", "format_recommande": "Tutoriels vidéo courts et démonstrations"}}	2026-04-08 11:57:54.225542+00	2026-04-08 11:57:54.225542+00
6	1	2026-01	{"videos": [{"rank": 1, "format": "Home Improvement", "pourquoi": "Intérêt marqué pour les projets de rénovation domiciliaire et tags bien utilisés"}], "synthese": "En février 2026, Mazine.mu a généré 120.2K vues avec 15 vidéos. L'engagement moyen s'élève à 4.3%, avec une viralité de 1.01%. Les abonnés ont augmenté de 193.0% depuis le début, passant de 5.2K à 15.2K.", "diagnostic": {"points_forts": ["Croissance rapide du nombre d'abonnés", "Vidéo virale sur le thème des revêtements de sol", "Engagement supérieur à 5% sur la vidéo waterproofing"], "points_amelioration": ["Augmenter la viralité globale", "Amplifier la présence de l'accroche 'ProtezeZotLakaz' pour mieux capter l'intérêt"]}, "recommandations": ["Créer des vidéos avec plus d'éléments visuels engageants", "Exploiter les moments saisonniers pour plus de pertinence", "Utiliser des collaborations pour élargir la portée", "Optimiser l'utilisation des hashtags pour augmenter la découvrabilité"], "analyse_viralite": "Bien que la vidéo sur les revêtements de sol ait obtenu 657.3K vues, la viralité globale est limitée à 1.01%. Améliorer la stratégie d’accroche et diversifier le contenu pourrait augmenter la viralité des futures publications.", "brief_prochain_contenu": {"a_eviter": "Contenu trop technique sans valeur ajoutée visuelle", "accroche_type": "Conseils pratiques avec hashtags pertinents", "angle_prioritaire": "Mise en avant des produits d'amélioration de l'habitat", "format_recommande": "Tutoriels vidéo et démonstrations"}}	2026-03-26 06:20:37.985032+00	2026-04-17 07:14:40.613457+00
\.


--
-- Data for Name: task_defaults; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.task_defaults (stage, label, emoji, default_hours, sort_order) FROM stdin;
ideas	Idéation	💡	1.00	1
script	Script	✍	2.00	2
shooting	Tournage	🎬	4.00	3
editing	Montage	🎞	3.00	4
ready	Ready to Post	📲	0.50	5
posted	Publication	📈	0.50	6
boosted	Boost Ads	🔥	1.00	7
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.team_members (id, name, role, hourly_rate, color, active, created_at) FROM stdin;
1	Amberine Sohawon	Directrice Artistique	1500.00	#df96b3	t	2026-03-23 10:44:47.33485+00
2	Victor Bohbot	Directeur des Technologies	1500.00	#949eeb	t	2026-03-23 10:45:03.629614+00
\.


--
-- Data for Name: tiktok_activity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_activity (client_id, date, hour, active_followers, updated_at) FROM stdin;
1	2026-03-12	0	1833	2026-03-20 12:52:36.37106+00
1	2026-03-12	1	1061	2026-03-20 12:52:36.37106+00
1	2026-03-12	2	654	2026-03-20 12:52:36.37106+00
1	2026-03-12	3	537	2026-03-20 12:52:36.37106+00
1	2026-03-12	4	950	2026-03-20 12:52:36.37106+00
1	2026-03-12	5	1535	2026-03-20 12:52:36.37106+00
1	2026-03-12	6	2222	2026-03-20 12:52:36.37106+00
1	2026-03-12	7	3053	2026-03-20 12:52:36.37106+00
1	2026-03-12	8	3080	2026-03-20 12:52:36.37106+00
1	2026-03-12	9	3133	2026-03-20 12:52:36.37106+00
1	2026-03-12	10	3055	2026-03-20 12:52:36.37106+00
1	2026-03-12	11	3175	2026-03-20 12:52:36.37106+00
1	2026-03-12	12	3599	2026-03-20 12:52:36.37106+00
1	2026-03-12	13	3547	2026-03-20 12:52:36.37106+00
1	2026-03-12	14	3543	2026-03-20 12:52:36.37106+00
1	2026-03-12	15	3621	2026-03-20 12:52:36.37106+00
1	2026-03-12	16	3658	2026-03-20 12:52:36.37106+00
1	2026-03-12	17	3728	2026-03-20 12:52:36.37106+00
1	2026-03-12	18	3753	2026-03-20 12:52:36.37106+00
1	2026-03-12	19	4316	2026-03-20 12:52:36.37106+00
1	2026-03-12	20	4491	2026-03-20 12:52:36.37106+00
1	2026-03-12	21	4655	2026-03-20 12:52:36.37106+00
1	2026-03-12	22	4237	2026-03-20 12:52:36.37106+00
1	2026-03-12	23	3204	2026-03-20 12:52:36.37106+00
1	2026-03-13	0	1991	2026-03-20 12:52:36.37106+00
1	2026-03-13	1	1132	2026-03-20 12:52:36.37106+00
1	2026-03-13	2	735	2026-03-20 12:52:36.37106+00
1	2026-03-13	3	607	2026-03-20 12:52:36.37106+00
1	2026-03-13	4	1033	2026-03-20 12:52:36.37106+00
1	2026-03-13	5	1476	2026-03-20 12:52:36.37106+00
1	2026-03-13	6	1907	2026-03-20 12:52:36.37106+00
1	2026-03-13	7	3013	2026-03-20 12:52:36.37106+00
1	2026-03-13	8	3295	2026-03-20 12:52:36.37106+00
1	2026-03-13	9	3428	2026-03-20 12:52:36.37106+00
1	2026-03-13	10	3313	2026-03-20 12:52:36.37106+00
1	2026-03-13	11	3354	2026-03-20 12:52:36.37106+00
1	2026-03-13	12	3525	2026-03-20 12:52:36.37106+00
1	2026-03-13	13	3731	2026-03-20 12:52:36.37106+00
1	2026-03-13	14	3710	2026-03-20 12:52:36.37106+00
1	2026-03-13	15	3667	2026-03-20 12:52:36.37106+00
1	2026-03-13	16	3658	2026-03-20 12:52:36.37106+00
1	2026-03-13	17	3687	2026-03-20 12:52:36.37106+00
1	2026-03-13	18	3646	2026-03-20 12:52:36.37106+00
1	2026-03-13	19	4140	2026-03-20 12:52:36.37106+00
1	2026-03-13	20	4209	2026-03-20 12:52:36.37106+00
1	2026-03-13	21	4372	2026-03-20 12:52:36.37106+00
1	2026-03-13	22	4202	2026-03-20 12:52:36.37106+00
1	2026-03-13	23	3293	2026-03-20 12:52:36.37106+00
1	2026-03-14	0	2271	2026-03-20 12:52:36.37106+00
1	2026-03-14	1	1370	2026-03-20 12:52:36.37106+00
1	2026-03-14	2	848	2026-03-20 12:52:36.37106+00
1	2026-03-14	3	627	2026-03-20 12:52:36.37106+00
1	2026-03-14	4	948	2026-03-20 12:52:36.37106+00
1	2026-03-14	5	1368	2026-03-20 12:52:36.37106+00
1	2026-03-14	6	1649	2026-03-20 12:52:36.37106+00
1	2026-03-14	7	2675	2026-03-20 12:52:36.37106+00
1	2026-03-14	8	3060	2026-03-20 12:52:36.37106+00
1	2026-03-14	9	3447	2026-03-20 12:52:36.37106+00
1	2026-03-14	10	3432	2026-03-20 12:52:36.37106+00
1	2026-03-14	11	3392	2026-03-20 12:52:36.37106+00
1	2026-03-14	12	3550	2026-03-20 12:52:36.37106+00
1	2026-03-14	13	3769	2026-03-20 12:52:36.37106+00
1	2026-03-14	14	3848	2026-03-20 12:52:36.37106+00
1	2026-03-14	15	3857	2026-03-20 12:52:36.37106+00
1	2026-03-14	16	3821	2026-03-20 12:52:36.37106+00
1	2026-03-14	17	3788	2026-03-20 12:52:36.37106+00
1	2026-03-14	18	3698	2026-03-20 12:52:36.37106+00
1	2026-03-14	19	4297	2026-03-20 12:52:36.37106+00
1	2026-03-14	20	4478	2026-03-20 12:52:36.37106+00
1	2026-03-14	21	4759	2026-03-20 12:52:36.37106+00
1	2026-03-14	22	4226	2026-03-20 12:52:36.37106+00
1	2026-03-14	23	3062	2026-03-20 12:52:36.37106+00
1	2026-03-15	0	1717	2026-03-20 12:52:36.37106+00
1	2026-03-15	1	1021	2026-03-20 12:52:36.37106+00
1	2026-03-15	2	663	2026-03-20 12:52:36.37106+00
1	2026-03-15	3	521	2026-03-20 12:52:36.37106+00
1	2026-03-15	4	890	2026-03-20 12:52:36.37106+00
1	2026-03-15	5	1559	2026-03-20 12:52:36.37106+00
1	2026-03-15	6	2057	2026-03-20 12:52:36.37106+00
1	2026-03-15	7	3045	2026-03-20 12:52:36.37106+00
1	2026-03-15	8	3052	2026-03-20 12:52:36.37106+00
1	2026-03-15	9	3089	2026-03-20 12:52:36.37106+00
1	2026-03-15	10	3016	2026-03-20 12:52:36.37106+00
1	2026-03-15	11	3214	2026-03-20 12:52:36.37106+00
1	2026-03-15	12	3518	2026-03-20 12:52:36.37106+00
1	2026-03-15	13	3559	2026-03-20 12:52:36.37106+00
1	2026-03-15	14	3471	2026-03-20 12:52:36.37106+00
1	2026-03-15	15	3536	2026-03-20 12:52:36.37106+00
1	2026-03-15	16	3590	2026-03-20 12:52:36.37106+00
1	2026-03-15	17	3577	2026-03-20 12:52:36.37106+00
1	2026-03-15	18	3655	2026-03-20 12:52:36.37106+00
1	2026-03-15	19	4369	2026-03-20 12:52:36.37106+00
1	2026-03-15	20	4606	2026-03-20 12:52:36.37106+00
1	2026-03-15	21	4647	2026-03-20 12:52:36.37106+00
1	2026-03-15	22	4103	2026-03-20 12:52:36.37106+00
1	2026-03-15	23	2874	2026-03-20 12:52:36.37106+00
1	2026-03-16	0	1761	2026-03-20 12:52:36.37106+00
1	2026-03-16	1	1028	2026-03-20 12:52:36.37106+00
1	2026-03-16	2	601	2026-03-20 12:52:36.37106+00
1	2026-03-16	3	535	2026-03-20 12:52:36.37106+00
1	2026-03-16	4	920	2026-03-20 12:52:36.37106+00
1	2026-03-16	5	1571	2026-03-20 12:52:36.37106+00
1	2026-03-16	6	2174	2026-03-20 12:52:36.37106+00
1	2026-03-16	7	3100	2026-03-20 12:52:36.37106+00
1	2026-03-16	8	3076	2026-03-20 12:52:36.37106+00
1	2026-03-16	9	3158	2026-03-20 12:52:36.37106+00
1	2026-03-16	10	3109	2026-03-20 12:52:36.37106+00
1	2026-03-16	11	3193	2026-03-20 12:52:36.37106+00
1	2026-03-16	12	3592	2026-03-20 12:52:36.37106+00
1	2026-03-16	13	3575	2026-03-20 12:52:36.37106+00
1	2026-03-16	14	3532	2026-03-20 12:52:36.37106+00
1	2026-03-16	15	3639	2026-03-20 12:52:36.37106+00
1	2026-03-16	16	3581	2026-03-20 12:52:36.37106+00
1	2026-03-16	17	3635	2026-03-20 12:52:36.37106+00
1	2026-03-16	18	3755	2026-03-20 12:52:36.37106+00
1	2026-03-16	19	4462	2026-03-20 12:52:36.37106+00
1	2026-03-16	20	4551	2026-03-20 12:52:36.37106+00
1	2026-03-16	21	4813	2026-03-20 12:52:36.37106+00
1	2026-03-16	22	4301	2026-03-20 12:52:36.37106+00
1	2026-03-16	23	2998	2026-03-20 12:52:36.37106+00
1	2026-03-17	0	1821	2026-03-20 12:52:36.37106+00
1	2026-03-17	1	1095	2026-03-20 12:52:36.37106+00
1	2026-03-17	2	705	2026-03-20 12:52:36.37106+00
1	2026-03-17	3	549	2026-03-20 12:52:36.37106+00
1	2026-03-17	4	971	2026-03-20 12:52:36.37106+00
1	2026-03-17	5	1658	2026-03-20 12:52:36.37106+00
1	2026-03-17	6	2241	2026-03-20 12:52:36.37106+00
1	2026-03-17	7	3142	2026-03-20 12:52:36.37106+00
1	2026-03-17	8	3019	2026-03-20 12:52:36.37106+00
1	2026-03-17	9	3126	2026-03-20 12:52:36.37106+00
1	2026-03-17	10	3019	2026-03-20 12:52:36.37106+00
1	2026-03-17	11	3193	2026-03-20 12:52:36.37106+00
1	2026-03-17	12	3596	2026-03-20 12:52:36.37106+00
1	2026-03-17	13	3600	2026-03-20 12:52:36.37106+00
1	2026-03-17	14	3461	2026-03-20 12:52:36.37106+00
1	2026-03-17	15	3549	2026-03-20 12:52:36.37106+00
1	2026-03-17	16	3516	2026-03-20 12:52:36.37106+00
1	2026-03-17	17	3695	2026-03-20 12:52:36.37106+00
1	2026-03-17	18	3904	2026-03-20 12:52:36.37106+00
1	2026-03-17	19	4316	2026-03-20 12:52:36.37106+00
1	2026-03-17	20	4487	2026-03-20 12:52:36.37106+00
1	2026-03-17	21	4713	2026-03-20 12:52:36.37106+00
1	2026-03-17	22	4157	2026-03-20 12:52:36.37106+00
1	2026-03-17	23	3032	2026-03-20 12:52:36.37106+00
1	2026-03-18	0	2018	2026-03-20 12:52:36.37106+00
1	2026-03-18	1	1280	2026-03-20 12:52:36.37106+00
1	2026-03-18	2	840	2026-03-20 12:52:36.37106+00
1	2026-03-18	3	607	2026-03-20 12:52:36.37106+00
1	2026-03-18	4	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	5	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	6	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	7	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	8	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	9	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	10	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	11	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	12	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	13	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	14	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	15	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	16	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	17	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	18	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	19	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	20	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	21	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	22	0	2026-03-20 12:52:36.37106+00
1	2026-03-18	23	0	2026-03-20 12:52:36.37106+00
5	2026-03-27	0	506	2026-04-04 11:24:02.693201+00
5	2026-03-27	1	309	2026-04-04 11:24:02.693201+00
5	2026-03-27	2	183	2026-04-04 11:24:02.693201+00
5	2026-03-27	3	126	2026-04-04 11:24:02.693201+00
5	2026-03-27	4	112	2026-04-04 11:24:02.693201+00
5	2026-03-27	5	186	2026-04-04 11:24:02.693201+00
5	2026-03-27	6	410	2026-04-04 11:24:02.693201+00
5	2026-03-27	7	676	2026-04-04 11:24:02.693201+00
5	2026-03-27	8	774	2026-04-04 11:24:02.693201+00
5	2026-03-27	9	832	2026-04-04 11:24:02.693201+00
5	2026-03-27	10	814	2026-04-04 11:24:02.693201+00
5	2026-03-27	11	792	2026-04-04 11:24:02.693201+00
5	2026-03-27	12	814	2026-04-04 11:24:02.693201+00
5	2026-03-27	13	846	2026-04-04 11:24:02.693201+00
5	2026-03-27	14	899	2026-04-04 11:24:02.693201+00
5	2026-03-27	15	926	2026-04-04 11:24:02.693201+00
5	2026-03-27	16	898	2026-04-04 11:24:02.693201+00
5	2026-03-27	17	880	2026-04-04 11:24:02.693201+00
5	2026-03-27	18	857	2026-04-04 11:24:02.693201+00
5	2026-03-27	19	862	2026-04-04 11:24:02.693201+00
5	2026-03-27	20	921	2026-04-04 11:24:02.693201+00
5	2026-03-27	21	1014	2026-04-04 11:24:02.693201+00
5	2026-03-27	22	955	2026-04-04 11:24:02.693201+00
5	2026-03-27	23	784	2026-04-04 11:24:02.693201+00
5	2026-03-28	0	575	2026-04-04 11:24:02.693201+00
5	2026-03-28	1	375	2026-04-04 11:24:02.693201+00
5	2026-03-28	2	225	2026-04-04 11:24:02.693201+00
5	2026-03-28	3	134	2026-04-04 11:24:02.693201+00
5	2026-03-28	4	93	2026-04-04 11:24:02.693201+00
5	2026-03-28	5	144	2026-04-04 11:24:02.693201+00
5	2026-03-28	6	333	2026-04-04 11:24:02.693201+00
5	2026-03-28	7	613	2026-04-04 11:24:02.693201+00
5	2026-03-28	8	725	2026-04-04 11:24:02.693201+00
5	2026-03-28	9	834	2026-04-04 11:24:02.693201+00
5	2026-03-28	10	825	2026-04-04 11:24:02.693201+00
5	2026-03-28	11	804	2026-04-04 11:24:02.693201+00
5	2026-03-28	12	852	2026-04-04 11:24:02.693201+00
5	2026-03-28	13	905	2026-04-04 11:24:02.693201+00
5	2026-03-28	14	927	2026-04-04 11:24:02.693201+00
5	2026-03-28	15	915	2026-04-04 11:24:02.693201+00
5	2026-03-28	16	895	2026-04-04 11:24:02.693201+00
5	2026-03-28	17	923	2026-04-04 11:24:02.693201+00
5	2026-03-28	18	991	2026-04-04 11:24:02.693201+00
5	2026-03-28	19	1039	2026-04-04 11:24:02.693201+00
5	2026-03-28	20	1096	2026-04-04 11:24:02.693201+00
5	2026-03-28	21	1151	2026-04-04 11:24:02.693201+00
5	2026-03-28	22	1053	2026-04-04 11:24:02.693201+00
5	2026-03-28	23	766	2026-04-04 11:24:02.693201+00
5	2026-03-29	0	440	2026-04-04 11:24:02.693201+00
5	2026-03-29	1	233	2026-04-04 11:24:02.693201+00
5	2026-03-29	2	125	2026-04-04 11:24:02.693201+00
5	2026-03-29	3	94	2026-04-04 11:24:02.693201+00
5	2026-03-29	4	97	2026-04-04 11:24:02.693201+00
5	2026-03-29	5	210	2026-04-04 11:24:02.693201+00
5	2026-03-29	6	507	2026-04-04 11:24:02.693201+00
5	2026-03-29	7	705	2026-04-04 11:24:02.693201+00
5	2026-03-29	8	791	2026-04-04 11:24:02.693201+00
5	2026-03-29	9	728	2026-04-04 11:24:02.693201+00
5	2026-03-29	10	744	2026-04-04 11:24:02.693201+00
5	2026-03-29	11	831	2026-04-04 11:24:02.693201+00
5	2026-03-29	12	878	2026-04-04 11:24:02.693201+00
5	2026-03-29	13	875	2026-04-04 11:24:02.693201+00
5	2026-03-29	14	837	2026-04-04 11:24:02.693201+00
5	2026-03-29	15	867	2026-04-04 11:24:02.693201+00
5	2026-03-29	16	873	2026-04-04 11:24:02.693201+00
5	2026-03-29	17	909	2026-04-04 11:24:02.693201+00
5	2026-03-29	18	967	2026-04-04 11:24:02.693201+00
5	2026-03-29	19	1016	2026-04-04 11:24:02.693201+00
5	2026-03-29	20	1152	2026-04-04 11:24:02.693201+00
5	2026-03-29	21	1204	2026-04-04 11:24:02.693201+00
5	2026-03-29	22	1063	2026-04-04 11:24:02.693201+00
5	2026-03-29	23	735	2026-04-04 11:24:02.693201+00
5	2026-03-30	0	432	2026-04-04 11:24:02.693201+00
5	2026-03-30	1	254	2026-04-04 11:24:02.693201+00
5	2026-03-30	2	139	2026-04-04 11:24:02.693201+00
5	2026-03-30	3	99	2026-04-04 11:24:02.693201+00
5	2026-03-30	4	102	2026-04-04 11:24:02.693201+00
5	2026-03-30	5	223	2026-04-04 11:24:02.693201+00
5	2026-03-30	6	479	2026-04-04 11:24:02.693201+00
5	2026-03-30	7	682	2026-04-04 11:24:02.693201+00
5	2026-03-30	8	666	2026-04-04 11:24:02.693201+00
5	2026-03-30	9	693	2026-04-04 11:24:02.693201+00
5	2026-03-30	10	683	2026-04-04 11:24:02.693201+00
5	2026-03-30	11	727	2026-04-04 11:24:02.693201+00
5	2026-03-30	12	787	2026-04-04 11:24:02.693201+00
5	2026-03-30	13	821	2026-04-04 11:24:02.693201+00
5	2026-03-30	14	776	2026-04-04 11:24:02.693201+00
5	2026-03-30	15	810	2026-04-04 11:24:02.693201+00
5	2026-03-30	16	814	2026-04-04 11:24:02.693201+00
5	2026-03-30	17	858	2026-04-04 11:24:02.693201+00
5	2026-03-30	18	975	2026-04-04 11:24:02.693201+00
5	2026-03-30	19	1033	2026-04-04 11:24:02.693201+00
5	2026-03-30	20	1131	2026-04-04 11:24:02.693201+00
5	2026-03-30	21	1227	2026-04-04 11:24:02.693201+00
5	2026-03-30	22	1080	2026-04-04 11:24:02.693201+00
5	2026-03-30	23	734	2026-04-04 11:24:02.693201+00
5	2026-03-31	0	420	2026-04-04 11:24:02.693201+00
5	2026-03-31	1	228	2026-04-04 11:24:02.693201+00
5	2026-03-31	2	145	2026-04-04 11:24:02.693201+00
5	2026-03-31	3	97	2026-04-04 11:24:02.693201+00
5	2026-03-31	4	101	2026-04-04 11:24:02.693201+00
5	2026-03-31	5	224	2026-04-04 11:24:02.693201+00
5	2026-03-31	6	470	2026-04-04 11:24:02.693201+00
5	2026-03-31	7	676	2026-04-04 11:24:02.693201+00
5	2026-03-31	8	715	2026-04-04 11:24:02.693201+00
5	2026-03-31	9	679	2026-04-04 11:24:02.693201+00
5	2026-03-31	10	693	2026-04-04 11:24:02.693201+00
5	2026-03-31	11	715	2026-04-04 11:24:02.693201+00
5	2026-03-31	12	849	2026-04-04 11:24:02.693201+00
5	2026-03-31	13	812	2026-04-04 11:24:02.693201+00
5	2026-03-31	14	804	2026-04-04 11:24:02.693201+00
5	2026-03-31	15	821	2026-04-04 11:24:02.693201+00
5	2026-03-31	16	852	2026-04-04 11:24:02.693201+00
5	2026-03-31	17	911	2026-04-04 11:24:02.693201+00
5	2026-03-31	18	976	2026-04-04 11:24:02.693201+00
5	2026-03-31	19	1018	2026-04-04 11:24:02.693201+00
5	2026-03-31	20	1111	2026-04-04 11:24:02.693201+00
5	2026-03-31	21	1189	2026-04-04 11:24:02.693201+00
5	2026-03-31	22	1045	2026-04-04 11:24:02.693201+00
5	2026-03-31	23	729	2026-04-04 11:24:02.693201+00
5	2026-04-01	0	424	2026-04-04 11:24:02.693201+00
5	2026-04-01	1	213	2026-04-04 11:24:02.693201+00
5	2026-04-01	2	118	2026-04-04 11:24:02.693201+00
5	2026-04-01	3	96	2026-04-04 11:24:02.693201+00
5	2026-04-01	4	109	2026-04-04 11:24:02.693201+00
5	2026-04-01	5	212	2026-04-04 11:24:02.693201+00
5	2026-04-01	6	456	2026-04-04 11:24:02.693201+00
5	2026-04-01	7	732	2026-04-04 11:24:02.693201+00
5	2026-04-01	8	704	2026-04-04 11:24:02.693201+00
5	2026-04-01	9	701	2026-04-04 11:24:02.693201+00
5	2026-04-01	10	680	2026-04-04 11:24:02.693201+00
5	2026-04-01	11	686	2026-04-04 11:24:02.693201+00
5	2026-04-01	12	861	2026-04-04 11:24:02.693201+00
5	2026-04-01	13	839	2026-04-04 11:24:02.693201+00
5	2026-04-01	14	788	2026-04-04 11:24:02.693201+00
5	2026-04-01	15	809	2026-04-04 11:24:02.693201+00
5	2026-04-01	16	862	2026-04-04 11:24:02.693201+00
5	2026-04-01	17	867	2026-04-04 11:24:02.693201+00
5	2026-04-01	18	923	2026-04-04 11:24:02.693201+00
5	2026-04-01	19	955	2026-04-04 11:24:02.693201+00
5	2026-04-01	20	1106	2026-04-04 11:24:02.693201+00
5	2026-04-01	21	1175	2026-04-04 11:24:02.693201+00
5	2026-04-01	22	1080	2026-04-04 11:24:02.693201+00
5	2026-04-01	23	784	2026-04-04 11:24:02.693201+00
5	2026-04-02	0	440	2026-04-04 11:24:02.693201+00
5	2026-04-02	1	235	2026-04-04 11:24:02.693201+00
5	2026-04-02	2	153	2026-04-04 11:24:02.693201+00
5	2026-04-02	3	113	2026-04-04 11:24:02.693201+00
5	2026-04-02	4	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	5	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	6	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	7	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	8	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	9	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	10	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	11	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	12	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	13	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	14	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	15	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	16	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	17	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	18	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	19	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	20	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	21	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	22	0	2026-04-04 11:24:02.693201+00
5	2026-04-02	23	0	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_content (client_id, title, views, likes, comments, shares, post_time, updated_at) FROM stdin;
1	are you planning to do redo your floors? 🏡 #flooringmauritius #epoxymauritius #polycolor #polytolpa	657271	23406	214	6686	31 décembre	2026-03-20 12:52:36.37106+00
1	🛒 christmas shopping at Polytol Paints🎅🎄#polytolpaints #polycolor #epoxymauritius #flooringmaurit	102986	2459	181	444	23 décembre	2026-03-20 12:52:36.37106+00
1	Replying to @Xuxuuuu  ki kouler zot envi trouve next time ? #polytolpaints #polycolor #paintmanufact	82470	4453	32	92	7 novembre	2026-03-20 12:52:36.37106+00
1	nou repar nou miray avan l’année 🏡 #housesmauritius #polycolor #polytolpaints #elastomericmauritius	81396	2402	21	1032	8 novembre	2026-03-20 12:52:36.37106+00
1	Bann madam, zot kapav profite nou promotion de fête des mères, pa traka!  📌 Rendez-vous demain dans	64208	2131	4	100	23 mai	2026-03-20 12:52:36.37106+00
1	Protez nou lakaz ☀️  #Polycolor  #Fibrated #Waterproofing #ProtezeZotLakaz #tiktokmauritius #fyp #ro	110519	3780	14	877	18 mars	2026-03-20 12:52:36.37106+00
1	#polytolpaints #mauritiancompany #paintmanufacturer #maurice 🇲🇺 	35281	1855	17	52	17 décembre	2026-03-20 12:52:36.37106+00
1	vinn ar moi dan l’usine enn gro fabrikan la peinture dan moris 🇲🇺 #polytolpaints #polycolor #polyt	29604	825	8	85	15 octobre	2026-03-20 12:52:36.37106+00
1	the importance of (a good) waterproofing 💦 🏡 #waterproofingmauritius #rainmauritius #roofleakingma	34580	498	6	93	16 mars	2026-03-20 12:52:36.37106+00
1	ki zot fer pou zot pa touffe? 🌞🌊 #thermoflexpolycolor #summermauritius #polycolor #pinterestmaurit	26530	802	7	329	27 novembre	2026-03-20 12:52:36.37106+00
1	Trouv nou waterproofing dan nou showrooms ou quincailleries! ☔️Sonn nou lor 249 1299 pu plis renseig	197626	7771	64	3034	28 février	2026-03-20 12:52:36.37106+00
1	eske zonn deza visite le nouveau mall de Montebello? 🥭 #montebellomauritius #polytolpaints #polycol	23350	677	1	87	21 février	2026-03-20 12:52:36.37106+00
1	📍Montebello • our new showroom 🏡 #polytolpaintsmontebello #paintmanufacturermauritius #mauritiuspa	16659	351	8	19	3 décembre	2026-03-20 12:52:36.37106+00
1	Une petite fissure aujourd’hui, c’est peut-être un gros dégât demain. Avec Polytop Elastomeric, vos 	14620	195	1	98	13 avril	2026-03-20 12:52:36.37106+00
1	guess where? 🏡 it starts with an M  #polytolpaintsshowroom #paintmauritius #renovationmauritius #su	14228	414	12	30	14 janvier	2026-03-20 12:52:36.37106+00
5	the new restaurant in Trou aux biches 🧁 #mauritius #restaurantmauritius #restauranttrouauxbiches #t	68899	5248	52	870	13 octobre	2026-04-04 11:24:02.693201+00
5	Bienvenue à Ava Beach. 🧡  #avabeach #restauranttrouauxbiches #restaurantmauritius #restaurantnorthm	54646	2157	25	1083	17 décembre	2026-04-04 11:24:02.693201+00
5	location at the end and we can’t wait to see you 🧡 #newrestaurantmauritius #newrestauranttrouauxbic	47164	4269	17	892	14 novembre	2026-04-04 11:24:02.693201+00
5	📍Ava Beach, Trou aux Biches, Mauritius 🇲🇺  #newrestaurantmauritius #wheretogoinmauritius #mauriti	24909	1176	13	194	10 mars	2026-04-04 11:24:02.693201+00
5	Ava Beach, opening soon 🌞🌊	21179	1448	13	292	9 octobre	2026-04-04 11:24:02.693201+00
5	🌊🐚🐬☀️ #trouauxbiches #mauritius #northmauritius #restaurantmauritius 	18613	734	7	198	2 novembre	2026-04-04 11:24:02.693201+00
5	and we’re opening very soon!!! #avabeach #trouauxbiches #newrestaurantmauritius #restauranttrouauxbi	17142	1032	5	141	1 novembre	2026-04-04 11:24:02.693201+00
5	we can’t wait to meet you all 🧡 #trouauxbiches #avabeachrestaurant #restauranttrouauxbiches #restau	16240	614	3	178	8 novembre	2026-04-04 11:24:02.693201+00
5	a few steps from the beach 🌊 #avabeach #restauranttrouauxbiches #trouauxbiches #restaurantmauritius	14620	406	3	35	16 octobre	2026-04-04 11:24:02.693201+00
5	have you visited us yet? 🩵 #newrestaurantmauritius #mauritiusrestaurants #trouauxbiches 	14266	553	12	100	17 décembre	2026-04-04 11:24:02.693201+00
5	what do you think of our style? 🐬 #avabeach #trouauxbiches 	11925	773	6	156	26 novembre	2026-04-04 11:24:02.693201+00
5	have you visited yeeet?  #breakfastmauritius #mauritiusrestaurant #mauritius #placestoeattrouauxbich	10802	595	5	163	17 février	2026-04-04 11:24:02.693201+00
5	call us now 🍸 on 5 274-2331 #jobrestaurantmaurice #jobnordmaurice 	10550	452	3	85	9 décembre	2026-04-04 11:24:02.693201+00
5	when is your day off? 🧡 #breakfastmauritius #breakfasttrouauxbiches #trouauxbiches #mauritius #plac	10262	430	10	129	18 février	2026-04-04 11:24:02.693201+00
5	J-7 before opening the restaurant 🇲🇺 #avabeachmauritius #avatrouauxbiches #restaurantmauritius #re	8753	443	8	82	10 novembre	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_followers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_followers (client_id, date, followers, diff, updated_at) FROM stdin;
1	2025-03-18	4540	17	2026-03-20 12:52:36.37106+00
1	2025-03-19	4557	9	2026-03-20 12:52:36.37106+00
1	2025-03-20	4566	2	2026-03-20 12:52:36.37106+00
1	2025-03-21	4568	6	2026-03-20 12:52:36.37106+00
1	2025-03-22	4574	5	2026-03-20 12:52:36.37106+00
1	2025-03-23	4579	4	2026-03-20 12:52:36.37106+00
1	2025-03-24	4583	11	2026-03-20 12:52:36.37106+00
1	2025-03-25	4594	2	2026-03-20 12:52:36.37106+00
1	2025-03-26	4596	2	2026-03-20 12:52:36.37106+00
1	2025-03-27	4598	1	2026-03-20 12:52:36.37106+00
1	2025-03-28	4599	2	2026-03-20 12:52:36.37106+00
1	2025-03-29	4601	5	2026-03-20 12:52:36.37106+00
1	2025-03-30	4606	4	2026-03-20 12:52:36.37106+00
1	2025-03-31	4610	1	2026-03-20 12:52:36.37106+00
1	2025-04-01	4611	8	2026-03-20 12:52:36.37106+00
1	2025-04-02	4619	1	2026-03-20 12:52:36.37106+00
1	2025-04-03	4620	3	2026-03-20 12:52:36.37106+00
1	2025-04-04	4623	0	2026-03-20 12:52:36.37106+00
1	2025-04-05	4623	2	2026-03-20 12:52:36.37106+00
1	2025-04-06	4625	2	2026-03-20 12:52:36.37106+00
1	2025-04-07	4627	2	2026-03-20 12:52:36.37106+00
1	2025-04-08	4629	-1	2026-03-20 12:52:36.37106+00
1	2025-04-09	4628	11	2026-03-20 12:52:36.37106+00
1	2025-04-10	4639	2	2026-03-20 12:52:36.37106+00
1	2025-04-11	4641	26	2026-03-20 12:52:36.37106+00
1	2025-04-12	4667	18	2026-03-20 12:52:36.37106+00
1	2025-04-13	4685	11	2026-03-20 12:52:36.37106+00
1	2025-04-14	4696	5	2026-03-20 12:52:36.37106+00
1	2025-04-15	4701	4	2026-03-20 12:52:36.37106+00
1	2025-04-16	4705	1	2026-03-20 12:52:36.37106+00
1	2025-04-17	4706	0	2026-03-20 12:52:36.37106+00
1	2025-04-18	4706	3	2026-03-20 12:52:36.37106+00
1	2025-04-19	4709	10	2026-03-20 12:52:36.37106+00
1	2025-04-20	4719	2	2026-03-20 12:52:36.37106+00
1	2025-04-21	4721	0	2026-03-20 12:52:36.37106+00
1	2025-04-22	4721	2	2026-03-20 12:52:36.37106+00
1	2025-04-23	4723	3	2026-03-20 12:52:36.37106+00
1	2025-04-24	4726	1	2026-03-20 12:52:36.37106+00
1	2025-04-25	4727	1	2026-03-20 12:52:36.37106+00
1	2025-04-26	4728	2	2026-03-20 12:52:36.37106+00
1	2025-04-27	4730	1	2026-03-20 12:52:36.37106+00
1	2025-04-28	4731	7	2026-03-20 12:52:36.37106+00
1	2025-04-29	4738	-2	2026-03-20 12:52:36.37106+00
1	2025-04-30	4736	1	2026-03-20 12:52:36.37106+00
1	2025-05-01	4737	2	2026-03-20 12:52:36.37106+00
1	2025-05-02	4739	4	2026-03-20 12:52:36.37106+00
1	2025-05-03	4743	5	2026-03-20 12:52:36.37106+00
1	2025-05-04	4748	4	2026-03-20 12:52:36.37106+00
1	2025-05-05	4752	7	2026-03-20 12:52:36.37106+00
1	2025-05-06	4759	0	2026-03-20 12:52:36.37106+00
1	2025-05-07	4759	3	2026-03-20 12:52:36.37106+00
1	2025-05-08	4762	6	2026-03-20 12:52:36.37106+00
1	2025-05-09	4768	3	2026-03-20 12:52:36.37106+00
1	2025-05-10	4771	-2	2026-03-20 12:52:36.37106+00
1	2025-05-11	4769	2	2026-03-20 12:52:36.37106+00
1	2025-05-12	4771	3	2026-03-20 12:52:36.37106+00
1	2025-05-13	4774	3	2026-03-20 12:52:36.37106+00
1	2025-05-14	4777	5	2026-03-20 12:52:36.37106+00
1	2025-05-15	4782	4	2026-03-20 12:52:36.37106+00
1	2025-05-16	4786	-1	2026-03-20 12:52:36.37106+00
1	2025-05-17	4785	2	2026-03-20 12:52:36.37106+00
1	2025-05-18	4787	2	2026-03-20 12:52:36.37106+00
1	2025-05-19	4789	2	2026-03-20 12:52:36.37106+00
1	2025-05-20	4791	2	2026-03-20 12:52:36.37106+00
1	2025-05-21	4793	30	2026-03-20 12:52:36.37106+00
1	2025-05-22	4823	128	2026-03-20 12:52:36.37106+00
1	2025-05-23	4951	17	2026-03-20 12:52:36.37106+00
1	2025-05-24	4968	23	2026-03-20 12:52:36.37106+00
1	2025-05-25	4991	1	2026-03-20 12:52:36.37106+00
1	2025-05-26	4992	5	2026-03-20 12:52:36.37106+00
1	2025-05-27	4997	2	2026-03-20 12:52:36.37106+00
1	2025-05-28	4999	1	2026-03-20 12:52:36.37106+00
1	2025-05-29	5000	0	2026-03-20 12:52:36.37106+00
1	2025-05-30	5000	1	2026-03-20 12:52:36.37106+00
1	2025-05-31	5001	4	2026-03-20 12:52:36.37106+00
1	2025-06-01	5005	1	2026-03-20 12:52:36.37106+00
1	2025-06-02	5006	0	2026-03-20 12:52:36.37106+00
1	2025-06-03	5006	1	2026-03-20 12:52:36.37106+00
1	2025-06-04	5007	2	2026-03-20 12:52:36.37106+00
1	2025-06-05	5009	0	2026-03-20 12:52:36.37106+00
1	2025-06-06	5009	2	2026-03-20 12:52:36.37106+00
1	2025-06-07	5011	1	2026-03-20 12:52:36.37106+00
1	2025-06-08	5012	1	2026-03-20 12:52:36.37106+00
1	2025-06-09	5013	0	2026-03-20 12:52:36.37106+00
1	2025-06-10	5013	1	2026-03-20 12:52:36.37106+00
1	2025-06-11	5014	0	2026-03-20 12:52:36.37106+00
1	2025-06-12	5014	1	2026-03-20 12:52:36.37106+00
1	2025-06-13	5015	1	2026-03-20 12:52:36.37106+00
1	2025-06-14	5016	-1	2026-03-20 12:52:36.37106+00
1	2025-06-15	5015	1	2026-03-20 12:52:36.37106+00
1	2025-06-16	5016	1	2026-03-20 12:52:36.37106+00
1	2025-06-17	5017	-1	2026-03-20 12:52:36.37106+00
1	2025-06-18	5016	2	2026-03-20 12:52:36.37106+00
1	2025-06-19	5018	0	2026-03-20 12:52:36.37106+00
1	2025-06-20	5018	1	2026-03-20 12:52:36.37106+00
1	2025-06-21	5019	1	2026-03-20 12:52:36.37106+00
1	2025-06-22	5020	2	2026-03-20 12:52:36.37106+00
1	2025-06-23	5022	1	2026-03-20 12:52:36.37106+00
1	2025-06-24	5023	0	2026-03-20 12:52:36.37106+00
1	2025-06-25	5023	0	2026-03-20 12:52:36.37106+00
1	2025-06-26	5023	0	2026-03-20 12:52:36.37106+00
1	2025-06-27	5023	1	2026-03-20 12:52:36.37106+00
1	2025-06-28	5024	2	2026-03-20 12:52:36.37106+00
1	2025-06-29	5026	0	2026-03-20 12:52:36.37106+00
1	2025-06-30	5026	1	2026-03-20 12:52:36.37106+00
1	2025-07-01	5027	1	2026-03-20 12:52:36.37106+00
1	2025-07-02	5028	1	2026-03-20 12:52:36.37106+00
1	2025-07-03	5029	4	2026-03-20 12:52:36.37106+00
1	2025-07-04	5033	0	2026-03-20 12:52:36.37106+00
1	2025-07-05	5033	0	2026-03-20 12:52:36.37106+00
1	2025-07-06	5033	2	2026-03-20 12:52:36.37106+00
1	2025-07-07	5035	1	2026-03-20 12:52:36.37106+00
1	2025-07-08	5036	7	2026-03-20 12:52:36.37106+00
1	2025-07-09	5043	1	2026-03-20 12:52:36.37106+00
1	2025-07-10	5044	3	2026-03-20 12:52:36.37106+00
1	2025-07-11	5047	-1	2026-03-20 12:52:36.37106+00
1	2025-07-12	5046	1	2026-03-20 12:52:36.37106+00
1	2025-07-13	5047	-2	2026-03-20 12:52:36.37106+00
1	2025-07-14	5045	1	2026-03-20 12:52:36.37106+00
1	2025-07-15	5046	-1	2026-03-20 12:52:36.37106+00
1	2025-07-16	5045	2	2026-03-20 12:52:36.37106+00
1	2025-07-17	5047	2	2026-03-20 12:52:36.37106+00
1	2025-07-18	5049	1	2026-03-20 12:52:36.37106+00
1	2025-07-19	5050	5	2026-03-20 12:52:36.37106+00
1	2025-07-20	5055	2	2026-03-20 12:52:36.37106+00
1	2025-07-21	5057	4	2026-03-20 12:52:36.37106+00
1	2025-07-22	5061	2	2026-03-20 12:52:36.37106+00
1	2025-07-23	5063	1	2026-03-20 12:52:36.37106+00
1	2025-07-24	5064	1	2026-03-20 12:52:36.37106+00
1	2025-07-25	5065	2	2026-03-20 12:52:36.37106+00
1	2025-07-26	5067	1	2026-03-20 12:52:36.37106+00
1	2025-07-27	5068	3	2026-03-20 12:52:36.37106+00
1	2025-07-28	5071	-2	2026-03-20 12:52:36.37106+00
1	2025-07-29	5069	1	2026-03-20 12:52:36.37106+00
1	2025-07-30	5070	2	2026-03-20 12:52:36.37106+00
1	2025-07-31	5072	0	2026-03-20 12:52:36.37106+00
1	2025-08-01	5072	2	2026-03-20 12:52:36.37106+00
1	2025-08-02	5074	0	2026-03-20 12:52:36.37106+00
1	2025-08-03	5074	1	2026-03-20 12:52:36.37106+00
1	2025-08-04	5075	1	2026-03-20 12:52:36.37106+00
1	2025-08-05	5076	0	2026-03-20 12:52:36.37106+00
1	2025-08-06	5076	0	2026-03-20 12:52:36.37106+00
1	2025-08-07	5076	1	2026-03-20 12:52:36.37106+00
1	2025-08-08	5077	-1	2026-03-20 12:52:36.37106+00
1	2025-08-09	5076	2	2026-03-20 12:52:36.37106+00
1	2025-08-10	5078	1	2026-03-20 12:52:36.37106+00
1	2025-08-11	5079	0	2026-03-20 12:52:36.37106+00
1	2025-08-12	5079	0	2026-03-20 12:52:36.37106+00
1	2025-08-13	5079	6	2026-03-20 12:52:36.37106+00
1	2025-08-14	5085	1	2026-03-20 12:52:36.37106+00
1	2025-08-15	5086	6	2026-03-20 12:52:36.37106+00
1	2025-08-16	5092	0	2026-03-20 12:52:36.37106+00
1	2025-08-17	5092	1	2026-03-20 12:52:36.37106+00
1	2025-08-18	5093	-1	2026-03-20 12:52:36.37106+00
1	2025-08-19	5092	1	2026-03-20 12:52:36.37106+00
1	2025-08-20	5093	1	2026-03-20 12:52:36.37106+00
1	2025-08-21	5094	0	2026-03-20 12:52:36.37106+00
1	2025-08-22	5094	1	2026-03-20 12:52:36.37106+00
1	2025-08-23	5095	0	2026-03-20 12:52:36.37106+00
1	2025-08-24	5095	0	2026-03-20 12:52:36.37106+00
1	2025-08-25	5095	2	2026-03-20 12:52:36.37106+00
1	2025-08-26	5097	0	2026-03-20 12:52:36.37106+00
1	2025-08-27	5097	0	2026-03-20 12:52:36.37106+00
1	2025-08-28	5097	0	2026-03-20 12:52:36.37106+00
1	2025-08-29	5097	1	2026-03-20 12:52:36.37106+00
1	2025-08-30	5098	-1	2026-03-20 12:52:36.37106+00
1	2025-08-31	5097	0	2026-03-20 12:52:36.37106+00
1	2025-09-01	5097	0	2026-03-20 12:52:36.37106+00
1	2025-09-02	5097	0	2026-03-20 12:52:36.37106+00
1	2025-09-03	5097	0	2026-03-20 12:52:36.37106+00
1	2025-09-04	5097	-1	2026-03-20 12:52:36.37106+00
1	2025-09-05	5096	0	2026-03-20 12:52:36.37106+00
1	2025-09-06	5096	1	2026-03-20 12:52:36.37106+00
1	2025-09-07	5097	1	2026-03-20 12:52:36.37106+00
1	2025-09-08	5098	0	2026-03-20 12:52:36.37106+00
1	2025-09-09	5098	1	2026-03-20 12:52:36.37106+00
1	2025-09-10	5099	1	2026-03-20 12:52:36.37106+00
1	2025-09-11	5100	-2	2026-03-20 12:52:36.37106+00
1	2025-09-12	5098	0	2026-03-20 12:52:36.37106+00
1	2025-09-13	5098	-1	2026-03-20 12:52:36.37106+00
1	2025-09-14	5097	4	2026-03-20 12:52:36.37106+00
1	2025-09-15	5101	-2	2026-03-20 12:52:36.37106+00
1	2025-09-16	5099	0	2026-03-20 12:52:36.37106+00
1	2025-09-17	5099	-1	2026-03-20 12:52:36.37106+00
1	2025-09-18	5098	-1	2026-03-20 12:52:36.37106+00
1	2025-09-19	5097	1	2026-03-20 12:52:36.37106+00
1	2025-09-20	5098	2	2026-03-20 12:52:36.37106+00
1	2025-09-21	5100	2	2026-03-20 12:52:36.37106+00
1	2025-09-22	5102	-1	2026-03-20 12:52:36.37106+00
1	2025-09-23	5101	0	2026-03-20 12:52:36.37106+00
1	2025-09-24	5101	10	2026-03-20 12:52:36.37106+00
1	2025-09-25	5111	10	2026-03-20 12:52:36.37106+00
1	2025-09-26	5121	4	2026-03-20 12:52:36.37106+00
1	2025-09-27	5125	3	2026-03-20 12:52:36.37106+00
1	2025-09-28	5128	6	2026-03-20 12:52:36.37106+00
1	2025-09-29	5134	2	2026-03-20 12:52:36.37106+00
1	2025-09-30	5136	3	2026-03-20 12:52:36.37106+00
1	2025-10-01	5139	1	2026-03-20 12:52:36.37106+00
1	2025-10-02	5140	0	2026-03-20 12:52:36.37106+00
1	2025-10-03	5140	3	2026-03-20 12:52:36.37106+00
1	2025-10-04	5143	3	2026-03-20 12:52:36.37106+00
1	2025-10-05	5146	0	2026-03-20 12:52:36.37106+00
1	2025-10-06	5146	12	2026-03-20 12:52:36.37106+00
1	2025-10-07	5158	-1	2026-03-20 12:52:36.37106+00
1	2025-10-08	5157	1	2026-03-20 12:52:36.37106+00
1	2025-10-09	5158	3	2026-03-20 12:52:36.37106+00
1	2025-10-10	5161	2	2026-03-20 12:52:36.37106+00
1	2025-10-11	5163	-1	2026-03-20 12:52:36.37106+00
1	2025-10-12	5162	1	2026-03-20 12:52:36.37106+00
1	2025-10-13	5163	30	2026-03-20 12:52:36.37106+00
1	2025-10-14	5193	49	2026-03-20 12:52:36.37106+00
1	2025-10-15	5242	27	2026-03-20 12:52:36.37106+00
1	2025-10-16	5269	4	2026-03-20 12:52:36.37106+00
1	2025-10-17	5273	3	2026-03-20 12:52:36.37106+00
1	2025-10-18	5276	5	2026-03-20 12:52:36.37106+00
1	2025-10-19	5281	3	2026-03-20 12:52:36.37106+00
1	2025-10-20	5284	13	2026-03-20 12:52:36.37106+00
1	2025-10-21	5297	14	2026-03-20 12:52:36.37106+00
1	2025-10-22	5311	2	2026-03-20 12:52:36.37106+00
1	2025-10-23	5313	10	2026-03-20 12:52:36.37106+00
1	2025-10-24	5323	1	2026-03-20 12:52:36.37106+00
1	2025-10-25	5324	8	2026-03-20 12:52:36.37106+00
1	2025-10-26	5332	4	2026-03-20 12:52:36.37106+00
1	2025-10-27	5336	9	2026-03-20 12:52:36.37106+00
1	2025-10-28	5345	7	2026-03-20 12:52:36.37106+00
1	2025-10-29	5352	3	2026-03-20 12:52:36.37106+00
1	2025-10-30	5355	0	2026-03-20 12:52:36.37106+00
1	2025-10-31	5355	3	2026-03-20 12:52:36.37106+00
1	2025-11-01	5358	2	2026-03-20 12:52:36.37106+00
1	2025-11-02	5360	1	2026-03-20 12:52:36.37106+00
1	2025-11-03	5361	3	2026-03-20 12:52:36.37106+00
1	2025-11-04	5364	4	2026-03-20 12:52:36.37106+00
1	2025-11-05	5368	55	2026-03-20 12:52:36.37106+00
1	2025-11-06	5423	219	2026-03-20 12:52:36.37106+00
1	2025-11-07	5642	487	2026-03-20 12:52:36.37106+00
1	2025-11-08	6129	151	2026-03-20 12:52:36.37106+00
1	2025-11-09	6280	61	2026-03-20 12:52:36.37106+00
1	2025-11-10	6341	40	2026-03-20 12:52:36.37106+00
1	2025-11-11	6381	13	2026-03-20 12:52:36.37106+00
1	2025-11-12	6394	14	2026-03-20 12:52:36.37106+00
1	2025-11-13	6408	18	2026-03-20 12:52:36.37106+00
1	2025-11-14	6426	17	2026-03-20 12:52:36.37106+00
1	2025-11-15	6443	4	2026-03-20 12:52:36.37106+00
1	2025-11-16	6447	10	2026-03-20 12:52:36.37106+00
1	2025-11-17	6457	13	2026-03-20 12:52:36.37106+00
1	2025-11-18	6470	8	2026-03-20 12:52:36.37106+00
1	2025-11-19	6478	22	2026-03-20 12:52:36.37106+00
1	2025-11-20	6500	15	2026-03-20 12:52:36.37106+00
1	2025-11-21	6515	11	2026-03-20 12:52:36.37106+00
1	2025-11-22	6526	13	2026-03-20 12:52:36.37106+00
1	2025-11-23	6539	15	2026-03-20 12:52:36.37106+00
1	2025-11-24	6554	20	2026-03-20 12:52:36.37106+00
1	2025-11-25	6574	38	2026-03-20 12:52:36.37106+00
1	2025-11-26	6612	60	2026-03-20 12:52:36.37106+00
1	2025-11-27	6672	18	2026-03-20 12:52:36.37106+00
1	2025-11-28	6690	13	2026-03-20 12:52:36.37106+00
1	2025-11-29	6703	21	2026-03-20 12:52:36.37106+00
1	2025-11-30	6724	9	2026-03-20 12:52:36.37106+00
1	2025-12-01	6733	15	2026-03-20 12:52:36.37106+00
1	2025-12-02	6748	22	2026-03-20 12:52:36.37106+00
1	2025-12-03	6770	20	2026-03-20 12:52:36.37106+00
1	2025-12-04	6790	18	2026-03-20 12:52:36.37106+00
1	2025-12-05	6808	17	2026-03-20 12:52:36.37106+00
1	2025-12-06	6825	4	2026-03-20 12:52:36.37106+00
1	2025-12-07	6829	21	2026-03-20 12:52:36.37106+00
1	2025-12-08	6850	14	2026-03-20 12:52:36.37106+00
1	2025-12-09	6864	7	2026-03-20 12:52:36.37106+00
1	2025-12-10	6871	12	2026-03-20 12:52:36.37106+00
1	2025-12-11	6883	20	2026-03-20 12:52:36.37106+00
1	2025-12-12	6903	15	2026-03-20 12:52:36.37106+00
1	2025-12-13	6918	11	2026-03-20 12:52:36.37106+00
1	2025-12-14	6929	13	2026-03-20 12:52:36.37106+00
1	2025-12-15	6942	20	2026-03-20 12:52:36.37106+00
1	2025-12-16	6962	51	2026-03-20 12:52:36.37106+00
1	2025-12-17	7013	36	2026-03-20 12:52:36.37106+00
1	2025-12-18	7049	13	2026-03-20 12:52:36.37106+00
1	2025-12-19	7062	14	2026-03-20 12:52:36.37106+00
1	2025-12-20	7076	12	2026-03-20 12:52:36.37106+00
1	2025-12-21	7088	78	2026-03-20 12:52:36.37106+00
1	2025-12-22	7166	123	2026-03-20 12:52:36.37106+00
1	2025-12-23	7289	96	2026-03-20 12:52:36.37106+00
1	2025-12-24	7385	61	2026-03-20 12:52:36.37106+00
1	2025-12-25	7446	58	2026-03-20 12:52:36.37106+00
1	2025-12-26	7504	67	2026-03-20 12:52:36.37106+00
1	2025-12-27	7571	63	2026-03-20 12:52:36.37106+00
1	2025-12-28	7634	42	2026-03-20 12:52:36.37106+00
1	2025-12-29	7676	743	2026-03-20 12:52:36.37106+00
1	2025-12-30	8419	1857	2026-03-20 12:52:36.37106+00
1	2025-12-31	10276	824	2026-03-20 12:52:36.37106+00
1	2026-01-01	11100	405	2026-03-20 12:52:36.37106+00
1	2026-01-02	11505	221	2026-03-20 12:52:36.37106+00
1	2026-01-03	11726	234	2026-03-20 12:52:36.37106+00
1	2026-01-04	11960	200	2026-03-20 12:52:36.37106+00
1	2026-01-05	12160	139	2026-03-20 12:52:36.37106+00
1	2026-01-06	12299	135	2026-03-20 12:52:36.37106+00
1	2026-01-07	12434	99	2026-03-20 12:52:36.37106+00
1	2026-01-08	12533	81	2026-03-20 12:52:36.37106+00
1	2026-01-09	12614	88	2026-03-20 12:52:36.37106+00
1	2026-01-10	12702	80	2026-03-20 12:52:36.37106+00
1	2026-01-11	12782	58	2026-03-20 12:52:36.37106+00
1	2026-01-12	12840	102	2026-03-20 12:52:36.37106+00
1	2026-01-13	12942	97	2026-03-20 12:52:36.37106+00
1	2026-01-14	13039	74	2026-03-20 12:52:36.37106+00
1	2026-01-15	13113	65	2026-03-20 12:52:36.37106+00
1	2026-01-16	13178	60	2026-03-20 12:52:36.37106+00
1	2026-01-17	13238	52	2026-03-20 12:52:36.37106+00
1	2026-01-18	13290	46	2026-03-20 12:52:36.37106+00
1	2026-01-19	13336	43	2026-03-20 12:52:36.37106+00
1	2026-01-20	13379	61	2026-03-20 12:52:36.37106+00
1	2026-01-21	13440	40	2026-03-20 12:52:36.37106+00
1	2026-01-22	13480	33	2026-03-20 12:52:36.37106+00
1	2026-01-23	13513	63	2026-03-20 12:52:36.37106+00
1	2026-01-24	13576	36	2026-03-20 12:52:36.37106+00
1	2026-01-25	13612	35	2026-03-20 12:52:36.37106+00
1	2026-01-26	13647	27	2026-03-20 12:52:36.37106+00
1	2026-01-27	13674	53	2026-03-20 12:52:36.37106+00
1	2026-01-28	13727	55	2026-03-20 12:52:36.37106+00
1	2026-01-29	13782	22	2026-03-20 12:52:36.37106+00
1	2026-01-30	13804	43	2026-03-20 12:52:36.37106+00
1	2026-01-31	13847	58	2026-03-20 12:52:36.37106+00
1	2026-02-01	13905	52	2026-03-20 12:52:36.37106+00
1	2026-02-02	13957	73	2026-03-20 12:52:36.37106+00
1	2026-02-03	14030	65	2026-03-20 12:52:36.37106+00
1	2026-02-04	14095	41	2026-03-20 12:52:36.37106+00
1	2026-02-05	14136	55	2026-03-20 12:52:36.37106+00
1	2026-02-06	14191	55	2026-03-20 12:52:36.37106+00
1	2026-02-07	14246	37	2026-03-20 12:52:36.37106+00
1	2026-02-08	14283	38	2026-03-20 12:52:36.37106+00
1	2026-02-09	14321	38	2026-03-20 12:52:36.37106+00
1	2026-02-10	14359	30	2026-03-20 12:52:36.37106+00
1	2026-02-11	14389	32	2026-03-20 12:52:36.37106+00
1	2026-02-12	14421	31	2026-03-20 12:52:36.37106+00
1	2026-02-13	14452	46	2026-03-20 12:52:36.37106+00
1	2026-02-14	14498	42	2026-03-20 12:52:36.37106+00
1	2026-02-15	14540	32	2026-03-20 12:52:36.37106+00
1	2026-02-16	14572	31	2026-03-20 12:52:36.37106+00
1	2026-02-17	14603	30	2026-03-20 12:52:36.37106+00
1	2026-02-18	14633	41	2026-03-20 12:52:36.37106+00
1	2026-02-19	14674	45	2026-03-20 12:52:36.37106+00
1	2026-02-20	14719	52	2026-03-20 12:52:36.37106+00
1	2026-02-21	14771	41	2026-03-20 12:52:36.37106+00
1	2026-02-22	14812	21	2026-03-20 12:52:36.37106+00
1	2026-02-23	14833	38	2026-03-20 12:52:36.37106+00
1	2026-02-24	14871	22	2026-03-20 12:52:36.37106+00
1	2026-02-25	14893	32	2026-03-20 12:52:36.37106+00
1	2026-02-26	14925	18	2026-03-20 12:52:36.37106+00
1	2026-02-27	14943	22	2026-03-20 12:52:36.37106+00
1	2026-02-28	14965	11	2026-03-20 12:52:36.37106+00
1	2026-03-01	14976	12	2026-03-20 12:52:36.37106+00
1	2026-03-02	14988	13	2026-03-20 12:52:36.37106+00
1	2026-03-03	15001	6	2026-03-20 12:52:36.37106+00
1	2026-03-04	15007	11	2026-03-20 12:52:36.37106+00
1	2026-03-05	15018	7	2026-03-20 12:52:36.37106+00
1	2026-03-06	15025	8	2026-03-20 12:52:36.37106+00
1	2026-03-07	15033	20	2026-03-20 12:52:36.37106+00
1	2026-03-08	15053	27	2026-03-20 12:52:36.37106+00
1	2026-03-09	15080	18	2026-03-20 12:52:36.37106+00
1	2026-03-10	15098	19	2026-03-20 12:52:36.37106+00
1	2026-03-11	15117	8	2026-03-20 12:52:36.37106+00
1	2026-03-12	15125	7	2026-03-20 12:52:36.37106+00
1	2026-03-13	15132	15	2026-03-20 12:52:36.37106+00
1	2026-03-14	15147	16	2026-03-20 12:52:36.37106+00
1	2026-03-15	15163	30	2026-03-20 12:52:36.37106+00
1	2026-03-16	15193	20	2026-03-20 12:52:36.37106+00
1	2026-03-17	15213	0	2026-03-20 12:52:36.37106+00
5	2025-10-08	9	98	2026-04-04 11:24:02.693201+00
5	2025-10-09	107	30	2026-04-04 11:24:02.693201+00
5	2025-10-10	137	28	2026-04-04 11:24:02.693201+00
5	2025-10-11	165	273	2026-04-04 11:24:02.693201+00
5	2025-10-12	438	166	2026-04-04 11:24:02.693201+00
5	2025-10-13	604	115	2026-04-04 11:24:02.693201+00
5	2025-10-14	719	50	2026-04-04 11:24:02.693201+00
5	2025-10-15	769	18	2026-04-04 11:24:02.693201+00
5	2025-10-16	787	25	2026-04-04 11:24:02.693201+00
5	2025-10-17	812	21	2026-04-04 11:24:02.693201+00
5	2025-10-18	833	13	2026-04-04 11:24:02.693201+00
5	2025-10-19	846	6	2026-04-04 11:24:02.693201+00
5	2025-10-20	852	6	2026-04-04 11:24:02.693201+00
5	2025-10-21	858	7	2026-04-04 11:24:02.693201+00
5	2025-10-22	865	4	2026-04-04 11:24:02.693201+00
5	2025-10-23	869	2	2026-04-04 11:24:02.693201+00
5	2025-10-24	871	5	2026-04-04 11:24:02.693201+00
5	2025-10-25	876	8	2026-04-04 11:24:02.693201+00
5	2025-10-26	884	14	2026-04-04 11:24:02.693201+00
5	2025-10-27	898	19	2026-04-04 11:24:02.693201+00
5	2025-10-28	917	15	2026-04-04 11:24:02.693201+00
5	2025-10-29	932	8	2026-04-04 11:24:02.693201+00
5	2025-10-30	940	82	2026-04-04 11:24:02.693201+00
5	2025-10-31	1022	37	2026-04-04 11:24:02.693201+00
5	2025-11-01	1059	35	2026-04-04 11:24:02.693201+00
5	2025-11-02	1094	5	2026-04-04 11:24:02.693201+00
5	2025-11-03	1099	5	2026-04-04 11:24:02.693201+00
5	2025-11-04	1104	2	2026-04-04 11:24:02.693201+00
5	2025-11-05	1106	6	2026-04-04 11:24:02.693201+00
5	2025-11-06	1112	19	2026-04-04 11:24:02.693201+00
5	2025-11-07	1131	33	2026-04-04 11:24:02.693201+00
5	2025-11-08	1164	28	2026-04-04 11:24:02.693201+00
5	2025-11-09	1192	7	2026-04-04 11:24:02.693201+00
5	2025-11-10	1199	10	2026-04-04 11:24:02.693201+00
5	2025-11-11	1209	6	2026-04-04 11:24:02.693201+00
5	2025-11-12	1215	3	2026-04-04 11:24:02.693201+00
5	2025-11-13	1218	164	2026-04-04 11:24:02.693201+00
5	2025-11-14	1382	62	2026-04-04 11:24:02.693201+00
5	2025-11-15	1444	31	2026-04-04 11:24:02.693201+00
5	2025-11-16	1475	13	2026-04-04 11:24:02.693201+00
5	2025-11-17	1488	9	2026-04-04 11:24:02.693201+00
5	2025-11-18	1497	6	2026-04-04 11:24:02.693201+00
5	2025-11-19	1503	7	2026-04-04 11:24:02.693201+00
5	2025-11-20	1510	5	2026-04-04 11:24:02.693201+00
5	2025-11-21	1515	6	2026-04-04 11:24:02.693201+00
5	2025-11-22	1521	6	2026-04-04 11:24:02.693201+00
5	2025-11-23	1527	3	2026-04-04 11:24:02.693201+00
5	2025-11-24	1530	5	2026-04-04 11:24:02.693201+00
5	2025-11-25	1535	13	2026-04-04 11:24:02.693201+00
5	2025-11-26	1548	4	2026-04-04 11:24:02.693201+00
5	2025-11-27	1552	4	2026-04-04 11:24:02.693201+00
5	2025-11-28	1556	5	2026-04-04 11:24:02.693201+00
5	2025-11-29	1561	9	2026-04-04 11:24:02.693201+00
5	2025-11-30	1570	8	2026-04-04 11:24:02.693201+00
5	2025-12-01	1578	8	2026-04-04 11:24:02.693201+00
5	2025-12-02	1586	9	2026-04-04 11:24:02.693201+00
5	2025-12-03	1595	6	2026-04-04 11:24:02.693201+00
5	2025-12-04	1601	1	2026-04-04 11:24:02.693201+00
5	2025-12-05	1602	7	2026-04-04 11:24:02.693201+00
5	2025-12-06	1609	6	2026-04-04 11:24:02.693201+00
5	2025-12-07	1615	12	2026-04-04 11:24:02.693201+00
5	2025-12-08	1627	4	2026-04-04 11:24:02.693201+00
5	2025-12-09	1631	3	2026-04-04 11:24:02.693201+00
5	2025-12-10	1634	2	2026-04-04 11:24:02.693201+00
5	2025-12-11	1636	3	2026-04-04 11:24:02.693201+00
5	2025-12-12	1639	7	2026-04-04 11:24:02.693201+00
5	2025-12-13	1646	9	2026-04-04 11:24:02.693201+00
5	2025-12-14	1655	5	2026-04-04 11:24:02.693201+00
5	2025-12-15	1660	53	2026-04-04 11:24:02.693201+00
5	2025-12-16	1713	77	2026-04-04 11:24:02.693201+00
5	2025-12-17	1790	54	2026-04-04 11:24:02.693201+00
5	2025-12-18	1844	27	2026-04-04 11:24:02.693201+00
5	2025-12-19	1871	23	2026-04-04 11:24:02.693201+00
5	2025-12-20	1894	18	2026-04-04 11:24:02.693201+00
5	2025-12-21	1912	11	2026-04-04 11:24:02.693201+00
5	2025-12-22	1923	7	2026-04-04 11:24:02.693201+00
5	2025-12-23	1930	7	2026-04-04 11:24:02.693201+00
5	2025-12-24	1937	10	2026-04-04 11:24:02.693201+00
5	2025-12-25	1947	2	2026-04-04 11:24:02.693201+00
5	2025-12-26	1949	0	2026-04-04 11:24:02.693201+00
5	2025-12-27	1949	9	2026-04-04 11:24:02.693201+00
5	2025-12-28	1958	11	2026-04-04 11:24:02.693201+00
5	2025-12-29	1969	3	2026-04-04 11:24:02.693201+00
5	2025-12-30	1972	1	2026-04-04 11:24:02.693201+00
5	2025-12-31	1973	1	2026-04-04 11:24:02.693201+00
5	2026-01-01	1974	6	2026-04-04 11:24:02.693201+00
5	2026-01-02	1980	12	2026-04-04 11:24:02.693201+00
5	2026-01-03	1992	12	2026-04-04 11:24:02.693201+00
5	2026-01-04	2004	18	2026-04-04 11:24:02.693201+00
5	2026-01-05	2022	29	2026-04-04 11:24:02.693201+00
5	2026-01-06	2051	15	2026-04-04 11:24:02.693201+00
5	2026-01-07	2066	8	2026-04-04 11:24:02.693201+00
5	2026-01-08	2074	5	2026-04-04 11:24:02.693201+00
5	2026-01-09	2079	6	2026-04-04 11:24:02.693201+00
5	2026-01-10	2085	8	2026-04-04 11:24:02.693201+00
5	2026-01-11	2093	17	2026-04-04 11:24:02.693201+00
5	2026-01-12	2110	16	2026-04-04 11:24:02.693201+00
5	2026-01-13	2126	7	2026-04-04 11:24:02.693201+00
5	2026-01-14	2133	3	2026-04-04 11:24:02.693201+00
5	2026-01-15	2136	5	2026-04-04 11:24:02.693201+00
5	2026-01-16	2141	5	2026-04-04 11:24:02.693201+00
5	2026-01-17	2146	7	2026-04-04 11:24:02.693201+00
5	2026-01-18	2153	2	2026-04-04 11:24:02.693201+00
5	2026-01-19	2155	2	2026-04-04 11:24:02.693201+00
5	2026-01-20	2157	3	2026-04-04 11:24:02.693201+00
5	2026-01-21	2160	8	2026-04-04 11:24:02.693201+00
5	2026-01-22	2168	1	2026-04-04 11:24:02.693201+00
5	2026-01-23	2169	10	2026-04-04 11:24:02.693201+00
5	2026-01-24	2179	2	2026-04-04 11:24:02.693201+00
5	2026-01-25	2181	2	2026-04-04 11:24:02.693201+00
5	2026-01-26	2183	0	2026-04-04 11:24:02.693201+00
5	2026-01-27	2183	8	2026-04-04 11:24:02.693201+00
5	2026-01-28	2191	2	2026-04-04 11:24:02.693201+00
5	2026-01-29	2193	4	2026-04-04 11:24:02.693201+00
5	2026-01-30	2197	1	2026-04-04 11:24:02.693201+00
5	2026-01-31	2198	0	2026-04-04 11:24:02.693201+00
5	2026-02-01	2198	9	2026-04-04 11:24:02.693201+00
5	2026-02-02	2207	3	2026-04-04 11:24:02.693201+00
5	2026-02-03	2210	0	2026-04-04 11:24:02.693201+00
5	2026-02-04	2210	1	2026-04-04 11:24:02.693201+00
5	2026-02-05	2211	2	2026-04-04 11:24:02.693201+00
5	2026-02-06	2213	4	2026-04-04 11:24:02.693201+00
5	2026-02-07	2217	13	2026-04-04 11:24:02.693201+00
5	2026-02-08	2230	1	2026-04-04 11:24:02.693201+00
5	2026-02-09	2231	7	2026-04-04 11:24:02.693201+00
5	2026-02-10	2238	5	2026-04-04 11:24:02.693201+00
5	2026-02-11	2243	2	2026-04-04 11:24:02.693201+00
5	2026-02-12	2245	4	2026-04-04 11:24:02.693201+00
5	2026-02-13	2249	9	2026-04-04 11:24:02.693201+00
5	2026-02-14	2258	2	2026-04-04 11:24:02.693201+00
5	2026-02-15	2260	16	2026-04-04 11:24:02.693201+00
5	2026-02-16	2276	43	2026-04-04 11:24:02.693201+00
5	2026-02-17	2319	28	2026-04-04 11:24:02.693201+00
5	2026-02-18	2347	11	2026-04-04 11:24:02.693201+00
5	2026-02-19	2358	6	2026-04-04 11:24:02.693201+00
5	2026-02-20	2364	8	2026-04-04 11:24:02.693201+00
5	2026-02-21	2372	5	2026-04-04 11:24:02.693201+00
5	2026-02-22	2377	6	2026-04-04 11:24:02.693201+00
5	2026-02-23	2383	7	2026-04-04 11:24:02.693201+00
5	2026-02-24	2390	3	2026-04-04 11:24:02.693201+00
5	2026-02-25	2393	5	2026-04-04 11:24:02.693201+00
5	2026-02-26	2398	4	2026-04-04 11:24:02.693201+00
5	2026-02-27	2402	1	2026-04-04 11:24:02.693201+00
5	2026-02-28	2403	-1	2026-04-04 11:24:02.693201+00
5	2026-03-01	2402	4	2026-04-04 11:24:02.693201+00
5	2026-03-02	2406	3	2026-04-04 11:24:02.693201+00
5	2026-03-03	2409	6	2026-04-04 11:24:02.693201+00
5	2026-03-04	2415	6	2026-04-04 11:24:02.693201+00
5	2026-03-05	2421	3	2026-04-04 11:24:02.693201+00
5	2026-03-06	2424	4	2026-04-04 11:24:02.693201+00
5	2026-03-07	2428	0	2026-04-04 11:24:02.693201+00
5	2026-03-08	2428	6	2026-04-04 11:24:02.693201+00
5	2026-03-09	2434	56	2026-04-04 11:24:02.693201+00
5	2026-03-10	2490	6	2026-04-04 11:24:02.693201+00
5	2026-03-11	2496	17	2026-04-04 11:24:02.693201+00
5	2026-03-12	2513	12	2026-04-04 11:24:02.693201+00
5	2026-03-13	2525	3	2026-04-04 11:24:02.693201+00
5	2026-03-14	2528	7	2026-04-04 11:24:02.693201+00
5	2026-03-15	2535	4	2026-04-04 11:24:02.693201+00
5	2026-03-16	2539	5	2026-04-04 11:24:02.693201+00
5	2026-03-17	2544	5	2026-04-04 11:24:02.693201+00
5	2026-03-18	2549	5	2026-04-04 11:24:02.693201+00
5	2026-03-19	2554	1	2026-04-04 11:24:02.693201+00
5	2026-03-20	2555	2	2026-04-04 11:24:02.693201+00
5	2026-03-21	2557	3	2026-04-04 11:24:02.693201+00
5	2026-03-22	2560	4	2026-04-04 11:24:02.693201+00
5	2026-03-23	2564	6	2026-04-04 11:24:02.693201+00
5	2026-03-24	2570	1	2026-04-04 11:24:02.693201+00
5	2026-03-25	2571	1	2026-04-04 11:24:02.693201+00
5	2026-03-26	2572	2	2026-04-04 11:24:02.693201+00
5	2026-03-27	2574	2	2026-04-04 11:24:02.693201+00
5	2026-03-28	2576	1	2026-04-04 11:24:02.693201+00
5	2026-03-29	2577	3	2026-04-04 11:24:02.693201+00
5	2026-03-30	2580	3	2026-04-04 11:24:02.693201+00
5	2026-03-31	2583	12	2026-04-04 11:24:02.693201+00
5	2026-04-01	2595	0	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_gender; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_gender (client_id, gender, distribution, updated_at) FROM stdin;
1	Male	55.00	2026-03-20 12:52:36.37106+00
1	Female	45.00	2026-03-20 12:52:36.37106+00
5	Female	72.00	2026-04-04 11:24:02.693201+00
5	Male	28.00	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_overview; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_overview (client_id, date, views, likes, comments, shares, updated_at) FROM stdin;
1	2025-03-18	41460	1654	18	363	2026-03-20 12:52:36.37106+00
1	2025-03-19	4597	176	1	52	2026-03-20 12:52:36.37106+00
1	2025-03-20	1808	56	0	15	2026-03-20 12:52:36.37106+00
1	2025-03-21	1457	36	0	20	2026-03-20 12:52:36.37106+00
1	2025-03-22	1254	28	0	13	2026-03-20 12:52:36.37106+00
1	2025-03-23	1123	24	0	6	2026-03-20 12:52:36.37106+00
1	2025-03-24	2097	13	1	8	2026-03-20 12:52:36.37106+00
1	2025-03-25	3149	83	2	12	2026-03-20 12:52:36.37106+00
1	2025-03-26	1567	14	0	7	2026-03-20 12:52:36.37106+00
1	2025-03-27	1720	14	0	8	2026-03-20 12:52:36.37106+00
1	2025-03-28	1029	12	1	4	2026-03-20 12:52:36.37106+00
1	2025-03-29	972	13	0	6	2026-03-20 12:52:36.37106+00
1	2025-03-30	1068	13	1	7	2026-03-20 12:52:36.37106+00
1	2025-03-31	941	9	0	3	2026-03-20 12:52:36.37106+00
1	2025-04-01	926	13	0	5	2026-03-20 12:52:36.37106+00
1	2025-04-02	711	10	0	4	2026-03-20 12:52:36.37106+00
1	2025-04-03	938	15	0	5	2026-03-20 12:52:36.37106+00
1	2025-04-04	1245	10	5	7	2026-03-20 12:52:36.37106+00
1	2025-04-05	903	9	0	5	2026-03-20 12:52:36.37106+00
1	2025-04-06	806	7	1	3	2026-03-20 12:52:36.37106+00
1	2025-04-07	708	14	1	2	2026-03-20 12:52:36.37106+00
1	2025-04-08	695	7	0	3	2026-03-20 12:52:36.37106+00
1	2025-04-09	612	10	0	3	2026-03-20 12:52:36.37106+00
1	2025-04-10	1784	74	0	16	2026-03-20 12:52:36.37106+00
1	2025-04-11	847	14	1	9	2026-03-20 12:52:36.37106+00
1	2025-04-12	4292	102	5	30	2026-03-20 12:52:36.37106+00
1	2025-04-13	4174	57	0	31	2026-03-20 12:52:36.37106+00
1	2025-04-14	2345	29	0	19	2026-03-20 12:52:36.37106+00
1	2025-04-15	1463	46	2	10	2026-03-20 12:52:36.37106+00
1	2025-04-16	1133	12	0	6	2026-03-20 12:52:36.37106+00
1	2025-04-17	1099	12	0	10	2026-03-20 12:52:36.37106+00
1	2025-04-18	920	13	0	6	2026-03-20 12:52:36.37106+00
1	2025-04-19	823	8	1	3	2026-03-20 12:52:36.37106+00
1	2025-04-20	906	16	0	3	2026-03-20 12:52:36.37106+00
1	2025-04-21	883	13	0	6	2026-03-20 12:52:36.37106+00
1	2025-04-22	1116	27	2	2	2026-03-20 12:52:36.37106+00
1	2025-04-23	842	15	0	8	2026-03-20 12:52:36.37106+00
1	2025-04-24	524	13	1	6	2026-03-20 12:52:36.37106+00
1	2025-04-25	497	4	1	4	2026-03-20 12:52:36.37106+00
1	2025-04-26	802	16	0	4	2026-03-20 12:52:36.37106+00
1	2025-04-27	775	15	1	6	2026-03-20 12:52:36.37106+00
1	2025-04-28	704	17	2	7	2026-03-20 12:52:36.37106+00
1	2025-04-29	1048	32	0	15	2026-03-20 12:52:36.37106+00
1	2025-04-30	800	29	0	6	2026-03-20 12:52:36.37106+00
1	2025-05-01	650	10	1	5	2026-03-20 12:52:36.37106+00
1	2025-05-02	646	20	0	7	2026-03-20 12:52:36.37106+00
1	2025-05-03	1514	39	1	4	2026-03-20 12:52:36.37106+00
1	2025-05-04	1525	40	1	16	2026-03-20 12:52:36.37106+00
1	2025-05-05	799	17	0	6	2026-03-20 12:52:36.37106+00
1	2025-05-06	1504	46	0	8	2026-03-20 12:52:36.37106+00
1	2025-05-07	713	11	0	8	2026-03-20 12:52:36.37106+00
1	2025-05-08	637	3	0	4	2026-03-20 12:52:36.37106+00
1	2025-05-09	838	19	0	28	2026-03-20 12:52:36.37106+00
1	2025-05-10	841	24	0	3	2026-03-20 12:52:36.37106+00
1	2025-05-11	551	7	0	4	2026-03-20 12:52:36.37106+00
1	2025-05-12	683	18	0	5	2026-03-20 12:52:36.37106+00
1	2025-05-13	630	10	0	4	2026-03-20 12:52:36.37106+00
1	2025-05-14	902	26	1	2	2026-03-20 12:52:36.37106+00
1	2025-05-15	466	13	0	2	2026-03-20 12:52:36.37106+00
1	2025-05-16	446	4	0	6	2026-03-20 12:52:36.37106+00
1	2025-05-17	322	6	0	6	2026-03-20 12:52:36.37106+00
1	2025-05-18	299	6	0	1	2026-03-20 12:52:36.37106+00
1	2025-05-19	270	3	0	3	2026-03-20 12:52:36.37106+00
1	2025-05-20	685	9	1	3	2026-03-20 12:52:36.37106+00
1	2025-05-21	316	6	0	2	2026-03-20 12:52:36.37106+00
1	2025-05-22	8856	312	1	42	2026-03-20 12:52:36.37106+00
1	2025-05-23	36721	1321	11	54	2026-03-20 12:52:36.37106+00
1	2025-05-24	4480	157	0	2	2026-03-20 12:52:36.37106+00
1	2025-05-25	4478	143	0	5	2026-03-20 12:52:36.37106+00
1	2025-05-26	794	21	1	4	2026-03-20 12:52:36.37106+00
1	2025-05-27	965	33	1	0	2026-03-20 12:52:36.37106+00
1	2025-05-28	2497	36	2	5	2026-03-20 12:52:36.37106+00
1	2025-05-29	1201	8	0	4	2026-03-20 12:52:36.37106+00
1	2025-05-30	1515	14	0	0	2026-03-20 12:52:36.37106+00
1	2025-05-31	795	10	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-01	612	9	1	0	2026-03-20 12:52:36.37106+00
1	2025-06-02	440	3	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-03	745	29	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-04	482	10	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-05	470	4	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-06	703	16	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-07	554	17	0	2	2026-03-20 12:52:36.37106+00
1	2025-06-08	761	19	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-09	474	10	0	2	2026-03-20 12:52:36.37106+00
1	2025-06-10	575	5	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-11	540	12	1	0	2026-03-20 12:52:36.37106+00
1	2025-06-12	483	10	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-13	665	10	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-14	507	10	1	1	2026-03-20 12:52:36.37106+00
1	2025-06-15	591	13	1	1	2026-03-20 12:52:36.37106+00
1	2025-06-16	511	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-17	469	10	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-18	341	6	0	2	2026-03-20 12:52:36.37106+00
1	2025-06-19	387	14	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-20	375	7	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-21	355	16	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-22	1129	33	1	4	2026-03-20 12:52:36.37106+00
1	2025-06-23	923	33	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-24	512	19	0	3	2026-03-20 12:52:36.37106+00
1	2025-06-25	485	9	0	2	2026-03-20 12:52:36.37106+00
1	2025-06-26	355	9	0	3	2026-03-20 12:52:36.37106+00
1	2025-06-27	276	6	0	1	2026-03-20 12:52:36.37106+00
1	2025-06-28	1301	14	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-29	311	11	0	0	2026-03-20 12:52:36.37106+00
1	2025-06-30	401	9	0	2	2026-03-20 12:52:36.37106+00
1	2025-07-01	281	8	0	1	2026-03-20 12:52:36.37106+00
1	2025-07-02	263	9	2	1	2026-03-20 12:52:36.37106+00
1	2025-07-03	278	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-04	987	39	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-05	1318	57	1	5	2026-03-20 12:52:36.37106+00
1	2025-07-06	509	13	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-07	455	12	0	1	2026-03-20 12:52:36.37106+00
1	2025-07-08	362	9	0	2	2026-03-20 12:52:36.37106+00
1	2025-07-09	1645	58	0	11	2026-03-20 12:52:36.37106+00
1	2025-07-10	559	13	0	3	2026-03-20 12:52:36.37106+00
1	2025-07-11	461	7	0	4	2026-03-20 12:52:36.37106+00
1	2025-07-12	257	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-13	383	8	1	2	2026-03-20 12:52:36.37106+00
1	2025-07-14	248	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-15	214	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-16	144	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-17	175	1	0	1	2026-03-20 12:52:36.37106+00
1	2025-07-18	279	9	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-19	257	3	0	1	2026-03-20 12:52:36.37106+00
1	2025-07-20	1310	58	0	6	2026-03-20 12:52:36.37106+00
1	2025-07-21	578	16	1	1	2026-03-20 12:52:36.37106+00
1	2025-07-22	224	3	0	3	2026-03-20 12:52:36.37106+00
1	2025-07-23	484	12	1	3	2026-03-20 12:52:36.37106+00
1	2025-07-24	232	9	0	3	2026-03-20 12:52:36.37106+00
1	2025-07-25	365	4	0	2	2026-03-20 12:52:36.37106+00
1	2025-07-26	211	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-27	249	7	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-28	372	9	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-29	233	8	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-30	266	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-07-31	407	6	1	1	2026-03-20 12:52:36.37106+00
1	2025-08-01	218	6	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-02	221	3	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-03	185	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-04	297	4	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-05	257	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-06	154	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-07	121	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-08	169	3	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-09	141	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-10	209	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-11	119	1	1	0	2026-03-20 12:52:36.37106+00
1	2025-08-12	145	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-13	106	3	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-14	730	44	0	3	2026-03-20 12:52:36.37106+00
1	2025-08-15	297	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-16	193	4	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-17	217	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-18	216	7	0	1	2026-03-20 12:52:36.37106+00
1	2025-08-19	201	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-20	159	3	0	2	2026-03-20 12:52:36.37106+00
1	2025-08-21	101	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-22	132	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-23	173	1	2	0	2026-03-20 12:52:36.37106+00
1	2025-08-24	445	14	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-25	171	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-26	188	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-27	201	4	0	1	2026-03-20 12:52:36.37106+00
1	2025-08-28	141	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-29	121	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-08-30	195	1	0	1	2026-03-20 12:52:36.37106+00
1	2025-08-31	138	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-01	181	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-02	645	14	0	6	2026-03-20 12:52:36.37106+00
1	2025-09-03	581	3	0	3	2026-03-20 12:52:36.37106+00
1	2025-09-04	188	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-05	155	0	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-06	253	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-07	159	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-08	155	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-09	337	5	0	1	2026-03-20 12:52:36.37106+00
1	2025-09-10	158	2	0	1	2026-03-20 12:52:36.37106+00
1	2025-09-11	146	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-12	209	3	1	1	2026-03-20 12:52:36.37106+00
1	2025-09-13	144	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-14	178	3	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-15	591	28	-1	1	2026-03-20 12:52:36.37106+00
1	2025-09-16	199	3	0	4	2026-03-20 12:52:36.37106+00
1	2025-09-17	238	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-18	149	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-19	133	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-20	196	3	0	1	2026-03-20 12:52:36.37106+00
1	2025-09-21	853	16	0	2	2026-03-20 12:52:36.37106+00
1	2025-09-22	335	5	0	2	2026-03-20 12:52:36.37106+00
1	2025-09-23	160	4	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-24	141	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-09-25	4134	190	4	13	2026-03-20 12:52:36.37106+00
1	2025-09-26	2577	94	1	7	2026-03-20 12:52:36.37106+00
1	2025-09-27	1024	19	0	1	2026-03-20 12:52:36.37106+00
1	2025-09-28	656	20	1	0	2026-03-20 12:52:36.37106+00
1	2025-09-29	504	21	2	0	2026-03-20 12:52:36.37106+00
1	2025-09-30	401	9	0	2	2026-03-20 12:52:36.37106+00
1	2025-10-01	568	12	0	2	2026-03-20 12:52:36.37106+00
1	2025-10-02	413	13	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-03	314	5	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-04	874	26	0	3	2026-03-20 12:52:36.37106+00
1	2025-10-05	511	12	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-06	358	20	2	0	2026-03-20 12:52:36.37106+00
1	2025-10-07	958	27	1	7	2026-03-20 12:52:36.37106+00
1	2025-10-08	287	2	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-09	420	4	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-10	1288	45	1	1	2026-03-20 12:52:36.37106+00
1	2025-10-11	293	4	0	2	2026-03-20 12:52:36.37106+00
1	2025-10-12	291	0	0	1	2026-03-20 12:52:36.37106+00
1	2025-10-13	268	1	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-14	4338	145	0	17	2026-03-20 12:52:36.37106+00
1	2025-10-15	8411	231	3	22	2026-03-20 12:52:36.37106+00
1	2025-10-16	4904	163	3	13	2026-03-20 12:52:36.37106+00
1	2025-10-17	1479	48	-1	3	2026-03-20 12:52:36.37106+00
1	2025-10-18	848	24	2	1	2026-03-20 12:52:36.37106+00
1	2025-10-19	1026	26	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-20	505	5	0	3	2026-03-20 12:52:36.37106+00
1	2025-10-21	3051	152	8	47	2026-03-20 12:52:36.37106+00
1	2025-10-22	2406	76	1	12	2026-03-20 12:52:36.37106+00
1	2025-10-23	1007	20	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-24	1234	21	0	9	2026-03-20 12:52:36.37106+00
1	2025-10-25	676	19	0	4	2026-03-20 12:52:36.37106+00
1	2025-10-26	1342	67	2	2	2026-03-20 12:52:36.37106+00
1	2025-10-27	864	17	0	3	2026-03-20 12:52:36.37106+00
1	2025-10-28	809	18	0	7	2026-03-20 12:52:36.37106+00
1	2025-10-29	1016	46	1	5	2026-03-20 12:52:36.37106+00
1	2025-10-30	621	25	0	0	2026-03-20 12:52:36.37106+00
1	2025-10-31	371	13	-1	0	2026-03-20 12:52:36.37106+00
1	2025-11-01	467	29	0	3	2026-03-20 12:52:36.37106+00
1	2025-11-02	434	26	1	2	2026-03-20 12:52:36.37106+00
1	2025-11-03	473	27	0	1	2026-03-20 12:52:36.37106+00
1	2025-11-04	315	16	0	0	2026-03-20 12:52:36.37106+00
1	2025-11-05	450	8	1	5	2026-03-20 12:52:36.37106+00
1	2025-11-06	6906	292	7	11	2026-03-20 12:52:36.37106+00
1	2025-11-07	30265	1155	23	156	2026-03-20 12:52:36.37106+00
1	2025-11-08	47235	2041	13	439	2026-03-20 12:52:36.37106+00
1	2025-11-09	16245	711	9	121	2026-03-20 12:52:36.37106+00
1	2025-11-10	10464	244	3	100	2026-03-20 12:52:36.37106+00
1	2025-11-11	5841	218	2	16	2026-03-20 12:52:36.37106+00
1	2025-11-12	2778	72	1	25	2026-03-20 12:52:36.37106+00
1	2025-11-13	1396	37	0	12	2026-03-20 12:52:36.37106+00
1	2025-11-14	1510	40	1	6	2026-03-20 12:52:36.37106+00
1	2025-11-15	1604	59	0	6	2026-03-20 12:52:36.37106+00
1	2025-11-16	1205	31	0	3	2026-03-20 12:52:36.37106+00
1	2025-11-17	1034	31	2	6	2026-03-20 12:52:36.37106+00
1	2025-11-18	1181	46	1	6	2026-03-20 12:52:36.37106+00
1	2025-11-19	1045	56	1	4	2026-03-20 12:52:36.37106+00
1	2025-11-20	4058	194	4	10	2026-03-20 12:52:36.37106+00
1	2025-11-21	2703	109	1	8	2026-03-20 12:52:36.37106+00
1	2025-11-22	1893	92	1	10	2026-03-20 12:52:36.37106+00
1	2025-11-23	1597	54	0	13	2026-03-20 12:52:36.37106+00
1	2025-11-24	2487	133	0	6	2026-03-20 12:52:36.37106+00
1	2025-11-25	1526	81	1	5	2026-03-20 12:52:36.37106+00
1	2025-11-26	7694	261	0	53	2026-03-20 12:52:36.37106+00
1	2025-11-27	11154	359	2	136	2026-03-20 12:52:36.37106+00
1	2025-11-28	2934	105	0	21	2026-03-20 12:52:36.37106+00
1	2025-11-29	2662	130	2	28	2026-03-20 12:52:36.37106+00
1	2025-11-30	2275	119	0	30	2026-03-20 12:52:36.37106+00
1	2025-12-01	2634	118	2	11	2026-03-20 12:52:36.37106+00
1	2025-12-02	4061	160	0	12	2026-03-20 12:52:36.37106+00
1	2025-12-03	4489	163	2	21	2026-03-20 12:52:36.37106+00
1	2025-12-04	2095	103	2	9	2026-03-20 12:52:36.37106+00
1	2025-12-05	1536	56	2	8	2026-03-20 12:52:36.37106+00
1	2025-12-06	2378	84	0	14	2026-03-20 12:52:36.37106+00
1	2025-12-07	1886	73	0	6	2026-03-20 12:52:36.37106+00
1	2025-12-08	4217	181	1	12	2026-03-20 12:52:36.37106+00
1	2025-12-09	2605	90	1	19	2026-03-20 12:52:36.37106+00
1	2025-12-10	1843	54	1	7	2026-03-20 12:52:36.37106+00
1	2025-12-11	2393	100	4	30	2026-03-20 12:52:36.37106+00
1	2025-12-12	1698	47	3	12	2026-03-20 12:52:36.37106+00
1	2025-12-13	2052	66	-1	11	2026-03-20 12:52:36.37106+00
1	2025-12-14	1508	53	0	14	2026-03-20 12:52:36.37106+00
1	2025-12-15	1565	47	1	16	2026-03-20 12:52:36.37106+00
1	2025-12-16	7916	411	4	19	2026-03-20 12:52:36.37106+00
1	2025-12-17	12943	686	11	22	2026-03-20 12:52:36.37106+00
1	2025-12-18	6164	344	4	24	2026-03-20 12:52:36.37106+00
1	2025-12-19	3033	152	1	14	2026-03-20 12:52:36.37106+00
1	2025-12-20	1998	82	1	11	2026-03-20 12:52:36.37106+00
1	2025-12-21	1931	91	0	11	2026-03-20 12:52:36.37106+00
1	2025-12-22	12429	297	12	45	2026-03-20 12:52:36.37106+00
1	2025-12-23	18052	496	20	99	2026-03-20 12:52:36.37106+00
1	2025-12-24	11029	331	6	63	2026-03-20 12:52:36.37106+00
1	2025-12-25	6683	238	25	34	2026-03-20 12:52:36.37106+00
1	2025-12-26	6461	232	13	37	2026-03-20 12:52:36.37106+00
1	2025-12-27	6598	221	5	40	2026-03-20 12:52:36.37106+00
1	2025-12-28	5695	220	3	34	2026-03-20 12:52:36.37106+00
1	2025-12-29	4320	167	3	29	2026-03-20 12:52:36.37106+00
1	2025-12-30	88123	3572	47	806	2026-03-20 12:52:36.37106+00
1	2025-12-31	166405	8248	43	1715	2026-03-20 12:52:36.37106+00
1	2026-01-01	69383	3428	19	717	2026-03-20 12:52:36.37106+00
1	2026-01-02	33354	1460	9	388	2026-03-20 12:52:36.37106+00
1	2026-01-03	18172	766	8	226	2026-03-20 12:52:36.37106+00
1	2026-01-04	16297	756	6	212	2026-03-20 12:52:36.37106+00
1	2026-01-05	15379	719	44	199	2026-03-20 12:52:36.37106+00
1	2026-01-06	12096	485	9	175	2026-03-20 12:52:36.37106+00
1	2026-01-07	10311	501	18	112	2026-03-20 12:52:36.37106+00
1	2026-01-08	6843	297	8	72	2026-03-20 12:52:36.37106+00
1	2026-01-09	5786	219	2	61	2026-03-20 12:52:36.37106+00
1	2026-01-10	6716	229	2	74	2026-03-20 12:52:36.37106+00
1	2026-01-11	6601	285	10	84	2026-03-20 12:52:36.37106+00
1	2026-01-12	5515	175	2	78	2026-03-20 12:52:36.37106+00
1	2026-01-13	9456	425	12	105	2026-03-20 12:52:36.37106+00
1	2026-01-14	9788	346	9	87	2026-03-20 12:52:36.37106+00
1	2026-01-15	6085	207	3	67	2026-03-20 12:52:36.37106+00
1	2026-01-16	6441	235	7	56	2026-03-20 12:52:36.37106+00
1	2026-01-17	7101	259	1	84	2026-03-20 12:52:36.37106+00
1	2026-01-18	5644	206	1	60	2026-03-20 12:52:36.37106+00
1	2026-01-19	4475	191	0	50	2026-03-20 12:52:36.37106+00
1	2026-01-20	3716	109	2	45	2026-03-20 12:52:36.37106+00
1	2026-01-21	4735	152	4	52	2026-03-20 12:52:36.37106+00
1	2026-01-22	3028	100	2	47	2026-03-20 12:52:36.37106+00
1	2026-01-23	3095	99	-1	35	2026-03-20 12:52:36.37106+00
1	2026-01-24	4403	120	0	49	2026-03-20 12:52:36.37106+00
1	2026-01-25	2652	134	0	28	2026-03-20 12:52:36.37106+00
1	2026-01-26	2445	74	1	23	2026-03-20 12:52:36.37106+00
1	2026-01-27	3051	105	1	31	2026-03-20 12:52:36.37106+00
1	2026-01-28	3330	123	2	34	2026-03-20 12:52:36.37106+00
1	2026-01-29	5049	165	1	40	2026-03-20 12:52:36.37106+00
1	2026-01-30	3798	107	1	33	2026-03-20 12:52:36.37106+00
1	2026-01-31	4438	154	5	58	2026-03-20 12:52:36.37106+00
1	2026-02-01	4155	137	4	44	2026-03-20 12:52:36.37106+00
1	2026-02-02	5342	227	0	48	2026-03-20 12:52:36.37106+00
1	2026-02-03	6211	240	4	74	2026-03-20 12:52:36.37106+00
1	2026-02-04	5848	210	7	72	2026-03-20 12:52:36.37106+00
1	2026-02-05	5223	211	1	46	2026-03-20 12:52:36.37106+00
1	2026-02-06	4961	178	0	43	2026-03-20 12:52:36.37106+00
1	2026-02-07	4918	176	0	64	2026-03-20 12:52:36.37106+00
1	2026-02-08	3823	127	2	50	2026-03-20 12:52:36.37106+00
1	2026-02-09	3274	111	2	37	2026-03-20 12:52:36.37106+00
1	2026-02-10	2919	122	1	28	2026-03-20 12:52:36.37106+00
1	2026-02-11	2779	84	2	32	2026-03-20 12:52:36.37106+00
1	2026-02-12	2263	59	1	35	2026-03-20 12:52:36.37106+00
1	2026-02-13	2444	83	0	25	2026-03-20 12:52:36.37106+00
1	2026-02-14	3899	146	1	54	2026-03-20 12:52:36.37106+00
1	2026-02-15	3661	113	2	47	2026-03-20 12:52:36.37106+00
1	2026-02-16	3346	105	2	45	2026-03-20 12:52:36.37106+00
1	2026-02-17	2853	94	3	41	2026-03-20 12:52:36.37106+00
1	2026-02-18	3181	90	1	40	2026-03-20 12:52:36.37106+00
1	2026-02-19	3983	143	0	35	2026-03-20 12:52:36.37106+00
1	2026-02-20	12780	389	33	64	2026-03-20 12:52:36.37106+00
1	2026-02-21	11232	357	1	72	2026-03-20 12:52:36.37106+00
1	2026-02-22	6267	240	4	44	2026-03-20 12:52:36.37106+00
1	2026-02-23	3046	106	2	37	2026-03-20 12:52:36.37106+00
1	2026-02-24	2866	87	2	23	2026-03-20 12:52:36.37106+00
1	2026-02-25	2589	91	1	18	2026-03-20 12:52:36.37106+00
1	2026-02-26	2148	79	0	25	2026-03-20 12:52:36.37106+00
1	2026-02-27	2134	78	0	24	2026-03-20 12:52:36.37106+00
1	2026-02-28	2062	57	0	27	2026-03-20 12:52:36.37106+00
1	2026-03-01	1457	40	0	10	2026-03-20 12:52:36.37106+00
1	2026-03-02	1358	48	0	12	2026-03-20 12:52:36.37106+00
1	2026-03-03	1336	46	0	16	2026-03-20 12:52:36.37106+00
1	2026-03-04	1359	41	1	21	2026-03-20 12:52:36.37106+00
1	2026-03-05	1213	39	1	10	2026-03-20 12:52:36.37106+00
1	2026-03-06	1294	34	0	10	2026-03-20 12:52:36.37106+00
1	2026-03-07	1319	30	0	15	2026-03-20 12:52:36.37106+00
1	2026-03-08	5494	152	4	18	2026-03-20 12:52:36.37106+00
1	2026-03-09	5446	148	0	20	2026-03-20 12:52:36.37106+00
1	2026-03-10	2192	64	2	17	2026-03-20 12:52:36.37106+00
1	2026-03-11	2119	68	1	20	2026-03-20 12:52:36.37106+00
1	2026-03-12	1456	39	0	9	2026-03-20 12:52:36.37106+00
1	2026-03-13	1445	42	2	15	2026-03-20 12:52:36.37106+00
1	2026-03-14	1317	60	1	21	2026-03-20 12:52:36.37106+00
1	2026-03-15	8067	164	0	28	2026-03-20 12:52:36.37106+00
1	2026-03-16	16917	271	3	52	2026-03-20 12:52:36.37106+00
1	2026-03-17	7136	130	3	29	2026-03-20 12:52:36.37106+00
5	2025-04-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-31	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-31	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-31	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-08	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-09	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-10	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-11	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-12	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-13	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-14	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-15	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-16	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-17	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-18	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-19	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-20	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-21	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-22	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-23	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-24	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-25	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-26	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-27	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-28	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-29	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-30	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-01	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-02	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-03	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-04	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-05	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-06	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-07	0	0	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-08	1356	145	0	5	2026-04-04 11:24:02.693201+00
5	2025-10-09	8852	743	3	136	2026-04-04 11:24:02.693201+00
5	2025-10-10	1764	97	1	15	2026-04-04 11:24:02.693201+00
5	2025-10-11	1471	61	0	9	2026-04-04 11:24:02.693201+00
5	2025-10-12	31526	2360	26	467	2026-04-04 11:24:02.693201+00
5	2025-10-13	16197	1576	14	203	2026-04-04 11:24:02.693201+00
5	2025-10-14	12546	812	8	145	2026-04-04 11:24:02.693201+00
5	2025-10-15	6212	315	7	51	2026-04-04 11:24:02.693201+00
5	2025-10-16	2497	161	0	32	2026-04-04 11:24:02.693201+00
5	2025-10-17	1852	126	2	11	2026-04-04 11:24:02.693201+00
5	2025-10-18	1513	126	3	14	2026-04-04 11:24:02.693201+00
5	2025-10-19	944	72	0	10	2026-04-04 11:24:02.693201+00
5	2025-10-20	589	46	3	2	2026-04-04 11:24:02.693201+00
5	2025-10-21	574	41	0	5	2026-04-04 11:24:02.693201+00
5	2025-10-22	612	38	2	7	2026-04-04 11:24:02.693201+00
5	2025-10-23	236	14	0	2	2026-04-04 11:24:02.693201+00
5	2025-10-24	212	14	1	3	2026-04-04 11:24:02.693201+00
5	2025-10-25	248	10	0	3	2026-04-04 11:24:02.693201+00
5	2025-10-26	938	71	1	16	2026-04-04 11:24:02.693201+00
5	2025-10-27	942	66	0	8	2026-04-04 11:24:02.693201+00
5	2025-10-28	952	62	1	7	2026-04-04 11:24:02.693201+00
5	2025-10-29	964	57	1	9	2026-04-04 11:24:02.693201+00
5	2025-10-30	690	40	0	5	2026-04-04 11:24:02.693201+00
5	2025-10-31	11523	727	11	93	2026-04-04 11:24:02.693201+00
5	2025-11-01	5126	342	3	75	2026-04-04 11:24:02.693201+00
5	2025-11-02	5409	310	2	70	2026-04-04 11:24:02.693201+00
5	2025-11-03	1793	129	0	24	2026-04-04 11:24:02.693201+00
5	2025-11-04	779	39	2	11	2026-04-04 11:24:02.693201+00
5	2025-11-05	539	31	0	9	2026-04-04 11:24:02.693201+00
5	2025-11-06	526	28	0	4	2026-04-04 11:24:02.693201+00
5	2025-11-07	4067	210	0	53	2026-04-04 11:24:02.693201+00
5	2025-11-08	5133	228	3	83	2026-04-04 11:24:02.693201+00
5	2025-11-09	6507	342	6	62	2026-04-04 11:24:02.693201+00
5	2025-11-10	3034	155	1	40	2026-04-04 11:24:02.693201+00
5	2025-11-11	3400	131	0	17	2026-04-04 11:24:02.693201+00
5	2025-11-12	2605	90	2	27	2026-04-04 11:24:02.693201+00
5	2025-11-13	2306	146	0	35	2026-04-04 11:24:02.693201+00
5	2025-11-14	24412	2541	12	547	2026-04-04 11:24:02.693201+00
5	2025-11-15	9792	729	4	137	2026-04-04 11:24:02.693201+00
5	2025-11-16	4400	275	3	42	2026-04-04 11:24:02.693201+00
5	2025-11-17	1881	91	0	25	2026-04-04 11:24:02.693201+00
5	2025-11-18	1437	76	1	12	2026-04-04 11:24:02.693201+00
5	2025-11-19	1069	61	0	17	2026-04-04 11:24:02.693201+00
5	2025-11-20	995	46	0	9	2026-04-04 11:24:02.693201+00
5	2025-11-21	828	40	0	12	2026-04-04 11:24:02.693201+00
5	2025-11-22	1010	47	0	5	2026-04-04 11:24:02.693201+00
5	2025-11-23	1266	65	1	14	2026-04-04 11:24:02.693201+00
5	2025-11-24	1165	61	0	16	2026-04-04 11:24:02.693201+00
5	2025-11-25	1931	157	1	27	2026-04-04 11:24:02.693201+00
5	2025-11-26	7267	553	2	113	2026-04-04 11:24:02.693201+00
5	2025-11-27	1402	86	1	15	2026-04-04 11:24:02.693201+00
5	2025-11-28	1325	86	0	11	2026-04-04 11:24:02.693201+00
5	2025-11-29	1127	59	0	17	2026-04-04 11:24:02.693201+00
5	2025-11-30	1149	73	0	10	2026-04-04 11:24:02.693201+00
5	2025-12-01	1145	69	1	17	2026-04-04 11:24:02.693201+00
5	2025-12-02	932	45	1	13	2026-04-04 11:24:02.693201+00
5	2025-12-03	1047	47	0	10	2026-04-04 11:24:02.693201+00
5	2025-12-04	936	35	0	5	2026-04-04 11:24:02.693201+00
5	2025-12-05	794	25	0	3	2026-04-04 11:24:02.693201+00
5	2025-12-06	814	22	0	1	2026-04-04 11:24:02.693201+00
5	2025-12-07	786	20	0	6	2026-04-04 11:24:02.693201+00
5	2025-12-08	5329	275	2	51	2026-04-04 11:24:02.693201+00
5	2025-12-09	1265	58	0	6	2026-04-04 11:24:02.693201+00
5	2025-12-10	914	25	0	3	2026-04-04 11:24:02.693201+00
5	2025-12-11	709	30	0	4	2026-04-04 11:24:02.693201+00
5	2025-12-12	785	23	0	5	2026-04-04 11:24:02.693201+00
5	2025-12-13	865	32	0	7	2026-04-04 11:24:02.693201+00
5	2025-12-14	781	34	0	2	2026-04-04 11:24:02.693201+00
5	2025-12-15	814	29	0	6	2026-04-04 11:24:02.693201+00
5	2025-12-16	14036	724	7	196	2026-04-04 11:24:02.693201+00
5	2025-12-17	12477	506	7	248	2026-04-04 11:24:02.693201+00
5	2025-12-18	7269	234	2	102	2026-04-04 11:24:02.693201+00
5	2025-12-19	3266	143	1	46	2026-04-04 11:24:02.693201+00
5	2025-12-20	1978	76	0	18	2026-04-04 11:24:02.693201+00
5	2025-12-21	2162	71	-1	21	2026-04-04 11:24:02.693201+00
5	2025-12-22	1775	35	0	21	2026-04-04 11:24:02.693201+00
5	2025-12-23	1619	48	0	22	2026-04-04 11:24:02.693201+00
5	2025-12-24	1533	44	0	14	2026-04-04 11:24:02.693201+00
5	2025-12-25	1260	42	1	11	2026-04-04 11:24:02.693201+00
5	2025-12-26	905	30	0	7	2026-04-04 11:24:02.693201+00
5	2025-12-27	839	35	0	6	2026-04-04 11:24:02.693201+00
5	2025-12-28	1051	20	0	11	2026-04-04 11:24:02.693201+00
5	2025-12-29	1128	36	2	15	2026-04-04 11:24:02.693201+00
5	2025-12-30	527	22	1	5	2026-04-04 11:24:02.693201+00
5	2025-12-31	835	28	0	5	2026-04-04 11:24:02.693201+00
5	2026-01-01	1031	40	-1	17	2026-04-04 11:24:02.693201+00
5	2026-01-02	1331	39	0	17	2026-04-04 11:24:02.693201+00
5	2026-01-03	1672	53	1	17	2026-04-04 11:24:02.693201+00
5	2026-01-04	1649	58	0	27	2026-04-04 11:24:02.693201+00
5	2026-01-05	1517	57	2	16	2026-04-04 11:24:02.693201+00
5	2026-01-06	2662	91	0	41	2026-04-04 11:24:02.693201+00
5	2026-01-07	1723	68	3	15	2026-04-04 11:24:02.693201+00
5	2026-01-08	926	34	0	10	2026-04-04 11:24:02.693201+00
5	2026-01-09	877	25	0	7	2026-04-04 11:24:02.693201+00
5	2026-01-10	1237	59	0	7	2026-04-04 11:24:02.693201+00
5	2026-01-11	1145	59	2	14	2026-04-04 11:24:02.693201+00
5	2026-01-12	2527	108	3	36	2026-04-04 11:24:02.693201+00
5	2026-01-13	3362	239	0	36	2026-04-04 11:24:02.693201+00
5	2026-01-14	1358	57	1	14	2026-04-04 11:24:02.693201+00
5	2026-01-15	1063	37	1	14	2026-04-04 11:24:02.693201+00
5	2026-01-16	991	45	0	12	2026-04-04 11:24:02.693201+00
5	2026-01-17	1318	65	1	17	2026-04-04 11:24:02.693201+00
5	2026-01-18	716	28	0	7	2026-04-04 11:24:02.693201+00
5	2026-01-19	416	19	0	10	2026-04-04 11:24:02.693201+00
5	2026-01-20	668	28	0	9	2026-04-04 11:24:02.693201+00
5	2026-01-21	679	29	0	14	2026-04-04 11:24:02.693201+00
5	2026-01-22	580	26	0	9	2026-04-04 11:24:02.693201+00
5	2026-01-23	558	26	0	11	2026-04-04 11:24:02.693201+00
5	2026-01-24	1019	32	0	13	2026-04-04 11:24:02.693201+00
5	2026-01-25	610	27	0	5	2026-04-04 11:24:02.693201+00
5	2026-01-26	579	11	0	2	2026-04-04 11:24:02.693201+00
5	2026-01-27	1024	95	8	6	2026-04-04 11:24:02.693201+00
5	2026-01-28	1703	133	1	16	2026-04-04 11:24:02.693201+00
5	2026-01-29	466	21	0	6	2026-04-04 11:24:02.693201+00
5	2026-01-30	551	20	0	8	2026-04-04 11:24:02.693201+00
5	2026-01-31	430	18	0	7	2026-04-04 11:24:02.693201+00
5	2026-02-01	1040	45	0	2	2026-04-04 11:24:02.693201+00
5	2026-02-02	821	31	1	7	2026-04-04 11:24:02.693201+00
5	2026-02-03	452	10	0	4	2026-04-04 11:24:02.693201+00
5	2026-02-04	346	9	1	0	2026-04-04 11:24:02.693201+00
5	2026-02-05	306	14	0	9	2026-04-04 11:24:02.693201+00
5	2026-02-06	431	9	0	3	2026-04-04 11:24:02.693201+00
5	2026-02-07	406	23	1	2	2026-04-04 11:24:02.693201+00
5	2026-02-08	970	19	0	7	2026-04-04 11:24:02.693201+00
5	2026-02-09	536	5	0	4	2026-04-04 11:24:02.693201+00
5	2026-02-10	1347	68	3	5	2026-04-04 11:24:02.693201+00
5	2026-02-11	671	9	0	12	2026-04-04 11:24:02.693201+00
5	2026-02-12	662	7	0	2	2026-04-04 11:24:02.693201+00
5	2026-02-13	570	7	2	5	2026-04-04 11:24:02.693201+00
5	2026-02-14	606	13	0	7	2026-04-04 11:24:02.693201+00
5	2026-02-15	525	10	0	13	2026-04-04 11:24:02.693201+00
5	2026-02-16	4975	251	1	41	2026-04-04 11:24:02.693201+00
5	2026-02-17	5806	291	0	47	2026-04-04 11:24:02.693201+00
5	2026-02-18	5024	154	0	45	2026-04-04 11:24:02.693201+00
5	2026-02-19	1654	55	2	29	2026-04-04 11:24:02.693201+00
5	2026-02-20	1407	39	1	13	2026-04-04 11:24:02.693201+00
5	2026-02-21	1385	45	2	10	2026-04-04 11:24:02.693201+00
5	2026-02-22	1055	33	1	9	2026-04-04 11:24:02.693201+00
5	2026-02-23	1085	44	0	13	2026-04-04 11:24:02.693201+00
5	2026-02-24	2875	150	5	10	2026-04-04 11:24:02.693201+00
5	2026-02-25	945	38	0	17	2026-04-04 11:24:02.693201+00
5	2026-02-26	862	27	0	6	2026-04-04 11:24:02.693201+00
5	2026-02-27	660	19	1	8	2026-04-04 11:24:02.693201+00
5	2026-02-28	853	25	1	12	2026-04-04 11:24:02.693201+00
5	2026-03-01	734	25	0	3	2026-04-04 11:24:02.693201+00
5	2026-03-02	992	36	4	19	2026-04-04 11:24:02.693201+00
5	2026-03-03	2016	104	1	25	2026-04-04 11:24:02.693201+00
5	2026-03-04	1003	52	1	15	2026-04-04 11:24:02.693201+00
5	2026-03-05	987	43	1	10	2026-04-04 11:24:02.693201+00
5	2026-03-06	835	20	0	4	2026-04-04 11:24:02.693201+00
5	2026-03-07	817	19	0	1	2026-04-04 11:24:02.693201+00
5	2026-03-08	734	26	0	7	2026-04-04 11:24:02.693201+00
5	2026-03-09	3635	167	2	27	2026-04-04 11:24:02.693201+00
5	2026-03-10	11473	560	4	124	2026-04-04 11:24:02.693201+00
5	2026-03-11	2671	119	0	13	2026-04-04 11:24:02.693201+00
5	2026-03-12	5622	246	0	45	2026-04-04 11:24:02.693201+00
5	2026-03-13	1800	66	0	15	2026-04-04 11:24:02.693201+00
5	2026-03-14	1147	52	0	14	2026-04-04 11:24:02.693201+00
5	2026-03-15	977	40	1	10	2026-04-04 11:24:02.693201+00
5	2026-03-16	1032	40	0	10	2026-04-04 11:24:02.693201+00
5	2026-03-17	866	25	0	2	2026-04-04 11:24:02.693201+00
5	2026-03-18	1130	47	2	9	2026-04-04 11:24:02.693201+00
5	2026-03-19	919	41	0	10	2026-04-04 11:24:02.693201+00
5	2026-03-20	713	25	0	2	2026-04-04 11:24:02.693201+00
5	2026-03-21	640	22	1	10	2026-04-04 11:24:02.693201+00
5	2026-03-22	606	14	0	7	2026-04-04 11:24:02.693201+00
5	2026-03-23	594	23	0	2	2026-04-04 11:24:02.693201+00
5	2026-03-24	465	6	0	4	2026-04-04 11:24:02.693201+00
5	2026-03-25	545	12	0	4	2026-04-04 11:24:02.693201+00
5	2026-03-26	588	13	0	4	2026-04-04 11:24:02.693201+00
5	2026-03-27	1116	30	0	10	2026-04-04 11:24:02.693201+00
5	2026-03-28	783	16	0	12	2026-04-04 11:24:02.693201+00
5	2026-03-29	885	20	0	6	2026-04-04 11:24:02.693201+00
5	2026-03-30	710	9	0	7	2026-04-04 11:24:02.693201+00
5	2026-03-31	771	18	0	3	2026-04-04 11:24:02.693201+00
5	2026-04-01	845	15	1	4	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_territories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_territories (client_id, territory, distribution, updated_at) FROM stdin;
1	MU	78.5000	2026-03-20 12:52:36.37106+00
1	CA	0.3000	2026-03-20 12:52:36.37106+00
1	FR	0.3000	2026-03-20 12:52:36.37106+00
1	AU	0.2000	2026-03-20 12:52:36.37106+00
1	GB	0.2000	2026-03-20 12:52:36.37106+00
1	AE	0.1000	2026-03-20 12:52:36.37106+00
1	RE	0.1000	2026-03-20 12:52:36.37106+00
1	SC	0.1000	2026-03-20 12:52:36.37106+00
1	US	0.1000	2026-03-20 12:52:36.37106+00
1	ZA	0.1000	2026-03-20 12:52:36.37106+00
5	MU	78.0000	2026-04-04 11:24:02.693201+00
5	FR	0.8000	2026-04-04 11:24:02.693201+00
5	GB	0.7000	2026-04-04 11:24:02.693201+00
5	RE	0.5000	2026-04-04 11:24:02.693201+00
5	AE	0.3000	2026-04-04 11:24:02.693201+00
5	CA	0.3000	2026-04-04 11:24:02.693201+00
5	AU	0.2000	2026-04-04 11:24:02.693201+00
5	US	0.2000	2026-04-04 11:24:02.693201+00
5	ZA	0.2000	2026-04-04 11:24:02.693201+00
5	DE	0.1000	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: tiktok_viewers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tiktok_viewers (client_id, date, new_viewers, returning_viewers, updated_at) FROM stdin;
1	2026-03-19	10601	25503	2026-03-20 12:52:36.37106+00
1	2026-03-20	1285	2534	2026-03-20 12:52:36.37106+00
1	2026-03-21	571	932	2026-03-20 12:52:36.37106+00
1	2026-03-22	621	581	2026-03-20 12:52:36.37106+00
1	2026-03-23	508	460	2026-03-20 12:52:36.37106+00
1	2026-03-24	452	437	2026-03-20 12:52:36.37106+00
1	2026-03-25	534	1290	2026-03-20 12:52:36.37106+00
1	2026-03-26	591	1840	2026-03-20 12:52:36.37106+00
1	2026-03-27	422	901	2026-03-20 12:52:36.37106+00
1	2026-03-28	486	679	2026-03-20 12:52:36.37106+00
1	2026-03-29	411	434	2026-03-20 12:52:36.37106+00
1	2026-03-30	369	430	2026-03-20 12:52:36.37106+00
1	2025-03-31	389	493	2026-03-20 12:52:36.37106+00
1	2025-04-01	324	370	2026-03-20 12:52:36.37106+00
1	2025-04-02	349	385	2026-03-20 12:52:36.37106+00
1	2025-04-03	294	296	2026-03-20 12:52:36.37106+00
1	2025-04-04	341	388	2026-03-20 12:52:36.37106+00
1	2025-04-05	411	462	2026-03-20 12:52:36.37106+00
1	2025-04-06	360	357	2026-03-20 12:52:36.37106+00
1	2025-04-07	268	374	2026-03-20 12:52:36.37106+00
1	2025-04-08	258	274	2026-03-20 12:52:36.37106+00
1	2025-04-09	275	266	2026-03-20 12:52:36.37106+00
1	2025-04-10	238	222	2026-03-20 12:52:36.37106+00
1	2025-04-11	450	899	2026-03-20 12:52:36.37106+00
1	2025-04-12	333	346	2026-03-20 12:52:36.37106+00
1	2025-04-13	636	2871	2026-03-20 12:52:36.37106+00
1	2025-04-14	453	3119	2026-03-20 12:52:36.37106+00
1	2025-04-15	350	1592	2026-03-20 12:52:36.37106+00
1	2025-04-16	236	947	2026-03-20 12:52:36.37106+00
1	2025-04-17	229	625	2026-03-20 12:52:36.37106+00
1	2025-04-18	225	668	2026-03-20 12:52:36.37106+00
1	2025-04-19	216	571	2026-03-20 12:52:36.37106+00
1	2025-04-20	204	486	2026-03-20 12:52:36.37106+00
1	2025-04-21	260	521	2026-03-20 12:52:36.37106+00
1	2025-04-22	256	452	2026-03-20 12:52:36.37106+00
1	2025-04-23	325	578	2026-03-20 12:52:36.37106+00
1	2025-04-24	266	401	2026-03-20 12:52:36.37106+00
1	2025-04-25	196	212	2026-03-20 12:52:36.37106+00
1	2025-04-26	208	219	2026-03-20 12:52:36.37106+00
1	2025-04-27	271	342	2026-03-20 12:52:36.37106+00
1	2025-04-28	245	305	2026-03-20 12:52:36.37106+00
1	2025-04-29	257	330	2026-03-20 12:52:36.37106+00
1	2025-04-30	304	507	2026-03-20 12:52:36.37106+00
1	2025-05-01	234	340	2026-03-20 12:52:36.37106+00
1	2025-05-02	198	311	2026-03-20 12:52:36.37106+00
1	2025-05-03	233	296	2026-03-20 12:52:36.37106+00
1	2025-05-04	443	811	2026-03-20 12:52:36.37106+00
1	2025-05-05	359	862	2026-03-20 12:52:36.37106+00
1	2025-05-06	216	438	2026-03-20 12:52:36.37106+00
1	2025-05-07	353	754	2026-03-20 12:52:36.37106+00
1	2025-05-08	199	363	2026-03-20 12:52:36.37106+00
1	2025-05-09	179	281	2026-03-20 12:52:36.37106+00
1	2025-05-10	301	381	2026-03-20 12:52:36.37106+00
1	2025-05-11	280	376	2026-03-20 12:52:36.37106+00
1	2025-05-12	191	261	2026-03-20 12:52:36.37106+00
1	2025-05-13	251	323	2026-03-20 12:52:36.37106+00
1	2025-05-14	250	258	2026-03-20 12:52:36.37106+00
1	2025-05-15	135	164	2026-03-20 12:52:36.37106+00
1	2025-05-16	136	162	2026-03-20 12:52:36.37106+00
1	2025-05-17	157	143	2026-03-20 12:52:36.37106+00
1	2025-05-18	137	106	2026-03-20 12:52:36.37106+00
1	2025-05-19	115	88	2026-03-20 12:52:36.37106+00
1	2025-05-20	228	366	2026-03-20 12:52:36.37106+00
1	2025-05-21	224	367	2026-03-20 12:52:36.37106+00
1	2025-05-22	104	93	2026-03-20 12:52:36.37106+00
1	2025-05-23	1971	4909	2026-03-20 12:52:36.37106+00
1	2025-05-24	8164	22790	2026-03-20 12:52:36.37106+00
1	2025-05-25	1192	2564	2026-03-20 12:52:36.37106+00
1	2025-05-26	1379	2484	2026-03-20 12:52:36.37106+00
1	2025-05-27	221	418	2026-03-20 12:52:36.37106+00
1	2025-05-28	290	499	2026-03-20 12:52:36.37106+00
1	2025-05-29	796	1325	2026-03-20 12:52:36.37106+00
1	2025-05-30	364	609	2026-03-20 12:52:36.37106+00
1	2025-05-31	493	770	2026-03-20 12:52:36.37106+00
1	2025-06-01	278	399	2026-03-20 12:52:36.37106+00
1	2025-06-02	245	291	2026-03-20 12:52:36.37106+00
1	2025-06-03	151	233	2026-03-20 12:52:36.37106+00
1	2025-06-04	184	402	2026-03-20 12:52:36.37106+00
1	2025-06-05	135	280	2026-03-20 12:52:36.37106+00
1	2025-06-06	156	258	2026-03-20 12:52:36.37106+00
1	2025-06-07	227	352	2026-03-20 12:52:36.37106+00
1	2025-06-08	198	279	2026-03-20 12:52:36.37106+00
1	2025-06-09	260	287	2026-03-20 12:52:36.37106+00
1	2025-06-10	182	241	2026-03-20 12:52:36.37106+00
1	2025-06-11	167	242	2026-03-20 12:52:36.37106+00
1	2025-06-12	206	225	2026-03-20 12:52:36.37106+00
1	2025-06-13	164	222	2026-03-20 12:52:36.37106+00
1	2025-06-14	255	298	2026-03-20 12:52:36.37106+00
1	2025-06-15	208	241	2026-03-20 12:52:36.37106+00
1	2025-06-16	253	255	2026-03-20 12:52:36.37106+00
1	2025-06-17	192	240	2026-03-20 12:52:36.37106+00
1	2025-06-18	163	241	2026-03-20 12:52:36.37106+00
1	2025-06-19	101	143	2026-03-20 12:52:36.37106+00
1	2025-06-20	138	171	2026-03-20 12:52:36.37106+00
1	2025-06-21	144	182	2026-03-20 12:52:36.37106+00
1	2025-06-22	123	184	2026-03-20 12:52:36.37106+00
1	2025-06-23	267	662	2026-03-20 12:52:36.37106+00
1	2025-06-24	284	471	2026-03-20 12:52:36.37106+00
1	2025-06-25	152	189	2026-03-20 12:52:36.37106+00
1	2025-06-26	106	256	2026-03-20 12:52:36.37106+00
1	2025-06-27	119	156	2026-03-20 12:52:36.37106+00
1	2025-06-28	108	110	2026-03-20 12:52:36.37106+00
1	2025-06-29	187	216	2026-03-20 12:52:36.37106+00
1	2025-06-30	116	122	2026-03-20 12:52:36.37106+00
1	2025-07-01	156	128	2026-03-20 12:52:36.37106+00
1	2025-07-02	115	109	2026-03-20 12:52:36.37106+00
1	2025-07-03	107	87	2026-03-20 12:52:36.37106+00
1	2025-07-04	107	83	2026-03-20 12:52:36.37106+00
1	2025-07-05	220	523	2026-03-20 12:52:36.37106+00
1	2025-07-06	342	811	2026-03-20 12:52:36.37106+00
1	2025-07-07	180	202	2026-03-20 12:52:36.37106+00
1	2025-07-08	103	225	2026-03-20 12:52:36.37106+00
1	2025-07-09	125	175	2026-03-20 12:52:36.37106+00
1	2025-07-10	295	1083	2026-03-20 12:52:36.37106+00
1	2025-07-11	130	203	2026-03-20 12:52:36.37106+00
1	2025-07-12	95	163	2026-03-20 12:52:36.37106+00
1	2025-07-13	64	139	2026-03-20 12:52:36.37106+00
1	2025-07-14	58	85	2026-03-20 12:52:36.37106+00
1	2025-07-15	60	108	2026-03-20 12:52:36.37106+00
1	2025-07-16	51	69	2026-03-20 12:52:36.37106+00
1	2025-07-17	43	61	2026-03-20 12:52:36.37106+00
1	2025-07-18	50	57	2026-03-20 12:52:36.37106+00
1	2025-07-19	119	114	2026-03-20 12:52:36.37106+00
1	2025-07-20	320	692	2026-03-20 12:52:36.37106+00
1	2025-07-21	319	697	2026-03-20 12:52:36.37106+00
1	2025-07-22	103	219	2026-03-20 12:52:36.37106+00
1	2025-07-23	71	91	2026-03-20 12:52:36.37106+00
1	2025-07-24	95	229	2026-03-20 12:52:36.37106+00
1	2025-07-25	86	77	2026-03-20 12:52:36.37106+00
1	2025-07-26	77	95	2026-03-20 12:52:36.37106+00
1	2025-07-27	72	71	2026-03-20 12:52:36.37106+00
1	2025-07-28	61	94	2026-03-20 12:52:36.37106+00
1	2025-07-29	77	112	2026-03-20 12:52:36.37106+00
1	2025-07-30	76	96	2026-03-20 12:52:36.37106+00
1	2025-07-31	75	109	2026-03-20 12:52:36.37106+00
1	2025-08-01	85	127	2026-03-20 12:52:36.37106+00
1	2025-08-02	77	79	2026-03-20 12:52:36.37106+00
1	2025-08-03	88	85	2026-03-20 12:52:36.37106+00
1	2025-08-04	59	66	2026-03-20 12:52:36.37106+00
1	2025-08-05	77	68	2026-03-20 12:52:36.37106+00
1	2025-08-06	81	81	2026-03-20 12:52:36.37106+00
1	2025-08-07	56	62	2026-03-20 12:52:36.37106+00
1	2025-08-08	59	45	2026-03-20 12:52:36.37106+00
1	2025-08-09	79	60	2026-03-20 12:52:36.37106+00
1	2025-08-10	49	56	2026-03-20 12:52:36.37106+00
1	2025-08-11	70	48	2026-03-20 12:52:36.37106+00
1	2025-08-12	66	30	2026-03-20 12:52:36.37106+00
1	2025-08-13	74	40	2026-03-20 12:52:36.37106+00
1	2025-08-14	47	33	2026-03-20 12:52:36.37106+00
1	2025-08-15	182	410	2026-03-20 12:52:36.37106+00
1	2025-08-16	59	123	2026-03-20 12:52:36.37106+00
1	2025-08-17	53	72	2026-03-20 12:52:36.37106+00
1	2025-08-18	65	68	2026-03-20 12:52:36.37106+00
1	2025-08-19	51	61	2026-03-20 12:52:36.37106+00
1	2025-08-20	55	54	2026-03-20 12:52:36.37106+00
1	2025-08-21	60	45	2026-03-20 12:52:36.37106+00
1	2025-08-22	37	45	2026-03-20 12:52:36.37106+00
1	2025-08-23	37	45	2026-03-20 12:52:36.37106+00
1	2025-08-24	51	39	2026-03-20 12:52:36.37106+00
1	2025-08-25	86	178	2026-03-20 12:52:36.37106+00
1	2025-08-26	61	63	2026-03-20 12:52:36.37106+00
1	2025-08-27	63	51	2026-03-20 12:52:36.37106+00
1	2025-08-28	54	53	2026-03-20 12:52:36.37106+00
1	2025-08-29	48	48	2026-03-20 12:52:36.37106+00
1	2025-08-30	42	46	2026-03-20 12:52:36.37106+00
1	2025-08-31	64	52	2026-03-20 12:52:36.37106+00
1	2025-09-01	43	44	2026-03-20 12:52:36.37106+00
1	2025-09-02	56	43	2026-03-20 12:52:36.37106+00
1	2025-09-03	138	329	2026-03-20 12:52:36.37106+00
1	2025-09-04	134	275	2026-03-20 12:52:36.37106+00
1	2025-09-05	47	46	2026-03-20 12:52:36.37106+00
1	2025-09-06	61	50	2026-03-20 12:52:36.37106+00
1	2025-09-07	47	44	2026-03-20 12:52:36.37106+00
1	2025-09-08	60	38	2026-03-20 12:52:36.37106+00
1	2025-09-09	58	50	2026-03-20 12:52:36.37106+00
1	2025-09-10	42	45	2026-03-20 12:52:36.37106+00
1	2025-09-11	51	48	2026-03-20 12:52:36.37106+00
1	2025-09-12	57	39	2026-03-20 12:52:36.37106+00
1	2025-09-13	50	49	2026-03-20 12:52:36.37106+00
1	2025-09-14	47	42	2026-03-20 12:52:36.37106+00
1	2025-09-15	63	50	2026-03-20 12:52:36.37106+00
1	2025-09-16	113	345	2026-03-20 12:52:36.37106+00
1	2025-09-17	56	89	2026-03-20 12:52:36.37106+00
1	2025-09-18	70	69	2026-03-20 12:52:36.37106+00
1	2025-09-19	42	58	2026-03-20 12:52:36.37106+00
1	2025-09-20	49	38	2026-03-20 12:52:36.37106+00
1	2025-09-21	70	51	2026-03-20 12:52:36.37106+00
1	2025-09-22	201	505	2026-03-20 12:52:36.37106+00
1	2025-09-23	60	76	2026-03-20 12:52:36.37106+00
1	2025-09-24	54	52	2026-03-20 12:52:36.37106+00
1	2025-09-25	45	54	2026-03-20 12:52:36.37106+00
1	2025-09-26	199	636	2026-03-20 12:52:36.37106+00
1	2025-09-27	199	636	2026-03-20 12:52:36.37106+00
1	2025-09-28	200	634	2026-03-20 12:52:36.37106+00
1	2025-09-29	142	377	2026-03-20 12:52:36.37106+00
1	2025-09-30	103	287	2026-03-20 12:52:36.37106+00
1	2025-10-01	97	209	2026-03-20 12:52:36.37106+00
1	2025-10-02	131	271	2026-03-20 12:52:36.37106+00
1	2025-10-03	102	193	2026-03-20 12:52:36.37106+00
1	2025-10-04	82	141	2026-03-20 12:52:36.37106+00
1	2025-10-05	170	488	2026-03-20 12:52:36.37106+00
1	2025-10-06	98	267	2026-03-20 12:52:36.37106+00
1	2025-10-07	75	149	2026-03-20 12:52:36.37106+00
1	2025-10-08	142	519	2026-03-20 12:52:36.37106+00
1	2025-10-09	59	137	2026-03-20 12:52:36.37106+00
1	2025-10-10	78	125	2026-03-20 12:52:36.37106+00
1	2025-10-11	264	773	2026-03-20 12:52:36.37106+00
1	2025-10-12	68	128	2026-03-20 12:52:36.37106+00
1	2025-10-13	78	102	2026-03-20 12:52:36.37106+00
1	2025-10-14	68	100	2026-03-20 12:52:36.37106+00
1	2025-10-15	663	2951	2026-03-20 12:52:36.37106+00
1	2025-10-16	1070	6284	2026-03-20 12:52:36.37106+00
1	2025-10-17	851	3353	2026-03-20 12:52:36.37106+00
1	2025-10-18	258	981	2026-03-20 12:52:36.37106+00
1	2025-10-19	118	551	2026-03-20 12:52:36.37106+00
1	2025-10-20	201	646	2026-03-20 12:52:36.37106+00
1	2025-10-21	123	291	2026-03-20 12:52:36.37106+00
1	2025-10-22	330	1929	2026-03-20 12:52:36.37106+00
1	2025-10-23	193	1654	2026-03-20 12:52:36.37106+00
1	2025-10-24	117	655	2026-03-20 12:52:36.37106+00
1	2025-10-25	178	704	2026-03-20 12:52:36.37106+00
1	2025-10-26	135	383	2026-03-20 12:52:36.37106+00
1	2025-10-27	192	836	2026-03-20 12:52:36.37106+00
1	2025-10-28	115	556	2026-03-20 12:52:36.37106+00
1	2025-10-29	155	461	2026-03-20 12:52:36.37106+00
1	2025-10-30	102	558	2026-03-20 12:52:36.37106+00
1	2025-10-31	59	346	2026-03-20 12:52:36.37106+00
1	2025-11-01	39	217	2026-03-20 12:52:36.37106+00
1	2025-11-02	65	246	2026-03-20 12:52:36.37106+00
1	2025-11-03	67	250	2026-03-20 12:52:36.37106+00
1	2025-11-04	71	233	2026-03-20 12:52:36.37106+00
1	2025-11-05	72	186	2026-03-20 12:52:36.37106+00
1	2025-11-06	81	191	2026-03-20 12:52:36.37106+00
1	2025-11-07	1003	4176	2026-03-20 12:52:36.37106+00
1	2025-11-08	4088	17725	2026-03-20 12:52:36.37106+00
1	2025-11-09	7983	27804	2026-03-20 12:52:36.37106+00
1	2025-11-10	3236	9356	2026-03-20 12:52:36.37106+00
1	2025-11-11	2438	5854	2026-03-20 12:52:36.37106+00
1	2025-11-12	933	3719	2026-03-20 12:52:36.37106+00
1	2025-11-13	388	1871	2026-03-20 12:52:36.37106+00
1	2025-11-14	249	712	2026-03-20 12:52:36.37106+00
1	2025-11-15	276	814	2026-03-20 12:52:36.37106+00
1	2025-11-16	289	794	2026-03-20 12:52:36.37106+00
1	2025-11-17	256	624	2026-03-20 12:52:36.37106+00
1	2025-11-18	219	519	2026-03-20 12:52:36.37106+00
1	2025-11-19	218	592	2026-03-20 12:52:36.37106+00
1	2025-11-20	203	588	2026-03-20 12:52:36.37106+00
1	2025-11-21	398	2712	2026-03-20 12:52:36.37106+00
1	2025-11-22	309	1679	2026-03-20 12:52:36.37106+00
1	2025-11-23	338	1049	2026-03-20 12:52:36.37106+00
1	2025-11-24	341	883	2026-03-20 12:52:36.37106+00
1	2025-11-25	603	1559	2026-03-20 12:52:36.37106+00
1	2025-11-26	347	898	2026-03-20 12:52:36.37106+00
1	2025-11-27	829	5574	2026-03-20 12:52:36.37106+00
1	2025-11-28	1077	8493	2026-03-20 12:52:36.37106+00
1	2025-11-29	350	1997	2026-03-20 12:52:36.37106+00
1	2025-11-30	519	1765	2026-03-20 12:52:36.37106+00
1	2025-12-01	414	1579	2026-03-20 12:52:36.37106+00
1	2025-12-02	442	1594	2026-03-20 12:52:36.37106+00
1	2025-12-03	464	2939	2026-03-20 12:52:36.37106+00
1	2025-12-04	461	3244	2026-03-20 12:52:36.37106+00
1	2025-12-05	321	1766	2026-03-20 12:52:36.37106+00
1	2025-12-06	276	1055	2026-03-20 12:52:36.37106+00
1	2025-12-07	502	1530	2026-03-20 12:52:36.37106+00
1	2025-12-08	404	1028	2026-03-20 12:52:36.37106+00
1	2025-12-09	490	2910	2026-03-20 12:52:36.37106+00
1	2025-12-10	447	1809	2026-03-20 12:52:36.37106+00
1	2025-12-11	443	1265	2026-03-20 12:52:36.37106+00
1	2025-12-12	461	1668	2026-03-20 12:52:36.37106+00
1	2025-12-13	374	966	2026-03-20 12:52:36.37106+00
1	2025-12-14	533	1251	2026-03-20 12:52:36.37106+00
1	2025-12-15	437	990	2026-03-20 12:52:36.37106+00
1	2025-12-16	438	1022	2026-03-20 12:52:36.37106+00
1	2025-12-17	1181	5385	2026-03-20 12:52:36.37106+00
1	2025-12-18	1632	9264	2026-03-20 12:52:36.37106+00
1	2025-12-19	776	4174	2026-03-20 12:52:36.37106+00
1	2025-12-20	570	1963	2026-03-20 12:52:36.37106+00
1	2025-12-21	452	1261	2026-03-20 12:52:36.37106+00
1	2025-12-22	412	1140	2026-03-20 12:52:36.37106+00
1	2025-12-23	1630	8771	2026-03-20 12:52:36.37106+00
1	2025-12-24	3180	12267	2026-03-20 12:52:36.37106+00
1	2025-12-25	2120	7064	2026-03-20 12:52:36.37106+00
1	2025-12-26	1427	4108	2026-03-20 12:52:36.37106+00
1	2025-12-27	1579	3613	2026-03-20 12:52:36.37106+00
1	2025-12-28	1751	3844	2026-03-20 12:52:36.37106+00
1	2025-12-29	1600	3420	2026-03-20 12:52:36.37106+00
1	2025-12-30	1246	2353	2026-03-20 12:52:36.37106+00
1	2025-12-31	21718	56920	2026-03-20 12:52:36.37106+00
1	2026-01-01	66050	85346	2026-03-20 12:52:36.37106+00
1	2026-01-02	38296	28407	2026-03-20 12:52:36.37106+00
1	2026-01-03	17914	14684	2026-03-20 12:52:36.37106+00
1	2026-01-04	9185	8564	2026-03-20 12:52:36.37106+00
1	2026-01-05	9709	6464	2026-03-20 12:52:36.37106+00
1	2026-01-06	9896	5954	2026-03-20 12:52:36.37106+00
1	2026-01-07	7111	4584	2026-03-20 12:52:36.37106+00
1	2026-01-08	5844	4307	2026-03-20 12:52:36.37106+00
1	2026-01-09	4147	2767	2026-03-20 12:52:36.37106+00
1	2026-01-10	3811	2258	2026-03-20 12:52:36.37106+00
1	2026-01-11	4634	2386	2026-03-20 12:52:36.37106+00
1	2026-01-12	4793	2368	2026-03-20 12:52:36.37106+00
1	2026-01-13	4149	2118	2026-03-20 12:52:36.37106+00
1	2026-01-14	4768	4627	2026-03-20 12:52:36.37106+00
1	2026-01-15	5018	5721	2026-03-20 12:52:36.37106+00
1	2026-01-16	4533	2706	2026-03-20 12:52:36.37106+00
1	2026-01-17	4139	2965	2026-03-20 12:52:36.37106+00
1	2026-01-18	5162	2734	2026-03-20 12:52:36.37106+00
1	2026-01-19	4236	2143	2026-03-20 12:52:36.37106+00
1	2026-01-20	3347	1652	2026-03-20 12:52:36.37106+00
1	2026-01-21	2711	1363	2026-03-20 12:52:36.37106+00
1	2026-01-22	3706	1687	2026-03-20 12:52:36.37106+00
1	2026-01-23	2447	1193	2026-03-20 12:52:36.37106+00
1	2026-01-24	2437	1189	2026-03-20 12:52:36.37106+00
1	2026-01-25	3353	1643	2026-03-20 12:52:36.37106+00
1	2026-01-26	2214	1103	2026-03-20 12:52:36.37106+00
1	2026-01-27	1920	1028	2026-03-20 12:52:36.37106+00
1	2026-01-28	2447	1257	2026-03-20 12:52:36.37106+00
1	2026-01-29	23	3870	2026-03-20 12:52:36.37106+00
1	2026-01-30	2502	2834	2026-03-20 12:52:36.37106+00
1	2026-01-31	2672	1787	2026-03-20 12:52:36.37106+00
1	2026-02-01	3439	1832	2026-03-20 12:52:36.37106+00
1	2026-02-02	3685	1476	2026-03-20 12:52:36.37106+00
1	2026-02-03	4380	2010	2026-03-20 12:52:36.37106+00
1	2026-02-04	4730	2273	2026-03-20 12:52:36.37106+00
1	2026-02-05	4538	2205	2026-03-20 12:52:36.37106+00
1	2026-02-06	3040	2664	2026-03-20 12:52:36.37106+00
1	2026-02-07	4163	1771	2026-03-20 12:52:36.37106+00
1	2026-02-08	4177	1562	2026-03-20 12:52:36.37106+00
1	2026-02-09	3442	1400	2026-03-20 12:52:36.37106+00
1	2026-02-10	3270	1003	2026-03-20 12:52:36.37106+00
1	2026-02-11	3054	806	2026-03-20 12:52:36.37106+00
1	2026-02-12	2822	932	2026-03-20 12:52:36.37106+00
1	2026-02-13	2335	777	2026-03-20 12:52:36.37106+00
1	2026-02-14	2382	974	2026-03-20 12:52:36.37106+00
1	2026-02-15	3699	1290	2026-03-20 12:52:36.37106+00
1	2026-02-16	3524	1188	2026-03-20 12:52:36.37106+00
1	2026-02-17	3104	1273	2026-03-20 12:52:36.37106+00
1	2026-02-18	2599	1019	2026-03-20 12:52:36.37106+00
1	2026-02-19	3068	1093	2026-03-20 12:52:36.37106+00
1	2026-02-20	3062	1742	2026-03-20 12:52:36.37106+00
1	2026-02-21	3327	9187	2026-03-20 12:52:36.37106+00
1	2026-02-22	3499	7852	2026-03-20 12:52:36.37106+00
1	2026-02-23	2898	3402	2026-03-20 12:52:36.37106+00
1	2026-02-24	1988	1551	2026-03-20 12:52:36.37106+00
1	2026-02-25	2304	1172	2026-03-20 12:52:36.37106+00
1	2026-02-26	2187	1005	2026-03-20 12:52:36.37106+00
1	2026-02-27	2002	707	2026-03-20 12:52:36.37106+00
1	2026-02-28	1939	922	2026-03-20 12:52:36.37106+00
1	2026-03-01	2070	736	2026-03-20 12:52:36.37106+00
1	2026-03-02	1459	442	2026-03-20 12:52:36.37106+00
1	2026-03-03	1397	490	2026-03-20 12:52:36.37106+00
1	2026-03-04	1304	484	2026-03-20 12:52:36.37106+00
1	2026-03-05	1205	374	2026-03-20 12:52:36.37106+00
1	2026-03-06	1366	432	2026-03-20 12:52:36.37106+00
1	2026-03-07	1449	421	2026-03-20 12:52:36.37106+00
1	2026-03-08	1651	498	2026-03-20 12:52:36.37106+00
1	2026-03-09	1709	4085	2026-03-20 12:52:36.37106+00
1	2026-03-10	1648	4264	2026-03-20 12:52:36.37106+00
1	2026-03-11	1588	1410	2026-03-20 12:52:36.37106+00
1	2026-03-12	1822	1056	2026-03-20 12:52:36.37106+00
1	2026-03-13	1521	645	2026-03-20 12:52:36.37106+00
1	2026-03-14	1496	712	2026-03-20 12:52:36.37106+00
1	2026-03-15	1468	615	2026-03-20 12:52:36.37106+00
1	2026-03-16	1522	6795	2026-03-20 12:52:36.37106+00
1	2026-03-17	1599	15577	2026-03-20 12:52:36.37106+00
1	2026-03-18	0	0	2026-03-20 12:52:36.37106+00
5	2026-04-03	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-04	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-05	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-06	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-07	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-08	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-09	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-10	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-11	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-12	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-13	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-14	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-15	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-16	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-17	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-18	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-19	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-20	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-21	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-22	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-23	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-24	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-25	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-26	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-27	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-28	0	0	2026-04-04 11:24:02.693201+00
5	2026-04-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-04-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-09	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-10	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-11	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-12	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-13	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-14	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-15	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-16	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-17	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-18	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-19	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-20	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-21	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-22	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-23	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-24	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-25	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-26	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-27	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-28	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-05-31	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-09	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-10	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-11	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-12	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-13	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-14	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-15	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-16	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-17	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-18	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-19	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-20	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-21	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-22	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-23	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-24	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-25	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-26	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-27	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-28	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-06-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-09	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-10	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-11	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-12	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-13	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-14	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-15	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-16	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-17	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-18	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-19	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-20	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-21	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-22	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-23	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-24	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-25	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-26	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-27	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-28	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-07-31	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-09	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-10	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-11	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-12	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-13	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-14	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-15	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-16	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-17	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-18	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-19	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-20	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-21	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-22	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-23	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-24	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-25	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-26	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-27	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-28	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-08-31	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-09	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-10	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-11	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-12	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-13	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-14	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-15	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-16	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-17	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-18	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-19	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-20	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-21	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-22	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-23	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-24	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-25	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-26	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-27	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-28	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-29	0	0	2026-04-04 11:24:02.693201+00
5	2025-09-30	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-01	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-02	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-03	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-04	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-05	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-06	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-07	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-08	0	0	2026-04-04 11:24:02.693201+00
5	2025-10-09	1183	1	2026-04-04 11:24:02.693201+00
5	2025-10-10	7735	14	2026-04-04 11:24:02.693201+00
5	2025-10-11	1541	33	2026-04-04 11:24:02.693201+00
5	2025-10-12	1304	23	2026-04-04 11:24:02.693201+00
5	2025-10-13	19405	6660	2026-04-04 11:24:02.693201+00
5	2025-10-14	10720	2242	2026-04-04 11:24:02.693201+00
5	2025-10-15	8463	1509	2026-04-04 11:24:02.693201+00
5	2025-10-16	1924	2845	2026-04-04 11:24:02.693201+00
5	2025-10-17	1061	749	2026-04-04 11:24:02.693201+00
5	2025-10-18	828	566	2026-04-04 11:24:02.693201+00
5	2025-10-19	647	379	2026-04-04 11:24:02.693201+00
5	2025-10-20	409	293	2026-04-04 11:24:02.693201+00
5	2025-10-21	274	183	2026-04-04 11:24:02.693201+00
5	2025-10-22	267	133	2026-04-04 11:24:02.693201+00
5	2025-10-23	322	127	2026-04-04 11:24:02.693201+00
5	2025-10-24	72	92	2026-04-04 11:24:02.693201+00
5	2025-10-25	73	87	2026-04-04 11:24:02.693201+00
5	2025-10-26	77	107	2026-04-04 11:24:02.693201+00
5	2025-10-27	485	134	2026-04-04 11:24:02.693201+00
5	2025-10-28	557	147	2026-04-04 11:24:02.693201+00
5	2025-10-29	503	176	2026-04-04 11:24:02.693201+00
5	2025-10-30	531	186	2026-04-04 11:24:02.693201+00
5	2025-10-31	314	210	2026-04-04 11:24:02.693201+00
5	2025-11-01	1906	6229	2026-04-04 11:24:02.693201+00
5	2025-11-02	529	2871	2026-04-04 11:24:02.693201+00
5	2025-11-03	302	3459	2026-04-04 11:24:02.693201+00
5	2025-11-04	185	1120	2026-04-04 11:24:02.693201+00
5	2025-11-05	115	411	2026-04-04 11:24:02.693201+00
5	2025-11-06	101	243	2026-04-04 11:24:02.693201+00
5	2025-11-07	82	257	2026-04-04 11:24:02.693201+00
5	2025-11-08	658	2390	2026-04-04 11:24:02.693201+00
5	2025-11-09	405	3227	2026-04-04 11:24:02.693201+00
5	2025-11-10	974	3892	2026-04-04 11:24:02.693201+00
5	2025-11-11	255	1741	2026-04-04 11:24:02.693201+00
5	2025-11-12	518	2029	2026-04-04 11:24:02.693201+00
5	2025-11-13	435	1316	2026-04-04 11:24:02.693201+00
5	2025-11-14	328	1165	2026-04-04 11:24:02.693201+00
5	2025-11-15	3770	13521	2026-04-04 11:24:02.693201+00
5	2025-11-16	2722	4418	2026-04-04 11:24:02.693201+00
5	2025-11-17	1078	1658	2026-04-04 11:24:02.693201+00
5	2025-11-18	356	744	2026-04-04 11:24:02.693201+00
5	2025-11-19	290	555	2026-04-04 11:24:02.693201+00
5	2025-11-20	217	462	2026-04-04 11:24:02.693201+00
5	2025-11-21	173	431	2026-04-04 11:24:02.693201+00
5	2025-11-22	168	374	2026-04-04 11:24:02.693201+00
5	2025-11-23	161	360	2026-04-04 11:24:02.693201+00
5	2025-11-24	202	475	2026-04-04 11:24:02.693201+00
5	2025-11-25	233	439	2026-04-04 11:24:02.693201+00
5	2025-11-26	293	951	2026-04-04 11:24:02.693201+00
5	2025-11-27	316	4666	2026-04-04 11:24:02.693201+00
5	2025-11-28	137	692	2026-04-04 11:24:02.693201+00
5	2025-11-29	184	587	2026-04-04 11:24:02.693201+00
5	2025-11-30	182	473	2026-04-04 11:24:02.693201+00
5	2025-12-01	215	429	2026-04-04 11:24:02.693201+00
5	2025-12-02	181	487	2026-04-04 11:24:02.693201+00
5	2025-12-03	248	403	2026-04-04 11:24:02.693201+00
5	2025-12-04	267	391	2026-04-04 11:24:02.693201+00
5	2025-12-05	230	354	2026-04-04 11:24:02.693201+00
5	2025-12-06	177	294	2026-04-04 11:24:02.693201+00
5	2025-12-07	200	320	2026-04-04 11:24:02.693201+00
5	2025-12-08	177	287	2026-04-04 11:24:02.693201+00
5	2025-12-09	781	3009	2026-04-04 11:24:02.693201+00
5	2025-12-10	178	739	2026-04-04 11:24:02.693201+00
5	2025-12-11	182	413	2026-04-04 11:24:02.693201+00
5	2025-12-12	151	331	2026-04-04 11:24:02.693201+00
5	2025-12-13	175	326	2026-04-04 11:24:02.693201+00
5	2025-12-14	195	316	2026-04-04 11:24:02.693201+00
5	2025-12-15	206	315	2026-04-04 11:24:02.693201+00
5	2025-12-16	172	316	2026-04-04 11:24:02.693201+00
5	2025-12-17	1608	7299	2026-04-04 11:24:02.693201+00
5	2025-12-18	1753	7149	2026-04-04 11:24:02.693201+00
5	2025-12-19	1618	3725	2026-04-04 11:24:02.693201+00
5	2025-12-20	830	1705	2026-04-04 11:24:02.693201+00
5	2025-12-21	357	953	2026-04-04 11:24:02.693201+00
5	2025-12-22	389	909	2026-04-04 11:24:02.693201+00
5	2025-12-23	352	781	2026-04-04 11:24:02.693201+00
5	2025-12-24	435	738	2026-04-04 11:24:02.693201+00
5	2025-12-25	380	666	2026-04-04 11:24:02.693201+00
5	2025-12-26	261	548	2026-04-04 11:24:02.693201+00
5	2025-12-27	193	422	2026-04-04 11:24:02.693201+00
5	2025-12-28	204	390	2026-04-04 11:24:02.693201+00
5	2025-12-29	174	406	2026-04-04 11:24:02.693201+00
5	2025-12-30	248	477	2026-04-04 11:24:02.693201+00
5	2025-12-31	111	238	2026-04-04 11:24:02.693201+00
5	2026-01-01	252	377	2026-04-04 11:24:02.693201+00
5	2026-01-02	247	499	2026-04-04 11:24:02.693201+00
5	2026-01-03	275	603	2026-04-04 11:24:02.693201+00
5	2026-01-04	454	833	2026-04-04 11:24:02.693201+00
5	2026-01-05	339	692	2026-04-04 11:24:02.693201+00
5	2026-01-06	377	657	2026-04-04 11:24:02.693201+00
5	2026-01-07	811	1207	2026-04-04 11:24:02.693201+00
5	2026-01-08	501	748	2026-04-04 11:24:02.693201+00
5	2026-01-09	231	458	2026-04-04 11:24:02.693201+00
5	2026-01-10	253	376	2026-04-04 11:24:02.693201+00
5	2026-01-11	382	534	2026-04-04 11:24:02.693201+00
5	2026-01-12	329	559	2026-04-04 11:24:02.693201+00
5	2026-01-13	828	1119	2026-04-04 11:24:02.693201+00
5	2026-01-14	675	1917	2026-04-04 11:24:02.693201+00
5	2026-01-15	301	650	2026-04-04 11:24:02.693201+00
5	2026-01-16	235	515	2026-04-04 11:24:02.693201+00
5	2026-01-17	218	397	2026-04-04 11:24:02.693201+00
5	2026-01-18	415	646	2026-04-04 11:24:02.693201+00
5	2026-01-19	233	327	2026-04-04 11:24:02.693201+00
5	2026-01-20	128	166	2026-04-04 11:24:02.693201+00
5	2026-01-21	162	258	2026-04-04 11:24:02.693201+00
5	2026-01-22	142	233	2026-04-04 11:24:02.693201+00
5	2026-01-23	158	206	2026-04-04 11:24:02.693201+00
5	2026-01-24	178	259	2026-04-04 11:24:02.693201+00
5	2026-01-25	304	456	2026-04-04 11:24:02.693201+00
5	2026-01-26	144	267	2026-04-04 11:24:02.693201+00
5	2026-01-27	107	193	2026-04-04 11:24:02.693201+00
5	2026-01-28	156	620	2026-04-04 11:24:02.693201+00
5	2026-01-29	10	1332	2026-04-04 11:24:02.693201+00
5	2026-01-30	87	208	2026-04-04 11:24:02.693201+00
5	2026-01-31	78	218	2026-04-04 11:24:02.693201+00
5	2026-02-01	79	183	2026-04-04 11:24:02.693201+00
5	2026-02-02	248	516	2026-04-04 11:24:02.693201+00
5	2026-02-03	117	368	2026-04-04 11:24:02.693201+00
5	2026-02-04	98	178	2026-04-04 11:24:02.693201+00
5	2026-02-05	81	166	2026-04-04 11:24:02.693201+00
5	2026-02-06	57	107	2026-04-04 11:24:02.693201+00
5	2026-02-07	76	136	2026-04-04 11:24:02.693201+00
5	2026-02-08	86	127	2026-04-04 11:24:02.693201+00
5	2026-02-09	118	172	2026-04-04 11:24:02.693201+00
5	2026-02-10	95	129	2026-04-04 11:24:02.693201+00
5	2026-02-11	259	784	2026-04-04 11:24:02.693201+00
5	2026-02-12	98	258	2026-04-04 11:24:02.693201+00
5	2026-02-13	81	204	2026-04-04 11:24:02.693201+00
5	2026-02-14	101	186	2026-04-04 11:24:02.693201+00
5	2026-02-15	148	230	2026-04-04 11:24:02.693201+00
5	2026-02-16	84	231	2026-04-04 11:24:02.693201+00
5	2026-02-17	764	2448	2026-04-04 11:24:02.693201+00
5	2026-02-18	443	2477	2026-04-04 11:24:02.693201+00
5	2026-02-19	385	2363	2026-04-04 11:24:02.693201+00
5	2026-02-20	122	719	2026-04-04 11:24:02.693201+00
5	2026-02-21	143	548	2026-04-04 11:24:02.693201+00
5	2026-02-22	121	519	2026-04-04 11:24:02.693201+00
5	2026-02-23	125	401	2026-04-04 11:24:02.693201+00
5	2026-02-24	126	501	2026-04-04 11:24:02.693201+00
5	2026-02-25	416	1414	2026-04-04 11:24:02.693201+00
5	2026-02-26	92	497	2026-04-04 11:24:02.693201+00
5	2026-02-27	83	361	2026-04-04 11:24:02.693201+00
5	2026-02-28	94	320	2026-04-04 11:24:02.693201+00
5	2026-03-01	103	402	2026-04-04 11:24:02.693201+00
5	2026-03-02	99	365	2026-04-04 11:24:02.693201+00
5	2026-03-03	99	499	2026-04-04 11:24:02.693201+00
5	2026-03-04	240	1185	2026-04-04 11:24:02.693201+00
5	2026-03-05	72	599	2026-04-04 11:24:02.693201+00
5	2026-03-06	107	575	2026-04-04 11:24:02.693201+00
5	2026-03-07	103	389	2026-04-04 11:24:02.693201+00
5	2026-03-08	76	297	2026-04-04 11:24:02.693201+00
5	2026-03-09	82	329	2026-04-04 11:24:02.693201+00
5	2026-03-10	758	1974	2026-04-04 11:24:02.693201+00
5	2026-03-11	2908	6548	2026-04-04 11:24:02.693201+00
5	2026-03-12	632	1528	2026-04-04 11:24:02.693201+00
5	2026-03-13	1798	3028	2026-04-04 11:24:02.693201+00
5	2026-03-14	330	965	2026-04-04 11:24:02.693201+00
5	2026-03-15	226	641	2026-04-04 11:24:02.693201+00
5	2026-03-16	151	487	2026-04-04 11:24:02.693201+00
5	2026-03-17	130	457	2026-04-04 11:24:02.693201+00
5	2026-03-18	140	444	2026-04-04 11:24:02.693201+00
5	2026-03-19	134	527	2026-04-04 11:24:02.693201+00
5	2026-03-20	190	466	2026-04-04 11:24:02.693201+00
5	2026-03-21	124	327	2026-04-04 11:24:02.693201+00
5	2026-03-22	92	315	2026-04-04 11:24:02.693201+00
5	2026-03-23	90	236	2026-04-04 11:24:02.693201+00
5	2026-03-24	86	283	2026-04-04 11:24:02.693201+00
5	2026-03-25	77	205	2026-04-04 11:24:02.693201+00
5	2026-03-26	85	193	2026-04-04 11:24:02.693201+00
5	2026-03-27	123	237	2026-04-04 11:24:02.693201+00
5	2026-03-28	240	448	2026-04-04 11:24:02.693201+00
5	2026-03-29	151	333	2026-04-04 11:24:02.693201+00
5	2026-03-30	241	277	2026-04-04 11:24:02.693201+00
5	2026-03-31	304	173	2026-04-04 11:24:02.693201+00
5	2026-04-01	294	180	2026-04-04 11:24:02.693201+00
5	2026-04-02	0	0	2026-04-04 11:24:02.693201+00
\.


--
-- Data for Name: time_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.time_entries (id, team_member_id, client_id, content_item_id, task_type, hours, date, notes, created_at, content_type, internal_project) FROM stdin;
7	1	4	\N	strategy	0.70	2026-04-06	Transposition Calendrier  	2026-04-06 06:50:46.626135+00		
8	1	3	\N	editing	1.50	2026-04-06	Aesthetic 	2026-04-06 10:57:34.60219+00		
9	1	6	\N	strategy	1.50	2026-04-06		2026-04-07 07:17:23.849928+00		
10	1	4	\N	meeting	1.00	2026-04-07		2026-04-07 07:18:24.945074+00		
12	1	6	\N	strategy	1.50	2026-04-07		2026-04-08 05:33:46.259002+00		
13	1	6	\N	strategy	2.00	2026-04-08		2026-04-11 08:07:02.332276+00		
14	1	3	4	editing	1.00	2026-04-08		2026-04-11 08:08:00.941831+00	aesthetic	
15	1	6	12	shooting	1.00	2026-04-09		2026-04-11 08:09:01.865728+00	authority_voice_over	
16	1	6	11	shooting	0.50	2026-04-09		2026-04-11 08:09:22.006746+00	aesthetic	
18	1	6	13	shooting	0.40	2026-04-09		2026-04-11 08:11:47.440045+00	carousel	
19	1	6	13	strategy	0.20	2026-04-09		2026-04-11 08:12:21.107837+00	carousel	
20	1	6	12	editing	0.20	2026-04-09		2026-04-11 08:12:47.472591+00	authority_voice_over	
22	1	5	\N	editing	0.40	2026-04-10	Montage et publi Vidéo Hidden terrace 	2026-04-11 08:17:30.11316+00	aesthetic	
23	1	5	\N	shooting	1.00	2026-04-10		2026-04-11 08:18:27.688643+00		
24	1	5	\N	strategy	0.40	2026-04-10		2026-04-11 08:18:42.286024+00		
25	1	1	\N	strategy	1.00	2026-04-10		2026-04-11 08:19:03.967821+00		
26	1	1	\N	shooting	0.50	2026-04-10		2026-04-11 08:19:16.532754+00		
27	1	7	\N	strategy	1.00	2026-04-09		2026-04-11 08:19:59.735105+00		
28	1	5	22	editing	0.50	2026-04-11		2026-04-11 12:34:49.234004+00	aesthetic	
29	1	6	\N	shooting	0.50	2026-04-11		2026-04-12 13:35:35.519388+00	aesthetic	
30	1	4	\N	shooting	2.00	2026-04-12		2026-04-12 13:36:02.738787+00	aesthetic	
31	1	6	12	editing	0.50	2026-04-12		2026-04-12 13:44:13.69726+00	authority_live	
32	1	6	12	editing	2.33	2026-04-13		2026-04-13 07:12:35.284115+00	authority_live	
33	1	6	12	editing	0.33	2026-04-13		2026-04-13 07:39:11.82069+00	authority_live	
34	1	4	7	editing	1.00	2026-04-13		2026-04-13 11:38:24.701216+00	aesthetic	
35	1	4	7	strategy	1.00	2026-04-13		2026-04-13 14:04:42.85622+00	aesthetic	
37	1	4	6	editing	1.00	2026-04-13		2026-04-13 18:40:00.313983+00	authority_voice_over	
38	1	4	6	editing	2.00	2026-04-13		2026-04-13 18:40:21.202731+00	authority_voice_over	
39	1	3	5	editing	0.50	2026-04-13		2026-04-14 04:33:02.758007+00	carousel	
40	1	3	5	publishing	0.50	2026-04-14		2026-04-14 09:48:56.966641+00	carousel	
41	1	5	21	strategy	0.40	2026-04-14		2026-04-14 09:49:28.701644+00	authority_voice_over	
42	1	1	32	editing	0.50	2026-04-14		2026-04-14 10:37:45.940919+00	aesthetic	
43	1	1	25	editing	2.00	2026-04-14		2026-04-15 12:09:13.860688+00	authority_voice_over	
44	1	3	\N	meeting	1.00	2026-04-15		2026-04-15 12:09:46.41265+00		
45	1	6	11	editing	1.00	2026-04-15		2026-04-15 12:10:29.128107+00	aesthetic	
47	1	6	19	shooting	0.80	2026-04-16		2026-04-16 08:23:21.187511+00	aesthetic	
48	1	6	20	shooting	0.50	2026-04-16		2026-04-16 08:23:50.4113+00	aesthetic	
49	1	6	14	shooting	1.20	2026-04-16		2026-04-17 07:22:20.740731+00	authority_live	
50	1	6	19	shooting	1.00	2026-04-16		2026-04-17 07:22:51.208277+00	aesthetic	
51	1	1	35	script	0.60	2026-04-17		2026-04-17 07:35:30.517447+00	authority_voice_over	
52	1	3	36	editing	0.60	2026-04-17		2026-04-17 08:14:00.446088+00	authority_voice_over	
54	1	1	35	shooting	0.20	2026-04-17		2026-04-22 06:29:07.752296+00	authority_voice_over	
55	1	3	37	editing	0.60	2026-04-17		2026-04-22 06:32:41.30513+00	aesthetic	
56	1	5	39	shooting	0.60	2026-04-18		2026-04-22 06:56:46.844655+00	authority_voice_over	
57	1	5	39	editing	0.60	2026-04-18		2026-04-22 06:57:36.590134+00	authority_voice_over	
58	1	5	38	shooting	0.50	2026-04-18		2026-04-22 06:57:57.469543+00	authority_voice_over	
60	1	5	23	script	0.60	2026-04-18		2026-04-22 06:59:18.939872+00	authority_voice_over	
61	1	5	23	script	0.60	2026-04-18		2026-04-22 06:59:19.685474+00	authority_voice_over	
63	1	1	28	shooting	0.80	2026-04-18		2026-04-22 07:00:55.018712+00	aesthetic	
64	1	1	35	editing	0.30	2026-04-19		2026-04-22 07:07:11.655909+00	authority_voice_over	
65	1	1	27	editing	0.40	2026-04-17		2026-04-22 07:07:35.820803+00	authority_voice_over	
66	1	5	23	shooting	1.20	2026-04-17		2026-04-22 07:08:33.395424+00	authority_live	
67	1	6	11	editing	1.00	2026-04-21		2026-04-22 07:12:16.809105+00	aesthetic	
68	1	6	11	publishing	0.30	2026-04-21		2026-04-22 07:12:50.569602+00	aesthetic	
69	1	6	\N	strategy	0.70	2026-04-21		2026-04-22 07:13:16.170585+00		
73	1	3	\N	strategy	0.30	2026-04-22		2026-04-22 14:50:29.119471+00		
74	1	\N	\N	strategy	2.00	2026-04-22		2026-04-22 14:50:46.588263+00		mazine
75	1	\N	\N	strategy	3.00	2026-04-19		2026-04-22 14:51:12.541254+00		mazine
\.


--
-- Name: client_contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.client_contracts_id_seq', 9, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clients_id_seq', 8, true);


--
-- Name: content_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_items_id_seq', 43, true);


--
-- Name: content_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_tasks_id_seq', 301, true);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoice_items_id_seq', 1, false);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoices_id_seq', 1, false);


--
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leads_id_seq', 3, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 51, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 12, true);


--
-- Name: quote_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quote_items_id_seq', 72, true);


--
-- Name: quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quotes_id_seq', 1, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reports_id_seq', 9, true);


--
-- Name: team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.team_members_id_seq', 2, true);


--
-- Name: time_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.time_entries_id_seq', 75, true);


--
-- Name: client_contracts client_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_contracts
    ADD CONSTRAINT client_contracts_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: content_items content_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_pkey PRIMARY KEY (id);


--
-- Name: content_tasks content_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tasks
    ADD CONSTRAINT content_tasks_pkey PRIMARY KEY (id);


--
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: quote_items quote_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_items
    ADD CONSTRAINT quote_items_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_quote_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_quote_number_key UNIQUE (quote_number);


--
-- Name: reports reports_client_id_month_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_client_id_month_key_key UNIQUE (client_id, month_key);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: task_defaults task_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_defaults
    ADD CONSTRAINT task_defaults_pkey PRIMARY KEY (stage);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: tiktok_activity tiktok_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_activity
    ADD CONSTRAINT tiktok_activity_pkey PRIMARY KEY (client_id, date, hour);


--
-- Name: tiktok_content tiktok_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_content
    ADD CONSTRAINT tiktok_content_pkey PRIMARY KEY (client_id, title);


--
-- Name: tiktok_followers tiktok_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_followers
    ADD CONSTRAINT tiktok_followers_pkey PRIMARY KEY (client_id, date);


--
-- Name: tiktok_gender tiktok_gender_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_gender
    ADD CONSTRAINT tiktok_gender_pkey PRIMARY KEY (client_id, gender);


--
-- Name: tiktok_overview tiktok_overview_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_overview
    ADD CONSTRAINT tiktok_overview_pkey PRIMARY KEY (client_id, date);


--
-- Name: tiktok_territories tiktok_territories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_territories
    ADD CONSTRAINT tiktok_territories_pkey PRIMARY KEY (client_id, territory);


--
-- Name: tiktok_viewers tiktok_viewers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_viewers
    ADD CONSTRAINT tiktok_viewers_pkey PRIMARY KEY (client_id, date);


--
-- Name: time_entries time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);


--
-- Name: client_contracts client_contracts_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_contracts
    ADD CONSTRAINT client_contracts_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: content_items content_items_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.team_members(id);


--
-- Name: content_items content_items_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: content_tasks content_tasks_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tasks
    ADD CONSTRAINT content_tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.team_members(id);


--
-- Name: content_tasks content_tasks_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tasks
    ADD CONSTRAINT content_tasks_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: content_tasks content_tasks_content_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_tasks
    ADD CONSTRAINT content_tasks_content_item_id_fkey FOREIGN KEY (content_item_id) REFERENCES public.content_items(id) ON DELETE CASCADE;


--
-- Name: invoice_items invoice_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: invoices invoices_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: invoices invoices_quote_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_quote_id_fkey FOREIGN KEY (quote_id) REFERENCES public.quotes(id) ON DELETE SET NULL;


--
-- Name: leads leads_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.team_members(id);


--
-- Name: notifications notifications_target_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_target_member_id_fkey FOREIGN KEY (target_member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- Name: payments payments_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: payments payments_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: quote_items quote_items_quote_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quote_items
    ADD CONSTRAINT quote_items_quote_id_fkey FOREIGN KEY (quote_id) REFERENCES public.quotes(id) ON DELETE CASCADE;


--
-- Name: quotes quotes_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE SET NULL;


--
-- Name: quotes quotes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.team_members(id);


--
-- Name: quotes quotes_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.leads(id) ON DELETE SET NULL;


--
-- Name: reports reports_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_activity tiktok_activity_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_activity
    ADD CONSTRAINT tiktok_activity_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_content tiktok_content_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_content
    ADD CONSTRAINT tiktok_content_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_followers tiktok_followers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_followers
    ADD CONSTRAINT tiktok_followers_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_gender tiktok_gender_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_gender
    ADD CONSTRAINT tiktok_gender_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_overview tiktok_overview_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_overview
    ADD CONSTRAINT tiktok_overview_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_territories tiktok_territories_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_territories
    ADD CONSTRAINT tiktok_territories_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: tiktok_viewers tiktok_viewers_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tiktok_viewers
    ADD CONSTRAINT tiktok_viewers_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: time_entries time_entries_content_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_content_item_id_fkey FOREIGN KEY (content_item_id) REFERENCES public.content_items(id) ON DELETE SET NULL;


--
-- Name: time_entries time_entries_team_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_team_member_id_fkey FOREIGN KEY (team_member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Epe08ZFwJnEwmBhKKZrKXdnbwqWsUIhJ0kY56uCPJtqZqyI1NODcyF3Y3WS4Hjx

