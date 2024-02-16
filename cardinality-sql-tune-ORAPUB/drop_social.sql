/* add_social.sql */

-- drop the social_id column
ALTER TABLE sh.customers DROP COLUMN social_id;

-- re-gather basic statistics
@@stats.sh

