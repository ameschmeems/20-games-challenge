extends StaticBody2D

signal deleted

func hit() -> void:
	emit_deleted()
	queue_free()

func emit_deleted() -> void:
	deleted.emit()