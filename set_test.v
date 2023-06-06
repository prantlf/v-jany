module jany

fn test_empty_path() {
	Any(null).set('', Any(f64(1))) or {
		assert err.msg() == 'empty path'
		return
	}
	assert false
}

fn test_no_object() {
	Any(f64(1)).set('a', Any(f64(1))) or {
		assert err.msg() == 'number is not an object'
		return
	}
	assert false
}

fn test_no_array() {
	Any(f64(1)).set('[0]', Any(f64(1))) or {
		assert err.msg() == 'number is not an array'
		return
	}
	assert false
}

fn test_key() {
	s := Any({
		'a': Any(f64(1))
	})
	s.set('a', Any(f64(2)))!
	assert s.get('a')!.number()! == 2
}

fn test_new_key() {
	s := Any({
		'a': Any(f64(1))
	})
	s.set('b', Any(f64(2)))!
	assert s.get('a')!.number()! == 1
	assert s.get('b')!.number()! == 2
}

fn test_index() {
	s := Any([Any(f64(1))])
	s.set('[0]', Any(f64(2)))!
	assert s.get('[0]')! == Any(f64(2))
}

fn test_no_index() {
	s := Any([Any(f64(1))])
	s.set('[1]', Any(f64(2))) or {
		assert err.msg() == 'index 1 out of bounds of length 1'
		return
	}
	assert false
}

fn test_new_index() {
	a := []Any{len: 2, init: Any(f64(1))}
	s := Any(a)
	s.set('[1]', Any(f64(2)))!
	assert s.get('[0]')! == Any(f64(1))
	assert s.get('[1]')! == Any(f64(2))
}
