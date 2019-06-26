// =============================================================================
// Regular functions
// =============================================================================

/**
 * TODO
 *
 * @param text TODO
 * @param node TODO
 * @return TODO
 */
void Emitter::append_token(const std::string& text, const AST_Node* node)
{
  //
}

/**
 * TODO
 *
 * @param it_begin TODO
 * @param _end TODO
 * @return TODO
 */
template<typename T>
Vector(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) {
  assert(N == std::distance(it_begin, it_end));
}

/**
 * TODO
 *
 * @param p TODO
 * @return TODO
 */
void f(A* p = this) { } // error: this is not allowed

/**
 * TODO
 *
 * @param a TODO
 * @param b TODO
 * @return TODO
 */
template <class T>
T GetMax (T a, T b) {
  T result;
  result = (a>b)? a : b;
  return (result);
}

/**
 * TODO
 *
 * @param i TODO
 * @param args TODO
 * @return TODO
 */
template<class...T> void h(int i = 0, T... args) {
  //
}

// =============================================================================
// PTS-functions (placeholder type specifiers)
// =============================================================================

/**
 * TODO
 *
 * @param it_begin TODO
 * @param _end TODO
 * @return TODO
 */
template<auto n>
auto f(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) -> std::pair<decltype(n), decltype(n)> // test
{
    return {n, n};
}

/**
 * TODO
 *
 * @param fun TODO
 * @param args TODO
 * @return TODO
 */
template<class F, class... Args>
decltype(auto) PerfectForward(F fun, Args&&... args)
{
  //
}
