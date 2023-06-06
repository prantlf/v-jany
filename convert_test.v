module jsany

fn test_u8() {
	assert Any(f64(1)).u8()! == 1
}

fn test_u8_overflow() {
	Any(f64(1234)).u8() or {
		assert err.msg() == 'unable to convert "1234.0" to u8'
		return
	}
	assert false
}

fn test_u16() {
	assert Any(f64(1)).u16()! == 1
}

fn test_u16_overflow() {
	Any(f64(123456)).u16() or {
		assert err.msg() == 'unable to convert "123456.0" to u16'
		return
	}
	assert false
}

fn test_u32() {
	assert Any(f64(1)).u32()! == 1
}

fn test_u32_overflow() {
	Any(f64(12345678901)).u32() or {
		assert err.msg() == 'unable to convert "1.2345678901e+10" to u32'
		return
	}
	assert false
}

fn test_u64() {
	assert Any(f64(1)).u64()! == 1
}

fn test_u64_overflow() {
	Any(f64(12345678901234567890e+10)).u64() or {
		assert err.msg() == 'unable to convert "1.2345678901234568e+29" to u64'
		return
	}
	assert false
}

fn test_i8() {
	assert Any(f64(1)).i8()! == 1
}

fn test_i8_overflow() {
	Any(f64(1234)).i8() or {
		assert err.msg() == 'unable to convert "1234.0" to i8'
		return
	}
	assert false
}

fn test_i16() {
	assert Any(f64(1)).i16()! == 1
}

fn test_i16_overflow() {
	Any(f64(123456)).i16() or {
		assert err.msg() == 'unable to convert "123456.0" to i16'
		return
	}
	assert false
}

fn test_int() {
	assert Any(f64(1)).int()! == 1
}

fn test_int_overflow() {
	Any(f64(12345678901)).int() or {
		assert err.msg() == 'unable to convert "1.2345678901e+10" to int'
		return
	}
	assert false
}

fn test_i64() {
	assert Any(f64(1)).i64()! == 1
}

fn test_i64_overflow() {
	Any(f64(12345678901234567890e+10)).i64() or {
		assert err.msg() == 'unable to convert "1.2345678901234568e+29" to i64'
		return
	}
	assert false
}

fn test_f32() {
	assert Any(f64(1)).f32()! == f32(1)
}

fn test_f32_overflow() {
	Any(f64(1.2345678)).f32() or {
		assert err.msg() == 'unable to convert "1.2345678" to f32'
		return
	}
	assert false
}
