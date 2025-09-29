package com.fatec.agis.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fatec.agis.model.Aluno;
import com.fatec.agis.model.Curso;
import com.fatec.agis.model.Disciplina;
import com.fatec.agis.model.Historico;
import com.fatec.agis.persistence.AlunoDao;
import com.fatec.agis.persistence.CursoDao;
import com.fatec.agis.persistence.DisciplinaDao;

@Controller
public class AlunoController {

	@Autowired
	CursoDao cursoDao;
	
	@Autowired
	AlunoDao alunoDao;
	
	@Autowired
	DisciplinaDao disciplinaDao;
	
	@GetMapping("/novoaluno")
	public String getNovoAluno(Model model) {
		List<Curso> cursos = new ArrayList<Curso>();
		try {
			cursos = cursoDao.listar();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		model.addAttribute("cursos", cursos);
		return "novoaluno";
	}
	
	@PostMapping("/novoaluno")
	public String postNovoAluno(@ModelAttribute Aluno aluno) {
		try {
			alunoDao.inserir(aluno);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		return "redirect:/";
	}
	
	@GetMapping("/matricula")
	public String getMatriculas(Model model) {
		List<Aluno> alunos = new ArrayList<Aluno>();
		try {
			alunos = alunoDao.listar();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		model.addAttribute("alunos", alunos);
		return "matricula";
	}
	
	@GetMapping("/listaDisciplinas")
	public String getDisciplinas(@RequestParam String ra, Model model) {
		List<Disciplina> disciplinas = new ArrayList<Disciplina>();
		Aluno aluno = new Aluno();
		aluno.setRa(ra);
		try {
			disciplinas = disciplinaDao.listarDisciplinasDisponiveis(aluno);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		model.addAttribute("disciplinas", disciplinas);
		model.addAttribute("aluno", aluno);
		return "matricula";
	}
	
	@PostMapping("/matricula")
	public String postMatricula(@ModelAttribute("id") ArrayList<Integer> id, @ModelAttribute("ra") String ra) {
		for(Integer Id : id) {
			Disciplina disciplina = new Disciplina();
			disciplina.setId(Id);
			Aluno aluno = new Aluno();
			aluno.setRa(ra);
			try {
				alunoDao.matricularDisciplina(aluno, disciplina);
			} catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
				return "erro";
			}
		}
		return "redirect:/";
	}
	
	@GetMapping("/chamada")
	public String getChamada(Model model) {
		List<Disciplina> disciplinas = new ArrayList<Disciplina>();
		try {
			disciplinas = disciplinaDao.listar();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		model.addAttribute("disciplinas", disciplinas);
		return "chamada";
	}
	
	@GetMapping("/listarAlunos")
	public String listaAlunos(@RequestParam int disciplinaId, Model model) {
		List<Aluno> alunos = new ArrayList<Aluno>();
		Disciplina disciplina = new Disciplina();
		disciplina.setId(disciplinaId);
		try {
			alunos = alunoDao.listarAlunosChamada(disciplina);
			disciplina = disciplinaDao.consultar(disciplina);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		model.addAttribute("alunos", alunos);
		model.addAttribute("disciplina", disciplina);
		return "chamada";
	}
	
	@PostMapping("/chamada")
	public String postChamada(@RequestParam("ra") ArrayList<String> ras, @RequestParam("aulas") ArrayList<Integer> aulas, @RequestParam("disciplinaId") int id){
		//inserir uma nova aula
		Disciplina disciplina = new Disciplina();
		disciplina.setId(id);
		int aulaId;
		try {
			aulaId = disciplinaDao.insereAula(disciplina);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			return "erro";
		}
		//inserir as frequencia
		for(String ra : ras) {
			for(Integer aula : aulas) {
				Aluno aluno = new Aluno();
				aluno.setRa(ra);
				try {
					disciplinaDao.insereFrequencia(aluno, aulaId, aula);
				} catch (ClassNotFoundException | SQLException e) {
					e.printStackTrace();
					return "erro";
				}
			}
		}
		return "redirect:/";
	}
	
	@GetMapping("/historico")
	public String getHistorico(Model model) {
		List<Aluno> alunos = new ArrayList<Aluno>();
		try {
			alunos = alunoDao.listar();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		model.addAttribute("alunos", alunos);
		return "historico";
	}
	
	
	@PostMapping("/historico")
	public String postHistorico(@ModelAttribute("ra") String ra, Model model) {
		Aluno aluno = new Aluno();
		aluno.setRa(ra);
		List<Historico> historicos = new ArrayList<Historico>();
		try {
			historicos = alunoDao.listaHistorico(aluno);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		model.addAttribute("historicos", historicos);
		return "historico";
	}
	
}
