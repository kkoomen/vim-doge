## [2.8.1](https://github.com/kkoomen/vim-doge/compare/v2.8.0...v2.8.1) (2020-09-02)



# [2.8.0](https://github.com/kkoomen/vim-doge/compare/v2.7.1...v2.8.0) (2020-09-02)


### Features

* **python:** add support for async functions ([#93](https://github.com/kkoomen/vim-doge/issues/93)) ([4c0b771](https://github.com/kkoomen/vim-doge/commit/4c0b771be8b7c5ad9859cc8705a727935ab63e1d))



## [2.7.1](https://github.com/kkoomen/vim-doge/compare/v2.7.0...v2.7.1) (2020-08-16)


### Bug Fixes

* **javascript:** remove unnecessary \s* ([cf6c13d](https://github.com/kkoomen/vim-doge/commit/cf6c13da4e08687bc2bc6b8cf92ee930c45e5ba7))


### Features

* fix typescript multiline function declaration with decorators bug ([aaecec0](https://github.com/kkoomen/vim-doge/commit/aaecec074f5c20fa31631ebdc1d5b5dfc6e4816d))
* remove blockchain link from funding.yml ([7cd7038](https://github.com/kkoomen/vim-doge/commit/7cd7038d14452ce421aa5623542483bc18896811))
* remove debug comments ([011a814](https://github.com/kkoomen/vim-doge/commit/011a81429935aff2efdd111eb9671c0f4f803084))
* **python:** add configuration option to use single quotes ([#92](https://github.com/kkoomen/vim-doge/issues/92)) ([6a1dfe0](https://github.com/kkoomen/vim-doge/commit/6a1dfe04cae147b9742060c63421a282c4d2079a))



# [2.6.0](https://github.com/kkoomen/vim-doge/compare/v2.5.1...v2.6.0) (2020-07-25)


### Features

* add proper support for advanced typescript syntax ([761d2a3](https://github.com/kkoomen/vim-doge/commit/761d2a307cce69b215942f71ea1c8f38c6ad24ff))



## [2.5.1](https://github.com/kkoomen/vim-doge/compare/v2.5.0...v2.5.1) (2020-07-24)


### Features

* **java:** add !description TODO to the [@throws](https://github.com/throws) tags ([#90](https://github.com/kkoomen/vim-doge/issues/90)) ([d1e1f02](https://github.com/kkoomen/vim-doge/commit/d1e1f02333d7520a06803fa37e9bf74b31644af1))
* **java:** support exceptions in method declaration along with [@throws](https://github.com/throws) tag ([#90](https://github.com/kkoomen/vim-doge/issues/90)) ([c6ecbb0](https://github.com/kkoomen/vim-doge/commit/c6ecbb0fe0f2ca6839c123845fed55f6b2821528))



# [2.5.0](https://github.com/kkoomen/vim-doge/compare/v2.4.3...v2.5.0) (2020-07-13)


### Features

* **php:** add newline in-between [@params](https://github.com/params) and [@returns](https://github.com/returns) ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([1c01a03](https://github.com/kkoomen/vim-doge/commit/1c01a03f73644d2d33d074c74604af34b1db7e98))
* **php:** Add specific configurabe option to disable FQN resolving ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([d38b425](https://github.com/kkoomen/vim-doge/commit/d38b42566639c3e91754e7ef69a0bb231fadf335))
* **php:** Transform ?Foo param type into Foo|null ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([6350984](https://github.com/kkoomen/vim-doge/commit/635098409a218eb19cbf3edacd948cbf9d4692cf))
* **test:** re-do previous fixes ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([ae944bd](https://github.com/kkoomen/vim-doge/commit/ae944bd6150cd330ec913a28f785150017e0ebdb))
* Added the Outputs part to type sh ([65df982](https://github.com/kkoomen/vim-doge/commit/65df982a506ba3ae58cb502beb8a8ee9a09feec7))



## [2.4.2](https://github.com/kkoomen/vim-doge/compare/v2.4.1...v2.4.2) (2020-06-05)


### Features

* **DogeCreateDocStandard:** Do not pre-create the path and and write the file after generation ([#87](https://github.com/kkoomen/vim-doge/issues/87)) ([3fa9d05](https://github.com/kkoomen/vim-doge/commit/3fa9d053817ef069a728d80890455dbdf0062b83))



## [2.4.1](https://github.com/kkoomen/vim-doge/compare/v2.4.0...v2.4.1) (2020-05-29)


### Bug Fixes

* **#86:** Allow default exports for JavaScript-like languages ([8f725bb](https://github.com/kkoomen/vim-doge/commit/8f725bb9776adc0943341b5d356205aedf050c52)), closes [#86](https://github.com/kkoomen/vim-doge/issues/86)



# [2.4.0](https://github.com/kkoomen/vim-doge/compare/v2.3.0...v2.4.0) (2020-05-29)


### Features

* **javascript:** Add support for TypeScript ES7 decorators ([8b8a74d](https://github.com/kkoomen/vim-doge/commit/8b8a74dccb0af0c88547f2d73ee1af70ec055b46))



# [2.3.0](https://github.com/kkoomen/vim-doge/compare/v2.2.9...v2.3.0) (2020-05-22)


### Bug Fixes

* linting errors ([4a4a214](https://github.com/kkoomen/vim-doge/commit/4a4a214f4af51121ce3960317b0ddc253a3df872))


### Features

* **javascript:** Add Promise<T> as a return type when a function is async ([57712e9](https://github.com/kkoomen/vim-doge/commit/57712e9021a52ee5d8ca29e07cb9daed7a4e4873))



## [2.2.9](https://github.com/kkoomen/vim-doge/compare/v2.2.8...v2.2.9) (2020-05-15)


### Bug Fixes

* **#85:** Indent line based on current line rather than next or previous line ([9553b5b](https://github.com/kkoomen/vim-doge/commit/9553b5b0acd91d0851f955fc58fb5eed278b038c)), closes [#85](https://github.com/kkoomen/vim-doge/issues/85)


### Features

* **sh:** Simplify regex ([0ec2e5e](https://github.com/kkoomen/vim-doge/commit/0ec2e5ea7328260d428b4ab8fe45212c6b3ae688))



## [2.2.7](https://github.com/kkoomen/vim-doge/compare/v2.2.6...v2.2.7) (2020-03-13)


### Bug Fixes

* Preprocess aliased filetypes ([1aba70d](https://github.com/kkoomen/vim-doge/commit/1aba70d1d2ff408045f8d57eec0b8103da5d2db9))
* **ruby:** Fix ruby without parentheses ([7f2adf0](https://github.com/kkoomen/vim-doge/commit/7f2adf0709d8a34006edca8d16fc87622cab3826))


### Features

* Allow patterns to denormalize input ([5915891](https://github.com/kkoomen/vim-doge/commit/5915891ca7ca578d05df2354db8ccc2fef12f5b7))



## [2.2.5](https://github.com/kkoomen/vim-doge/compare/v2.2.4...v2.2.5) (2020-03-05)


### Bug Fixes

* **doge#buffer#get_supported_doc_standards:** Order list based on how it should be defined ([da8b5c5](https://github.com/kkoomen/vim-doge/commit/da8b5c52353444e74958fb034425c7ea04f1b781))



## [2.2.4](https://github.com/kkoomen/vim-doge/compare/v2.2.3...v2.2.4) (2020-02-21)


### Bug Fixes

* **javascript/typescript:** Support [@generator](https://github.com/generator) tag; Escape pipe characters in input to ensure union types are parsed correctly ([25b34b2](https://github.com/kkoomen/vim-doge/commit/25b34b2718111fbd29d9261fdccb5e449ad50812))



## [2.2.3](https://github.com/kkoomen/vim-doge/compare/v2.2.2...v2.2.3) (2020-02-19)


### Bug Fixes

* **#80:** Check whether current filetype is supported ([50efe22](https://github.com/kkoomen/vim-doge/commit/50efe22af6b677acc7d5645da75a5a47b056b729)), closes [#80](https://github.com/kkoomen/vim-doge/issues/80)



## [2.2.2](https://github.com/kkoomen/vim-doge/compare/v2.2.1...v2.2.2) (2020-02-18)


### Bug Fixes

* **#79:** Support advanced typescript parameters ([40f15e1](https://github.com/kkoomen/vim-doge/commit/40f15e13624de10ba70e390929814d9ea5f14570)), closes [#79](https://github.com/kkoomen/vim-doge/issues/79)



## [2.2.1](https://github.com/kkoomen/vim-doge/compare/v2.2.0...v2.2.1) (2020-01-28)


### Bug Fixes

* **#76:** Add check when switching from an alias ft to alias ft ([19b8a6e](https://github.com/kkoomen/vim-doge/commit/19b8a6ea070410d55ab347d757d75878c9adb397)), closes [#76](https://github.com/kkoomen/vim-doge/issues/76)



# [2.2.0](https://github.com/kkoomen/vim-doge/compare/v2.1.0...v2.2.0) (2020-01-01)


### Bug Fixes

* Ensure doc standards and patterns are not stacked when switching filetype ([2a1937b](https://github.com/kkoomen/vim-doge/commit/2a1937b31ded606dbddc30daa454e56f198c58b9))


### Features

* **#73:** Add g:doge_filetype_aliases to ToC ([5ebf787](https://github.com/kkoomen/vim-doge/commit/5ebf7878623189c20e14c066f7eac299083ac4d9)), closes [#73](https://github.com/kkoomen/vim-doge/issues/73)
* **#73:** Add support for g:doge_filetype_aliases; fix: prevent patterns getting stacked when changing filetype ([aa1912f](https://github.com/kkoomen/vim-doge/commit/aa1912fab227f64e3128dc68a327d6de29e24b1e)), closes [#73](https://github.com/kkoomen/vim-doge/issues/73)



# [2.1.0](https://github.com/kkoomen/vim-doge/compare/v2.0.0...v2.1.0) (2019-12-28)


### Bug Fixes

* **funding:** Add quotes to ensure correct parsing ([3061c38](https://github.com/kkoomen/vim-doge/commit/3061c38b3a534788f848043a65b3f9d85cca4b5c))
* Remove duplicates properly in doge#buffer#get_supported_doc_standards() ([7db29f7](https://github.com/kkoomen/vim-doge/commit/7db29f7fbdbcddac84a7202ed0029e1c61471d03))
* Unlet parameters key instead of v:false ([a638cd9](https://github.com/kkoomen/vim-doge/commit/a638cd93cd5e0bbe5780310395cf4b58b60ea4d1))


### Features

* **#71:** Add support for PHP 7 return type declaration and PHP 8 union types ([ec27953](https://github.com/kkoomen/vim-doge/commit/ec27953fe1459bf6d92b499a77b20159618f79a9)), closes [#71](https://github.com/kkoomen/vim-doge/issues/71)
* Add polyfill for mkdir, see E739; Add tests ([679f7dc](https://github.com/kkoomen/vim-doge/commit/679f7dc13ac24b5f36b3ed601871399412eae74e))
* Add silent! to every execute() ([c1a526f](https://github.com/kkoomen/vim-doge/commit/c1a526fae288a5f2bcada05757a83832c1e1eb6d))
* Rebase changes from 25c64d1 v1.17.4 ([23196a9](https://github.com/kkoomen/vim-doge/commit/23196a94bb40d6e7086a83fb0584d441d6792ce4))
* Return when opening file to prevent duplicate content ([74e0f5d](https://github.com/kkoomen/vim-doge/commit/74e0f5d1a6be083416be650473a615eb7c729543))
* **funding:** Add paypal.me link ([da2c511](https://github.com/kkoomen/vim-doge/commit/da2c511061875218865f07a44d3af04e04f70f1c))
* Add new doge#buffer functions ([8960e0c](https://github.com/kkoomen/vim-doge/commit/8960e0c1b484e2243d118c1893a4617d12278f5c))
* Initial rewrite for all languages ([c67974d](https://github.com/kkoomen/vim-doge/commit/c67974dc630269539cceab8db554fe55250fdfa6))
* Rebase changes from c2f427a v1.17.5 ([880447e](https://github.com/kkoomen/vim-doge/commit/880447e9f1b9bce7f05369583fe30b3a864213ac))
* Rename doge#generate#pattern() -> doge#pattern#generate() ([03c5263](https://github.com/kkoomen/vim-doge/commit/03c5263757afb6f066a4ec2fbf9faa363af5bf51))
* Use doge#buffer#register_doc_standard in all ftplugins ([3312abd](https://github.com/kkoomen/vim-doge/commit/3312abda5cbb106cee193edabf2dd3dcf0d5d919))
* Validate patterns when generating ([27df1d3](https://github.com/kkoomen/vim-doge/commit/27df1d3daaca1cc03ea8369b634d6ce7a308d5b2))



## [1.17.5](https://github.com/kkoomen/vim-doge/compare/v1.17.4...v1.17.5) (2019-12-02)


### Bug Fixes

* **#67:** Allow protected and private function data modifier ([c2f427a](https://github.com/kkoomen/vim-doge/commit/c2f427a0359d847b05c3db1b5e9ca9edc087ff64)), closes [#67](https://github.com/kkoomen/vim-doge/issues/67)



## [1.17.4](https://github.com/kkoomen/vim-doge/compare/v1.17.3...v1.17.4) (2019-12-01)


### Bug Fixes

* **#66:** Remove returnType when the type is void ([25c64d1](https://github.com/kkoomen/vim-doge/commit/25c64d1e521b5448800ad0b6698f320b5037bfbf)), closes [#66](https://github.com/kkoomen/vim-doge/issues/66)


### Features

* Add prefix to tempfile for c-family languages ([e899e51](https://github.com/kkoomen/vim-doge/commit/e899e516502cd74cb77d0e99426d36b9faf3a7bb))
* Remove opencollective funding page ([4fa2c09](https://github.com/kkoomen/vim-doge/commit/4fa2c09aea9556f0be2dbbacca79928816a8120c))



## [1.17.3](https://github.com/kkoomen/vim-doge/compare/v1.17.2...v1.17.3) (2019-11-27)


### Bug Fixes

* **#64:** Support optional parameter indicator for TypeScript class methods ([ca27745](https://github.com/kkoomen/vim-doge/commit/ca27745e8b4f0ea49bd5a0408411687cc88bbdfc)), closes [#64](https://github.com/kkoomen/vim-doge/issues/64)



## [1.17.2](https://github.com/kkoomen/vim-doge/compare/v1.17.1...v1.17.2) (2019-11-26)


### Bug Fixes

* **#62:** Allow public keyword for functions ([bda99bb](https://github.com/kkoomen/vim-doge/commit/bda99bb345d1c212db031cd0630922c3e51b3baa)), closes [#62](https://github.com/kkoomen/vim-doge/issues/62)



## [1.17.1](https://github.com/kkoomen/vim-doge/compare/v1.17.0...v1.17.1) (2019-11-25)


### Bug Fixes

* **#61:** Exclude self, cls and klass from python documentation ([f9db43a](https://github.com/kkoomen/vim-doge/commit/f9db43a05ec34bf0854f0a82d0f8be250642c983)), closes [#61](https://github.com/kkoomen/vim-doge/issues/61)


### Features

* Add BTC donation address ([f458d57](https://github.com/kkoomen/vim-doge/commit/f458d57b977143036c76917e0a7c0dc8e7bdbd6f))



## 1.13.1 (2019-09-12)



# [1.16.0](https://github.com/kkoomen/vim-doge/compare/v1.15.3...v1.16.0) (2019-11-18)


### Bug Fixes

* breaking tests ([35ca349](https://github.com/kkoomen/vim-doge/commit/35ca3490b0bb74e2b7c18414185078c9cbc49743))


### Features

* **#48:** Support Shell ([8abad34](https://github.com/kkoomen/vim-doge/commit/8abad34d0415db29bbc69dd7b32833d261c1c3db)), closes [#48](https://github.com/kkoomen/vim-doge/issues/48)



## [1.15.3](https://github.com/kkoomen/vim-doge/compare/v1.15.2...v1.15.3) (2019-11-18)


### Bug Fixes

* **#58:** Change logic for jump_forward() and jump_backward() to fix conflict with vim-cool ([cf9ea1d](https://github.com/kkoomen/vim-doge/commit/cf9ea1d8facd1c9ae0612f9b188bb2b97ae56816))



## [1.15.2](https://github.com/kkoomen/vim-doge/compare/v1.15.1...v1.15.2) (2019-11-17)


### Features

* Add g:doge_clang_args configurable option ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([c56c00c](https://github.com/kkoomen/vim-doge/commit/c56c00c29dcc01b5424900e455939df8724fb717))
* Add missing let-keyword ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([6b060a6](https://github.com/kkoomen/vim-doge/commit/6b060a6341c0d774d1a3410eac38d31f5a72d1ea))



## [1.15.1](https://github.com/kkoomen/vim-doge/compare/v1.15.0...v1.15.1) (2019-11-17)


### Bug Fixes

* Create temp file in the same dir as the current active vim buffer ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([685d8b1](https://github.com/kkoomen/vim-doge/commit/685d8b1bf41fca8abaa6e5654791fe58d479f3c2))
* Move FUNDING.yml to the right location ([b2cdaf8](https://github.com/kkoomen/vim-doge/commit/b2cdaf8dc4e4c968fe9dd11b74feb001c9de87a5))
* Typo of old v0.3, updated this to v0.4 ([6cb70ac](https://github.com/kkoomen/vim-doge/commit/6cb70ac01ef837dab8972780890127ae94a0604d))


### Features

* Add FUNDING.yml ([175e512](https://github.com/kkoomen/vim-doge/commit/175e512500771b4a6254a1573264184f0880df13))
* **ISSUE_TEMPLATE:** Update bug_report template ([317ef1d](https://github.com/kkoomen/vim-doge/commit/317ef1d695fecfa9f303d90b02c93dc0ee620794))
* Update travis.yml with new NeoVim v0.4 ([0961db5](https://github.com/kkoomen/vim-doge/commit/0961db5993913e54030cd22170a05ab84806ed4c))
* **docker:** Upgrade Vim v8.1.2000 -> v8.1.2300 and NeoVim v0.3.8 -> v0.4.3 ([dac31f8](https://github.com/kkoomen/vim-doge/commit/dac31f888c2aed0078cb421224737e014f540f27))



# [1.15.0](https://github.com/kkoomen/vim-doge/compare/v1.14.1...v1.15.0) (2019-11-16)


### Bug Fixes

* Adjust check for py3file issue for Vim v7.4.2119 ([ded59fb](https://github.com/kkoomen/vim-doge/commit/ded59fb35ea4bfe477e2f8049031d7ee7991e7f8))
* Change name property to funcName in libclang.py ([b682fb5](https://github.com/kkoomen/vim-doge/commit/b682fb5f3a70da945b621d97e777b9f2e82ffa2f))
* failing test ([98eb5c8](https://github.com/kkoomen/vim-doge/commit/98eb5c8db3947c16f8b923d02a6d32ac9481e14c))
* Get return type in right way; Resolve failing tests ([d8e5356](https://github.com/kkoomen/vim-doge/commit/d8e53562cb9444772dc89f3f413f0bf17b193055))
* javascript tests ([9c123af](https://github.com/kkoomen/vim-doge/commit/9c123af80553efa05db4dd5f0e6a9b3c15797714))
* linter issues ([70ec33b](https://github.com/kkoomen/vim-doge/commit/70ec33bd5b58dd430619fd36942109293620085a))
* merge conflict feature/clang-c <-- feature/clang ([c4e74c1](https://github.com/kkoomen/vim-doge/commit/c4e74c16b5c8d87fd2cc1207d6091ff08e2147c6))
* py3file error for Vim v7.4.2119 ([a3e94d7](https://github.com/kkoomen/vim-doge/commit/a3e94d71852dc4b3a08dd34f8fead407e163c005))
* Set corrects paths for tests ([54618ad](https://github.com/kkoomen/vim-doge/commit/54618ad62d724d9a25620c1bdcd80a65489299f3))


### Features

* Add class-template and struct-template tests; Add support for virtual-functions ([e70bd5d](https://github.com/kkoomen/vim-doge/commit/e70bd5d08385c1d9bab776485f37c4efe9a99616))
* Add initial working version ([cd935f6](https://github.com/kkoomen/vim-doge/commit/cd935f6f3a36bce0117f4d04534bbc3becb0a0ae))
* Add more doxygen docblock styles ([f340b6c](https://github.com/kkoomen/vim-doge/commit/f340b6c56c3407f0230ddb9e6ffeddada57dcea6))
* Add stable support for C; Optimise C++ cases ([6261f15](https://github.com/kkoomen/vim-doge/commit/6261f15934ed1b3283c7e0a8b47d6bc5770ac97c))
* Optimise docker for clang develpoment; Add basic function tests ([3317f32](https://github.com/kkoomen/vim-doge/commit/3317f32fe50b401ad393e79a653fa5ff8afb0430))
* Setup basic support for C ([f08c35d](https://github.com/kkoomen/vim-doge/commit/f08c35d4cbcdf56bfcc19e5c6aae5d59e4e4da7f))
* Update vim-testbed which fixed 7.4.2119 python build failing; Add expected docblocks in playground ([2795e9c](https://github.com/kkoomen/vim-doge/commit/2795e9c4f71e8f58b95f81a6d961c7d9db50a4dd))
* **generator:libclang.py:** Remove unused function ([64e1692](https://github.com/kkoomen/vim-doge/commit/64e16922b0eafc52e116aa9d9d625b3a2d279136))



## [1.14.1](https://github.com/kkoomen/vim-doge/compare/v1.14.0...v1.14.1) (2019-10-25)


### Bug Fixes

* **#54:** Allow export keyword in front of variables ([507425b](https://github.com/kkoomen/vim-doge/commit/507425bc6c689005336d47a93b77f9e93f9417b2)), closes [#54](https://github.com/kkoomen/vim-doge/issues/54)



# [1.14.0](https://github.com/kkoomen/vim-doge/compare/v1.13.1...v1.14.0) (2019-10-24)


### Bug Fixes

* **#54:** Optimise incorrect javascript/typescript patterns ([d10e62b](https://github.com/kkoomen/vim-doge/commit/d10e62b38bae97cc822254eaf5268437ed77062b)), closes [#54](https://github.com/kkoomen/vim-doge/issues/54)



## 1.13.1 (2019-09-12)



