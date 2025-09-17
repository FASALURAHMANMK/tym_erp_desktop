--
-- PostgreSQL database dump
--

\restrict RiZUQfjwBXfF3w2Bdw3X5ZqvNsJvxuuz5lcEb0YXkvP9PKcQLjE0JuamI7rh9LG

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6

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

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


--
-- Name: calculate_discount_amount(uuid, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_discount_amount(discount_id uuid, base_amount numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    discount RECORD;
    discount_amount DECIMAL;
BEGIN
    SELECT * INTO discount FROM discount_rules WHERE id = discount_id;
    
    IF NOT FOUND OR NOT is_discount_valid(discount_id) THEN
        RETURN 0;
    END IF;
    
    -- Check minimum purchase amount
    IF discount.min_purchase_amount IS NOT NULL AND 
       base_amount < discount.min_purchase_amount THEN
        RETURN 0;
    END IF;
    
    -- Calculate discount based on type
    IF discount.discount_type = 'percentage' THEN
        discount_amount := base_amount * (discount.discount_value / 100);
        
        -- Apply maximum discount cap if set
        IF discount.max_discount_amount IS NOT NULL AND 
           discount_amount > discount.max_discount_amount THEN
            discount_amount := discount.max_discount_amount;
        END IF;
    ELSE -- fixed amount discount
        discount_amount := discount.discount_value;
    END IF;
    
    -- Ensure discount doesn't exceed base amount
    IF discount_amount > base_amount THEN
        discount_amount := base_amount;
    END IF;
    
    RETURN discount_amount;
END;
$$;


--
-- Name: FUNCTION calculate_discount_amount(discount_id uuid, base_amount numeric); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.calculate_discount_amount(discount_id uuid, base_amount numeric) IS 'Calculates the discount amount for a given base amount according to discount rules';


--
-- Name: calculate_product_tax(uuid, numeric, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_product_tax(p_product_id uuid, p_base_amount numeric, p_location_id uuid DEFAULT NULL::uuid) RETURNS TABLE(tax_group_id uuid, tax_group_name character varying, tax_rate_id uuid, tax_rate_name character varying, rate numeric, tax_amount numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH applicable_taxes AS (
        -- Get product-specific taxes
        SELECT 
            tg.id as tax_group_id,
            tg.name as tax_group_name,
            tr.id as tax_rate_id,
            tr.name as tax_rate_name,
            COALESCE(lto.override_rate, tr.rate) as effective_rate,
            tr.calculation_method,
            tr.apply_on
        FROM product_taxes pt
        JOIN tax_groups tg ON pt.tax_group_id = tg.id
        JOIN tax_rates tr ON tr.tax_group_id = tg.id
        LEFT JOIN location_tax_overrides lto ON 
            lto.tax_rate_id = tr.id 
            AND lto.location_id = p_location_id
            AND lto.is_active = true
        WHERE pt.product_id = p_product_id
        AND pt.is_active = true
        AND tg.is_active = true
        AND tr.is_active = true
        
        UNION
        
        -- Get category-based taxes
        SELECT 
            tg.id as tax_group_id,
            tg.name as tax_group_name,
            tr.id as tax_rate_id,
            tr.name as tax_rate_name,
            COALESCE(lto.override_rate, tr.rate) as effective_rate,
            tr.calculation_method,
            tr.apply_on
        FROM products p
        JOIN category_taxes ct ON ct.category_id = p.category_id
        JOIN tax_groups tg ON ct.tax_group_id = tg.id
        JOIN tax_rates tr ON tr.tax_group_id = tg.id
        LEFT JOIN location_tax_overrides lto ON 
            lto.tax_rate_id = tr.id 
            AND lto.location_id = p_location_id
            AND lto.is_active = true
        WHERE p.id = p_product_id
        AND ct.is_active = true
        AND tg.is_active = true
        AND tr.is_active = true
        AND NOT EXISTS (
            -- Exclude if product has specific tax configuration
            SELECT 1 FROM product_taxes pt2 
            WHERE pt2.product_id = p_product_id 
            AND pt2.is_active = true
        )
    )
    SELECT 
        tax_group_id,
        tax_group_name,
        tax_rate_id,
        tax_rate_name,
        effective_rate,
        CASE 
            WHEN calculation_method = 'inclusive' THEN 
                p_base_amount - (p_base_amount / (1 + effective_rate / 100))
            ELSE 
                p_base_amount * (effective_rate / 100)
        END as tax_amount
    FROM applicable_taxes;
END;
$$;


--
-- Name: FUNCTION calculate_product_tax(p_product_id uuid, p_base_amount numeric, p_location_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.calculate_product_tax(p_product_id uuid, p_base_amount numeric, p_location_id uuid) IS 'Calculates applicable taxes for a product based on product and category tax assignments';


--
-- Name: calculate_tiered_charge(uuid, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.calculate_tiered_charge(p_charge_id uuid, p_base_amount numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_charge_amount DECIMAL := 0;
    v_tier RECORD;
BEGIN
    -- Find the applicable tier
    SELECT * INTO v_tier
    FROM charge_tiers
    WHERE charge_id = p_charge_id
        AND p_base_amount >= min_value
        AND (max_value IS NULL OR p_base_amount <= max_value)
    ORDER BY min_value DESC
    LIMIT 1;
    
    IF FOUND THEN
        v_charge_amount := v_tier.charge_value;
    END IF;
    
    RETURN v_charge_amount;
END;
$$;


--
-- Name: can_apply_discount(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_apply_discount(p_discount_id uuid, p_user_id uuid DEFAULT auth.uid()) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM discount_rules dr
        JOIN businesses b ON dr.business_id = b.id
        WHERE dr.id = p_discount_id
        AND b.owner_id = p_user_id
        AND dr.is_active = true
    );
END;
$$;


--
-- Name: FUNCTION can_apply_discount(p_discount_id uuid, p_user_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.can_apply_discount(p_discount_id uuid, p_user_id uuid) IS 'Checks if a user has permission to apply a specific discount';


--
-- Name: can_user_create_employee(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_user_create_employee(p_business_id uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_is_owner BOOLEAN;
BEGIN
  -- Check if user owns the business
  SELECT EXISTS(
    SELECT 1 FROM businesses 
    WHERE id = p_business_id AND owner_id = auth.uid()
  ) INTO v_is_owner;
  
  RETURN v_is_owner;
END;
$$;


--
-- Name: check_business_subscription_access(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_business_subscription_access(business_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  subscription_record business_subscriptions%ROWTYPE;
  can_access BOOLEAN := false;
BEGIN
  -- Get the latest subscription for the business
  SELECT * INTO subscription_record
  FROM business_subscriptions
  WHERE business_id = business_uuid
  ORDER BY created_at DESC
  LIMIT 1;
  
  -- If no subscription found, return false
  IF NOT FOUND THEN
    RETURN false;
  END IF;
  
  -- Check if trial is active
  IF subscription_record.status = 'trial' AND 
     subscription_record.trial_end_date > NOW() THEN
    can_access := true;
  END IF;
  
  -- Check if subscription is active
  IF subscription_record.status = 'active' AND 
     subscription_record.subscription_end_date > NOW() THEN
    can_access := true;
  END IF;
  
  RETURN can_access;
END;
$$;


--
-- Name: check_customer_credit_limit(uuid, numeric); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_customer_credit_limit(p_customer_id uuid, p_sale_amount numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_credit_limit DECIMAL;
    v_current_credit DECIMAL;
    v_credit_status VARCHAR;
BEGIN
    SELECT credit_limit, current_credit, credit_status
    INTO v_credit_limit, v_current_credit, v_credit_status
    FROM customers
    WHERE id = p_customer_id;
    
    -- Check if customer is blocked
    IF v_credit_status = 'blocked' THEN
        RETURN FALSE;
    END IF;
    
    -- Check if sale would exceed credit limit
    IF v_credit_limit > 0 AND (v_current_credit + p_sale_amount) > v_credit_limit THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$;


--
-- Name: check_customer_discount_usage(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_customer_discount_usage(p_discount_id uuid, p_customer_id uuid) RETURNS TABLE(can_use boolean, usage_count integer, usage_limit integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_usage_count INTEGER;
    v_per_customer_limit INTEGER;
BEGIN
    -- Get the per-customer limit for this discount
    SELECT per_customer_limit 
    INTO v_per_customer_limit
    FROM discount_rules 
    WHERE id = p_discount_id;
    
    -- If no limit is set, customer can use it
    IF v_per_customer_limit IS NULL THEN
        RETURN QUERY SELECT TRUE, 0, NULL::INTEGER;
        RETURN;
    END IF;
    
    -- Count how many times this customer has used this discount
    SELECT COUNT(*)::INTEGER
    INTO v_usage_count
    FROM discount_usage_history
    WHERE discount_rule_id = p_discount_id
    AND customer_id = p_customer_id;
    
    RETURN QUERY SELECT 
        (v_usage_count < v_per_customer_limit),
        v_usage_count,
        v_per_customer_limit;
END;
$$;


--
-- Name: FUNCTION check_customer_discount_usage(p_discount_id uuid, p_customer_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.check_customer_discount_usage(p_discount_id uuid, p_customer_id uuid) IS 'Checks if a customer can use a discount based on per-customer limits';


--
-- Name: check_user_exists_by_phone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.check_user_exists_by_phone(check_phone text) RETURNS TABLE(user_id uuid, email text, full_name text, phone text, user_exists boolean)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Try to find user by phone in auth.users
  -- We need SECURITY DEFINER to access auth.users
  RETURN QUERY
  SELECT 
    au.id as user_id,
    au.email::TEXT,
    COALESCE(au.raw_user_meta_data->>'full_name', '')::TEXT as full_name,
    au.phone::TEXT,
    true as user_exists  -- Changed from 'exists' to 'user_exists'
  FROM auth.users au
  WHERE au.phone = check_phone
  LIMIT 1;
  
  -- If no rows returned, user doesn't exist
  IF NOT FOUND THEN
    RETURN QUERY
    SELECT 
      NULL::UUID as user_id,
      NULL::TEXT as email,
      NULL::TEXT as full_name,
      NULL::TEXT as phone,
      false as user_exists;  -- Changed from 'exists' to 'user_exists'
  END IF;
END;
$$;


--
-- Name: create_default_charges(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_default_charges(p_business_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Service charge (10%)
    INSERT INTO charges (
        business_id,
        code,
        name,
        description,
        charge_type,
        calculation_type,
        value,
        scope,
        auto_apply,
        is_taxable,
        display_order
    ) VALUES (
        p_business_id,
        'SERVICE',
        'Service Charge',
        'Standard service charge',
        'service',
        'percentage',
        10.0,
        'order',
        false,
        true,
        1
    );
    
    -- Packaging charge (fixed)
    INSERT INTO charges (
        business_id,
        code,
        name,
        description,
        charge_type,
        calculation_type,
        value,
        scope,
        auto_apply,
        is_taxable,
        display_order
    ) VALUES (
        p_business_id,
        'PACKAGING',
        'Packaging Charge',
        'Standard packaging charge',
        'packaging',
        'fixed',
        10.0,
        'order',
        false,
        false,
        2
    );
END;
$$;


--
-- Name: create_default_payment_methods(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_default_payment_methods(p_business_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert default payment methods if they don't exist
    INSERT INTO payment_methods (business_id, name, code, icon, is_default, requires_reference, display_order)
    VALUES 
        (p_business_id, 'Cash', 'cash', 'cash', true, false, 1),
        (p_business_id, 'Card', 'card', 'credit_card', true, false, 2),
        (p_business_id, 'Customer Credit', 'customer_credit', 'account_balance', true, false, 3),
        (p_business_id, 'Cheque', 'cheque', 'receipt', true, true, 4)
    ON CONFLICT (business_id, code) DO NOTHING;
END;
$$;


--
-- Name: create_default_price_categories(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_default_price_categories(p_business_id uuid, p_location_id uuid, p_created_by uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert default price categories
    INSERT INTO price_categories (business_id, location_id, name, type, is_default, is_active, is_visible, display_order, icon_name, color_hex, created_by)
    VALUES 
        (p_business_id, p_location_id, 'Dine-In', 'dine_in', true, true, true, 1, 'restaurant', '#4CAF50', p_created_by),
        (p_business_id, p_location_id, 'Parcel', 'takeaway', true, true, true, 2, 'takeout_dining', '#FF9800', p_created_by),
        (p_business_id, p_location_id, 'Delivery', 'delivery', true, true, true, 3, 'delivery_dining', '#2196F3', p_created_by)
    ON CONFLICT (business_id, location_id, name) DO NOTHING;
    
    -- Create default sell screen preferences
    INSERT INTO sell_screen_preferences (business_id, location_id)
    VALUES (p_business_id, p_location_id)
    ON CONFLICT (business_id, location_id) DO NOTHING;
END;
$$;


--
-- Name: create_default_tax_groups(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_default_tax_groups(p_business_id uuid) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_gst_group_id UUID;
BEGIN
    -- Create GST tax group
    INSERT INTO tax_groups (business_id, name, description, is_default, is_active)
    VALUES (p_business_id, 'GST', 'Goods and Services Tax', true, true)
    RETURNING id INTO v_gst_group_id;
    
    -- Create GST rates
    INSERT INTO tax_rates (tax_group_id, business_id, name, rate, type, calculation_method)
    VALUES 
        (v_gst_group_id, p_business_id, 'GST 0%', 0, 'percentage', 'exclusive'),
        (v_gst_group_id, p_business_id, 'GST 5%', 5, 'percentage', 'exclusive'),
        (v_gst_group_id, p_business_id, 'GST 12%', 12, 'percentage', 'exclusive'),
        (v_gst_group_id, p_business_id, 'GST 18%', 18, 'percentage', 'exclusive'),
        (v_gst_group_id, p_business_id, 'GST 28%', 28, 'percentage', 'exclusive');
    
    -- Create Service Tax group (if needed)
    INSERT INTO tax_groups (business_id, name, description, is_default, is_active)
    VALUES (p_business_id, 'Service Tax', 'Service Tax for restaurant services', false, true);
    
END;
$$;


--
-- Name: create_trial_subscription_for_business(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_trial_subscription_for_business(business_uuid uuid, plan_uuid uuid DEFAULT NULL::uuid) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
  DECLARE
    subscription_record business_subscriptions%ROWTYPE;
    selected_plan subscription_plans%ROWTYPE;
    result json;
  BEGIN
    -- Verify the business belongs to the current user
    IF NOT EXISTS (
      SELECT 1 FROM businesses
      WHERE id = business_uuid AND owner_id = auth.uid()
    ) THEN
      RAISE EXCEPTION 'Access denied: Business not found or not owned by user';
    END IF;

    -- Check if business already has a subscription
    IF EXISTS (
      SELECT 1 FROM business_subscriptions
      WHERE business_id = business_uuid
    ) THEN
      RAISE EXCEPTION 'Business already has a subscription';
    END IF;

    -- Get the plan (default to monthly if not specified)
    IF plan_uuid IS NULL THEN
      SELECT * INTO selected_plan
      FROM subscription_plans
      WHERE is_active = true AND duration_months = 1
      ORDER BY created_at ASC
      LIMIT 1;
    ELSE
      SELECT * INTO selected_plan
      FROM subscription_plans
      WHERE id = plan_uuid AND is_active = true;
    END IF;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Valid subscription plan not found';
    END IF;

    -- Create the trial subscription
    INSERT INTO business_subscriptions (
      business_id,
      plan_id,
      status,
      trial_start_date,
      trial_end_date,
      currency,
      auto_renew,
      created_at,
      updated_at
    ) VALUES (
      business_uuid,
      selected_plan.id,
      'trial',
      NOW(),
      NOW() + INTERVAL '14 days',
      'INR',
      false,
      NOW(),
      NOW()
    ) RETURNING * INTO subscription_record;

    -- Return the created subscription as JSON
    SELECT json_build_object(
      'id', subscription_record.id,
      'business_id', subscription_record.business_id,
      'plan_id', subscription_record.plan_id,
      'status', subscription_record.status,
      'trial_start_date', subscription_record.trial_start_date,
      'trial_end_date', subscription_record.trial_end_date,
      'subscription_start_date', subscription_record.subscription_start_date,
      'subscription_end_date', subscription_record.subscription_end_date,
      'auto_renew', subscription_record.auto_renew,
      'payment_method', subscription_record.payment_method,
      'currency', subscription_record.currency,
      'amount_paid', subscription_record.amount_paid,
      'created_at', subscription_record.created_at,
      'updated_at', subscription_record.updated_at
    ) INTO result;

    RETURN result;
  END;
  $$;


--
-- Name: ensure_single_default_printer(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_single_default_printer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_default = true THEN
        UPDATE kot_printers 
        SET is_default = false 
        WHERE business_id = NEW.business_id 
          AND location_id = NEW.location_id 
          AND id != NEW.id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: ensure_single_default_template(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_single_default_template() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.is_default = true THEN
        UPDATE kot_templates 
        SET is_default = false 
        WHERE business_id = NEW.business_id 
          AND location_id = NEW.location_id 
          AND type = NEW.type
          AND id != NEW.id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- Name: ensure_walkin_customer(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ensure_walkin_customer(p_business_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_customer_id UUID;
BEGIN
    -- Try to find existing walk-in customer
    SELECT id INTO v_customer_id
    FROM customers
    WHERE business_id = p_business_id
        AND customer_code = 'WALK-IN'
    LIMIT 1;
    
    -- If not found, create one using deterministic UUID
    IF v_customer_id IS NULL THEN
        -- Generate deterministic UUID using UUID v5
        v_customer_id := uuid_generate_v5(
            p_business_id,  -- namespace (business_id)
            'WALK-IN'       -- name
        );
        
        -- Insert the walk-in customer
        INSERT INTO customers (
            id,
            business_id,
            customer_code,
            name,
            phone,
            email,
            is_walk_in,
            is_active,
            created_at,
            updated_at
        ) VALUES (
            v_customer_id,
            p_business_id,
            'WALK-IN',
            'Walk-in Customer',
            '0000000000',
            NULL,
            true,
            true,
            NOW(),
            NOW()
        )
        ON CONFLICT (business_id, customer_code) 
        DO UPDATE SET updated_at = NOW()
        RETURNING id INTO v_customer_id;
    END IF;
    
    RETURN v_customer_id;
END;
$$;


--
-- Name: get_admin_dashboard_stats(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_admin_dashboard_stats() RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    total_users INTEGER;
    total_businesses INTEGER;
    subscription_stats json;
    revenue_stats json;
BEGIN
    -- Check if the user is an admin
    IF NOT (auth.jwt() ->> 'email' = ANY(ARRAY['admin@tym.com', 'naseefc@tym.com'])) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;
    
    -- Get total unique users (business owners)
    SELECT COUNT(DISTINCT owner_id) INTO total_users
    FROM businesses 
    WHERE is_active = true;
    
    -- Get total businesses
    SELECT COUNT(*) INTO total_businesses
    FROM businesses 
    WHERE is_active = true;
    
    -- Get subscription statistics
    SELECT json_object_agg(status, count) INTO subscription_stats
    FROM (
        SELECT 
            COALESCE(status, 'none') as status,
            COUNT(*) as count 
        FROM business_subscriptions 
        GROUP BY status
    ) s;
    
    -- Get revenue statistics
    SELECT json_build_object(
        'total_revenue', COALESCE(SUM(amount), 0),
        'monthly_revenue', COALESCE(SUM(CASE 
            WHEN created_at >= date_trunc('month', CURRENT_DATE) 
            THEN amount ELSE 0 END), 0)
    ) INTO revenue_stats
    FROM subscription_payments;
    
    RETURN json_build_object(
        'total_users', total_users,
        'total_businesses', total_businesses,
        'subscription_stats', COALESCE(subscription_stats, '{}'::json),
        'revenue_stats', COALESCE(revenue_stats, '{"total_revenue": 0, "monthly_revenue": 0}'::json)
    );
END;
$$;


--
-- Name: get_admin_recent_activities(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_admin_recent_activities(limit_count integer DEFAULT 20) RETURNS TABLE(id text, type text, description text, activity_timestamp timestamp with time zone, business_id uuid, user_id uuid, extra_data json)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if the user is an admin
    IF NOT (auth.jwt() ->> 'email' = ANY(ARRAY['admin@tym.com', 'naseefc@tym.com'])) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;
    
    RETURN QUERY
    (
        -- Recent business creations
        SELECT 
            b.id::TEXT,
            'business_created'::TEXT,
            ('New ' || 
             CASE 
                 WHEN b.business_type = 'restaurant' THEN 'Restaurant'
                 ELSE 'Wholesale & Retail'
             END || 
             ' business created: ' || b.name)::TEXT,
            b.created_at,
            b.id,
            b.owner_id,
            json_build_object('business_type', b.business_type, 'business_name', b.name)
        FROM businesses b
        WHERE b.is_active = true
        ORDER BY b.created_at DESC
        LIMIT limit_count / 2
    )
    UNION ALL
    (
        -- Recent subscription creations
        SELECT 
            bs.id::TEXT,
            'subscription_created'::TEXT,
            (CASE 
                WHEN bs.status = 'trial' THEN 'Free trial started'
                ELSE 'Subscription activated'
            END)::TEXT,
            bs.created_at,
            bs.business_id,
            b.owner_id,
            json_build_object('status', bs.status, 'business_name', b.name)
        FROM business_subscriptions bs
        JOIN businesses b ON b.id = bs.business_id
        ORDER BY bs.created_at DESC
        LIMIT limit_count / 2
    )
    ORDER BY activity_timestamp DESC
    LIMIT limit_count;
END;
$$;


--
-- Name: get_applicable_charges(uuid, uuid, numeric, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_applicable_charges(p_business_id uuid, p_location_id uuid, p_order_value numeric, p_customer_id uuid DEFAULT NULL::uuid) RETURNS TABLE(charge_id uuid, charge_name character varying, charge_type character varying, calculation_type character varying, charge_value numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.name,
        c.charge_type,
        c.calculation_type,
        CASE 
            WHEN c.calculation_type = 'tiered' THEN
                calculate_tiered_charge(c.id, p_order_value)
            ELSE
                c.value
        END as charge_value
    FROM charges c
    WHERE c.business_id = p_business_id
        AND c.is_active = true
        AND (c.location_id IS NULL OR c.location_id = p_location_id)
        AND (c.minimum_order_value IS NULL OR p_order_value >= c.minimum_order_value)
        AND (c.maximum_order_value IS NULL OR p_order_value <= c.maximum_order_value)
        AND (c.valid_from IS NULL OR CURRENT_TIMESTAMP >= c.valid_from)
        AND (c.valid_until IS NULL OR CURRENT_TIMESTAMP <= c.valid_until)
        -- Check if customer is not exempted
        AND NOT EXISTS (
            SELECT 1 FROM customer_charge_exemptions e
            WHERE e.charge_id = c.id
                AND e.customer_id = p_customer_id
                AND e.is_active = true
                AND e.exemption_type = 'full'
        );
END;
$$;


--
-- Name: get_applicable_discounts(uuid, numeric, uuid[], uuid[], uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_applicable_discounts(p_business_id uuid, p_cart_total numeric, p_product_ids uuid[] DEFAULT NULL::uuid[], p_category_ids uuid[] DEFAULT NULL::uuid[], p_customer_id uuid DEFAULT NULL::uuid) RETURNS TABLE(discount_id uuid, discount_name character varying, discount_type character varying, discount_value numeric, max_discount_amount numeric, is_auto_apply boolean, priority integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        dr.id,
        dr.name,
        dr.discount_type,
        dr.discount_value,
        dr.max_discount_amount,
        dr.auto_apply,
        dr.priority
    FROM discount_rules dr
    WHERE dr.business_id = p_business_id
    AND is_discount_valid(dr.id)
    AND (
        -- Cart-level discounts apply to all
        dr.scope = 'cart'
        OR
        -- Category-specific discounts
        (dr.scope = 'category' AND p_category_ids IS NOT NULL AND EXISTS (
            SELECT 1 FROM discount_categories dc
            WHERE dc.discount_rule_id = dr.id
            AND dc.category_id = ANY(p_category_ids)
            AND dc.is_active = TRUE
        ))
        OR
        -- Product-specific discounts
        (dr.scope IN ('item', 'product') AND p_product_ids IS NOT NULL AND EXISTS (
            SELECT 1 FROM discount_products dp
            WHERE dp.discount_rule_id = dr.id
            AND dp.product_id = ANY(p_product_ids)
            AND dp.is_active = TRUE
        ))
    )
    AND (
        -- Check minimum purchase amount if specified
        dr.min_purchase_amount IS NULL OR
        p_cart_total >= dr.min_purchase_amount
    )
    ORDER BY dr.priority DESC, dr.discount_value DESC;
END;
$$;


--
-- Name: FUNCTION get_applicable_discounts(p_business_id uuid, p_cart_total numeric, p_product_ids uuid[], p_category_ids uuid[], p_customer_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_applicable_discounts(p_business_id uuid, p_cart_total numeric, p_product_ids uuid[], p_category_ids uuid[], p_customer_id uuid) IS 'Returns all applicable discounts for a given cart context';


--
-- Name: get_business_subscriptions_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_business_subscriptions_admin() RETURNS TABLE(subscription_id uuid, business_id uuid, business_name text, business_type text, owner_id uuid, status text, plan_name text, trial_end_date timestamp with time zone, subscription_end_date timestamp with time zone, currency text, amount_paid numeric, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if the user is an admin
    IF NOT (auth.jwt() ->> 'email' = ANY(ARRAY['admin@tym.com', 'naseefc@tym.com'])) THEN
        RAISE EXCEPTION 'Access denied. Admin privileges required.';
    END IF;
    
    RETURN QUERY
    SELECT 
        bs.id,
        b.id,
        b.name,
        b.business_type,
        b.owner_id,
        bs.status,
        sp.name,
        bs.trial_end_date,
        bs.subscription_end_date,
        bs.currency,
        bs.amount_paid,
        bs.created_at
    FROM business_subscriptions bs
    JOIN businesses b ON b.id = bs.business_id
    LEFT JOIN subscription_plans sp ON sp.id = bs.plan_id
    ORDER BY bs.created_at DESC;
END;
$$;


--
-- Name: get_default_tax_group(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_default_tax_group(p_business_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_tax_group_id UUID;
BEGIN
    SELECT id INTO v_tax_group_id
    FROM tax_groups
    WHERE business_id = p_business_id
    AND is_default = true
    AND is_active = true
    LIMIT 1;
    
    RETURN v_tax_group_id;
END;
$$;


--
-- Name: FUNCTION get_default_tax_group(p_business_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.get_default_tax_group(p_business_id uuid) IS 'Returns the default tax group ID for a business';


--
-- Name: get_user_business_ids(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_business_ids() RETURNS uuid[]
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  business_ids UUID[];
BEGIN
  -- Get all business IDs where the user is an owner
  SELECT ARRAY_AGG(DISTINCT id) INTO business_ids
  FROM businesses 
  WHERE owner_id = auth.uid();
  
  -- Add business IDs where the user is an active employee
  -- This query won't trigger RLS because of SECURITY DEFINER
  SELECT ARRAY_AGG(DISTINCT e.business_id) INTO business_ids
  FROM (
    SELECT business_id 
    FROM employees 
    WHERE user_id = auth.uid() 
    AND employment_status = 'active'
  ) e
  WHERE business_ids IS NULL 
     OR e.business_id != ALL(COALESCE(business_ids, ARRAY[]::UUID[]));
  
  -- Combine both arrays
  IF business_ids IS NULL THEN
    SELECT ARRAY_AGG(DISTINCT business_id) INTO business_ids
    FROM employees 
    WHERE user_id = auth.uid() 
    AND employment_status = 'active';
  ELSE
    SELECT ARRAY_AGG(DISTINCT combined_id) INTO business_ids
    FROM (
      SELECT unnest(business_ids) AS combined_id
      UNION
      SELECT business_id AS combined_id
      FROM employees 
      WHERE user_id = auth.uid() 
      AND employment_status = 'active'
    ) combined;
  END IF;
  
  RETURN COALESCE(business_ids, ARRAY[]::UUID[]);
END;
$$;


--
-- Name: get_user_by_phone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_user_by_phone(check_phone text) RETURNS TABLE(user_id uuid, email character varying, phone character varying, raw_user_meta_data jsonb, created_at timestamp with time zone)
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT 
    id as user_id,
    email::VARCHAR,
    phone::VARCHAR,
    raw_user_meta_data,
    created_at
  FROM auth.users
  WHERE phone = check_phone
     OR raw_user_meta_data->>'phone' = check_phone
  LIMIT 1;
$$;


--
-- Name: is_active_employee(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_active_employee(business_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM employees 
    WHERE business_id = business_uuid 
    AND user_id = auth.uid() 
    AND employment_status = 'active'
  );
END;
$$;


--
-- Name: is_business_manager(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_business_manager(business_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM businesses WHERE id = business_uuid AND owner_id = auth.uid()
  ) OR EXISTS (
    SELECT 1 FROM employees 
    WHERE business_id = business_uuid 
    AND user_id = auth.uid() 
    AND primary_role IN ('manager', 'owner')
    AND employment_status = 'active'
  );
END;
$$;


--
-- Name: is_discount_valid(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_discount_valid(discount_id uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    discount RECORD;
    curr_time TIME;
    curr_day INTEGER;
BEGIN
    SELECT * INTO discount FROM discount_rules WHERE id = discount_id;
    
    IF NOT FOUND OR NOT discount.is_active THEN
        RETURN FALSE;
    END IF;
    
    -- Check date validity
    IF discount.valid_from IS NOT NULL AND NOW() < discount.valid_from THEN
        RETURN FALSE;
    END IF;
    
    IF discount.valid_until IS NOT NULL AND NOW() > discount.valid_until THEN
        RETURN FALSE;
    END IF;
    
    -- Check time validity
    curr_time := LOCALTIME;
    IF discount.valid_from_time IS NOT NULL AND curr_time < discount.valid_from_time THEN
        RETURN FALSE;
    END IF;
    
    IF discount.valid_until_time IS NOT NULL AND curr_time > discount.valid_until_time THEN
        RETURN FALSE;
    END IF;
    
    -- Check day validity (0 = Sunday, 1 = Monday, etc.)
    IF discount.valid_days IS NOT NULL AND array_length(discount.valid_days, 1) > 0 THEN
        curr_day := EXTRACT(DOW FROM NOW())::INTEGER;
        IF NOT (curr_day = ANY(discount.valid_days)) THEN
            RETURN FALSE;
        END IF;
    END IF;
    
    -- Check usage limits
    IF discount.total_usage_limit IS NOT NULL AND 
       discount.current_usage_count >= discount.total_usage_limit THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$;


--
-- Name: FUNCTION is_discount_valid(discount_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.is_discount_valid(discount_id uuid) IS 'Checks if a discount is currently valid based on dates, times, days, and usage limits';


--
-- Name: is_phone_registered(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_phone_registered(check_phone text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS(
    SELECT 1 FROM auth.users WHERE phone = check_phone
  );
END;
$$;


--
-- Name: maintain_business_owner_lookup(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.maintain_business_owner_lookup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO employee_business_lookup (
      user_id, 
      business_id, 
      is_owner, 
      updated_at
    ) VALUES (
      NEW.owner_id,
      NEW.id,
      true,
      NOW()
    )
    ON CONFLICT (user_id, business_id) 
    DO UPDATE SET
      is_owner = true,
      updated_at = NOW();
  ELSIF TG_OP = 'DELETE' THEN
    DELETE FROM employee_business_lookup
    WHERE business_id = OLD.id AND is_owner = true;
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: maintain_employee_business_lookup(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.maintain_employee_business_lookup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    -- Update or insert into lookup table
    INSERT INTO employee_business_lookup (
      user_id, 
      business_id, 
      is_active_employee, 
      employee_role, 
      updated_at
    ) VALUES (
      NEW.user_id,
      NEW.business_id,
      NEW.employment_status = 'active',
      NEW.primary_role,
      NOW()
    )
    ON CONFLICT (user_id, business_id) 
    DO UPDATE SET
      is_active_employee = EXCLUDED.is_active_employee,
      employee_role = EXCLUDED.employee_role,
      updated_at = NOW();
  ELSIF TG_OP = 'DELETE' THEN
    -- Remove from lookup table
    DELETE FROM employee_business_lookup
    WHERE user_id = OLD.user_id AND business_id = OLD.business_id
    AND is_active_employee = true; -- Only remove employee entry, not owner entry
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: on_business_created_payment_methods(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.on_business_created_payment_methods() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM create_default_payment_methods(NEW.id);
    RETURN NEW;
END;
$$;


--
-- Name: record_discount_usage(uuid, uuid, numeric, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.record_discount_usage(p_discount_id uuid, p_order_id uuid, p_discount_amount numeric, p_customer_id uuid DEFAULT NULL::uuid, p_location_id uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_usage_id UUID;
BEGIN
    -- Insert usage record
    INSERT INTO discount_usage_history (
        discount_rule_id,
        order_id,
        customer_id,
        discount_amount,
        used_at,
        location_id
    ) VALUES (
        p_discount_id,
        p_order_id,
        p_customer_id,
        p_discount_amount,
        NOW(),
        p_location_id
    ) RETURNING id INTO v_usage_id;
    
    -- Update usage count in discount_rules
    UPDATE discount_rules 
    SET current_usage_count = COALESCE(current_usage_count, 0) + 1
    WHERE id = p_discount_id;
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
$$;


--
-- Name: FUNCTION record_discount_usage(p_discount_id uuid, p_order_id uuid, p_discount_amount numeric, p_customer_id uuid, p_location_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.record_discount_usage(p_discount_id uuid, p_order_id uuid, p_discount_amount numeric, p_customer_id uuid, p_location_id uuid) IS 'Records discount usage and updates the usage counter';


--
-- Name: record_subscription_payment(uuid, numeric, text, text, text, text, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.record_subscription_payment(p_subscription_id uuid, p_amount numeric, p_currency text DEFAULT 'INR'::text, p_payment_method text DEFAULT 'manual'::text, p_payment_reference text DEFAULT NULL::text, p_notes text DEFAULT NULL::text, p_payment_date timestamp with time zone DEFAULT now()) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_current_amount_paid DECIMAL(10,2);
    v_new_total_paid DECIMAL(10,2);
    v_payment_record json;
    v_subscription_exists BOOLEAN;
BEGIN
    -- Check if the user is an admin
    IF NOT (auth.jwt() ->> 'email' = ANY(ARRAY['admin@tym.com', 'naseefc@tym.com'])) THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Access denied. Admin privileges required.'
        );
    END IF;
    
    -- Start transaction block
    BEGIN
        -- Check if subscription exists and get current amount_paid
        SELECT 
            COALESCE(amount_paid, 0),
            TRUE
        INTO v_current_amount_paid, v_subscription_exists
        FROM business_subscriptions 
        WHERE id = p_subscription_id;
        
        IF NOT v_subscription_exists THEN
            RETURN json_build_object(
                'success', false,
                'error', 'Subscription not found'
            );
        END IF;
        
        -- Calculate new total paid amount
        v_new_total_paid := v_current_amount_paid + p_amount;
        
        -- Insert payment record and capture the result
        INSERT INTO subscription_payments (
            subscription_id,
            amount,
            currency,
            payment_method,
            payment_reference,
            payment_date,
            notes
        ) VALUES (
            p_subscription_id,
            p_amount,
            p_currency,
            p_payment_method,
            p_payment_reference,
            p_payment_date,
            p_notes
        )
        RETURNING json_build_object(
            'id', id,
            'subscription_id', subscription_id,
            'amount', amount,
            'currency', currency,
            'payment_method', payment_method,
            'payment_reference', payment_reference,
            'payment_date', payment_date,
            'verified_by', verified_by,
            'notes', notes,
            'created_at', created_at
        ) INTO v_payment_record;
        
        -- Update subscription amount_paid
        UPDATE business_subscriptions 
        SET 
            amount_paid = v_new_total_paid,
            updated_at = NOW()
        WHERE id = p_subscription_id;
        
        -- Return success with payment record
        RETURN json_build_object(
            'success', true,
            'payment_record', v_payment_record,
            'new_total_paid', v_new_total_paid,
            'previous_amount_paid', v_current_amount_paid
        );
        
    EXCEPTION WHEN OTHERS THEN
        -- Transaction will automatically rollback on exception
        RETURN json_build_object(
            'success', false,
            'error', 'Transaction failed: ' || SQLERRM
        );
    END;
END;
$$;


--
-- Name: sync_employee_with_dependencies(uuid, uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sync_employee_with_dependencies(p_employee_id uuid, p_user_id uuid, p_business_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- First ensure the business owner relationship exists in lookup
  INSERT INTO employee_business_lookup (user_id, business_id, is_owner)
  SELECT owner_id, id, true FROM businesses WHERE id = p_business_id
  ON CONFLICT (user_id, business_id) 
  DO UPDATE SET is_owner = true, updated_at = NOW();
  
  -- Then ensure the employee relationship exists
  INSERT INTO employee_business_lookup (user_id, business_id, is_active_employee, employee_role)
  SELECT user_id, business_id, employment_status = 'active', primary_role
  FROM employees WHERE id = p_employee_id
  ON CONFLICT (user_id, business_id) 
  DO UPDATE SET 
    is_active_employee = EXCLUDED.is_active_employee,
    employee_role = EXCLUDED.employee_role,
    updated_at = NOW();
  
  RETURN true;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error in sync_employee_with_dependencies: %', SQLERRM;
    RETURN false;
END;
$$;


--
-- Name: update_customer_purchase_metrics(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_customer_purchase_metrics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.transaction_type = 'sale' THEN
        UPDATE customers
        SET 
            total_purchases = total_purchases + NEW.amount,
            purchase_count = purchase_count + 1,
            last_purchase_date = CURRENT_DATE,
            first_purchase_date = COALESCE(first_purchase_date, CURRENT_DATE),
            average_order_value = (total_purchases + NEW.amount) / (purchase_count + 1),
            current_credit = NEW.balance_after,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.customer_id;
    ELSIF TG_OP = 'INSERT' AND NEW.transaction_type = 'payment' THEN
        UPDATE customers
        SET 
            total_payments = total_payments + ABS(NEW.amount),
            current_credit = NEW.balance_after,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.customer_id;
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: update_table_status_from_orders(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_table_status_from_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_active_orders INTEGER;
    v_billed_orders INTEGER;
    v_total_amount DECIMAL(10,2);
BEGIN
    -- Count active and billed orders for the table
    SELECT 
        COUNT(*) FILTER (WHERE o.status IN ('pending', 'confirmed', 'preparing', 'ready')),
        COUNT(*) FILTER (WHERE o.payment_status = 'pending' AND to2.is_printed_bill = true),
        COALESCE(SUM(o.total) FILTER (WHERE o.status NOT IN ('completed', 'cancelled')), 0)
    INTO v_active_orders, v_billed_orders, v_total_amount
    FROM table_orders to2
    JOIN orders o ON o.id = to2.order_id
    WHERE to2.table_id = COALESCE(NEW.table_id, OLD.table_id)
    AND to2.is_active = true;
    
    -- Update table status and amount
    UPDATE tables
    SET 
        status = CASE
            WHEN v_billed_orders > 0 THEN 'billed'
            WHEN v_active_orders > 0 THEN 'occupied'
            ELSE 'free'
        END,
        current_amount = v_total_amount,
        occupied_at = CASE
            WHEN v_active_orders > 0 AND occupied_at IS NULL THEN CURRENT_TIMESTAMP
            WHEN v_active_orders = 0 THEN NULL
            ELSE occupied_at
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = COALESCE(NEW.table_id, OLD.table_id);
    
    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: update_user_phone(uuid, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_user_phone(user_id uuid, phone_number text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Update the phone field in auth.users
  UPDATE auth.users
  SET 
    phone = phone_number,
    updated_at = NOW()
  WHERE id = user_id;
  
  -- Also update the phone in raw_user_meta_data if it exists
  UPDATE auth.users
  SET raw_user_meta_data = 
    CASE 
      WHEN raw_user_meta_data IS NULL THEN 
        jsonb_build_object('phone', phone_number)
      ELSE 
        raw_user_meta_data || jsonb_build_object('phone', phone_number)
    END
  WHERE id = user_id;
  
  RETURN FOUND; -- Returns true if a row was updated
END;
$$;


--
-- Name: validate_coupon_code(character varying, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_coupon_code(p_code character varying, p_business_id uuid) RETURNS TABLE(discount_id uuid, discount_name character varying, discount_type character varying, discount_value numeric, is_valid boolean, message text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_discount RECORD;
    v_now TIMESTAMPTZ := NOW();
BEGIN
    -- Find the discount with the given code
    SELECT * INTO v_discount
    FROM discount_rules
    WHERE code = p_code
    AND business_id = p_business_id
    AND is_active = true
    LIMIT 1;
    
    -- Check if discount exists
    IF NOT FOUND THEN
        RETURN QUERY SELECT 
            NULL::UUID,
            NULL::VARCHAR,
            NULL::VARCHAR,
            NULL::DECIMAL,
            false,
            'Invalid coupon code'::TEXT;
        RETURN;
    END IF;
    
    -- Check validity period
    IF v_discount.valid_from IS NOT NULL AND v_now < v_discount.valid_from THEN
        RETURN QUERY SELECT 
            v_discount.id,
            v_discount.name,
            v_discount.discount_type,
            v_discount.discount_value,
            false,
            'Coupon is not yet valid'::TEXT;
        RETURN;
    END IF;
    
    IF v_discount.valid_until IS NOT NULL AND v_now > v_discount.valid_until THEN
        RETURN QUERY SELECT 
            v_discount.id,
            v_discount.name,
            v_discount.discount_type,
            v_discount.discount_value,
            false,
            'Coupon has expired'::TEXT;
        RETURN;
    END IF;
    
    -- Check usage limits
    IF v_discount.total_usage_limit IS NOT NULL AND 
       v_discount.current_usage_count >= v_discount.total_usage_limit THEN
        RETURN QUERY SELECT 
            v_discount.id,
            v_discount.name,
            v_discount.discount_type,
            v_discount.discount_value,
            false,
            'Coupon usage limit reached'::TEXT;
        RETURN;
    END IF;
    
    -- All checks passed
    RETURN QUERY SELECT 
        v_discount.id,
        v_discount.name,
        v_discount.discount_type,
        v_discount.discount_value,
        true,
        'Coupon is valid'::TEXT;
END;
$$;


--
-- Name: FUNCTION validate_coupon_code(p_code character varying, p_business_id uuid); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.validate_coupon_code(p_code character varying, p_business_id uuid) IS 'Validates a coupon code and returns discount details if valid';


--
-- Name: validate_table_order_business_location(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.validate_table_order_business_location() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Verify that the location belongs to the business
    IF NOT EXISTS (
        SELECT 1 FROM business_locations
        WHERE id = NEW.location_id AND business_id = NEW.business_id
    ) THEN
        RAISE EXCEPTION 'Location does not belong to the specified business';
    END IF;
    
    -- Verify that the table belongs to the location
    IF NOT EXISTS (
        SELECT 1 FROM tables
        WHERE id = NEW.table_id AND location_id = NEW.location_id
    ) THEN
        RAISE EXCEPTION 'Table does not belong to the specified location';
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
BEGIN
    RETURN query EXECUTE
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name || '/' AS name,
                    NULL::uuid AS id,
                    NULL::timestamptz AS updated_at,
                    NULL::timestamptz AS created_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
                ORDER BY prefixes.name COLLATE "C" LIMIT $3
            )
            UNION ALL
            (SELECT split_part(name, '/', $4) AS key,
                name,
                id,
                updated_at,
                created_at,
                metadata
            FROM storage.objects
            WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
            ORDER BY name COLLATE "C" LIMIT $3)
        ) obj
        ORDER BY name COLLATE "C" LIMIT $3;
        $sql$
        USING prefix, bucket_name, limits, levels, start_after;
END;
$_$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_id text NOT NULL,
    client_secret_hash text NOT NULL,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: business_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    address text,
    phone character varying(20),
    coordinates point,
    is_default boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: business_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.business_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    status character varying DEFAULT 'trial'::character varying NOT NULL,
    trial_start_date timestamp without time zone,
    trial_end_date timestamp without time zone,
    subscription_start_date timestamp without time zone,
    subscription_end_date timestamp without time zone,
    auto_renew boolean DEFAULT false,
    payment_method character varying DEFAULT 'manual'::character varying,
    currency character varying(3) DEFAULT 'INR'::character varying,
    amount_paid numeric(10,2),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.businesses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(255) NOT NULL,
    business_type character varying(50) NOT NULL,
    description text,
    address text,
    phone character varying(50),
    email character varying(255),
    website character varying(500),
    tax_number character varying(100),
    registration_number character varying(100),
    owner_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT businesses_business_type_check CHECK (((business_type)::text = ANY ((ARRAY['restaurant'::character varying, 'wholesaleRetail'::character varying])::text[])))
);


--
-- Name: category_taxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_taxes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_id uuid NOT NULL,
    tax_group_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE category_taxes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.category_taxes IS 'Category-wide tax assignments';


--
-- Name: charge_formulas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charge_formulas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    charge_id uuid NOT NULL,
    base_amount numeric(10,2) DEFAULT 0,
    variable_rate numeric(10,2) DEFAULT 0,
    variable_type character varying(50),
    min_charge numeric(10,2),
    max_charge numeric(10,2),
    formula_expression text,
    custom_variables jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: charge_tiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charge_tiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    charge_id uuid NOT NULL,
    tier_name character varying(100),
    min_value numeric(15,2) NOT NULL,
    max_value numeric(15,2),
    charge_value numeric(10,2) NOT NULL,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: charge_usage_analytics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charge_usage_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    charge_id uuid NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid,
    usage_date date NOT NULL,
    usage_count integer DEFAULT 0,
    total_amount numeric(15,2) DEFAULT 0,
    waived_count integer DEFAULT 0,
    waived_amount numeric(15,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.charges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    charge_type character varying(50) NOT NULL,
    calculation_type character varying(20) NOT NULL,
    value numeric(10,2),
    scope character varying(20) DEFAULT 'order'::character varying NOT NULL,
    auto_apply boolean DEFAULT false,
    is_mandatory boolean DEFAULT false,
    is_taxable boolean DEFAULT true,
    apply_before_discount boolean DEFAULT false,
    minimum_order_value numeric(15,2),
    maximum_order_value numeric(15,2),
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    applicable_days text[],
    applicable_time_slots jsonb,
    applicable_categories uuid[],
    applicable_products uuid[],
    excluded_categories uuid[],
    excluded_products uuid[],
    applicable_customer_groups uuid[],
    excluded_customer_groups uuid[],
    display_order integer DEFAULT 0,
    show_in_pos boolean DEFAULT true,
    show_in_invoice boolean DEFAULT true,
    show_in_online boolean DEFAULT true,
    icon_name character varying(50),
    color_hex character varying(7),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: customer_charge_exemptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_charge_exemptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    charge_id uuid NOT NULL,
    business_id uuid NOT NULL,
    exemption_type character varying(20) NOT NULL,
    exemption_value numeric(10,2),
    reason text,
    valid_from date,
    valid_until date,
    is_active boolean DEFAULT true,
    approved_by uuid,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    percent_off numeric(5,2),
    CONSTRAINT customer_charge_exemptions_percent_range CHECK (((percent_off IS NULL) OR ((percent_off >= (0)::numeric) AND (percent_off <= (100)::numeric))))
);


--
-- Name: customer_communications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_communications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    communication_type character varying(50) NOT NULL,
    direction character varying(10),
    subject character varying(500),
    content text,
    contact_person character varying(200),
    handled_by uuid,
    status character varying(50),
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    follow_up_required boolean DEFAULT false,
    follow_up_date date,
    follow_up_notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: customer_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    designation character varying(100),
    department character varying(100),
    email character varying(255),
    phone character varying(20),
    mobile character varying(20),
    is_primary boolean DEFAULT false,
    is_billing_contact boolean DEFAULT false,
    is_shipping_contact boolean DEFAULT false,
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: customer_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_documents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_id uuid NOT NULL,
    document_type character varying(50) NOT NULL,
    document_name character varying(200) NOT NULL,
    file_url text,
    file_size integer,
    mime_type character varying(100),
    valid_from date,
    valid_until date,
    notes text,
    is_verified boolean DEFAULT false,
    verified_by uuid,
    uploaded_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    uploaded_by uuid
);


--
-- Name: customer_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    color character varying(7),
    discount_percent numeric(5,2) DEFAULT 0,
    credit_limit numeric(15,2) DEFAULT 0,
    payment_terms integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: customer_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    transaction_type character varying(20) NOT NULL,
    transaction_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    reference_type character varying(50),
    reference_id uuid,
    reference_number character varying(100),
    amount numeric(15,2) NOT NULL,
    balance_before numeric(15,2) NOT NULL,
    balance_after numeric(15,2) NOT NULL,
    payment_method_id uuid,
    payment_reference character varying(200),
    payment_date date,
    cheque_number character varying(50),
    cheque_date date,
    cheque_status character varying(20),
    bank_name character varying(100),
    description text,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    is_verified boolean DEFAULT false,
    verified_by uuid,
    verified_at timestamp with time zone
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    group_id uuid,
    customer_code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    company_name character varying(200),
    customer_type character varying(20) DEFAULT 'individual'::character varying,
    email character varying(255),
    phone character varying(20),
    alternate_phone character varying(20),
    whatsapp_number character varying(20),
    website character varying(255),
    address_line1 character varying(255),
    address_line2 character varying(255),
    city character varying(100),
    state character varying(100),
    postal_code character varying(20),
    country character varying(100),
    shipping_address_line1 character varying(255),
    shipping_address_line2 character varying(255),
    shipping_city character varying(100),
    shipping_state character varying(100),
    shipping_postal_code character varying(20),
    shipping_country character varying(100),
    use_billing_for_shipping boolean DEFAULT true,
    tax_id character varying(100),
    tax_exempt boolean DEFAULT false,
    tax_exempt_reason text,
    credit_limit numeric(15,2) DEFAULT 0,
    current_credit numeric(15,2) DEFAULT 0,
    payment_terms integer DEFAULT 0,
    credit_status character varying(20) DEFAULT 'active'::character varying,
    credit_notes text,
    price_category_id uuid,
    discount_percent numeric(5,2) DEFAULT 0,
    loyalty_points integer DEFAULT 0,
    loyalty_tier character varying(50),
    membership_number character varying(50),
    membership_expiry date,
    date_of_birth date,
    anniversary_date date,
    first_purchase_date date,
    last_purchase_date date,
    total_purchases numeric(15,2) DEFAULT 0,
    total_payments numeric(15,2) DEFAULT 0,
    purchase_count integer DEFAULT 0,
    average_order_value numeric(15,2) DEFAULT 0,
    preferred_contact_method character varying(20),
    language_preference character varying(10) DEFAULT 'en'::character varying,
    currency_preference character varying(3) DEFAULT 'INR'::character varying,
    marketing_consent boolean DEFAULT false,
    sms_consent boolean DEFAULT false,
    email_consent boolean DEFAULT false,
    notes text,
    tags text[],
    is_active boolean DEFAULT true,
    is_blacklisted boolean DEFAULT false,
    blacklist_reason text,
    is_vip boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    last_modified_by uuid,
    is_walk_in boolean DEFAULT false
);


--
-- Name: customer_outstanding_balances; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.customer_outstanding_balances AS
 SELECT id,
    business_id,
    customer_code,
    name,
    credit_limit,
    current_credit,
    payment_terms,
    credit_status,
        CASE
            WHEN ((current_credit > credit_limit) AND (credit_limit > (0)::numeric)) THEN 'Over Limit'::text
            WHEN (current_credit > (0)::numeric) THEN 'Outstanding'::text
            ELSE 'Clear'::text
        END AS balance_status,
    ( SELECT count(*) AS count
           FROM public.customer_transactions ct
          WHERE ((ct.customer_id = c.id) AND ((ct.cheque_status)::text = 'pending'::text))) AS pending_cheques_count,
    ( SELECT sum(ct.amount) AS sum
           FROM public.customer_transactions ct
          WHERE ((ct.customer_id = c.id) AND ((ct.cheque_status)::text = 'pending'::text))) AS pending_cheques_amount
   FROM public.customers c
  WHERE (is_active = true);


--
-- Name: discount_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    discount_rule_id uuid NOT NULL,
    category_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE discount_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.discount_categories IS 'Categories eligible for specific discounts';


--
-- Name: discount_customer_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_customer_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    discount_rule_id uuid NOT NULL,
    customer_group_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: discount_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    discount_rule_id uuid NOT NULL,
    product_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE discount_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.discount_products IS 'Products eligible for specific discounts';


--
-- Name: discount_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(50),
    description text,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    max_discount_amount numeric(10,2),
    scope character varying(20) NOT NULL,
    auto_apply boolean DEFAULT false,
    requires_coupon boolean DEFAULT false,
    combinable boolean DEFAULT false,
    min_purchase_amount numeric(10,2),
    min_quantity integer,
    buy_quantity integer,
    get_quantity integer,
    get_discount_percent numeric(5,2),
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    total_usage_limit integer,
    per_customer_limit integer,
    current_usage_count integer DEFAULT 0,
    valid_days integer[],
    valid_from_time time without time zone,
    valid_until_time time without time zone,
    priority integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT discount_rules_discount_type_check CHECK (((discount_type)::text = ANY ((ARRAY['percentage'::character varying, 'fixed'::character varying, 'buy_x_get_y'::character varying, 'bundle'::character varying])::text[]))),
    CONSTRAINT discount_rules_scope_check CHECK (((scope)::text = ANY ((ARRAY['item'::character varying, 'cart'::character varying, 'category'::character varying, 'product'::character varying])::text[])))
);


--
-- Name: TABLE discount_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.discount_rules IS 'Configurable discount rules with various conditions';


--
-- Name: discount_usage_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_usage_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    discount_rule_id uuid NOT NULL,
    order_id uuid NOT NULL,
    customer_id uuid,
    discount_amount numeric(10,2) NOT NULL,
    used_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    location_id uuid
);


--
-- Name: TABLE discount_usage_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.discount_usage_history IS 'Track discount usage for analytics and limits';


--
-- Name: employee_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid,
    business_id uuid,
    action text NOT NULL,
    entity_type text,
    entity_id uuid,
    old_values jsonb DEFAULT '{}'::jsonb,
    new_values jsonb DEFAULT '{}'::jsonb,
    performed_by uuid,
    performed_by_name text,
    performed_at timestamp with time zone DEFAULT now(),
    ip_address inet,
    user_agent text,
    has_unsynced_changes boolean DEFAULT false
);


--
-- Name: employee_business_lookup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_business_lookup (
    user_id uuid NOT NULL,
    business_id uuid NOT NULL,
    is_owner boolean DEFAULT false,
    is_active_employee boolean DEFAULT false,
    employee_role text,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: employee_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id uuid NOT NULL,
    session_token text NOT NULL,
    device_id text NOT NULL,
    device_name text,
    device_type text,
    app_type text,
    app_version text,
    ip_address inet,
    user_agent text,
    started_at timestamp with time zone DEFAULT now(),
    last_activity_at timestamp with time zone DEFAULT now(),
    expires_at timestamp with time zone,
    last_known_location point,
    last_location_update timestamp with time zone,
    is_active boolean DEFAULT true,
    ended_at timestamp with time zone,
    end_reason text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT employee_sessions_app_type_check CHECK ((app_type = ANY (ARRAY['erp_desktop'::text, 'waiter_app'::text, 'kitchen_app'::text, 'delivery_app'::text]))),
    CONSTRAINT employee_sessions_device_type_check CHECK ((device_type = ANY (ARRAY['desktop'::text, 'mobile'::text, 'tablet'::text, 'pos_terminal'::text]))),
    CONSTRAINT employee_sessions_end_reason_check CHECK ((end_reason = ANY (ARRAY['logout'::text, 'timeout'::text, 'forced'::text, 'app_closed'::text, 'network_error'::text])))
);


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    business_id uuid NOT NULL,
    employee_code text NOT NULL,
    display_name text,
    primary_role text NOT NULL,
    assigned_locations uuid[] DEFAULT '{}'::uuid[],
    can_access_all_locations boolean DEFAULT false,
    employment_status text DEFAULT 'active'::text,
    joined_at date DEFAULT CURRENT_DATE,
    terminated_at date,
    termination_reason text,
    work_phone text,
    work_email text,
    emergency_contact jsonb DEFAULT '{}'::jsonb,
    permissions jsonb DEFAULT '{}'::jsonb,
    settings jsonb DEFAULT '{}'::jsonb,
    default_shift_start time without time zone,
    default_shift_end time without time zone,
    working_days integer[] DEFAULT '{1,2,3,4,5}'::integer[],
    hourly_rate numeric(10,2),
    monthly_salary numeric(10,2),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    last_modified_by uuid,
    has_unsynced_changes boolean DEFAULT false,
    last_synced_at timestamp with time zone,
    CONSTRAINT employees_employment_status_check CHECK ((employment_status = ANY (ARRAY['active'::text, 'inactive'::text, 'suspended'::text, 'terminated'::text]))),
    CONSTRAINT employees_primary_role_check CHECK ((primary_role = ANY (ARRAY['owner'::text, 'manager'::text, 'cashier'::text, 'waiter'::text, 'kitchen_staff'::text, 'delivery'::text, 'accountant'::text])))
);


--
-- Name: kot_item_routing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_item_routing (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    station_id uuid NOT NULL,
    category_id uuid,
    product_id uuid,
    variation_id uuid,
    priority integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT at_least_one_routing_criterion CHECK (((category_id IS NOT NULL) OR (product_id IS NOT NULL) OR (variation_id IS NOT NULL))),
    CONSTRAINT kot_item_routing_priority_check CHECK ((priority > 0)),
    CONSTRAINT single_routing_type CHECK ((((category_id IS NOT NULL) AND (product_id IS NULL) AND (variation_id IS NULL)) OR ((category_id IS NULL) AND (product_id IS NOT NULL) AND (variation_id IS NULL)) OR ((category_id IS NULL) AND (product_id IS NULL) AND (variation_id IS NOT NULL))))
);


--
-- Name: kot_printer_stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_printer_stations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    printer_id uuid NOT NULL,
    station_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    priority integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT kot_printer_stations_priority_check CHECK ((priority > 0))
);


--
-- Name: kot_printers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_printers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    ip_address character varying(45),
    port text DEFAULT 9100,
    type character varying(50) DEFAULT 'network'::character varying,
    description text,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false,
    printer_type text DEFAULT 'network'::text,
    mac_address text,
    device_name text,
    print_copies integer DEFAULT 1,
    paper_size text DEFAULT '80mm'::text,
    auto_cut boolean DEFAULT true,
    cash_drawer boolean DEFAULT false,
    notes text,
    CONSTRAINT check_paper_size CHECK ((paper_size = ANY (ARRAY['58mm'::text, '80mm'::text]))),
    CONSTRAINT check_printer_type CHECK ((printer_type = ANY (ARRAY['network'::text, 'bluetooth'::text, 'usb'::text, 'serial'::text])))
);


--
-- Name: kot_routing_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_routing_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    printer_id uuid NOT NULL,
    instruction text,
    copies integer DEFAULT 1,
    priority integer DEFAULT 1,
    is_active boolean DEFAULT true,
    order_type character varying(50),
    time_range character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false
);


--
-- Name: kot_stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_stations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    color character varying(7),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: kot_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kot_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(20) NOT NULL,
    content text NOT NULL,
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    description text,
    settings jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT kot_templates_type_check CHECK (((type)::text = ANY ((ARRAY['header'::character varying, 'footer'::character varying, 'item_format'::character varying, 'full'::character varying])::text[])))
);


--
-- Name: location_tax_overrides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_tax_overrides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    tax_rate_id uuid NOT NULL,
    override_rate numeric(5,2),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT location_tax_overrides_override_rate_check CHECK (((override_rate >= (0)::numeric) AND (override_rate <= (100)::numeric)))
);


--
-- Name: order_charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_charges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    charge_id uuid,
    charge_code character varying(50),
    charge_name character varying(100) NOT NULL,
    charge_type character varying(50) NOT NULL,
    calculation_type character varying(20) NOT NULL,
    base_amount numeric(15,2),
    charge_rate numeric(10,2),
    charge_amount numeric(15,2) NOT NULL,
    is_taxable boolean DEFAULT true,
    tax_amount numeric(15,2) DEFAULT 0,
    is_manual boolean DEFAULT false,
    original_amount numeric(15,2),
    adjustment_reason text,
    added_by uuid,
    removed_by uuid,
    is_removed boolean DEFAULT false,
    removed_at timestamp with time zone,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: order_discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_discounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    discount_id uuid NOT NULL,
    discount_name character varying(255) NOT NULL,
    discount_code character varying(50) NOT NULL,
    discount_type character varying(50) NOT NULL,
    applied_to character varying(50) NOT NULL,
    discount_percent numeric(5,2) DEFAULT 0,
    discount_amount numeric(15,2) DEFAULT 0,
    maximum_discount numeric(15,2) DEFAULT 0,
    applied_amount numeric(15,2) NOT NULL,
    minimum_purchase numeric(15,2) DEFAULT 0,
    minimum_quantity integer DEFAULT 0,
    applicable_categories jsonb DEFAULT '[]'::jsonb,
    applicable_products jsonb DEFAULT '[]'::jsonb,
    application_method character varying(20) DEFAULT 'auto'::character varying,
    coupon_code character varying(50),
    applied_by uuid,
    applied_by_name character varying(255),
    reason text,
    authorized_by uuid,
    applied_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    metadata jsonb
);


--
-- Name: order_item_charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_item_charges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_item_id uuid NOT NULL,
    charge_id uuid,
    charge_name character varying(100) NOT NULL,
    charge_type character varying(50) NOT NULL,
    quantity numeric(10,2) DEFAULT 1,
    unit_charge numeric(10,2),
    total_charge numeric(15,2) NOT NULL,
    is_manual boolean DEFAULT false,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    variation_id uuid NOT NULL,
    product_name character varying(255) NOT NULL,
    variation_name character varying(255) NOT NULL,
    product_code character varying(50),
    sku character varying(100),
    unit_of_measure character varying(50),
    quantity numeric(10,3) DEFAULT 1 NOT NULL,
    unit_price numeric(15,2) NOT NULL,
    modifiers_price numeric(15,2) DEFAULT 0,
    modifiers jsonb DEFAULT '[]'::jsonb,
    special_instructions text,
    discount_amount numeric(15,2) DEFAULT 0,
    discount_percent numeric(5,2) DEFAULT 0,
    discount_reason text,
    applied_discount_id uuid,
    tax_rate numeric(5,2) DEFAULT 0,
    tax_amount numeric(15,2) DEFAULT 0,
    tax_group_id uuid,
    tax_group_name character varying(100),
    subtotal numeric(15,2) NOT NULL,
    total numeric(15,2) NOT NULL,
    skip_kot boolean DEFAULT false,
    kot_printed boolean DEFAULT false,
    kot_printed_at timestamp with time zone,
    kot_number character varying(50),
    preparation_status character varying(20) DEFAULT 'pending'::character varying,
    prepared_at timestamp with time zone,
    prepared_by uuid,
    station character varying(100),
    served_at timestamp with time zone,
    served_by uuid,
    is_voided boolean DEFAULT false,
    voided_at timestamp with time zone,
    voided_by uuid,
    void_reason text,
    is_complimentary boolean DEFAULT false,
    complimentary_reason text,
    is_returned boolean DEFAULT false,
    returned_quantity numeric(10,3) DEFAULT 0,
    returned_at timestamp with time zone,
    return_reason text,
    refunded_amount numeric(15,2) DEFAULT 0,
    display_order integer DEFAULT 0,
    category character varying(100),
    category_id uuid,
    item_notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_preparation_status CHECK (((preparation_status)::text = ANY ((ARRAY['pending'::character varying, 'preparing'::character varying, 'ready'::character varying, 'served'::character varying])::text[])))
);


--
-- Name: order_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    payment_method_id uuid NOT NULL,
    payment_method_name character varying(100) NOT NULL,
    payment_method_code character varying(50) NOT NULL,
    amount numeric(15,2) NOT NULL,
    tip_amount numeric(15,2) DEFAULT 0,
    processing_fee numeric(15,2) DEFAULT 0,
    total_amount numeric(15,2) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    reference_number character varying(100),
    transaction_id character varying(255),
    approval_code character varying(50),
    card_last_four character varying(4),
    card_type character varying(20),
    paid_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    refunded_at timestamp with time zone,
    refunded_amount numeric(15,2) DEFAULT 0,
    refund_reason text,
    refunded_by uuid,
    refund_transaction_id character varying(255),
    processed_by uuid NOT NULL,
    processed_by_name character varying(255),
    notes text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_payment_status CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'completed'::character varying, 'failed'::character varying, 'refunded'::character varying])::text[])))
);


--
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_status_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_id uuid NOT NULL,
    from_status character varying(20) NOT NULL,
    to_status character varying(20) NOT NULL,
    changed_by uuid NOT NULL,
    changed_by_name character varying(255) NOT NULL,
    changed_by_role character varying(50),
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reason text,
    notes text,
    device_id uuid,
    ip_address inet,
    metadata jsonb
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    order_number character varying(50) NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    pos_device_id uuid,
    order_type character varying(20) DEFAULT 'dine_in'::character varying NOT NULL,
    order_source character varying(20) DEFAULT 'pos'::character varying NOT NULL,
    table_id uuid,
    table_name character varying(100),
    customer_id uuid NOT NULL,
    customer_name character varying(255) NOT NULL,
    customer_phone character varying(20),
    customer_email character varying(255),
    delivery_address_line1 character varying(255),
    delivery_address_line2 character varying(255),
    delivery_city character varying(100),
    delivery_postal_code character varying(20),
    delivery_phone character varying(20),
    delivery_instructions text,
    ordered_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    confirmed_at timestamp with time zone,
    prepared_at timestamp with time zone,
    ready_at timestamp with time zone,
    served_at timestamp with time zone,
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    estimated_ready_time timestamp with time zone,
    subtotal numeric(15,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(15,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(15,2) DEFAULT 0 NOT NULL,
    delivery_charge numeric(15,2) DEFAULT 0,
    service_charge numeric(15,2) DEFAULT 0,
    tip_amount numeric(15,2) DEFAULT 0,
    round_off_amount numeric(5,2) DEFAULT 0,
    total numeric(15,2) NOT NULL,
    payment_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    total_paid numeric(15,2) DEFAULT 0 NOT NULL,
    change_amount numeric(15,2) DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying NOT NULL,
    kitchen_status character varying(20),
    created_by uuid NOT NULL,
    created_by_name character varying(255),
    served_by uuid,
    served_by_name character varying(255),
    customer_notes text,
    kitchen_notes text,
    internal_notes text,
    cancellation_reason text,
    token_number character varying(20),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_synced_at timestamp with time zone,
    is_priority boolean DEFAULT false,
    is_void boolean DEFAULT false,
    void_reason text,
    voided_at timestamp with time zone,
    voided_by uuid,
    preparation_time_minutes integer,
    service_time_minutes integer,
    total_time_minutes integer,
    charges_amount numeric(10,2) DEFAULT 0.0,
    is_draft boolean DEFAULT false,
    kot_printed_at timestamp with time zone,
    bill_printed_at timestamp with time zone,
    price_category_name character varying(100),
    CONSTRAINT check_order_source CHECK (((order_source)::text = ANY ((ARRAY['pos'::character varying, 'online'::character varying, 'phone'::character varying])::text[]))),
    CONSTRAINT check_order_status CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'confirmed'::character varying, 'preparing'::character varying, 'ready'::character varying, 'served'::character varying, 'picked'::character varying, 'completed'::character varying, 'cancelled'::character varying, 'refunded'::character varying])::text[]))),
    CONSTRAINT check_order_type CHECK (((order_type)::text = ANY ((ARRAY['dineIn'::character varying, 'takeaway'::character varying, 'delivery'::character varying, 'online'::character varying, 'dine_in'::character varying, 'take_away'::character varying])::text[]))),
    CONSTRAINT check_payment_status CHECK (((payment_status)::text = ANY ((ARRAY['pending'::character varying, 'partial'::character varying, 'paid'::character varying, 'refunded'::character varying])::text[])))
);


--
-- Name: COLUMN orders.pos_device_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.pos_device_id IS 'POS device where payment was processed. NULL for orders created by waiters before payment.';


--
-- Name: COLUMN orders.charges_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.charges_amount IS 'Total amount of charges applied to the order';


--
-- Name: COLUMN orders.is_draft; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.is_draft IS 'Whether this order is saved as draft (not sent to kitchen)';


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    icon character varying(50),
    is_active boolean DEFAULT true,
    is_default boolean DEFAULT false,
    requires_reference boolean DEFAULT false,
    requires_approval boolean DEFAULT false,
    display_order integer DEFAULT 0,
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid
);


--
-- Name: pos_devices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pos_devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    device_name character varying(100) NOT NULL,
    device_code character varying(20) NOT NULL,
    device_type character varying(20) DEFAULT 'terminal'::character varying,
    is_default boolean DEFAULT false,
    is_active boolean DEFAULT true,
    last_sync_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    description text
);


--
-- Name: price_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.price_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    is_active boolean DEFAULT true,
    is_visible boolean DEFAULT true,
    display_order integer DEFAULT 0,
    icon_name character varying(50),
    color_hex character varying(7),
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    CONSTRAINT price_categories_type_check CHECK (((type)::text = ANY ((ARRAY['dine_in'::character varying, 'takeaway'::character varying, 'delivery'::character varying, 'catering'::character varying, 'custom'::character varying])::text[])))
);


--
-- Name: TABLE price_categories; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.price_categories IS 'Stores different pricing categories like Dine-In, Parcel, Delivery for flexible pricing';


--
-- Name: product_brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    logo_url text,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false
);


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    name_in_alternate_language character varying(255),
    description text,
    image_url text,
    icon_name character varying(100),
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    parent_category_id uuid,
    default_kot_printer_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false
);


--
-- Name: product_image_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_image_metadata (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    business_id uuid NOT NULL,
    image_type character varying(20) NOT NULL,
    storage_path text NOT NULL,
    file_name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: product_stock; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_stock (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_variation_id uuid NOT NULL,
    location_id uuid NOT NULL,
    current_stock numeric(12,3) DEFAULT 0,
    reserved_stock numeric(12,3) DEFAULT 0,
    alert_quantity numeric(12,3) DEFAULT 10,
    last_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false
);


--
-- Name: product_taxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_taxes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    tax_group_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE product_taxes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.product_taxes IS 'Product-specific tax assignments';


--
-- Name: product_variation_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variation_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    variation_id uuid NOT NULL,
    price_category_id uuid NOT NULL,
    price numeric(10,2) NOT NULL,
    cost numeric(10,2),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    CONSTRAINT product_variation_prices_cost_check CHECK ((cost >= (0)::numeric)),
    CONSTRAINT product_variation_prices_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: TABLE product_variation_prices; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.product_variation_prices IS 'Stores price overrides for product variations per price category (Dine-In, Parcel, Delivery, etc.)';


--
-- Name: product_variations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    sku character varying(100),
    mrp numeric(12,2) NOT NULL,
    selling_price numeric(12,2) NOT NULL,
    purchase_price numeric(12,2),
    barcode character varying(100),
    is_default boolean DEFAULT false,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    is_for_sale boolean DEFAULT true,
    is_for_purchase boolean DEFAULT false,
    cost numeric(10,2) DEFAULT 0,
    price numeric(10,2) DEFAULT 0,
    compare_at_price numeric(10,2),
    track_inventory boolean DEFAULT false,
    inventory_quantity integer DEFAULT 0,
    low_stock_alert_quantity integer DEFAULT 10,
    weight numeric(10,3),
    weight_unit character varying(10)
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    name_in_alternate_language character varying(255),
    description text,
    description_in_alternate_language text,
    category_id uuid NOT NULL,
    brand_id uuid,
    image_url text,
    additional_image_urls text[],
    unit_of_measure character varying(50) DEFAULT 'count'::character varying,
    barcode character varying(100),
    hsn character varying(50),
    tax_rate numeric(5,2) DEFAULT 0.0,
    short_code character varying(50),
    tags text[],
    product_type character varying(50) DEFAULT 'physical'::character varying,
    track_inventory boolean DEFAULT true,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    available_in_pos boolean DEFAULT true,
    available_in_online_store boolean DEFAULT false,
    available_in_catalog boolean DEFAULT true,
    skip_kot boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_synced_at timestamp with time zone,
    has_unsynced_changes boolean DEFAULT false,
    tax_group_id text,
    tax_rate_id text
);


--
-- Name: COLUMN products.additional_image_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.additional_image_urls IS 'Array of additional product image URLs stored as JSON';


--
-- Name: COLUMN products.tax_group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.tax_group_id IS 'Deprecated - use tax_rate_id instead. References the tax group for backward compatibility.';


--
-- Name: COLUMN products.tax_rate_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.tax_rate_id IS 'References the specific tax rate to apply to this product.';


--
-- Name: role_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_code text NOT NULL,
    role_name text NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    description text,
    is_system_role boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: sell_screen_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sell_screen_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    show_on_hold_tab boolean DEFAULT true,
    show_settlement_tab boolean DEFAULT true,
    default_price_category_id uuid,
    product_view_mode character varying(20) DEFAULT 'grid'::character varying,
    grid_columns integer DEFAULT 4,
    show_quick_sale boolean DEFAULT true,
    show_add_expense boolean DEFAULT false,
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sell_screen_preferences_grid_columns_check CHECK (((grid_columns >= 2) AND (grid_columns <= 8))),
    CONSTRAINT sell_screen_preferences_product_view_mode_check CHECK (((product_view_mode)::text = ANY ((ARRAY['grid'::character varying, 'list'::character varying])::text[])))
);


--
-- Name: TABLE sell_screen_preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.sell_screen_preferences IS 'User preferences for the sell/POS screen interface';


--
-- Name: subscription_analytics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    active_users integer DEFAULT 0,
    transactions_count integer DEFAULT 0,
    storage_used_mb integer DEFAULT 0,
    features_used jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: subscription_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subscription_id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) NOT NULL,
    payment_method character varying NOT NULL,
    payment_reference character varying,
    payment_date timestamp without time zone DEFAULT now() NOT NULL,
    verified_by uuid,
    notes text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: subscription_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    duration_months integer NOT NULL,
    price_inr numeric(10,2) NOT NULL,
    price_sar numeric(10,2) NOT NULL,
    price_aed numeric(10,2) NOT NULL,
    features jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: table_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.table_areas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    layout_config jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE table_areas; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.table_areas IS 'Different areas/floors for organizing tables in a restaurant';


--
-- Name: table_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.table_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    table_id uuid NOT NULL,
    order_id uuid NOT NULL,
    is_active boolean DEFAULT true,
    is_printed_kot boolean DEFAULT false,
    is_printed_bill boolean DEFAULT false,
    kot_printed_at timestamp with time zone,
    bill_printed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE table_orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.table_orders IS 'Tracks relationship between restaurant tables and orders, supporting multiple orders per table';


--
-- Name: COLUMN table_orders.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.table_orders.is_active IS 'Whether this order is currently active for the table';


--
-- Name: COLUMN table_orders.is_printed_kot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.table_orders.is_printed_kot IS 'Whether KOT has been printed for this order';


--
-- Name: COLUMN table_orders.is_printed_bill; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.table_orders.is_printed_bill IS 'Whether bill has been printed for this order';


--
-- Name: table_price_overrides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.table_price_overrides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    table_id uuid NOT NULL,
    variation_id uuid NOT NULL,
    price numeric(10,2) NOT NULL,
    is_active boolean DEFAULT true,
    valid_from timestamp with time zone,
    valid_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    CONSTRAINT table_price_overrides_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: TABLE table_price_overrides; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.table_price_overrides IS 'Table-specific price overrides for special pricing per table';


--
-- Name: tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    area_id uuid NOT NULL,
    business_id uuid NOT NULL,
    location_id uuid NOT NULL,
    table_number character varying(50) NOT NULL,
    display_name character varying(100),
    capacity integer DEFAULT 4,
    status character varying(50) DEFAULT 'free'::character varying,
    current_order_id uuid,
    position_x integer DEFAULT 0,
    position_y integer DEFAULT 0,
    width integer DEFAULT 100,
    height integer DEFAULT 100,
    shape character varying(20) DEFAULT 'rectangle'::character varying,
    is_active boolean DEFAULT true,
    is_bookable boolean DEFAULT true,
    settings jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_occupied_at timestamp with time zone,
    last_cleared_at timestamp with time zone,
    active_order_ids uuid[] DEFAULT '{}'::uuid[],
    total_active_amount numeric(10,2) DEFAULT 0,
    occupied_at timestamp with time zone,
    current_amount numeric(10,2),
    CONSTRAINT tables_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT tables_shape_check CHECK (((shape)::text = ANY ((ARRAY['rectangle'::character varying, 'circle'::character varying, 'square'::character varying])::text[]))),
    CONSTRAINT tables_status_check CHECK (((status)::text = ANY ((ARRAY['free'::character varying, 'occupied'::character varying, 'billed'::character varying, 'blocked'::character varying, 'reserved'::character varying, 'cleaning'::character varying])::text[])))
);


--
-- Name: TABLE tables; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.tables IS 'Individual tables/rooms in a restaurant with status tracking';


--
-- Name: tax_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_groups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_default boolean DEFAULT false,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE tax_groups; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.tax_groups IS 'Tax groups like GST, VAT, Service Tax';


--
-- Name: tax_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tax_rates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tax_group_id uuid NOT NULL,
    business_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    rate numeric(5,2) NOT NULL,
    type character varying(20) DEFAULT 'percentage'::character varying,
    calculation_method character varying(20) DEFAULT 'exclusive'::character varying,
    apply_on character varying(20) DEFAULT 'base_price'::character varying,
    parent_tax_id uuid,
    is_active boolean DEFAULT true,
    display_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT tax_rates_apply_on_check CHECK (((apply_on)::text = ANY ((ARRAY['base_price'::character varying, 'after_discount'::character varying, 'after_tax'::character varying])::text[]))),
    CONSTRAINT tax_rates_calculation_method_check CHECK (((calculation_method)::text = ANY ((ARRAY['exclusive'::character varying, 'inclusive'::character varying])::text[]))),
    CONSTRAINT tax_rates_rate_check CHECK (((rate >= (0)::numeric) AND (rate <= (100)::numeric))),
    CONSTRAINT tax_rates_type_check CHECK (((type)::text = ANY ((ARRAY['percentage'::character varying, 'fixed'::character varying])::text[])))
);


--
-- Name: TABLE tax_rates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.tax_rates IS 'Individual tax rates within tax groups';


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: messages_2025_09_11; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_11 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_12; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_12 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_13; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_13 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_14; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_14 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_15; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_16; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: messages_2025_09_17; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages_2025_09_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- Name: messages_2025_09_11; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_11 FOR VALUES FROM ('2025-09-11 00:00:00') TO ('2025-09-12 00:00:00');


--
-- Name: messages_2025_09_12; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_12 FOR VALUES FROM ('2025-09-12 00:00:00') TO ('2025-09-13 00:00:00');


--
-- Name: messages_2025_09_13; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_13 FOR VALUES FROM ('2025-09-13 00:00:00') TO ('2025-09-14 00:00:00');


--
-- Name: messages_2025_09_14; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_14 FOR VALUES FROM ('2025-09-14 00:00:00') TO ('2025-09-15 00:00:00');


--
-- Name: messages_2025_09_15; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_15 FOR VALUES FROM ('2025-09-15 00:00:00') TO ('2025-09-16 00:00:00');


--
-- Name: messages_2025_09_16; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_16 FOR VALUES FROM ('2025-09-16 00:00:00') TO ('2025-09-17 00:00:00');


--
-- Name: messages_2025_09_17; Type: TABLE ATTACH; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_09_17 FOR VALUES FROM ('2025-09-17 00:00:00') TO ('2025-09-18 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_client_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_client_id_key UNIQUE (client_id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: business_locations business_locations_name_business_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_locations
    ADD CONSTRAINT business_locations_name_business_unique UNIQUE (business_id, name) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: business_locations business_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_locations
    ADD CONSTRAINT business_locations_pkey PRIMARY KEY (id);


--
-- Name: business_subscriptions business_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_subscriptions
    ADD CONSTRAINT business_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: category_taxes category_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_taxes
    ADD CONSTRAINT category_taxes_pkey PRIMARY KEY (id);


--
-- Name: charge_formulas charge_formulas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_formulas
    ADD CONSTRAINT charge_formulas_pkey PRIMARY KEY (id);


--
-- Name: charge_tiers charge_tiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_tiers
    ADD CONSTRAINT charge_tiers_pkey PRIMARY KEY (id);


--
-- Name: charge_usage_analytics charge_usage_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_usage_analytics
    ADD CONSTRAINT charge_usage_analytics_pkey PRIMARY KEY (id);


--
-- Name: charges charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT charges_pkey PRIMARY KEY (id);


--
-- Name: customer_charge_exemptions customer_charge_exemptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT customer_charge_exemptions_pkey PRIMARY KEY (id);


--
-- Name: customer_communications customer_communications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_communications
    ADD CONSTRAINT customer_communications_pkey PRIMARY KEY (id);


--
-- Name: customer_contacts customer_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_contacts
    ADD CONSTRAINT customer_contacts_pkey PRIMARY KEY (id);


--
-- Name: customer_documents customer_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_pkey PRIMARY KEY (id);


--
-- Name: customer_groups customer_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_groups
    ADD CONSTRAINT customer_groups_pkey PRIMARY KEY (id);


--
-- Name: customer_transactions customer_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: discount_categories discount_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_categories
    ADD CONSTRAINT discount_categories_pkey PRIMARY KEY (id);


--
-- Name: discount_customer_groups discount_customer_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_customer_groups
    ADD CONSTRAINT discount_customer_groups_pkey PRIMARY KEY (id);


--
-- Name: discount_products discount_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT discount_products_pkey PRIMARY KEY (id);


--
-- Name: discount_rules discount_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_rules
    ADD CONSTRAINT discount_rules_pkey PRIMARY KEY (id);


--
-- Name: discount_usage_history discount_usage_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage_history
    ADD CONSTRAINT discount_usage_history_pkey PRIMARY KEY (id);


--
-- Name: employee_audit_log employee_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_pkey PRIMARY KEY (id);


--
-- Name: employee_business_lookup employee_business_lookup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_business_lookup
    ADD CONSTRAINT employee_business_lookup_pkey PRIMARY KEY (user_id, business_id);


--
-- Name: employee_sessions employee_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_sessions
    ADD CONSTRAINT employee_sessions_pkey PRIMARY KEY (id);


--
-- Name: employee_sessions employee_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_sessions
    ADD CONSTRAINT employee_sessions_session_token_key UNIQUE (session_token);


--
-- Name: employees employees_business_id_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_business_id_employee_code_key UNIQUE (business_id, employee_code);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees employees_user_id_business_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_business_id_key UNIQUE (user_id, business_id);


--
-- Name: kot_item_routing kot_item_routing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_pkey PRIMARY KEY (id);


--
-- Name: kot_printer_stations kot_printer_stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT kot_printer_stations_pkey PRIMARY KEY (id);


--
-- Name: kot_printers kot_printers_location_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printers
    ADD CONSTRAINT kot_printers_location_id_name_key UNIQUE (location_id, name);


--
-- Name: kot_printers kot_printers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printers
    ADD CONSTRAINT kot_printers_pkey PRIMARY KEY (id);


--
-- Name: kot_routing_rules kot_routing_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_routing_rules
    ADD CONSTRAINT kot_routing_rules_pkey PRIMARY KEY (id);


--
-- Name: kot_stations kot_stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_stations
    ADD CONSTRAINT kot_stations_pkey PRIMARY KEY (id);


--
-- Name: kot_templates kot_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_templates
    ADD CONSTRAINT kot_templates_pkey PRIMARY KEY (id);


--
-- Name: location_tax_overrides location_tax_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_tax_overrides
    ADD CONSTRAINT location_tax_overrides_pkey PRIMARY KEY (id);


--
-- Name: order_charges order_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_charges
    ADD CONSTRAINT order_charges_pkey PRIMARY KEY (id);


--
-- Name: order_discounts order_discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_discounts
    ADD CONSTRAINT order_discounts_pkey PRIMARY KEY (id);


--
-- Name: order_item_charges order_item_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item_charges
    ADD CONSTRAINT order_item_charges_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: order_payments order_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_pkey PRIMARY KEY (id);


--
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: pos_devices pos_devices_location_device_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_devices
    ADD CONSTRAINT pos_devices_location_device_code_unique UNIQUE (location_id, device_code) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pos_devices pos_devices_name_location_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_devices
    ADD CONSTRAINT pos_devices_name_location_unique UNIQUE (location_id, device_name) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pos_devices pos_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_devices
    ADD CONSTRAINT pos_devices_pkey PRIMARY KEY (id);


--
-- Name: price_categories price_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_categories
    ADD CONSTRAINT price_categories_pkey PRIMARY KEY (id);


--
-- Name: product_brands product_brands_business_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_brands
    ADD CONSTRAINT product_brands_business_id_name_key UNIQUE (business_id, name);


--
-- Name: product_brands product_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_brands
    ADD CONSTRAINT product_brands_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_business_id_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_business_id_name_key UNIQUE (business_id, name);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_image_metadata product_image_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image_metadata
    ADD CONSTRAINT product_image_metadata_pkey PRIMARY KEY (id);


--
-- Name: product_stock product_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pkey PRIMARY KEY (id);


--
-- Name: product_stock product_stock_product_variation_id_location_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_product_variation_id_location_id_key UNIQUE (product_variation_id, location_id);


--
-- Name: product_taxes product_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_taxes
    ADD CONSTRAINT product_taxes_pkey PRIMARY KEY (id);


--
-- Name: product_variation_prices product_variation_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variation_prices
    ADD CONSTRAINT product_variation_prices_pkey PRIMARY KEY (id);


--
-- Name: product_variations product_variations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: role_templates role_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_templates
    ADD CONSTRAINT role_templates_pkey PRIMARY KEY (id);


--
-- Name: role_templates role_templates_role_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_templates
    ADD CONSTRAINT role_templates_role_code_key UNIQUE (role_code);


--
-- Name: sell_screen_preferences sell_screen_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sell_screen_preferences
    ADD CONSTRAINT sell_screen_preferences_pkey PRIMARY KEY (id);


--
-- Name: subscription_analytics subscription_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_analytics
    ADD CONSTRAINT subscription_analytics_pkey PRIMARY KEY (id);


--
-- Name: subscription_payments subscription_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_payments
    ADD CONSTRAINT subscription_payments_pkey PRIMARY KEY (id);


--
-- Name: subscription_plans subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_plans
    ADD CONSTRAINT subscription_plans_pkey PRIMARY KEY (id);


--
-- Name: table_areas table_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_areas
    ADD CONSTRAINT table_areas_pkey PRIMARY KEY (id);


--
-- Name: table_orders table_orders_order_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_order_id_key UNIQUE (order_id);


--
-- Name: table_orders table_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_pkey PRIMARY KEY (id);


--
-- Name: table_price_overrides table_price_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_price_overrides
    ADD CONSTRAINT table_price_overrides_pkey PRIMARY KEY (id);


--
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- Name: tax_groups tax_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_groups
    ADD CONSTRAINT tax_groups_pkey PRIMARY KEY (id);


--
-- Name: tax_rates tax_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rates
    ADD CONSTRAINT tax_rates_pkey PRIMARY KEY (id);


--
-- Name: table_areas unique_area_name_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_areas
    ADD CONSTRAINT unique_area_name_per_location UNIQUE (business_id, location_id, name);


--
-- Name: category_taxes unique_category_tax; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_taxes
    ADD CONSTRAINT unique_category_tax UNIQUE (category_id, tax_group_id);


--
-- Name: charges unique_charge_code_per_business; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT unique_charge_code_per_business UNIQUE (business_id, code);


--
-- Name: charge_tiers unique_charge_tier_range; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_tiers
    ADD CONSTRAINT unique_charge_tier_range UNIQUE (charge_id, min_value);


--
-- Name: charge_usage_analytics unique_charge_usage_per_day; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_usage_analytics
    ADD CONSTRAINT unique_charge_usage_per_day UNIQUE (charge_id, location_id, usage_date);


--
-- Name: customer_charge_exemptions unique_customer_charge_exemption; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT unique_customer_charge_exemption UNIQUE (customer_id, charge_id);


--
-- Name: customers unique_customer_code_per_business; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_customer_code_per_business UNIQUE (business_id, customer_code);


--
-- Name: customers unique_customer_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_customer_email UNIQUE (business_id, email);


--
-- Name: customer_groups unique_customer_group_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_groups
    ADD CONSTRAINT unique_customer_group_code UNIQUE (business_id, code);


--
-- Name: customers unique_customer_phone; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT unique_customer_phone UNIQUE (business_id, phone);


--
-- Name: pos_devices unique_default_device_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_devices
    ADD CONSTRAINT unique_default_device_per_location EXCLUDE USING btree (location_id WITH =) WHERE (((is_default = true) AND (is_active = true)));


--
-- Name: business_locations unique_default_location_per_business; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_locations
    ADD CONSTRAINT unique_default_location_per_business EXCLUDE USING btree (business_id WITH =) WHERE (((is_default = true) AND (is_active = true)));


--
-- Name: discount_categories unique_discount_category; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_categories
    ADD CONSTRAINT unique_discount_category UNIQUE (discount_rule_id, category_id);


--
-- Name: discount_rules unique_discount_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_rules
    ADD CONSTRAINT unique_discount_code UNIQUE (business_id, code);


--
-- Name: discount_products unique_discount_product; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT unique_discount_product UNIQUE (discount_rule_id, product_id);


--
-- Name: location_tax_overrides unique_location_tax_override; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_tax_overrides
    ADD CONSTRAINT unique_location_tax_override UNIQUE (location_id, tax_rate_id);


--
-- Name: orders unique_order_number_per_business; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT unique_order_number_per_business UNIQUE (business_id, order_number);


--
-- Name: payment_methods unique_payment_method_code; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT unique_payment_method_code UNIQUE (business_id, code);


--
-- Name: sell_screen_preferences unique_preferences_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sell_screen_preferences
    ADD CONSTRAINT unique_preferences_per_location UNIQUE (business_id, location_id);


--
-- Name: price_categories unique_price_category_name_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_categories
    ADD CONSTRAINT unique_price_category_name_per_location UNIQUE (business_id, location_id, name);


--
-- Name: kot_printer_stations unique_printer_station_mapping; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT unique_printer_station_mapping UNIQUE (printer_id, station_id);


--
-- Name: product_taxes unique_product_tax; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_taxes
    ADD CONSTRAINT unique_product_tax UNIQUE (product_id, tax_group_id);


--
-- Name: kot_stations unique_station_name_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_stations
    ADD CONSTRAINT unique_station_name_per_location UNIQUE (business_id, location_id, name);


--
-- Name: tables unique_table_number_per_area; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT unique_table_number_per_area UNIQUE (area_id, table_number);


--
-- Name: table_price_overrides unique_table_variation_price; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_price_overrides
    ADD CONSTRAINT unique_table_variation_price UNIQUE (table_id, variation_id);


--
-- Name: tax_groups unique_tax_group_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_groups
    ADD CONSTRAINT unique_tax_group_name UNIQUE (business_id, name);


--
-- Name: tax_rates unique_tax_rate_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rates
    ADD CONSTRAINT unique_tax_rate_name UNIQUE (business_id, name);


--
-- Name: kot_templates unique_template_name_per_location; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_templates
    ADD CONSTRAINT unique_template_name_per_location UNIQUE (business_id, location_id, name, type);


--
-- Name: product_variation_prices unique_variation_price_category; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variation_prices
    ADD CONSTRAINT unique_variation_price_category UNIQUE (variation_id, price_category_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_11 messages_2025_09_11_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_11
    ADD CONSTRAINT messages_2025_09_11_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_12 messages_2025_09_12_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_12
    ADD CONSTRAINT messages_2025_09_12_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_13 messages_2025_09_13_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_13
    ADD CONSTRAINT messages_2025_09_13_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_14 messages_2025_09_14_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_14
    ADD CONSTRAINT messages_2025_09_14_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_15 messages_2025_09_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_15
    ADD CONSTRAINT messages_2025_09_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_16 messages_2025_09_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_16
    ADD CONSTRAINT messages_2025_09_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_09_17 messages_2025_09_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages_2025_09_17
    ADD CONSTRAINT messages_2025_09_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_clients_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_client_id_idx ON auth.oauth_clients USING btree (client_id);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_business_locations_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_locations_business_id ON public.business_locations USING btree (business_id);


--
-- Name: idx_business_locations_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_locations_created_at ON public.business_locations USING btree (created_at);


--
-- Name: idx_business_locations_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_locations_is_active ON public.business_locations USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_business_locations_is_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_locations_is_default ON public.business_locations USING btree (is_default) WHERE (is_default = true);


--
-- Name: idx_business_subscriptions_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_subscriptions_business_id ON public.business_subscriptions USING btree (business_id);


--
-- Name: idx_business_subscriptions_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_subscriptions_created ON public.business_subscriptions USING btree (created_at DESC);


--
-- Name: idx_business_subscriptions_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_subscriptions_end_date ON public.business_subscriptions USING btree (subscription_end_date);


--
-- Name: idx_business_subscriptions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_business_subscriptions_status ON public.business_subscriptions USING btree (status);


--
-- Name: idx_businesses_active_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_businesses_active_created ON public.businesses USING btree (is_active, created_at DESC);


--
-- Name: idx_businesses_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_businesses_created_at ON public.businesses USING btree (created_at);


--
-- Name: idx_businesses_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_businesses_is_active ON public.businesses USING btree (is_active);


--
-- Name: idx_businesses_name_owner_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_businesses_name_owner_unique ON public.businesses USING btree (name, owner_id) WHERE (is_active = true);


--
-- Name: idx_businesses_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_businesses_owner_id ON public.businesses USING btree (owner_id);


--
-- Name: idx_category_taxes_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_category_taxes_category ON public.category_taxes USING btree (category_id);


--
-- Name: idx_charge_analytics_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charge_analytics_charge ON public.charge_usage_analytics USING btree (charge_id);


--
-- Name: idx_charge_analytics_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charge_analytics_date ON public.charge_usage_analytics USING btree (usage_date);


--
-- Name: idx_charge_formulas_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charge_formulas_charge ON public.charge_formulas USING btree (charge_id);


--
-- Name: idx_charge_tiers_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charge_tiers_charge ON public.charge_tiers USING btree (charge_id);


--
-- Name: idx_charges_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charges_active ON public.charges USING btree (is_active);


--
-- Name: idx_charges_auto_apply; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charges_auto_apply ON public.charges USING btree (auto_apply);


--
-- Name: idx_charges_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charges_business ON public.charges USING btree (business_id);


--
-- Name: idx_charges_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charges_location ON public.charges USING btree (location_id);


--
-- Name: idx_charges_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_charges_type ON public.charges USING btree (charge_type);


--
-- Name: idx_customer_communications_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_communications_customer ON public.customer_communications USING btree (customer_id);


--
-- Name: idx_customer_contacts_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_contacts_customer ON public.customer_contacts USING btree (customer_id);


--
-- Name: idx_customer_documents_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_documents_customer ON public.customer_documents USING btree (customer_id);


--
-- Name: idx_customer_exemptions_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_exemptions_charge ON public.customer_charge_exemptions USING btree (charge_id);


--
-- Name: idx_customer_exemptions_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_exemptions_customer ON public.customer_charge_exemptions USING btree (customer_id);


--
-- Name: idx_customer_groups_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_groups_business ON public.customer_groups USING btree (business_id);


--
-- Name: idx_customer_transactions_cheque_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_transactions_cheque_status ON public.customer_transactions USING btree (cheque_status);


--
-- Name: idx_customer_transactions_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_transactions_customer ON public.customer_transactions USING btree (customer_id);


--
-- Name: idx_customer_transactions_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_transactions_date ON public.customer_transactions USING btree (transaction_date);


--
-- Name: idx_customer_transactions_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customer_transactions_type ON public.customer_transactions USING btree (transaction_type);


--
-- Name: idx_customers_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_active ON public.customers USING btree (is_active);


--
-- Name: idx_customers_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_business ON public.customers USING btree (business_id);


--
-- Name: idx_customers_business_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_business_code ON public.customers USING btree (business_id, customer_code);


--
-- Name: idx_customers_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_code ON public.customers USING btree (customer_code);


--
-- Name: idx_customers_credit_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_credit_status ON public.customers USING btree (credit_status);


--
-- Name: idx_customers_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_email ON public.customers USING btree (email);


--
-- Name: idx_customers_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_group ON public.customers USING btree (group_id);


--
-- Name: idx_customers_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_name ON public.customers USING btree (name);


--
-- Name: idx_customers_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_customers_phone ON public.customers USING btree (phone);


--
-- Name: idx_discount_categories; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_categories ON public.discount_categories USING btree (category_id);


--
-- Name: idx_discount_products; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_products ON public.discount_products USING btree (product_id);


--
-- Name: idx_discount_rules_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_rules_business ON public.discount_rules USING btree (business_id);


--
-- Name: idx_discount_rules_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_rules_code ON public.discount_rules USING btree (code) WHERE (code IS NOT NULL);


--
-- Name: idx_discount_rules_validity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_rules_validity ON public.discount_rules USING btree (valid_from, valid_until);


--
-- Name: idx_discount_usage_history; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_discount_usage_history ON public.discount_usage_history USING btree (discount_rule_id, customer_id);


--
-- Name: idx_employee_audit_log_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_audit_log_business ON public.employee_audit_log USING btree (business_id);


--
-- Name: idx_employee_audit_log_employee; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_audit_log_employee ON public.employee_audit_log USING btree (employee_id);


--
-- Name: idx_employee_business_lookup_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_business_lookup_business ON public.employee_business_lookup USING btree (business_id);


--
-- Name: idx_employee_business_lookup_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_business_lookup_user ON public.employee_business_lookup USING btree (user_id);


--
-- Name: idx_employee_sessions_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_sessions_active ON public.employee_sessions USING btree (employee_id, is_active);


--
-- Name: idx_employee_sessions_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employee_sessions_token ON public.employee_sessions USING btree (session_token);


--
-- Name: idx_employees_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_business ON public.employees USING btree (business_id);


--
-- Name: idx_employees_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_role ON public.employees USING btree (primary_role);


--
-- Name: idx_employees_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_status ON public.employees USING btree (employment_status);


--
-- Name: idx_employees_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_employees_user ON public.employees USING btree (user_id);


--
-- Name: idx_kot_item_routing_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_item_routing_business_location ON public.kot_item_routing USING btree (business_id, location_id);


--
-- Name: idx_kot_item_routing_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_item_routing_category ON public.kot_item_routing USING btree (category_id) WHERE (category_id IS NOT NULL);


--
-- Name: idx_kot_item_routing_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_item_routing_product ON public.kot_item_routing USING btree (product_id) WHERE (product_id IS NOT NULL);


--
-- Name: idx_kot_item_routing_station; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_item_routing_station ON public.kot_item_routing USING btree (station_id);


--
-- Name: idx_kot_item_routing_variation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_item_routing_variation ON public.kot_item_routing USING btree (variation_id) WHERE (variation_id IS NOT NULL);


--
-- Name: idx_kot_printer_stations_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_printer_stations_business_location ON public.kot_printer_stations USING btree (business_id, location_id);


--
-- Name: idx_kot_printers_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_printers_business_location ON public.kot_printers USING btree (business_id, location_id);


--
-- Name: idx_kot_routing_rules_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_routing_rules_product_id ON public.kot_routing_rules USING btree (product_id);


--
-- Name: idx_kot_stations_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_stations_business_location ON public.kot_stations USING btree (business_id, location_id);


--
-- Name: idx_kot_templates_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kot_templates_business_location ON public.kot_templates USING btree (business_id, location_id);


--
-- Name: idx_location_tax_overrides; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_location_tax_overrides ON public.location_tax_overrides USING btree (location_id);


--
-- Name: idx_order_charges_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_charges_charge ON public.order_charges USING btree (charge_id);


--
-- Name: idx_order_charges_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_charges_order ON public.order_charges USING btree (order_id);


--
-- Name: idx_order_discounts_discount_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_discounts_discount_id ON public.order_discounts USING btree (discount_id);


--
-- Name: idx_order_discounts_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_discounts_order_id ON public.order_discounts USING btree (order_id);


--
-- Name: idx_order_item_charges_charge; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_item_charges_charge ON public.order_item_charges USING btree (charge_id);


--
-- Name: idx_order_item_charges_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_item_charges_item ON public.order_item_charges USING btree (order_item_id);


--
-- Name: idx_order_items_kot_printed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_kot_printed ON public.order_items USING btree (kot_printed);


--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- Name: idx_order_items_preparation_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_preparation_status ON public.order_items USING btree (preparation_status);


--
-- Name: idx_order_items_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_product_id ON public.order_items USING btree (product_id);


--
-- Name: idx_order_payments_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_payments_order_id ON public.order_payments USING btree (order_id);


--
-- Name: idx_order_payments_payment_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_payments_payment_method_id ON public.order_payments USING btree (payment_method_id);


--
-- Name: idx_order_payments_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_payments_status ON public.order_payments USING btree (status);


--
-- Name: idx_order_status_history_changed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_status_history_changed_at ON public.order_status_history USING btree (changed_at DESC);


--
-- Name: idx_order_status_history_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_status_history_order_id ON public.order_status_history USING btree (order_id);


--
-- Name: idx_orders_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_business_id ON public.orders USING btree (business_id);


--
-- Name: idx_orders_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_customer_id ON public.orders USING btree (customer_id);


--
-- Name: idx_orders_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_location_id ON public.orders USING btree (location_id);


--
-- Name: idx_orders_order_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_order_number ON public.orders USING btree (order_number);


--
-- Name: idx_orders_ordered_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_ordered_at ON public.orders USING btree (ordered_at DESC);


--
-- Name: idx_orders_payment_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_payment_status ON public.orders USING btree (payment_status);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_table_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_table_id ON public.orders USING btree (table_id);


--
-- Name: idx_orders_token_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_token_number ON public.orders USING btree (token_number);


--
-- Name: idx_payment_methods_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_methods_active ON public.payment_methods USING btree (is_active);


--
-- Name: idx_payment_methods_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_methods_business ON public.payment_methods USING btree (business_id);


--
-- Name: idx_payment_methods_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_methods_code ON public.payment_methods USING btree (code);


--
-- Name: idx_pos_devices_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pos_devices_created_at ON public.pos_devices USING btree (created_at);


--
-- Name: idx_pos_devices_device_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pos_devices_device_code ON public.pos_devices USING btree (device_code);


--
-- Name: idx_pos_devices_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pos_devices_is_active ON public.pos_devices USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_pos_devices_is_default; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pos_devices_is_default ON public.pos_devices USING btree (is_default) WHERE (is_default = true);


--
-- Name: idx_pos_devices_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pos_devices_location_id ON public.pos_devices USING btree (location_id);


--
-- Name: idx_price_categories_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_price_categories_active ON public.price_categories USING btree (is_active, is_visible);


--
-- Name: idx_price_categories_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_price_categories_business_location ON public.price_categories USING btree (business_id, location_id);


--
-- Name: idx_product_stock_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_stock_location_id ON public.product_stock USING btree (location_id);


--
-- Name: idx_product_stock_variation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_stock_variation_id ON public.product_stock USING btree (product_variation_id);


--
-- Name: idx_product_taxes_product; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_taxes_product ON public.product_taxes USING btree (product_id);


--
-- Name: idx_product_variation_prices_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variation_prices_active ON public.product_variation_prices USING btree (is_active);


--
-- Name: idx_product_variation_prices_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variation_prices_category ON public.product_variation_prices USING btree (price_category_id);


--
-- Name: idx_product_variation_prices_price_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variation_prices_price_category_id ON public.product_variation_prices USING btree (price_category_id);


--
-- Name: idx_product_variation_prices_variation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variation_prices_variation ON public.product_variation_prices USING btree (variation_id);


--
-- Name: idx_product_variation_prices_variation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variation_prices_variation_id ON public.product_variation_prices USING btree (variation_id);


--
-- Name: idx_product_variations_barcode; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_product_variations_barcode ON public.product_variations USING btree (product_id, barcode) WHERE (barcode IS NOT NULL);


--
-- Name: idx_product_variations_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_product_variations_product_id ON public.product_variations USING btree (product_id);


--
-- Name: idx_product_variations_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_product_variations_sku ON public.product_variations USING btree (product_id, sku) WHERE (sku IS NOT NULL);


--
-- Name: idx_products_brand_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_brand_id ON public.products USING btree (brand_id);


--
-- Name: idx_products_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_business_id ON public.products USING btree (business_id);


--
-- Name: idx_products_business_short_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_products_business_short_code ON public.products USING btree (business_id, short_code) WHERE (short_code IS NOT NULL);


--
-- Name: idx_products_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_category_id ON public.products USING btree (category_id);


--
-- Name: idx_products_is_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_is_active ON public.products USING btree (is_active);


--
-- Name: idx_products_tax_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_tax_group_id ON public.products USING btree (tax_group_id);


--
-- Name: idx_products_tax_rate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_products_tax_rate_id ON public.products USING btree (tax_rate_id);


--
-- Name: idx_sell_screen_preferences_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sell_screen_preferences_location ON public.sell_screen_preferences USING btree (business_id, location_id);


--
-- Name: idx_subscription_analytics_business_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscription_analytics_business_date ON public.subscription_analytics USING btree (business_id, date);


--
-- Name: idx_subscription_payments_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscription_payments_created ON public.subscription_payments USING btree (created_at DESC);


--
-- Name: idx_subscription_payments_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscription_payments_date ON public.subscription_payments USING btree (payment_date);


--
-- Name: idx_subscription_payments_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_subscription_payments_subscription_id ON public.subscription_payments USING btree (subscription_id);


--
-- Name: idx_table_areas_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_areas_active ON public.table_areas USING btree (is_active);


--
-- Name: idx_table_areas_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_areas_business_id ON public.table_areas USING btree (business_id);


--
-- Name: idx_table_areas_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_areas_business_location ON public.table_areas USING btree (business_id, location_id);


--
-- Name: idx_table_orders_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_orders_active ON public.table_orders USING btree (table_id, is_active) WHERE (is_active = true);


--
-- Name: idx_table_orders_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_orders_business_location ON public.table_orders USING btree (business_id, location_id);


--
-- Name: idx_table_orders_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_orders_order_id ON public.table_orders USING btree (order_id);


--
-- Name: idx_table_orders_table_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_orders_table_id ON public.table_orders USING btree (table_id);


--
-- Name: idx_table_price_overrides_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_price_overrides_active ON public.table_price_overrides USING btree (is_active);


--
-- Name: idx_table_price_overrides_table; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_price_overrides_table ON public.table_price_overrides USING btree (table_id);


--
-- Name: idx_table_price_overrides_variation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_price_overrides_variation ON public.table_price_overrides USING btree (variation_id);


--
-- Name: idx_tables_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_active ON public.tables USING btree (is_active);


--
-- Name: idx_tables_area; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_area ON public.tables USING btree (area_id);


--
-- Name: idx_tables_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_business_id ON public.tables USING btree (business_id);


--
-- Name: idx_tables_business_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_business_location ON public.tables USING btree (business_id, location_id);


--
-- Name: idx_tables_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_location_id ON public.tables USING btree (location_id);


--
-- Name: idx_tables_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tables_status ON public.tables USING btree (status);


--
-- Name: idx_tax_groups_business; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tax_groups_business ON public.tax_groups USING btree (business_id);


--
-- Name: idx_tax_rates_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tax_rates_group ON public.tax_rates USING btree (tax_group_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: messages_2025_09_11_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_11_pkey;


--
-- Name: messages_2025_09_12_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_12_pkey;


--
-- Name: messages_2025_09_13_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_13_pkey;


--
-- Name: messages_2025_09_14_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_14_pkey;


--
-- Name: messages_2025_09_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_15_pkey;


--
-- Name: messages_2025_09_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_16_pkey;


--
-- Name: messages_2025_09_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: -
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_09_17_pkey;


--
-- Name: businesses create_payment_methods_on_business_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER create_payment_methods_on_business_insert AFTER INSERT ON public.businesses FOR EACH ROW EXECUTE FUNCTION public.on_business_created_payment_methods();


--
-- Name: kot_printers ensure_single_default_printer_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_single_default_printer_trigger BEFORE INSERT OR UPDATE ON public.kot_printers FOR EACH ROW WHEN ((new.is_default = true)) EXECUTE FUNCTION public.ensure_single_default_printer();


--
-- Name: kot_templates ensure_single_default_template_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ensure_single_default_template_trigger BEFORE INSERT OR UPDATE ON public.kot_templates FOR EACH ROW WHEN ((new.is_default = true)) EXECUTE FUNCTION public.ensure_single_default_template();


--
-- Name: businesses maintain_business_owner_lookup_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER maintain_business_owner_lookup_trigger AFTER INSERT OR DELETE OR UPDATE ON public.businesses FOR EACH ROW EXECUTE FUNCTION public.maintain_business_owner_lookup();


--
-- Name: employees maintain_employee_lookup_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER maintain_employee_lookup_trigger AFTER INSERT OR DELETE OR UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.maintain_employee_business_lookup();


--
-- Name: table_orders trigger_update_table_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_table_status AFTER INSERT OR DELETE OR UPDATE ON public.table_orders FOR EACH ROW EXECUTE FUNCTION public.update_table_status_from_orders();


--
-- Name: table_orders trigger_validate_table_order; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_validate_table_order BEFORE INSERT OR UPDATE ON public.table_orders FOR EACH ROW EXECUTE FUNCTION public.validate_table_order_business_location();


--
-- Name: business_locations update_business_locations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_business_locations_updated_at BEFORE UPDATE ON public.business_locations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: business_subscriptions update_business_subscriptions_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_business_subscriptions_updated_at BEFORE UPDATE ON public.business_subscriptions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: businesses update_businesses_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_businesses_updated_at BEFORE UPDATE ON public.businesses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: customer_transactions update_customer_metrics_on_transaction; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_customer_metrics_on_transaction AFTER INSERT ON public.customer_transactions FOR EACH ROW EXECUTE FUNCTION public.update_customer_purchase_metrics();


--
-- Name: discount_rules update_discount_rules_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_discount_rules_updated_at BEFORE UPDATE ON public.discount_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employees update_employees_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_item_routing update_kot_item_routing_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_item_routing_updated_at BEFORE UPDATE ON public.kot_item_routing FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_printer_stations update_kot_printer_stations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_printer_stations_updated_at BEFORE UPDATE ON public.kot_printer_stations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_printers update_kot_printers_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_printers_updated_at BEFORE UPDATE ON public.kot_printers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_routing_rules update_kot_routing_rules_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_routing_rules_updated_at BEFORE UPDATE ON public.kot_routing_rules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_stations update_kot_stations_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_stations_updated_at BEFORE UPDATE ON public.kot_stations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: kot_templates update_kot_templates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_kot_templates_updated_at BEFORE UPDATE ON public.kot_templates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: location_tax_overrides update_location_tax_overrides_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_location_tax_overrides_updated_at BEFORE UPDATE ON public.location_tax_overrides FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: order_items update_order_items_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_order_items_updated_at BEFORE UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: order_payments update_order_payments_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_order_payments_updated_at BEFORE UPDATE ON public.order_payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: orders update_orders_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: pos_devices update_pos_devices_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_pos_devices_updated_at BEFORE UPDATE ON public.pos_devices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: price_categories update_price_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_price_categories_updated_at BEFORE UPDATE ON public.price_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_brands update_product_brands_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_brands_updated_at BEFORE UPDATE ON public.product_brands FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_categories update_product_categories_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_categories_updated_at BEFORE UPDATE ON public.product_categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_variation_prices update_product_variation_prices_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_product_variation_prices_updated_at BEFORE UPDATE ON public.product_variation_prices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: sell_screen_preferences update_sell_screen_preferences_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_sell_screen_preferences_updated_at BEFORE UPDATE ON public.sell_screen_preferences FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription_plans update_subscription_plans_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON public.subscription_plans FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: table_areas update_table_areas_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_table_areas_updated_at BEFORE UPDATE ON public.table_areas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: table_price_overrides update_table_price_overrides_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_table_price_overrides_updated_at BEFORE UPDATE ON public.table_price_overrides FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tables update_tables_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_tables_updated_at BEFORE UPDATE ON public.tables FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tax_groups update_tax_groups_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_tax_groups_updated_at BEFORE UPDATE ON public.tax_groups FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tax_rates update_tax_rates_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_tax_rates_updated_at BEFORE UPDATE ON public.tax_rates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: business_locations business_locations_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_locations
    ADD CONSTRAINT business_locations_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: business_subscriptions business_subscriptions_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_subscriptions
    ADD CONSTRAINT business_subscriptions_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: business_subscriptions business_subscriptions_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.business_subscriptions
    ADD CONSTRAINT business_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.subscription_plans(id);


--
-- Name: businesses businesses_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.businesses
    ADD CONSTRAINT businesses_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: category_taxes category_taxes_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_taxes
    ADD CONSTRAINT category_taxes_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE CASCADE;


--
-- Name: category_taxes category_taxes_tax_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_taxes
    ADD CONSTRAINT category_taxes_tax_group_id_fkey FOREIGN KEY (tax_group_id) REFERENCES public.tax_groups(id) ON DELETE CASCADE;


--
-- Name: charge_formulas charge_formulas_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_formulas
    ADD CONSTRAINT charge_formulas_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE CASCADE;


--
-- Name: charge_tiers charge_tiers_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_tiers
    ADD CONSTRAINT charge_tiers_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE CASCADE;


--
-- Name: charge_usage_analytics charge_usage_analytics_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_usage_analytics
    ADD CONSTRAINT charge_usage_analytics_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: charge_usage_analytics charge_usage_analytics_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_usage_analytics
    ADD CONSTRAINT charge_usage_analytics_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE CASCADE;


--
-- Name: charge_usage_analytics charge_usage_analytics_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charge_usage_analytics
    ADD CONSTRAINT charge_usage_analytics_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE SET NULL;


--
-- Name: charges charges_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT charges_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: charges charges_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT charges_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: charges charges_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.charges
    ADD CONSTRAINT charges_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE SET NULL;


--
-- Name: customer_charge_exemptions customer_charge_exemptions_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT customer_charge_exemptions_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES auth.users(id);


--
-- Name: customer_charge_exemptions customer_charge_exemptions_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT customer_charge_exemptions_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: customer_charge_exemptions customer_charge_exemptions_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT customer_charge_exemptions_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE CASCADE;


--
-- Name: customer_charge_exemptions customer_charge_exemptions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_charge_exemptions
    ADD CONSTRAINT customer_charge_exemptions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_communications customer_communications_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_communications
    ADD CONSTRAINT customer_communications_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: customer_communications customer_communications_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_communications
    ADD CONSTRAINT customer_communications_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_communications customer_communications_handled_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_communications
    ADD CONSTRAINT customer_communications_handled_by_fkey FOREIGN KEY (handled_by) REFERENCES auth.users(id);


--
-- Name: customer_contacts customer_contacts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_contacts
    ADD CONSTRAINT customer_contacts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_documents customer_documents_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_documents customer_documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);


--
-- Name: customer_documents customer_documents_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES auth.users(id);


--
-- Name: customer_groups customer_groups_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_groups
    ADD CONSTRAINT customer_groups_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: customer_groups customer_groups_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_groups
    ADD CONSTRAINT customer_groups_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: customer_transactions customer_transactions_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: customer_transactions customer_transactions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: customer_transactions customer_transactions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_transactions customer_transactions_payment_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);


--
-- Name: customer_transactions customer_transactions_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_transactions
    ADD CONSTRAINT customer_transactions_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES auth.users(id);


--
-- Name: customers customers_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: customers customers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: customers customers_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.customer_groups(id) ON DELETE SET NULL;


--
-- Name: customers customers_last_modified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_last_modified_by_fkey FOREIGN KEY (last_modified_by) REFERENCES auth.users(id);


--
-- Name: customers customers_price_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_price_category_id_fkey FOREIGN KEY (price_category_id) REFERENCES public.price_categories(id) ON DELETE SET NULL;


--
-- Name: discount_categories discount_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_categories
    ADD CONSTRAINT discount_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE CASCADE;


--
-- Name: discount_categories discount_categories_discount_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_categories
    ADD CONSTRAINT discount_categories_discount_rule_id_fkey FOREIGN KEY (discount_rule_id) REFERENCES public.discount_rules(id) ON DELETE CASCADE;


--
-- Name: discount_customer_groups discount_customer_groups_discount_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_customer_groups
    ADD CONSTRAINT discount_customer_groups_discount_rule_id_fkey FOREIGN KEY (discount_rule_id) REFERENCES public.discount_rules(id) ON DELETE CASCADE;


--
-- Name: discount_products discount_products_discount_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT discount_products_discount_rule_id_fkey FOREIGN KEY (discount_rule_id) REFERENCES public.discount_rules(id) ON DELETE CASCADE;


--
-- Name: discount_products discount_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_products
    ADD CONSTRAINT discount_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: discount_rules discount_rules_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_rules
    ADD CONSTRAINT discount_rules_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: discount_usage_history discount_usage_history_discount_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage_history
    ADD CONSTRAINT discount_usage_history_discount_rule_id_fkey FOREIGN KEY (discount_rule_id) REFERENCES public.discount_rules(id) ON DELETE CASCADE;


--
-- Name: discount_usage_history discount_usage_history_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage_history
    ADD CONSTRAINT discount_usage_history_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id);


--
-- Name: employee_audit_log employee_audit_log_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: employee_audit_log employee_audit_log_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: employee_audit_log employee_audit_log_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_audit_log
    ADD CONSTRAINT employee_audit_log_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES auth.users(id);


--
-- Name: employee_business_lookup employee_business_lookup_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_business_lookup
    ADD CONSTRAINT employee_business_lookup_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: employee_business_lookup employee_business_lookup_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_business_lookup
    ADD CONSTRAINT employee_business_lookup_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: employee_sessions employee_sessions_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_sessions
    ADD CONSTRAINT employee_sessions_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: employees employees_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: employees employees_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: employees employees_last_modified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_last_modified_by_fkey FOREIGN KEY (last_modified_by) REFERENCES auth.users(id);


--
-- Name: employees employees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.kot_stations(id) ON DELETE CASCADE;


--
-- Name: kot_item_routing kot_item_routing_variation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_item_routing
    ADD CONSTRAINT kot_item_routing_variation_id_fkey FOREIGN KEY (variation_id) REFERENCES public.product_variations(id) ON DELETE CASCADE;


--
-- Name: kot_printer_stations kot_printer_stations_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT kot_printer_stations_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: kot_printer_stations kot_printer_stations_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT kot_printer_stations_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: kot_printer_stations kot_printer_stations_printer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT kot_printer_stations_printer_id_fkey FOREIGN KEY (printer_id) REFERENCES public.kot_printers(id) ON DELETE CASCADE;


--
-- Name: kot_printer_stations kot_printer_stations_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printer_stations
    ADD CONSTRAINT kot_printer_stations_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.kot_stations(id) ON DELETE CASCADE;


--
-- Name: kot_printers kot_printers_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printers
    ADD CONSTRAINT kot_printers_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: kot_printers kot_printers_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_printers
    ADD CONSTRAINT kot_printers_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: kot_routing_rules kot_routing_rules_printer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_routing_rules
    ADD CONSTRAINT kot_routing_rules_printer_id_fkey FOREIGN KEY (printer_id) REFERENCES public.kot_printers(id) ON DELETE CASCADE;


--
-- Name: kot_routing_rules kot_routing_rules_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_routing_rules
    ADD CONSTRAINT kot_routing_rules_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: kot_stations kot_stations_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_stations
    ADD CONSTRAINT kot_stations_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: kot_stations kot_stations_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_stations
    ADD CONSTRAINT kot_stations_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: kot_templates kot_templates_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_templates
    ADD CONSTRAINT kot_templates_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: kot_templates kot_templates_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kot_templates
    ADD CONSTRAINT kot_templates_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: location_tax_overrides location_tax_overrides_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_tax_overrides
    ADD CONSTRAINT location_tax_overrides_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: location_tax_overrides location_tax_overrides_tax_rate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_tax_overrides
    ADD CONSTRAINT location_tax_overrides_tax_rate_id_fkey FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rates(id) ON DELETE CASCADE;


--
-- Name: order_charges order_charges_added_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_charges
    ADD CONSTRAINT order_charges_added_by_fkey FOREIGN KEY (added_by) REFERENCES auth.users(id);


--
-- Name: order_charges order_charges_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_charges
    ADD CONSTRAINT order_charges_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE SET NULL;


--
-- Name: order_charges order_charges_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_charges
    ADD CONSTRAINT order_charges_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_charges order_charges_removed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_charges
    ADD CONSTRAINT order_charges_removed_by_fkey FOREIGN KEY (removed_by) REFERENCES auth.users(id);


--
-- Name: order_discounts order_discounts_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_discounts
    ADD CONSTRAINT order_discounts_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_item_charges order_item_charges_charge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item_charges
    ADD CONSTRAINT order_item_charges_charge_id_fkey FOREIGN KEY (charge_id) REFERENCES public.charges(id) ON DELETE SET NULL;


--
-- Name: order_item_charges order_item_charges_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_item_charges
    ADD CONSTRAINT order_item_charges_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES public.order_items(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_payments order_payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_payments
    ADD CONSTRAINT order_payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: orders orders_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: orders orders_pos_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pos_device_id_fkey FOREIGN KEY (pos_device_id) REFERENCES public.pos_devices(id);


--
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id);


--
-- Name: payment_methods payment_methods_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: payment_methods payment_methods_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: pos_devices pos_devices_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pos_devices
    ADD CONSTRAINT pos_devices_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: price_categories price_categories_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_categories
    ADD CONSTRAINT price_categories_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: price_categories price_categories_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_categories
    ADD CONSTRAINT price_categories_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: price_categories price_categories_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.price_categories
    ADD CONSTRAINT price_categories_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: product_brands product_brands_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_brands
    ADD CONSTRAINT product_brands_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: product_image_metadata product_image_metadata_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image_metadata
    ADD CONSTRAINT product_image_metadata_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: product_image_metadata product_image_metadata_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_image_metadata
    ADD CONSTRAINT product_image_metadata_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_stock product_stock_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: product_stock product_stock_product_variation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_product_variation_id_fkey FOREIGN KEY (product_variation_id) REFERENCES public.product_variations(id) ON DELETE CASCADE;


--
-- Name: product_taxes product_taxes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_taxes
    ADD CONSTRAINT product_taxes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: product_taxes product_taxes_tax_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_taxes
    ADD CONSTRAINT product_taxes_tax_group_id_fkey FOREIGN KEY (tax_group_id) REFERENCES public.tax_groups(id) ON DELETE CASCADE;


--
-- Name: product_variation_prices product_variation_prices_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variation_prices
    ADD CONSTRAINT product_variation_prices_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: product_variation_prices product_variation_prices_price_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variation_prices
    ADD CONSTRAINT product_variation_prices_price_category_id_fkey FOREIGN KEY (price_category_id) REFERENCES public.price_categories(id) ON DELETE CASCADE;


--
-- Name: product_variation_prices product_variation_prices_variation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variation_prices
    ADD CONSTRAINT product_variation_prices_variation_id_fkey FOREIGN KEY (variation_id) REFERENCES public.product_variations(id) ON DELETE CASCADE;


--
-- Name: product_variations product_variations_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variations
    ADD CONSTRAINT product_variations_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.product_brands(id);


--
-- Name: products products_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.product_categories(id);


--
-- Name: sell_screen_preferences sell_screen_preferences_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sell_screen_preferences
    ADD CONSTRAINT sell_screen_preferences_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: sell_screen_preferences sell_screen_preferences_default_price_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sell_screen_preferences
    ADD CONSTRAINT sell_screen_preferences_default_price_category_id_fkey FOREIGN KEY (default_price_category_id) REFERENCES public.price_categories(id);


--
-- Name: sell_screen_preferences sell_screen_preferences_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sell_screen_preferences
    ADD CONSTRAINT sell_screen_preferences_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: subscription_analytics subscription_analytics_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_analytics
    ADD CONSTRAINT subscription_analytics_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: subscription_payments subscription_payments_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_payments
    ADD CONSTRAINT subscription_payments_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.business_subscriptions(id) ON DELETE CASCADE;


--
-- Name: subscription_payments subscription_payments_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_payments
    ADD CONSTRAINT subscription_payments_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES auth.users(id);


--
-- Name: table_areas table_areas_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_areas
    ADD CONSTRAINT table_areas_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: table_areas table_areas_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_areas
    ADD CONSTRAINT table_areas_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: table_orders table_orders_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: table_orders table_orders_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: table_orders table_orders_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: table_orders table_orders_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_orders
    ADD CONSTRAINT table_orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id) ON DELETE CASCADE;


--
-- Name: table_price_overrides table_price_overrides_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_price_overrides
    ADD CONSTRAINT table_price_overrides_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: table_price_overrides table_price_overrides_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_price_overrides
    ADD CONSTRAINT table_price_overrides_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id) ON DELETE CASCADE;


--
-- Name: table_price_overrides table_price_overrides_variation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_price_overrides
    ADD CONSTRAINT table_price_overrides_variation_id_fkey FOREIGN KEY (variation_id) REFERENCES public.product_variations(id) ON DELETE CASCADE;


--
-- Name: tables tables_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.table_areas(id) ON DELETE CASCADE;


--
-- Name: tables tables_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: tables tables_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.business_locations(id) ON DELETE CASCADE;


--
-- Name: tax_groups tax_groups_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_groups
    ADD CONSTRAINT tax_groups_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: tax_rates tax_rates_business_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rates
    ADD CONSTRAINT tax_rates_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.businesses(id) ON DELETE CASCADE;


--
-- Name: tax_rates tax_rates_parent_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rates
    ADD CONSTRAINT tax_rates_parent_tax_id_fkey FOREIGN KEY (parent_tax_id) REFERENCES public.tax_rates(id);


--
-- Name: tax_rates tax_rates_tax_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_rates
    ADD CONSTRAINT tax_rates_tax_group_id_fkey FOREIGN KEY (tax_group_id) REFERENCES public.tax_groups(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: subscription_payments Admins can insert payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can insert payments" ON public.subscription_payments FOR INSERT WITH CHECK (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: subscription_plans Admins can manage subscription plans; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can manage subscription plans" ON public.subscription_plans USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: subscription_payments Admins can update payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update payments" ON public.subscription_payments FOR UPDATE USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: business_subscriptions Admins can update subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can update subscriptions" ON public.business_subscriptions FOR UPDATE USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: subscription_analytics Admins can view all analytics; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view all analytics" ON public.subscription_analytics FOR SELECT USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: businesses Admins can view all businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view all businesses" ON public.businesses FOR SELECT USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: subscription_payments Admins can view all payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view all payments" ON public.subscription_payments FOR SELECT USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: business_subscriptions Admins can view all subscriptions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Admins can view all subscriptions" ON public.business_subscriptions FOR SELECT USING (((auth.jwt() ->> 'email'::text) = ANY (ARRAY['admin@tym.com'::text, 'naseefc@tym.com'::text])));


--
-- Name: table_price_overrides Authenticated users can delete table price overrides; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can delete table price overrides" ON public.table_price_overrides FOR DELETE TO authenticated USING (true);


--
-- Name: product_variation_prices Authenticated users can delete variation prices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can delete variation prices" ON public.product_variation_prices FOR DELETE TO authenticated USING (true);


--
-- Name: table_price_overrides Authenticated users can insert table price overrides; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can insert table price overrides" ON public.table_price_overrides FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.product_variations pv
  WHERE (pv.id = table_price_overrides.variation_id))));


--
-- Name: product_variation_prices Authenticated users can insert variation prices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can insert variation prices" ON public.product_variation_prices FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.product_variations pv
  WHERE (pv.id = product_variation_prices.variation_id))));


--
-- Name: table_price_overrides Authenticated users can update table price overrides; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can update table price overrides" ON public.table_price_overrides FOR UPDATE TO authenticated USING (true) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.product_variations pv
  WHERE (pv.id = table_price_overrides.variation_id))));


--
-- Name: product_variation_prices Authenticated users can update variation prices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can update variation prices" ON public.product_variation_prices FOR UPDATE TO authenticated USING (true) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.product_variations pv
  WHERE (pv.id = product_variation_prices.variation_id))));


--
-- Name: table_price_overrides Authenticated users can view table price overrides; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can view table price overrides" ON public.table_price_overrides FOR SELECT TO authenticated USING (true);


--
-- Name: product_variation_prices Authenticated users can view variation prices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Authenticated users can view variation prices" ON public.product_variation_prices FOR SELECT TO authenticated USING (true);


--
-- Name: business_locations Business owners and managers can create locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners and managers can create locations" ON public.business_locations FOR INSERT WITH CHECK (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.business_id = business_locations.business_id) AND (employees.primary_role = ANY (ARRAY['owner'::text, 'manager'::text])) AND (employees.employment_status = 'active'::text))))));


--
-- Name: business_locations Business owners and managers can update locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners and managers can update locations" ON public.business_locations FOR UPDATE USING (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.business_id = business_locations.business_id) AND (employees.primary_role = ANY (ARRAY['owner'::text, 'manager'::text])) AND (employees.employment_status = 'active'::text)))))) WITH CHECK (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.business_id = business_locations.business_id) AND (employees.primary_role = ANY (ARRAY['owner'::text, 'manager'::text])) AND (employees.employment_status = 'active'::text))))));


--
-- Name: kot_item_routing Business owners can delete kot_item_routing; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete kot_item_routing" ON public.kot_item_routing FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printer_stations Business owners can delete kot_printer_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete kot_printer_stations" ON public.kot_printer_stations FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printers Business owners can delete kot_printers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete kot_printers" ON public.kot_printers FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_stations Business owners can delete kot_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete kot_stations" ON public.kot_stations FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_templates Business owners can delete kot_templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete kot_templates" ON public.kot_templates FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_locations Business owners can delete locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can delete locations" ON public.business_locations FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_item_routing Business owners can insert kot_item_routing; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can insert kot_item_routing" ON public.kot_item_routing FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printer_stations Business owners can insert kot_printer_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can insert kot_printer_stations" ON public.kot_printer_stations FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printers Business owners can insert kot_printers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can insert kot_printers" ON public.kot_printers FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_stations Business owners can insert kot_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can insert kot_stations" ON public.kot_stations FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_templates Business owners can insert kot_templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can insert kot_templates" ON public.kot_templates FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: employee_sessions Business owners can terminate sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can terminate sessions" ON public.employee_sessions FOR UPDATE TO authenticated USING ((employee_id IN ( SELECT e.id
   FROM (public.employees e
     JOIN public.businesses b ON ((e.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: kot_item_routing Business owners can update kot_item_routing; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can update kot_item_routing" ON public.kot_item_routing FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printer_stations Business owners can update kot_printer_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can update kot_printer_stations" ON public.kot_printer_stations FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printers Business owners can update kot_printers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can update kot_printers" ON public.kot_printers FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_stations Business owners can update kot_stations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can update kot_stations" ON public.kot_stations FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_templates Business owners can update kot_templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can update kot_templates" ON public.kot_templates FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: employee_sessions Business owners can view all sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Business owners can view all sessions" ON public.employee_sessions FOR SELECT TO authenticated USING ((employee_id IN ( SELECT e.id
   FROM (public.employees e
     JOIN public.businesses b ON ((e.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: discount_usage_history Discount usage history cannot be deleted; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Discount usage history cannot be deleted" ON public.discount_usage_history FOR DELETE USING (false);


--
-- Name: discount_usage_history Discount usage history is immutable; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Discount usage history is immutable" ON public.discount_usage_history FOR UPDATE USING (false);


--
-- Name: POLICY "Discount usage history is immutable" ON discount_usage_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Discount usage history is immutable" ON public.discount_usage_history IS 'Ensures discount usage history cannot be modified for audit purposes';


--
-- Name: employee_sessions Employees can create own sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Employees can create own sessions" ON public.employee_sessions FOR INSERT TO authenticated WITH CHECK ((employee_id IN ( SELECT employees.id
   FROM public.employees
  WHERE (employees.user_id = auth.uid()))));


--
-- Name: employee_sessions Employees can update own sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Employees can update own sessions" ON public.employee_sessions FOR UPDATE TO authenticated USING ((employee_id IN ( SELECT employees.id
   FROM public.employees
  WHERE (employees.user_id = auth.uid()))));


--
-- Name: employee_sessions Employees can view own sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Employees can view own sessions" ON public.employee_sessions FOR SELECT TO authenticated USING ((employee_id IN ( SELECT employees.id
   FROM public.employees
  WHERE (employees.user_id = auth.uid()))));


--
-- Name: role_templates Everyone can view role templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Everyone can view role templates" ON public.role_templates FOR SELECT TO authenticated USING (true);


--
-- Name: employee_audit_log Insert audit logs - any authenticated user; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Insert audit logs - any authenticated user" ON public.employee_audit_log FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: role_templates System admins can modify role templates; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "System admins can modify role templates" ON public.role_templates TO authenticated USING (false) WITH CHECK (false);


--
-- Name: table_areas Temporary - Allow all operations for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Temporary - Allow all operations for authenticated users" ON public.table_areas TO authenticated USING (true) WITH CHECK (true);


--
-- Name: tables Temporary - Allow all operations for authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Temporary - Allow all operations for authenticated users" ON public.tables TO authenticated USING (true) WITH CHECK (true);


--
-- Name: business_locations Users and employees can view business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users and employees can view business locations" ON public.business_locations FOR SELECT USING (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (EXISTS ( SELECT 1
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.business_id = business_locations.business_id) AND (employees.employment_status = ANY (ARRAY['active'::text, 'inactive'::text])))))));


--
-- Name: businesses Users can create businesses for themselves; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create businesses for themselves" ON public.businesses FOR INSERT WITH CHECK ((auth.uid() = owner_id));


--
-- Name: customers Users can create customers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create customers" ON public.customers FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: discount_rules Users can create discount rules for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create discount rules for their businesses" ON public.discount_rules FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = discount_rules.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can create discount rules for their businesses" ON discount_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can create discount rules for their businesses" ON public.discount_rules IS 'Allows managers and above to create discount rules';


--
-- Name: discount_usage_history Users can create discount usage records for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create discount usage records for their businesses" ON public.discount_usage_history FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_usage_history.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: order_discounts Users can create order discounts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create order discounts" ON public.order_discounts FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = order_discounts.order_id) AND (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_items Users can create order items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create order items" ON public.order_items FOR INSERT WITH CHECK ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: order_payments Users can create order payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create order payments" ON public.order_payments FOR INSERT WITH CHECK ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: order_status_history Users can create order status history; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create order status history" ON public.order_status_history FOR INSERT WITH CHECK ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: orders Users can create orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create orders for their businesses" ON public.orders FOR INSERT WITH CHECK (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) AND (created_by = auth.uid())));


--
-- Name: payment_methods Users can create payment methods for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create payment methods for their business" ON public.payment_methods FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: price_categories Users can create price categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create price categories for their businesses" ON public.price_categories FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = price_categories.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_variations Users can create product variations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create product variations" ON public.product_variations FOR INSERT WITH CHECK ((product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: sell_screen_preferences Users can create sell screen preferences for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create sell screen preferences for their businesses" ON public.sell_screen_preferences FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = sell_screen_preferences.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: table_price_overrides Users can create table price overrides for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create table price overrides for their businesses" ON public.table_price_overrides FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.tables t
     JOIN public.businesses b ON ((b.id = t.business_id)))
  WHERE ((t.id = table_price_overrides.table_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_groups Users can create tax groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create tax groups for their businesses" ON public.tax_groups FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_groups.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can create tax groups for their businesses" ON tax_groups; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can create tax groups for their businesses" ON public.tax_groups IS 'Allows users to create tax groups for their businesses';


--
-- Name: tax_rates Users can create tax rates for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create tax rates for their businesses" ON public.tax_rates FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_rates.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_variation_prices Users can create variation prices for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create variation prices for their businesses" ON public.product_variation_prices FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM ((public.product_variations pv
     JOIN public.products p ON ((pv.product_id = p.id)))
     JOIN public.businesses b ON ((b.id = p.business_id)))
  WHERE ((pv.id = product_variation_prices.variation_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_brands Users can delete brands for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete brands for their businesses" ON public.product_brands FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_categories Users can delete categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete categories for their businesses" ON public.product_categories FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customers Users can delete customers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete customers" ON public.customers FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: discount_rules Users can delete discount rules for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete discount rules for their businesses" ON public.discount_rules FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = discount_rules.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: orders Users can delete draft orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete draft orders for their businesses" ON public.orders FOR DELETE USING (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) AND ((status)::text = 'draft'::text)));


--
-- Name: payment_methods Users can delete non-default payment methods for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete non-default payment methods for their business" ON public.payment_methods FOR DELETE USING (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) AND (is_default = false)));


--
-- Name: order_items Users can delete order items from draft orders; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete order items from draft orders" ON public.order_items FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = order_items.order_id) AND (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))) AND ((o.status)::text = 'draft'::text)))));


--
-- Name: price_categories Users can delete price categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete price categories for their businesses" ON public.price_categories FOR DELETE USING (((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = price_categories.business_id) AND (b.owner_id = auth.uid())))) AND (is_default = false)));


--
-- Name: kot_printers Users can delete printers for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete printers for their business locations" ON public.kot_printers FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_variations Users can delete product variations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete product variations" ON public.product_variations FOR DELETE USING ((product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: products Users can delete products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete products for their businesses" ON public.products FOR DELETE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_routing_rules Users can delete routing rules for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete routing rules for their business products" ON public.kot_routing_rules FOR DELETE USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: sell_screen_preferences Users can delete sell screen preferences for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete sell screen preferences for their businesses" ON public.sell_screen_preferences FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = sell_screen_preferences.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_stock Users can delete stock for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete stock for their business locations" ON public.product_stock FOR DELETE USING ((location_id IN ( SELECT business_locations.id
   FROM public.business_locations
  WHERE (business_locations.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: table_price_overrides Users can delete table price overrides for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete table price overrides for their businesses" ON public.table_price_overrides FOR DELETE USING ((EXISTS ( SELECT 1
   FROM (public.tables t
     JOIN public.businesses b ON ((b.id = t.business_id)))
  WHERE ((t.id = table_price_overrides.table_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_groups Users can delete tax groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete tax groups for their businesses" ON public.tax_groups FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_groups.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_rates Users can delete tax rates for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete tax rates for their businesses" ON public.tax_rates FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_rates.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: pos_devices Users can delete their POS devices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete their POS devices" ON public.pos_devices FOR DELETE USING ((location_id IN ( SELECT bl.id
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: businesses Users can delete their own businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete their own businesses" ON public.businesses FOR DELETE USING ((auth.uid() = owner_id));


--
-- Name: product_variation_prices Users can delete variation prices for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete variation prices for their businesses" ON public.product_variation_prices FOR DELETE USING ((EXISTS ( SELECT 1
   FROM ((public.product_variations pv
     JOIN public.products p ON ((pv.product_id = p.id)))
     JOIN public.businesses b ON ((b.id = p.business_id)))
  WHERE ((pv.id = product_variation_prices.variation_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_variations Users can delete variations for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete variations for their business products" ON public.product_variations FOR DELETE USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: pos_devices Users can insert POS devices for their locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert POS devices for their locations" ON public.pos_devices FOR INSERT WITH CHECK ((location_id IN ( SELECT bl.id
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: product_brands Users can insert brands for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert brands for their businesses" ON public.product_brands FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_categories Users can insert categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert categories for their businesses" ON public.product_categories FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printers Users can insert printers for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert printers for their business locations" ON public.kot_printers FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: products Users can insert products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert products for their businesses" ON public.products FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_routing_rules Users can insert routing rules for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert routing rules for their business products" ON public.kot_routing_rules FOR INSERT WITH CHECK ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_stock Users can insert stock for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert stock for their business locations" ON public.product_stock FOR INSERT WITH CHECK ((location_id IN ( SELECT business_locations.id
   FROM public.business_locations
  WHERE (business_locations.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_variations Users can insert variations for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert variations for their business products" ON public.product_variations FOR INSERT WITH CHECK ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: category_taxes Users can manage category taxes for their categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage category taxes for their categories" ON public.category_taxes USING ((EXISTS ( SELECT 1
   FROM (public.product_categories pc
     JOIN public.businesses b ON ((pc.business_id = b.id)))
  WHERE ((pc.id = category_taxes.category_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.product_categories pc
     JOIN public.businesses b ON ((pc.business_id = b.id)))
  WHERE ((pc.id = category_taxes.category_id) AND (b.owner_id = auth.uid())))));


--
-- Name: customer_charge_exemptions Users can manage charge exemptions for their customers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage charge exemptions for their customers" ON public.customer_charge_exemptions USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: charge_formulas Users can manage charge formulas for their charges; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage charge formulas for their charges" ON public.charge_formulas USING ((charge_id IN ( SELECT charges.id
   FROM public.charges
  WHERE (charges.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: charge_tiers Users can manage charge tiers for their charges; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage charge tiers for their charges" ON public.charge_tiers USING ((charge_id IN ( SELECT charges.id
   FROM public.charges
  WHERE (charges.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: charges Users can manage charges for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage charges for their business" ON public.charges USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customer_communications Users can manage customer communications for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customer communications for their business" ON public.customer_communications USING ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: customer_contacts Users can manage customer contacts for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customer contacts for their business" ON public.customer_contacts USING ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: customer_documents Users can manage customer documents for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customer documents for their business" ON public.customer_documents USING ((customer_id IN ( SELECT customers.id
   FROM public.customers
  WHERE (customers.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: customer_groups Users can manage customer groups for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customer groups for their business" ON public.customer_groups USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customer_transactions Users can manage customer transactions for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customer transactions for their business" ON public.customer_transactions USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customers Users can manage customers for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage customers for their business" ON public.customers USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: discount_categories Users can manage discount categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage discount categories for their businesses" ON public.discount_categories USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_categories.discount_rule_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_categories.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: discount_customer_groups Users can manage discount customer groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage discount customer groups for their businesses" ON public.discount_customer_groups USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_customer_groups.discount_rule_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_customer_groups.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: discount_products Users can manage discount products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage discount products for their businesses" ON public.discount_products USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_products.discount_rule_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_products.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: order_item_charges Users can manage item charges for their orders; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage item charges for their orders" ON public.order_item_charges USING ((order_item_id IN ( SELECT oi.id
   FROM (public.order_items oi
     JOIN public.orders o ON ((oi.order_id = o.id)))
  WHERE (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: location_tax_overrides Users can manage location tax overrides for their locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage location tax overrides for their locations" ON public.location_tax_overrides USING ((EXISTS ( SELECT 1
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE ((bl.id = location_tax_overrides.location_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE ((bl.id = location_tax_overrides.location_id) AND (b.owner_id = auth.uid())))));


--
-- Name: order_charges Users can manage order charges for their orders; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage order charges for their orders" ON public.order_charges USING ((order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_taxes Users can manage product taxes for their products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage product taxes for their products" ON public.product_taxes USING ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE ((p.id = product_taxes.product_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE ((p.id = product_taxes.product_id) AND (b.owner_id = auth.uid())))));


--
-- Name: table_orders Users can manage table orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can manage table orders for their businesses" ON public.table_orders USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())))) WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_brands Users can update brands for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update brands for their businesses" ON public.product_brands FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_categories Users can update categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update categories for their businesses" ON public.product_categories FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customers Users can update customers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update customers" ON public.customers FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())))) WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: discount_rules Users can update discount rules for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update discount rules for their businesses" ON public.discount_rules FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = discount_rules.business_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = discount_rules.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: order_discounts Users can update order discounts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update order discounts" ON public.order_discounts FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = order_discounts.order_id) AND (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = order_discounts.order_id) AND (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_items Users can update order items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update order items" ON public.order_items FOR UPDATE USING ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid())))) WITH CHECK ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: order_payments Users can update order payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update order payments" ON public.order_payments FOR UPDATE USING ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid())))) WITH CHECK ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: orders Users can update orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update orders for their businesses" ON public.orders FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())))) WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: payment_methods Users can update payment methods for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update payment methods for their business" ON public.payment_methods FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: price_categories Users can update price categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update price categories for their businesses" ON public.price_categories FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = price_categories.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: kot_printers Users can update printers for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update printers for their business locations" ON public.kot_printers FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_variations Users can update product variations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update product variations" ON public.product_variations FOR UPDATE USING ((product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE (b.owner_id = auth.uid())))) WITH CHECK ((product_id IN ( SELECT p.id
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: products Users can update products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update products for their businesses" ON public.products FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_routing_rules Users can update routing rules for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update routing rules for their business products" ON public.kot_routing_rules FOR UPDATE USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: sell_screen_preferences Users can update sell screen preferences for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update sell screen preferences for their businesses" ON public.sell_screen_preferences FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = sell_screen_preferences.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_stock Users can update stock for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update stock for their business locations" ON public.product_stock FOR UPDATE USING ((location_id IN ( SELECT business_locations.id
   FROM public.business_locations
  WHERE (business_locations.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: table_price_overrides Users can update table price overrides for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update table price overrides for their businesses" ON public.table_price_overrides FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.tables t
     JOIN public.businesses b ON ((b.id = t.business_id)))
  WHERE ((t.id = table_price_overrides.table_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_groups Users can update tax groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update tax groups for their businesses" ON public.tax_groups FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_groups.business_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_groups.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_rates Users can update tax rates for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update tax rates for their businesses" ON public.tax_rates FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_rates.business_id) AND (b.owner_id = auth.uid()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_rates.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: pos_devices Users can update their POS devices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their POS devices" ON public.pos_devices FOR UPDATE USING ((location_id IN ( SELECT bl.id
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: businesses Users can update their own businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own businesses" ON public.businesses FOR UPDATE USING ((auth.uid() = owner_id));


--
-- Name: product_variation_prices Users can update variation prices for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update variation prices for their businesses" ON public.product_variation_prices FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ((public.product_variations pv
     JOIN public.products p ON ((pv.product_id = p.id)))
     JOIN public.businesses b ON ((b.id = p.business_id)))
  WHERE ((pv.id = product_variation_prices.variation_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_variations Users can update variations for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update variations for their business products" ON public.product_variations FOR UPDATE USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_brands Users can view brands for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view brands for their businesses" ON public.product_brands FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())
UNION
 SELECT employees.business_id
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))));


--
-- Name: product_categories Users can view categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view categories for their businesses" ON public.product_categories FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())
UNION
 SELECT employees.business_id
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))));


--
-- Name: category_taxes Users can view category taxes for their categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view category taxes for their categories" ON public.category_taxes FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.product_categories pc
     JOIN public.businesses b ON ((pc.business_id = b.id)))
  WHERE ((pc.id = category_taxes.category_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can view category taxes for their categories" ON category_taxes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can view category taxes for their categories" ON public.category_taxes IS 'Allows users to view tax assignments for their product categories';


--
-- Name: charge_usage_analytics Users can view charge analytics for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view charge analytics for their business" ON public.charge_usage_analytics FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: customers Users can view customers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view customers" ON public.customers FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: discount_categories Users can view discount categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view discount categories for their businesses" ON public.discount_categories FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_categories.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: discount_customer_groups Users can view discount customer groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view discount customer groups for their businesses" ON public.discount_customer_groups FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_customer_groups.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: discount_products Users can view discount products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view discount products for their businesses" ON public.discount_products FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_products.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: discount_rules Users can view discount rules for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view discount rules for their businesses" ON public.discount_rules FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = discount_rules.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can view discount rules for their businesses" ON discount_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can view discount rules for their businesses" ON public.discount_rules IS 'Allows users to view discount rules for businesses they belong to';


--
-- Name: discount_usage_history Users can view discount usage history for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view discount usage history for their businesses" ON public.discount_usage_history FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.discount_rules dr
     JOIN public.businesses b ON ((dr.business_id = b.id)))
  WHERE ((dr.id = discount_usage_history.discount_rule_id) AND (b.owner_id = auth.uid())))));


--
-- Name: kot_item_routing Users can view kot_item_routing in their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view kot_item_routing in their business" ON public.kot_item_routing FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printer_stations Users can view kot_printer_stations in their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view kot_printer_stations in their business" ON public.kot_printer_stations FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_printers Users can view kot_printers in their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view kot_printers in their business" ON public.kot_printers FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_stations Users can view kot_stations in their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view kot_stations in their business" ON public.kot_stations FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: kot_templates Users can view kot_templates in their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view kot_templates in their business" ON public.kot_templates FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: location_tax_overrides Users can view location tax overrides for their locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view location tax overrides for their locations" ON public.location_tax_overrides FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE ((bl.id = location_tax_overrides.location_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can view location tax overrides for their locations" ON location_tax_overrides; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can view location tax overrides for their locations" ON public.location_tax_overrides IS 'Allows users to view location-specific tax rate overrides';


--
-- Name: order_discounts Users can view order discounts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view order discounts" ON public.order_discounts FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.orders o
  WHERE ((o.id = order_discounts.order_id) AND (o.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_items Users can view order items; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view order items" ON public.order_items FOR SELECT USING ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: order_payments Users can view order payments; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view order payments" ON public.order_payments FOR SELECT USING ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: order_status_history Users can view order status history; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view order status history" ON public.order_status_history FOR SELECT USING ((order_id IN ( SELECT o.id
   FROM (public.orders o
     JOIN public.businesses b ON ((o.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: orders Users can view orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view orders for their businesses" ON public.orders FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: payment_methods Users can view payment methods for their business; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view payment methods for their business" ON public.payment_methods FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: price_categories Users can view price categories for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view price categories for their businesses" ON public.price_categories FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())
UNION
 SELECT employees.business_id
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))));


--
-- Name: kot_printers Users can view printers for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view printers for their business locations" ON public.kot_printers FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: product_variation_prices Users can view product prices for their price categories; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view product prices for their price categories" ON public.product_variation_prices FOR SELECT USING ((price_category_id IN ( SELECT price_categories.id
   FROM public.price_categories
  WHERE (price_categories.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())
        UNION
         SELECT employees.business_id
           FROM public.employees
          WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))))));


--
-- Name: product_taxes Users can view product taxes for their products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view product taxes for their products" ON public.product_taxes FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.products p
     JOIN public.businesses b ON ((p.business_id = b.id)))
  WHERE ((p.id = product_taxes.product_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can view product taxes for their products" ON product_taxes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can view product taxes for their products" ON public.product_taxes IS 'Allows users to view tax assignments for their products';


--
-- Name: product_variations Users can view product variations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view product variations" ON public.product_variations FOR SELECT USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())
        UNION
         SELECT employees.business_id
           FROM public.employees
          WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))))));


--
-- Name: products Users can view products for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view products for their businesses" ON public.products FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())
UNION
 SELECT employees.business_id
   FROM public.employees
  WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text)))));


--
-- Name: kot_routing_rules Users can view routing rules for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view routing rules for their business products" ON public.kot_routing_rules FOR SELECT USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: sell_screen_preferences Users can view sell screen preferences for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view sell screen preferences for their businesses" ON public.sell_screen_preferences FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = sell_screen_preferences.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_stock Users can view stock for their business locations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view stock for their business locations" ON public.product_stock FOR SELECT USING ((location_id IN ( SELECT business_locations.id
   FROM public.business_locations
  WHERE (business_locations.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_stock Users can view stock for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view stock for their businesses" ON public.product_stock FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.product_variations pv
     JOIN public.products p ON ((pv.product_id = p.id)))
  WHERE ((pv.id = product_stock.product_variation_id) AND (p.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())
        UNION
         SELECT employees.business_id
           FROM public.employees
          WHERE ((employees.user_id = auth.uid()) AND (employees.employment_status = 'active'::text))))))));


--
-- Name: table_orders Users can view table orders for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view table orders for their businesses" ON public.table_orders FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: table_price_overrides Users can view table price overrides for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view table price overrides for their businesses" ON public.table_price_overrides FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.tables t
     JOIN public.businesses b ON ((b.id = t.business_id)))
  WHERE ((t.id = table_price_overrides.table_id) AND (b.owner_id = auth.uid())))));


--
-- Name: tax_groups Users can view tax groups for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view tax groups for their businesses" ON public.tax_groups FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_groups.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: POLICY "Users can view tax groups for their businesses" ON tax_groups; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON POLICY "Users can view tax groups for their businesses" ON public.tax_groups IS 'Allows users to view tax groups for businesses they own';


--
-- Name: tax_rates Users can view tax rates for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view tax rates for their businesses" ON public.tax_rates FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.businesses b
  WHERE ((b.id = tax_rates.business_id) AND (b.owner_id = auth.uid())))));


--
-- Name: pos_devices Users can view their POS devices; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their POS devices" ON public.pos_devices FOR SELECT USING ((location_id IN ( SELECT bl.id
   FROM (public.business_locations bl
     JOIN public.businesses b ON ((bl.business_id = b.id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: businesses Users can view their own businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view their own businesses" ON public.businesses FOR SELECT USING ((auth.uid() = owner_id));


--
-- Name: product_variation_prices Users can view variation prices for their businesses; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view variation prices for their businesses" ON public.product_variation_prices FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ((public.product_variations pv
     JOIN public.products p ON ((pv.product_id = p.id)))
     JOIN public.businesses b ON ((b.id = p.business_id)))
  WHERE ((pv.id = product_variation_prices.variation_id) AND (b.owner_id = auth.uid())))));


--
-- Name: product_variations Users can view variations for their business products; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view variations for their business products" ON public.product_variations FOR SELECT USING ((product_id IN ( SELECT products.id
   FROM public.products
  WHERE (products.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid()))))));


--
-- Name: product_image_metadata Users manage their business images; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users manage their business images" ON public.product_image_metadata USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: employee_audit_log View audit logs - business owners; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "View audit logs - business owners" ON public.employee_audit_log FOR SELECT TO authenticated USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: employee_audit_log audit_log_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_insert_policy ON public.employee_audit_log FOR INSERT TO authenticated WITH CHECK (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (employee_id IN ( SELECT employees.id
   FROM public.employees
  WHERE (employees.user_id = auth.uid()))) OR (business_id IN ( SELECT employee_business_lookup.business_id
   FROM public.employee_business_lookup
  WHERE (employee_business_lookup.user_id = auth.uid())))));


--
-- Name: business_locations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.business_locations ENABLE ROW LEVEL SECURITY;

--
-- Name: business_subscriptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.business_subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: business_subscriptions business_subscriptions_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_insert_policy ON public.business_subscriptions FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_subscriptions business_subscriptions_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_select_policy ON public.business_subscriptions FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_subscriptions business_subscriptions_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_update_policy ON public.business_subscriptions FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_subscriptions business_subscriptions_user_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_user_insert_policy ON public.business_subscriptions FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_subscriptions business_subscriptions_user_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_user_select_policy ON public.business_subscriptions FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: business_subscriptions business_subscriptions_user_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY business_subscriptions_user_update_policy ON public.business_subscriptions FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: businesses; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;

--
-- Name: category_taxes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.category_taxes ENABLE ROW LEVEL SECURITY;

--
-- Name: charge_formulas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.charge_formulas ENABLE ROW LEVEL SECURITY;

--
-- Name: charge_tiers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.charge_tiers ENABLE ROW LEVEL SECURITY;

--
-- Name: charge_usage_analytics; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.charge_usage_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: charges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.charges ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_charge_exemptions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_charge_exemptions ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_communications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_communications ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_contacts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_contacts ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_documents; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_documents ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_groups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: customer_transactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customer_transactions ENABLE ROW LEVEL SECURITY;

--
-- Name: customers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

--
-- Name: discount_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.discount_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: discount_customer_groups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.discount_customer_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: discount_products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.discount_products ENABLE ROW LEVEL SECURITY;

--
-- Name: discount_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.discount_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: discount_usage_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.discount_usage_history ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_business_lookup; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_business_lookup ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employee_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: employees; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;

--
-- Name: employees employees_delete_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_delete_policy ON public.employees FOR DELETE TO authenticated USING ((business_id IN ( SELECT employee_business_lookup.business_id
   FROM public.employee_business_lookup
  WHERE ((employee_business_lookup.user_id = auth.uid()) AND (employee_business_lookup.is_owner = true)))));


--
-- Name: employees employees_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_insert_policy ON public.employees FOR INSERT TO authenticated WITH CHECK (((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))) OR (user_id = auth.uid())));


--
-- Name: employees employees_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_select_policy ON public.employees FOR SELECT TO authenticated USING (((business_id IN ( SELECT employee_business_lookup.business_id
   FROM public.employee_business_lookup
  WHERE ((employee_business_lookup.user_id = auth.uid()) AND ((employee_business_lookup.is_owner = true) OR (employee_business_lookup.is_active_employee = true))))) OR (user_id = auth.uid())));


--
-- Name: employees employees_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY employees_update_policy ON public.employees FOR UPDATE TO authenticated USING (((business_id IN ( SELECT employee_business_lookup.business_id
   FROM public.employee_business_lookup
  WHERE ((employee_business_lookup.user_id = auth.uid()) AND (employee_business_lookup.is_owner = true)))) OR (user_id = auth.uid()))) WITH CHECK (((business_id IN ( SELECT employee_business_lookup.business_id
   FROM public.employee_business_lookup
  WHERE ((employee_business_lookup.user_id = auth.uid()) AND (employee_business_lookup.is_owner = true)))) OR ((user_id = auth.uid()) AND (business_id = business_id))));


--
-- Name: kot_item_routing; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_item_routing ENABLE ROW LEVEL SECURITY;

--
-- Name: kot_printer_stations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_printer_stations ENABLE ROW LEVEL SECURITY;

--
-- Name: kot_printers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_printers ENABLE ROW LEVEL SECURITY;

--
-- Name: kot_routing_rules; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_routing_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: kot_stations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_stations ENABLE ROW LEVEL SECURITY;

--
-- Name: kot_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.kot_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: location_tax_overrides; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.location_tax_overrides ENABLE ROW LEVEL SECURITY;

--
-- Name: employee_business_lookup lookup_all_operations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY lookup_all_operations ON public.employee_business_lookup TO authenticated USING (((user_id = auth.uid()) OR (business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))))) WITH CHECK (((user_id = auth.uid()) OR (business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())))));


--
-- Name: employee_business_lookup lookup_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY lookup_select_policy ON public.employee_business_lookup FOR SELECT TO authenticated USING (true);


--
-- Name: order_charges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_charges ENABLE ROW LEVEL SECURITY;

--
-- Name: order_charges order_charges_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_charges_policy ON public.order_charges USING (((auth.uid() IS NOT NULL) AND (order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_discounts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_discounts ENABLE ROW LEVEL SECURITY;

--
-- Name: order_discounts order_discounts_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_discounts_policy ON public.order_discounts USING (((auth.uid() IS NOT NULL) AND (order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_item_charges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_item_charges ENABLE ROW LEVEL SECURITY;

--
-- Name: order_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

--
-- Name: order_items order_items_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_items_policy ON public.order_items USING (((auth.uid() IS NOT NULL) AND (order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_items order_items_temp_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_items_temp_all ON public.order_items USING ((auth.uid() IS NOT NULL));


--
-- Name: order_payments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_payments ENABLE ROW LEVEL SECURITY;

--
-- Name: order_payments order_payments_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_payments_policy ON public.order_payments USING (((auth.uid() IS NOT NULL) AND (order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_status_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;

--
-- Name: order_status_history order_status_history_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_status_history_policy ON public.order_status_history USING (((auth.uid() IS NOT NULL) AND (order_id IN ( SELECT orders.id
   FROM public.orders
  WHERE (orders.business_id IN ( SELECT businesses.id
           FROM public.businesses
          WHERE (businesses.owner_id = auth.uid())))))));


--
-- Name: order_status_history order_status_history_temp_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY order_status_history_temp_all ON public.order_status_history USING ((auth.uid() IS NOT NULL));


--
-- Name: orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

--
-- Name: orders orders_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY orders_policy ON public.orders USING (((auth.uid() IS NOT NULL) AND (business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid())))));


--
-- Name: orders orders_temp_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY orders_temp_all ON public.orders USING ((auth.uid() IS NOT NULL));


--
-- Name: payment_methods; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;

--
-- Name: pos_devices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.pos_devices ENABLE ROW LEVEL SECURITY;

--
-- Name: price_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.price_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_brands; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_brands ENABLE ROW LEVEL SECURITY;

--
-- Name: product_categories; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_categories ENABLE ROW LEVEL SECURITY;

--
-- Name: product_image_metadata; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_image_metadata ENABLE ROW LEVEL SECURITY;

--
-- Name: product_stock; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_stock ENABLE ROW LEVEL SECURITY;

--
-- Name: product_taxes; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_taxes ENABLE ROW LEVEL SECURITY;

--
-- Name: product_variation_prices; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_variation_prices ENABLE ROW LEVEL SECURITY;

--
-- Name: product_variations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.product_variations ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: role_templates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.role_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: sell_screen_preferences; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.sell_screen_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: subscription_analytics; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscription_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: subscription_analytics subscription_analytics_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_analytics_insert_policy ON public.subscription_analytics FOR INSERT WITH CHECK ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: subscription_analytics subscription_analytics_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_analytics_select_policy ON public.subscription_analytics FOR SELECT USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: subscription_analytics subscription_analytics_update_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_analytics_update_policy ON public.subscription_analytics FOR UPDATE USING ((business_id IN ( SELECT businesses.id
   FROM public.businesses
  WHERE (businesses.owner_id = auth.uid()))));


--
-- Name: subscription_payments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscription_payments ENABLE ROW LEVEL SECURITY;

--
-- Name: subscription_payments subscription_payments_insert_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_payments_insert_policy ON public.subscription_payments FOR INSERT WITH CHECK ((subscription_id IN ( SELECT bs.id
   FROM (public.business_subscriptions bs
     JOIN public.businesses b ON ((b.id = bs.business_id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: subscription_payments subscription_payments_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_payments_select_policy ON public.subscription_payments FOR SELECT USING ((subscription_id IN ( SELECT bs.id
   FROM (public.business_subscriptions bs
     JOIN public.businesses b ON ((b.id = bs.business_id)))
  WHERE (b.owner_id = auth.uid()))));


--
-- Name: subscription_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.subscription_plans ENABLE ROW LEVEL SECURITY;

--
-- Name: subscription_plans subscription_plans_select_policy; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY subscription_plans_select_policy ON public.subscription_plans FOR SELECT USING ((is_active = true));


--
-- Name: table_areas; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.table_areas ENABLE ROW LEVEL SECURITY;

--
-- Name: table_orders; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.table_orders ENABLE ROW LEVEL SECURITY;

--
-- Name: table_price_overrides; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.table_price_overrides ENABLE ROW LEVEL SECURITY;

--
-- Name: tables; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tables ENABLE ROW LEVEL SECURITY;

--
-- Name: tax_groups; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tax_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: tax_rates; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tax_rates ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Authenticated users can delete 16wiy3a_0; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can delete 16wiy3a_0" ON storage.objects FOR DELETE TO authenticated USING (true);


--
-- Name: objects Authenticated users can update 16wiy3a_0; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can update 16wiy3a_0" ON storage.objects FOR UPDATE TO authenticated USING (true);


--
-- Name: objects Authenticated users can upload 16wiy3a_0; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated users can upload 16wiy3a_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: objects Public can view product images 16wiy3a_0; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public can view product images 16wiy3a_0" ON storage.objects FOR SELECT TO authenticated, anon USING (true);


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: -
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict RiZUQfjwBXfF3w2Bdw3X5ZqvNsJvxuuz5lcEb0YXkvP9PKcQLjE0JuamI7rh9LG

