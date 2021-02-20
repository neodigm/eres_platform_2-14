CREATE OR REPLACE PACKAGE BODY ADD_ORS.ADD_UE AS
-- Informatica MDM User Exit PL/SQL
-- 🏄 SQL⚡ ETL MDM ⚡ PL/SQL ORM
FUNCTION show_version
    RETURN cmxlb.cmx_med_str
AS
addue_version cmxlb.cmx_med_str := 'Version 1.4 (2014-03-13 16:02:00)';
BEGIN
    RETURN addue_version;
END;
--
FUNCTION GET_PARAMETER(in_name VARCHAR2, in_dft VARCHAR2) RETURN VARCHAR2 AS
     result VARCHAR2(255);
BEGIN
     SELECT VALUE INTO result FROM C_PARAMETERS WHERE NAME = in_name;
     return result;
EXCEPTION
   WHEN OTHERS THEN
          RETURN in_dft;
END;
--
PROCEDURE chk_acct_ids
(
    acct_rowid_object      varchar2,
    acct_sys_name          varchar2,
    acct_sys_id            varchar2,
    acct_cd                varchar2,
    src_nf_ok              boolean,
    out_rowid_object OUT   varchar2,
    out_pkey_src_obj OUT   varchar2,
    out_err_flg      OUT   char,
    out_err_msg      OUT   varchar2
)
AS
sql_stmt varchar2(2000);
t_src_sys_name  varchar2(10);
t_src_sys_id    varchar2(40);
t_rowid_object  varchar2(14);
t_count         integer;
BEGIN
   IF acct_rowid_object is not null THEN
   BEGIN
      -- Check if the rowid_object is valid
     sql_stmt := 'select src_sys_name, src_sys_id from c_hm_accounts where rowid_object = ''' || acct_rowid_object || '''';
      --dbms_output.put_line('sql_stmt = ' || sql_stmt);
      EXECUTE IMMEDIATE sql_stmt into t_src_sys_name, t_src_sys_id;
      --dbms_output.put_line('account found');
      -- Rowid found
      out_rowid_object := acct_rowid_object;
      -- Version 1.4 - Always use account rowid_object to build pkey source object
      out_pkey_src_obj := 'BATCH' || ':' || acct_rowid_object;
      out_err_flg := 'N';
      out_err_msg := '';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          --dbms_output.put_line('account not found');
           out_rowid_object := NULL;
           out_pkey_src_obj := NULL;
           out_err_flg := 'Y';
           out_err_msg := 'Invalid account rowid object: ' || acct_rowid_object;
   END;
   ELSIF (acct_sys_name is NOT NULL and acct_sys_id is NOT NULL) THEN
   BEGIN
      -- Check if there is an account with the provided source keys
      sql_stmt := 'select rowid_object from c_hm_accounts where src_sys_name = :1 and src_sys_id = :2';
      dbms_output.put_line('Executing:' || sql_stmt);
      dbms_output.put_line('Using src_sys_name = ' || acct_sys_name || ' src_sys Id: ' || acct_sys_id);
      EXECUTE IMMEDIATE sql_stmt into t_rowid_object using acct_sys_name, acct_sys_id;
      -- Rowid found
      out_rowid_object := t_rowid_object;
      out_pkey_src_obj := acct_sys_name || ':' || acct_sys_id;
      out_err_flg := 'N';
      out_err_msg := '';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          IF src_nf_ok THEN
            -- No existing record with this key combo, treat it as a new account
             dbms_output.put_line('No data found, src_nf_ok is true');
             out_rowid_object := NULL;
             out_pkey_src_obj := acct_sys_name || ':' || acct_sys_id;
             out_err_flg := 'N';
             out_err_msg := '';
          ELSE
             dbms_output.put_line('No data found, src_nf_ok is false');
             out_rowid_object := NULL;
             out_pkey_src_obj := NULL;
             out_err_flg := 'Y';
             out_err_msg := 'Account source key not found: ' || acct_sys_id || ':' || acct_rowid_object;
          END IF;
   END;
   ELSIF acct_cd IS NOT NULL THEN
   BEGIN
      -- Check if there are multiple accounts with this account code
      sql_stmt := 'select count(*) from c_hm_accounts where account_cd = :a1';
      EXECUTE IMMEDIATE sql_stmt into t_count using acct_cd;
      --
      -- Bugfix for 3.11. Moved the single row select statment down so it is executed *after* checking that the record count=1
      --
      IF t_count = 0 THEN
          IF src_nf_ok THEN
           -- No existing record with this account code, treat it as a new account
           out_rowid_object := NULL;
           out_pkey_src_obj := 'BATCH' || ':' || acct_cd;
           out_err_flg := 'N';
           out_err_msg := '';
          ELSE
             out_rowid_object := NULL;
             out_pkey_src_obj := NULL;
             out_err_flg := 'Y';
             out_err_msg := 'No account found for account code: ' || acct_cd;
          END IF;
      ELSIF t_count = 1 THEN
        -- Get the id of the account with the provided account cd
        sql_stmt := 'select rowid_object from c_hm_accounts where account_cd = :a1';
        EXECUTE IMMEDIATE sql_stmt into t_rowid_object using acct_cd;
        out_rowid_object := t_rowid_object;
        out_pkey_src_obj := 'BATCH' || ':' || acct_cd;
        out_err_flg := 'N';
        out_err_msg := '';
      ELSE
        out_rowid_object := NULL;
        out_pkey_src_obj := NULL;
        out_err_flg := 'Y';
        out_err_msg := 'More than one row found for account Code: ' || acct_cd;
      END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          IF src_nf_ok THEN
           -- No existing record with this account code, treat it as a new account
           out_rowid_object := NULL;
           out_pkey_src_obj := 'BATCH' || ':' || acct_cd;
           out_err_flg := 'N';
           out_err_msg := '';
          ELSE
             out_rowid_object := NULL;
             out_pkey_src_obj := NULL;
             out_err_flg := 'Y';
             out_err_msg := 'No account found for account code: ' || acct_cd;
          END IF;
   END;
   ELSE
     -- No account identifiers provided
     out_rowid_object := NULL;
     out_pkey_src_obj := NULL;
     out_err_flg := 'Y';
     out_err_msg := 'At least one account identifier should be provided';
   END IF;
--
END chk_acct_ids;
--
--
PROCEDURE chk_ptac_ids
(
    ptac_rowid_object      varchar2,
    ptac_sys_name          varchar2,
    ptac_sys_id            varchar2,
    out_rowid_object OUT   varchar2,
    out_err_flg      OUT   char,
    out_err_msg      OUT   varchar2
)
AS
sql_stmt varchar2(2000);
t_src_sys_name  varchar2(10);
t_src_sys_id    varchar2(40);
t_rowid_object  varchar2(14);
t_count         integer;
BEGIN
   IF ptac_rowid_object is not null THEN
   BEGIN
      -- Check if the rowid_object is valid
      sql_stmt := 'select rowid_object from c_bo_party_acct where rowid_object = :rid';
      EXECUTE IMMEDIATE sql_stmt into t_rowid_object using ptac_rowid_object;
      -- Rowid found
      out_rowid_object := ptac_rowid_object;
      out_err_flg := 'N';
      out_err_msg := '';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           out_rowid_object := NULL;
           out_err_flg := 'Y';
           out_err_msg := 'Invalid primary customer rowid object: ' || ptac_rowid_object;
   END;
   ELSIF (ptac_sys_name is NOT NULL and ptac_sys_id is NOT NULL) THEN
   BEGIN
      -- Check if there is an account with the provided source keys
      sql_stmt := 'select rowid_object from c_bo_party_acct_xref where rowid_system = ''' || ptac_sys_name ||
                           ''' and pkey_src_object = ''' || ptac_sys_id || '''';
      --dbms_output.put_line('Executing:' || sql_stmt);
      --dbms_output.put_line('Using rowid_system = ' || ptac_sys_name || ' Sys Id: ' || ptac_sys_id);
      --EXECUTE IMMEDIATE sql_stmt into t_rowid_object using ptac_sys_name, ptac_sys_id;
      EXECUTE IMMEDIATE sql_stmt into t_rowid_object;
      -- Rowid found
      out_rowid_object := t_rowid_object;
      out_err_flg := 'N';
      out_err_msg := '';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           -- No existing PTAC record with this key combo, error
           out_rowid_object := NULL;
           out_err_flg := 'Y';
           out_err_msg := 'No customer record found for provided source keys: ' || ptac_sys_name || ':' || ptac_sys_id;
   END;
   ELSE
     -- No PTAC identifiers provided
     out_rowid_object := NULL;
     out_err_flg := 'N';
     out_err_msg := '';
   END IF;
END chk_ptac_ids;


PROCEDURE post_landing
(
    in_rowid_job            cmxlb.cmx_rowid,
    in_ldg_table_name       cmxlb.cmx_table_name,
    in_stg_table_name       cmxlb.cmx_table_name,
    in_prl_table_name       cmxlb.cmx_table_name,
    out_error_msg      OUT  cmxlb.cmx_message,
    out_return_code    OUT  int
)
AS
t_acc_rowid_object varchar2(14);
t_acc_rowid_object2 varchar2(14);
t_ptac_rowid_object varchar2(14);
t_pkey_src_obj varchar2(100);
t_pkey_src_obj2 varchar2(100);
t_err_flg char(1);
t_err_msg varchar2(2000);
--
TYPE ref_cursor is REF CURSOR;
m_cursor ref_cursor;
--
cursor c_accts is
select acc_rowid_object, account_cd, src_sys_name, src_sys_id, ptac_rowid_object, ptac_src_name, ptac_src_key
from   c_ldg_hm_accounts
for update;
--
cursor c_accts_rel is
select acc_rowid_object_1, account_cd_1, src_sys_name_1, src_sys_id_1,
       acc_rowid_object_2, account_cd_2, src_sys_name_2, src_sys_id_2
from   c_ldg_accounts_rel
for update;
--
cursor c_accts_ptac_rel is
select acc_rowid_object, account_cd, src_sys_name, src_sys_id, ptac_rowid_object, ptac_src_name, ptac_src_key
from   C_LDG_HM_ACCT_PTY_AC_REL
for update;
--
--
BEGIN
    cmxlog.debug ('Inside ADD_UE.post_landing');
    IF in_ldg_table_name = 'C_LDG_HM_ACCOUNTS' AND in_stg_table_name = 'C_STG_HM_ACCTS_BATCH' THEN
    BEGIN
      cmxlog.debug ('ADDUE: Landing table name is ' || in_ldg_table_name || ' Staging table name is ' || in_stg_table_name);
      FOR r_accts in c_accts LOOP
        --Check the account identifiers
        chk_acct_ids (r_accts.acc_rowid_object, r_accts.src_sys_name, r_accts.src_sys_id, r_accts.account_cd, TRUE, t_acc_rowid_object, t_pkey_src_obj, t_err_flg, t_err_msg);
        IF t_err_flg = 'N' THEN
            chk_ptac_ids (r_accts.ptac_rowid_object, r_accts.ptac_src_name, r_accts.ptac_src_key, t_ptac_rowid_object, t_err_flg, t_err_msg);
        END IF;
        UPDATE C_LDG_HM_ACCOUNTS
        SET  cmp_acc_rowid_object = t_acc_rowid_object,
             cmp_pkey_src_obj = t_pkey_src_obj,
             cmp_ptac_rowid_object = t_ptac_rowid_object,
             error_flag = t_err_flg,
             error_msg  = t_err_msg
        WHERE CURRENT OF c_accts;
      END LOOP;
      COMMIT;
    END;
    ELSIF in_ldg_table_name = 'C_LDG_ACCOUNTS_REL' AND in_stg_table_name = 'C_STG_HM_ACCTS_REL_BATCH' THEN
    BEGIN
      cmxlog.debug ('ADDUE: Landing table name is ' || in_ldg_table_name || ' Staging table name is ' || in_stg_table_name);
      FOR r_accts_rel in c_accts_rel LOOP
        --Check the account identifiers
        chk_acct_ids (r_accts_rel.acc_rowid_object_1, r_accts_rel.src_sys_name_1, r_accts_rel.src_sys_id_1, r_accts_rel.account_cd_1, FALSE, t_acc_rowid_object, t_pkey_src_obj, t_err_flg, t_err_msg);
        IF t_err_flg = 'N' THEN
            chk_acct_ids (r_accts_rel.acc_rowid_object_2, r_accts_rel.src_sys_name_2, r_accts_rel.src_sys_id_2, r_accts_rel.account_cd_2, FALSE, t_acc_rowid_object2, t_pkey_src_obj2, t_err_flg, t_err_msg);
        END IF;
        UPDATE C_LDG_ACCOUNTS_REL
        SET  cmp_acc_rowid_object_1 = t_acc_rowid_object,
             cmp_pkey_src_obj = t_pkey_src_obj || ':' || t_pkey_src_obj2,
             cmp_acc_rowid_object_2 = t_acc_rowid_object2,
             error_flag = t_err_flg,
             error_msg  = t_err_msg
        WHERE CURRENT OF c_accts_rel;
      END LOOP;
      COMMIT;
    END;
    ELSIF in_ldg_table_name = 'C_LDG_HM_ACCT_PTY_AC_REL' AND in_stg_table_name = 'C_STG_HM_ACCT_PTAC_BATCH' THEN
    BEGIN
      cmxlog.debug ('ADDUE: Landing table name is ' || in_ldg_table_name || ' Staging table name is ' || in_stg_table_name);
      FOR r_accts_ptac_rel in c_accts_ptac_rel LOOP
        --Check the account identifiers
        chk_acct_ids (r_accts_ptac_rel.acc_rowid_object, r_accts_ptac_rel.src_sys_name, r_accts_ptac_rel.src_sys_id, r_accts_ptac_rel.account_cd, FALSE, t_acc_rowid_object, t_pkey_src_obj, t_err_flg, t_err_msg);
        --
        IF t_err_flg = 'N' THEN
            chk_ptac_ids (r_accts_ptac_rel.ptac_rowid_object, r_accts_ptac_rel.ptac_src_name, r_accts_ptac_rel.ptac_src_key, t_ptac_rowid_object, t_err_flg, t_err_msg);
        END IF;
        --
        --
        IF r_accts_ptac_rel.ptac_src_name is NOT NULL and r_accts_ptac_rel.ptac_src_key IS NOT NULL THEN
            t_pkey_src_obj2 := t_pkey_src_obj || ':' || r_accts_ptac_rel.ptac_src_name || ':' || r_accts_ptac_rel.ptac_src_key;
        ELSE
            t_pkey_src_obj2 := t_pkey_src_obj || ':' || t_ptac_rowid_object;
        END IF;
        --
        --
        UPDATE C_LDG_HM_ACCT_PTY_AC_REL
        SET  cmp_acc_rowid_object = t_acc_rowid_object,
             cmp_pkey_src_obj = t_pkey_src_obj2,
             cmp_ptac_rowid_object = t_ptac_rowid_object,
             error_flag = t_err_flg,
             error_msg  = t_err_msg
        WHERE CURRENT OF c_accts_ptac_rel;
      END LOOP;
      COMMIT;
    END;
    ELSE
      -- Do nothing
      CMXlog.debug ('ADDUE Post Landing - no action taken');
    END IF;
END;
PROCEDURE post_stage_concat
(
    in_party_acct_id varchar2,
    out_txn_div_display    OUT  varchar2
)
AS
--
BEGIN
    with
    stgbo as
    (
    select party_acct_id, TXN_DIV_CD from C_BO_PTAC_TXN_DIV WHERE party_acct_id = in_party_acct_id
    union
    select party_acct_id, TXN_DIV_CD from C_STG_PTAC_TXN_DIV WHERE PARTY_ACCT_ID = in_party_acct_id
    )
    select distinct TRIM(A||' '||B||' '||C||' '||D) into out_txn_div_display from (select party_acct_id, TXN_DIV_CD from stgbo ) pivot( max(TXN_DIV_CD) for TXN_DIV_CD in ( 'ADC' A, 'ADD' B, 'AMD' C,  'APOC' D)) WHERE PARTY_ACCT_ID = in_party_acct_id;
END post_stage_concat;
PROCEDURE post_stage
(
    in_rowid_job            cmxlb.cmx_rowid,
    in_ldg_table_name       cmxlb.cmx_table_name,
    in_stg_table_name       cmxlb.cmx_table_name,
    out_error_msg      OUT  cmxlb.cmx_message,
    out_return_code    OUT  int
)
AS
sql_stmt varchar2(2000);
t_party_acct_id varchar2(14);
t_txn_div_cd varchar2(20);
t_txn_div_display varchar2(50);
commit_count NUMBER := 0;
commit_inc NUMBER := 1000;
--
CURSOR C_PTAC_TXN IS
SELECT PARTY_ACCT_ID, TXN_DIV_CD, TXN_DIV_DISPLAY
FROM   C_STG_PTAC_TXN_DIV;
--
BEGIN
--
    commit_inc := to_number(GET_PARAMETER('post_stage_commit', commit_inc));
    IF in_ldg_table_name = 'C_LDG_PTAC_TXN_DIV' AND in_stg_table_name = 'C_STG_PTAC_TXN_DIV' THEN
    --    20130225 SCK Update the stage txn_div_display col with a denormalized string derived from an aggregate of both staging and base object
        cmxlog.debug ('ADDUE: Landing table name is ' || in_ldg_table_name || ' Staging table name is ' || in_stg_table_name);
        BEGIN
              FOR R_PTAC_TXN in C_PTAC_TXN LOOP
                    post_stage_concat(R_PTAC_TXN.PARTY_ACCT_ID, t_txn_div_display);
                    UPDATE C_STG_PTAC_TXN_DIV
                    SET txn_div_display = t_txn_div_display, create_date = sysdate WHERE TXN_DIV_CD = R_PTAC_TXN.TXN_DIV_CD AND
                    PARTY_ACCT_ID = R_PTAC_TXN.PARTY_ACCT_ID;  -- CURRENT OF C_PTAC_TXN;
                    commit_count := commit_count + commit_inc;
                    IF MOD(commit_count, 1000) = 0 THEN
                        cmxlog.debug ('ADDUE: post_stage_concat is: ' || commit_count || ':' || R_PTAC_TXN.PARTY_ACCT_ID || ' : ' || t_txn_div_display);
                        COMMIT;
                    END IF;
              END LOOP;
              COMMIT;
        END;
    ELSE
      CMXlog.debug ('ADDUE Post Stage - no action taken');
    END IF;
END post_stage;
END ADD_UE;
/
