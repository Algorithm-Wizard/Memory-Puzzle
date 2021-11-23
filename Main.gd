extends Node2D

const NONE := Vector2(-1,-1)

enum States {ready, peek, first, show, start}

export var fps := 30
export var windowWidth := 700
export var windowHeight := 490
export var boxSize := Vector2(55, 55)
export var gapSize := Vector2(10, 10)
export var boardWidth := 10
export var boardHeight := 7
export var showGroupsOf := 8
export var lightbgColor := Color.gray
export var bgColor := Color.cadetblue

var Box := preload("res://Box.tscn")

var margin := Vector2(
	(windowWidth - (boardWidth * (boxSize.x + gapSize.x)) + gapSize.x) / 2,
	(windowHeight - (boardHeight * (boxSize.y + gapSize.y)) + gapSize.y) / 2)
var firstSelection := NONE
var mainBoard :Array
var icons: Array
var preview: Array
var group: Array
var first:Icon
var peek:Icon
var state:int
var matches:int

func _ready():
	VisualServer.set_default_clear_color(bgColor)
	assert((boardHeight * boardWidth) % 2 == 0, "Board needs to have an even number of boxes for pairs of matches.")
	assert(Icon.Colors.size() * Icon.NUMSHAPES * 2 >= boardWidth * boardHeight, "Board is too big for the number of shapes/colors defined.")
	randomize()
	icons.clear()
	var pos := margin
	for y in boardHeight:
		pos.x = margin.x
		for x in boardWidth:
			var box = Box.instance()
			box.connect("clicked", self, "select")
			icons.append(box)
			add_child(box)
			box.set_size(boxSize)
			box.set_global_position(pos)
			pos.x += boxSize.x + gapSize.x
		pos.y += boxSize.y + gapSize.y
	start()

func _process(_delta):
	if Input.is_action_just_released("ui_quit"):
		get_tree().quit()

func start():
	mainBoard.clear()
	matches = 0
	for color in Icon.Colors:
		for shape in range(Icon.NUMSHAPES):
			mainBoard.append([shape, color])
	shuffle(mainBoard)
	mainBoard.resize(boardWidth * boardHeight / 2)
	mainBoard.append_array(mainBoard)
	shuffle(mainBoard)
	for index in range(mainBoard.size()):
		var icon := icons[index] as Icon
		icon.shape = mainBoard[index][0]
		icon.color = mainBoard[index][1]
		icon.hide()
	state = States.start
	$CanvasLayer/Button.show()

func shuffle(list :Array):
	var pick: int
	var swap
	for i in range(list.size(), 1, -1):
		pick = evenRand(i)
		swap = list[i - 1]
		list[i - 1] = list[pick]
		list[pick] = swap

func evenRand(num:int) -> int:
	var MAXINT := 4294967295
	var org = MAXINT - (MAXINT % num)
	var pick = randi()
	while(pick >= org):
		pick = randi()
	return pick % num

func select(box: Icon):
	var enter := state
	match state:
		States.ready:
			if box.covered:
				first = box
				box.covered = false
				state = States.first
		States.first:
			if box == first:
				box.covered = true
				state = States.ready
			elif first.shape == box.shape and first.color == box.color:
				box.covered = false
				state = States.ready
				matches += 2
				if matches >= icons.size():
					$Timer2.start()
			elif box.covered:
				peek = box
				state = States.peek
				box.covered = false
		States.peek:
			peek.covered = true
			first.covered = true
			if box == peek or box == first or not box.covered:
				state = States.ready
			else:
				first = box
				box.covered = false
				state = States.first

func _on_Timer_timeout():
	var index: int
	if state == States.show and preview.size() > 0 and showGroupsOf > 0:
		for icon in group:
			icon.covered = true
		group.clear()
		while group.size() < showGroupsOf and preview.size() > 0:
			index = evenRand(preview.size())
			group.append(preview[index])
			preview[index] = preview.back()
			preview.pop_back()
		for icon in group:
			icon.show()
			icon.covered = false
	else:
		for icon in group:
			icon.covered = true
		state = States.ready
		$Timer.stop()

func _on_Button_pressed():
	state = States.show
	preview = icons.duplicate()
	group.clear()
	$Timer.start()
	$CanvasLayer/Button.hide()
	$CanvasLayer/Label.hide()

func _on_Timer2_timeout():
	$CanvasLayer/Label.show()
	start()
