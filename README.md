# MySQL / PostgreSQL DDL


<details>
  <summary>
    <p align="center">
    Sample Database Schema SQL DDL 🍭 Multi-tenant SaaS
    </p>
  </summary>
  <p align="center">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvs.svg" width="76" alt="Vivid Vector ✨ JavaScript && TypeScript && Go 🪐">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvq.svg" width="76" alt="🚀Go TypeScript ⚡ WASM ✨ NestJS">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvl.svg" width="76" alt="Vivid DataVis 🚀 Micro Frontend 🚀 PWA Skulduggery DataVis 🚀 Micro Frontend 🚀 PWA">
      <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvspace.svg" width="33" alt="Vivid Vector 👁️ D3 Parallax Three.js Greensock && WebGL 🍭">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvd.svg" width="76" alt="Vivid Vector ✨ Cypress && JavaScript && TypeScript && Go 🪐">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvd.svg" width="76" alt="Vivid Vector Skulduggery 🚀 PWA">
  <img src="https://neodigm.github.io/vivid_vector_alphabet/wasm/vvl.svg" width="76" alt="👁️ D3 Parallax Three.js Greensock && WebGL 🍭">
  </p>
</details>

  <img src="http://neodigm.github.io/eres_platform_2-14/scott_krause_database_er_design.webp" alt="Sample Database Schema SQL DDL 🐒 Multi-tenant SaaS">

```sql
CREATE TABLE IF NOT EXISTS `email_tmpl` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key / Auton',
  `created_at` datetime NOT NULL COMMENT 'audit: eloquent ORM',
  `email_tmpl_nm` varchar(32) NOT NULL COMMENT 'Email Template Name',
  `email_tmpl_desc` varchar(176) DEFAULT NULL COMMENT 'Email Template Description',
  `subject_text` varchar(96) DEFAULT NULL COMMENT 'Subject of Message (Token Pattern)',
  `from_address` varchar(32) NOT NULL COMMENT 'From email address',
  `from_nm` varchar(32) NOT NULL COMMENT 'From Name',
  `body_markup` blob COMMENT 'Message Rich Text (Token Pattern)',
  `body_text` blob NOT NULL COMMENT 'Message Plain Text (Token Pattern)',
  `attachment_1` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  `attachment_2` varchar(176) DEFAULT NULL COMMENT 'abs path (Token Pattern)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
```
<a href="https://gist.github.com/neodigm/a9272cbf44d4a35c134ddc90f530d38e" target="_blank">Oracle PL/SQL Stored Procedure</a>

```sql
--  ███████  ██████  ██      
--  ██      ██    ██ ██      
--  ███████ ██    ██ ██      
--       ██ ██ ▄▄ ██ ██      
--  ███████  ██████  ███████  Relational ⚡ Transactional | SQL DDL 🐒 Multi-tenant SaaS
--              ▀▀           
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
    --    20130225 SCK Update the stage txn_div_display col with a denormalized string derived
    --    from an aggregate of both staging and base object. 
    --    🏄 SQL ⚡ ETL MDM ⚡ PL/SQL ORM
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
```

[Currated Emerging Tech](https://www.thescottkrause.com/tags/curated/)

#
[Portfolio Blog](https://www.theScottKrause.com) |
[🌶️ Résumé](https://thescottkrause.com/Arcanus_Scott_C_Krause_2023.pdf) |
[UX micro-library](https://thescottkrause.com/emerging_tech/neodigm55_ux_library/) |
[PWA WASM](https://www.thescottkrause.com/emerging_tech/curated-pwa-links/) |
[DevToys](https://www.thescottkrause.com/devtoys/) |
[Neodigm UX Wiki](https://github.com/arcanus55/neodigm55/wiki/Cheat-Sheet) | 
[NPM](https://www.npmjs.com/~neodigm) |
[Github](https://github.com/neodigm) |
[LinkedIn](https://www.linkedin.com/in/neodigm555/) |
[Gists](https://gist.github.com/neodigm?direction=asc&sort=created) |
[Salesforce](https://trailblazer.me/id/skrause) |
[Code Pen](https://codepen.io/neodigm24) |
[Machvive](https://www.machfivemarketing.com/accelerators/google_analytics_ga4_migration/) |
[Arcanus 55](https://www.arcanus55.com/?trusted55=A55PV2) |
[Medium](https://medium.com/@neo5ive/accessibility-%EF%B8%8F-ecommerce-552d4d35cd66) |
[W3C](https://www.w3.org/users/123844) |
[InfoSec](https://arcanus55.medium.com/offline-vs-cloud-password-managers-51b1fbebe301)
#
<p align="center">
	  <a target="_blank" href="https://www.thescottkrause.com/emerging_tech/cytoscape_dataviz_skills/">
	  	<img src="https://neodigm.github.io/brand_logo_graphic_design/fantastic/discerning/22.webp" alt="TypeScript UX 🪐 Interactive Infographic ⚡ WASM ✨ PWA 🍭 Svelte">
	  </a>
</p>

<p align="center">
  <a target="_blank" href="https://www.thescottkrause.com">
    <img src="https://neodigm.github.io/pan-fried-monkey-fisticuffs/thescottkrause_contact_card.png" title="UX PWA TypeScript ⚡ WASM ✨ Vue.js 🍭 ThreeJS 🌶️ HTMLX" alt="Interactive Infographic">
  </a>
</p>
