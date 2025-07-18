extends Node

@onready var player_sfx: AudioStreamPlayer = %PlayerSFX
@onready var enemy_sfx: AudioStreamPlayer = %EnemySFX
@onready var music: AudioStreamPlayer = %Music
@onready var world_sfx: AudioStreamPlayer = %WorldSFX
@onready var interface_sfx: AudioStreamPlayer = %InterfaceSFX

func _ready() -> void:
	AudioMessenger.play_music.connect(_on_play_music.bind());
	AudioMessenger.play_sfx.connect(_on_play_sfx.bind());
	AudioMessenger.stop_music.connect(_on_stop_music);
	AudioMessenger.toggle_music.connect(on_toggle_music_playing)
	
func _on_stop_music():
	if (music.playing):
		music.stop();	
		
func _on_play_music(audio: AudioStream):
	if (music.playing):
		music.stop();
	music.stream = audio;
	music.play();

func on_toggle_music_playing(audio: AudioStream):
	if (music.playing):
		music.stop();
	else:
		music.stream = audio;
		music.play();

func _on_play_sfx(source: AudioSource.Source, audio: AudioStream):
	match (source):
		AudioSource.Source.PLAYER_SFX:
			player_sfx.stream = audio;
			player_sfx.play();
		AudioSource.Source.ENEMY_SFX:
			enemy_sfx.stream = audio;
			enemy_sfx.play();
		AudioSource.Source.WORLD_SFX:
			world_sfx.stream = audio;
			world_sfx.play();
		AudioSource.Source.UI_SFX:
			interface_sfx.stream = audio;
			interface_sfx.play();
	
