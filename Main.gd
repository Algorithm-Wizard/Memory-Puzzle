extends Node2D

export var fps := 30
export var windowWidth := 640
export var windowHeight := 480
export var revealSpeed := 8
export var boxSize := Vector2(40, 40)
export var gapSize := Vector2(10, 10)
export var boardWidth := 10
export var boardHeight := 7
export var lightbgColor := Color.gray
export var bgColor := Color.cadetblue

var Box := preload("res://Box.tscn")

const NONE := Vector2(-1,-1)

const MAXINT := 4294967295

var margin := Vector2(
	(windowWidth - (boardWidth * (boxSize.x + gapSize.x)) + gapSize.x) / 2,
	(windowHeight - (boardHeight * (boxSize.y + gapSize.y)) + gapSize.y) / 2)

var firstSelection := NONE

var mainBoard :Array
var icons: Array
var revealedBoxes: Array

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
			icons.append(box)
			add_child(box)
			box.set_size(boxSize)
			box.set_global_position(pos)
			box.bgColor = bgColor
			pos.x += boxSize.x + gapSize.x
		pos.y += boxSize.y + gapSize.y
	start()

func _process(_delta):
	if Input.is_action_just_released("ui_quit"):
		get_tree().quit()

func start():
	mainBoard.clear()
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
	var out := ""

func shuffle(list :Array):
	var pick: int
	var org: int
	var swap
	for i in range(list.size(), 1, -1):
		org = MAXINT - (MAXINT % i)
		pick = randi()
		while(pick >= org):
			pick = randi()
		pick %= i
		swap = list[i - 1]
		list[i - 1] = list[pick]
		list[pick] = swap
