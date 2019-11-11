// =============================================================================
// Regular functions
// =============================================================================

class Emitter {
  public:
      void append_token();
}

/**
 * @brief 
 * 
 * @param text 
 * @param node 
 */
void Emitter::append_token(const std::string& text, const AST_Node* node)
{
  //
}

/**
 * @brief 
 * 
 * @return std::vector<std::string> 
 */
std::vector<std::string> someFunction();

/**
 * @brief 
 * 
 * @return const next_layer_type& 
 */
const next_layer_type& my_func()
{
  //
}

/**
 * @brief 
 * 
 * @param text 
 * @return lowest_layer_type& 
 */
lowest_layer_type& my_func(std::string& text)
{
  //
}

/**
 * @brief 
 * 
 * @param v 
 * @param ec 
 * @return ASIO_SYNC_OP_VOID 
 */
ASIO_SYNC_OP_VOID myFunc(
    verify_mode v, asio::error_code& ec)
{
  //
}

/**
 * @brief 
 * 
 * @param line 
 * @return std::string 
 */
std::string trimLine(const std::string &line);

/**
 * @brief 
 * 
 * @param e 
 * @return project::error_code 
 */
inline project::error_code my_func(ssl_errors e)
{
  //
}

/**
 * @brief Construct a new Vector object
 * 
 * @tparam T 
 * @param it_begin 
 * @param _end 
 */
template<typename T>
Vector(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) {
  assert(N == std::distance(it_begin, it_end));
}

/**
 * @brief 
 * 
 * @param p 
 */
void f(A* p = this)
{
  //
}

/**
 * @brief Get the Max object
 * 
 * @tparam T 
 * @param a 
 * @param b 
 * @return T 
 */
template <class T>
T GetMax (T a, T b) {
  T result;
  result = (a>b)? a : b;
  return (result);
}

/**
 * @brief 
 * 
 * @tparam T 
 * @param i 
 * @param args 
 */
template<class...T> void h(int i = 0, T... args) {
  //
}

// =============================================================================
// PTS/auto-functions (placeholder type specifiers)
// =============================================================================

/**
 * @brief 
 * 
 * @tparam n 
 * @param it_begin 
 * @param _end 
 * @return std::pair<decltype(n), decltype(n)> 
 */
template<auto n>
auto f(std::enable_if<is_foreach_iterator<T>, T>::type& it_begin, T& _end) -> std::pair<decltype(n), decltype(n)> // test
{
  //
}

/**
 * @brief 
 * 
 * @tparam T 
 * @tparam Args 
 * @param args 
 * @return T* 
 */
template<typename T, typename... Args>
static T* create(Args&& ... args)
{
  //
}

/**
 * @brief 
 * 
 * @tparam  
 * @param args 
 * @return T* 
 */
template<> static T* create(Args&& ... args);

/**
 * @brief 
 * 
 * @tparam BasicJsonType 
 * @tparam ValueType 
 * @param j 
 * @param val 
 * @return decltype(::somename::from_json(std::forward<BasicJsonType>(j), val), void()) 
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
 * @brief 
 * 
 * @tparam F 
 * @tparam Args 
 * @param fun 
 * @param args 
 * @return decltype(auto) 
 */
template<class F, class... Args>
decltype(auto) PerfectForward(F fun, Args&&... args)
{
  //
}