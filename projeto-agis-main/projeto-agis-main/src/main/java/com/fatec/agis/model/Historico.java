package com.fatec.agis.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Historico {

	private int codigoDisciplina;
	private String nomeDisciplina;
	private String professor;
	private float notaFinal;
	private int qtdeFaltas;
}
