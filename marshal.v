module jany

pub struct MarshalOpts {
pub:
	enums_as_names bool
}

@[inline]
pub fn marshal[T](val T) !Any {
	return marshal_opt[T](val, &MarshalOpts{})!
}

pub fn marshal_opt[T](val T, opts &MarshalOpts) !Any {
	$if T is $enum {
		return marshal_enum(val, opts.enums_as_names)
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
		return marshal_array(val, opts)!
	} $else $if T is $struct {
		return marshal_struct(&val, opts)!
	} $else $if T is $map {
		return marshal_map(&val, opts)!
	} $else {
		return error('unsupported type ${T.name}')
	}
}

fn marshal_enum[T](val T, names bool) !Any {
	if names {
		enums := enum_vals(T.idx)!
		ival := int(val)
		if ival < 0 || ival >= enums.len {
			return error('${val} out of bounds of ${type_name(T.idx)}')
		}
		return Any(enums[int(val)])
	} else {
		return Any(f64(val))
	}
}

fn marshal_array[T](val []T, opts &MarshalOpts) !Any {
	mut res := []Any{cap: val.len}
	for item in val {
		res << marshal_opt(item, opts)!
	}
	return Any(res)
}

fn marshal_map[T](src &T, opts &MarshalOpts) !Any {
	mut res := map[string]Any{}
	for key, value in src {
		// *value feels like a bug in V. There's a reference to the map,
		// but not a reference to the value.
		out := marshal_opt(*value, opts)!
		res[key] = out
	}
	return Any(res)
}

fn marshal_struct[T](src &T, opts &MarshalOpts) !Any {
	mut res := map[string]Any{}

	$for field in T.fields {
		mut json_name := field.name
		mut skip := false
		for attr in field.attrs {
			if attr.starts_with('json: ') {
				json_name = if attr[6] == `'` {
					attr[7..(attr.len - 1)]
				} else {
					attr[6..]
				}
			} else if attr == 'skip' {
				skip = true
			}
		}

		if skip {
		} else {
			$if field.is_enum {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is int {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
				// } $else $if field.typ is ?int {
				// 	if val != none {
				// 		num := val or { 0 }
				// 		res[json_name] = Any(f64(num))
				// 	} else {
				// 		res[json_name] = Any(null)
				// 	}
			} $else $if field.typ is u8 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u16 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u32 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is u64 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i8 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i16 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is i64 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is f32 {
				val := src.$(field.name)
				res[json_name] = Any(f64(val))
			} $else $if field.typ is f64 {
				val := src.$(field.name)
				res[json_name] = Any(val)
			} $else $if field.typ is bool {
				val := src.$(field.name)
				res[json_name] = Any(val)
			} $else $if field.typ is string {
				val := src.$(field.name)
				res[json_name] = Any(val)
			} $else $if field.is_array {
				val := src.$(field.name)
				res[json_name] = marshal_array(val, opts)!
			} $else $if field.is_struct {
				val := &src.$(field.name)
				res[json_name] = marshal_struct(val, opts)!
			} $else $if field.is_map {
				val := &src.$(field.name)
				res[json_name] = marshal_map(val, opts)!
			} $else {
				return error('unsupported type ${type_name(field.typ)} of ${field.name}')
			}
		}
	}
	return Any(res)
}
