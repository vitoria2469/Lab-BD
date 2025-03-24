package com.example.CadastroSpring.Cliente;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/cliente")
public class ClienteController {

	@Autowired
	private ClienteDAO clienteDAO;

	@PostMapping("/adicionar")
	public String adicionarCliente(@RequestParam String nome, @RequestParam String cpf, @RequestParam String telefone,
			@RequestParam String email) {
		clienteDAO.inserirCliente(nome, cpf, telefone, email);
		return "redirect:/cliente/lista";
	}

	@PostMapping("/atualizar")
	public String atualizarCliente(@RequestParam int id, @RequestParam String nome, @RequestParam String telefone,
			@RequestParam String email) {
		clienteDAO.atualizarCliente(id, nome, telefone, email);
		return "redirect:/cliente/lista";
	}

	@PostMapping("/excluir")
	public String excluirCliente(@RequestParam int id) {
		clienteDAO.excluirCliente(id);
		return "redirect:/cliente/lista";
	}

}
