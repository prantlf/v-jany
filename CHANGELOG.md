# [0.0.4](https://github.com/prantlf/v-jany/compare/v0.0.3...v0.0.4) (2023-06-12)


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