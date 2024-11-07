extends Button
class_name MotivoBotaoSelecao

var motivoId: int

func inserePropriedadesDoComponente(motivoSelecaoId: int, motivoDescricao: String):
	self.motivoId = motivoSelecaoId
	self.text = motivoDescricao
