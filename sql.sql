CREATE TABLE "usuarios" (
	"usuarioId"	INTEGER NOT NULL,
	"nome"	TEXT NOT NULL,
	"email"	TEXT NOT NULL,
	"senha"	TEXT NOT NULL,
	"dataNascimento"	TEXT NOT NULL,
	"telefone"	INTEGER,
	"isDesativado"	INTEGER DEFAULT 0,
	PRIMARY KEY("usuarioId" AUTOINCREMENT)
);