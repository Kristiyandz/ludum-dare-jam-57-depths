extends Node

signal trigger_mines(event_data)
signal wakeup_alien_fish(event_data)

func send_event():
    emit_signal("trigger_mines")

func send_wakeup_alien_fish_event():
    emit_signal("wakeup_alien_fish")

