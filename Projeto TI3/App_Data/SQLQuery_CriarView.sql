﻿--CREATE VIEW v_emprestimos
--AS
--SELECT l.*, ISNULL(t.total, 0) AS total
--FROM livros l
--LEFT JOIN (
--    SELECT Emp_livro_ID, COUNT(*) AS total
--    FROM emprestimos
--    GROUP BY Emp_livro_ID
--) t ON l.livro_ID = t.Emp_livro_ID;

--CREATE VIEW v_livros
--AS
--select c.*,t.total from livros c left join
--	( 
--		select Emp_livro_ID, count(*) total from emprestimos group by Emp_livro_ID
--	)t on c.livro_ID=t.Emp_livro_ID;