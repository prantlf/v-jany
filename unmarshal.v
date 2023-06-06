module jany

import math
import v.reflection

pub struct UnmarshalOpts {
pub:
	require_all_fields     bool
	forbid_extra_keys      bool
	cast_null_to_default   bool
	ignore_number_overflow bool
}

pub fn unmarshal[T](a Any, opts UnmarshalOpts) !T {
	mut typ := T{}
	if a is Null {
		$if T is $option {
			typ = none
		} $else {
			return error('null cannot be cast to ${T.name}')
		}
	} else {
		ino := opts.ignore_number_overflow
		$if T is $enum {
			typ = unmarshal_enum(a, T.idx)!
		} $else $if T is int || T is ?int {
			typ = unmarshal_int[int](a, ino)!
		} $else $if T is u8 || T is ?u8 {
			typ = unmarshal_int[u8](a, ino)!
		} $else $if T is u16 || T is ?u16 {
			typ = unmarshal_int[u16](a, ino)!
		} $else $if T is u32 || T is ?u32 {
			typ = unmarshal_int[u32](a, ino)!
		} $else $if T is u64 || T is ?u64 {
			typ = unmarshal_int[u64](a, ino)!
		} $else $if T is i8 || T is ?i8 {
			typ = unmarshal_int[i8](a, ino)!
		} $else $if T is i16 || T is ?i16 {
			typ = unmarshal_int[i16](a, ino)!
		} $else $if T is i64 || T is ?i64 {
			typ = unmarshal_int[i64](a, ino)!
		} $else $if T is f32 || T is ?f32 {
			typ = unmarshal_f32(a, ino)!
		} $else $if T is f64 || T is ?f64 {
			typ = a.number()!
		} $else $if T is bool || T is ?bool {
			typ = a.boolean()!
		} $else $if T is string || T is ?string {
			typ = a.string()!
		} $else $if T is $array {
			typ = unmarshal_array(typ, a, opts)!
		} $else $if T is $struct {
			typ = unmarshal_struct(typ, a, opts)!
		} $else $if T is $map {
			unmarshal_map(mut typ, a, opts)!
		} $else {
			return error('unsupported type ${T.name}')
		}
	}
	return typ
}

fn unmarshal_array[T](_ []T, a Any, opts UnmarshalOpts) ![]T {
	res := a.array()!
	mut typ := []T{cap: res.len}
	for item in res {
		typ << unmarshal[T](item, opts)!
	}
	return typ
}

fn unmarshal_struct[T](_ T, a Any, opts UnmarshalOpts) !T {
	res := a.object()!
	mut typ := T{}

	if opts.forbid_extra_keys {
		for key, _ in res {
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
				if json_name == key || skip {
					unsafe {
						goto passed
					}
				}
			}
			return error('extra "${key}" key')
			passed:
		}
	}

	$for field in T.fields {
		mut json_name := field.name
		mut required := false
		mut skip := false
		mut nullable := false
		mut nooverflow := false
		for attr in field.attrs {
			if attr.starts_with('json: ') {
				json_name = attr[6..]
			} else if attr == 'required' {
				required = true
			} else if attr == 'skip' {
				skip = true
			} else if attr == 'nullable' {
				nullable = true
			} else if attr == 'nooverflow' {
				nooverflow = true
			}
		}

		if skip {
		} else if json_name in res {
			val := res[json_name]!
			if val is Null {
				$if field.is_option {
					typ.$(field.name) = none
				} $else {
					if !nullable && !opts.cast_null_to_default {
						return error('null cannot be set to ${field.name} of ${type_name(field.typ)}')
					}
				}
			} else {
				ino := nooverflow || opts.ignore_number_overflow
				$if field.is_enum {
					typ.$(field.name) = unmarshal_enum(val, field.typ)!
				} $else $if field.typ is int || field.typ is ?int {
					typ.$(field.name) = unmarshal_int[int](val, ino)!
				} $else $if field.typ is u8 || field.typ is ?u8 {
					typ.$(field.name) = unmarshal_int[u8](val, ino)!
				} $else $if field.typ is u16 || field.typ is ?u16 {
					typ.$(field.name) = unmarshal_int[u16](val, ino)!
				} $else $if field.typ is u32 || field.typ is ?u32 {
					typ.$(field.name) = unmarshal_int[u32](val, ino)!
				} $else $if field.typ is u64 || field.typ is ?u64 {
					typ.$(field.name) = unmarshal_int[u64](val, ino)!
				} $else $if field.typ is i8 || field.typ is ?i8 {
					typ.$(field.name) = unmarshal_int[i8](val, ino)!
				} $else $if field.typ is i16 || field.typ is ?i16 {
					typ.$(field.name) = unmarshal_int[i16](val, ino)!
				} $else $if field.typ is i64 || field.typ is ?i64 {
					typ.$(field.name) = unmarshal_int[i64](val, ino)!
				} $else $if field.typ is f32 || field.typ is ?f32 {
					typ.$(field.name) = unmarshal_f32(val, ino)!
				} $else $if field.typ is f64 || field.typ is ?f64 {
					typ.$(field.name) = val.number()!
				} $else $if field.typ is bool || field.typ is ?bool {
					typ.$(field.name) = val.boolean()!
				} $else $if field.typ is string || field.typ is ?string {
					typ.$(field.name) = val.string()!
				} $else $if field.is_array {
					typ.$(field.name) = unmarshal_array(typ.$(field.name), val, opts)!
				} $else $if field.is_struct {
					typ.$(field.name) = unmarshal_struct(typ.$(field.name), val, opts)!
				} $else $if field.is_map {
					mut object := T{}
					unmarshal_map(mut object, val, opts)!
					typ.$(field.name) = object
				} $else {
					return error('unsupported type ${type_name(field.typ)} of ${field.name}')
				}
			}
		} else if required || opts.require_all_fields {
			return error('missing "${json_name}" key')
		}
	}
	return typ
}

fn type_name(idx int) string {
	return if typ := reflection.get_type(idx) {
		typ.name
	} else {
		'unknown'
	}
}

fn enum_vals(idx int) ![]string {
	return if typ := reflection.get_type(idx) {
		if typ.sym.info is reflection.Enum {
			typ.sym.info.vals
		} else {
			error('not an enum ${typ.name}')
		}
	} else {
		error('unknown enum')
	}
}

fn unmarshal_int[T](a Any, ignore_overflow bool) !T {
	float := a.number()!
	num := T(float)
	if !ignore_overflow && num != float {
		return error('unable to convert "${float}" to ${T.name}')
	}
	return num
}

fn unmarshal_f32(a Any, ignore_overflow bool) !f32 {
	float := a.number()!
	num := f32(float)
	if !ignore_overflow && float - num > math.smallest_non_zero_f64 {
		return error('unable to convert "${float}" to f32')
	}
	return num
}

fn unmarshal_enum(a Any, typ int) !int {
	if a is f64 {
		return unmarshal_int[int](a, false)!
	} else {
		enums := enum_vals(typ)!
		val := a.string()!
		idx := enums.index(val)
		if idx >= 0 {
			return idx
		} else {
			return error('${val} not in ${type_name(typ)} enum')
		}
	}
}

fn unmarshal_map[T](mut typ map[string]T, a Any) ! {
	res := a.object()!
	for k, v in res {
		typ[k] = T(v)
	}
}
