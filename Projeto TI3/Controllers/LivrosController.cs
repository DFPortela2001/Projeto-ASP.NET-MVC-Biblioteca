using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography.Xml;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

// ADICIONAR NAME SPACE PARA ACESSO AS ENTITIES
using Projeto_TI3.Models;


namespace Projeto_TI3.Controllers
{
    public class LivrosController : Controller
    {
        // GET: Livros
        public ActionResult ListaLivros(String msg)
        {
            using (DatabaseEntities1 db= new DatabaseEntities1())
            {
                ViewBag.msg = msg;
                List<v_livros> livros = db.v_livros.ToList();
                return View(livros);
            }
        }

        // INSERIR NOVO LIVRO
        public ActionResult InserirLivro()
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                List<autore> autores = db.autores.ToList();
                ViewBag.autores = new SelectList(autores, "autor_nome", "autor_nome");
                return View();
            }
        }
        [HttpPost]
        public ActionResult InserirLivro(livro novo, string preco, HttpPostedFileBase fich)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                db.livros.Add(novo);
                db.SaveChanges();

                if (fich != null && fich.FileName.Length > 0 && fich.ContentType.Contains("image"))
                {
                    String caminho = Server.MapPath("~/Fotos/");
                    String f = novo.livro_ID.ToString() + System.IO.Path.GetExtension(fich.FileName);
                    novo.fotopath = f;
                    caminho += f;
                    fich.SaveAs(caminho);
                    db.SaveChanges();
                }
                return RedirectToAction("ListaLivros", "Livros", new { msg = "Inserido com Sucesso" });
            }
        }

        //EDITAR 
        public ActionResult EditarLivros(int? id)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                List<autore> autores= db.autores.ToList();
                ViewBag.autores = new SelectList(autores, "autor_nome","autor_nome");
                livro este = db.livros.Find(id);
                if (este != null) return View(este);
                return RedirectToAction("ListaLivros", "Livros", new { msg = "Registo não existe" });
            }
        }
        [HttpPost]
        public ActionResult EditarLivros(livro editado, string txtpreco, HttpPostedFileBase fich)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                livro este = db.livros.Find(editado.livro_ID);
                double preco;
                if (este != null)
                {
                    este.titulo = editado.titulo;
                    este.autor = editado.autor;
                    txtpreco = txtpreco.Replace('.', ',');
                    if (double.TryParse(txtpreco, out preco))
                    {
                        este.preco = preco;
                    }
                    else este.preco = 0.0;
                    if (fich != null && fich.FileName.Length > 0 && fich.ContentType.Contains("image"))
                    {

                        string caminho = Server.MapPath("~/Fotos/");
                        string ficheiro = este.livro_ID.ToString() + System.IO.Path.GetExtension(fich.FileName);
                        if (este.fotopath != null && System.IO.File.Exists(caminho + este.fotopath))
                        {
                            System.IO.File.Delete(caminho + este.fotopath);
                        }
                        caminho += ficheiro;
                        este.fotopath = ficheiro;
                        fich.SaveAs(caminho);
                    }
                    db.SaveChanges();
                    return RedirectToAction("ListaLivros", "Livros", new { msg = "Registo editado" });
                }
                else return RedirectToAction("ListaLivros", "Livros", new { msg = "Registo não editado" });
            }
        }

        // DELETE
        public ActionResult DeleteLivro(int? id)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                Boolean existe_emprestimos = db.emprestimos.Where(x => x.Emp_livro_ID == id).Count() > 0;
                if (existe_emprestimos) return Json(new { msg = "Existem alugueres" }, JsonRequestBehavior.AllowGet);
                try
                {
                    livro este = db.livros.Find(id);
                    if (este != null)
                    {
                        db.livros.Remove(este);
                        db.SaveChanges();
                        return Json(new { msg = "ok" }, JsonRequestBehavior.AllowGet);
                    }
                    else return Json(new { msg = "Erro ao apagar" }, JsonRequestBehavior.AllowGet);
                }
                catch (SqlException erro)
                {
                    return Json(new { msg = erro.Message }, JsonRequestBehavior.AllowGet);
                }
            }
        }
        //  EDITAR NAO ESTÁ A MOSTRAR OS REGISTROS DOS EMPRESTIMOS :(
        public ActionResult DetailsLivros(int? id)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                livro este = db.livros.Find(id);
                if (este != null) return View(este);
                return RedirectToAction("ListaLivros", "Livros", new { msg = "Registo não existe" });
            }
        }
        public ActionResult livrosemprestimos(int? id)
        {
            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                List<emprestimo> emprestimos = db.emprestimos.Where(x => x.Emp_livro_ID == (id??-1)).ToList();
                return PartialView(emprestimos);

            }
        }
        public ActionResult editaremprestimo(int? id)
        {

            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                emprestimo este = db.emprestimos.Find(id);
                if (este != null) return View(este);
                return new EmptyResult();
            }
        }
        [HttpPost]
        public ActionResult editaluguer(emprestimo editado)
        {

            using (DatabaseEntities1 db = new DatabaseEntities1())
            {
                emprestimo este = db.emprestimos.Find(editado.numero_emprestimo);
                if (este != null)
                {
                    este.Data_Emprestimo = editado.Data_Emprestimo;
                    este.Data_Devolucao = editado.Data_Devolucao;
                    db.SaveChanges();
                }
                return RedirectToAction("DetailsLivros", "Livros", new { id = editado.numero_emprestimo });
            }
        }
    }
}
    
