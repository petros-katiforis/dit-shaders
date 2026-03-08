extends CanvasItem

@export var transition_duration: float = 0.6 

# We need some way of cancelling pending, overlapping transitions
# We will intropduce some state
var is_covering: bool = false
var current_tween: Tween

func toggle() -> void:
	# Kill and stay at your current position
	if current_tween:
		current_tween.kill()

	if is_covering:
		transition_off()
	else:
		transition_on()

func transition_on() -> void:
	is_covering = true
	current_tween = create_tween()

	# EASE_OUT means that we're going to apply our transition (bouncy)
	# towards the end of the operation
	current_tween.tween_property(material, "shader_parameter/progress", 1.0, transition_duration) \
		.set_trans(Tween.TRANS_BOUNCE) \
		.set_ease(Tween.EASE_OUT)

func transition_off() -> void:
	is_covering = false
	current_tween = create_tween()
	
	current_tween.tween_property(material, "shader_parameter/progress", 0.0, transition_duration * 0.8) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		
func _unhandled_input(event: InputEvent) -> void:
	# This checks if the specific action we created was just pressed
	if event.is_action_released("action_accept"):
		toggle()
