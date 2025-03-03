INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (2, 'student01', 'student01', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
 VALUES (3, 'student02', 'student02', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (4, 'student03', 'student03', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (5, 'student04', 'student04', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (6, 'student05', 'student05', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (7, 'student06', 'student06', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (8, 'student07', 'student07', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (9, 'student08', 'student08', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (10, 'student09', 'student09', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (11, 'student10', 'student10', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (12, 'student11', 'student11', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');
INSERT INTO system (id, display_nm, username, host, port, authorized_keys, status_cd)
  VALUES (13, 'student12', 'student12', 'lvcsqlgg01', 22, '~/.ssh/authorized_keys', 'FAILED');

INSERT INTO profiles (id, nm, desc) VALUES (1, 'student01', NULL);
INSERT INTO profiles (id, nm, desc) VALUES (2, 'student02', NULL);
INSERT INTO profiles (id, nm, desc) VALUES (3, 'student03', '');
INSERT INTO profiles (id, nm, desc) VALUES (4, 'student04', '');
INSERT INTO profiles (id, nm, desc) VALUES (5, 'student05', '');
INSERT INTO profiles (id, nm, desc) VALUES (6, 'student06', '');
INSERT INTO profiles (id, nm, desc) VALUES (7, 'student07', '');
INSERT INTO profiles (id, nm, desc) VALUES (8, 'student08', '');
INSERT INTO profiles (id, nm, desc) VALUES (9, 'student09', '');
INSERT INTO profiles (id, nm, desc) VALUES (10, 'student10', '');
INSERT INTO profiles (id, nm, desc) VALUES (11, 'student11', '');
INSERT INTO profiles (id, nm, desc) VALUES (12, 'student12', '');

INSERT INTO system_map (profile_id, system_id) VALUES (1,2);
INSERT INTO system_map (profile_id, system_id) VALUES (2,3);
INSERT INTO system_map (profile_id, system_id) VALUES (3,4);
INSERT INTO system_map (profile_id, system_id) VALUES (4,5);
INSERT INTO system_map (profile_id, system_id) VALUES (5,6);
INSERT INTO system_map (profile_id, system_id) VALUES (6,7);
INSERT INTO system_map (profile_id, system_id) VALUES (7,8);
INSERT INTO system_map (profile_id, system_id) VALUES (8,9);
INSERT INTO system_map (profile_id, system_id) VALUES (9,10);
INSERT INTO system_map (profile_id, system_id) VALUES (11,12);
INSERT INTO system_map (profile_id, system_id) VALUES (12,13);

INSERT INTO user_map (user_id, profile_id) VALUES (2,1);
INSERT INTO user_map (user_id, profile_id) VALUES (3,2);
INSERT INTO user_map (user_id, profile_id) VALUES (4,3);
INSERT INTO user_map (user_id, profile_id) VALUES (5,4);
INSERT INTO user_map (user_id, profile_id) VALUES (6,5);
INSERT INTO user_map (user_id, profile_id) VALUES (7,6);
INSERT INTO user_map (user_id, profile_id) VALUES (8,7);
INSERT INTO user_map (user_id, profile_id) VALUES (9,8);
INSERT INTO user_map (user_id, profile_id) VALUES (10,9);
INSERT INTO user_map (user_id, profile_id) VALUES (11,10);
INSERT INTO user_map (user_id, profile_id) VALUES (12,11);
INSERT INTO user_map (user_id, profile_id) VALUES (13,12);


