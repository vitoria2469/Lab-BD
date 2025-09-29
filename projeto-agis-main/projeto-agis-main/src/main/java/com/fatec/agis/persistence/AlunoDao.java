package com.fatec.agis.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.fatec.agis.model.Aluno;
import com.fatec.agis.model.Disciplina;
import com.fatec.agis.model.Historico;

@Repository
public class AlunoDao implements Dao<Aluno> {

	private Connection connection;
	
	@Override
	public void inserir(Aluno aluno) throws SQLException, ClassNotFoundException {
		connection = SqlConnector.connect();
		String sql = "EXEC insere_aluno(?,?,?,?,?,?,?,?,?,?,?,?,?)";
		CallableStatement statement = connection.prepareCall(sql);
		statement.setString(1, aluno.getCpf());
		statement.setString(2, aluno.getNome());
		statement.setString(3, aluno.getNomeSocial());
		statement.setDate(4, Date.valueOf(aluno.getDataNascimento()));
		statement.setString(5, aluno.getTelefone()[0]);
		statement.setString(6, aluno.getTelefone()[1]);
		statement.setString(7, aluno.getEmailPessoal());
		statement.setString(8, aluno.getEmailCorporativo());
		statement.setDate(9, Date.valueOf(aluno.getDataConclusaoSegundoGrau()));
		statement.setString(10, aluno.getInstituicaoSegundoGrau());
		statement.setFloat(11, aluno.getPontuacao());	
		statement.setInt(12, aluno.getPosicao());
		statement.setInt(13, aluno.getMatricula().getCurso().getCodigo());
		statement.execute();
	}
	
	@Override
	public void atualizar() throws SQLException, ClassNotFoundException {
	}
	
	@Override
	public Aluno consultar(Aluno e) throws SQLException, ClassNotFoundException {
		return null;
	}
	
	@Override
	public List<Aluno> listar() throws SQLException, ClassNotFoundException {
		connection = SqlConnector.connect();
		String sql = "SELECT ra, nome FROM aluno";
		PreparedStatement statement = connection.prepareStatement(sql);
		ResultSet res = statement.executeQuery();
		List<Aluno> alunos = new ArrayList<Aluno>();
		while(res.next()) {
			Aluno aluno = new Aluno();
			aluno.setRa(res.getString("ra"));
			aluno.setNome(res.getString("nome"));
			alunos.add(aluno);
		}
		return alunos;
	}
	
	public void matricularDisciplina(Aluno aluno, Disciplina disciplina) throws SQLException, ClassNotFoundException{
		connection = SqlConnector.connect();
		String sql = "CALL adiciona_disciplina(?, ?)";
		CallableStatement statement = connection.prepareCall(sql);
		statement.setString(1, aluno.getRa());
		statement.setInt(2, disciplina.getId());
		statement.execute();
	}
	
	public List<Aluno> listarAlunosChamada(Disciplina disciplina) throws SQLException, ClassNotFoundException{
		connection = SqlConnector.connect();
		String sql = "SELECT aluno_ra, aluno_nome FROM consulta_chamada(?)";
		PreparedStatement statement = connection.prepareStatement(sql);
		statement.setInt(1, disciplina.getId());
		ResultSet res = statement.executeQuery();
		List<Aluno> alunos = new ArrayList<Aluno>();
		while(res.next()) {
			Aluno aluno = new Aluno();
			aluno.setRa(res.getString("aluno_ra"));
			aluno.setNome(res.getString("aluno_nome"));
			alunos.add(aluno);
		}
		statement.close();
		connection.close();
		return alunos;
	}
	
	public List<Historico> listaHistorico(Aluno aluno) throws ClassNotFoundException, SQLException{
		connection = SqlConnector.connect();
		String sql = "SELECT codigoDisciplina, nomeDisciplina, professor, notaFinal, qtdeFaltas FROM consulta_historico(?)";
		PreparedStatement statement = connection.prepareStatement(sql);
		statement.setString(1, aluno.getRa());
		ResultSet res = statement.executeQuery();
		List<Historico> historicos = new ArrayList<Historico>();
		while(res.next()) {
			Historico historico = new Historico();
			historico.setCodigoDisciplina(res.getInt("codigoDisciplina"));
			historico.setNomeDisciplina(res.getString("nomeDisciplina"));
			historico.setProfessor(res.getString("professor"));
			historico.setNotaFinal(res.getFloat("notaFinal"));
			historico.setQtdeFaltas(res.getInt("qtdeFaltas"));
			historicos.add(historico);
		}
		return historicos;
	}
	
}
