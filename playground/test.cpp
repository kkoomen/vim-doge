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
 * @return TODO
 */
const next_layer_type& my_func()
{
  //
}

/**
 * TODO
 *
 * @param text TODO
 * @return TODO
 */
lowest_layer_type& my_func(std::string& text)
{
  //
}

/**
 * TODO
 *
 * @param v TODO
 * @param ec TODO
 * @return TODO
 */
ASIO_SYNC_OP_VOID myFunc(
    verify_mode v, asio::error_code& ec)
{
  //
}

/**
 * TODO
 *
 * @param e TODO
 * @return TODO
 */
inline project::error_code my_func(ssl_errors e)
{
  //
}

/**
 * TODO
 *
 * @param type TODO
 * @param handler TODO
 * @return TODO
 */
template <typename HandshakeHandler>
INITFN_RESULT_TYPE(HandshakeHandler, void (project::error_code))
myFunc(handshake_type type, MOVE_ARG(HandshakeHandler) handler)
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
void f(A* p = this)
{
  //
}

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
// PTS/auto-functions (placeholder type specifiers)
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
  //
}

/**
 * TODO
 *
 * @param args TODO
 * @return TODO
 */
template<typename T, typename... Args>
static T* create(Args&& ... args)
{
  //
}

/**
 * TODO
 *
 * @param args TODO
 * @return TODO
 */
template<> static T* create(Args&& ... args);

/**
 * TODO
 *
 * @param j TODO
 * @param val TODO
 * @return TODO
 */
template<typename BasicJsonType, typename ValueType>
static auto 
  from_json(BasicJsonType&& j, ValueType& val) 
  noexcept(noexcept(::somename::from_json(std::forward<BasicJsonType>(j), val)))
-> decltype(::somename::from_json(std::forward<BasicJsonType>(j), val), void())
{
  //
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
