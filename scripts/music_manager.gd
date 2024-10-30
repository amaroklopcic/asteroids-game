extends Node

## Volume to assign the music player, in range 0-1
@export_range(0, 1, 0.01) var volume: float = 1:
    set = _set_volume

@onready var stream = $BackgroundMusic


func _ready() -> void:
    print("initializing music player...")
    stream.play()


func _set_volume(vol: float):
    print("changing music volume to ", vol)
    stream.volume_db = linear_to_db(vol)
