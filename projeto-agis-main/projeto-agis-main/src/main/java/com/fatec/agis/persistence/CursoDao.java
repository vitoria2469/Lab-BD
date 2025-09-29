package com.fatec.agis.persistence;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.fatec.agis.model.Curso;

@Repository
public class CursoDao implements DaoSimples<Curso>{

	private Connection connection;
	
	@Override
	public List<Curso> listar() throws SQLException, ClassNotFoundException {
		connection = SqlConnector.connect();
		String sql = "SELECT codigo, nome FROM curso";
		PreparedStatement statement = connection.prepareStatement(sql);
		ResultSet res = statement.executeQuery();
		List<Curso> cursos = new ArrayList<Curso>();
		
		while(res.next()) {
			Curso curso = new Curso();
			curso.setCodigo(res.getInt("codigo"));
			curso.setNome(res.getString("nome"));
			cursos.add(curso);
			
		}
		return cursos;
	}
}
