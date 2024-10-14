extends Button
class_name MotivoBotaoSelecao

var motivoId: int
var motivoDescricao: String


func inserePropriedadesDoComponente(motivoId: int, motivoDescricao: String):
	self.motivoId = motivoId
	self.text = motivoDescricao
