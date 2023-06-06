module jany

pub fn marshal[T](val T) !Any {
	$if T is $enum {
		return Any(f64(val))
	} $else $if T is int {
		return Any(f64(val))
	} $else $if T is u8 {
		return Any(f64(val))
	} $else $if T is u16 {
		return Any(f64(val))
	} $else $if T is u32 {
		return Any(f64(val))
	} $else $if T is u64 {
		return Any(f64(val))
	} $else $if T is i8 {
		return Any(f64(val))
	} $else $if T is i16 {
		return Any(f64(val))
	} $else $if T is i64 {
		return Any(f64(val))
	} $else $if T is f32 {
		return Any(f64(val))
	} $else $if T is f64 {
		return Any(val)
	} $else $if T is bool {
		return Any(val)
	} $else $if T is string {
		return Any(val)
	} $else $if T is $array {
		return marshal_array(val)!
	} $else $if T is $struct {
		return marshal_struct(val)!
	} $else $if T is $map {
		return marshal_map(val)!
	} $else {
		return error('unsupported type ${T.name}')
	}
}

fn marshal_array[T](val []T) !Any {
	mut res := []Any{cap: val.len}
	for item in res {
		res << marshal(item)!
	}
	return Any(res)
}

fn marshal_struct[T](src T) !Any {
	mut res := map[string]Any{}

	$for field in T.fields {
		mut json_name := field.name
		mut skip := false
		for attr in field.attrs {
			if attr.starts_with('json: ') {
				json_name = attr[6..]
			} else if attr == 'skip' {
				skip = true
			}
		}

		if skip {
		} else {
			val := src.$(field.name)
			$if field.is_enum {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is int {
				res[json_name] = Any(f64(val))
				// } $else $if field.typ is ?int {
				// 	if val != none {
				// 		num := val or { 0 }
				// 		res[json_name] = Any(f64(num))
				// 	} else {
				// 		res[json_name] = Any(null)
				// 	}
			} $else $if field.typ is u8 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u16 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u32 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u64 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i8 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i16 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i64 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is f32 {
				res[json_name] = Any(f64(val))
			} $else $if field.typ is f64 {
				res[json_name] = Any(val)
			} $else $if field.typ is bool {
				res[json_name] = Any(val)
			} $else $if field.typ is string {
				res[json_name] = Any(val)
			} $else $if field.is_array {
				res[json_name] = marshal_array(val)!
			} $else $if field.is_struct {
				res[json_name] = marshal_struct(val)!
			} $else $if field.is_map {
				res[json_name] = marshal_map(val)!
			} $else {
				return error('unsupported type ${type_name(field.typ)} of ${field.name}')
			}
		}
	}
	return Any(res)
}

fn marshal_map[T](src map[string]T) !Any {
	res := a.object()!
	for k, v in res {
		typ[k] = T(v)
	}
}
