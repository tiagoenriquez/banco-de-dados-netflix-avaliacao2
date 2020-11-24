drop database netflix;

create database netflix;

use netflix;

create table pessoa(
	id_pessoa int not null auto_increment primary key,
	nome varchar (200) unique not null,
	sexo varchar (1) not null
);

create table diretor(
	id_diretor int not null auto_increment primary key,
	pessoa int not null,
	foreign key (pessoa) references pessoa (id_pessoa)
);

create table filme(
	id_filme int not null auto_increment primary key,
	nome varchar (200) not null,
	ano_producao int not null,
	diretor int not null,
	foreign key (diretor) references diretor (id_diretor)
);

create table ator(
	id_ator int not null auto_increment primary key,
	pessoa int not null,
	foreign key (pessoa) references pessoa (id_pessoa)
);

create table papel(
	id_papel int not null auto_increment primary key,
	nome varchar (200) not null,
	tipo varchar (200) not null,
	ator int not null,
	filme int not null,
	foreign key (ator) references ator (id_ator),
	foreign key (filme) references filme (id_filme)
);

create table genero(
	id_genero int not null auto_increment primary key,
	nome varchar (200) not null
);

create table genero_filme(
	id_genero_filme int not null auto_increment primary key,
	genero int not null,
	filme int not null,
	foreign key (genero) references genero (id_genero),
	foreign key (filme) references filme (id_filme)
);

delimiter $$
create procedure inserir_ator(in nome_entrada varchar (200), in sexo_entrada varchar (1))
begin
	set @pessoa = (select * from (select id_pessoa from pessoa where nome = nome_entrada) as rownum);
    if @pessoa is null then
		insert into pessoa (nome, sexo) values (nome_entrada, sexo_entrada);
        set @pessoa_nula = last_insert_id();
        insert into ator (pessoa) values (@pessoa_nula);
	else
		insert into ator (pessoa) values (@pessoa);
	end if;
end $$

delimiter $$
create procedure inserir_diretor(in nome_entrada varchar (200), in sexo_entrada varchar (1))
begin
	set @pessoa = (select * from (select id_pessoa from pessoa where nome = nome_entrada) as rownum);
    if @pessoa is null then
		insert into pessoa (nome, sexo) values (nome_entrada, sexo_entrada);
        set @pessoa_nula = last_insert_id();
        insert into diretor (pessoa) values (@pessoa_nula);
	else
		insert into diretor (pessoa) values (@pessoa);
	end if;
end $$

delimiter $$
create procedure inserir_filme(in nome_entrada varchar (200), in ano_producao_entrada int, in diretor_entrada varchar (200))
begin
	set @pessoa = (select * from (select id_pessoa from pessoa where nome = diretor_entrada) as rownum_a);
	set @diretor = (select * from (select id_diretor from diretor where pessoa = @pessoa) as rownum_b);
    insert into filme (nome, ano_producao, diretor)
    values (nome_entrada, ano_producao_entrada, @diretor);
end $$

delimiter $$
create procedure inserir_papel(in nome_entrada varchar (200), in tipo_entrada varchar (200), in ator_entrada varchar (200), in filme_entrada varchar (200))
begin
	set @pessoa = (select * from (select id_pessoa from pessoa where nome = ator_entrada) as rownum);
	set @ator = (select * from (select id_ator from ator where pessoa = @pessoa) as rownum);
	set @filme = (select * from (select id_filme from filme where nome = filme_entrada) as rownum);
    insert into papel (nome, tipo, ator, filme)
    values (nome_entrada, tipo_entrada, @ator, @filme);
end $$

delimiter $$
create procedure atribuir_genero_a_filme(in genero_entrada varchar (200), in filme_entrada varchar (200))
begin
	set @genero = (select * from (select id_genero from genero where nome = genero_entrada) as rownum);
    if @genero is null then
		insert into genero (nome) values (genero_entrada);
        set @genero = last_insert_id();
	end if;
    set @filme = (select * from (select id_filme from filme where nome = filme_entrada) as rownum);
    insert into genero_filme (genero, filme) values (@genero, @filme);
end $$

call inserir_diretor("Charlie Bean", "M");
call inserir_ator("Tessa Thompson", "F");
call inserir_ator("Justin Theroux", "M");
call inserir_ator("Kiersey Klemons", "F");
call inserir_filme("A dama e o vagabundo", 2019, "Charlie Bean");
call inserir_papel("Dama", "", "Tessa Thompson", "A dama e o vagabundo");
call inserir_papel("Vagabundo", "", "Justin Theroux", "A dama e o vagabundo");
call inserir_papel("Darling Dear", "", "Kiersey Klemons", "A dama e o vagabundo");
call atribuir_genero_a_filme("romance", "A dama e o vagabundo");
call atribuir_genero_a_filme("comédia", "A dama e o vagabundo");
call atribuir_genero_a_filme("familia", "A dama e o vagabundo");