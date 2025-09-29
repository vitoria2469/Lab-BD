package com.fatec.agis.model;

import java.time.LocalDate;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Aluno {

	private String cpf;
	private String ra;
	private String nome;
	private String nomeSocial;
	private LocalDate dataNascimento;
	private String telefone[];
	private String emailPessoal;
	private String emailCorporativo;
	private LocalDate dataConclusaoSegundoGrau;
	private String instituicaoSegundoGrau;
	private int pontuacao;
	private int posicao;
	private Matricula matricula;
	
	public void setNomeSocial(String nomeSocial) {
		if(nomeSocial.isEmpty()) {
			this.nomeSocial = "";
		}
		else {
			this.nomeSocial = nomeSocial;
		}
	}
	
}
