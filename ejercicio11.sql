#11
delimiter //
create procedure alterCommentOrder(in customerNumero int)
begin
	declare hayFilas boolean default 1;
    declare comentarioObtenido varchar(45) default "";
	declare comentarioCursor cursor for select comments from orders where customerNumber = customerNumero;
	declare continue handler for not found set hayFilas = 0;
	open comentarioCursor;
	miLoop:loop
		fetch comentarioCursor into comentarioObtenido;
		if hayFilas = 0 then
			leave miLoop;
		end if;
		update orders set comments = "El total de la orden es … ";
    end loop miLoop;
	close comentarioCursor;
end//
delimiter ;