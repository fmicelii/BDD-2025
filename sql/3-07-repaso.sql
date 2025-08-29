#1
select nombre from proveedor where ciudad = "La Plata";


#2
delete from articulo where codigo!=(select articulo_codigo from compuesto_por where material_codigo <= 0);

#3
select articulo.codigo, articulo.descripcion from articulo join compuesto_por on articulo_codigo=articulo.codigo join provisto_por on provisto_por.material_codigo=compuesto_por.material_codigo join proveedor on proveedor_codigo=proveedor.codigo where proveedor.nombre = "Lopez SA";

#4
select proveedor.codigo, proveedor.nombre from proveedor join provisto_por on proveedor_codigo=proveedor.codigo join compuesto_por on compuesto_por.material_codigo=provisto_por.material_codigo join articulo on articulo.codigo=compuesto_por.articulo_codigo where precio>10000;

#5
select codigo from articulo where precio =(select max(precio) from articulo);

#6
select articulo.descripcion from articulo join tiene on articulo_codigo=articulo.codigo where stock=(select max(stock) from tiene);

#7
select almacen.codigo from almacen join tiene on almacen_codigo=almacen.codigo join articulo on tiene.articulo_codigo=articulo.codigo join compuesto_por on compuesto_por.articulo_codigo=articulo.codigo where compuesto_por.material_codigo=2;

#8
select articulo.descripcion from articulo join compuesto_por on articulo_codigo=articulo.codigo having count(*)> 0;

#9
update articulo set precio=(precio*1.2) where (select stock from tiene where stock>=20);

#10
select avg(cantidad) from (select count(material_codigo) as cantidad from compuesto_por group by articulo_codigo)as subconsulta;

#11
select min(precio), max(precio), avg(promiedos) from articulo join (select count(articulo_codigo) as promiedos from tiene) as subconsulta2;

#12
select sum(stock*precio) from tiene join articulo on articulo_codigo=articulo.codigo join almacen on almacen.codigo=almacen_codigo group by almacen.codigo;

#13
select sum(stock*precio) from tiene join articulo on articulo_codigo=articulo.codigo join almacen on almacen.codigo=almacen_codigo where stock > 100 group by articulo.codigo;

#14
select descripcion from articulo join compuesto_por on articulo_codigo=articulo.codigo where precio>= 5000 group by articulo_codigo having count(material_codigo)>3;

#15
select material.descripcion from material join compuesto_por on material.codigo=material_codigo join articulo on articulo.codigo=articulo_codigo where precio >(select avg(precio) from articulo join tiene on articulo_codigo=articulo.codigo where almacen_codigo = 2); 
