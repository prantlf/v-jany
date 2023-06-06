module jsany

fn test_empty_path() {
	Any(null).get('') or {
		assert err.msg() == 'empty path'
		return
	}
	assert false
}

fn test_no_object() {
	Any(f64(1)).get('a') or {
		assert err.msg() == 'number is not an object'
		return
	}
	assert false
}

fn test_no_array() {
	Any(f64(1)).get('[0]') or {
		assert err.msg() == 'number is not an array'
		return
	}
	assert false
}

fn test_key() {
	r := Any({
		'a': Any(f64(1))
	}).get('a')!
	assert r.number()! == 1
}

fn test_no_key() {
	Any({
		'a': Any(f64(1))
	}).get('b') or {
		assert err.msg() == 'no value for key "b"'
		return
	}
	assert false
}

fn test_key_key() {
	r := Any({
		'a': Any({
			'b': Any(f64(1))
		})
	}).get('a.b')!
	assert r.number()! == 1
}

fn test_name() {
	r := Any({
		'a': Any(f64(1))
	}).get('"a"')!
	assert r.number()! == 1
}

fn test_name_name() {
	r := Any({
		'a': Any({
			'b': Any(f64(1))
		})
	}).get('"a".\'b\'')!
	assert r.number()! == 1
}

fn test_name_key() {
	r := Any({
		'a': Any({
			'b': Any(f64(1))
		})
	}).get('"a".b')!
	assert r.number()! == 1
}

fn test_key_name() {
	r := Any({
		'a': Any({
			'b': Any(f64(1))
		})
	}).get("a.'b'")!
	assert r.number()! == 1
}

fn test_index() {
	r := Any([Any(f64(1))]).get('[0]')!
	assert r.number()! == 1
}

fn test_no_index() {
	r := Any([Any(f64(1))]).get('[1]') or {
		assert err.msg() == 'no value for index 1'
		return
	}
	assert false
}

fn test_index_index() {
	r := Any([Any([Any(f64(1))])]).get('[0][0]')!
	assert r.number()! == 1
}

fn test_key_index() {
	r := Any({
		'a': Any([Any(f64(1))])
	}).get('a[0]')!
	assert r.number()! == 1
}

fn test_name_index() {
	r := Any({
		'a': Any([Any(f64(1))])
	}).get('"a"[0]')!
	assert r.number()! == 1
}

fn test_index_key() {
	r := Any([Any({
		'a': Any(f64(1))
	})]).get('[0].a')!
	assert r.number()! == 1
}

fn test_index_name() {
	r := Any([Any({
		'a': Any(f64(1))
	})]).get('[0]."a"')!
	assert r.number()! == 1
}
