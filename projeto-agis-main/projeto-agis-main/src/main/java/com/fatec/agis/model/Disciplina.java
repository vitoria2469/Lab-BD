package com.fatec.agis.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Disciplina {
	private int id;
	private String nome;
	private String diaSemana;
	private String horaComeco;
	private int aulasHora;
}
