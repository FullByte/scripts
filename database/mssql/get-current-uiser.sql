
--Functions returning login
SELECT original_login() -- original login name not impersonated one
UNION
SELECT suser_name()
UNION
SELECT suser_sname()
UNION
SELECT system_user


--Functions returning database user
SELECT session_user
UNION
SELECT current_user
UNION
SELECT user_name()
UNION
SELECT user
