module jsany

import math
import strings

pub fn (a Any) boolean() !bool {
	return match a {
		bool { a }
		else { error('${a.typ()} is not a boolean') }
	}
}

pub fn (a Any) number() !f64 {
	return match a {
		f64 { a }
		else { error('${a.typ()} is not a number') }
	}
}

pub fn (a Any) u8() !u8 {
	return get_int[u8](a)!
}

pub fn (a Any) u16() !u16 {
	return get_int[u16](a)!
}

pub fn (a Any) u32() !u32 {
	return get_int[u32](a)!
}

pub fn (a Any) u64() !u64 {
	return get_int[u64](a)!
}

pub fn (a Any) i8() !i8 {
	return get_int[i8](a)!
}

pub fn (a Any) i16() !i16 {
	return get_int[i16](a)!
}

pub fn (a Any) int() !int {
	return get_int[int](a)!
}

pub fn (a Any) i64() !i64 {
	return get_int[i64](a)!
}

pub fn (a Any) f32() !f32 {
	return get_f32(a)!
}

pub fn (a Any) string() !string {
	return match a {
		string { a }
		else { error('${a.typ()} is not a string') }
	}
}

pub fn (a Any) array() ![]Any {
	return match a {
		[]Any { a }
		else { error('${a.typ()} is not an array') }
	}
}

pub fn (a Any) object() !map[string]Any {
	return match a {
		map[string]Any { a }
		else { error('${a.typ()} is not an object') }
	}
}

pub fn (a Any) str() string {
	mut buffer := strings.new_builder(64)
	write_any(mut buffer, a)
	return buffer.str()
}

fn get_int[T](a Any) !T {
	float := a.number()!
	num := T(float)
	if num != float {
		return error('unable to convert "${float}" to ${T.name}')
	}
	return num
}

fn get_f32(a Any) !f32 {
	float := a.number()!
	num := f32(float)
	if float - num > math.smallest_non_zero_f64 {
		return error('unable to convert "${float}" to f32')
	}
	return num
}
