use ecommerce;

-- Updated EER Diagram accordingly with the tables we created in class: Some attributes were missing, some had different length, some had missing parameters and default values, others had wrong types attributed to them.

-- Added attribute "Bdate" (birthday date) to table "clients" and inserted values to these new attributes.
alter table clients add Bdate date;
update clients set Bdate = 
	case
		when CPF = 12346789 then '1990-01-01'
        when CPF = 987654321 then '2000-06-11'
        when CPF = 45678913 then '1983-11-09'
        when CPF = 789123456 then '1996-06-29'
        when CPF = 98745631 then '1950-09-20'
        when CPF = 654789123 then '1977-12-03'
	end;
    
-- Added attribute "Price" and "Description" to table "Product". Inserted values to these new attributes.
alter table product
	add Price float,
	add Description varchar(255);
update product set Price =
	case
		when idProduct = 1 then 50.00
		when idProduct = 2 then 180.00
		when idProduct = 3 then 110.00
		when idProduct = 4 then 250.00
		when idProduct = 5 then 2000.00
		when idProduct = 6 then 5.00
		when idProduct = 7 then 300.00
	end,
	Description =
    case
		when idProduct = 1 then 'Fone de ouvido preto bluetooth da JBL. Adaptado para todas as orelhas e com bateria para 5 horas de uso contínuo.'
		when idProduct = 2 then 'Barbie edição especial da princesa Elsa da Disney. Disponível por tempo limitado.'
		when idProduct = 3 then 'Camisa Polo G masculina da Body Carters. Tecido antitranspirante e de fácil lavagem.'
		when idProduct = 4 then 'Microfone edição especial do youtuber Vedo. Possui sensor de toque, LEDs e ajuste de inclinação.'
		when idProduct = 5 then 'Sofá retrátil verde da Monet de dimensões 3x57x80 (mxcmxcm). Alto conforto e durabilidade.'
		when idProduct = 6 then '500g de farinha de arroz orgânico da Ecobio.'
		when idProduct = 7 then 'Transforme sua TV em Smart com um simples encaixe no HDMI. Assista aos seus serviços de Streaming favoritos e controle-os pelo celular ou por comandos de voz com a Alexa.'
	end;

-- Remove attribute "PaymentCash" from table "orders", since in the next steep we will be creating table payment, which will be responsible for all payment information.
alter table orders drop column PaymentCash;

-- Creation of table "payment", which is responsible for all payment information.
create table payment(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartão de crédito','Cartão de débito', 'PIX'),
    limitAvailable float,
    primary key (idClient, idPayment),
    constraint fk_payment_client foreign key (idClient) references clients(idClient),
    constraint fk_payment_order foreign key (idPayment) references orders(idOrder)
    
);

-- Insertion of values to this new table.
insert into payment (idClient, idPayment, typePayment, limitAvailable) values
					(1,1,'Boleto',50000),
                    (2,2,'Cartão de crédito',70000),
                    (3,3,'Cartão de débito',10000),
                    (4,4,'PIX',15000),
                    (2,5,'Cartão de crédito',70000);

-- Implementing a constraint in the "seller" table to allow insertion of either a CPNJ or CPF for a single row.
alter table seller
	alter column CNPJ set default null,
    alter column CPF set default null,
    add check ((CNPJ is not null and CPF is null) or (CPF is not null and CNPJ is null));

-- Show clients whose name starts with an "M", order them in alphabetical order and display their full names and CPFs.
select concat(Fname, ' ', Minit, '. ', Lname) as Complete_name, CPF from clients
	where Fname like 'M%'
    order by Fname, Minit, Lname;
    
-- Show clients whose contact number starts with 21.
select SocialName, CNPJ, CPF, contact from seller
	where contact like '21_______'
    order by SocialName;

-- Show how many orders each client has made.
select concat(Fname, ' ', Minit, '. ', Lname) as Complete_name, CPF, count(*) as Quantidade_pedidos from clients, orders
	where idCLient = idOrderClient
    group by idClient;

-- Insertion of values to obtain a seller which is also a supplier. Also, applying a query to find them.
insert into supplier (SocialName, CNPJ, contact) values
					 ('Tech eletronics', 123456789456321, 219946287);
    
select * from supplier inner join seller using (CNPJ, contact);
	
-- Show relation between tables "product', "supplier" and "productSupplier" and orders by ProductName.
select p.Pname as ProductName, s.SocialName as SupplierName, ps.quantity as Quantity
	from product p
    inner join productSupplier ps on p.idProduct = ps.idPsProduct
    inner join supplier s on ps.idPsSupplier = s.idSupplier
    order by ProductName;

-- Show relation between supplier's names and product's names, ordering by ProductName.
select p.Pname as ProductName, s.SocialName as SupplierName
	from product p
	inner join supplier s on p.idProduct = s.idSupplier
    order by ProductName;    

-- Show delivery status.
Select idOrder as Código_de_rastreio, orderStatus as Status_do_pedido
	from orders;

-- Show complete name, CPF and age of clients.
select concat(Fname, ' ', Minit, '. ', Lname) as Complete_name, CPF, timestampdiff(year, Bdate, curdate()) as Age
	from clients; 
	
-- Show all information about all sellers and suppliers.
select * from seller cross join supplier;

-- Show total quantity of products each supplier is expected to deliver.
select s.SocialName as SupplierName, sum(ps.quantity) as Quantity
	from product p
    inner join productSupplier ps on p.idProduct = ps.idPsProduct
    inner join supplier s on ps.idPsSupplier = s.idSupplier
    group by SupplierName
    having sum(ps.quantity) >= 400;
