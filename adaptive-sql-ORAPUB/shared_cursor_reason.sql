/* shared_cursor_reason.sql */

-- From Mustafa Doganay


SELECT reason_not_shared, COUNT (*) cursors, COUNT (DISTINCT sql_id) sql_ids
    FROM gv$sql_shared_cursor
         UNPIVOT (val
                 FOR reason_not_shared
                 IN (UNBOUND_CURSOR,
                    SQL_TYPE_MISMATCH,
                    OPTIMIZER_MISMATCH,
                    OUTLINE_MISMATCH,
                    STATS_ROW_MISMATCH,
                    LITERAL_MISMATCH,
                    FORCE_HARD_PARSE,
                    EXPLAIN_PLAN_CURSOR,
                    BUFFERED_DML_MISMATCH,
                    PDML_ENV_MISMATCH,
                    INST_DRTLD_MISMATCH,
                    SLAVE_QC_MISMATCH,
                    TYPECHECK_MISMATCH,
                    AUTH_CHECK_MISMATCH,
                    BIND_MISMATCH,
                    DESCRIBE_MISMATCH,
                    LANGUAGE_MISMATCH,
                    TRANSLATION_MISMATCH,
                    BIND_EQUIV_FAILURE,
                    INSUFF_PRIVS,
                    INSUFF_PRIVS_REM,
                    REMOTE_TRANS_MISMATCH,
                    LOGMINER_SESSION_MISMATCH,
                    INCOMP_LTRL_MISMATCH,
                    OVERLAP_TIME_MISMATCH,
                    EDITION_MISMATCH,
                    MV_QUERY_GEN_MISMATCH,
                    USER_BIND_PEEK_MISMATCH,
                    TYPCHK_DEP_MISMATCH,
                    NO_TRIGGER_MISMATCH,
                    FLASHBACK_CURSOR,
                    ANYDATA_TRANSFORMATION,
                    PDDL_ENV_MISMATCH,
                    TOP_LEVEL_RPI_CURSOR,
                    DIFFERENT_LONG_LENGTH,
                    LOGICAL_STANDBY_APPLY,
                    DIFF_CALL_DURN,
                    BIND_UACS_DIFF,
                    PLSQL_CMP_SWITCHS_DIFF,
                    CURSOR_PARTS_MISMATCH,
                    STB_OBJECT_MISMATCH,
                    CROSSEDITION_TRIGGER_MISMATCH,
                    PQ_SLAVE_MISMATCH,
                    TOP_LEVEL_DDL_MISMATCH,
                    MULTI_PX_MISMATCH,
                    BIND_PEEKED_PQ_MISMATCH,
                    MV_REWRITE_MISMATCH,
                    ROLL_INVALID_MISMATCH,
                    OPTIMIZER_MODE_MISMATCH,
                    PX_MISMATCH,
                    MV_STALEOBJ_MISMATCH,
                    FLASHBACK_TABLE_MISMATCH,
                    LITREP_COMP_MISMATCH,
                    PLSQL_DEBUG,
                    LOAD_OPTIMIZER_STATS,
                    ACL_MISMATCH,
                    FLASHBACK_ARCHIVE_MISMATCH,
                    LOCK_USER_SCHEMA_FAILED,
                    REMOTE_MAPPING_MISMATCH,
                    LOAD_RUNTIME_HEAP_FAILED,
                    HASH_MATCH_FAILED,
                    PURGED_CURSOR,
                    BIND_LENGTH_UPGRADEABLE,
                    USE_FEEDBACK_STATS))
   WHERE val = 'Y' AND sql_id = trim('&&1')
GROUP BY reason_not_shared
ORDER BY 2 DESC, 3, 1;


