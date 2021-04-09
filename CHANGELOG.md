## [3.9.1](https://github.com/kkoomen/vim-doge/compare/v3.9.0...v3.9.1) (2021-03-29)


### Bug Fixes

* **c:** support pointer return types ([#294](https://github.com/kkoomen/vim-doge/issues/294)) ([4e814d7](https://github.com/kkoomen/vim-doge/commit/4e814d7047b2bcfb81a1e14eec3873295f84b076))

# [3.9.0](https://github.com/kkoomen/vim-doge/compare/v3.8.1...v3.9.0) (2021-03-15)


### Features

* implement Errors and Safety sections ([358a0fa](https://github.com/kkoomen/vim-doge/commit/358a0fa0eb4ba78b00dea8b35c3bee7727740aa7))
* implement rust with support for functions/methods ([77becd5](https://github.com/kkoomen/vim-doge/commit/77becd56a4ad67740863815c088a150b7d6e39f6))

## [3.8.1](https://github.com/kkoomen/vim-doge/compare/v3.8.0...v3.8.1) (2021-03-07)


### Bug Fixes

* **windows:** remove old param in build.ps1 ([5aec2f6](https://github.com/kkoomen/vim-doge/commit/5aec2f69be194a7373ac9e043c8f81322ca9472b))

# 3.8.0 (2021-03-07)


### Bug Fixes

* **ci:** remove old build params ([dbc4a96](https://github.com/kkoomen/vim-doge/commit/dbc4a9637a0fba122ef5b967d31299130a29b66f))
* remove prettier/[@typescript-eslint](https://github.com/typescript-eslint) from eslintrc ([cd8b9fb](https://github.com/kkoomen/vim-doge/commit/cd8b9fb515befdd209b6a20d247bb132bdf7ca4c))
* **ci:** add strings around command for windows ([ffcfc74](https://github.com/kkoomen/vim-doge/commit/ffcfc7484d7ce12f0f6cc6432a4aa9a9af4b331f))
* **ci:** do not pass any params to build binary scripts ([27545b4](https://github.com/kkoomen/vim-doge/commit/27545b4e6a311d2d463a28610c7ae5f0c624dc25))


### Features

* replace vercel/pkg with caxa ([3c145fd](https://github.com/kkoomen/vim-doge/commit/3c145fd343e95099d4c723db7bc8f98d18c9a790))

### Features

* replace vercel/pkg with caxa ([3c145fd](https://github.com/kkoomen/vim-doge/commit/3c145fd343e95099d4c723db7bc8f98d18c9a790))

# [3.7.0](https://github.com/kkoomen/vim-doge/compare/v3.6.0...v3.7.0) (2021-02-17)


### Bug Fixes

* adjust python errors; adjust package.json and tsconfig to use build/ instead of dist/ ([e0f29d4](https://github.com/kkoomen/vim-doge/commit/e0f29d410f357202778f7ec86949796b821aa1ff))
* temp allow more output in CI ([871c2da](https://github.com/kkoomen/vim-doge/commit/871c2da5bb472b23c0fa29519932612ca8cb3164))
* use the same logic for the DogeCreateDocStandard command in the test itself ([2eafe9b](https://github.com/kkoomen/vim-doge/commit/2eafe9bf0d8d9ea68f846a78e7f57dca4f3fc91e))
* **ci:** use correct checkout path for vader.vim ([6d4c7eb](https://github.com/kkoomen/vim-doge/commit/6d4c7eb02256f29f118c9aca9585f0ccc6bb4f29))


### Features

* rename build:binary -> build:binary:unix ([7ec480c](https://github.com/kkoomen/vim-doge/commit/7ec480c532c37ed518cb7eb44c65de73f91d7ed4))

# [3.6.0](https://github.com/kkoomen/vim-doge/compare/v3.5.4...v3.6.0) (2020-12-19)

### Bug Fixes

- **cpp:** support functions that return pointers ([#179](https://github.com/kkoomen/vim-doge/issues/179)) ([493336a](https://github.com/kkoomen/vim-doge/commit/493336afdaf81d84050c114f0558824fc70356de))

### Features

- support headless mode ([#199](https://github.com/kkoomen/vim-doge/issues/199)) ([ec4d1c4](https://github.com/kkoomen/vim-doge/commit/ec4d1c4702918f4cf31ce2d1dbe97e65c12d5d6d))

## [3.5.4](https://github.com/kkoomen/vim-doge/compare/v3.5.3...v3.5.4) (2020-11-17)

### Bug Fixes

- adjust elif statement to be compatible with dash ([#160](https://github.com/kkoomen/vim-doge/issues/160)) ([3964cb0](https://github.com/kkoomen/vim-doge/commit/3964cb0841cfed670b6bf509deb5d56f69c2c258))

## [3.5.3](https://github.com/kkoomen/vim-doge/compare/v3.5.2...v3.5.3) (2020-11-17)

### Bug Fixes

- make install script compatible with dash ([#160](https://github.com/kkoomen/vim-doge/issues/160)) ([3129f22](https://github.com/kkoomen/vim-doge/commit/3129f227547c95547be1d1fcc4f75e45e93442e0))

## [3.5.2](https://github.com/kkoomen/vim-doge/compare/v3.5.2-beta.1...v3.5.2) (2020-11-16)

## [3.5.2-beta.1](https://github.com/kkoomen/vim-doge/compare/v3.5.2-beta.0...v3.5.2-beta.1) (2020-11-16)

### Bug Fixes

- use shellescape() in system call and resolve typo ([#157](https://github.com/kkoomen/vim-doge/issues/157)) ([3b55111](https://github.com/kkoomen/vim-doge/commit/3b55111ea13f692c7f04d601f688a13807ccf71f))

## [3.5.2-beta.0](https://github.com/kkoomen/vim-doge/compare/v3.5.1...v3.5.2-beta.0) (2020-11-16)

### Bug Fixes

- use case-sensitive check for doge#install() ([400e871](https://github.com/kkoomen/vim-doge/commit/400e87185f7514b3edb7c2801cb36dc41f4c85b5))

### Features

- do not download binary if already downloaded ([b5695b6](https://github.com/kkoomen/vim-doge/commit/b5695b60f8f31450b433d31c5c8a36e86cef8b28))

## [3.5.1](https://github.com/kkoomen/vim-doge/compare/v3.5.0...v3.5.1) (2020-10-31)

### Bug Fixes

- **windows:** prefix install.ps1 with powershell.exe ([5853802](https://github.com/kkoomen/vim-doge/commit/58538028a60bbcbc3a1f8d86c719f18b0eea2004))

# [3.5.0](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.5...v3.5.0) (2020-10-31)

### Bug Fixes

- **ci:** exit 1 if reached 5 test tries ([f4bd0de](https://github.com/kkoomen/vim-doge/commit/f4bd0dea2ef9722cd8f793c5cd38c178c766858e))
- **ci:** only run windows tests for now ([cc00317](https://github.com/kkoomen/vim-doge/commit/cc0031739a7d949546da63c383be0ec8d066513c))
- **ci:** run windows tests but only for Vim, exclude NeoVim ([e3a0300](https://github.com/kkoomen/vim-doge/commit/e3a0300ab3966d96acf5af2a814ff717de51ba72))
- **ci:** use correct windows target value ([41eab11](https://github.com/kkoomen/vim-doge/commit/41eab113fa6337859980f6fabbea082560600ad6))
- **test:** make sure the vim-doge rtp are the only runtimepaths ([3c963e9](https://github.com/kkoomen/vim-doge/commit/3c963e9f892a3a60e3422eff0cd52869196a5352))
- **tests:** call execute() method in test/vimrc ([7be6a45](https://github.com/kkoomen/vim-doge/commit/7be6a455bdb49298c5fcc4711576fd3ac7bef446))
- **tests:** only create ~/.vim dir on non-windows systems ([206a584](https://github.com/kkoomen/vim-doge/commit/206a5845c6b5af484afd5eb2a455b0c241855f9b))
- **tests:** temporarily disable neovim tests ([4a4e74d](https://github.com/kkoomen/vim-doge/commit/4a4e74de837d83cee68f326d7530b645b7010829))
- **tests:** update vimrc runtimepath to work on windows ([2684c96](https://github.com/kkoomen/vim-doge/commit/2684c96a08a52df9212d454bdeada96365894f27))
- **tests:** use proper runtimepath and only run windows tests ([0d72744](https://github.com/kkoomen/vim-doge/commit/0d72744a5936d90807629f0809ef940d4b51e7b1))
- **windows:** use shellslash check for g:doge_dir ([57777b7](https://github.com/kkoomen/vim-doge/commit/57777b79d0c363fe21ba984a74ec75cb0bc51176))
- add path fix for windows in vercel/pkg submodule ([9cf0164](https://github.com/kkoomen/vim-doge/commit/9cf01642b6308e940ad4b65b9918f90afb020709))

### Features

- **ci:** first try to support windows ([709b6c6](https://github.com/kkoomen/vim-doge/commit/709b6c636666ee28747f15dcbfd619575ede3067))
- **windows:** set shell=powershel before running ps1 script ([184f510](https://github.com/kkoomen/vim-doge/commit/184f5102bf4ecda5ba7a4bc78dc42d8224da24df))

## [3.4.2-beta.5](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.4...v3.4.2-beta.5) (2020-10-27)

## [3.4.2-beta.4](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.3...v3.4.2-beta.4) (2020-10-27)

## [3.4.2-beta.3](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.2...v3.4.2-beta.3) (2020-10-27)

### Bug Fixes

- **ci:** only support win64 for now ([cd4a7fb](https://github.com/kkoomen/vim-doge/commit/cd4a7fbd31bf54a661c0f8d1a4e6bd3f8a76c409))

## [3.4.2-beta.2](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.1...v3.4.2-beta.2) (2020-10-27)

### Bug Fixes

- **ci:** resolve path to parent dir for windows ([02aabcb](https://github.com/kkoomen/vim-doge/commit/02aabcb638eaa1c51479810e1c8db67ff0d27360))

## [3.4.2-beta.1](https://github.com/kkoomen/vim-doge/compare/v3.4.2-beta.0...v3.4.2-beta.1) (2020-10-27)

### Bug Fixes

- **ci:** use powershell equivalent of != and && ([fcaa173](https://github.com/kkoomen/vim-doge/commit/fcaa1732569ddc2a270c74dca60669764a6efe3a))

## [3.4.2-beta.0](https://github.com/kkoomen/vim-doge/compare/v3.4.1...v3.4.2-beta.0) (2020-10-27)

### Features

- add initial windows build script setup ([24869f9](https://github.com/kkoomen/vim-doge/commit/24869f942e2576a31707cce3d1bca9d05e83dd88))

## [3.4.1](https://github.com/kkoomen/vim-doge/compare/v3.4.0...v3.4.1) (2020-10-24)

### Bug Fixes

- **typescript:** do not generate docs for function calls ([65ae158](https://github.com/kkoomen/vim-doge/commit/65ae15862269255becb15ffc624a51839b740928))

# [3.4.0](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.26...v3.4.0) (2020-10-24)

### Bug Fixes

- **ci:** rename steps name ([9b01428](https://github.com/kkoomen/vim-doge/commit/9b014289dec7cf4e046d7d32dce251adbd7a578b))

### Features

- recreate PR [#104](https://github.com/kkoomen/vim-doge/issues/104) ([9c6e84c](https://github.com/kkoomen/vim-doge/commit/9c6e84cbb43e3d8772704ba68e73acb2eb4ca626))
- **cpp:** add support for virtual functions ([#41](https://github.com/kkoomen/vim-doge/issues/41)) ([a06e8e9](https://github.com/kkoomen/vim-doge/commit/a06e8e9a7680ee47b405268939f8d08d4e54c805))

## [3.3.2-beta.26](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.25...v3.3.2-beta.26) (2020-10-24)

### Bug Fixes

- **ci:** use underscores in yml keys ([74df0df](https://github.com/kkoomen/vim-doge/commit/74df0df54c19a9ae5b24b3446ef23a9fa3ebcbf8))

## 3.3.2-beta.25 (2020-10-24)

### Bug Fixes

- give prio to ./bin/vim-doge.exe instead of ./bin/vim-doge ([5e42557](https://github.com/kkoomen/vim-doge/commit/5e4255783b3ea4c8d881353e9e1972f18b09c14a))
- **ci:** add vader.vim to neovim tests ([dde32db](https://github.com/kkoomen/vim-doge/commit/dde32db3ad6c76033c2c678bea037e22afdaa84d))
- **ci:** always build from source with neovim ([6b1a0e9](https://github.com/kkoomen/vim-doge/commit/6b1a0e96295fc7534f774862c80d9ada97f519e8))
- **ci:** bump neovim version from v0.2.0 -> v0.2.1 ([1435a2b](https://github.com/kkoomen/vim-doge/commit/1435a2b8c2a660cb4ce01505a775794ea8981235))
- **ci:** bump neovim version from v0.2.1 -> v0.2.2 ([33a4d1d](https://github.com/kkoomen/vim-doge/commit/33a4d1d435489c03c61eecfd4555757674d54c56))
- **ci:** bump neovim version from v0.2.2 -> v0.3.0 ([3e12b0a](https://github.com/kkoomen/vim-doge/commit/3e12b0a6ec38d44930b13a9ab733329366c17d11))
- **ci:** bump neovim version from v0.3.0 -> v0.3.2 ([356cd50](https://github.com/kkoomen/vim-doge/commit/356cd50416daa3be58ea43c28949908c1f3cae20))
- **ci:** change vim_type:vim to vim_type:neovim for neovim tests ([5cd086f](https://github.com/kkoomen/vim-doge/commit/5cd086fe5934aeb9df76dccd5843e269c09517e5))
- **ci:** check if binary exists before using chmod ([b1b5a89](https://github.com/kkoomen/vim-doge/commit/b1b5a89bd74044f5d59ec68d310ec0b9fbc9e8d6))
- **ci:** convert TARGET env var into output var ([cce2d2c](https://github.com/kkoomen/vim-doge/commit/cce2d2c9d417671e3086c8c28972a8b76437a583))
- **ci:** do not run chmod on vim-doge.exe ([7d4bc9d](https://github.com/kkoomen/vim-doge/commit/7d4bc9d36798120de5441e2839a2e9192f47d8a7))
- **ci:** pass target to build script ([b33ebb0](https://github.com/kkoomen/vim-doge/commit/b33ebb0545a04232f9feb9dbf9cd16f6e96fa08e))
- **ci:** surpress chmod errors from build.sh ([910b6b9](https://github.com/kkoomen/vim-doge/commit/910b6b9cd2b54a714675bb3eede204c0cf0e1e81))
- **ci:** use head instead of stable vim version ([1dc882c](https://github.com/kkoomen/vim-doge/commit/1dc882ce7a1906beca341588d389629e5c60f2f2))
- **install script:** fix incorrect unarchiving commands ([f001e03](https://github.com/kkoomen/vim-doge/commit/f001e036737fceb3e47ba3a8a0cbfc29d16803e4))

### Features

- remove support for windows ([2d7010d](https://github.com/kkoomen/vim-doge/commit/2d7010d6a00a9c832c144c23faea1122a793601f))
- **ci:** add neovim tests ([54ecd1a](https://github.com/kkoomen/vim-doge/commit/54ecd1a939a35332305c9aacfd97b25617d57148))
- **ci:** include windows-latest in the tests ([34cdb72](https://github.com/kkoomen/vim-doge/commit/34cdb72cdd31724c01c457c16ed607e5d87d5c6f))
- **ci:** use matrix.include to switch target version and other vars ([2c763f3](https://github.com/kkoomen/vim-doge/commit/2c763f390c4b4260739b97596517ce7746e5b34c))
- **ci:** use thinca/action-setup-vim instead of rhysd/action-setup-vim ([06165aa](https://github.com/kkoomen/vim-doge/commit/06165aabdd2c13e75238f6d3b23b4618751bebd7))

## [3.3.2-beta.24](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.23...v3.3.2-beta.24) (2020-10-23)

### Bug Fixes

- **ci:** use matrix method for ubuntu and macos ([05ff5f7](https://github.com/kkoomen/vim-doge/commit/05ff5f763db05378c028caa02a054963d149caa6))

## [3.3.2-beta.23](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.22...v3.3.2-beta.23) (2020-10-23)

### Bug Fixes

- **ci:** remove invalid needs-key ([fc43674](https://github.com/kkoomen/vim-doge/commit/fc436745d84f8c3477ef8095e18d7db552832cbd))

## [3.3.2-beta.22](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.21...v3.3.2-beta.22) (2020-10-23)

### Bug Fixes

- **ci:** run on release:created instead of created tag ([4f4af3f](https://github.com/kkoomen/vim-doge/commit/4f4af3fd0bf946c2a28b5ed938c9dee66d47c175))

## [3.3.2-beta.21](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.20...v3.3.2-beta.21) (2020-10-23)

### Bug Fixes

- **ci:** replace [0-9]+ with \* ([67c66b0](https://github.com/kkoomen/vim-doge/commit/67c66b04c96483885151f9209cadcb0a41a0f0b4))

## [3.3.2-beta.20](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.19...v3.3.2-beta.20) (2020-10-23)

## [3.3.2-beta.19](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.18...v3.3.2-beta.19) (2020-10-23)

### Bug Fixes

- **ci:** only use negate pattern for the releas ([7087532](https://github.com/kkoomen/vim-doge/commit/70875322e32c764948ae865b23f4e1c941df8caf))

## [3.3.2-beta.18](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.17...v3.3.2-beta.18) (2020-10-23)

### Bug Fixes

- **ci:** exclude beta versions in main release ([d0ff95f](https://github.com/kkoomen/vim-doge/commit/d0ff95f0f4ec0e4ff7e120b5007e54242e1fc6c8))

## [3.3.2-beta.17](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.16...v3.3.2-beta.17) (2020-10-23)

### Features

- **ci:** add release workflow ([de3b0c4](https://github.com/kkoomen/vim-doge/commit/de3b0c455e77e41160cc444eb8cf817598744605))

## [3.3.2-beta.16](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.15...v3.3.2-beta.16) (2020-10-23)

### Bug Fixes

- **ci:** revert incorrect RUNNER_OS and url vars ([123a3c6](https://github.com/kkoomen/vim-doge/commit/123a3c6fd15a736e9262e5287d573138750aeee3))

## [3.3.2-beta.15](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.14...v3.3.2-beta.15) (2020-10-23)

### Bug Fixes

- **ci:** use env prefix for remaining env vars ([ca73ea5](https://github.com/kkoomen/vim-doge/commit/ca73ea514a7b15547ad5764f69682de7cceb561d))

## [3.3.2-beta.14](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.13...v3.3.2-beta.14) (2020-10-23)

### Bug Fixes

- **ci:** use env prefix for env vars ([25f5816](https://github.com/kkoomen/vim-doge/commit/25f58160f43e8f08ebcb64ac764eb183ba6dd427))

## [3.3.2-beta.13](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.12...v3.3.2-beta.13) (2020-10-23)

### Bug Fixes

- **ci:** use workaround for the upload-release-assets args ([b136772](https://github.com/kkoomen/vim-doge/commit/b136772817b8a1226ee04e8cb307379d77576078))

## [3.3.2-beta.12](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.11...v3.3.2-beta.12) (2020-10-23)

## [3.3.2-beta.11](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.10...v3.3.2-beta.11) (2020-10-23)

## [3.3.2-beta.10](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.9...v3.3.2-beta.10) (2020-10-23)

### Bug Fixes

- **ci:** use correct syntax ([9da65dd](https://github.com/kkoomen/vim-doge/commit/9da65dd3ce49902c27b17533cc3a63286885888a))

## [3.3.2-beta.9](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.8...v3.3.2-beta.9) (2020-10-23)

## [3.3.2-beta.8](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.7...v3.3.2-beta.8) (2020-10-23)

## [3.3.2-beta.7](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.6...v3.3.2-beta.7) (2020-10-23)

### Bug Fixes

- **ci:** change runner.os to \$RUNNER_OS ([d0d054c](https://github.com/kkoomen/vim-doge/commit/d0d054c28a7055deaa8a5baaac36a7b34de381d9))
- **ci:** only run beta-release workflow on new tags ([0e8627c](https://github.com/kkoomen/vim-doge/commit/0e8627c68052c08ce3e2d8d7a85184437407eb78))

## [3.3.2-beta.6](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.5...v3.3.2-beta.6) (2020-10-23)

### Bug Fixes

- **ci:** move env key from root scope to job scope ([0259ab2](https://github.com/kkoomen/vim-doge/commit/0259ab229485318f66fd1b8e3a274b294eb64aff))

## [3.3.2-beta.5](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.4...v3.3.2-beta.5) (2020-10-23)

### Bug Fixes

- **ci:** build multiple releases on different systems ([da62246](https://github.com/kkoomen/vim-doge/commit/da6224687ac3083c8d1c854500e274abaa6aec4a))

## [3.3.2-beta.4](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.3...v3.3.2-beta.4) (2020-10-23)

### Features

- **ci:** build release assets with actions/create-release and actions/upload-release-asset ([635148c](https://github.com/kkoomen/vim-doge/commit/635148cfa3c43da7ea7fc31fbbf3fc851012e95c))

## [3.3.2-beta.3](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.2...v3.3.2-beta.3) (2020-10-23)

### Bug Fixes

- **ci:** specify all branches, excluding tags ([950a82a](https://github.com/kkoomen/vim-doge/commit/950a82a3ef52de4fd81d51c98f85ad3b12c0bc60))

## [3.3.2-beta.2](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.1...v3.3.2-beta.2) (2020-10-23)

### Bug Fixes

- **ci:** only build release assets on published type ([2fbe1f4](https://github.com/kkoomen/vim-doge/commit/2fbe1f44604c978490d286dc6092f1186aeda4cb))

## [3.3.2-beta.1](https://github.com/kkoomen/vim-doge/compare/v3.3.2-beta.0...v3.3.2-beta.1) (2020-10-23)

### Bug Fixes

- **ci:** use env variables for node-version and build target ([eaf8e5b](https://github.com/kkoomen/vim-doge/commit/eaf8e5ba28d0f8abc92f127d8bb445bc89240e95))

### Features

- **ci:** rename ci.yml to tests.yml ([f9a35a0](https://github.com/kkoomen/vim-doge/commit/f9a35a041764edfbfaf59b28806c65e3e57dcd7b))

## [3.3.2-beta.0](https://github.com/kkoomen/vim-doge/compare/v3.3.1...v3.3.2-beta.0) (2020-10-23)

### Bug Fixes

- revert package.json version back ([20142bf](https://github.com/kkoomen/vim-doge/commit/20142bf73798c5cae860c34a1dd248dd9ccfd155))
- **ci:** add matrix prefix for variable ([3bfa189](https://github.com/kkoomen/vim-doge/commit/3bfa1890dcaa82c06809f4dc9625728217a14ac4))
- **ci:** do not compress binary if no name has been given ([d607ee0](https://github.com/kkoomen/vim-doge/commit/d607ee0f0582c8b6867ec34fe960653ccb475948))
- **ci:** replace old \$tests var with all the necessary globs ([3f8c81f](https://github.com/kkoomen/vim-doge/commit/3f8c81f86627a8f0bfdf68976cb182bc467035ae))
- **ci:** set runtimepath correctly for unix / macunix ([2b634c5](https://github.com/kkoomen/vim-doge/commit/2b634c596325224ed8ed3ef4c29e11afbadd8cd8))
- **ci:** split up single job into separate linux + macos jobs ([0e25059](https://github.com/kkoomen/vim-doge/commit/0e25059be2b5e9d917eb272a453b95684ca11f5c))
- **ci:** use proper testing setup for vim + neovim ([6022cab](https://github.com/kkoomen/vim-doge/commit/6022cab9cc5a51235643b3b98321b80c14d11d52))
- add vader as a submodule and adjust test vimrc runtimepath ([21bbbc1](https://github.com/kkoomen/vim-doge/commit/21bbbc18900ab54e3fa9591653b5bcbd9f241b9f))

### Features

- **ci:** add linux build to the release.yml ([287dd6b](https://github.com/kkoomen/vim-doge/commit/287dd6b8bafb267fae908b414d2e552c56f39811))
- **ci:** add release workflow ([678d913](https://github.com/kkoomen/vim-doge/commit/678d913516b93f3321255d95a851282d4c5f7dda))
- move echo to the top to ensure proper color echoing ([6e66713](https://github.com/kkoomen/vim-doge/commit/6e66713f780e1ac526fda48dbfe81ef0d5f6128f))
- **ci:** filter vader output ([4fd24e4](https://github.com/kkoomen/vim-doge/commit/4fd24e4bb68529b6d0a58eaa05c8ca11a3de7765))
- **gitmodules:** add shallow = true to vader ([73da31a](https://github.com/kkoomen/vim-doge/commit/73da31a8c977bacd876f39181a62b221e3826dd7))
- remove travis.yml and setup initial CI workflow ([0c35ac9](https://github.com/kkoomen/vim-doge/commit/0c35ac97ea21f7005b54de58b512a4acebc11145))

## [3.3.1](https://github.com/kkoomen/vim-doge/compare/v3.3.0...v3.3.1) (2020-10-20)

### Bug Fixes

- **install.sh:** Only make dir when it does not exists ([#113](https://github.com/kkoomen/vim-doge/issues/113)) ([3006c7b](https://github.com/kkoomen/vim-doge/commit/3006c7b4027d380e86c40a9d506d98035d1dca05))

# [3.3.0](https://github.com/kkoomen/vim-doge/compare/v3.2.10...v3.3.0) (2020-10-20)

### Features

- archive binaries in builds for faster downloads ([42e92f6](https://github.com/kkoomen/vim-doge/commit/42e92f620ade9a472b8d08b4a71701112b5447e9))

# 3.3.0 (2020-10-20)

### Features

- archive binaries in builds for faster downloads ([42e92f6](https://github.com/kkoomen/vim-doge/commit/42e92f620ade9a472b8d08b4a71701112b5447e9))

## [3.2.10](https://github.com/kkoomen/vim-doge/compare/3.2.9...v3.2.10) (2020-10-20)

### Bug Fixes

- **typescript:** use TSX parser to support JSX/TSX in JS/TS ([#110](https://github.com/kkoomen/vim-doge/issues/110)) ([60cbfe7](https://github.com/kkoomen/vim-doge/commit/60cbfe73d894488353ff335aee8e58b49be123ba))

## [3.2.9](https://github.com/kkoomen/vim-doge/compare/3.2.8...3.2.9) (2020-10-17)

### Bug Fixes

- remove question-mark in regex ([#110](https://github.com/kkoomen/vim-doge/issues/110)) ([6448da8](https://github.com/kkoomen/vim-doge/commit/6448da8ccc4feb7e77f76572141e1a04af491dd3))

## [3.2.8](https://github.com/kkoomen/vim-doge/compare/3.2.7...3.2.8) (2020-10-17)

### Bug Fixes

- use correct regex for self-closing tag ([#110](https://github.com/kkoomen/vim-doge/issues/110)) ([96636f1](https://github.com/kkoomen/vim-doge/commit/96636f143fa02679a0e28958281e2188ab6f6900))

## [3.2.7](https://github.com/kkoomen/vim-doge/compare/3.2.6...3.2.7) (2020-10-17)

### Bug Fixes

- strip HTML tags properly ([#110](https://github.com/kkoomen/vim-doge/issues/110)) ([8e55d37](https://github.com/kkoomen/vim-doge/commit/8e55d378b8c27619867fb8736f9643f01c10ab2a))

## [3.2.6](https://github.com/kkoomen/vim-doge/compare/3.2.5...3.2.6) (2020-10-17)

### Bug Fixes

- **javascript:** strip html tags from source code, fixes [#110](https://github.com/kkoomen/vim-doge/issues/110) ([6ea1d83](https://github.com/kkoomen/vim-doge/commit/6ea1d83e8ad5ca3c8c757bee911cc3e17cca60b9))

## [3.2.5](https://github.com/kkoomen/vim-doge/compare/3.2.4...3.2.5) (2020-10-17)

### Bug Fixes

- remove ./bin/vim-doge before installing ([35b7c9e](https://github.com/kkoomen/vim-doge/commit/35b7c9eb179f9106e6abd6d4c298e3e64bf3afca))

## [3.2.4](https://github.com/kkoomen/vim-doge/compare/3.2.3...3.2.4) (2020-10-17)

### Bug Fixes

- use custom fork to ensure no unexpected breaking changes ([b460bcc](https://github.com/kkoomen/vim-doge/commit/b460bccb3ab288f3f081a05efb9406ed76ddaf0f))

## [3.2.3](https://github.com/kkoomen/vim-doge/compare/3.2.2...3.2.3) (2020-10-17)

### Bug Fixes

- remove v prefix in version when downloading ([ffc583f](https://github.com/kkoomen/vim-doge/commit/ffc583fe68e030ab73f0791148c315e206504047))

## [3.2.2](https://github.com/kkoomen/vim-doge/compare/3.2.1...3.2.2) (2020-10-17)

### Bug Fixes

- add staged .version file after version bump ([ead9864](https://github.com/kkoomen/vim-doge/commit/ead9864e1529dc2f06987423939954f88d2e6748))

## [3.2.1](https://github.com/kkoomen/vim-doge/compare/3.2.0...3.2.1) (2020-10-17)

### Features

- add .version file for install script instead of stripping it from package.json ([e3cc326](https://github.com/kkoomen/vim-doge/commit/e3cc3264034ea22c60b670571ed4bf0488c275cd))

# [3.2.0](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.9...3.2.0) (2020-10-17)

### Features

- remove support for g:doge_parsers ([0159f3e](https://github.com/kkoomen/vim-doge/commit/0159f3e53b8110a04926536544b5700567d4195c))

## [3.1.1](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.9...3.2.0) (2020-10-13)

## 3.1.2-beta.9 (2020-10-17)

### Bug Fixes

- remove redundant ROOT_DIR in variable to ensure chmod executes correctly ([f84cb9d](https://github.com/kkoomen/vim-doge/commit/f84cb9d36dc9d35ef042041102216be6822a47ab))

## [3.1.2-beta.8](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.7...3.1.2-beta.8) (2020-10-17)

### Bug Fixes

- adjust logic in doge#helpers#parser() to allow local build + prod build ([c3f5651](https://github.com/kkoomen/vim-doge/commit/c3f56511c4b20f5f433e4536b67b87eda8fb00b8))

## [3.1.2-beta.7](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.6...3.1.2-beta.7) (2020-10-16)

### Bug Fixes

- resolve ROOT_DIR properly ([270c41b](https://github.com/kkoomen/vim-doge/commit/270c41b2d490ecc08e4faa3cee83661ba33885e9))

## [3.1.2-beta.6](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.5...3.1.2-beta.6) (2020-10-16)

### Bug Fixes

- add extensions to ensure dirname commands works ([0e55767](https://github.com/kkoomen/vim-doge/commit/0e557675554392721097a060efb185eaa6b3f072))

## [3.1.2-beta.5](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.4...3.1.2-beta.5) (2020-10-16)

### Bug Fixes

- rename install/build scripts and remove most logging ([ca3338b](https://github.com/kkoomen/vim-doge/commit/ca3338b8f3697037904dcdeddf1bf88dd7ed6481))
- resolve ROOT_DIR properly ([271e457](https://github.com/kkoomen/vim-doge/commit/271e457ca3f552741617273eef1f3f3ddc958547))

## [3.1.2-beta.4](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.3...3.1.2-beta.4) (2020-10-16)

### Bug Fixes

- add missing echo in install script ([35bad8e](https://github.com/kkoomen/vim-doge/commit/35bad8ec399bfc45f785d7081f0262c41491240b))

## [3.1.2-beta.3](https://github.com/kkoomen/vim-doge/compare/3.1.2-beta.2...3.1.2-beta.3) (2020-10-16)

### Bug Fixes

- add ROOT_DIR in front of OUTFILE path ([c927d44](https://github.com/kkoomen/vim-doge/commit/c927d4492ae5b081b481274a2c8bcd51a0a99544))

## 3.1.2-beta.2 (2020-10-16)

### Bug Fixes

- resolve ROOT_DIR properly in build/install scripts ([4d45442](https://github.com/kkoomen/vim-doge/commit/4d45442f29c3fd0c342ae6e89a8e2fa4c0185b04))
- use realpath instead of dirname in setup/build scripts ([c2ac7da](https://github.com/kkoomen/vim-doge/commit/c2ac7dabccf68f885dc0396bb744241e466f9436))

## [3.1.2-beta.1](https://github.com/kkoomen/vim-doge/compare/v3.1.2-beta.0...v3.1.2-beta.1) (2020-10-16)

### Features

- optimise install + build scripts ([06db921](https://github.com/kkoomen/vim-doge/commit/06db921d560eea236c80be31fd78318c4b989a2b))
- update doge#install() ([fdfcd2f](https://github.com/kkoomen/vim-doge/commit/fdfcd2f266c7e46214f1fb7d6845b9b29a455136))

## [3.1.2-beta.0](https://github.com/kkoomen/vim-doge/compare/v3.1.1...v3.1.2-beta.0) (2020-10-16)

### Features

- add initial setup ([bf7745b](https://github.com/kkoomen/vim-doge/commit/bf7745b1e32caa34bb4565a28cde868b9850f413))
- add proper build flow into single binary; add release-it config ([17b42dc](https://github.com/kkoomen/vim-doge/commit/17b42dc1223bec4e697afcedf73ad2e8fdf69c61))

## [3.1.1](https://github.com/kkoomen/vim-doge/compare/v3.1.0...v3.1.1) (2020-10-13)

### Features

- **javascript:** use !name instead of !parentName for the sake of multi-cursor ([7a56d28](https://github.com/kkoomen/vim-doge/commit/7a56d280048821938f77c7eee05fc71b3deffe82))

# [3.1.0](https://github.com/kkoomen/vim-doge/compare/v3.0.1...v3.1.0) (2020-10-13)

### Bug Fixes

- do not decode empty strings, closes [#105](https://github.com/kkoomen/vim-doge/issues/105) ([b26026b](https://github.com/kkoomen/vim-doge/commit/b26026b3be2dd735ab7b89ede2dd9a0dea22a2ae))

### Features

- **javascript:** add new destructuring option, closes [#109](https://github.com/kkoomen/vim-doge/issues/109) ([72f2432](https://github.com/kkoomen/vim-doge/commit/72f24322d14facb598730423d21c5a70aed54b6d))

## [3.0.1](https://github.com/kkoomen/vim-doge/compare/v3.0.0...v3.0.1) (2020-10-08)

### Bug Fixes

- make rimraf a dep instead of devdep ([4085897](https://github.com/kkoomen/vim-doge/commit/4085897a2bb39d7a97596cbdc57171c5a9fd741d))

### Features

- **python:** remove types from google doc ([#97](https://github.com/kkoomen/vim-doge/issues/97)) ([92e9973](https://github.com/kkoomen/vim-doge/commit/92e9973abac3836271afeff52515434c9c7fbf32))

# [3.0.0](https://github.com/kkoomen/vim-doge/compare/v2.8.0...v3.0.0) (2020-10-08)

### Bug Fixes

- **docker:** rimraf dist/\* instead of dist to fix conflict with volume ([60a32c8](https://github.com/kkoomen/vim-doge/commit/60a32c83fc5c0510e1e710a235b74c385d367d72))
- add doge#helpers#deepsubstitute() back ([78adc13](https://github.com/kkoomen/vim-doge/commit/78adc13bda8a6d25d44289827339ce1071d63cc2))
- **docker:** add webpack to Dockerfile ([3c7012d](https://github.com/kkoomen/vim-doge/commit/3c7012d037f967a464f77e5a63376b9f0ad98e4c))
- **python:** add semicolon for numpy exception ([#77](https://github.com/kkoomen/vim-doge/issues/77)) ([af1c1f2](https://github.com/kkoomen/vim-doge/commit/af1c1f2ce292dd28a1b3b8359138fc653c2e843d))
- resolve broken tests for all versions ([239ff81](https://github.com/kkoomen/vim-doge/commit/239ff81063a84aee02c368ae16941559e5b0d058))

### Features

- add doge#install() and g:doge_parsers for dynamic language selection ([cfe6edb](https://github.com/kkoomen/vim-doge/commit/cfe6edb07546db06d1f3646347e2ab0d9cf613f5))
- revert python method back; remove webpack ([8aa0e50](https://github.com/kkoomen/vim-doge/commit/8aa0e505fbb49938ffdb49c5c4f0569c77e3bb8c))
- **javascript:** parse exceptions in the function body and add it in the docblock ([cd7c835](https://github.com/kkoomen/vim-doge/commit/cd7c83585056b37bbcbe6e4e94e85bdd01df1daf))
- **php:** add default !name if exception name couldnt be parsed ([29a269c](https://github.com/kkoomen/vim-doge/commit/29a269c07b0b9341391d4db627a1c61f592c615c))
- **php:** add exception names via body in docblock ([7cb1fda](https://github.com/kkoomen/vim-doge/commit/7cb1fda30b0e699deb630fee5d8b9ef8bae83697))
- **python:** add default !name if exception name couldnt be parsed ([#77](https://github.com/kkoomen/vim-doge/issues/77)) ([dced707](https://github.com/kkoomen/vim-doge/commit/dced70799b56dd220841833ac5ff854eeadec06b))
- **python:** add exception names via body in docblock ([#77](https://github.com/kkoomen/vim-doge/issues/77)) ([1699fd7](https://github.com/kkoomen/vim-doge/commit/1699fd70ec177cd362878e26faeee32bb6f159e1))
- add initial tree-sitter rewrite for javascript/typescript ([ec88a48](https://github.com/kkoomen/vim-doge/commit/ec88a481f8a7afc83b3a7df25fc60b294db3a992))
- add proper support for javascript ([1f1a5b1](https://github.com/kkoomen/vim-doge/commit/1f1a5b1724668e1b8f0e8a8da31f6ca33c165daf))
- add support for bash ([ed587cf](https://github.com/kkoomen/vim-doge/commit/ed587cf762d82103119e64bb03f19036ee8335f1))
- add support for C ([77ae35b](https://github.com/kkoomen/vim-doge/commit/77ae35b4798756538e34922e96871118aa0a9d2e))
- add support for c++ ([6ad7e0c](https://github.com/kkoomen/vim-doge/commit/6ad7e0c86ac9805a1a4a3d2f731b463d2013674f))
- add support for java + groovy ([72842b4](https://github.com/kkoomen/vim-doge/commit/72842b46efaf42fe1c0bf4fa2e28cc38fdc39a49))
- add support for lua ([dc2d178](https://github.com/kkoomen/vim-doge/commit/dc2d178e5a395e56ce89d6f5e253a838736157bf))
- add support for python ([027216a](https://github.com/kkoomen/vim-doge/commit/027216abddf316fa3d1db8bed2e1688b8be5e0d3))
- add support for ruby ([5a11538](https://github.com/kkoomen/vim-doge/commit/5a11538d886e16eaad7af35df99753def65cfe15))
- run webpack build before running tests ([1f2b6a9](https://github.com/kkoomen/vim-doge/commit/1f2b6a9d5871bee2432001668566322afd728776))
- update docs; restructure TS files ([f4244a2](https://github.com/kkoomen/vim-doge/commit/f4244a2ff5e65908a937f0ef9978325476e263df))
- **javascript:** add support for typeparams; add [@template](https://github.com/template) tag to template and TS generics tests ([f7bfb09](https://github.com/kkoomen/vim-doge/commit/f7bfb094d4257850211d136384b63a2821b6c7a7))
- **javascript:** optimise optional param parsinga and generator functions ([6ed3f90](https://github.com/kkoomen/vim-doge/commit/6ed3f900802bc0a931a6ebbdc3fa3e48f6284aff))
- **php:** rewrite php templates and tests ([d7e12e0](https://github.com/kkoomen/vim-doge/commit/d7e12e00aa1c977f7f41b3f18bf188ed2562dee8))

# [2.8.0](https://github.com/kkoomen/vim-doge/compare/v2.7.1...v2.8.0) (2020-09-02)

### Features

- **python:** add support for async functions ([#93](https://github.com/kkoomen/vim-doge/issues/93)) ([4c0b771](https://github.com/kkoomen/vim-doge/commit/4c0b771be8b7c5ad9859cc8705a727935ab63e1d))

## [2.7.1](https://github.com/kkoomen/vim-doge/compare/v2.7.0...v2.7.1) (2020-08-16)

### Bug Fixes

- **javascript:** remove unnecessary \s\* ([cf6c13d](https://github.com/kkoomen/vim-doge/commit/cf6c13da4e08687bc2bc6b8cf92ee930c45e5ba7))

### Features

- fix typescript multiline function declaration with decorators bug ([aaecec0](https://github.com/kkoomen/vim-doge/commit/aaecec074f5c20fa31631ebdc1d5b5dfc6e4816d))
- remove blockchain link from funding.yml ([7cd7038](https://github.com/kkoomen/vim-doge/commit/7cd7038d14452ce421aa5623542483bc18896811))
- remove debug comments ([011a814](https://github.com/kkoomen/vim-doge/commit/011a81429935aff2efdd111eb9671c0f4f803084))
- **python:** add configuration option to use single quotes ([#92](https://github.com/kkoomen/vim-doge/issues/92)) ([6a1dfe0](https://github.com/kkoomen/vim-doge/commit/6a1dfe04cae147b9742060c63421a282c4d2079a))

# [2.6.0](https://github.com/kkoomen/vim-doge/compare/v2.5.1...v2.6.0) (2020-07-25)

### Features

- add proper support for advanced typescript syntax ([761d2a3](https://github.com/kkoomen/vim-doge/commit/761d2a307cce69b215942f71ea1c8f38c6ad24ff))

## [2.5.1](https://github.com/kkoomen/vim-doge/compare/v2.5.0...v2.5.1) (2020-07-24)

### Features

- **java:** add !description TODO to the [@throws](https://github.com/throws) tags ([#90](https://github.com/kkoomen/vim-doge/issues/90)) ([d1e1f02](https://github.com/kkoomen/vim-doge/commit/d1e1f02333d7520a06803fa37e9bf74b31644af1))
- **java:** support exceptions in method declaration along with [@throws](https://github.com/throws) tag ([#90](https://github.com/kkoomen/vim-doge/issues/90)) ([c6ecbb0](https://github.com/kkoomen/vim-doge/commit/c6ecbb0fe0f2ca6839c123845fed55f6b2821528))

# [2.5.0](https://github.com/kkoomen/vim-doge/compare/v2.4.3...v2.5.0) (2020-07-13)

### Features

- **php:** add newline in-between [@params](https://github.com/params) and [@returns](https://github.com/returns) ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([1c01a03](https://github.com/kkoomen/vim-doge/commit/1c01a03f73644d2d33d074c74604af34b1db7e98))
- **php:** Add specific configurabe option to disable FQN resolving ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([d38b425](https://github.com/kkoomen/vim-doge/commit/d38b42566639c3e91754e7ef69a0bb231fadf335))
- **php:** Transform ?Foo param type into Foo|null ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([6350984](https://github.com/kkoomen/vim-doge/commit/635098409a218eb19cbf3edacd948cbf9d4692cf))
- **test:** re-do previous fixes ([#89](https://github.com/kkoomen/vim-doge/issues/89)) ([ae944bd](https://github.com/kkoomen/vim-doge/commit/ae944bd6150cd330ec913a28f785150017e0ebdb))
- Added the Outputs part to type sh ([65df982](https://github.com/kkoomen/vim-doge/commit/65df982a506ba3ae58cb502beb8a8ee9a09feec7))

## [2.4.2](https://github.com/kkoomen/vim-doge/compare/v2.4.1...v2.4.2) (2020-06-05)

### Features

- **DogeCreateDocStandard:** Do not pre-create the path and and write the file after generation ([#87](https://github.com/kkoomen/vim-doge/issues/87)) ([3fa9d05](https://github.com/kkoomen/vim-doge/commit/3fa9d053817ef069a728d80890455dbdf0062b83))

## [2.4.1](https://github.com/kkoomen/vim-doge/compare/v2.4.0...v2.4.1) (2020-05-29)

### Bug Fixes

- **#86:** Allow default exports for JavaScript-like languages ([8f725bb](https://github.com/kkoomen/vim-doge/commit/8f725bb9776adc0943341b5d356205aedf050c52)), closes [#86](https://github.com/kkoomen/vim-doge/issues/86)

# [2.4.0](https://github.com/kkoomen/vim-doge/compare/v2.3.0...v2.4.0) (2020-05-29)

### Features

- **javascript:** Add support for TypeScript ES7 decorators ([8b8a74d](https://github.com/kkoomen/vim-doge/commit/8b8a74dccb0af0c88547f2d73ee1af70ec055b46))

# [2.3.0](https://github.com/kkoomen/vim-doge/compare/v2.2.9...v2.3.0) (2020-05-22)

### Bug Fixes

- linting errors ([4a4a214](https://github.com/kkoomen/vim-doge/commit/4a4a214f4af51121ce3960317b0ddc253a3df872))

### Features

- **javascript:** Add Promise<T> as a return type when a function is async ([57712e9](https://github.com/kkoomen/vim-doge/commit/57712e9021a52ee5d8ca29e07cb9daed7a4e4873))

## [2.2.9](https://github.com/kkoomen/vim-doge/compare/v2.2.8...v2.2.9) (2020-05-15)

### Bug Fixes

- **#85:** Indent line based on current line rather than next or previous line ([9553b5b](https://github.com/kkoomen/vim-doge/commit/9553b5b0acd91d0851f955fc58fb5eed278b038c)), closes [#85](https://github.com/kkoomen/vim-doge/issues/85)

### Features

- **sh:** Simplify regex ([0ec2e5e](https://github.com/kkoomen/vim-doge/commit/0ec2e5ea7328260d428b4ab8fe45212c6b3ae688))

## [2.2.7](https://github.com/kkoomen/vim-doge/compare/v2.2.6...v2.2.7) (2020-03-13)

### Bug Fixes

- Preprocess aliased filetypes ([1aba70d](https://github.com/kkoomen/vim-doge/commit/1aba70d1d2ff408045f8d57eec0b8103da5d2db9))
- **ruby:** Fix ruby without parentheses ([7f2adf0](https://github.com/kkoomen/vim-doge/commit/7f2adf0709d8a34006edca8d16fc87622cab3826))

### Features

- Allow patterns to denormalize input ([5915891](https://github.com/kkoomen/vim-doge/commit/5915891ca7ca578d05df2354db8ccc2fef12f5b7))

## [2.2.5](https://github.com/kkoomen/vim-doge/compare/v2.2.4...v2.2.5) (2020-03-05)

### Bug Fixes

- **doge#buffer#get_supported_doc_standards:** Order list based on how it should be defined ([da8b5c5](https://github.com/kkoomen/vim-doge/commit/da8b5c52353444e74958fb034425c7ea04f1b781))

## [2.2.4](https://github.com/kkoomen/vim-doge/compare/v2.2.3...v2.2.4) (2020-02-21)

### Bug Fixes

- **javascript/typescript:** Support [@generator](https://github.com/generator) tag; Escape pipe characters in input to ensure union types are parsed correctly ([25b34b2](https://github.com/kkoomen/vim-doge/commit/25b34b2718111fbd29d9261fdccb5e449ad50812))

## [2.2.3](https://github.com/kkoomen/vim-doge/compare/v2.2.2...v2.2.3) (2020-02-19)

### Bug Fixes

- **#80:** Check whether current filetype is supported ([50efe22](https://github.com/kkoomen/vim-doge/commit/50efe22af6b677acc7d5645da75a5a47b056b729)), closes [#80](https://github.com/kkoomen/vim-doge/issues/80)

## [2.2.2](https://github.com/kkoomen/vim-doge/compare/v2.2.1...v2.2.2) (2020-02-18)

### Bug Fixes

- **#79:** Support advanced typescript parameters ([40f15e1](https://github.com/kkoomen/vim-doge/commit/40f15e13624de10ba70e390929814d9ea5f14570)), closes [#79](https://github.com/kkoomen/vim-doge/issues/79)

## [2.2.1](https://github.com/kkoomen/vim-doge/compare/v2.2.0...v2.2.1) (2020-01-28)

### Bug Fixes

- **#76:** Add check when switching from an alias ft to alias ft ([19b8a6e](https://github.com/kkoomen/vim-doge/commit/19b8a6ea070410d55ab347d757d75878c9adb397)), closes [#76](https://github.com/kkoomen/vim-doge/issues/76)

# [2.2.0](https://github.com/kkoomen/vim-doge/compare/v2.1.0...v2.2.0) (2020-01-01)

### Bug Fixes

- Ensure doc standards and patterns are not stacked when switching filetype ([2a1937b](https://github.com/kkoomen/vim-doge/commit/2a1937b31ded606dbddc30daa454e56f198c58b9))

### Features

- **#73:** Add g:doge_filetype_aliases to ToC ([5ebf787](https://github.com/kkoomen/vim-doge/commit/5ebf7878623189c20e14c066f7eac299083ac4d9)), closes [#73](https://github.com/kkoomen/vim-doge/issues/73)
- **#73:** Add support for g:doge_filetype_aliases; fix: prevent patterns getting stacked when changing filetype ([aa1912f](https://github.com/kkoomen/vim-doge/commit/aa1912fab227f64e3128dc68a327d6de29e24b1e)), closes [#73](https://github.com/kkoomen/vim-doge/issues/73)

# [2.1.0](https://github.com/kkoomen/vim-doge/compare/v2.0.0...v2.1.0) (2019-12-28)

### Bug Fixes

- **funding:** Add quotes to ensure correct parsing ([3061c38](https://github.com/kkoomen/vim-doge/commit/3061c38b3a534788f848043a65b3f9d85cca4b5c))
- Remove duplicates properly in doge#buffer#get_supported_doc_standards() ([7db29f7](https://github.com/kkoomen/vim-doge/commit/7db29f7fbdbcddac84a7202ed0029e1c61471d03))
- Unlet parameters key instead of v:false ([a638cd9](https://github.com/kkoomen/vim-doge/commit/a638cd93cd5e0bbe5780310395cf4b58b60ea4d1))

### Features

- **#71:** Add support for PHP 7 return type declaration and PHP 8 union types ([ec27953](https://github.com/kkoomen/vim-doge/commit/ec27953fe1459bf6d92b499a77b20159618f79a9)), closes [#71](https://github.com/kkoomen/vim-doge/issues/71)
- Add polyfill for mkdir, see E739; Add tests ([679f7dc](https://github.com/kkoomen/vim-doge/commit/679f7dc13ac24b5f36b3ed601871399412eae74e))
- Add silent! to every execute() ([c1a526f](https://github.com/kkoomen/vim-doge/commit/c1a526fae288a5f2bcada05757a83832c1e1eb6d))
- Rebase changes from 25c64d1 v1.17.4 ([23196a9](https://github.com/kkoomen/vim-doge/commit/23196a94bb40d6e7086a83fb0584d441d6792ce4))
- Return when opening file to prevent duplicate content ([74e0f5d](https://github.com/kkoomen/vim-doge/commit/74e0f5d1a6be083416be650473a615eb7c729543))
- **funding:** Add paypal.me link ([da2c511](https://github.com/kkoomen/vim-doge/commit/da2c511061875218865f07a44d3af04e04f70f1c))
- Add new doge#buffer functions ([8960e0c](https://github.com/kkoomen/vim-doge/commit/8960e0c1b484e2243d118c1893a4617d12278f5c))
- Initial rewrite for all languages ([c67974d](https://github.com/kkoomen/vim-doge/commit/c67974dc630269539cceab8db554fe55250fdfa6))
- Rebase changes from c2f427a v1.17.5 ([880447e](https://github.com/kkoomen/vim-doge/commit/880447e9f1b9bce7f05369583fe30b3a864213ac))
- Rename doge#generate#pattern() -> doge#pattern#generate() ([03c5263](https://github.com/kkoomen/vim-doge/commit/03c5263757afb6f066a4ec2fbf9faa363af5bf51))
- Use doge#buffer#register_doc_standard in all ftplugins ([3312abd](https://github.com/kkoomen/vim-doge/commit/3312abda5cbb106cee193edabf2dd3dcf0d5d919))
- Validate patterns when generating ([27df1d3](https://github.com/kkoomen/vim-doge/commit/27df1d3daaca1cc03ea8369b634d6ce7a308d5b2))

## [1.17.5](https://github.com/kkoomen/vim-doge/compare/v1.17.4...v1.17.5) (2019-12-02)

### Bug Fixes

- **#67:** Allow protected and private function data modifier ([c2f427a](https://github.com/kkoomen/vim-doge/commit/c2f427a0359d847b05c3db1b5e9ca9edc087ff64)), closes [#67](https://github.com/kkoomen/vim-doge/issues/67)

## [1.17.4](https://github.com/kkoomen/vim-doge/compare/v1.17.3...v1.17.4) (2019-12-01)

### Bug Fixes

- **#66:** Remove returnType when the type is void ([25c64d1](https://github.com/kkoomen/vim-doge/commit/25c64d1e521b5448800ad0b6698f320b5037bfbf)), closes [#66](https://github.com/kkoomen/vim-doge/issues/66)

### Features

- Add prefix to tempfile for c-family languages ([e899e51](https://github.com/kkoomen/vim-doge/commit/e899e516502cd74cb77d0e99426d36b9faf3a7bb))
- Remove opencollective funding page ([4fa2c09](https://github.com/kkoomen/vim-doge/commit/4fa2c09aea9556f0be2dbbacca79928816a8120c))

## [1.17.3](https://github.com/kkoomen/vim-doge/compare/v1.17.2...v1.17.3) (2019-11-27)

### Bug Fixes

- **#64:** Support optional parameter indicator for TypeScript class methods ([ca27745](https://github.com/kkoomen/vim-doge/commit/ca27745e8b4f0ea49bd5a0408411687cc88bbdfc)), closes [#64](https://github.com/kkoomen/vim-doge/issues/64)

## [1.17.2](https://github.com/kkoomen/vim-doge/compare/v1.17.1...v1.17.2) (2019-11-26)

### Bug Fixes

- **#62:** Allow public keyword for functions ([bda99bb](https://github.com/kkoomen/vim-doge/commit/bda99bb345d1c212db031cd0630922c3e51b3baa)), closes [#62](https://github.com/kkoomen/vim-doge/issues/62)

## [1.17.1](https://github.com/kkoomen/vim-doge/compare/v1.17.0...v1.17.1) (2019-11-25)

### Bug Fixes

- **#61:** Exclude self, cls and klass from python documentation ([f9db43a](https://github.com/kkoomen/vim-doge/commit/f9db43a05ec34bf0854f0a82d0f8be250642c983)), closes [#61](https://github.com/kkoomen/vim-doge/issues/61)

### Features

- Add BTC donation address ([f458d57](https://github.com/kkoomen/vim-doge/commit/f458d57b977143036c76917e0a7c0dc8e7bdbd6f))

# [1.16.0](https://github.com/kkoomen/vim-doge/compare/v1.15.3...v1.16.0) (2019-11-18)

### Bug Fixes

- breaking tests ([35ca349](https://github.com/kkoomen/vim-doge/commit/35ca3490b0bb74e2b7c18414185078c9cbc49743))

### Features

- **#48:** Support Shell ([8abad34](https://github.com/kkoomen/vim-doge/commit/8abad34d0415db29bbc69dd7b32833d261c1c3db)), closes [#48](https://github.com/kkoomen/vim-doge/issues/48)

## [1.15.3](https://github.com/kkoomen/vim-doge/compare/v1.15.2...v1.15.3) (2019-11-18)

### Bug Fixes

- **#58:** Change logic for jump_forward() and jump_backward() to fix conflict with vim-cool ([cf9ea1d](https://github.com/kkoomen/vim-doge/commit/cf9ea1d8facd1c9ae0612f9b188bb2b97ae56816))

## [1.15.2](https://github.com/kkoomen/vim-doge/compare/v1.15.1...v1.15.2) (2019-11-17)

### Features

- Add g:doge_clang_args configurable option ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([c56c00c](https://github.com/kkoomen/vim-doge/commit/c56c00c29dcc01b5424900e455939df8724fb717))
- Add missing let-keyword ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([6b060a6](https://github.com/kkoomen/vim-doge/commit/6b060a6341c0d774d1a3410eac38d31f5a72d1ea))

## [1.15.1](https://github.com/kkoomen/vim-doge/compare/v1.15.0...v1.15.1) (2019-11-17)

### Bug Fixes

- Create temp file in the same dir as the current active vim buffer ([#57](https://github.com/kkoomen/vim-doge/issues/57)) ([685d8b1](https://github.com/kkoomen/vim-doge/commit/685d8b1bf41fca8abaa6e5654791fe58d479f3c2))
- Move FUNDING.yml to the right location ([b2cdaf8](https://github.com/kkoomen/vim-doge/commit/b2cdaf8dc4e4c968fe9dd11b74feb001c9de87a5))
- Typo of old v0.3, updated this to v0.4 ([6cb70ac](https://github.com/kkoomen/vim-doge/commit/6cb70ac01ef837dab8972780890127ae94a0604d))

### Features

- Add FUNDING.yml ([175e512](https://github.com/kkoomen/vim-doge/commit/175e512500771b4a6254a1573264184f0880df13))
- **ISSUE_TEMPLATE:** Update bug_report template ([317ef1d](https://github.com/kkoomen/vim-doge/commit/317ef1d695fecfa9f303d90b02c93dc0ee620794))
- Update travis.yml with new NeoVim v0.4 ([0961db5](https://github.com/kkoomen/vim-doge/commit/0961db5993913e54030cd22170a05ab84806ed4c))
- **docker:** Upgrade Vim v8.1.2000 -> v8.1.2300 and NeoVim v0.3.8 -> v0.4.3 ([dac31f8](https://github.com/kkoomen/vim-doge/commit/dac31f888c2aed0078cb421224737e014f540f27))

# [1.15.0](https://github.com/kkoomen/vim-doge/compare/v1.14.1...v1.15.0) (2019-11-16)

### Bug Fixes

- Adjust check for py3file issue for Vim v7.4.2119 ([ded59fb](https://github.com/kkoomen/vim-doge/commit/ded59fb35ea4bfe477e2f8049031d7ee7991e7f8))
- Change name property to funcName in libclang.py ([b682fb5](https://github.com/kkoomen/vim-doge/commit/b682fb5f3a70da945b621d97e777b9f2e82ffa2f))
- failing test ([98eb5c8](https://github.com/kkoomen/vim-doge/commit/98eb5c8db3947c16f8b923d02a6d32ac9481e14c))
- Get return type in right way; Resolve failing tests ([d8e5356](https://github.com/kkoomen/vim-doge/commit/d8e53562cb9444772dc89f3f413f0bf17b193055))
- javascript tests ([9c123af](https://github.com/kkoomen/vim-doge/commit/9c123af80553efa05db4dd5f0e6a9b3c15797714))
- linter issues ([70ec33b](https://github.com/kkoomen/vim-doge/commit/70ec33bd5b58dd430619fd36942109293620085a))
- merge conflict feature/clang-c <-- feature/clang ([c4e74c1](https://github.com/kkoomen/vim-doge/commit/c4e74c16b5c8d87fd2cc1207d6091ff08e2147c6))
- py3file error for Vim v7.4.2119 ([a3e94d7](https://github.com/kkoomen/vim-doge/commit/a3e94d71852dc4b3a08dd34f8fead407e163c005))
- Set corrects paths for tests ([54618ad](https://github.com/kkoomen/vim-doge/commit/54618ad62d724d9a25620c1bdcd80a65489299f3))

### Features

- Add class-template and struct-template tests; Add support for virtual-functions ([e70bd5d](https://github.com/kkoomen/vim-doge/commit/e70bd5d08385c1d9bab776485f37c4efe9a99616))
- Add initial working version ([cd935f6](https://github.com/kkoomen/vim-doge/commit/cd935f6f3a36bce0117f4d04534bbc3becb0a0ae))
- Add more doxygen docblock styles ([f340b6c](https://github.com/kkoomen/vim-doge/commit/f340b6c56c3407f0230ddb9e6ffeddada57dcea6))
- Add stable support for C; Optimise C++ cases ([6261f15](https://github.com/kkoomen/vim-doge/commit/6261f15934ed1b3283c7e0a8b47d6bc5770ac97c))
- Optimise docker for clang develpoment; Add basic function tests ([3317f32](https://github.com/kkoomen/vim-doge/commit/3317f32fe50b401ad393e79a653fa5ff8afb0430))
- Setup basic support for C ([f08c35d](https://github.com/kkoomen/vim-doge/commit/f08c35d4cbcdf56bfcc19e5c6aae5d59e4e4da7f))
- Update vim-testbed which fixed 7.4.2119 python build failing; Add expected docblocks in playground ([2795e9c](https://github.com/kkoomen/vim-doge/commit/2795e9c4f71e8f58b95f81a6d961c7d9db50a4dd))
- **generator:libclang.py:** Remove unused function ([64e1692](https://github.com/kkoomen/vim-doge/commit/64e16922b0eafc52e116aa9d9d625b3a2d279136))

## [1.14.1](https://github.com/kkoomen/vim-doge/compare/v1.14.0...v1.14.1) (2019-10-25)

### Bug Fixes

- **#54:** Allow export keyword in front of variables ([507425b](https://github.com/kkoomen/vim-doge/commit/507425bc6c689005336d47a93b77f9e93f9417b2)), closes [#54](https://github.com/kkoomen/vim-doge/issues/54)

# [1.14.0](https://github.com/kkoomen/vim-doge/compare/v1.13.1...v1.14.0) (2019-10-24)

### Bug Fixes

- **#54:** Optimise incorrect javascript/typescript patterns ([d10e62b](https://github.com/kkoomen/vim-doge/commit/d10e62b38bae97cc822254eaf5268437ed77062b)), closes [#54](https://github.com/kkoomen/vim-doge/issues/54)
- check for todo count inside TextChanged/InsertLeave autocmd func ([2879331](https://github.com/kkoomen/vim-doge/commit/28793312312d51e437ad71d80224f2b0c0a31f7a))
- Revert back to 2b5a17d ([3b3ed40](https://github.com/kkoomen/vim-doge/commit/3b3ed40c143185ed27d6250a7f248acb8fe0a9db))
- **#50:** Update helptags; Adjust option description; Add new option to README ([143597c](https://github.com/kkoomen/vim-doge/commit/143597c4a790eecf8a7ffe74dd19004943c8dd3b)), closes [#50](https://github.com/kkoomen/vim-doge/issues/50)

### Features

- Simplify code and update docs ([1743fe3](https://github.com/kkoomen/vim-doge/commit/1743fe36361bd953cab8cfbf5aa328208ad8a6de))
- Update php playground generated scenario ([eb0157d](https://github.com/kkoomen/vim-doge/commit/eb0157ddc0454aa3d00fb631aec2168f7e9234f8))

# [1.13.0](https://github.com/kkoomen/vim-doge/compare/v1.12.0...v1.13.0) (2019-09-11)

### Bug Fixes

- incorrect logical operator for version check ([b80bfbb](https://github.com/kkoomen/vim-doge/commit/b80bfbbf9b85c050cc6593d517cafcb3a7dd91ff))
- Incorrect patch version ([3bcc337](https://github.com/kkoomen/vim-doge/commit/3bcc3371d4bf0632c540d9c38284d8ddbe2c7a4b))
- Incorrect path version ([1703e00](https://github.com/kkoomen/vim-doge/commit/1703e00d91e6727a35bb18b4e531f5b4eb3e9ce0))
- Remove duplicate content ([c76a745](https://github.com/kkoomen/vim-doge/commit/c76a7457c3ecbb6c35ad7f7c72024664fddd91bd))
- Remove unnecessary == v:true check ([866abd4](https://github.com/kkoomen/vim-doge/commit/866abd41a52ad3c5f356fd8d6d07f677790a2d01))
- Shorten version check condition ([e123c82](https://github.com/kkoomen/vim-doge/commit/e123c82ebaa7a79876d6aa0487c3ecf75d5e1d5a))
- Simplify wrapping logic ([86e231a](https://github.com/kkoomen/vim-doge/commit/86e231ac454715492000e069eac21b35116c73a3))
- Update broken version checks ([66e3251](https://github.com/kkoomen/vim-doge/commit/66e3251e2935e267d8e6841fc8f71155374a235f))
- Update incorrect version for unsupported vim version ([14e4ce5](https://github.com/kkoomen/vim-doge/commit/14e4ce5cb1f764934b53ae532e0bc4f8567727ee))
- Use correct l: and s: scope; Put s:no_trim outside of function ([c9eb506](https://github.com/kkoomen/vim-doge/commit/c9eb506edc8e42d640fb77ad50bb7de9e235b5a4))

### Features

- Add g:doge_comment_jump_wrap backwards jumping tests ([d2e2abb](https://github.com/kkoomen/vim-doge/commit/d2e2abbf1ca6bd7350182ca4642cde85a4579536))
- Add release badge ([1092f88](https://github.com/kkoomen/vim-doge/commit/1092f88a6e0d63ea62421fff5e6d67337e53665c))
- Add tests ([f0971a3](https://github.com/kkoomen/vim-doge/commit/f0971a3e9e460d16b8f56b657ab6dcfdeb3170dd))
- Add tests ([010edaf](https://github.com/kkoomen/vim-doge/commit/010edaf5bdb3c1f39e946d320ffa29fdbd54b1b4))
- Enable continues cycling with surrounding TODOs ([1321811](https://github.com/kkoomen/vim-doge/commit/13218110163009e947a9af699541b0d0a0725471))
- Ensure correct regex interpretation by enforcing magic ([64cb9f8](https://github.com/kkoomen/vim-doge/commit/64cb9f8397b2c3f8c516fb1790b43106b71bc03e))
- Ensure search starts from the beginning of the line ([7241a29](https://github.com/kkoomen/vim-doge/commit/7241a2985d0eccce463b40ac9544025e5b60a6f2))
- **README:** Add missing g:doge_buffer_mappings section ([50c1c76](https://github.com/kkoomen/vim-doge/commit/50c1c760c6786b10086c44b60ef8c794fb37032f))
- Ensure correct regex interpretation by enforcing magic ([5631741](https://github.com/kkoomen/vim-doge/commit/56317415e44ea594459872cac87d071c9b265042))
- Follow coding standards; adjust incorrect version check; optimise mappings ([20333b0](https://github.com/kkoomen/vim-doge/commit/20333b0b15ef0b2871da151cf3306ada987b6cbc))
- Order Vim versions ascending ([bc87f64](https://github.com/kkoomen/vim-doge/commit/bc87f64d216206b9e12d334ba3c3ce86427b291a))
- Update doc/doge.txt; Optimise version compatibility check ([bf8296c](https://github.com/kkoomen/vim-doge/commit/bf8296cebb9d05d27391ee42a44535a3bc253cc7))
- Update minimum supported versions for Travis & docs ([1a52360](https://github.com/kkoomen/vim-doge/commit/1a5236099ee1ed898a18239730e68f8c027bf6fb))
- Update travis.yml to run for Vim 8.0 ([a7ca880](https://github.com/kkoomen/vim-doge/commit/a7ca8807b5a6bcdf16cfdd23ba49e538936ec30c))
- Use variable for duplicate regex chars ([453b12b](https://github.com/kkoomen/vim-doge/commit/453b12b529e37857532ae0bd1aabab0c2b776a91))
- Use variable for duplicate regex chars ([399a615](https://github.com/kkoomen/vim-doge/commit/399a6155c44a37d4a96d7c921dc44436b11dbae1))

## [1.11.2](https://github.com/kkoomen/vim-doge/compare/v1.11.1...v1.11.2) (2019-08-26)

### Bug Fixes

- **#37:** Allow generation for Java body-less method declarations ([f0169c0](https://github.com/kkoomen/vim-doge/commit/f0169c09a353748df021cb7df0d294d7740b121e)), closes [#37](https://github.com/kkoomen/vim-doge/issues/37)
- **#38:** Remove parameter type hints in Java methods in generated docs ([a095438](https://github.com/kkoomen/vim-doge/commit/a095438f51871a98612b10a519da79e87b8f9144)), closes [#38](https://github.com/kkoomen/vim-doge/issues/38)

### Features

- Update php playground examples ([2fdd869](https://github.com/kkoomen/vim-doge/commit/2fdd86981b54a57dfedba2133bd318663566b3cc))

## [1.11.1](https://github.com/kkoomen/vim-doge/compare/v1.11.0...v1.11.1) (2019-07-30)

### Bug Fixes

- **php:** Add TODO context for class properties including missing tests ([9b5bbae](https://github.com/kkoomen/vim-doge/commit/9b5bbaebf374f685958616f705af7e2ad4270a39))
- Prevent using <Plug> to redraw buffer correctly ([a1ce619](https://github.com/kkoomen/vim-doge/commit/a1ce6191e927d51a0f38ab33d7b0396215a18b9b))

### Features

- Adjust DogeGenerate command declaration ([a47e59a](https://github.com/kkoomen/vim-doge/commit/a47e59a8bea24375c69a57e92ae12131f98644d8))

## [1.9.3](https://github.com/kkoomen/vim-doge/compare/v1.9.2...v1.9.3) (2019-07-28)

### Bug Fixes

- **python:** Allow whitespace before the colon when using type hints ([d403bcd](https://github.com/kkoomen/vim-doge/commit/d403bcda809749d564abd83a9d041cc3ddb157c6))

## [1.9.2](https://github.com/kkoomen/vim-doge/compare/v1.9.1...v1.9.2) (2019-07-28)

### Features

- **#31:** Filter out the self parameter in Python methods ([7087d68](https://github.com/kkoomen/vim-doge/commit/7087d689b432ddad7c9370270048882f982c8358)), closes [#31](https://github.com/kkoomen/vim-doge/issues/31)

## [1.9.1](https://github.com/kkoomen/vim-doge/compare/v1.9.0...v1.9.1) (2019-07-28)

### Bug Fixes

- **#30:** Prevent indenting when empty line ([ce62c8e](https://github.com/kkoomen/vim-doge/commit/ce62c8ea391a3b88d2dc40f34f4f31920833d653)), closes [#30](https://github.com/kkoomen/vim-doge/issues/30)

# [1.9.0](https://github.com/kkoomen/vim-doge/compare/v1.8.2...v1.9.0) (2019-07-26)

### Features

- **javascript:** Support class properties ([a55b24f](https://github.com/kkoomen/vim-doge/commit/a55b24fc0c3b959d516fceffecf10026c94ef9aa))

## [1.8.2](https://github.com/kkoomen/vim-doge/compare/v1.8.1...v1.8.2) (2019-07-26)

### Bug Fixes

- **javascript:** Remove additional whiteline after main function description ([45eddac](https://github.com/kkoomen/vim-doge/commit/45eddac466da6b73353d34d71667a0dde185e7c3))

## [1.8.1](https://github.com/kkoomen/vim-doge/compare/v1.8.0...v1.8.1) (2019-07-26)

### Bug Fixes

- **php:** Use correct phpdoc description format ([33ed53b](https://github.com/kkoomen/vim-doge/commit/33ed53b2b5942d7fba0a73c3e3f493e8db0b5285))

# [1.8.0](https://github.com/kkoomen/vim-doge/compare/v1.7.0...v1.8.0) (2019-07-24)

### Features

- Implement [@return](https://github.com/return) tag for PHP; Adjust conditional token format to ensure correct parsing ([af43f96](https://github.com/kkoomen/vim-doge/commit/af43f9648887bcf7087e314be5e27fc43e63a983))

# [1.7.0](https://github.com/kkoomen/vim-doge/compare/v1.6.1...v1.7.0) (2019-07-23)

### Features

- **javascript:** Add pattern for functions inside objects ([718cada](https://github.com/kkoomen/vim-doge/commit/718cada4fb9ab571bd91c191b06efe3e42c19390))

## [1.6.1](https://github.com/kkoomen/vim-doge/compare/v1.6.0...v1.6.1) (2019-07-22)

### Bug Fixes

- **cpp:** Change kotline -> c++ in error message ([7ee3ec6](https://github.com/kkoomen/vim-doge/commit/7ee3ec6d4d27c268b0ec23827e62922432077ec4))

### Features

- **cpp:** Check for 0 or more occurences in the regex pattern instead of making it optional ([e69ea80](https://github.com/kkoomen/vim-doge/commit/e69ea80e43f634c430e6137859e8173cfebffa41))
- **cpp:** Use TODO context placeholder instead of raw context ([f391791](https://github.com/kkoomen/vim-doge/commit/f391791dc8e3fd7e8a96dcc4091f18266cfc72b1))

# [1.6.0](https://github.com/kkoomen/vim-doge/compare/v1.5.3...v1.6.0) (2019-07-21)

### Bug Fixes

- Adjust tests to be correct; remove additional # in [@examples](https://github.com/examples) tag ([ca21fea](https://github.com/kkoomen/vim-doge/commit/ca21fea02ebe4a813b03e1b2921ee982849937d6))
- Change TODO in [TODO:description] for doge_comment_interactive option test ([54a2626](https://github.com/kkoomen/vim-doge/commit/54a2626b0df1763ae9fc106d05edbd398009d252))
- Exclude tab chars by adjusting the regex in doge#token#replace ([1290981](https://github.com/kkoomen/vim-doge/commit/1290981dced85ea706fcc541444ed5797cb7716f))

### Features

- Remove scala demo ([3310584](https://github.com/kkoomen/vim-doge/commit/331058484743394d3fb06849698d8b14144550de))
- Update demo README ([4fed02b](https://github.com/kkoomen/vim-doge/commit/4fed02bc36389bfa7881376e1fdd33f4f16f1133))
- **CONTRIBUTING.md:** Update ToC ([20ce496](https://github.com/kkoomen/vim-doge/commit/20ce4961ed934f3968dc59a82d59362f79fce3e4))
- **javascript:** Change TODO to !description ([7d247b5](https://github.com/kkoomen/vim-doge/commit/7d247b5d27636a43d8f6cfdb09753759deba8637))
- Add .editorconfig ([e6c12e4](https://github.com/kkoomen/vim-doge/commit/e6c12e44bf7921dfa2dcb4a931637b37273040f1))
- Add .editorconfig ([9bfa350](https://github.com/kkoomen/vim-doge/commit/9bfa350ee48010cad5f7612f793d8611790411c0))
- Add TODO contexts for every language by adding the new !<context> placeholder ([5360d9a](https://github.com/kkoomen/vim-doge/commit/5360d9ac64cb3098b7b3d9d58925fe9e2555853e))
- Update playground generations for all languages ([bb31964](https://github.com/kkoomen/vim-doge/commit/bb31964ca028c340b6660ad42d65d81f106ca819))
- Update python, js and php patterns by adding TODO context ([196df07](https://github.com/kkoomen/vim-doge/commit/196df07fc8006e8a6f699bac59dd172f06e662f4))
- Use new demos from asciinema ([304b104](https://github.com/kkoomen/vim-doge/commit/304b104d41b96d25ded69e01b8b5b6c5672fe06d))
- **python:** Add more TODO context ([70cf0d2](https://github.com/kkoomen/vim-doge/commit/70cf0d29245dd82bddfa422c73e4f0548d923d32))

## [1.5.2](https://github.com/kkoomen/vim-doge/compare/v1.5.1...v1.5.2) (2019-07-20)

### Bug Fixes

- **#26:** Allow colon inside C++ angle bracket notation in the return type ([83df9d1](https://github.com/kkoomen/vim-doge/commit/83df9d1d17c2cecd57968f3355d6b9e1b2079a93)), closes [#26](https://github.com/kkoomen/vim-doge/issues/26)
- Adjust typos in tests ([12c0df0](https://github.com/kkoomen/vim-doge/commit/12c0df02d18461a90c947aed2fe0003e66fa064a))
- Update functions-doc-google tests for return type ([f539f52](https://github.com/kkoomen/vim-doge/commit/f539f5260334aa7fd5cf3b72be20ba066ccbfb18))

### Features

- Remove url hash id to match 80 columns ([6a4ef14](https://github.com/kkoomen/vim-doge/commit/6a4ef1478d35dbe97cf9029bb0bd4105910f37d1))
- **CONTRIBUTING.md:** Add doc-standard section ([e2ef9b7](https://github.com/kkoomen/vim-doge/commit/e2ef9b7d20f88453d89021e3096d1e126080cd30))
- Add missing Google doc standard in ftplugin root description ([c8dd2a4](https://github.com/kkoomen/vim-doge/commit/c8dd2a4d3bd63c246276f21d43138799e5100cad))

## [1.4.7](https://github.com/kkoomen/vim-doge/compare/v1.4.6...v1.4.7) (2019-07-19)

### Bug Fixes

- **#20:** Use start of docblock for the description instead of [@description](https://github.com/description) tag for javascript/typescript ([1ab5871](https://github.com/kkoomen/vim-doge/commit/1ab5871e91e3d4bd543fa8d71ee63f8061cb37ad)), closes [#20](https://github.com/kkoomen/vim-doge/issues/20)

### Features

- Add new issue template for languages ([7578b95](https://github.com/kkoomen/vim-doge/commit/7578b95c4e68cdc44938c99a2c6fff5763da73e6))

## [1.4.6](https://github.com/kkoomen/vim-doge/compare/v1.4.5...v1.4.6) (2019-07-19)

### Bug Fixes

- **#17:** Add & in cpp function regex var name to match a specific case ([e874cc3](https://github.com/kkoomen/vim-doge/commit/e874cc32f2974272f67766380cb74631f09dc727)), closes [#17](https://github.com/kkoomen/vim-doge/issues/17)

## [1.4.5](https://github.com/kkoomen/vim-doge/compare/v1.4.4...v1.4.5) (2019-07-18)

### Bug Fixes

- **#14:** Allow dot-characters in python parameter type hint ([93d9e1f](https://github.com/kkoomen/vim-doge/commit/93d9e1fb502542f7419d35c6fdb43cf2d6d83c65)), closes [#14](https://github.com/kkoomen/vim-doge/issues/14)

## [1.4.4](https://github.com/kkoomen/vim-doge/compare/v1.4.3...v1.4.4) (2019-07-18)

### Bug Fixes

- **#9:** Preprocess indent position for python for inserting below declaration and adjust preprocess order ([8cb1876](https://github.com/kkoomen/vim-doge/commit/8cb1876e6aff9d15043cef032813ded313cdecba)), closes [#9](https://github.com/kkoomen/vim-doge/issues/9)

## [1.4.3](https://github.com/kkoomen/vim-doge/compare/v1.4.2...v1.4.3) (2019-07-18)

### Bug Fixes

- Set correct has(nvim-0.3.2) ([7efa503](https://github.com/kkoomen/vim-doge/commit/7efa503fb140e40a89b2e0a79bfdbe1db938b0b6))
- **#12:** Optimise plugin root check to allow nvim 0.3.2+ ([9d0a36e](https://github.com/kkoomen/vim-doge/commit/9d0a36e357800707c9befacdeec694643c59b4e7)), closes [#12](https://github.com/kkoomen/vim-doge/issues/12)

## [1.4.2](https://github.com/kkoomen/vim-doge/compare/v1.4.1...v1.4.2) (2019-07-18)

### Bug Fixes

- **#4:** Remove <unique> to fix mapping-already-exists error ([9d6f686](https://github.com/kkoomen/vim-doge/commit/9d6f6867f87725be310323c1525f350b6d4bf291))

## [1.4.1](https://github.com/kkoomen/vim-doge/compare/v1.4.0...v1.4.1) (2019-07-18)

### Bug Fixes

- Do not display error msg when no generation can be done ([aaaccc4](https://github.com/kkoomen/vim-doge/commit/aaaccc492daa5b15b022cf09f2350c26d4a254a4))

# [1.4.0](https://github.com/kkoomen/vim-doge/compare/v1.3.2...v1.4.0) (2019-07-18)

### Features

- Support TODO contexts ([28413b9](https://github.com/kkoomen/vim-doge/commit/28413b935853e93b2dcdfb09d42a736c3cb0923a))
- Use global script variable for doge#helpers#placeholder ([1b1d88f](https://github.com/kkoomen/vim-doge/commit/1b1d88f9393be3fa481a0eb32f649d44f8839b64))
- **ISSUE_TEMPLATE:** Add settings-section and improve the description-section ([655a00d](https://github.com/kkoomen/vim-doge/commit/655a00d561026438ad10e98abdad4cd2274371db))

## [1.3.2](https://github.com/kkoomen/vim-doge/compare/v1.3.1...v1.3.2) (2019-07-17)

### Features

- Change default g:doge_mapping to <Leader>d instead of <C-d> ([873bf1f](https://github.com/kkoomen/vim-doge/commit/873bf1f8eda03006e869ae6c54181c47a4ec007b))
- **playground:** Regenerate the expected results ([1bc5297](https://github.com/kkoomen/vim-doge/commit/1bc5297246ebd987ae12f0e6d18c02130937db28))

# [1.3.0](https://github.com/kkoomen/vim-doge/compare/v1.2.3...v1.3.0) (2019-07-12)

### Features

- **python:** Add 'optional' keyword in type hint (issue [#6](https://github.com/kkoomen/vim-doge/issues/6)) ([5db4a61](https://github.com/kkoomen/vim-doge/commit/5db4a61ba939527cf19fc52403b6a6e0856fac80))
- **python:** Add support for Google doc standard (issue [#6](https://github.com/kkoomen/vim-doge/issues/6)) ([336460e](https://github.com/kkoomen/vim-doge/commit/336460e0e85eb40c10519197012ad8a4712731f0))
- **python:** Add support for type hints within comments (issue [#6](https://github.com/kkoomen/vim-doge/issues/6)) ([2b4cacb](https://github.com/kkoomen/vim-doge/commit/2b4cacbaa9aa0ca78a44b59e9a8131010fa00d6f))
- **python:** Split up tests for numpy doc ([5a89b6d](https://github.com/kkoomen/vim-doge/commit/5a89b6d79633a343397ed9ba887086f45c05036c))
- **python:** Update functions-doc-numpy test descriptions ([d647476](https://github.com/kkoomen/vim-doge/commit/d647476cee94df8fe6cf97d9cdc75326c639106c))
- Link to demos folder instead of README ([8a17071](https://github.com/kkoomen/vim-doge/commit/8a1707178a75f46f64aa4e22bbae2df1233ae50f))
- Update doc_standard.md issue template ([8182ab3](https://github.com/kkoomen/vim-doge/commit/8182ab3a74b22969ddf4e4c1ede3a735e4c5c5a7))

## [1.2.3](https://github.com/kkoomen/vim-doge/compare/v1.2.2...v1.2.3) (2019-07-10)

### Bug Fixes

- **cpp:** Prevent [@return](https://github.com/return) tag to be added when returning void (issue [#5](https://github.com/kkoomen/vim-doge/issues/5)) ([ec4fdd9](https://github.com/kkoomen/vim-doge/commit/ec4fdd924f1757bdecd6ab38e23e0e336f119814))
- Adjust broken test for the python numpy doc ([1a0dd2e](https://github.com/kkoomen/vim-doge/commit/1a0dd2e742b70a7f133844d8ad720b9c2b86a0ad))

## [1.2.1](https://github.com/kkoomen/vim-doge/compare/v1.2.0...v1.2.1) (2019-06-28)

### Features

- **cpp:** Support declarations and add support for advanced function syntax ([#2](https://github.com/kkoomen/vim-doge/issues/2)) ([fae8dbe](https://github.com/kkoomen/vim-doge/commit/fae8dbe8943851d2d42deef0722d223c80bdfee4))

# [1.2.0](https://github.com/kkoomen/vim-doge/compare/v1.1.0...v1.2.0) (2019-06-27)

### Features

- Add initial C++ version ([94f8c74](https://github.com/kkoomen/vim-doge/commit/94f8c7418409a8c6cd02af6f8f4ade4eb85072a0))
- Add support for C++ including tests (issue [#2](https://github.com/kkoomen/vim-doge/issues/2)) ([277c36f](https://github.com/kkoomen/vim-doge/commit/277c36f5c29e457e93a9199f1c4bdfacd67ba6e1))

# [1.1.0](https://github.com/kkoomen/vim-doge/compare/v1.0.0...v1.1.0) (2019-06-27)

### Features

- Delete demos ([edbca0e](https://github.com/kkoomen/vim-doge/commit/edbca0e2aac49c6a01511a281c4fac183066b113))
- Prefix every parameter token line with ! markup ([84d10c1](https://github.com/kkoomen/vim-doge/commit/84d10c1c4e163d5ea317233a892effa451f3b43c))
- re-add demo gifs ([51a1618](https://github.com/kkoomen/vim-doge/commit/51a16186e213e7cdb37a188f3d5ab6a7a1bf1beb))
- re-add demo gifs ([be862a8](https://github.com/kkoomen/vim-doge/commit/be862a82bba9e0ac6f12d057b0aaf5b3d5af8a7d))
- Re-add demos ([f5fbd26](https://github.com/kkoomen/vim-doge/commit/f5fbd26d4d3866d1495c238e8968c81f8950689a))
- Remove demo gifs ([c033a49](https://github.com/kkoomen/vim-doge/commit/c033a4982e355bfa2609dce81c57f73fb176170d))
- Strip comments before generating to ensure patterns do not break ([12cc8da](https://github.com/kkoomen/vim-doge/commit/12cc8dab024c6641052fe6e28ae97d547a783a59))
- Support multiple doc standard (feature issue [#3](https://github.com/kkoomen/vim-doge/issues/3)) ([cda039c](https://github.com/kkoomen/vim-doge/commit/cda039c1e1e4750c40f336ffc6d83d30f5720d6b))

# [1.0.0](https://github.com/kkoomen/vim-doge/compare/da2df41ff188e4391f703ebd5aeb4ab9c0b30628...v1.0.0) (2019-06-24)

### Bug Fixes

- Add missing \s\* in regex ([764f705](https://github.com/kkoomen/vim-doge/commit/764f705e25a462877fd73116fa926f94463bfd68))
- Add missing abort after doge#helpers#count function ([793ef26](https://github.com/kkoomen/vim-doge/commit/793ef26454ca52a32ae0de98472e8e39be5ec0ea))
- Add missing abort attribute for s:uppercase helper function ([871acbc](https://github.com/kkoomen/vim-doge/commit/871acbc776a75dd803192d556f71fec24f7eece9))
- Adjust links from old repo ([bb6909d](https://github.com/kkoomen/vim-doge/commit/bb6909d0c09d4cbdb5dcf89629dec4f41ab70072))
- Remove <buffer> in mapping ([13bcdb6](https://github.com/kkoomen/vim-doge/commit/13bcdb6a4a9f18aaf5c7a94b5e64430f2dcdce9d))
- Replace \s*|\s* rather then " | " ([a08dab2](https://github.com/kkoomen/vim-doge/commit/a08dab25f839e83b9b0ada310f5c7046e27701aa))
- Set correct assertion expected value for g:doge_comment_interactive test ([2956ff5](https://github.com/kkoomen/vim-doge/commit/2956ff5dbeeef8ddecdaef62b956e44b0040d60d))
- Set correct option flag for travis and correct bash variable for run-tests script when pulling docker image ([b80b262](https://github.com/kkoomen/vim-doge/commit/b80b2621712e762143cd7346d82e62a0ff592f96))
- Use > operator instead of >= to fix incorrect calculation for Scala ([0e44b6b](https://github.com/kkoomen/vim-doge/commit/0e44b6b260141bb2d2fd60df7f9df2ab8dc86014))
- **README:** Add missing ) characters ([bd4ef9d](https://github.com/kkoomen/vim-doge/commit/bd4ef9dc0d36f54b5a21733e987c9dac7f3c7aa7))
- **README:** Correct repo naming in getting-started ([f41c911](https://github.com/kkoomen/vim-doge/commit/f41c9118289e04bddda5ec535381166126f4ad99))
- **README:** Replace gfi with doge ([f7f512a](https://github.com/kkoomen/vim-doge/commit/f7f512ae324f6b9da266b56c260468e6dcb7a485))
- **README:** Use bold markdown rather then emphasized text ([3459abb](https://github.com/kkoomen/vim-doge/commit/3459abb90336c598385b2360c7d0ae1dfb099258))

### Features

- Update banner ([ab550c1](https://github.com/kkoomen/vim-doge/commit/ab550c1991bd5320c9869bc31ce7d3dd59ebfd40))
- **tests:** Add another test case to the doge_comment_interactive setting ([4aa0749](https://github.com/kkoomen/vim-doge/commit/4aa07495eb49558df044ea59d9aa76fe04a76099))
- Add correct markdown ([7f61510](https://github.com/kkoomen/vim-doge/commit/7f61510bb54a1039be9c2998f756159cae368295))
- Add DoGe banner ([ff53ed8](https://github.com/kkoomen/vim-doge/commit/ff53ed856319e7d36cd1d8165eee68b48b71aa45))
- Add g:doge_comment_todo_suffix option and logic to remove TODO in params ([936a274](https://github.com/kkoomen/vim-doge/commit/936a274574f84d351764e2cd864fcfc97c42bc87))
- Add license from w0rp/ale for bash test scripts ([5265b4b](https://github.com/kkoomen/vim-doge/commit/5265b4b53bda628adaf012e47ef42979cb2304de))
- Add neovim 0.3.2+ support; Add fancy badges to README ([e3b6f57](https://github.com/kkoomen/vim-doge/commit/e3b6f575dfc609d1cde6f73dbc6d77400eaa0728))
- Add preprocess function doge#preprocessors#<filetype>#insert_position() for Java and Groovy ([569223b](https://github.com/kkoomen/vim-doge/commit/569223bdcf5652907f6fd5a4ea42590f3e9121a3))
- Add quicklinks for users to quickly add a bug report of feature request ([2c1ed94](https://github.com/kkoomen/vim-doge/commit/2c1ed94abd4395b10f436ae1f0e6188434c09b22))
- Add README.md in the playground/ directory rather then inline comments ([3280e0f](https://github.com/kkoomen/vim-doge/commit/3280e0f0192006014ff54315a87bf6afe190f9fb))
- Add scala tests ([78eaa10](https://github.com/kkoomen/vim-doge/commit/78eaa1026a885357a8b6f7e445bcef2f6f21fb1b))
- Add support for Groovy by inhering Java logic ([798bf38](https://github.com/kkoomen/vim-doge/commit/798bf38cc10009377b19ebfb9b67a8bad81d77ba))
- Add support for interactive comments insert below ([94b3f59](https://github.com/kkoomen/vim-doge/commit/94b3f593289ae81b3b0c7824f1adc5398c80d9f1))
- Add support for kotlin ([d3dd35c](https://github.com/kkoomen/vim-doge/commit/d3dd35c7a0c7c2650c8151f268e3e2b18d5706b6))
- Add tests for coffee script ([a820f85](https://github.com/kkoomen/vim-doge/commit/a820f8555e6fca0db0edc5a36ca5193f73ba4765))
- Add tests for java ([c7eda6f](https://github.com/kkoomen/vim-doge/commit/c7eda6feb6ded85ff7b9bb3629d7df4c8957de1e))
- Add tests for setting g:doge_comment_interactive ([b30461e](https://github.com/kkoomen/vim-doge/commit/b30461e84d8bd2e71700a285626c7f714b750588))
- Change "- TODO" in "TODO" ([8a58aeb](https://github.com/kkoomen/vim-doge/commit/8a58aebbb5016c8ef3f4e0546a17ee419f0b6619))
- Change test name type from "tags" -> "tag" ([eab77b3](https://github.com/kkoomen/vim-doge/commit/eab77b35e281454d98ae5ca1f29053862ba0d026))
- Convert &filetype to uppercase for the user prompts ([e405e12](https://github.com/kkoomen/vim-doge/commit/e405e122f05c5fbee48537413328872dfb151e5f))
- Disable g:doge_comment_interactive to prevent tests from breaking ([f27dfae](https://github.com/kkoomen/vim-doge/commit/f27dfae950b4511457466f765570c7ac5d505e4d))
- Document doge#helpers#count function ([1c0ffca](https://github.com/kkoomen/vim-doge/commit/1c0ffcaeb7f797d144aeaf0f026bcd9186654cf4))
- Fix broken tests by reset the option g:doge_comment_todo_suffix after it has been used ([21c603e](https://github.com/kkoomen/vim-doge/commit/21c603ed9db400ea40f4d5eac0dd99b1ab2953ea))
- Fix linting errors ([7901b80](https://github.com/kkoomen/vim-doge/commit/7901b80705050531c109ae8e7d73a6f4093490a3))
- Implement basic working version of todo-jumping functionality ([c68aaee](https://github.com/kkoomen/vim-doge/commit/c68aaee147f7ef2fdd7fcb808642414c9dbf29fc))
- Implement support for R including tests ([121e7de](https://github.com/kkoomen/vim-doge/commit/121e7deb573e36d6fadcda4cbec5d7a7dae62e51))
- Implement tests for js,jsx,typescript,tsx ([93a7c9c](https://github.com/kkoomen/vim-doge/commit/93a7c9c2668c2005cfd7f6a619d622079321bf6f))
- Optimise banner in size and quality ([c440940](https://github.com/kkoomen/vim-doge/commit/c44094038cf0aa0c5b6dc0f3de9b01d6aac7cdaf))
- Optimise ISSUE_TEMPLATE files along with the plugin messages ([9a4f2ec](https://github.com/kkoomen/vim-doge/commit/9a4f2ecb2ccca381a241d3de21cfc705544bd6c4))
- Optimise jumping logic to a stable version ([d30c404](https://github.com/kkoomen/vim-doge/commit/d30c404d2e94fcd895bcf02a483e545e6f9442b7))
- Optimise PHP function parameter regex ([cec1cb8](https://github.com/kkoomen/vim-doge/commit/cec1cb81b95020b81934d048b7ac528abf984a41))
- Optimise the comment jump logic ([64b183e](https://github.com/kkoomen/vim-doge/commit/64b183ee62c64915aa2ff039207d13d9b24b6ac4))
- Remove unnecessary Given statement in test and remove duplicate test ([b99b818](https://github.com/kkoomen/vim-doge/commit/b99b81851c51a8e209f8e49c4ce3f66910ffb69b))
- Use a separate key for each token ([179130d](https://github.com/kkoomen/vim-doge/commit/179130df39baf4d468f3479e32fa0348bbb53941))
- **tests:** Add a python scenario for g:doge_comment_interactive to below-comments ([082acf2](https://github.com/kkoomen/vim-doge/commit/082acf2850e369f1f11c9af43998c0249b9fc395))
- Remove duplicate comment in php playground ([d3712e6](https://github.com/kkoomen/vim-doge/commit/d3712e64f99d98f839f0ba14769891cc19724d05))
- Rename arg to p as an abbr of param ([35b3249](https://github.com/kkoomen/vim-doge/commit/35b3249a1c679a7dc323349fe15b2b6d4dd2e660))
- Set g:doge_comment_todo_suffix back to 1 by default ([201354f](https://github.com/kkoomen/vim-doge/commit/201354f5dafc6ca4a2d34e010882955e1001e6e4))
- Support vim 8.0.1630+ from now on ([3058c14](https://github.com/kkoomen/vim-doge/commit/3058c14a9634b91b57fb313f06f1667f5957109c))
- Update markdown table for the language overview ([c5eb458](https://github.com/kkoomen/vim-doge/commit/c5eb458646e550cb8a18527573dfd64f9dc3520a))
- Update vimrc for test environment ([41d8223](https://github.com/kkoomen/vim-doge/commit/41d8223fd3dbf2bc868c53374e1449535c18f49d))
- Use markdown syntax rather for all emojis ([ce9f967](https://github.com/kkoomen/vim-doge/commit/ce9f967c6ff9386fff09bedd01d4c0ddb7eda384))
- Use variable rather then global variable in helper function ([cd3b79d](https://github.com/kkoomen/vim-doge/commit/cd3b79d62c329ce65ef69aedd74c0c68988a0e50))
- **java:** Add correct description in java tests ([77c3b03](https://github.com/kkoomen/vim-doge/commit/77c3b03e729d05cece9017e0b7f7472843d122ab))
- **java:** Make return type optional in class method declaration ([a668d33](https://github.com/kkoomen/vim-doge/commit/a668d33ea796807a2ed424ec4cd4ca58420848f1))
- **kotlin:** Add tests for functions and classes ([552b562](https://github.com/kkoomen/vim-doge/commit/552b562edb6176e57df41b34b540e855435f3e78))
- **kotlin:** Adjust some declaration in the playground ([4acc63d](https://github.com/kkoomen/vim-doge/commit/4acc63dfda8979a9dd71fab9667d9c1b776bd815))
- **kotlin:** Allow external class definition in regex for classes ([1c0672b](https://github.com/kkoomen/vim-doge/commit/1c0672bf8a3edca7007a51825a12855861d00af1))
- **kotlin:** Use [@property](https://github.com/property) rather then [@param](https://github.com/param) for classes ([40118ed](https://github.com/kkoomen/vim-doge/commit/40118ed53f7eb23f8515b0d7d6a4b653de1c27ca))
- **php:** Correct test description ([efb1a88](https://github.com/kkoomen/vim-doge/commit/efb1a88ebdb4f3dcd16674d56210905fc7508865))
- **README:** Add more clarification for the Contributing -> Linting section ([390450c](https://github.com/kkoomen/vim-doge/commit/390450c0f1ff646272cab646f208adc9d23a00bb))
- **README:** Change order of headings ([5c6c290](https://github.com/kkoomen/vim-doge/commit/5c6c290a10ddea3d7efd22a1e91ae320d1435397))
- **README:** Check kotlin as done ([1af5bb5](https://github.com/kkoomen/vim-doge/commit/1af5bb50c10df709ea8eaa8a22fdc57a67aefbf7))
- **README:** Update Table of Contents ([2c810c5](https://github.com/kkoomen/vim-doge/commit/2c810c586d2d6b51cac78c03168c89d5cacc1bc6))
- Add configurable option g:doge_mapping ([53259a6](https://github.com/kkoomen/vim-doge/commit/53259a653306f682f0d46734f87702f6679f177f))
- Add doc/tags file and update README with :help commands ([285a5a4](https://github.com/kkoomen/vim-doge/commit/285a5a4066464c82113fa59336a9f6d504dc9ba2))
- Add expected comments for PHP playground ([3ce87c1](https://github.com/kkoomen/vim-doge/commit/3ce87c1fed791a6ee79fef3ac832d85c6f96d1c8))
- Add initial file structure and setup ([da2df41](https://github.com/kkoomen/vim-doge/commit/da2df41ff188e4391f703ebd5aeb4ab9c0b30628))
- Add javascript support, tests and ftplugin ([5849aee](https://github.com/kkoomen/vim-doge/commit/5849aee192f6f2497429b66fb824a75e8f2a8e90))
- Add logic to find the FQN for a class property based on the constructor func of the surrounding class ([fe0f3f6](https://github.com/kkoomen/vim-doge/commit/fe0f3f6dc52d985b7fe0b85f854a17c43360fd2d))
- Add lua tests ([a4251c3](https://github.com/kkoomen/vim-doge/commit/a4251c30dcf52cd69857a8a32043d42fa31fe7c6))
- Add ruby tests ([77921e6](https://github.com/kkoomen/vim-doge/commit/77921e6dc4872db7e27a739f8be47fd4380034b3))
- Add support for coffeescript functions incl. flowjs support ([25bfafc](https://github.com/kkoomen/vim-doge/commit/25bfafcb3f46f8dc2633526469d18377fc9a21f8))
- Add support for Java ([1429529](https://github.com/kkoomen/vim-doge/commit/14295297d36db0a42426f9c5bd1fc96339ab96e8))
- Add support for ruby with YARD ([f255208](https://github.com/kkoomen/vim-doge/commit/f255208fdae082754bef16a7e28e1a36bb3c5474))
- Add support for the Lua language ([f1f1b12](https://github.com/kkoomen/vim-doge/commit/f1f1b12216233bd59b2f759a9b20ea09e11b20df))
- Add tests for python filetype ([f02d075](https://github.com/kkoomen/vim-doge/commit/f02d0757a3bc5bcc4d32f4bf2c5d8e9bb2a4ffe5))
- Add top-comment for all playground files to give some indication what it is ([052fc34](https://github.com/kkoomen/vim-doge/commit/052fc3412c050f3b59f3b4a4c845dd9158b88eec))
- Adjust incorrect variable; Show all output of vader with verbose flag enabled ([a80c3b6](https://github.com/kkoomen/vim-doge/commit/a80c3b64661350a4b9933b2dfcb5a23e3a7c6c83))
- Adjust indentation for b:doge_pattern items ([9522f3e](https://github.com/kkoomen/vim-doge/commit/9522f3e903bb8c0f1590fde40eece462e234c955))
- Change description in ruby test ([8429114](https://github.com/kkoomen/vim-doge/commit/84291146b4a3b10bd83669b9b1665188bd091e9c))
- Change license from MIT -> GNU GPLv3.0 ([c122ca0](https://github.com/kkoomen/vim-doge/commit/c122ca076ad14bbe1fc72d06a80a5dc5af2f6b96))
- Change MIT -> GPL-3.0 in code files ([6afea17](https://github.com/kkoomen/vim-doge/commit/6afea1744fad99e28c45fb418b5458bd703af096))
- Do not delete/insert comment if nothing has changed ([cf4f953](https://github.com/kkoomen/vim-doge/commit/cf4f9538ba1a3375cde16fad0e78432bbb23eecd))
- Do not trim in comparison check for variables l:oldline vs l:newline ([d7f0a18](https://github.com/kkoomen/vim-doge/commit/d7f0a180376e775d4c1e70a2ce7af8d1ff0c6bd6))
- Fix linting errors and implement linter-only and vim-81-only env option ([4cf5e6d](https://github.com/kkoomen/vim-doge/commit/4cf5e6d6a92170180bc0ae1d58a14a2692f7eec2))
- Fix remaining linting errors ([62e03ed](https://github.com/kkoomen/vim-doge/commit/62e03ed1dc83e9d5c44e2b11c569152237122292))
- Format vader test output ([3a44f7b](https://github.com/kkoomen/vim-doge/commit/3a44f7bfceadeedbfa8d1733966f346022d03411))
- Implement javascript/typescript/tsx/jsx ftplugins with complete logic and scenarios ([336e4ee](https://github.com/kkoomen/vim-doge/commit/336e4ee524463b084d86331089aa1bfede721e94))
- Implement php tests ([f542c8f](https://github.com/kkoomen/vim-doge/commit/f542c8fef005a78fc417aa25cfcaf6d694f8f442))
- Implement support for python docs; improved ftplugin documentation ([6588e53](https://github.com/kkoomen/vim-doge/commit/6588e53497251fa3ff3de10a5db628a7c29317cb))
- Implement support for Scala ([3cc724a](https://github.com/kkoomen/vim-doge/commit/3cc724ad952b3305b248770d17c1dceba7e0a51f))
- Improve generating logic ([2ecdc46](https://github.com/kkoomen/vim-doge/commit/2ecdc468cfcbf36188cddca7ad3d81b60820901b))
- Initial version of automated testing ([f203100](https://github.com/kkoomen/vim-doge/commit/f203100ec1dbecac0c23ebebe814e99020684d19))
- Initial version that generates a proper comment for PHP functions/methods ([be5cfdb](https://github.com/kkoomen/vim-doge/commit/be5cfdba1f270aea4e121006e36987887d6a453e))
- Make doge#token#replace_string a local script function ([88b34d5](https://github.com/kkoomen/vim-doge/commit/88b34d53209c6b0a9b1be926870c8dd742633258))
- Move all tests to a playground folder ([b185920](https://github.com/kkoomen/vim-doge/commit/b185920c4c1872fd83d807cf440ecc62a5fa36b3))
- Optimise doge#token#replace() to replace multiple tokens in string; Remove comment before inserting; Add regex documentation ([eac09a9](https://github.com/kkoomen/vim-doge/commit/eac09a9a847e013ccb2698fea399edeccd9a0e3c))
- Optimise php regex to ensure parameters are parsed correctly ([48603c6](https://github.com/kkoomen/vim-doge/commit/48603c6ba67122d1b034896170de1c979d6a2ce2))
- Optimise vim-pack installation syntax ([ef0d808](https://github.com/kkoomen/vim-doge/commit/ef0d80860ed5203432188aeb7cc1faef314d3142))
- Remove [@function](https://github.com/function) if it is not a function declared with the keyword "function" ([873fee5](https://github.com/kkoomen/vim-doge/commit/873fee5f6b264ca3f5e6f3cb31f1d141838b4774))
- Remove key trim_comparision_check since it is no longer used ([43d2d7d](https://github.com/kkoomen/vim-doge/commit/43d2d7d3b4212030ca192ea9b7b40991a10af05b))
- Remove logic for old-comment check ([18c0042](https://github.com/kkoomen/vim-doge/commit/18c00421ac16428e19c3a91009d7962fbe3b6276))
- Remove separator to be a configurable option per ftplugin ([ad2430e](https://github.com/kkoomen/vim-doge/commit/ad2430e47f8bceccc9819aeded561b62941a58cc))
- Remove top comments with unnecessary template ([1b4d7a2](https://github.com/kkoomen/vim-doge/commit/1b4d7a2a9519dd064f661ae44e06bdfdda1ffb1a))
- Remove unnecessary echoerr ([eaa7128](https://github.com/kkoomen/vim-doge/commit/eaa7128c92788373c35cd404bfbfd92b029ea9a1))
- Rename test/languages folder to test/filetypes ([d9f42b0](https://github.com/kkoomen/vim-doge/commit/d9f42b0fab960d3953e785fb4564a9573b246d58))
- Revert .\+ to .\{-} for php ([aa0a5b1](https://github.com/kkoomen/vim-doge/commit/aa0a5b1521b0c908bcce1992c0dc525221c0c626))
- Revert doge#token#replace_string function and implement exclamation-mark logic ([68e1b63](https://github.com/kkoomen/vim-doge/commit/68e1b63651caa71f049c072770cbad27693e00a0))
- Set 2 spaces rather then 4 in test vimrc ([d2000be](https://github.com/kkoomen/vim-doge/commit/d2000bea6df49e064659c9dc96ba81cb42f1121d))
- Trigger comment on current line, rather then next line; Indent comment based on current line ([2330fa4](https://github.com/kkoomen/vim-doge/commit/2330fa4b176caf8dd77e5401efdb470e04837079))
- Update kotlin regex patterns to improve type-hint detection ([9cfdf13](https://github.com/kkoomen/vim-doge/commit/9cfdf13801a42504f056198df20d738e7cc24789))
- Update test files and added example test files ([bdad685](https://github.com/kkoomen/vim-doge/commit/bdad6855de9a9efe783e92813116b39fee350f73))
- Use a comment separator in-between tests in the php tests ([cfc8b2e](https://github.com/kkoomen/vim-doge/commit/cfc8b2e7266dcbd8553a03a6dbd5fd05563eb937))
- **lua:** Enforce magic regex interpretation ([81eb8ac](https://github.com/kkoomen/vim-doge/commit/81eb8acb5771d7df6b0b2bd86c5c9fd41fd7c6aa))
- **php:** Add a doge#preprocessors namespace for all the filetype specific preprocess functions ([93c8ebb](https://github.com/kkoomen/vim-doge/commit/93c8ebbf94e25a2dd2431d5c6727e1949824b2bf))
- **php:** Use the FQN for class types if the import is not an alias ([86c62ed](https://github.com/kkoomen/vim-doge/commit/86c62ed29d87b147222bc84b347bb00542549246))
- **README:** Add new languages to the TODO list ([a3bf2bb](https://github.com/kkoomen/vim-doge/commit/a3bf2bb4eaf25e66abfbc7662d31903c46c41803))
- **README:** Add quote of Martin Fowler ([16cca15](https://github.com/kkoomen/vim-doge/commit/16cca1572d223c7b81cd806e5cb898e861dd603f))
- **README:** set align attribute on h1 rather then surrounding <p> ([7ede579](https://github.com/kkoomen/vim-doge/commit/7ede5799ebf73ba2d44628a19866fc0295d002b1))
- **run-tests:** Add colored output with glyphs ([b6d0df7](https://github.com/kkoomen/vim-doge/commit/b6d0df78b25cbcc3bd923b2cc1c4d8ffcba0fa2c))
- Support default token values; refactor: Split up doge#generate and split up token functions ([d82cb52](https://github.com/kkoomen/vim-doge/commit/d82cb5259b204edbab51460212179e19609bd791))
- Update php and lua comment templates ([a9d26a4](https://github.com/kkoomen/vim-doge/commit/a9d26a4ab7fd33191c4742703adcb34f0892a488))
- Update playground/test.js with new scenarios ([287231e](https://github.com/kkoomen/vim-doge/commit/287231ed89b47e0cb686e26bf05191d823bf4a23))
- Update README introduction ([8554c23](https://github.com/kkoomen/vim-doge/commit/8554c23226b2773a503ce52b0243a5c935add009))
- **README:** Add description and supported-languages section ([900a9f0](https://github.com/kkoomen/vim-doge/commit/900a9f078dab5859058cdd5c533e325b960dfa1b))
- **README:** Add Typescript to the supported-languages list ([3b79af6](https://github.com/kkoomen/vim-doge/commit/3b79af641addd309a0e574274a0fa4c2faffd2ca))
- **README:** Change JAVA -> Java ([544abab](https://github.com/kkoomen/vim-doge/commit/544abab286e1642b7ee72e55b7398ea2d29a8da8))
- **README:** Remove flowjs check under coffeescript ([79cd39e](https://github.com/kkoomen/vim-doge/commit/79cd39ed070963397a52d22382264fc4f78f6827))
- **README:** Update supported-languages section ([24e4e04](https://github.com/kkoomen/vim-doge/commit/24e4e04847b5d56621adbc16341669a195c9a5f8))
- **README:** Update ToC ([d126b94](https://github.com/kkoomen/vim-doge/commit/d126b9474d080bb7febee8cd3850e405b9909fd1))
- Support multiline function expressions ([bff43a4](https://github.com/kkoomen/vim-doge/commit/bff43a4442654059f7a329eb24ba558bf8401c79))
- Use javascript and typescript without the unneeded jsx ftplugin and tests ([352b1d0](https://github.com/kkoomen/vim-doge/commit/352b1d02360569d71f86fc9351b77ab55fa1b61e))
