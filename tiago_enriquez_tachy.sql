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

call inserir_diretor("Todd Phillips", "M");
call inserir_ator("Bradley Cooper", "M");
call inserir_ator("Ed Helms", "M");
call inserir_ator("Zach Galifianakais", "M");
call inserir_filme("Se beber, não case!", 2009, "Todd Phillips");
call inserir_papel("Phil Wenneck", "professor", "Bradley Cooper", "Se beber, não case!");
call inserir_papel("Stu Price", "dentista", "Ed Helms", "Se beber, não case!");
call inserir_papel("Alan Garner", "amigo de personagem", "Zach Galifianakais", "Se beber, não case!");
call atribuir_genero_a_filme("comédia", "Se beber, não case!");

call inserir_diretor("Todd Phillips", "M");
call inserir_ator("Bradley Cooper", "M");
call inserir_ator("Ed Helms", "M");
call inserir_ator("Zach Galifianakais", "M");
call inserir_filme("Se beber, não case! Parte 2", 2011, "Todd Phillips");
call inserir_papel("Phil Wenneck", "professor", "Bradley Cooper", "Se beber, não case! Parte 2");
call inserir_papel("Stu Price", "dentista", "Ed Helms", "Se beber, não case! Parte 2");
call inserir_papel("Alan Garner", "amigo de personagem", "Zach Galifianakais", "Se beber, não case! Parte 2");
call atribuir_genero_a_filme("comédia", "Se beber, não case! Parte 2");

call inserir_diretor("Todd Phillips", "M");
call inserir_ator("Bradley Cooper", "M");
call inserir_ator("Ed Helms", "M");
call inserir_ator("Zach Galifianakais", "M");
call inserir_filme("Se beber, não case! Parte 3", 2013, "Todd Phillips");
call inserir_papel("Phil Wenneck", "professor", "Bradley Cooper", "Se beber, não case! Parte 3");
call inserir_papel("Stu Price", "dentista", "Ed Helms", "Se beber, não case! Parte 3");
call inserir_papel("Alan Garner", "amigo de personagem", "Zach Galifianakais", "Se beber, não case! Parte 3");
call atribuir_genero_a_filme("comédia", "Se beber, não case! Parte 3");

call inserir_diretor("Quentin Tarantino", "M");
call inserir_ator("Harvey Keitel", "M");
call inserir_ator("Tim Roth", "M");
call inserir_ator("Michael Madsen", "M");
call inserir_filme("Cães de aluguel", 1993, "Quentin Tarantino");
call inserir_papel("Phil Wenneck", "", "Harvey Keitel", "Cães de aluguel");
call inserir_papel("Mr. Orange", "", "Tim Roth", "Cães de aluguel");
call inserir_papel("Mr. Blonde", "", "Michael Madsen", "Cães de aluguel");
call atribuir_genero_a_filme("crime", "Cães de aluguel");

call inserir_diretor("Robert Rodriguez", "M");
call inserir_ator("Antonio Bandeiras", "M");
call inserir_ator("Salma Hayek", "F");
call inserir_ator("Quentin Tarantino", "M");
call inserir_filme("A balada do pistoleiro", 1995, "Robert Rodriguez");
call inserir_papel("El Mariachi", "", "Antonio Bandeiras", "A balada do pistoleiro");
call inserir_papel("Carolina", "", "Salma Hayek", "A balada do pistoleiro");
call inserir_papel("Pick-Up-Guy", "", "Quentin Tarantino", "A balada do pistoleiro");
call atribuir_genero_a_filme("ação", "A balada do pistoleiro");
call atribuir_genero_a_filme("crime", "A balada do pistoleiro");

call inserir_diretor("Robert Rodriguez", "M");
call inserir_ator("Rose McGowan", "F");
call inserir_ator("Freddy Rodríguez", "M");
call inserir_ator("Quentin Tarantino", "M");
call inserir_filme("Planeta Terror", 2007, "Robert Rodriguez");
call inserir_papel("Cherry Darling", "", "Rose McGowan", "Planeta Terror");
call inserir_papel("El Wray", "", "Freddy Rodríguez", "Planeta Terror");
call inserir_papel("The Rapist", "", "Quentin Tarantino", "Planeta Terror");
call atribuir_genero_a_filme("terror", "Planeta Terror");
call atribuir_genero_a_filme("ação", "Planeta Terror");

call inserir_diretor("Quentin Tarantino", "M");
call inserir_ator("John Travolta", "M");
call inserir_ator("Samuel L. Jackson", "M");
call inserir_ator("Uma Thurman", "F");
call inserir_filme("Pulp Fiction: Tempo de violência", 1995, "Quentin Tarantino");
call inserir_papel("Vincent Vega", "", "John Travolta", "Pulp Fiction: Tempo de violência");
call inserir_papel("Jules Winnfield", "", "Samuel L. Jackson", "Pulp Fiction: Tempo de violência");
call inserir_papel("Mia Wallace", "", "Uma Thurman", "Pulp Fiction: Tempo de violência");
call atribuir_genero_a_filme("crime", "Pulp Fiction: Tempo de violência");

call inserir_diretor("Aaron Rahsaan Thomas", "M");
call inserir_ator("Shemar Moore", "M");
call inserir_ator("Alex Russell", "M");
call inserir_ator("Jay Harrington", "M");
call inserir_filme("S.W.A.T.", 2017, "Aaron Rahsaan Thomas");
call inserir_papel("Daniel Hondo Harrelson", "", "Shemar Moore", "S.W.A.T.");
call inserir_papel("Jim Street", "", "Alex Russell", "S.W.A.T.");
call inserir_papel("David Deacon Kay", "", "Jay Harrington", "S.W.A.T.");
call atribuir_genero_a_filme("crime", "S.W.A.T.");
call atribuir_genero_a_filme("drama", "S.W.A.T.");

call inserir_diretor("Scott Frank", "M");
call inserir_ator("Anya Taylor-Joy", "F");
call inserir_ator("Bill Camp", "M");
call inserir_ator("Brodie-Sangster", "M");
call inserir_filme("O gambito da rainha", 2020, "Scott Frank");
call inserir_papel("Beth Harmon", "", "Anya Taylor-Joy", "O gambito da rainha");
call inserir_papel("Mr. Shaibel", "", "Bill Camp", "O gambito da rainha");
call inserir_papel("Benny Watts", "", "Brodie-Sangster", "O gambito da rainha");
call atribuir_genero_a_filme("drama", "O gambito da rainha");

call inserir_diretor("Todd Phillips", "M");
call inserir_ator("Joaquin Phoennix", "M");
call inserir_ator("Robert de Niro", "M");
call inserir_ator("Zazie Beets", "F");
call inserir_filme("Coringa", 2019, "Todd Phillips");
call inserir_papel("Arthur Fleck", "", "Joaquin Phoennix", "Coringa");
call inserir_papel("Murray Franklin", "", "Robert de Niro", "Coringa");
call inserir_papel("Sophie Dumond", "", "Zazie Beets", "Coringa");
call atribuir_genero_a_filme("crime", "Coringa");
call atribuir_genero_a_filme("drama", "Coringa");
