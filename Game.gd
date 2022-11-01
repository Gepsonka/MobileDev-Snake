extends Node2D

enum Direction {
	UP = 1,
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4
}

var score = 0
var body = []
var direction = Direction.RIGHT
var step = 50

onready var timer = $Timer
onready var head = $Snake/Head
onready var food = $Food

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "update")
	self.get_node("PauseMenu").visible = false
	self.get_node("GameOverMenu").visible = false
	self.get_node("ScoreLabel").text = "Score: " + str(self.score)
	
	timer.start()

func update():
	match direction:
		Direction.UP:
			$Snake/Head.rect_position = Vector2($Snake/Head.rect_position.x, $Snake/Head.rect_position.y - step)
		Direction.DOWN:
			$Snake/Head.rect_position = Vector2($Snake/Head.rect_position.x, $Snake/Head.rect_position.y + step)
		Direction.RIGHT:
			$Snake/Head.rect_position = Vector2($Snake/Head.rect_position.x + step, $Snake/Head.rect_position.y)
		Direction.LEFT:
			$Snake/Head.rect_position = Vector2($Snake/Head.rect_position.x - step, $Snake/Head.rect_position.y)
			
	if $Snake/Head.rect_position.x < 0:
		$Snake/Head.rect_position.x = 600 - step
	if $Snake/Head.rect_position.x >= 600:
		$Snake/Head.rect_position.x = 0
	if $Snake/Head.rect_position.y >= 900:
		$Snake/Head.rect_position.y = 0
	if $Snake/Head.rect_position.y < 0:
		$Snake/Head.rect_position.y = 900 - step
		
	self.check_food_eaten()
			
	
func check_head_collision():
	if self.head.position == self.food.position:
		grow()
		self.food.change_poz()
	
func check_food_eaten():
	if $Food.position == $Snake/Head.rect_position:
		self.add_score()
		$Food.change_poz()

func grow():
	pass

func add_score():
	self.score += 1
	$ScoreLabel.text = "Score: " + str(self.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_UP) and direction != Direction.DOWN:
		direction = Direction.UP
	elif Input.is_key_pressed(KEY_DOWN) and direction != Direction.UP:
		direction = Direction.DOWN
	elif Input.is_key_pressed(KEY_LEFT) and direction != Direction.RIGHT:
		direction = Direction.LEFT
	elif Input.is_key_pressed(KEY_RIGHT) and direction != Direction.LEFT:
		direction = Direction.RIGHT
