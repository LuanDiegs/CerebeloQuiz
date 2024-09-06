CREATE TABLE "usuarios" (
	"usuarioId"	INTEGER NOT NULL,
	"nome"	TEXT NOT NULL CHECK("nome" != ''),
	"email"	TEXT NOT NULL CHECK("email" != ''),
	"senha"	TEXT NOT NULL CHECK("senha" != ''),
	"dataNascimento" TEXT NOT NULL CHECK("dataNascimento" != ''),
	"telefone" INTEGER CHECK("telefone" == NULL OR typeof("telefone") = 'integer'),
	"isDesativado"	INTEGER DEFAULT 0 CHECK(typeof("isDesativado") = 'integer' AND "isDesativado" IN (1, 0)),
	PRIMARY KEY("usuarioId" AUTOINCREMENT)
)

CREATE TABLE "quizzes" (
	"quizId" INTEGER NOT NULL,
	"titulo" TEXT NOT NULL CHECK("titulo" != ''),
	"isPrivado"	INTEGER NOT NULL CHECK(typeof("isPrivado") = 'integer' AND "isPrivado" IN (1, 0)),
	"classificacaoIndicativa" INTEGER NOT NULL CHECK(typeof("classificacaoIndicativa") = 'integer' AND "classificacaoIndicativa" IN (1, 2)),
	"usuarioId"	TEXT NOT NULL CHECK("usuarioId" != ''),
	FOREIGN KEY("usuarioId") REFERENCES "usuarios"("usuarioId"),
	PRIMARY KEY("quizId" AUTOINCREMENT)
)