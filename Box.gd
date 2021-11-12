extends Control

class_name Icon

export var boxColor := Color.white
export var highlightColor := Color.blue

const NONE := -1

const NUMSHAPES := 7
enum {DONUT, SQUARE, DIAMOND, OVAL, UP, DOWN, LINES}

const Colors := [Color.red, Color.green, Color.blue, Color.yellow, Color.orange, Color.purple, Color.cyan, Color.hotpink, Color.darkgreen, Color.darkred]

var coverage := 0.0
var shape := NONE
var color := Color.white
var bgColor := Color.black
var hovered := false

func _ready():
	connect("mouse_entered", self, "mouseEntered")
	connect("mouse_exited", self, "mouseExited")
	
func _draw():
	if true:#hovered:
		draw_rect(Rect2(Vector2(-4, -4), rect_size + Vector2(8, 8)), highlightColor)
		draw_rect(Rect2(Vector2.ZERO, rect_size), bgColor)
	if (coverage >= 1.0):
		draw_rect(Rect2(Vector2.ZERO,rect_size), boxColor)
	elif (coverage <= 0.0):
		drawIcon()
	else:
		drawIcon()
		draw_rect(Rect2((1.0 - coverage) * rect_size.x, 0, coverage * rect_size.x, rect_size.y), boxColor)

func drawIcon():
	var boxSize := min(rect_size.x, rect_size.y)
	var wd := Vector2(rect_size.x, 0)
	var ht := Vector2(0, rect_size.y)
	var middle := rect_size / 2
	var high := Vector2(rect_size.x / 2, rect_size.y * .33)
	var low := Vector2(rect_size.x / 2, rect_size.y * .66)
	var midTop := wd * .5 + ht * .1
	var midBot := Vector2(middle.x, rect_size.y)
	var midRgt := Vector2(rect_size.x, middle.y)
	var higRgt := Vector2(rect_size.x, high.y)
	var lowRgt := Vector2(rect_size.x, low.y)
	var midLft := Vector2(0, middle.y)
	var higLft := Vector2(0, high.y)
	var lowLft := Vector2(0, low.y)
	match shape:
		DONUT:
			draw_circle(middle, boxSize * .4, color)
			draw_circle(middle, boxSize * .2, bgColor)
		DIAMOND:
			draw_colored_polygon([midTop, midRgt, wd*.5+ht*.9, midLft], color)
		SQUARE:
			draw_rect(Rect2(Vector2.ZERO, rect_size), color)
		OVAL:
			draw_set_transform(Vector2(rect_size.x * .1, rect_size.y * .25), 0, Vector2(.8, .5))
			draw_circle(middle, boxSize / 2, color)
		UP:
			draw_set_transform(Vector2(rect_size.x * .1, rect_size.y * .3), 0.0, Vector2(.9, .9))
			draw_colored_polygon([midTop, higRgt, lowRgt, high, lowLft, higLft], color)
		DOWN:
			draw_set_transform(Vector2(rect_size.x * .1, -rect_size.y * .2), 0.0, Vector2(.9, .9))
			draw_colored_polygon([midBot, lowLft, higLft, low, higRgt, lowRgt], color)
		LINES:
			draw_set_transform(Vector2(rect_size.x * .1, 0), 0.0, Vector2(.8, .8))
			draw_rect(Rect2(0, rect_size.y * .25, rect_size.x, boxSize / 4), color)
			draw_rect(Rect2(0, rect_size.y * .75, rect_size.x, boxSize / 4), color)
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func mouseEntered():
	hovered = true
	update()

func mouseExited():
	hovered = false
	update()
