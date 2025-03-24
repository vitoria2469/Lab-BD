package com.example.CadastroSpring.Cliente;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

@Repository
public class ClienteDAO {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public ClienteDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	// Método para inserir cliente
	public void inserirCliente(String nome, String cpf, String telefone, String email) {
		SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("InsertCliente");

		jdbcCall.execute(nome, cpf, telefone, email);
	}

	// Método para atualizar cliente
	public void atualizarCliente(int id, String nome, String telefone, String email) {
		SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("UpdateCliente");

		jdbcCall.execute(id, nome, telefone, email);
	}

	// Método para excluir cliente
	public void excluirCliente(int id) {
		SimpleJdbcCall jdbcCall = new SimpleJdbcCall(jdbcTemplate).withProcedureName("DeleteCliente");

		jdbcCall.execute(id);
	}

}
