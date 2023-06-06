module jsany

fn test_empty_path() {
	Any(null).add('', Any(f64(1))) or {
		assert err.msg() == 'empty path'
		return
	}
	assert false
}

fn test_no_object() {
	Any(f64(1)).add('a', Any(f64(1))) or {
		assert err.msg() == 'number is not an object'
		return
	}
	assert false
}

fn test_no_array() {
	Any(f64(1)).add('[0]', Any(f64(1))) or {
		assert err.msg() == 'number is not an array'
		return
	}
	assert false
}

fn test_key() {
	s := Any({
		'a': Any([Any(f64(1))])
	})
	s.add('a', Any(f64(2)))!
	assert s.get('a[0]')!.number()! == 1
	assert s.get('a[1]')!.number()! == 2
}

fn test_index() {
	s := Any([Any([Any(f64(1))])])
	s.add('[0]', Any(f64(2)))!
	assert s.get('[0][0]')!.number()! == 1
	assert s.get('[0][1]')!.number()! == 2
}
