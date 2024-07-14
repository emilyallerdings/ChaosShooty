extends CharacterBody2D

enum EnemyState {IDLE_STATE, ATTACK_STATE,MOVEMENT_STATE,COLLISION}
var current_state: EnemyState = EnemyState.MOVEMENT_STATE
@onready var player := get_tree().get_first_node_in_group("player")
@export var speed = 20;

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var enemies := get_tree().get_nodes_in_group("enemy")
@export var min_Distance = 3



var enemy_ID = 1
var nav_tick = 0

@export var isattacking = false;
var attackSpeed = 200;
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = player.position - self.position 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	match current_state:
		EnemyState.IDLE_STATE:
			print("hi")
		EnemyState.ATTACK_STATE:
			if(isattacking):
				isattacking = false
				$AttackTimer.start()
				direction = (player.position - self.position).normalized()
				
			velocity = direction * attackSpeed		
				
		EnemyState.MOVEMENT_STATE:
			DirectionProcess(delta)
			
		EnemyState.COLLISION:
			
			pass
		_:
			print("Unknown state")
	
	nav_tick = (nav_tick + 1) % 20
	if nav_tick == enemy_ID:
		MakePath()
	
	velocity = velocity.lerp(Vector2.ZERO, delta*5)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		current_state = EnemyState.COLLISION
		velocity = velocity.bounce(collision.get_normal())
		#if collision.get_collider() == player:
			#velocity = velocity.bounce(collision.get_normal())
		#else:
			#velocity = velocity.slide(collision.get_normal())
			
func DirectionProcess(delta):
	
	var next_position = nav_agent.get_next_path_position()
	
	var dir = to_local(next_position).normalized()
	velocity = dir * speed
	
	
	if(global_position.distance_to(player.global_position) < 150):
		isattacking = true;
		current_state =  EnemyState.ATTACK_STATE

func  MakePath():
	nav_agent.target_position = player.global_position
	#print(nav_agent.target_position)

func _on_timer_timeout():
	#MakePath()
	pass # Replace with function body.




func _on_attack_timer_timeout():
	velocity = Vector2.ZERO
	current_state = EnemyState.MOVEMENT_STATE
	pass # Replace with function body.
