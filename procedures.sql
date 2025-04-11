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
create procedure getCiudadesOffices (out listadoCiudades varchar(4000))
begin
	declare hayFilas boolean default 1;
	declare ciudadObtenida varchar(45) default "";
	declare ciudadesCursor cursor for select city from offices;
	declare continue handler for not found set hayFilas = 0;
	set listadoCiudades = "";
	open ciudadesCursor;
	elLoop:loop
		fetch ciudadesCursor into ciudadObtenida;
		if hayFilas = 0 then
			leave elLoop;
		end if;
		set listadoCiudades = concat(ciudadObtenida, ", ", listadoCiudades);
	end loop elLoop;
	close ciudadesCursor;
end//
delimiter ;
drop procedure getCiudadesOffices;
call getCiudadesOffices(@listadoCiudades);
select @listadoCiudades;

#10
create table cancelledOrders(
	orderNumber int primary key,
    orderDate date,
    shippedDate date,
    customerNumber int
);

delimiter //
create procedure insertCancelledOrders (out cant_cancelados int)
begin
declare hayFilas boolean default 1;
declare variable1, variable4 int;
declare variable2, variable3 date;
declare ordenesCursor cursor for select orderNumber, orderDate, shippedDate, customerNumber from orders where status = "Cancelled";
declare continue handler for not found set hayFilas = 0;
open ordenesCursor;
ordenesLoop:loop
	fetch ordenesCursor into variable1, variable2, variable3, variable4;
	if hayFilas = 0 then
	leave ordenesLoop;
	end if;
	insert into cancelledOrders values(variable1, variable2, variable3, variable4);
end loop ordenesLoop;
close ordenesCursor;
select count(*) into cant_cancelados from cancelledOrders;
end//
delimiter ;
call insertCancelledOrders(@cant_cancelados);
select @cant_cancelados;

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
 call alterCommentOrder;


# 12 - Crear un SP que devuelva en un parámetro de salida los telefonos de los clientes que
#      cancelaron una orden y no volvieron a comprar.
drop procedure telefonos;
delimiter //
create procedure  telefonos (out listadoTelefonos text)
begin
	declare hayFilas boolean default 1;
	declare telActual text;
    declare numActual int;
    declare ultimaFecha date;
	declare cursor_telefonos cursor for select distinct phone,orders.customerNumber from customers 
	join orders on customers.customerNumber = orders.customerNumber where status = "Cancelled";
	declare continue handler for not found set hayFilas=0;
    set listadoTelefonos = "";
	open cursor_telefonos;
	pepo:loop 
		fetch cursor_telefonos into telActual,numActual;
		if hayFilas = 0 then 
			leave pepo;
		end if;	
        select max(orderDate) into ultimaFecha from orders where orders.customerNumber = numActual and status = "Cancelled";
		if not exists (select * from orders where orderDate > ultimaFecha and orders.customerNumber = numActual) then
			set listadoTelefonos = concat(telActual, ", ", listadoTelefonos);
		end if;
	end loop pepo;
    close cursor_telefonos;
end//
delimiter ;
call telefonos(@listadoTelefonos);
select @listadoTelefonos;
