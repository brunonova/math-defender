class_name Option
# Interface for an Option in the ConfigFile.
# "value" will get the value from the ConfigFile, and changing it will save the
# new value to the ConfigFile.

var parent: Node          # the outer class
var section: String       # section that this option is in
var key: String           # key of this option
var default_value         # default value of the option
var on_changed            # function to call when the value is changed, with the new value as argument
var store: bool           # set to false to not store the value in the config

var value setget _set_value, _get_value


func _init(p_parent: Node, p_section: String, p_key: String, p_default_value, p_on_changed = null, p_store = true) -> void:
	parent = p_parent
	section = p_section
	key = p_key
	default_value = p_default_value
	on_changed = p_on_changed
	store = p_store
	value = default_value


# Toggles the value, if it's a boolean.
func toggle() -> void:
	if value is bool:
		self.value = not self.value


func _set_value(val) -> void:
	value = val
	if store:
		parent.config.set_value(section, key, val)
		# warning-ignore:return_value_discarded
		parent.config.save_encrypted_pass(parent.config_path, parent.config_pass)
	if on_changed:
		parent.call(on_changed, val)

func _get_value():
	return parent.config.get_value(section, key, default_value) if store else value
