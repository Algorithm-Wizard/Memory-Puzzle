extends Control

class_name Icon

signal clicked(Icon)

export var boxColor := Color.white
export var highlightColor := Color.darkblue
export var bgColor := Color.black
export var speed := 4

const NUMSHAPES := 9
enum {DONUT, SQUARE, DIAMOND, OVAL, UP, DOWN, LINES, PLUS, TIMES}

const Colors := [Color.red, Color.green, Color.blue, Color.yellow, Color.orange, Color.purple, 
	Color.cyan, Color.hotpink, Color.slategray]

var coverage := 1.0
var shape := -1
var color := Color.white
var hovered := false
var covered := true

func hide():
	hovered = false
	.hide()

func _process(delta):
	if covered and coverage < 1.0:
		coverage += speed * delta
		update()
	elif not covered and coverage > 0.0:
		coverage -= speed * delta
		update()
	
func _draw():
	if hovered:
		draw_rect(Rect2(Vector2(-4, -4), rect_size + Vector2(8, 8)), highlightColor)
		draw_rect(Rect2(Vector2.ZERO, rect_size), bgColor)
	if (coverage >= 1.0):
		draw_rect(Rect2(Vector2.ZERO, rect_size), boxColor)
	elif (coverage <= 0.0):
		drawIcon()
	else:
		drawIcon()
		draw_rect(Rect2((1.0 - coverage) * rect_size.x, 0, coverage * rect_size.x, rect_size.y), boxColor)

func loc(x :float, y :float) -> Vector2:
		return Vector2(x, y) * rect_size * .1

func drawIcon():
	var boxSize := min(rect_size.x, rect_size.y)
	draw_rect(Rect2(loc(0,0),loc(10,10)), bgColor)
	match shape:
		DONUT:
			draw_circle(loc(5,5), boxSize * .4, color)
			draw_circle(loc(5,5), boxSize * .2, bgColor)
		DIAMOND:
			draw_colored_polygon([loc(5,1), loc(9,5), loc(5,9), loc(1,5)], color)
		SQUARE:
			draw_rect(Rect2(loc(2,2), loc(6,6)), color)
		OVAL:
			draw_set_transform(Vector2(rect_size.x * .1, rect_size.y * .25), 0, Vector2(.8, .5))
			draw_circle(loc(5,5), boxSize / 2, color)
			draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
		UP:
			draw_colored_polygon([loc(5,2), loc(9,5), loc(9,8), loc(5,5), loc(1,8), loc(1,5)], color)
		DOWN:
			draw_colored_polygon([loc(5,5), loc(9,2), loc(9,5), loc(5,8), loc(1,5), loc(1,2)], color)
		LINES:
			draw_rect(Rect2(loc(1,2), loc(8,2)), color)
			draw_rect(Rect2(loc(1,6), loc(8,2)), color)
		PLUS:
			draw_rect(Rect2(loc(4,1), loc(2,8)), color)
			draw_rect(Rect2(loc(1,4), loc(8,2)), color)
		TIMES:
			draw_colored_polygon([loc(2,1), loc(9,8), loc(8,9), loc(1,2)], color)
			draw_colored_polygon([loc(8,1), loc(9,2), loc(2,9), loc(1,8)], color)

func _on_Box_mouse_entered():
	hovered = true
	update()

func _on_Box_mouse_exited():
	hovered = false
	update()

func _on_Box_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", self)
