extends Area2D
class_name Escudo 

## Variables
var esta_activado: bool = false setget, get_esta_activado
var energia_original:float

## Variables Export
export var energia:float = 8.0
export var radio_desgaste = -1.6

## Setters y Getters
func get_esta_activado() -> bool:
	return esta_activado

## Metodos
func _process(delta: float) -> void:
	controlar_energia(radio_desgaste * delta)
	
	if energia <= 0.0:
		desactivar()

func _ready() -> void:
	energia_original = energia
	set_process(false)
	controlar_colisionador(true)
	
## Metodos Custom
func controlar_energia(consumo:float) -> void:
	energia += consumo
	
	if energia > energia_original: 
		energia = energia_original
	elif energia <= 0.0:
		desactivar()

func controlar_colisionador(esta_desactivado: bool)-> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)
	
func activar() -> void:
	if energia <= 0.0:
		return
		
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activando")

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("activando")
	
## Señales Internas 	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and esta_activado:
		$AnimationPlayer.play("activado")
		set_process(true)

func _on_body_entered(body: Node) -> void:
	body.queue_free()
