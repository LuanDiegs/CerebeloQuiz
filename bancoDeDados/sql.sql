CREATE TABLE usuarios (
	usuarioId	INTEGER NOT NULL,
	nome	TEXT NOT NULL CHECK(nome != ''),
	email	TEXT NOT NULL CHECK(email != ''),
	senha	TEXT NOT NULL CHECK(senha != ''),
	dataNascimento TEXT NOT NULL CHECK(dataNascimento != ''),
	telefone INTEGER CHECK(telefone == NULL OR typeof(telefone) = 'integer'),
	isDesativado INTEGER DEFAULT 0 CHECK(typeof(isDesativado) = 'integer' AND isDesativado IN (1, 0)),
	PRIMARY KEY(usuarioId AUTOINCREMENT)
);

CREATE TABLE quizzes (
	quizId INTEGER NOT NULL,
	titulo TEXT NOT NULL CHECK(titulo != ''),
	isPrivado	INTEGER NOT NULL CHECK(typeof(isPrivado) = 'integer' AND isPrivado IN (1, 0)),
	classificacaoIndicativa INTEGER NOT NULL CHECK(typeof(classificacaoIndicativa) = 'integer' AND classificacaoIndicativa IN (1, 2)),
	usuarioId	INTEGER NOT NULL,
	PRIMARY KEY(quizId AUTOINCREMENT),
	CONSTRAINT usuarioFk
		FOREIGN KEY (usuarioId)
		REFERENCES usuarios(usuarioId)
);

CREATE INDEX quizzesUsuarioIdIdx
ON quizzes (usuarioId);

CREATE TABLE perguntas (
	perguntaId INTEGER NOT NULL,
	conteudoPergunta TEXT NOT NULL CHECK(conteudoPergunta != ''),
	quizId INTEGER NOT NULL,
	PRIMARY KEY(perguntaId AUTOINCREMENT),
	CONSTRAINT quizFk
		FOREIGN KEY (quizId)
		REFERENCES quizzes(quizId)
		ON DELETE CASCADE
);

CREATE INDEX perguntasQuizIdIdx
ON perguntas (quizId);

CREATE TABLE alternativas (
	alternativaId INTEGER NOT NULL,
	conteudoAlternativa TEXT NOT NULL CHECK(conteudoAlternativa != ''),
	isAlternativaCorreta INTEGER NOT NULL CHECK(typeof(isAlternativaCorreta) = 'integer' AND isAlternativaCorreta IN (1, 0)),
	perguntaId INTEGER NOT NULL,
	PRIMARY KEY(alternativaId AUTOINCREMENT),
	CONSTRAINT perguntaFk
		FOREIGN KEY (perguntaId)
		REFERENCES perguntas(perguntaId)
		ON DELETE CASCADE
);

CREATE INDEX alternativasPerguntaIdIdx
ON alternativas (perguntaId);

CREATE TABLE rankingPessoal (
	rankingPessoalId INTEGER NOT NULL,
	pontuacao INTEGER NOT NULL CHECK(typeof(pontuacao) = 'integer'),
	quizId INTEGER NOT NULL,
	usuarioId INTEGER NOT NULL,
	PRIMARY KEY(rankingPessoalId AUTOINCREMENT),
	CONSTRAINT quizFk
		FOREIGN KEY (quizId)
		REFERENCES quizzes(quizId)
	CONSTRAINT usuarioFk
		FOREIGN KEY (usuarioId)
		REFERENCES usuarios(usuarioId)
);

CREATE INDEX rankingPessoalQuizIdIdx
ON rankingPessoal (quizId);

CREATE INDEX rankingPessoalUsuarioIdIdx
ON rankingPessoal (usuarioId);


CREATE TABLE quizzesFavoritos (
	quizFavoritoId INTEGER NOT NULL,
	quizId INTEGER NOT NULL,
	usuarioId INTEGER NOT NULL,
	PRIMARY KEY(quizFavoritoId AUTOINCREMENT),
	CONSTRAINT quizFk
		FOREIGN KEY (quizId)
		REFERENCES quizzes(quizId)
	CONSTRAINT usuarioFk
		FOREIGN KEY (usuarioId)
		REFERENCES usuarios(usuarioId)
);

CREATE INDEX quizzesFavoritosQuizIdIdx
ON quizzesFavoritos (quizId);

CREATE INDEX quizzesFavoritosUsuarioIdIdx
ON quizzesFavoritos (usuarioId);

CREATE TABLE denuncias(
	denunciaId INTEGER NOT NULL,
	justificativa TEXT NOT NULL CHECK(justificativa != ''),
	quizId INTEGER NOT NULL,
	usuarioId INTEGER NOT NULL,
	PRIMARY KEY(denunciaId AUTOINCREMENT)
	CONSTRAINT quizFk
		FOREIGN KEY (quizId)
		REFERENCES quizzes(quizId)
	CONSTRAINT usuarioFk
		FOREIGN KEY (usuarioId)
		REFERENCES usuarios(usuarioId)
);

CREATE INDEX denunciasQuizIdIdx
ON denuncias (quizId);

CREATE INDEX denunciasUsuarioIdIdx
ON denuncias (usuarioId);

CREATE TABLE denunciaMotivos(
	denunciaMotivosId INTEGER NOT NULL,
	denunciaId INTEGER NOT NULL,
	motivoId INTEGER NOT NULL,
	PRIMARY KEY(denunciaMotivosId AUTOINCREMENT)
	CONSTRAINT denunciaFk
		FOREIGN KEY (denunciaId)
		REFERENCES denuncias(denunciaId)
	CONSTRAINT motivosFk
		FOREIGN KEY (motivoId)
		REFERENCES motivosDenuncia(motivoId)
);

CREATE INDEX denunciaMotivosDenunciaIdIdx
ON denunciaMotivos (denunciaId);

CREATE INDEX denunciaMotivosMotivoIdIdx
ON denunciaMotivos (motivoId);

CREATE TABLE motivosDenuncia(
	motivosDenunciaId INTEGER NOT NULL,
	descricao TEXT NOT NULL CHECK(descricao != ''),
	PRIMARY KEY(motivosDenunciaId AUTOINCREMENT)
);

CREATE TABLE comentarios(
	comentarioId INTEGER NOT NULL,
	comentarioDescricao TEXT NOT NULL CHECK(comentarioDescricao != ''),
	quizId INTEGER NOT NULL,
	usuarioId INTEGER NOT NULL,
	PRIMARY KEY(comentarioId AUTOINCREMENT)
	CONSTRAINT quizFk
		FOREIGN KEY (quizId)
		REFERENCES quizzes(quizId)
	CONSTRAINT usuarioFk
		FOREIGN KEY (usuarioId)
		REFERENCES usuarios(usuarioId)
);

CREATE INDEX comentariosQuizIdIdx
ON comentarios (quizId);

CREATE INDEX comentariosUsuarioIdIdx
ON comentarios (usuarioId);

-- Insercao dos itens
INSERT INTO usuarios(nome, email, senha, dataNascimento, telefone, isDesativado) 
	VALUES ('dev', 'dev@dev', '123', '2000-01-01', 999999999, 0);	