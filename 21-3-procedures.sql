#1
delimiter //
create procedure mostrar_productos(out cant int)
begin
	select * from products where buyPrice > (select avg(buyPrice) from products);
	select count(*) into cant from products where buyPrice > (select avg(buyPrice) from products);
end//
delimiter ;
drop procedure mostrar_productos;
call mostrar_productos(@lolo);

select @lolo;

#2
delimiter //
create procedure P2(in n int, out cant int) 
begin 
select count(*) into cant from orderdetails where orderNumber = n;
delete from orderdetails where orderNumber = n;
end//
delimiter ;
call P2(10100, @cant);
select(@cant);

#3 
delimiter //
create procedure eliminar_lineaa(in linea text,out mensaje text)
begin
	if (select contador_productos(linea)=0) then 
		delete from productlines where productlines.productLine;
		set mensaje = "la linea de producto fue borrada";
	else
		set mensaje = "la linea de producto no se pudo borrar porque tiene productos asociados";
	end if;
end//
delimiter ;
