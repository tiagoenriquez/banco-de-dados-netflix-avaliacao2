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
		set @ator = (select * from (select id_ator from ator where pessoa = @pessoa) as rownum);
        if @ator is null then
			insert into ator (pessoa) values (@pessoa);
		end if;
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
	  	set @diretor = (select * from (select id_diretor from diretor where pessoa = @pessoa) as rownum);
        if @diretor is null then
			insert into diretor (pessoa) values (@pessoa);
		end if;
	end if;
end $$

delimiter $$
create procedure inserir_filme(in nome_entrada varchar (200), 
								in ano_producao_entrada int, 
                                in diretor_entrada varchar (200))
begin
	set @pessoa = (select * from (select id_pessoa from pessoa where nome = diretor_entrada) as rownum);
	set @diretor = (select * from (select id_diretor from diretor where pessoa = @pessoa) as rownum);
    insert into filme (nome, ano_producao, diretor)
    values (nome_entrada, ano_producao_entrada, @diretor);
end $$

delimiter $$
create procedure inserir_papel(in nome_entrada varchar (200), 
								in tipo_entrada varchar (200), 
								in ator_entrada varchar (200), 
                                in filme_entrada varchar (200))
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
call inserir_filme("Planeta terror", 2007, "Robert Rodriguez");
call inserir_papel("Cherry Darling", "", "Rose McGowan", "Planeta terror");
call inserir_papel("El Wray", "", "Freddy Rodríguez", "Planeta terror");
call inserir_papel("The Rapist", "", "Quentin Tarantino", "Planeta terror");
call atribuir_genero_a_filme("terror", "Planeta terror");
call atribuir_genero_a_filme("ação", "Planeta terror");

call inserir_diretor("Quentin Tarantino", "M");
call inserir_ator("John Travolta", "M");
call inserir_ator("Samuel L. Jackson", "M");
call inserir_ator("Uma Thurman", "F");
call inserir_filme("Pulp fiction: tempo de violência", 1995, "Quentin Tarantino");
call inserir_papel("Vincent Vega", "", "John Travolta", "Pulp fiction: tempo de violência");
call inserir_papel("Jules Winnfield", "", "Samuel L. Jackson", "Pulp fiction: tempo de violência");
call inserir_papel("Mia Wallace", "", "Uma Thurman", "Pulp fiction: tempo de violência");
call atribuir_genero_a_filme("crime", "Pulp fiction: tempo de violência");

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

call inserir_diretor("Pat Williams", "M");
call inserir_ator("Jesse Metcalfe", "M");
call inserir_ator("Keegan Connor Tracy", "F");
call inserir_ator("Marie Avgeropoulo", "F");
call inserir_filme("Dead rising: endgame", 2016, "Pat Williams");
call inserir_papel("Chase Carter", "", "Jesse Metcalfe", "Dead rising: endgame");
call inserir_papel("Jordan", "", "Keegan Connor Tracy", "Dead rising: endgame");
call inserir_papel("Sandra Lowe", "", "Marie Avgeropoulo", "Dead rising: endgame");
call atribuir_genero_a_filme("acao", "Dead rising: endgame");
call atribuir_genero_a_filme("terror", "Dead rising: endgame");

call inserir_diretor("Alan Metter", "M");
call inserir_ator("Sarah Jessica Parker", "F");
call inserir_ator("Lee Montgomery", "M");
call inserir_ator("Helen Hunt", "F");
call inserir_filme("Dançando na TV", 1985, "Alan Metter");
call inserir_papel("Janey Glenn", "", "Sarah Jessica Parker", "Dançando na TV");
call inserir_papel("Jeff Malene", "", "Lee Montgomery", "Dançando na TV");
call inserir_papel("Lynne Stone", "", "Helen Hunt", "Dançando na TV");
call atribuir_genero_a_filme("comédia", "Dançando na TV");
call atribuir_genero_a_filme("família", "Dançando na TV");
call atribuir_genero_a_filme("música", "Dançando na TV");
call atribuir_genero_a_filme("romance", "Dançando na TV");

call inserir_diretor("Michael Lehmann", "M");
call inserir_ator("Winona Ryder", "F");
call inserir_ator("Christian Slater", "M");
call inserir_ator("Shannen Doherte", "F");
call inserir_filme("Atração mortal", 1989, "Michael Lehmann");
call inserir_papel("Veronica Sawyer", "", "Winona Ryder", "Atração mortal");
call inserir_papel("Jason J.D. Dean", "", "Christian Slater", "Atração mortal");
call inserir_papel("Heather Duke", "", "Shannen Doherte", "Atração mortal");
call atribuir_genero_a_filme("comédia", "Atração mortal");
call atribuir_genero_a_filme("crime", "Atração mortal");

call inserir_diretor("Jason Sanchez", "M");
call inserir_ator("Evan Rachel Wood", "F");
call inserir_ator("Julia Sarah Stone", "F");
call inserir_ator("Denis O'Hare", "F");
call inserir_filme("Allure", 2018, "Jason Sanchez");
call inserir_papel("Laura Drake", "", "Evan Rachel Wood", "Allure");
call inserir_papel("Eva", "", "Julia Sarah Stone", "Allure");
call inserir_papel("William", "", "Denis O'Hare", "Allure");
call atribuir_genero_a_filme("drama", "Allure");
call atribuir_genero_a_filme("romance", "Allure");

call inserir_diretor("Richard Elson", "M");
call inserir_ator("Erin Galway-Kendrick", "F");
call inserir_ator("Liam Neeson", "M");
call inserir_ator("Robert James-Collier", "M");
call inserir_filme("Uma estrela no paraíso", 2015, "Richard Elson");
call inserir_papel("Noelle O'Hanlon", "", "Erin Galway-Kendrick", "Uma estrela no paraíso");
call inserir_papel("Narrator", "", "Liam Neeson", "Uma estrela no paraíso");
call inserir_papel("Pat McKerrod", "", "Robert James-Collier", "Uma estrela no paraíso");
call atribuir_genero_a_filme("família", "Uma estrela no paraíso");

call inserir_diretor("Tyler Measom", "M");
call inserir_ator("James Randi", "M");
call inserir_ator("Adam Savage", "M");
call inserir_ator("Bill Nye", "M");
call inserir_filme("An honest liar", 2014, "Tyler Measom");
call inserir_papel("Himself", "", "James Randi", "An honest liar");
call inserir_papel("Himself", "", "Adam Savage", "An honest liar");
call inserir_papel("Himself", "", "Bill Nye", "An honest liar");
call atribuir_genero_a_filme("história", "An honest liar");
call atribuir_genero_a_filme("comédia", "An honest liar");
call atribuir_genero_a_filme("documentário", "An honest liar");

call inserir_diretor("Dietrich Johnston", "M");
call inserir_ator("Brad Dourif", "M");
call inserir_ator("Troy Brenna", "M");
call inserir_ator("Brennan Elliott", "M");
call inserir_filme("Blood shot", 2013, "Dietrich Johnston");
call inserir_papel("Bob", "", "Brad Dourif", "Blood shot");
call inserir_papel("Genie", "", "Troy Brenna", "Blood shot");
call inserir_papel("Rip", "", "Brennan Elliott", "Blood shot");
call atribuir_genero_a_filme("ação", "Blood shot");
call atribuir_genero_a_filme("comédia", "Blood shot");
call atribuir_genero_a_filme("terror", "Blood shot");

call inserir_diretor("David Yarovesky", "M");
call inserir_ator("Kathryn Prescott", "F");
call inserir_ator("Gabriel Basso", "M");
call inserir_ator("Sean Gunn", "M");
call inserir_filme("A colmeia", 2015, "David Yarovesky");
call inserir_papel("Katie", "", "Kathryn Prescott", "A colmeia");
call inserir_papel("Adam", "", "Gabriel Basso", "A colmeia");
call inserir_papel("Dr. Baker", "", "Sean Gunn", "A colmeia");
call atribuir_genero_a_filme("terror", "A colmeia");
call atribuir_genero_a_filme("ficção científica", "A colmeia");

call inserir_diretor("Roger Spottiswoode", "M");
call inserir_ator("Jamie Lee Curtis", "F");
call inserir_ator("Ben Johnson", "M");
call inserir_ator("Hart Bochner", "M");
call inserir_filme("O Trem do terror", 1980, "Roger Spottiswoode");
call inserir_papel("Alana Maxwell", "", "Jamie Lee Curtis", "O Trem do terror");
call inserir_papel("Carne", "", "Ben Johnson", "O Trem do terror");
call inserir_papel("Doc Manley", "", "Hart Bochner", "O Trem do terror");
call atribuir_genero_a_filme("terror", "O Trem do terror");

call inserir_diretor("David Mackenzie", "M");
call inserir_ator("Jeff Bridges", "M");
call inserir_ator("Chris Pine", "M");
call inserir_ator("Ben Foster", "M");
call inserir_filme("A qualquer custo", 2016, "David Mackenzie");
call inserir_papel("Marcus Hamilton", "", "Jeff Bridges", "A qualquer custo");
call inserir_papel("Toby Howard", "", "Chris Pine", "A qualquer custo");
call inserir_papel("Tanner Howard", "", "Ben Foster", "A qualquer custo");
call atribuir_genero_a_filme("crime", "A qualquer custo");
call atribuir_genero_a_filme("faroeste", "A qualquer custo");

call inserir_diretor("Lo Wei", "M");
call inserir_ator("Bruce Lee", "M");
call inserir_ator("Nora Miao", "F");
call inserir_ator("Maria Yi", "F");
call inserir_filme("A fúria do dragão", 1972, "Lo Wei");
call inserir_papel("Chen Zhen", "", "Bruce Lee", "A fúria do dragão");
call inserir_papel("Yuan Le-erh", "", "Nora Miao", "A fúria do dragão");
call inserir_papel("Yen", "", "Maria Yi", "A fúria do dragão");
call atribuir_genero_a_filme("drama", "A fúria do dragão");
call atribuir_genero_a_filme("ação", "A fúria do dragão");

call inserir_diretor("Jonas Åkerlund", "M");
call inserir_ator("Dennis Quaid", "M");
call inserir_ator("Zhang Ziyi", "F");
call inserir_ator("Lou Taylor Pucci", "M");
call inserir_filme("Os cavaleiros do apocalipse", 2009, "Jonas Åkerlund");
call inserir_papel("Aidan Breslin", "", "Dennis Quaid", "Os cavaleiros do apocalipse");
call inserir_papel("Kristen", "", "Zhang Ziyi", "Os cavaleiros do apocalipse");
call inserir_papel("Alex Breslin", "", "Lou Taylor Pucci", "Os cavaleiros do apocalipse");
call atribuir_genero_a_filme("crime", "Os cavaleiros do apocalipse");
call atribuir_genero_a_filme("drama", "Os cavaleiros do apocalipse");
call atribuir_genero_a_filme("terror", "Os cavaleiros do apocalipse");
call atribuir_genero_a_filme("mistério", "Os cavaleiros do apocalipse");

call inserir_diretor("Ramiro Meneses", "M");
call inserir_ator("Andrea Lopez", "F");
call inserir_ator("Carolina Sepulveda", "F");
call inserir_ator("Juan Pablo Shuk", "M");
call inserir_filme("Sexo, mentiras e mortes", 2011, "Ramiro Meneses");
call inserir_papel("Viviana", "", "Andrea Lopez", "Sexo, mentiras e mortes");
call inserir_papel("Lorena", "", "Carolina Sepulveda", "Sexo, mentiras e mortes");
call inserir_papel("Gerardo", "", "Juan Pablo Shuk", "Sexo, mentiras e mortes");
call atribuir_genero_a_filme("drama", "Sexo, mentiras e mortes");
call atribuir_genero_a_filme("crime", "Sexo, mentiras e mortes");
call atribuir_genero_a_filme("romance", "Sexo, mentiras e mortes");

call inserir_diretor("Terry Winsor", "M");
call inserir_ator("Lance Henriksen", "M");
call inserir_ator("Cian Barry", "M");
call inserir_ator("Michael Smiley", "M");
call inserir_filme("Aranhas assassinas", 2007, "Terry Winsor");
call inserir_papel("Dr. Lecorpus", "", "Lance Henriksen", "Aranhas assassinas");
call inserir_papel("John", "", "Cian Barry", "Aranhas assassinas");
call inserir_papel("Phil", "", "Michael Smiley", "Aranhas assassinas");
call atribuir_genero_a_filme("terror", "Aranhas assassinas");

call inserir_diretor("Jack Sholder", "M");
call inserir_ator("Kyle MacLachlan", "M");
call inserir_ator("Michael Nouri", "M");
call inserir_ator("Claudia Christian", "F");
call inserir_filme("O escondido", 1987, "Jack Sholder");
call inserir_papel("Lloyd Gallagher", "", "Kyle MacLachlan", "O escondido");
call inserir_papel("Tom Beck", "", "Michael Nouri", "O escondido");
call inserir_papel("Brenda Lee Van Buren", "", "Claudia Christian", "O escondido");
call atribuir_genero_a_filme("ação", "O escondido");
call atribuir_genero_a_filme("terror", "O escondido");
call atribuir_genero_a_filme("ficção científica", "O escondido");

call inserir_diretor("Quinn Shephard", "F");
call inserir_ator("Quinn Shephard", "F");
call inserir_ator("Nadia Alexander", "F");
call inserir_ator("Chris Messina", "M");
call inserir_filme("Blame", 2017, "Quinn Shephard");
call inserir_papel("Abigail Grey", "", "Quinn Shephard", "Blame");
call inserir_papel("Melissa Bowman", "", "Nadia Alexander", "Blame");
call inserir_papel("Jeremy Woods", "", "Chris Messina", "Blame");
call atribuir_genero_a_filme("drama", "Blame");

call inserir_diretor("David Shore", "M");
call inserir_ator("Freddie Highmore", "M");
call inserir_ator("Antonia Thomas", "F");
call inserir_ator("Hill Harper", "M");
call inserir_filme("The good doctor: o Bom doutor", 2017, "David Shore");
call inserir_papel("Shaun Murphy", "", "Freddie Highmore", "The good doctor: o Bom doutor");
call inserir_papel("Claire Browne", "", "Antonia Thomas", "The good doctor: o Bom doutor");
call inserir_papel("Marcus Andrews", "", "Hill Harper", "The good doctor: o Bom doutor");
call atribuir_genero_a_filme("drama", "The good doctor: o Bom doutor");

call inserir_diretor("Fritz Kiersch", "M");
call inserir_ator("Peter Horton", "M");
call inserir_ator("Linda Hamilton", "F");
call inserir_ator("R.G. Armstrong", "M");
call inserir_filme("Colheita maldita", 1984, "Fritz Kiersch");
call inserir_papel("Burton Stanton", "", "Peter Horton", "Colheita maldita");
call inserir_papel("Vicky", "", "Linda Hamilton", "Colheita maldita");
call inserir_papel("Diehl", "", "R.G. Armstrong", "Colheita maldita");
call atribuir_genero_a_filme("terror", "Colheita maldita");

call inserir_diretor("Chris Columbus", "M");
call inserir_ator("Kurt Russell", "M");
call inserir_ator("Goldie Hawn", "F");
call inserir_ator("Darby Camp", "F");
call inserir_filme("Crônicas de Natal: parte dois", 2020, "Chris Columbus");
call inserir_papel("Santa Claus", "", "Kurt Russell", "Crônicas de Natal: parte dois");
call inserir_papel("Mrs. Claus", "", "Goldie Hawn", "Crônicas de Natal: parte dois");
call inserir_papel("Kate Pierce", "", "Darby Camp", "Crônicas de Natal: parte dois");
call atribuir_genero_a_filme("família", "Crônicas de Natal: parte dois");
call atribuir_genero_a_filme("fantasia", "Crônicas de Natal: parte dois");
call atribuir_genero_a_filme("aventura", "Crônicas de Natal: parte dois");

call inserir_diretor("Kenneth Branagh", "M");
call inserir_ator("Chris Pine", "M");
call inserir_ator("Keira Knightley", "F");
call inserir_ator("Kevin Costner", "M");
call inserir_filme("Operação Sombra - Jack Ryan", 2013, "Kenneth Branagh");
call inserir_papel("Jack Ryan", "", "Chris Pine", "Operação Sombra - Jack Ryan");
call inserir_papel("Cathy Muller", "", "Keira Knightley", "Operação Sombra - Jack Ryan");
call inserir_papel("Thomas Harper", "", "Kevin Costner", "Operação Sombra - Jack Ryan");
call atribuir_genero_a_filme("ação", "Operação Sombra - Jack Ryan");

call inserir_diretor("Simon Curtis", "M");
call inserir_ator("Michelle Williams", "F");
call inserir_ator("Kenneth Branagh", "M");
call inserir_ator("Eddie Redmayne", "M");
call inserir_filme("Sete Dias com Marilyn", 2011, "Simon Curtis");
call inserir_papel("Marilyn Monroe", "", "Michelle Williams", "Sete Dias com Marilyn");
call inserir_papel("Sir Laurence Olivier", "", "Kenneth Branagh", "Sete Dias com Marilyn");
call inserir_papel("Colin Clark", "", "Eddie Redmayne", "Sete Dias com Marilyn");
call atribuir_genero_a_filme("drama", "Sete Dias com Marilyn");

call inserir_diretor("Chris Columbus", "M");
call inserir_ator("Daniel Radcliffe", "M");
call inserir_ator("Rupert Grint", "M");
call inserir_ator("Emma Watson", "F");
call inserir_filme("Harry Potter e a Câmara Secreta", 2002, "Chris Columbus");
call inserir_papel("Harry Potter", "", "Daniel Radcliffe", "Harry Potter e a Câmara Secreta");
call inserir_papel("Rony Weasley", "", "Rupert Grint", "Harry Potter e a Câmara Secreta");
call inserir_papel("Hermione Granger", "", "Emma Watson", "Harry Potter e a Câmara Secreta");
call atribuir_genero_a_filme("aventura", "Harry Potter e a Câmara Secreta");
call atribuir_genero_a_filme("fantasia", "Harry Potter e a Câmara Secreta");

call inserir_diretor("Bryan Singer", "M");
call inserir_ator("Terence Stamp", "M");
call inserir_ator("Tom Wilkinson", "M");
call inserir_ator("Carice van Houten", "F");
call inserir_filme("Operação Valquíria", 2008, "Bryan Singer");
call inserir_papel("Ludwig Beck", "", "Terence Stamp", "Operação Valquíria");
call inserir_papel("Friedrich Fromm", "", "Tom Wilkinson", "Operação Valquíria");
call inserir_papel("Nina von Stauffenberg", "", "Carice van Houten", "Operação Valquíria");
call atribuir_genero_a_filme("biografia", "Operação Valquíria");
call atribuir_genero_a_filme("drama", "Operação Valquíria");
call atribuir_genero_a_filme("ficção histórica", "Operação Valquíria");

call inserir_diretor("Barry Sonnenfeld", "M");
call inserir_ator("Will Smith", "M");
call inserir_ator("Kevin Kline", "M");
call inserir_ator("Kenneth Branagh", "M");
call inserir_filme("As Loucas Aventuras de James West", 1999, "Barry Sonnenfeld");
call inserir_papel("Capitão James T", "", "Will Smith", "As Loucas Aventuras de James West");
call inserir_papel("Artemus Gordon", "", "Kevin Kline", "As Loucas Aventuras de James West");
call inserir_papel("Dr. Airliss Loveless", "", "Kenneth Branagh", "As Loucas Aventuras de James West");
call atribuir_genero_a_filme("faroeste", "As Loucas Aventuras de James West");
call atribuir_genero_a_filme("comédia", "As Loucas Aventuras de James West");
call atribuir_genero_a_filme("ação", "As Loucas Aventuras de James West");
call atribuir_genero_a_filme("ficção científica", "As Loucas Aventuras de James West");

call inserir_diretor("Hideo Nakata", "M");
call inserir_ator("Miki Nakatani", "F");
call inserir_ator("Hitomi Satô", "F");
call inserir_ator("Kyoko Fukada", "F");
call inserir_filme("O Chamado 2", 1999, "Hideo Nakata");
call inserir_papel("Mai Takano", "", "Miki Nakatani", "O Chamado 2");
call inserir_papel("Masami Kurahashi", "", "Hitomi Satô", "O Chamado 2");
call inserir_papel("Kanae Sawaguchi", "", "Kyoko Fukada", "O Chamado 2");
call atribuir_genero_a_filme("terror", "O Chamado 2");
call atribuir_genero_a_filme("mistério", "O Chamado 2");
call atribuir_genero_a_filme("ficção científica", "O Chamado 2");

call inserir_diretor("Konstantin Khabenskiy", "M");
call inserir_ator("Konstantin Khabenskiy", "M");
call inserir_ator("Christopher Lambert", "M");
call inserir_ator("Michalina Olszańska", "F");
call inserir_filme("Sobibor", 2018, "Konstantin Khabenskiy");
call inserir_papel("Alexander Pechersky", "", "Konstantin Khabenskiy", "Sobibor");
call inserir_papel("Karl Frenzel", "", "Christopher Lambert", "Sobibor");
call inserir_papel("Hanna", "", "Michalina Olszańska", "Sobibor");
call atribuir_genero_a_filme("drama", "Sobibor");
call atribuir_genero_a_filme("guerra", "Sobibor");

call inserir_diretor("Vladimir Kott", "M");
call inserir_ator("Konstantin Khabensky", "M");
call inserir_ator("Andrey Merzlikin", "M");
call inserir_ator("Viktoriya Isakova", "F");
call inserir_filme("Pyotr Leschenko. Everything That Was", 2013, "Vladimir Kott");
call inserir_papel("Pyotr Leshchenko", "", "Konstantin Khabensky", "Pyotr Leschenko. Everything That Was");
call inserir_papel("Georgy Khrapak", "", "Andrey Merzlikin", "Pyotr Leschenko. Everything That Was");
call inserir_papel("Ekaterina Zavyalova", "", "Viktoriya Isakova", "Pyotr Leschenko. Everything That Was");
call atribuir_genero_a_filme("musical", "Pyotr Leschenko. Everything That Was");


-- 1ª view: Liste os 10 atores ou atrizes com maior número de papéis em filmes do gênero Crime 
-- e a quantidade total de papéis deles nesses filmes. 
create view crime as
	select pessoa.nome as ator, count(*) as atuacoes from genero_filme
	inner join genero on genero_filme.genero = genero.id_genero
	inner join filme on genero_filme.filme = filme.id_filme
	inner join papel on filme.id_filme = papel.filme
	inner join ator on papel.ator = ator.id_ator
	inner join pessoa on ator.pessoa = pessoa.id_pessoa
	where genero.nome = "crime"
    group by pessoa.nome
    order by atuacoes desc
    limit 10;
    
-- 2ª view: Para cada gênero, liste o nome do gênero e a quantidade de filmes desse gênero. 
-- Ordene pela  quantidade de maneira crescente. 
create view quantidade_filmes_genero as
	select genero.nome as genero, count(genero_filme.filme) as quantidade_filmes from genero_filme
    inner join genero on genero_filme.genero = genero.id_genero
    inner join filme on genero_filme.filme = filme.id_filme
    group by genero_filme.genero
    order by quantidade_filmes desc;

-- 3ª view: Liste o nome dos filmes em que Quentin Tarantino atuou (lembre-se que existem filmes no qual ele atuou 
-- e é diretor, filmes em que ele é apenas diretor e filmes em que ele apenas atuou) 
-- e o nome do papel em cada um deles.
create view tarantino as
	select filme.nome as filme, papel.nome as papel from filme
	inner join papel on filme.id_filme = papel.filme
	inner join ator on papel.ator = ator.id_ator
	inner join pessoa on ator.pessoa = pessoa.id_pessoa
	where pessoa.nome = "Quentin Tarantino";

-- 4ª view: Sobre a trilogia do filme Se Beber Não Case, liste o nome dos filmes da trilogia, 
-- o nome das  pessoas que trabalharam nos filmes, bem como o nome do papel que cada um desempenhou 
-- e o tipo do papel. Ordene pelo ano de produção em ordem crescente.
create view se_beber_nao_case as
	select filme.nome as filme, pessoa.nome as participante, papel.nome as papel, papel.tipo as tipo_papel
	from papel
	inner join filme on papel.filme = filme.id_filme
    inner join ator on papel.ator = ator.id_ator
    inner join diretor on filme.diretor = diretor.id_diretor
	inner join pessoa on ator.pessoa = pessoa.id_pessoa
	where filme.nome like "Se beber, não case!%"
	order by filme.ano_producao asc;
    
-- 5ª view: Liste os nomes dos 10 atores ou atrizes que mais participaram de diferentes gêneros de filmes.  
-- Liste também a quantidade de gêneros diferentes que cada um participou e ordene de forma  decrescente.
create view atores_generos_diferentes as
	select pessoa.nome as ator, count(distinct genero.id_genero) as quantidade_genero from genero_filme
    inner join genero on genero_filme.genero = genero.id_genero
    inner join filme on genero_filme.filme = filme.id_filme
	inner join papel on filme.id_filme = papel.filme
	inner join ator on papel.ator = ator.id_ator
	inner join pessoa on ator.pessoa = pessoa.id_pessoa
    group by papel.ator
    order by quantidade_genero desc
    limit 10;

select * from crime;

select * from quantidade_filmes_genero;

select * from tarantino;

select * from se_beber_nao_case;

select * from atores_generos_diferentes;
