/**
 * @brief [TODO:description]
 *
 * @return [TODO:description]
 */
int myFunc(/* inline comment */) {}

class TestClass {
  public:
    int myFunc();
};

/**
 * struct foo - [TODO:description]
 */
struct foo {
      /**
       * @foo [TODO:description]
       */
      int foo;
};

/**
 * @brief [TODO:description]
 *
 * @param text [TODO:description]
 * @param node [TODO:description]
 * @return [TODO:description]
 */
int TestClass::myFunc(const std::string& text /* inline comment */, const Node* node) {}

/**
 * @brief [TODO:description]
 *
 * @param p [TODO:description]
 */
void f(A* p = this) {}

/**
 * @brief [TODO:description]
 *
 * @tparam F [TODO:description]
 * @tparam Args [TODO:description]
 * @param fun [TODO:description]
 * @param args [TODO:description]
 * @return [TODO:description]
 */
template<class F, class... Args>
decltype(auto) PerfectForward(F fun, Args&&... args)
{
  //
}

/**
 * @brief [TODO:description]
 *
 * @param lhs [TODO:description]
 * @param rhs [TODO:description]
 * @return [TODO:description]
 */
inline bool operator<(const value_t lhs, const value_t rhs) noexcept {}

/**
 * @brief [TODO:description]
 *
 * @tparam HandshakeHandler [TODO:description]
 * @param type [TODO:description]
 * @param param [TODO:description]
 */
template <typename HandshakeHandler>
void myFunc(handshake_type type, MOVE_ARG(HandshakeHandler) handler) {}

/**
 * @brief [TODO:description]
 *
 * @param val [TODO:description]
 * @return [TODO:description]
 */
virtual bool boolean(bool val) = 0;
