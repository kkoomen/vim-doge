// =============================================================================
// Regular functions
// =============================================================================

/**
 * [TODO:description]
 *
 * @param text [TODO:description]
 * @param node [TODO:description]
 */
void Emitter::append_token(const std::string& text, const AST_Node* node)
{
  //
}

/**
 * [TODO:description]
 * @return [TODO:description]
 */
std::vector<std::string> someFunction();

/**
 * [TODO:description]
 * @return [TODO:description]
 */
const next_layer_type& my_func()
{
  //
}

/**
 * [TODO:description]
 *
 * @param text [TODO:description]
 * @return [TODO:description]
 */
lowest_layer_type& my_func(std::string& text)
{
  //
}

/**
 * [TODO:description]
 *
 * @param v [TODO:description]
 * @param ec [TODO:description]
 * @return [TODO:description]
 */
ASIO_SYNC_OP_VOID myFunc(
    verify_mode v, asio::error_code& ec)
{
  //
}

std::string trimLine(const std::string &line);

/**
 * [TODO:description]
 *
 * @param e [TODO:description]
 * @return [TODO:description]
 */
inline project::error_code my_func(ssl_errors e)
{
  //
}

/**
 * [TODO:description]
 *
 * @param type [TODO:description]
 * @param handler [TODO:description]
 * @return [TODO:description]
 */
template <typename HandshakeHandler>
INITFN_RESULT_TYPE(HandshakeHandler, void (project::error_code))
myFunc(handshake_type type, MOVE_ARG(HandshakeHandler) handler)
{
  //
}

/**
 * [TODO:description]
 *
 * @param it_begin [TODO:description]
 * @param _end [TODO:description]
 * @return [TODO:description]
 */
template<typename T>
Vector(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) {
  assert(N == std::distance(it_begin, it_end));
}

/**
 * [TODO:description]
 *
 * @param p [TODO:description]
 */
void f(A* p = this)
{
  //
}

/**
 * [TODO:description]
 *
 * @param a [TODO:description]
 * @param b [TODO:description]
 * @return [TODO:description]
 */
template <class T>
T GetMax (T a, T b) {
  T result;
  result = (a>b)? a : b;
  return (result);
}

/**
 * [TODO:description]
 *
 * @param i [TODO:description]
 * @param args [TODO:description]
 */
template<class...T> void h(int i = 0, T... args) {
  //
}

// =============================================================================
// PTS/auto-functions (placeholder type specifiers)
// =============================================================================

/**
 * [TODO:description]
 *
 * @param it_begin [TODO:description]
 * @param _end [TODO:description]
 * @return [TODO:description]
 */
template<auto n>
auto f(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) -> std::pair<decltype(n), decltype(n)> // test
{
  //
}

/**
 * [TODO:description]
 *
 * @param args [TODO:description]
 * @return [TODO:description]
 */
template<typename T, typename... Args>
static T* create(Args&& ... args)
{
  //
}

/**
 * [TODO:description]
 *
 * @param args [TODO:description]
 * @return [TODO:description]
 */
template<> static T* create(Args&& ... args);

/**
 * [TODO:description]
 *
 * @param j [TODO:description]
 * @param val [TODO:description]
 * @return [TODO:description]
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
 * [TODO:description]
 *
 * @param fun [TODO:description]
 * @param args [TODO:description]
 * @return [TODO:description]
 */
template<class F, class... Args>
decltype(auto) PerfectForward(F fun, Args&&... args)
{
  //
}
