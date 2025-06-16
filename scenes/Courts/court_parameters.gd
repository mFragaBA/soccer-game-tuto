class_name CourtParameters

var friction := 0.25
var bounciness := 0.4
var court_color : Color = Color.GREEN

func set_friction(friction : float) -> CourtParameters:
	friction = friction
	return self
	
func set_bounciness(bounciness : float) -> CourtParameters:
	bounciness = bounciness
	return self
