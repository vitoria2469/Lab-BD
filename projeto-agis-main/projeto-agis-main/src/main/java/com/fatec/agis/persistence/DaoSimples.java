package com.fatec.agis.persistence;

import java.sql.SQLException;
import java.util.List;

public interface DaoSimples<E>{

	public List<E> listar() throws SQLException, ClassNotFoundException;
}
