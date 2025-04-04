#1-1- Crear una Stored Function que reciba un id de cliente e indique si es o no frecuente. Es
# frecuente si realizó al menos un 5% de las compras totales, en los últimos 6 meses.
select * from cliente;
delimiter //
create function es_frecuente(numero_cliente int) returns varchar(45) deterministic
begin
	declare cant_compras int default 0;
    declare compras_cliente int default 0;
    declare es varchar(45) default "no es frecuente";
    select count(*) into cant_compras from pedido where fecha > "2024-10-04";
    select count(*) into compras_cliente from pedido where Cliente_codCliente = numero_cliente;
	if compras_cliente >= (cant_compras * 0.05) then
		set es = "frecuente";
    end if;
return es;
end //
delimiter ;
select es_frecuente(1);

#1-4- Crear una Stored Function que reciba un id de cliente y devuelva la cantidad de pedidos
# pendientes de pago de ese cliente.

delimiter //
create function pagos_pendientes(num_cliente int) returns int deterministic
begin
	declare pendientes int default 0;
	select count(*) into pendientes from estado join pedido on idEstado = Estado_idEstado where nombre = "pendiente" and Cliente_codCliente = num_cliente;
return pendientes;
end //
delimiter ;
select pagos_pendientes("a");

#2-2- Crear una Stored Function que reciba un código de producto y devuelva el precio
# promedio al que lo proveen todos los proveedores.

delimiter //
create function precio_promedio(cod_producto int) returns int deterministic
begin
	declare promedio int default 0;
	select avg(precio) into promedio from producto_proveedor where Producto_codProducto = cod_producto;
	return promedio;
end //
delimiter ;
select precio_promedio(1);

#3-1- Crear una stored function que dado el id de una función, devuelva la cantidad de entradas
#compradas para esa función.

delimiter // 
create function entradas(id int) returns int deterministic
begin
declare cant_compras int default 0;
select count(*) into cant_compras from compra where funcion_idFuncion = id;
return cant_compras;
end //
delimiter ;

#3-2- Crear una stored function que reciba el id de un cliente, calcule y retorne los puntos a favor.
# Considerar que los puntos representan el 25% de lo que gastó el mes pasado.

delimiter //
create function calcular_puntos(id int) returns int deterministic
begin
declare puntos float default 0;
set puntos = 0.25 * (select sum(cantEntradas * valorEntrada) from compra join funcion on funcion_idFuncion = funcion.idFuncion where cliente_idCliente = id and timestampdiff(month,fecha,current_date())=1);
return puntos;
end //
delimiter ; 	
