module jsany

import strings

fn write_any(mut builder strings.Builder, a Any) {
	match a {
		Null {
			builder.write_string('null')
		}
		bool {
			builder.write_string(a.str())
		}
		f64 {
			builder.write_string(number_to_string(a))
		}
		string {
			builder.write_string(a)
		}
		[]Any {
			write_array(mut builder, a)
		}
		map[string]Any {
			write_object(mut builder, a)
		}
	}
}

fn write_array(mut builder strings.Builder, array []Any) {
	builder.write_u8(`[`)
	last := array.len - 1
	for i, item in array {
		write_any(mut builder, item)
		if i != last {
			builder.write_u8(`,`)
		}
	}
	builder.write_u8(`]`)
}

fn write_object(mut builder strings.Builder, object map[string]Any) {
	builder.write_u8(`{`)
	mut next := false
	for key, val in object {
		if next {
			builder.write_u8(`,`)
		} else {
			next = true
		}
		builder.write_string(key)
		builder.write_u8(`:`)
		write_any(mut builder, val)
	}
	builder.write_u8(`}`)
}

fn number_to_string(float f64) string {
	num := int(float)
	return if float == num {
		num.str()
	} else {
		float.str()
	}
}
