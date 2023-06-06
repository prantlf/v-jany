# Any Type for JSON and YAML

Build and access JSON/YAML data using a dynamic sumtype instead of static types.

* Type `Any` accomodating all JSON types - `null`, `boolean`, `number`, `string`, `array` and `object`.
* Strict extraction of values checking for the right return type.
* Safe conversion of all numberic types (`u8`, `u16`, `u32`, `u64`, `i8`, `i16`, `int`, `i64` and `f32`) checking for arithmetic overflow.
* Factory functions for creating JSON values.
* Built-in formatting to `string` for easy logging.
* Convenient traversing of nested values in arrays and objects.
* Unmarshalling `Any` data to a static V type and marshalling a V value to `Any` data.

Used in [json] and [yaml] packages.

## Synopsis

```go
import jsany { Any, Null, any_int }

// Create an Any
any := any_int(42)  // factory function
any := Any(f64(42)) // cast to sumtype

// Checks for null
if any is Null {}
if any.is_null() {}

// Get a value
val := any.number()! // get a number (f64)
val := any.int()!    // get an integer

// Format a value to string
str := any.str()

// Get a value on a path
val := any.get('a.b[0]')!

// Set a value on a path
any.set('a.b[0]', any_int(42))!

// Marshal a statically typed value to an Any
struct Config {
	answer int
}
config := Config{ answer: 42 }
any := marshal(config)

// Unmarshal an Any to a static type
struct Config {
	answer int
}
any := Any({
  'answer': Any(f64(42))
})
config := unmarshal[Config](any)
```

## Installation

You can install this package from GitHub:

```txt
v install --git https://github.com/prantlf/v-jsany
```

## API

The type `Any` is a sumtype of the following built-in V types:

```go
// JSON types: null   boolean   number   string   array   object
pub type Any = Null | bool    | f64    | string | []Any | map[string]Any
```

### Null

The `null` is a special value in the `jsany` namespace:

```go
pub const null = Null{}
```

`Null` can be used to check the `null` value with the `is` operator. There's a convenience method `is_null()` too:

```go
if any is Null {}
if any.is_null() {}
```

### Types

Built-in V types are mapped to JSON types in the following way:

| JSON type | V type           |
|:----------|:-----------------|
| `null`    | `Null`           |
| `boolean` | `bool`           |
| `number`  | `f64`            |
| `string`  | `string`         |
| `array`   | `[]Any`          |
| `object`  | `map[string]Any` |

The native V type of an `Any` can be checked by the operator `is`:

```go
if any is string {}
```

The name of the JSON type of an `Any` can be obtained as a string by the function `.typ()`:

```go
typ := any.typ()
```

### Factories

An `Any` can be created by casting a native V value to the sumtype, or using a factory function exported from the `jsany` namespace:

| JSON type | V type           | Casting                   | Factory                   |
|:----------|:-----------------|:--------------------------|:--------------------------|
| `null`    | `Null`           | `Any(null)`               | `.any_null()`             |
| `boolean` | `bool`           | `Any(true)`               | `.any_boolean(true)`      |
| `number`  | `f64`            | `Any(f64(1))`             | `.any_number(1)`          |
| `string`  | `string`         | `Any('a')`                | `.any_string('a')`        |
| `array`   | `[]Any`          | `Any([Any(f64(1))])`      | `.any_array([1])`         |
| `object`  | `map[string]Any` | `Any({'a': Any(f64(1))})` | `.any_object({ 'a': 1 })` |

### Getters

For V types mapped from JSON types, there're getters. If the JSON value doesn't match the type of the getter, an error will be returned:

| JSON type | V type           | Getter       |
|:----------|:-----------------|:-------------|
| `null`    | `Null`           | `.is_null()` |
| `number`  | `f64`            | `.number()`  |
| `boolean` | `bool`           | `.boolean()` |
| `string`  | `string`         | `.string()`  |
| `array`   | `[]Any`          | `.array()`  |
| `object`  | `map[string]Any` | `.object()`  |

Except for the basic V types mapped from JSON types, there're additional getters for other numeric V types. If the JSON value doesn't match the type of the getter, or of the numeric type cannot accomodate the value and an arithmetic overflow would occur, an error will be returned:

| JSON type | V type           | Getter       |
|:----------|:-----------------|:-------------|
| `number`  | `u8`             | `.u8()`      |
| `number`  | `u16`            | `.u16()`     |
| `number`  | `u32`            | `.u32()`     |
| `number`  | `u64`            | `.u64()`     |
| `number`  | `i8`             | `.i8()`      |
| `number`  | `i16`            | `.i16()`     |
| `number`  | `int`            | `.int()`     |
| `number`  | `i64`            | `.i64()`     |
| `number`  | `f32`            | `.f32()`     |

### Formatting

Serialisation of an `Any` to a string representation is expected from libraries providing the specific format, liek JSON or YAML. The `Any` type provides only a simple serialisation to string for logging purposes - the getter `.str()`:

```go
str := any.str()
```

### Traversing

Values nested in arrays objects can be obtained by a convenience function using a string path - `.get(...)`. The syntax is the same as in the V langauge - arrays are accessed by `[usize]` and fields by `.`. Quotation marks (`"` or `'`) san be used to specify field names with some of three special characters (`[`, `]` and `.`). If a value on any level of the the specifcfied path is missing, an error will be returned:

```go
val := any.get('a.b[0]')!
```

Similarly to getting a nested value, a nested value can be set too. If the parent value on the path (the one but last value) is missing, an error will be returned. Arrays need to have the proper length before assigning values to them:

```go
any.set('a.b', Any([]Any{}))!
any.set('a.b[0]', any_int(42))!
```

A new item can be added to an array too:

```go
any.add('a.b', any_int(42))!
```

### Marshalling

Except for using `Any` values directly, they can be converted to static V types and back again by functions exported from the `jsany` namespace:

### marshal[T](value T) !Any

Marshals a value of `T` to `Any` value.

```go
struct Config {
	answer int
}

config := Config{ answer: 42 }
any := marshal(config)
```

### unmarshal_text[T](any Any, opts UnmarshalOpts) !T

Unmarshals an `Any` value to an instance of `T`. Fields available in `UnmarshalOpts`:

| Name                     | Type   | Default | Description                                                             |
|:-------------------------|:-------|:--------|:------------------------------------------------------------------------|
| `require_all_fields`     | `bool` | `false` | requires a key in the source object for each field in the target struct |
| `forbid_extra_keys`      | `bool` | `false` | forbids keys in the source object not mapping to a field in the target struct |
| `cast_null_to_default`   | `bool` | `false` | allows `null`s in the source data to be translated to default values of V types; `null`s can be unmarshaled only to Option types by default |
| `ignore_number_overflow` | `bool` | `false` | allows losing precision when unmarshaling numbers to smaller numeric types |

```go
struct Config {
	answer int
}

any := Any({
  'answer': Any(f64(42))
})
config := unmarshal[Config](any)
```

## TODO

This is a work in progress.

* Should `is_null` stay or should only `is Null` remain?
* Should the getters be forgiving and chekcing getter should be renamed to `strict_*`?
* Enable support for arrays (bug [#18317]).

[json]: https://github.com/prantlf/v-json
[yaml]: https://github.com/prantlf/v-yaml
[#18317]: https://github.com/vlang/v/issues/18317
