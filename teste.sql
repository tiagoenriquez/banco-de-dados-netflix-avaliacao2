drop database trabalho;

create database trabalho;

use trabalho;

create table pessoa(
	id int not null primary key auto_increment,
    nome varchar (255) unique not null,
    sexo varchar (1) not null
);

create table funcionario(
	id int not null primary key auto_increment,
    pessoa int not null,
    foreign key (pessoa) references pessoa (id)
);

create table cliente(
	id int not null primary key auto_increment,
    pessoa int not null,
    foreign key (pessoa) references pessoa (id)
);

insert into pessoa (nome, sexo) values ("Tiago", "M");

insert into pessoa (nome, sexo) values ("Diego", "M");

insert into pessoa (nome, sexo) values ("Michel", "M");

insert into pessoa (nome, sexo) values ("Georgina", "F");

insert into pessoa (nome, sexo) values ("Maria", "F");

insert into cliente (pessoa) values (4);

insert into cliente (pessoa) values (5);

delimiter $$
create procedure inserir_funcionario(in nome_entrada varchar (255), in sexo_entrada varchar (1))
begin
	set @pessoa = (select * from(select id from pessoa where nome = nome_entrada) as a_pessoa);
    if @pessoa is null then
		insert into pessoa (nome, sexo) values (nome_entrada, sexo_entrada);
        set @pessoa_nula = last_insert_id();
        insert into funcionario (pessoa) values (@pessoa_nula);
	else 
		insert into funcionario (pessoa) values (@pessoa);
	end if;
end $$

call inserir_funcionario("Rutinaldo", "M");

call inserir_funcionario("Maria", "F");

call inserir_funcionario("Diego", "M");

select * from pessoa;

select * from funcionario;

select * from cliente;