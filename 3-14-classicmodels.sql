#1
delimiter //
create function ordenes(fecha_inicio date, fecha_fin date, estado text) returns int deterministic
begin 
declare cant_ordenes int default 0;
select count(*) into cant_ordenes from orders where status = estado and orderDate between fecha_inicio and fecha_fin;
return cant_ordenes;
end// 
delimiter ; 

select ordenes("2003-11-09", "2003-12-09", "shipped");

#2
delimiter //
create function entregas(fecha_1 date, fecha_2 date) returns int deterministic
begin
declare cant_entregas int default 0;
select count(*) into cant_entregas from orders where status = "Shipped" and shippedDate between fecha_1 and fecha_2;
return cant_entregas;
end//
delimiter ;

select entregas("2003-09-05", "2003-11-07");

#3
delimiter //
create function ciudad_empleado(nro_cliente int) returns text deterministic
begin
declare ciudad text;
select offices.city into ciudad from offices join employees on offices.officeCode=employees.officeCode join customers on salesRepEmployeeNumber=employeeNumber where nro_cliente =customerNumber;
return ciudad;
end//
delimiter ;
drop function ciudad_empleado;
select ciudad_empleado(103);

#4
delimiter //
create function	contador_productos(prod_linea text) returns int deterministic
begin
declare cant_productos int default 0;
select count(*) into cant_productos from products where productLine = prod_linea;
return cant_productos;
end//
delimiter ;
drop function contador_productos;
select contador_productos("Motorcycles");

#5
delimiter //
create function cant_clientes(nro_oficina int) returns int deterministic
begin 
declare clientesitos int default 0;
select count(*) into clientesitos from customers join employees on salesRepEmployeeNumber = employeeNumber where nro_oficina=officeCode;
return clientesitos;
end//
delimiter ;
drop function cant_clientes;
select cant_clientes(1);

#6
delimiter //
create function cant_ordenes(nro_oficina int) returns int deterministic
begin 
declare ordensitas int default 0;
select count(*) into ordensitas from orders join customers on customers.customerNumber=orders.customerNumber join employees on salesRepEmployeeNumber = employeeNumber where nro_oficina=officeCode;
return ordensitas;
end//
delimiter ;
drop function cant_ordenes;
select cant_ordenes(1);

#7
delimiter //
create function beneficio(nro_orden int, nro_producto text) returns int deterministic 
begin
declare beneficio_obtenido int default 0;
select (priceEach-buyPrice) into beneficio_obtenido from products join orderdetails on orderdetails.productCode = products.productCode where orderdetails.productCode = nro_producto and orderNumber = nro_orden;
return beneficio_obtenido;
end //
delimiter ;
drop function beneficio;
select beneficio(10100, "S18_1749");

#8
delimiter //
create function estado(nro_orden int) returns int deterministic
begin
declare estado_producto varchar(45);
select status into estado_producto from orders where orderNumber = nro_orden;
if estado_producto = 'Cancelled' then
set estado_producto = -1;
else if estado_producto = 'Shipped' then
set estado_producto = 0;
end if; 
end if;
return estado_producto;
end // 
delimiter ;
select estado (10102);

#9 
delimiter // 
create function primera_orden(n_cliente int) returns date deterministic
begin 
return (select orderDate from orders where customerNumber = n_cliente order by orderDate desc limit 1);
end//
delimiter ;
drop function primera_orden;
select primera_orden(103);

#10
delimiter //
create function porcentaje(n_producto int) returns float deterministic
begin
declare var int default 0;-- falta calcular total
declare total default 0;
select count(*) into var from products where buyPrice < MSRP and n_producto = productCode;
select count(*) into total from products where n_producto = productCode;
return 100*(var/total);
end//
delimiter ;

