module jsany

fn test_is_null() {
	assert Any(null) is Null
}

fn test_null() {
	assert Any(null).typ() == 'null'
}

fn test_bool() {
	assert Any(true).typ() == 'boolean'
}

fn test_number() {
	assert Any(f64(1)).typ() == 'number'
}

fn test_string() {
	assert Any('a').typ() == 'string'
}

fn test_array() {
	assert Any([Any(f64(1))]).typ() == 'array'
}

fn test_object() {
	assert Any({
		'a': Any(f64(1))
	}).typ() == 'object'
}
