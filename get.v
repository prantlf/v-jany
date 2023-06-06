module jany

import strconv

type Part = int | string

pub fn (a Any) get(path string) !Any {
	parts := parse_path(path)!
	return get_value(a, parts)!
}

fn get_value(value Any, parts []Part) !Any {
	mut cur := value
	for part in parts {
		if part is string {
			obj := cur.object()!
			cur = obj[part] or { return error('no value for key "${part}"') }
		} else if part is int {
			arr := cur.array()!
			cur = arr[part] or { return error('no value for index ${part}') }
		}
	}
	return cur
}

fn parse_path(path string) ![]Part {
	mut parts := []Part{}
	len := path.len
	mut cur := 0
	mut part_start := 0
	mut in_key := false
	mut in_index := false
	mut str_delim := 0
	for cur < len {
		ch := path[cur]
		rune_len := utf8_char_len(ch)
		if rune_len == 1 {
			if in_key {
				if ch == str_delim {
					val := unsafe { tos(path.str + part_start, cur - part_start) }
					parts << val
					in_key = false
					cur++
					part_start = cur
				} else {
					cur++
				}
			} else if in_index {
				if ch == u8(`]`) {
					val := unsafe { tos(path.str + part_start, cur - part_start) }
					index := strconv.atoi(val) or { return error('invalid index ${val}') }
					parts << index
					in_index = false
					cur++
					part_start = cur
				} else {
					cur++
				}
			} else if ch in [u8(`'`), u8(`"`)] {
				cur++
				str_delim = ch
				part_start = cur
				in_key = true
			} else if ch == u8(`[`) {
				if part_start < cur {
					val := unsafe { tos(path.str + part_start, cur - part_start) }
					parts << val
				}
				cur++
				part_start = cur
				in_index = true
			} else if ch == u8(`.`) {
				if part_start < cur {
					val := unsafe { tos(path.str + part_start, cur - part_start) }
					parts << val
				}
				cur++
				part_start = cur
			} else {
				cur++
			}
		} else {
			cur += rune_len
		}
	}
	if part_start < len {
		val := unsafe { tos(path.str + part_start, len - part_start) }
		if in_key {
			return error('missing ${str_delim} for key "${val}"')
		}
		if in_index {
			return error('missing ] for index "${val}"')
		}
		parts << val
	}
	if parts.len == 0 {
		return error('empty path')
	}
	return parts
}
