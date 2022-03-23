extends "res://entity/ball/normal/Ball_Normal.gd"

#--const
const EXPLOSION_SCALE = 4
const EXPLOSION_MULTIPLIER = 2

#--export
export (PackedScene) var explosion_fx

func _on_Ball_Bomb_body_entered(body):
	if !can_grab and $Explosion_Timer.time_left == 0:
		#explosion
		var e = explosion_fx.instance()
		e.global_position = global_position
		get_parent().add_child(e)
		e.scale *= EXPLOSION_SCALE
		linear_velocity = Vector2.ZERO
		deal_damage()
		#resize
		$Sprite.hide()
		#timer
		$Explosion_Timer.start()

#acts on bodies in the overlapping area
func deal_damage():
	for b in $Area2D.get_overlapping_bodies():
		if b.is_in_group("Player") or b.is_in_group("Bot"):
			b.take_damage(1)
		elif b.is_in_group("Ball") and b != self:
			#jettison away from center of explosion (non-proportionally from center)
			var dir = b.position.angle_to(position)
			var v_dir = Vector2(cos(dir), sin(dir))
			b.apply_central_impulse(v_dir * THROW_IMPULSE * EXPLOSION_MULTIPLIER)

#grab after dropped, but not thrown
func _on_Timer_timeout():
	if dropped:
		dropped = false
		can_grab = true

func _on_Explosion_Timer_timeout():
	queue_free()
