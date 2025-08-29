#Crear un evento que se ejecute diariamente y cambie el estado de los pedidos cuya
#fecha de entrega ya pasó pero aún están marcados como "In Process" a "Delayed".

delimiter //
create procedure cambioEstado()
begin 
update orders set status = "Shipped" where shippedDate <= current_date() and status = "In Process" or status = "Delayed";
end //

create event actualizarEstado on schedule every 1 day starts now() do
begin 
call cambioEstado();
end //
delimiter ;

#2 Crear un evento que cada mes elimine los pagos realizados hace más de 5 años.
delimiter //
create procedure eliminarPagos()
begin 
delete from payments where paymentDate <= (current_date() - interval 5 year);
end // 

create event actualizarPagos on schedule every 1 month starts now() do
begin 
call eliminarPagos();
end //
delimiter ;

#3 Crea un evento que cada mes identifique a los clientes que han realizado más de 10
#  pedidos en el último año y les agregue un 10% de crédito extra en creditLimit. Esto se
#  debe realizar hasta el año que viene.
delimiter //
create procedure agregarCredito()
begin
update customers set creditLimit = creditLimit * 1.1 where customerNumber in (select customerNumber from orders where orderDate >= (current_date() - interval 1 year) group by customerNumber having count(*) > 10);
end //

create event cambiarCredito on schedule every 1 month starts now() ends now() + interval 1 year do
begin 
call agregarCredito();
end//
delimiter ;

#4 Crear un evento que a partir del día de mañana a las 7AM y una vez por semana, revise
#  si hay pagos pendientes de verificar y los marque como "Confirmed" si han pasado más
#  de 7 días
delimiter //
create procedure chequearPendientes()
begin
update orders set status = "Confirmed" where orderDate <= (current_date() - interval 7 day) and status != "Confirmed";
end //

create event cambioStatus on schedule every 1 week starts ("2025-05-24 7:00:00") do
begin 
call chequearPendientes();
end //
delimiter ;

#5 Crear un evento que realice un reporte diario de ventas. Para esto se debe crear una
#  tabla de reportes que contenga, id del reporte, fecha del mismo y total de ventas. El
#  evento debe generar un reporte de ventas todos los días a las 23:59, pero solo durante
#  el próximo trimestre.
create table Reportes(
	idReporte int primary key,
    fechaReporte date,
    totalVentas int
);
delimiter //
create procedure ReporteDiario()
begin 
select count(*) from orders where orderDate = current_date();
end //

create event Reportes on schedule every 1 day starts timestamp(now() + interval 1 month, "23:59:00") ends now() + interval 4 month do
begin 
call ReporteDiario();
end //
delimiter ;

#6 Crear un evento que cada 6 meses reduzca un 5% el precio de los productos que no
#  tengan ventas recientes. Debe iniciar el 1 de julio de 2025.
delimiter // 
create procedure ventasRecientes()
begin
update products set buyPrice = buyPrice * 0.95 where productCode in (select productCode from orderdetails join orders on orderNumber = orderdetails.orderNumber where orderDate <= (current_date() - interval 1 week));
end//

create event actualizarPrecio on schedule every 6 month starts ("2025-06-01") do
begin 
call ventasRecientes();
end // 
delimiter ;

