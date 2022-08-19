# C-Family Doc Standard Examples

Due to the amount of doc standards for the C-family languages, all of them are
listed below using C++ to clarify the style they generate, although most of the
doc styles apply for other C-family languages as well.

# Table of Contents

- [C-Family Doc Standard Examples](#c-family-doc-standard-examples)
- [Table of Contents](#table-of-contents)
- [Doc standards](#doc-standards)
  - [doxygen_javadoc](#doxygen_javadoc)
  - [doxygen_javadoc_no_asterisk](#doxygen_javadoc_no_asterisk)
  - [doxygen_javadoc_banner](#doxygen_javadoc_banner)
  - [doxygen_qt](#doxygen_qt)
  - [doxygen_qt_no_asterisk](#doxygen_qt_no_asterisk)
  - [doxygen_cpp_comment_slash](#doxygen_cpp_comment_slash)
  - [doxygen_cpp_comment_exclamation](#doxygen_cpp_comment_exclamation)
  - [doxygen_cpp_comment_slash_banner](#doxygen_cpp_comment_slash_banner)
  - [kernel_doc (only available in C)](#kernel_doc-only-available-in-c)

# Doc standards

### doxygen_javadoc

```cpp
/**
 * @brief [TODO:summary]
 *
 * @tparam F [TODO:description]
 * @tparam Args [TODO:description]
 * @param builder [TODO:description]
 * @return [TODO:description]
 */
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_javadoc_no_asterisk

```cpp
/**
@brief [TODO:summary]

@tparam F [TODO:description]
@tparam Args [TODO:description]
@param builder [TODO:description]
@return [TODO:description]
*/
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_javadoc_banner

```cpp
/*******************************************************************************
 * @brief [TODO:summary]
 *
 * @tparam F [TODO:description]
 * @tparam Args [TODO:description]
 * @param builder [TODO:description]
 * @return [TODO:description]
 ******************************************************************************/
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_qt

```cpp
/*!
 * @brief [TODO:summary]
 *
 * @tparam F [TODO:description]
 * @tparam Args [TODO:description]
 * @param builder [TODO:description]
 * @return [TODO:description]
 */
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_qt_no_asterisk

```cpp
/*!
@brief [TODO:summary]

@tparam F [TODO:description]
@tparam Args [TODO:description]
@param builder [TODO:description]
@return [TODO:description]
*/
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_cpp_comment_slash

```cpp
///
/// @brief [TODO:summary]
///
/// @tparam F [TODO:description]
/// @tparam Args [TODO:description]
/// @param builder [TODO:description]
/// @return [TODO:description]
///
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_cpp_comment_exclamation

```cpp
//!
//! @brief [TODO:summary]
//!
//! @tparam F [TODO:description]
//! @tparam Args [TODO:description]
//! @param builder [TODO:description]
//! @return [TODO:description]
//!
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### doxygen_cpp_comment_slash_banner

```cpp
////////////////////////////////////////////////////////////////////////////////
/// @brief [TODO:summary]
///
/// @tparam F [TODO:description]
/// @tparam Args [TODO:description]
/// @param builder [TODO:description]
/// @return [TODO:description]
////////////////////////////////////////////////////////////////////////////////
template<class F, class... Args>
auto Person::getPersonType (const Builder& builder) -> PersonType {}
```

### kernel_doc (only available in C)

```c
/**
 * foo(): [TODO:summary]
 * @a: [TODO:description]
 * @b: [TODO:description]
 *
 * [TODO:description]
 *
 * Return: [TODO:description]
 */
int foo(int a, char b) {}
```
