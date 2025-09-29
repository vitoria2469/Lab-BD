package com.fatec.agis.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.fatec.agis.model.Aluno;
import com.fatec.agis.model.Disciplina;

@Repository
public class DisciplinaDao implements DaoSimples<Disciplina>{

	Connection connection;
	
	@Override
	public List<Disciplina> listar() throws SQLException, ClassNotFoundException {
		connection = SqlConnector.connect();
		String sql = "SELECT id, nome, dia_semana, horaComeco, horasAula FROM disciplina";
		PreparedStatement statement = connection.prepareStatement(sql);
		ResultSet res = statement.executeQuery();
		List<Disciplina> disciplinas = new ArrayList<Disciplina>();
		while(res.next()) {
			Disciplina disciplina = new Disciplina();
			disciplina.setId(res.getInt("id"));
			disciplina.setNome(res.getString("nome"));
			disciplina.setDiaSemana(res.getString("dia_Semana"));
			disciplina.setHoraComeco(res.getTime("horaComeco").toString());
			disciplina.setAulasHora(res.getInt("horasAula"));
			disciplinas.add(disciplina);
		}
		return disciplinas;	
		}
	
	public List<Disciplina> listarDisciplinasDisponiveis(Aluno aluno) throws SQLException, ClassNotFoundException{
		connection = SqlConnector.connect();
		String sql = "SELECT disciplina_id, disciplina_nome, diaSemana, horaComeco, aulas FROM consulta_disciplinas(?)";
		PreparedStatement statement = connection.prepareStatement(sql);
		statement.setString(1, aluno.getRa());
		ResultSet res = statement.executeQuery();
		List<Disciplina> disciplinas = new ArrayList<Disciplina>();
		while(res.next()) {
			Disciplina disciplina = new Disciplina();
			disciplina.setId(res.getInt("disciplina_id"));
			disciplina.setNome(res.getString("disciplina_nome"));
			disciplina.setDiaSemana(res.getString("diaSemana"));
			disciplina.setHoraComeco(res.getTime("horaComeco").toString());
			disciplina.setAulasHora(res.getInt("aulas"));
			disciplinas.add(disciplina);
		}
		statement.close();
		connection.close();
		return disciplinas;
	}
	
	public Disciplina consultar(Disciplina disciplina) throws ClassNotFoundException, SQLException {
		connection = SqlConnector.connect();
		String sql = "SELECT nome, professor, horaComeco, horasAula, semestre FROM disciplina WHERE id = ?";
		PreparedStatement statement = connection.prepareStatement(sql);
		statement.setInt(1, disciplina.getId());
		ResultSet res = statement.executeQuery();
		if(res.next()) {
			disciplina.setNome(res.getString("nome"));
			disciplina.setHoraComeco(res.getString("horaComeco"));
			disciplina.setAulasHora(res.getInt("horasAula"));
		}
		statement.close();
		connection.close();
		return disciplina;
	}
	
	public int insereAula(Disciplina disciplina) throws SQLException, ClassNotFoundException{
		connection = SqlConnector.connect();
		int disciplinaId = 0;
		String sql = "INSERT INTO aula(disciplina_id, dataAula) VALUES (?,?)";
		PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		statement.setInt(1, disciplina.getId());
		statement.setDate(2, Date.valueOf(LocalDate.now()));
		statement.execute();
		ResultSet res = statement.getGeneratedKeys();
		if(res.next()) {
			disciplinaId = res.getInt(1);
		}
		statement.close();
		connection.close();
		return disciplinaId;
	}
	
	public void insereFrequencia(Aluno aluno, int aulaId, int aulas) throws SQLException, ClassNotFoundException{
		connection = SqlConnector.connect();
		String sql = "CALL insere_frequencia(?,?,?)";
		CallableStatement statement = connection.prepareCall(sql);
		statement.setInt(1, aulaId);
		statement.setString(2, aluno.getRa());
		statement.setInt(3, aulas);
		statement.execute();
		statement.close();
		connection.close();
	}
}
