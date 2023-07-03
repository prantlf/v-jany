module jany

pub fn (a Any) set(path string, value Any) ! {
	parts := parse_path(path)!
	set_value(a, parts, value)!
}

fn set_value(target Any, parts []Part, value Any) ! {
	mut cur := target
	mut i := 0
	len := parts.len
	for i < len {
		part := parts[i]
		i++
		if part is string {
			mut obj := cur.object()!
			if i == len {
				obj[part] = value
			} else {
				cur = obj[part] or { return error('no value for key "${part}"') }
			}
		} else if part is int {
			mut arr := cur.array()!
			if i == len {
				if part < arr.len {
					arr[part] = value
				} else {
					return error('index ${part} out of bounds of length ${arr.len}')
				}
			} else {
				cur = arr[part] or { return error('no value for index ${part}') }
			}
		}
	}
}
