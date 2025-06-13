class_name BallStateCarried
extends BallState

func _enter_tree() -> void:
	assert(carrier != null, "Ball in carried state has no carrier")

func _process(_delta: float) -> void:
	ball.position = carrier.position
