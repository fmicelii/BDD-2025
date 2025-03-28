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
create procedure eliminar_linea(in linea text,out mensaje text)
begin
	if (select contador_productos(linea)=0) then 
		delete from productlines where productlines.productLine;
		set mensaje = "la linea de producto fue borrada";
	else
		set mensaje = "la linea de producto no se pudo borrar porque tiene productos asociados";
	end if;
end//
delimiter ;
call eliminar_linea("Classic Cars");

#4
delimiter //
create procedure cant_ordenes()
begin
	select count(orderNumber),orders.status from orders group by orders.status;
end//
delimiter ;

drop procedure cant_ordenes;
call cant_ordenes();

#5
delimiter //
create procedure empleados_a_cargo(in codigo int)
begin
	select count(*) from employees where reportsTo = codigo;
end//
delimiter ;
call empleados_a_cargo(1002);

#6
delimiter //
create procedure orden_precio()
begin
	select sum(priceEach*quantityOrdered),orderNumber from orderdetails group by orderNumber;
end//
delimiter ;
drop procedure orden_precio;
call orden_precio();

#7
delimiter //
create procedure datos_cliente()
begin 
	select customers.customerNumber,customerName,orders.orderNumber,sum(priceEach*quantityOrdered) from customers join orders on customers.customerNumber = orders.customerNumber join orderdetails on orders.orderNumber = orderdetails.orderNumber group by orders.orderNumber;
end//
delimiter ;
drop procedure datos_cliente;
call datos_cliente();

#9
delimiter //
create procedure 