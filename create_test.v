module jany

fn test_null() {
	r := any_null()
	assert r == Any(null)
}

fn test_int() {
	r := any_number(1)
	assert r == Any(f64(1))
}

fn test_float() {
	r := any_number(1.2)
	assert r == Any(1.2)
}

fn test_boolean() {
	r := any_boolean(true)
	assert r == Any(true)
}

fn test_string() {
	r := any_string('a')
	assert r == Any('a')
}

fn test_array() {
	r := any_array([1])
	assert r == [Any(f64(1))]
}

fn test_object() {
	r := any_object({
		'a': 1
	})
	assert r == {
		'a': Any(f64(1))
	}
}
