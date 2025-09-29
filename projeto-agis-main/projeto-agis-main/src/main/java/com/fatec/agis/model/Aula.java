package com.fatec.agis.model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Aula {

	private Disciplina disciplina;
	private LocalDate data;
}
