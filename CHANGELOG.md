# Changes 

## [0.1.2](https://github.com/prantlf/v-jany/compare/v0.1.1...v0.1.2) (2023-10-15)

### Bug Fixes

* Fix marshalling maps ([1dbca81](https://github.com/prantlf/v-jany/commit/1dbca81a1dc4ab5abe54de9f8721c2b703b4924d))

## [0.1.1](https://github.com/prantlf/v-jany/compare/v0.1.0...v0.1.1) (2023-09-09)

### Bug Fixes

* Make unmarshalling enums compatible with new v ([88d1601](https://github.com/prantlf/v-jany/commit/88d160152cfde315dbd8ea5dec627eeb24d13aaa))

## [0.1.0](https://github.com/prantlf/v-jany/compare/v0.0.6...v0.1.0) (2023-08-15)

### Features

* Add unmarshal_to to modify an existing object ([8657d7d](https://github.com/prantlf/v-jany/commit/8657d7d0417bc261c9bc08971555bad537747e8f))

## [0.0.6](https://github.com/prantlf/v-jany/compare/v0.0.5...v0.0.6) (2023-08-07)

### Bug Fixes

* Temporarily disable the incomplete map handling ([8cddc76](https://github.com/prantlf/v-jany/commit/8cddc7636754cf3f6a549b5d762a82349ad0fe0e))

## [0.0.5](https://github.com/prantlf/v-jany/compare/v0.0.4...v0.0.5) (2023-06-25)

### Bug Fixes

* Use direct_array_access to improve performance ([7d3e51f](https://github.com/prantlf/v-jany/commit/7d3e51fea3fecaa94aab787a943c3808244f5e78))

## [0.0.4](https://github.com/prantlf/v-jany/compare/v0.0.3...v0.0.4) (2023-06-12)

### Bug Fixes

* Fix checks for float overflow ([ed1a336](https://github.com/prantlf/v-jany/commit/ed1a33627785827aa4749dd9da768ba0d5ddf67c))

## [0.0.3](https://github.com/prantlf/v-jany/compare/v0.0.2...v0.0.3) (2023-06-08)

### Bug Fixes

* Enable marshalling of enums ([71991d7](https://github.com/prantlf/v-jany/commit/71991d7ae0f4c5c851f9277bacb7e7347289b751))
* Enable unmarshalling of arrays ([8096233](https://github.com/prantlf/v-jany/commit/8096233a254ea891b0e68b337248be8b3f51cea0))

### BREAKING CHANGES

* The function `marshal` expects a new argument - `MarshalOpts`. You will have to append `, jany.MarshalOpts{}` to the calls of the `marshal` function.

## [0.0.2](https://github.com/prantlf/v-jany/compare/v0.0.1...v0.0.2) (2023-06-06)

### Chores

* Rename everything to `jany` ([2b4fa45](https://github.com/prantlf/v-jany/commit/2b4fa45fbe0213326e08b8cda37f1e2cd889fa3c))

### BREAKING CHANGES

* The repository was renamed from `prantlf.v-jsany` to `prantlf/v-jany`. Consequentially, the package was renamed from `jsany` to `jany`. You have to fix the names and paths in your sources.

## 0.0.1 (2023-06-06)

Initial release.
