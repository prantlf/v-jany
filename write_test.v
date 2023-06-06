module jsany

fn test_null() {
	r := Any(null).str()
	assert r == 'null'
}

fn test_int() {
	r := Any(f64(1)).str()
	assert r == '1'
}

fn test_float() {
	r := Any(1.2).str()
	assert r == '1.2'
}

fn test_bool() {
	r := Any(true).str()
	assert r == 'true'
}

fn test_string() {
	r := Any('a').str()
	assert r == 'a'
}

fn test_empty_array() {
	r := Any([]Any{}).str()
	assert r == '[]'
}

fn test_array_1() {
	r := Any([Any(f64(1))]).str()
	assert r == '[1]'
}

fn test_array_2() {
	r := Any([Any(f64(1)), Any(f64(2))]).str()
	assert r == '[1,2]'
}

fn test_empty_object() {
	r := Any(map[string]Any{}).str()
	assert r == '{}'
}

fn test_object_1() {
	r := Any({
		'a': Any(f64(1))
	}).str()
	assert r == '{a:1}'
}

fn test_object_2() {
	r := Any({
		'a': Any(f64(1))
		'b': Any(f64(2))
	}).str()
	assert r == '{a:1,b:2}'
}
