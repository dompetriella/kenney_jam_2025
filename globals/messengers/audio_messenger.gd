extends Node

signal play_sfx(
	source: AudioSource.Source,
	stream: AudioStream,
)

signal play_music(
	stream: AudioStream,
)

signal stop_music;

signal toggle_music(	stream: AudioStream);
