#Crear un Stored Procedure que actualice el stock de los productos teniendo en cuenta los ingresos de esta semana.
delimiter //
create procedure actualizar_stock()
begin
declare hayFilas boolean default 1;
declare items varchar(45) default "";
declare cant int default 0;
declare productosCursor cursor for select sum(cantidad), Producto_codProducto from ingresostock_producto join ingresostock on ingresostock.idIngreso = IngresoStock_idIngreso where fecha >= current_date() - interval 7 day group by Producto_codProducto;
declare continue handler for not found set hayFilas = 0;
open productosCursor;
loopsito:loop
	fetch productosCursor into cant, items;
	if hayFilas = 0 then
		leave loopsito;
	end if;
	update producto set stock = stock + cant where codProducto = items;
	end loop;
close productosCursor;
end//
delimiter ;
drop procedure actualizar_stock;
call actualizar_stock;

#2. Crear un Stored Procedure que reduzca el precio de los productos en un 10% si no se vendieron más de 100 unidades en la semana.
delimiter //
create procedure reducirPrecios()
begin 
declare hayFilas boolean default 1;
declare productito varchar(45) default "";
declare ventasCursor cursor for select Producto_codProducto from pedido_producto group by producto_codProducto having sum(cantidad)<100;
declare continue handler for not found set hayFilas = 0;
open ventasCursor;
rita:loop 
	fetch ventasCursor into productito;
    if hayFilas = 0 then
		leave rita;
	end if;
    update producto set precio = precio * 0.9 where codProducto = productito;
    end loop;
close ventasCursor;
end //
delimiter ;
drop procedure reducirPrecios;
call reducirPrecios;

#3. Crear un Stored Procedure que actualice el precio de los productos. Debe ser un 10% más que el mayor precio al que lo proveen los proveedores
delimiter //
create procedure ganancias()
begin
declare hayFilas boolean default 0;
declare provi varchar(45) default "";
declare maximo int default 0;
declare prod_provisto cursor for select Producto_codProducto, max(precio) from producto_proveedor group by Producto_codProducto;
declare continue handler for not found set hayFilas = 0;
open prod_provisto;
pepo:loop
	fetch prod_provisto into provi, maximo;
    if hayFilas = 0 then
		leave pepo;
	end if;
    update producto set precio = maximo * 1.1 where codProducto = provi;
    end loop;
close prod_provisto;
end //
delimiter ;
call ganancias;

#4. Suponiendo que agregamos una columna llamada “nivel” en la tabla de proveedores, se
#pide realizar un procedimiento que calcule la cantidad de ingresos por proveedor en los
#últimos 2 meses y actualice el nivel del proveedor. Los niveles son “Bronce” hasta 50
#ingresos inclusive, “Plata” de 50 a 100 ingresos inclusive y “Oro” más de 100.

alter table proveedor add column nivel text;
delimiter //
create procedure niveles()
begin
declare hayFilas boolean default 1;
declare cant_ingresos int default 0;
declare provi int default 0;
declare ingresosCursor cursor for select count(*), Proveedor_idProveedor from ingresostock where fecha >= (current_date() - interval 2 month) group by Proveedor_idProveedor;
declare continue handler for not found set hayFilas = 0;
open ingresosCursor;
p:loop
	fetch ingresosCursor into cant_ingresos, provi;
    if hayFilas = 0 then
		leave p;
	end if;
    if cant_ingresos <= 50 then 
		update proveedor set nivel = "Bronce" where idProveedor = provi;
	else if cant_ingresos > 50 and cant_ingresos <= 100 then
		update proveedor set nivel = "Plata" where idProveedor = provi;
	else 
		update proveedor set nivel = "Oro" where idProveedor = provi;
	end if;
    end if;
    end loop;
close ingresosCursor;
end //
delimiter ;
call niveles();

#5. Realice un procedimiento que actualice el precio unitario de los productos que están en 
#pedidos pendientes de pago, al precio actual del producto.
delimiter //
create procedure precioPedido()
begin 
declare hayFilas boolean default 1; 
declare precioPendientes int default 0;
declare productito int default 0;
declare precioCursor cursor for select precio, codProducto from producto join pedido_producto on Producto_codProducto = producto.codProducto join pedido on Pedido_idPedido = pedido.idPedido join estado on Estado_idEstado = estado.idEstado where nombre = "Pendiente";
declare continue handler for not found set hayFilas = 0;
open precioCursor;
pendientes:loop
	fetch precioCursor into precioPendientes, productito;
    if hayFilas = 0 then 
		leave pendientes;
	end if;
    update pedido_producto set precioUnitario = precioPendientes where Producto_codProducto = productito;
    end loop;
close precioCursor;
end //
delimiter ;
drop procedure precioPedido;
call precioPedido();
