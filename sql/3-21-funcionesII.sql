#1

delimiter //
create function nivel_empleado(codigo_empleado int) returns int deterministic 
begin
declare cantidad int default 0;
declare nivel int default 0;
select count(*) into cantidad from employees where reportsTo = codigo_empleado;
if cantidad >= 20 then
set nivel = 3;
else if cantidad >10 and cantidad < 20 then
set nivel = 2;
else 
set nivel = 1;
end if;
end if;
return nivel;
end //
delimiter ;
drop function nivel_empleado;
select nivel_empleado(1143);

#2
delimiter //
create function dias_pasados(fecha_orden date, fecha_llegada date) returns int deterministic 
begin
declare cant int default 0;
select datediff(fecha_orden, fecha_llegada) into cant;
return cant;
end//
delimiter ;
drop function dias_pasados;
select dias_pasados("2024-01-20","2024-01-15");

#3    
delimiter //
create function ordenes() returns int deterministic
begin
declare modificados int default 0;
select count(*) into modificados from orders where dias_pasados(orderDate, shippedDate) > 10;
update orders set status = "Cancelled" where dias_pasados(orderDate, shippedDate) >= 10;
return modificados;
end //
delimiter ;
drop function ordenes;
select ordenes();

#4
delimiter //
create function eliminar_producto(n_orden int, n_prod varchar(15)) returns int deterministic
begin
declare numerin int default 0;
select quantityOrdered into numerin from orderdetails where orderNumber=n_orden and productCode=n_prod;
delete from orderdetails where orderNumber=n_orden and productCode=n_prod;
return numerin;
end //
delimiter ;
drop function eliminar_producto;
select eliminar_producto(10100,"S18_1749");

#5
delimiter // 
create function stock(cod_producto varchar(45)) returns text deterministic
begin 
declare cant_stock int default 0;
declare cuanto varchar(45);
select quantityInStock into cant_stock from products where cod_producto = products.productCode;
if cant_stock >5000 then 
set cuanto = "Sobrestock";
else if cant_stock > 1000 and cant_stock < 5000 then 
set cuanto = "Stock Adecuado";
else 
set cuanto = "BajoStock";
end if;
end if;
return cuanto;
end //
delimiter ;
drop function stock;
select stock("S10_4698");
