module jsany

pub fn (a Any) add(path string, value Any) ! {
	parts := parse_path(path)!
	add_value(a, parts, value)!
}

fn add_value(target Any, parts []Part, value Any) ! {
	mut obj := map[string]Any{}
	mut arr := []Any{}
	mut key := ''
	mut index := 0
	mut cur := target
	mut i := 0
	len := parts.len
	for i < len {
		part := parts[i]
		i++
		if part is string {
			obj = cur.object()!
			cur = obj[part] or { return error('no value for key "${part}"') }
			if i == len {
				key = part
			}
		} else if part is int {
			arr = cur.array()!
			cur = arr[part] or { return error('no value for index ${part}') }
			if i == len {
				index = part
			}
		}
	}
	mut parent := cur.array()!
	parent << value
	if key != '' {
		obj[key] = Any(parent)
	} else {
		arr[index] = Any(parent)
	}
}
