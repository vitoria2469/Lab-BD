package com.fatec.agis.persistence;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.fatec.agis.model.Matricula;

public class MatriculaDao implements Dao<Matricula> {

	private Connection connection;
	
	@Override
	public void inserir(Matricula matricula) throws SQLException, ClassNotFoundException {
		
	}
	

	
	@Override
	public void atualizar() throws SQLException, ClassNotFoundException {
	}
	
	@Override
	public Matricula consultar(Matricula e) throws SQLException, ClassNotFoundException {
		return null;
	}
	
	@Override
	public List<Matricula> listar() throws SQLException, ClassNotFoundException {
		return null;
	}
}
