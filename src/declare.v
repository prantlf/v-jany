module jany

@[noinit]
pub struct Null {}

pub const null = Null{}

pub type Any = Null | []Any | bool | f64 | map[string]Any | string

pub fn (a Any) typ() string {
	return match a {
		Null { 'null' }
		bool { 'boolean' }
		f64 { 'number' }
		string { 'string' }
		[]Any { 'array' }
		map[string]Any { 'object' }
	}
}

pub fn (a Any) is_null() bool {
	return a == Any(null)
}
