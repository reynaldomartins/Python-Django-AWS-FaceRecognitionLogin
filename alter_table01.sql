ALTER TABLE tbemployee
ADD username char(20); 

ALTER TABLE tbemployee
ADD constraint fk_tbEmployee_auth_user FOREIGN KEY (username) REFERENCES auth_user(username); 