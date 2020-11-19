create database netflix;

use netflix;

create table pessoa(
	id int not null auto_increment primary key,
	nome varchar (200) not null,
	sexo varchar (1) not null
);

create table diretor(
	id int not null auto_increment primary key,
	pessoa int not null,
	foreign key (pessoa) references pessoa (id)
);

create table filme(
	id int not null auto_increment primary key,
	nome varchar (200) not null,
	votos int not null,
	ano_produção int not null,
	posição_ranking int not null,
	diretor int not null,
	foreign key (diretor) references diretor (id)
);

create table ator(
	id int not null auto_increment primary key,
	pessoa int not null,
	foreign key (pessoa) references pessoa (id)
);

create table papel(
	id int not null auto_increment primary key,
	nome varchar (200) not null,
	tipo varchar (200) not null,
	ator int not null,
	filme int not null,
	foreign key (ator) references ator (id),
	foreign key (filme) references filme (id)
);

create table genero(
	id int not null auto_increment primary key,
	nome varchar (200) not null
);

create table filme_genero(
	id int not null auto_increment primary key,
	filme int not null,
	genero int not null,
	foreign key (filme) references filme (id),
	foreign key (genero) references genero (id)
);

delimiter $$
create procedure inserir_pessoa(in nome varchar (200), in sexo varchar (1))
begin
	insert into pessoa (nome, sexo)
	values (nome, sexo);
end $$
