
--CREATE table clientes (
--	id_cliente int identity(1,1) primary key,
--	primeiro_nome nvarchar(50) not null,
--	ultimo_nome nvarchar(50) not null,
--	email nvarchar (150) unique,
--	codigo_postal nvarchar (50),
--	datanasc date,
--	idade as datediff(day,datanasc,getdate())/365.25,
--	gender nvarchar(50)
--		check(gender = 'M' or gender = 'F' or gender = 'X')
--);
--ALTER TABLE clientes
--ADD CONSTRAINT CHK_Gender CHECK (gender IN ('M', 'F', 'X'));
--ALTER TABLE clientes
--ADD DEFAULT 'X' FOR gender;

--insert into clientes (primeiro_nome, ultimo_nome, datanasc, email, codigo_postal, gender)
--values
--('Peter', 'Parker', '1995-08-10', 'peter.parker@marvel.com', '12345', 'M'),
--('Tony', 'Stark', '1970-05-29', 'tony.stark@marvel.com', '54321', 'M'),
--('Steve', 'Rogers', '1918-07-04', 'steve.rogers@marvel.com', '67890', 'M'),
--('Natasha', 'Romanoff', '1984-11-22', 'natasha.romanoff@marvel.com', '98765', 'F'),
--('Bruce', 'Banner', '1969-12-18', 'bruce.banner@marvel.com', '11111', 'M'),
--('Carol', 'Danvers', '1980-10-17', 'carol.danvers@marvel.com', '22222', 'F'),
--('Thor', 'Odinson', '1000-01-01', 'thor.odinson@marvel.com', '33333', 'M'),
--('Wanda', 'Maximoff', '1989-02-10', 'wanda.maximoff@marvel.com', '44444', 'F'),
--('Scott', 'Lang', '1982-07-06', 'scott.lang@marvel.com', '55555', 'M'),
--('TChalla', '', '1980-05-21', 'tchalla@marvel.com', '66666', 'M');

select * from clientes
select * from livros
select * from emprestimos
select * from autores

select * from clientes where primeiro_nome like 'T%';
select * from clientes where primeiro_nome like '[^T]%'
select * from clientes where primeiro_nome like '[Th]%' 
select * from clientes where primeiro_nome like '[^Th]%' 

-- UNION
SELECT primeiro_nome, ultimo_nome, 'Cliente' AS Tipo
FROM clientes
UNION
SELECT autor, titulo, 'Livro' AS Tipo
FROM livros;
-- EXCEPT

-- Clientes que não têm 'X' como gender
SELECT primeiro_nome
FROM clientes
WHERE gender = 'M'
-- DIVISION
-- Listar clientes que pegaram emprestado todos os livros com o ID 1 (apenas 1 livro)
SELECT c.primeiro_nome, c.ultimo_nome
FROM clientes c
WHERE NOT EXISTS (
    SELECT l.livro_ID
    FROM livros l
    WHERE l.livro_ID = '1'
    EXCEPT
    SELECT e.Emp_livro_ID
    FROM emprestimos e
    WHERE e.Emp_id_cliente = c.id_cliente
);
-- LEFT JOIN
SELECT c.*, e.*
FROM clientes c
LEFT JOIN emprestimos e ON c.id_cliente = e.Emp_id_cliente;
-- RIGHT JOIN 
SELECT c.*, e.*
FROM clientes c
RIGHT JOIN emprestimos e ON c.id_cliente = e.Emp_id_cliente;
-- FULL OUTER JOIN
SELECT c.*, e.*
FROM clientes c
FULL OUTER JOIN emprestimos e ON c.id_cliente = e.Emp_id_cliente;
-- SEMI JOIN
SELECT c.*
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM emprestimos e
    WHERE c.id_cliente = e.Emp_id_cliente
);
-- ANTI JOIN
SELECT c.*
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM emprestimos e
    WHERE c.id_cliente = e.Emp_id_cliente
);













--CREATE TABLE livros (
--    livro_ID INT IDENTITY(1,1) PRIMARY KEY,
--    titulo NVARCHAR(100) NOT NULL,
--    autor NVARCHAR(100),
--    ano INT,
--    disponivel BIT NOT NULL DEFAULT 1,
--    preco int
--);

--ALTERAR PREÇO PARA FLOAT
--alter table livros  
--add preco float
--update livros 
--set fotopath = 'hp_stone.jpg'
--where livro_ID = 4;
--GO
--create function fn_livros(@autor as nvarchar(max)) returns nvarchar(max)
--AS
--BEGIN
--    declare @idx int = charindex(' ',@autor);
--    return left(@autor, @idx)
--END
--GO
--select dbo.fn_livros('Stephen')

--ALTERAR NOMES DE COLUNAS
--EXEC sp_rename 'livros.livroID', 'livro_id' , 'COLUMN'
--EXEC sp_rename 'livros.AnoPublicacao', 'ano' , 'COLUMN'
--EXEC sp_rename 'livros.Disponivel', 'disponivel' , 'COLUMN'


--INSERT INTO livros (titulo, autor, ano, disponivel, preco)
--VALUES 
--    -- Livros de Stephen King
--    ('It', 'Stephen King', 1986, 1, 19.99),
--    ('The Shining', 'Stephen King', 1977, 1,19.99),
--    ('Misery', 'Stephen King', 1987, 1,19.99),
--    -- Livros de J.K. Rowling
--    ('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 1997, 1,25),
--    ('Harry Potter and the Chamber of Secrets', 'J.K. Rowling', 1998, 1,25),
--    ('Harry Potter and the Prisoner of Azkaban', 'J.K. Rowling', 1999, 1,25),
--    -- Livros de George R.R. Martin
--    ('A Game of Thrones', 'George R.R. Martin', 1996, 1,14.99),
--    ('A Clash of Kings', 'George R.R. Martin', 1998, 1,14.99),
--    ('A Storm of Swords', 'George R.R. Martin', 2000, 1,14.99),  
--    -- Outros livros aleatórios
--    ('Murder on the Orient Express', 'Agatha Christie', 1934, 1,20),
--    ('The Hobbit', 'J.R.R. Tolkien', 1937, 1,20),
--    ('Norwegian Wood', 'Haruki Murakami', 1987, 1,20),
--    ('Pride and Prejudice', 'Jane Austen', 1813, 1,20),
--    ('American Gods', 'Neil Gaiman', 2001, 1,20),
--    ('The Handmaid''s Tale', 'Margaret Atwood', 1985, 1,20);






--CREATE TABLE emprestimos (
--    numero_emprestimo INT IDENTITY(1,1) PRIMARY KEY,
--    Emp_id_cliente INT FOREIGN KEY REFERENCES clientes(id_cliente),
--    Emp_livro_ID INT FOREIGN KEY REFERENCES livros(livro_id),
--    Data_Emprestimo DATE NOT NULL,
--    Data_Devolucao DATE
--);

--INSERT INTO emprestimos (Emp_id_cliente, Emp_livro_ID, Data_Emprestimo)
--VALUES
--(1, 1, '2024-01-01'),  -- Cliente 1, Livro 1, emprestado de 1 de janeiro a 1 de fevereiro
--(2, 2, '2024-02-01'),  -- Cliente 2, Livro 2, emprestado de 1 de fevereiro a 1 de março
--(3, 3, '2024-03-01'),  -- Cliente 3, Livro 3, emprestado de 1 de março a 1 de abril
--(4, 4, '2024-04-01'),  -- Cliente 4, Livro 4, emprestado de 1 de abril a 1 de maio
--(5, 5, '2024-05-01');  -- Cliente 5, Livro 5, emprestado de 1 de maio a 1 de junho

--DELETE FROM emprestimos;
--DBCC CHECKIDENT ('emprestimos', RESEED, 1);


---- Criar o trigger para calcular a Data_Devolucao após inserção da Data_Emprestimo
--CREATE TRIGGER tr_calcular_data_devolucao
--ON emprestimos
--AFTER INSERT
--AS
--BEGIN
--    -- Atualizar a Data_Devolucao baseado na Data_Emprestimo
--    UPDATE emprestimos
--    SET Data_Devolucao = DATEADD(day, 5, i.Data_Emprestimo)  -- Adicionar 5 dias à Data_Emprestimo
--    FROM inserted i
--    WHERE emprestimos.numero_emprestimo = i.numero_emprestimo;
--END;
--drop table autores
--create table autores(
--    autor_nome nvarchar(100) primary key 
--)
--select * from livros
--insert into autores(autor_nome)
--    values
--    ('Stephen King'),
--    ('J.K. Rowling'),
--    ('George R.R. Martin'),
--    ('J.R.R. Tolkien')

