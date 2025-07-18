extends Node2D

@onready var bumper_name_label: Label = %BumperNameLabel

@export var label_text: String = 'Bumper';
@export var audio_source: AudioSource.Source;
@export var sound_effect: AudioStream;

func _ready() -> void:
	bumper_name_label.text = label_text;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (audio_source == AudioSource.Source.MUSIC):
			AudioMessenger.toggle_music.emit(sound_effect);
		else:
			AudioMessenger.play_sfx.emit(audio_source, sound_effect);
