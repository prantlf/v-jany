module jany

fn test_marshal_int() {
	r := marshal(1)!
	assert r == Any(f64(1))
}

fn test_marshal_u8() {
	r := marshal(u8(1))!
	assert r == Any(f64(1))
}

fn test_marshal_u16() {
	r := marshal(u16(1))!
	assert r == Any(f64(1))
}

fn test_marshal_u32() {
	r := marshal(u32(1))!
	assert r == Any(f64(1))
}

fn test_marshal_u64() {
	r := marshal(u64(1))!
	assert r == Any(f64(1))
}

fn test_marshal_i8() {
	r := marshal(u8(1))!
	assert r == Any(f64(1))
}

fn test_marshal_i16() {
	r := marshal(u16(1))!
	assert r == Any(f64(1))
}

fn test_marshal_i64() {
	r := marshal(u64(1))!
	assert r == Any(f64(1))
}

fn test_marshal_f32() {
	r := marshal(f32(1.2))!
	assert f32(r.number()!) == 1.2
}

fn test_marshal_f64() {
	r := marshal(1.2)!
	assert r == Any(1.2)
}

fn test_marshal_bool() {
	r := marshal(true)!
	assert r == Any(true)
}

fn test_marshal_string() {
	r := marshal('a')!
	assert r == Any('a')
}

// fn test_marshal_array() {
// 	r := marshal([1])!
// 	assert r == Any([Any(f64(1))])
// }

enum Human {
	man
	woman
}

fn test_marshal_enum_num() {
	r := marshal(Human.woman)!
	assert r == Any(f64(1))
}

fn test_marshal_enum_nam() {
	r := marshal_opt(Human.woman, &MarshalOpts{ enums_as_names: true })!
	assert r == Any('woman')
}

struct Empty {}

fn test_marshal_empty_object() {
	r := marshal(Empty{})!
	assert r == Any(map[string]Any{})
}

struct PrimitiveTypes {
	h      Human
	u8     u8
	u16    u16
	u32    u32
	u64    u64
	i8     i8
	i16    i16
	int    int
	i64    i64
	f32    f32
	f64    f64
	string string
	bool   bool
}

fn test_marshal_primitive_types() {
	r := marshal(PrimitiveTypes{
		h:      .woman
		u8:     1
		u16:    2
		u32:    3
		u64:    4
		i8:     5
		i16:    6
		int:    7
		i64:    8
		f32:    9.1
		f64:    9.2
		string: 's'
		bool:   true
	})!
	m := r.object()!
	assert m['h']! == Any(f64(Human.woman))
	assert m['u8']! == Any(f64(1))
	assert m['u16']! == Any(f64(2))
	assert m['u32']! == Any(f64(3))
	assert m['u64']! == Any(f64(4))
	assert m['i8']! == Any(f64(5))
	assert m['i16']! == Any(f64(6))
	assert m['int']! == Any(f64(7))
	assert m['i64']! == Any(f64(8))
	assert m['f32']!.number()! == f32(9.1)
	assert m['f64']! == Any(9.2)
	assert m['string']! == Any('s')
	assert m['bool']! == Any(true)
}

// struct OptionalTypes {
// 	h      ?Human
// 	u8     ?u8
// 	u16    ?u16
// 	u32    ?u32
// 	u64    ?u64
// 	i8     ?i8
// 	i16    ?i16
// 	int    ?int
// 	i64    ?i64
// 	f32    ?f32
// 	f64    ?f64
// 	string ?string
// 	bool   ?bool
// }

// fn test_marshal_optional_types() {
// 	input := Any({
// 		'h': Any(f64(Human.woman))
// 		'u8':  Any(f64(1))
// 		'u16': Any(f64(2))
// 		'u32': Any(f64(3))
// 		'u64': Any(f64(4))
// 		'i8':  Any(f64(5))
// 		'i16': Any(f64(6))
// 		'int': Any(f64(7))
// 		'i64': Any(f64(8))
// 		'f32': Any(9.1)
// 		'f64': Any(9.2)
// 		'string': Any('s')
// 		'bool': Any(true)
// 	})
// 	r := marshal[OptionalTypes](input)!
// 	assert r.h? == .woman
// 	assert r.u8? == 1
// 	assert r.u16? == 2
// 	assert r.u32? == 3
// 	assert r.u64? == 4
// 	assert r.i8? == 5
// 	assert r.i16? == 6
// 	assert r.int? == 7
// 	assert r.i64? == 8
// 	assert r.f32? == 9.1
// 	assert r.f64? == 9.2
// 	assert r.string? == 's'
// 	assert r.bool? == true
// }

/*
struct OptionalType {
	int ?int
}

fn test_marshal_optional_null_type() {
	r := marshal(OptionalType{
		int: none
	})!
	m := r.object()!
	assert m['int']! == Any(null)
}

fn test_marshal_optional_type() {
	r := marshal(OptionalType{
		int: 1
	})!
	m := r.object()!
	assert m['int']! == Any(f64(1))
}
*/

// /*
// struct OptionalArray {
// 	int ?[]int
// }

// fn test_marshal_optional_array() {
// 	input := r'
// int:
// 	- 1
// '
// 	r := marshal[OptionalArray](input)!
// 	assert r.int?.len == 1
// 	assert r.int?[0] == 1
// }
// */

// /*
// struct ArrayOfOptions {
// 	int []?int
// }

// fn test_marshal_array_of_options() {
// 	input := r'
// int:
// 	- 1
// '
// 	r := marshal[ArrayOfOptions](input)!
// 	assert r.int.len == 1
// 	first := r.int[0]
// 	assert first? == 1
// }
// */

fn test_marshal_array() {
	input := [42]
	r := marshal(input)!
	aa := r.array()!
	v := aa[0]!
	assert v == Any(f64(42))
}

struct ArrayInStruct {
	arr []int
}

fn test_marshal_array_in_struct() {
	input := ArrayInStruct{
		arr: [42]
	}
	r := marshal(input)!
	o := r.object()!
	a := o['arr']!
	aa := a.array()!
	v := aa[0]!
	assert v == Any(f64(42))
}

fn test_marshal_map() {
	input := {
		'answer': 42
	}
	r := marshal(input)!
	o := r.object()!
	v := o['answer']!
	assert v == Any(f64(42))
}

struct MapInStruct {
	val map[string]int
}

fn test_marshal_map_in_struct() {
	input := MapInStruct{
		val: {
			'answer': 42
		}
	}
	r := marshal(input)!
	o := r.object()!
	o2 := o['val']!
	o2o := o2.object()!
	v := o2o['answer']!
	assert v == Any(f64(42))
}

struct InnerStruct {
	val int
}

struct OuterStruct {
	inner InnerStruct
}

fn test_marshal_struct_in_struct() {
	input := OuterStruct{
		inner: InnerStruct{
			val: 1
		}
	}
	r := marshal(input)!
	o := r.object()!
	i := o['inner']!
	io := i.object()!
	v := io['val']!
	assert v == Any(f64(1))
}

struct Attributes {
	int    int  @[required]
	bool   bool @[skip]
	string string
	f64    f64 @[json: float; required]
	u8     u8  @[nooverflow]
	u16    u16 @[nullable]
}

fn test_attributes() {
	input := Attributes{
		int:  1
		f64:  2.3
		bool: true
		u8:   4
		u16:  0
	}
	r := marshal(input)!
	o := r.object()!
	assert o['int']! == Any(f64(1))
	if _ := o['bool'] {
		assert false
	}
	assert o['string']! == Any('')
	assert o['float']! == Any(2.3)
	assert o['u8']! == Any(f64(4))
	assert o['u16']! == Any(f64(0))
}
