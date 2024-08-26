CREATE TABLE "usuarios" (
	"usuarioId"	INTEGER NOT NULL,
	"nome"	TEXT NOT NULL CHECK("nome" != ''),
	"email"	TEXT NOT NULL CHECK("email" != ''),
	"senha"	TEXT NOT NULL CHECK("senha" != ''),
	"dataNascimento"	TEXT NOT NULL CHECK("dataNascimento" != ''),
	"telefone"	INTEGER CHECK(typeof("telefone") = 'integer'),
	"isDesativado"	INTEGER DEFAULT 0 CHECK(typeof("isDesativado") = 'integer' AND "isDesativado" IN (1, 0)),
	PRIMARY KEY("usuarioId" AUTOINCREMENT)
)