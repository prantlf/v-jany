module jsany

pub fn any_null() Any {
	return null
}

pub fn any_number(num f64) Any {
	return Any(num)
}

pub fn any_boolean(flag bool) Any {
	return Any(flag)
}

pub fn any_string(str string) Any {
	return Any(str)
}

pub fn any_array[T](src []T) []Any {
	mut dst := []Any{len: 0, cap: src.len, init: null}
	for item in src {
		mut a := Any(null)
		$if T is int {
			a = Any(f64(item))
		} $else {
			a = Any(item)
		}
		dst << a
	}
	return dst
}

pub fn any_object[T](src map[string]T) map[string]Any {
	mut dst := map[string]Any{}
	for key, val in src {
		mut a := Any(null)
		$if T is int {
			a = Any(f64(val))
		} $else {
			a = Any(val)
		}
		dst[key] = a
	}
	return dst
}
