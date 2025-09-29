package com.fatec.agis.persistence;

import java.sql.SQLException;
import java.util.List;

import com.fatec.agis.model.Aula;

public class AulaDao implements Dao<Aula> {

	@Override
	public void inserir(Aula aula) throws SQLException, ClassNotFoundException {
	}
	
	@Override
	public void atualizar() throws SQLException, ClassNotFoundException {
	}
	
	@Override
	public Aula consultar(Aula e) throws SQLException, ClassNotFoundException {
		return null;
	}
	
	@Override
	public List<Aula> listar() throws SQLException, ClassNotFoundException {
		return null;
	}
}
