#1
create table customers_audit(
	idAudit int auto_increment not null primary key,
    Operacion char(6),
    User text,
    Last_date_modified date,
    customerNumber int,
    customerName text,
    phone int
);
#1) a)
delimiter //
create trigger after_insert_customers after insert on customers for each row
begin
	insert into customers_audit values (null,"insert",current_user(),current_date(),new.customerNumber,new.customerName,new.phone);
end//
delimiter ;

#1) b)
delimiter //
create trigger before_update_customers before update  on customers for each row
begin
	insert into customers_audit values (null,"update",current_user(),current_date(),old.customerNumber,old.customerName,old.phone);
end//
delimiter ;

#1) c)
delimiter //
create trigger before_delete_customers before delete on customers for each row
begin
	insert into customers_audit values (null,"delete",current_user(),current_date(),old.customerNumber,old.customerName,old.phone);
end//
delimiter ;

#2)
create table employees_audit(
	idAudit int,
    Operacion char(6),
    User text,
    Last_date_modified date,
	employeeNumber int,
    email varchar(100)
);

delimiter //
create trigger after_insert_employees after insert on customers for each row
begin
	insert into employees_audit values (null,"insert",current_user(),current_date(),new.customerNumber,new.customerName,new.email);
end//
delimiter ; 
delimiter //
create trigger before_update_employees before update on employees for each row
begin
	insert into employees_audit values (null,"update",current_user(),current_date(),old.customerNumber,old.customerName,old.mail);
end//
delimiter ;
delimiter //
create trigger before_delete_employees before delete on employees for each row
begin
	insert into employees_audit values (null,"delete",current_user(),current_date(),old.customerNumber,old.customerName,old.mail);
end//
delimiter ;

#3
delimiter //
create trigger producto_con_ordenes_asociadas before delete on products for each row
begin
	declare hayFilas bool default true;
    declare cantidad int default 0;
    select count(*) into cantidad from orders join orderdetails on orders.orderNumber = orderdetails.orderNumber
    where OrderDate > (current_date - interval 2 month) and old.productCode = orderdetails.productCode;
    if (cantidad > 0) then 
		signal sqlstate "45000" set message_text = "Error, tiene órdenes asociadas";
	end if;
end//
delimiter ;
delete from products where productCode = "S10_1678";