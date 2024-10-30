extends Node

## Volume to assign the music player, in range 0-1
@export_range(0, 1, 0.01) var volume: float = 1:
    set = _set_volume

enum SoundType {
    ASTEROID_HIT,
    GAME_OVER,
    PLAYER_DEATH,
    PLAYER_HURT,
    PLAYER_SHOOT,
}

@onready var sound_map: Dictionary = {
    SoundType.ASTEROID_HIT: $AsteroidHitAudio,
    SoundType.GAME_OVER: $GameOverAudio,
    SoundType.PLAYER_DEATH: $PlayerDeathAudio,
    SoundType.PLAYER_HURT: $PlayerHurtAudio,
    SoundType.PLAYER_SHOOT: $PlayerShootAudio,
}

var sound_streams: Array[Node] = []


func _ready() -> void:
    print("initializing sound player...")
    # initialize reference to AudioStreamPlayer2D instances and set their initial volume to
    # the maximum
    sound_streams = get_children()
    for stream in sound_streams:
        stream.volume_db = linear_to_db(1)


func _set_volume(vol: float):
    print("changing sound volume to ", vol)
    for stream in sound_streams:
        stream.volume_db = linear_to_db(vol)


func play(sound: SoundType):
    sound_map[sound].play()
