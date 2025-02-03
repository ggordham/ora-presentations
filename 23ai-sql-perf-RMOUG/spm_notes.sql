column foreground_last_verified format a30

select p.plan_name, p.foreground_last_verified,
       pfspm.status result, pfspm.ver verify_type,
       pfspm.test_phv, pftp.elps, pfspm.ref_phv, pfrp.elps
from dba_sql_plan_baselines p,
    XMLTABLE(
         '/notes'
         passing xmltype(p.notes)
         columns
             plan_id         NUMBER    path 'plan_id',
             flags           NUMBER    path 'flags',
             fg_spm          XMLType   path 'fg_spm') pf,
     XMLTABLE(
         '/fg_spm'
         passing pf.fg_spm
         columns
             test_phv        NUMBER         path 'test_phv',
             ref_phv         NUMBER         path 'ref_phv',
             ver             VARCHAR2(8)    path 'ver',
             status          VARCHAR2(8)    path 'status',
             ref_perf        XMLType        path 'ref_perf',
             test_perf       XMLType        path 'test_perf' ) pfspm,
    XMLTABLE(
        '/ref_perf'
        passing pfspm.ref_perf
        columns
             bg              NUMBER         path 'bg',
             cpu             NUMBER         path 'cpu',
             elps            NUMBER         path 'elps' ) pfrp,
    XMLTABLE(
        '/test_perf'
        passing pfspm.test_perf
        columns
             bg              NUMBER         path 'bg',
             cpu             NUMBER         path 'cpu',
             elps            NUMBER         path 'elps' ) pftp
where notes is not null
and p.sql_handle = 'SQL_2044b318726d1c30'
order by p.foreground_last_verified
;

