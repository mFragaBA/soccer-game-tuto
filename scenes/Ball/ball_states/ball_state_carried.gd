class_name BallStateCarried
extends BallState

const dribble_frequency : float = 3
const dribble_intensity : float = 3
const offset_from_player := Vector2(10, 4)
var previous_heading : Vector2
var timer : float = 0

func _enter_tree() -> void:
	assert(carrier != null, "Ball in carried state has no carrier")
	previous_heading = carrier.heading
	
func _process(delta: float) -> void:
	if previous_heading.x != carrier.heading.x:
		print("resetting timer")
		timer = 0
	
	if carrier.velocity != Vector2.ZERO:
		if carrier.heading.x > 0:
			animation_player.play("roll")
		else:
			animation_player.play_backwards("roll")
		animation_player.advance(0)
				
		var vx = -cos(timer * dribble_frequency) * dribble_intensity
		ball.position = carrier.position + Vector2(carrier.heading.x * (vx + offset_from_player.x), offset_from_player.y)
		
		if abs(carrier.velocity.x) > 0:
			# Make kicking look more accelerated
			timer = (timer + 0.5 * delta) if timer > PI else (timer + 2 * delta)
			if timer > 2 * PI:
				timer -= 2 * PI
	else:
		animation_player.play("idle")
		
	previous_heading = carrier.heading
