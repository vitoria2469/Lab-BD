package com.fatec.agis.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Matricula {
	
	private int anoIngresso;
	private int semestreIngresso;
	private int anoLimite;
	private Curso curso;
	
}
