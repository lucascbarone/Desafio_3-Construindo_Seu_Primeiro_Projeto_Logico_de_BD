-- Criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    constraint unique_cpf_client unique (CPF)
);
    
alter table clients auto_increment = 1;

-- criar tabela produto
-- size = dimensão do produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(255) not null,
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
);

alter table product auto_increment = 1;

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    PaymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
);

alter table orders auto_increment = 1;

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment = 1;

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact varchar(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment = 1;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);

alter table seller auto_increment = 1;

-- criar tabela produto-vendedor
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
	primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
	constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- criar tabela produto-pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
	poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
	constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

-- criar tabela produto_em_estoque (localização)
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key(idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
	constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- criar tabela produto-fornecedor
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key(idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
	constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);
show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';