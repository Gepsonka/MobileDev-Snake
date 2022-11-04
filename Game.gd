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
var grow = false

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

	self.move_body()
	
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
	
	if self.grow:
		self.grow()
		self.grow = false
		
	self.check_head_collision()
			
	
func check_head_collision():
	for body_part in self.body:
		if body_part.rect_position == $Snake/Head.rect_position:
			self.game_over()
	
func check_food_eaten():
	if $Food.rect_position == $Snake/Head.rect_position:
		self.add_score()
		$Food.change_poz()
		self.grow = true

func grow():
	var new_rect = ColorRect.new()
	new_rect.color = Color(232, 255, 63, 1)
	new_rect.set_size(Vector2(50,50))
	var relative_rect;
	var placing_direction;
	
	if len(self.body) == 0:
		relative_rect = $Snake/Head
		placing_direction = self.direction
	elif len(self.body) == 1:
		relative_rect = self.body[0]
		placing_direction = self.direction
	else:
		relative_rect = self.body[-1]
		if self.body[-1].rect_position.y < self.body[-2].rect_position.y:
			placing_direction = Direction.DOWN
		elif self.body[-1].rect_position.y > self.body[-2].rect_position.y:
			placing_direction = Direction.UP
		elif self.body[-1].rect_position.x < self.body[-2].rect_position.x:
			placing_direction = Direction.RIGHT
		elif self.body[-1].rect_position.x > self.body[-2].rect_position.x:
			placing_direction = Direction.LEFT
			
		
	match placing_direction:
		Direction.UP:
			new_rect.rect_position = Vector2(relative_rect.rect_position.x, relative_rect.rect_position.y + self.step)
		Direction.DOWN:
			new_rect.rect_position = Vector2(relative_rect.rect_position.x, relative_rect.rect_position.y - self.step)
		Direction.LEFT:
			new_rect.rect_position = Vector2(relative_rect.rect_position.x + self.step, relative_rect.rect_position.y)
		Direction.LEFT:
			new_rect.rect_position = Vector2(relative_rect.rect_position.x - self.step, relative_rect.rect_position.y)
	self.body.append(new_rect)
	$Snake.add_child(new_rect)
		
func move_body():
	if self.body.size() == 0:
		return
	for body_part_index in range(self.body.size()-1, -1, -1):
		if body_part_index == 0:
			self.body[body_part_index].rect_position = $Snake/Head.rect_position
		else:
			self.body[body_part_index].rect_position = self.body[body_part_index-1].rect_position


func add_score():
	self.score += 1
	$ScoreLabel.text = "Score: " + str(self.score)
	
func game_over():
	$Timer.stop()
	$GameOverMenu.visible = true

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
