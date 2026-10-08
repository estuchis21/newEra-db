CREATE OR REPLACE FUNCTION existeUsername (p_username varchar)
returns boolean
language plpgsql

as $$ 
begin
	
	return exists (
		select 1 from users where users.username = p_username
	);

end;
$$;

	