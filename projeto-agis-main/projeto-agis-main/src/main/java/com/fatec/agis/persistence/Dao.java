package com.fatec.agis.persistence;

import java.sql.SQLException;
import java.util.List;

public interface Dao<E> {

	public void inserir(E e) throws SQLException, ClassNotFoundException;
	
	public void atualizar() throws SQLException, ClassNotFoundException;
	
	public E consultar(E e) throws SQLException, ClassNotFoundException;
	
	public List<E> listar() throws SQLException, ClassNotFoundException;
}
