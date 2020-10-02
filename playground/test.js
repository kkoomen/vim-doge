// =============================================================================
//
// Vanilla
//
// =============================================================================

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} window - [TODO:description]
 * @param {[TODO:type]} document - [TODO:description]
 * @param {[TODO:type]} $ - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
((window, document, $) => {

  /**
   * [TODO:description]
   *
   * @param {string} [$p1] - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  function myFunc($p1: string = 'value') {}

})(window, document, jQuery);

/**
 * [TODO:description]
 *
 * @function Person#greet
 * @param {string} [p1] - [TODO:description]
 * @param {Immutable.List} [p2] - [TODO:description]
 * @return {string[]} [TODO:description]
 */
Person.prototype.greet = function (p1: string = 'default', p2: Immutable.List = Immutable.List()): string[] {
  //
};

/**
 * [TODO:description]
 *
 * @function Person#greet
 * @param {[TODO:type]} p1 - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
Person.prototype.greet = function (p1) {}

/**
 * [TODO:description]
 *
 * @generator
 * @param {[TODO:type]} p1 - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
var perfectSquares = function*(p1) {};

/**
 * [TODO:description]
 *
 * @async
 * @generator
 * @param {[TODO:type]} p1 - [TODO:description]
 * @return {Promise<[TODO:type]>} [TODO:description]
 */
perfectSquares = async function*(p1) {};

/**
 * [TODO:description]
 *
 * @async
 * @generator
 * @param {[TODO:type]} [$p1] - [TODO:description]
 * @param {[TODO:type]} [p2] - [TODO:description]
 * @param {[TODO:type]} p3 - [TODO:description]
 * @param {[TODO:type]} p4 - [TODO:description]
 * @return {Promise<[TODO:type]>} [TODO:description]
 */
var myFunc = async function*($p1 = 'value', p2 = [], p3, p4) {}

/**
 * [TODO:description]
 *
 * @async
 * @param {[TODO:type]} [$p1] - [TODO:description]
 * @param {[TODO:type]} [p2] - [TODO:description]
 * @param {[TODO:type]} p3 - [TODO:description]
 * @param {[TODO:type]} p4 - [TODO:description]
 * @return {Promise<[TODO:type]>} [TODO:description]
 */
var myFunc = async ($p1 = 'value', p2 = [], p3, p4) => {}

/**
 * [TODO:description]
 *
 * @param {string} $p1 - [TODO:description]
 * @param {Foo | Bar | Baz} p2 - [TODO:description]
 * @return {(Foo | Bar)} [TODO:description]
 */
function myFunc($p1: string, p2: Foo | Bar | Baz): (Foo | Bar) {}

/**
 * [TODO:description]
 *
 * @function Person#greet
 * @return {[TODO:type]} [TODO:description]
 */
Person.prototype.greet = () => {}

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} [$p1] - [TODO:description]
 * @param {[TODO:type]} [p2] - [TODO:description]
 * @param {[TODO:type]} p3 - [TODO:description]
 * @param {[TODO:type]} p4 - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
var myFunc = function($p1 = 'value', p2 = [], p3, p4) {}

/**
 * [TODO:description]
 *
 * @param {string} [$p1] - [TODO:description]
 * @param {string[]} [p2] - [TODO:description]
 * @param {number} p3 - [TODO:description]
 * @param {float} p4 - [TODO:description]
 * @return {string[]} [TODO:description]
 */
var myFunc = function($p1: string = 'value', p2: string[] = [], p3: number, p4: float): string[]  {}

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} p1 - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
function myFunc(p1) {
  var a = 2;
}

var myObj = {

  /**
   * [TODO:description]
   *
   * @return {[TODO:type]} [TODO:description]
   */
  myFunc: function() {

    /**
     * [TODO:description]
     *
     * @param {string} [p1] - [TODO:description]
     * @param {Immutable.List} [p2] - [TODO:description]
     * @return {[TODO:type]} [TODO:description]
     */
    function(p1: string = 'default', p2: Immutable.List = Immutable.List()) {
      var a = 2;
    };

    /**
     * [TODO:description]
     *
     * @return {[TODO:type]} [TODO:description]
     */
    return function() {
      //
    }
  },
};

// =============================================================================
//
// Node & ES6
//
// =============================================================================

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} [p1] - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
const user = (p1 = 'default') => (subp1, subp2 = 'default') => 5;

/**
 * [TODO:description]
 *
 * @return {number[]} [TODO:description]
 */
(): number[] => { };

/**
 * [TODO:description]
 *
 * @param {string} [p1] - [TODO:description]
 * @param {number} [p2] - [TODO:description]
 * @param {[TODO:type]} p3 - [TODO:description]
 * @param {Immutable.List} [p4] - [TODO:description]
 * @param {string[]} [p5] - [TODO:description]
 * @param {float} [p6] - [TODO:description]
 * @return {number[]} [TODO:description]
 */
const user = (p1: string = 'default', p2: number = 5, p3, p4: Immutable.List = [], p5: string[] = [], p6: float = 0.5): number[] => { };

const myObj = {

  /**
   * [TODO:description]
   *
   * @return {[TODO:type]} [TODO:description]
   */
  myFunc: () => {
    /**
     * [TODO:description]
     *
     * @return {[TODO:type]} [TODO:description]
     */
    return () => {
      //
    };
  },

  /**
   * [TODO:description]
   *
   * @param {string} p1 - [TODO:description]
   * @param {string} [p2] - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  myFunc(p1: string, p2: string = '5') {
    //
  }
};

// =============================================================================
//
// Flow js (can be used e.g. in React projects)
//
// =============================================================================

const bar: number = 2;
let foo: number = 1;
let isOneOf: number | boolean | string = foo;

/**
 * [TODO:description]
 *
 * @param {any} one - [TODO:description]
 * @param {any} [two] - [TODO:description]
 * @return {number} [TODO:description]
 */
function add(one: any, two: any = 'default'): number {}

// =============================================================================
//
// Typescript
//
// =============================================================================
const bar: number = 2;
let foo: number = 1;
let sn: string | null = "bar";
let Easing: "ease-in" | "ease-out" | "ease-in-out" = "ease-in";

/**
 * [TODO:description]
 *
 * @param {string[]} [p1] - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
(p1: string[] = []) => (p2: string) => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {History} history - [TODO:description]
 * @param {object} initialState - [TODO:description]
 * @return {Store<AppState>} [TODO:description]
 */
export function configureStore(history: History, initialState: object): Store<AppState> {}

/**
 * [TODO:description]
 *
 * @param {History} history - [TODO:description]
 * @param {object} initialState - [TODO:description]
 * @return {Store<AppState>} [TODO:description]
 */
function configureStore(history: History, initialState: object): Store<AppState> {}

/**
 * [TODO:description]
 *
 * @param {History} history - [TODO:description]
 * @param {object} initialState - [TODO:description]
 * @return {Store<AppState>} [TODO:description]
 */
const configureStore = (history: History, initialState: object): Store<AppState> => {}

/**
 * [TODO:description]
 *
 * @return {1 | 2 | 3 | 4 | 5 | 6} [TODO:description]
 */
function rollDice(): 1 | 2 | 3 | 4 | 5 | 6 {}

/**
 * [TODO:description]
 *
 * @return {(1 | 2 | 3 | 4 | 5 | 6)} [TODO:description]
 */
function rollDice(): (1 | 2 | 3 | 4 | 5 | 6) {}

/**
 * [TODO:description]
 *
 * @template T - [TODO:description]
 * @template K - [TODO:description]
 * @param {T} o - [TODO:description]
 * @param {K[]} names - [TODO:description]
 * @return {T[K][]} [TODO:description]
 */
function pluck<T, K extends keyof T>(o: T, names: K[]): T[K][] {}

/**
 * [TODO:description]
 *
 * @param {Fish | Bird} pet - [TODO:description]
 * @param {[User]} users - [TODO:description]
 * @return {[User, Fish]} [TODO:description]
 */
function isFish(pet: Fish | Bird, users: [User]): [User, Fish] {}

/**
 * [TODO:description]
 *
 * @param {any} x - [TODO:description]
 * @return {x is number} [TODO:description]
 */
function isNumber(x: any): x is number {}

/**
 * [TODO:description]
 *
 * @param {number} [p1] - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
const func = (p1: number = 5) => { console.log(5); }

/**
 * [TODO:description]
 *
 * @template T - [TODO:description]
 * @param {string[]} [p1] - [TODO:description]
 * @return {Sequence[T]} [TODO:description]
 */
const func = <T>(p1: string[] = []): Sequence[T] => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {Sequence[]} [p1] - [TODO:description]
 * @return {Array<T, B>} [TODO:description]
 */
const func = (p1: Sequence[] = []): Array<T, B> => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {string[]} [p1] - [TODO:description]
 * @return {Array<T, B>} [TODO:description]
 */
const user1 = (p1: string[] = []): Array<T, B> => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {number[]} [p1] - [TODO:description]
 * @return {Array<T, B>} [TODO:description]
 */
let user2 = (p1: number[] = []): Array<T, B> => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {number[]} [p1] - [TODO:description]
 * @return {Array<T, B>} [TODO:description]
 */
var user3 = (p1: number[] = []): Array<T, B> => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {string[]} [p1] - [TODO:description]
 * @return {x is number} [TODO:description]
 */
const $_123user3 = (p1: string[] = []): x is number => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {string[]} [p1] - [TODO:description]
 * @return {1 | 2 | 3 | 4 | 5 | 6} [TODO:description]
 */
const rollDice = (p1: string[] = []): 1 | 2 | 3 | 4 | 5 | 6 => { console.log(5); }

/**
 * [TODO:description]
 *
 * @return {1 | 2 | 3 | 4 | 5 | 6} [TODO:description]
 */
const rollDice = (): 1 | 2 | 3 | 4 | 5 | 6 => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} bar - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
const foo = bar => baz;

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} bar - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
export const foo = bar => baz;

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} [TODO:name] - [TODO:description]
 * @return {(PropTypes.Element | null)} [TODO:description]
 */
const myFunc = ({ children }): (PropTypes.Element | null) => (
  <div>...</div>
);

/**
 * [TODO:description]
 *
 * @param {[TODO:type]} [TODO:name] - [TODO:description]
 * @return {[TODO:type]} [TODO:description]
 */
const myFunc = ({ children }) => {
  <div>...</div>
};

/**
 * [TODO:description]
 *
 * @param {string[]} [p1] - [TODO:description]
 * @return {(1 | 2 | 3 | 4 | 5 | 6)} [TODO:description]
 */
const rollDice = (p1: string[] = []): (1 | 2 | 3 | 4 | 5 | 6) => { console.log(5); }

/**
 * [TODO:description]
 *
 * @return {(1 | 2 | 3 | 4 | 5 | 6)} [TODO:description]
 */
const rollDice = () : (1 | 2 | 3 | 4 | 5 | 6) => { console.log(5); }

/**
 * [TODO:description]
 *
 * @param {number} b - [TODO:description]
 * @return {number | Fish} [TODO:description]
 */
const add = (b: number): number | Fish => { console.log(5); }

/**
 * [TODO:description]
 * @implements Padder
 */
class SpaceRepeatingPadder implements Padder {

  /**
   * [TODO:description]
   *
   * @param {number} numSpaces - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  constructor(private numSpaces: number) { }

  /**
   * [TODO:description]
   *
   * @return {string} [TODO:description]
   */
  getPaddingString(): string {
    return Array(this.numSpaces + 1).join(" ");
  }
}

/**
 * [TODO:description]
 */
class Adder {

  /**
   * [TODO:description]
   *
   * @param {number} a - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  constructor = (public a: number) => {}

  /**
   * [TODO:description]
   *
   * @param {number} b - [TODO:description]
   * @return {number} [TODO:description]
   */
  add = (b: number): number => {
    return this.a + b;
  }
}

/**
 * [TODO:description]
 */
class Child {}

/**
 * [TODO:description]
 */
export class Child {}

/**
 * [TODO:description]
 * @extends Parent
 */
class Child extends Parent {}

/**
 * [TODO:description]
 * @extends React.Component
 */
export class Child extends React.Component {}

/**
 * [TODO:description]
 * @extends Parent
 */
export class Child extends Parent {}

/**
 * [TODO:description]
 * @implements CustomInterfaceName
 */
class Child implements CustomInterfaceName {}

/**
 * [TODO:description]
 * @implements CustomInterfaceName
 */
export class Child implements CustomInterfaceName {}

/**
 * [TODO:description]
 * @extends Parent
 * @implements CustomInterfaceName
 */
class Child extends Parent implements CustomInterfaceName {}

/**
 * [TODO:description]
 * @extends Parent
 * @implements CustomInterfaceName
 */
export class Child extends Parent implements CustomInterfaceName {}

/**
 * [TODO:description]
 *
 * @param {string} [$p1] - [TODO:description]
 * @param {string[]} [p2] - [TODO:description]
 * @param {number} p3 - [TODO:description]
 * @param {float} p4 - [TODO:description]
 * @return {string[]} [TODO:description]
 */
const myFunc = ($p1: string = 'value', p2: string[] = [], p3: number, p4: float): string[] => {}

/**
 * [TODO:description]
 *
 * @template MapItem - [TODO:description]
 * @template MapKey - [TODO:description]
 * @param {(xs: MapItem) => Boolean} x - [TODO:description]
 * @param {(xs: MapItem) => Boolean} y - [TODO:description]
 * @return {(xs: Map<MapKey, MapItem>) => MapItem[]} [TODO:description]
 */
export function rejectMapByValue<MapItem = unknown, MapKey = unknown>(
  x: (xs: MapItem) => Boolean,
  y: (xs: MapItem) => Boolean,
): (xs: Map<MapKey, MapItem>) => MapItem[] {}

// Example of ES7 with decorators
/**
 * [TODO:description]
 */
class Test {

  /**
   * [TODO:description]
   *
   * @async
   * @param {User} user - [TODO:description]
   * @param {Request} req - [TODO:description]
   * @return {Promise<User>} [TODO:description]
   */
  @Get()
  @UseGuards(LocalAuthGuard([
    'foo',
    'bar'
  ]))
  @SkipJwtAuth()
  async login(@CurrentUser() user: User, @Req() req: Request): Promise<User> {
    //
  }
}

/**
 * [TODO:description]
 * @extends Parent
 */
class Child extends Parent {
  classProperty;

  classProperty

  static classProperty: string

  classProperty: string = 'default value'

  /**
   * [TODO:description]
   *
   * @return {[TODO:type]} [TODO:description]
   */
  static classProperty = function() {}

  /**
   * [TODO:description]
   *
   * @param {number} b - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  myMethod(public b: number) {
    return this.add(b);
  }

  /**
   * [TODO:description]
   *
   * @param {number} arg0 - [TODO:description]
   * @param {string} [arg1] - [TODO:description]
   */
  public funcA(arg0: number, arg1?: string): void {

  }

  /**
   * [TODO:description]
   *
   * @param {number} b - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  static myMethod = (b: number) => {
    return this.add(b);
  }

  /**
   * [TODO:description]
   *
   * @static
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {number} [TODO:description]
   */
  static myMethod({ b: number }): number {
    return this.add(b);
  }

  /**
   * [TODO:description]
   *
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  mMethod = ({ b: number }) => {
    return this.add(b);
  }

  /**
   * [TODO:description]
   *
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  test({ idUser, userModel }: { idUser: ObjectId, userModel: string }) {}

  /**
   * [TODO:description]
   *
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  test(@Body() { idUser, userModel }: { idUser: ObjectId, userModel: string }) {}

  /**
   * [TODO:description]
   *
   * @param {Model<T>} $model - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  test(@InjectModel(User.name) private readonly $model: Model<T>) {}

  /**
   * [TODO:description]
   *
   * @param {Model<T>} model - [TODO:description]
   * @return {[TODO:type]} [TODO:description]
   */
  test(@InjectModel('User') private readonly model: Model<T>) {}
}

/**
 * [TODO:description]
 */
class Test {

  /**
   * [TODO:description]
   *
   * @async
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {UserA & UserB} [TODO:description]
   */
  @Test()
  async test(@Body() { idUser, userModel }: { error: string } & { idUser: ObjectId, userModel: string }): UserA & UserB {}

  /**
   * [TODO:description]
   *
   * @async
   * @param {[TODO:type]} [TODO:name] - [TODO:description]
   * @return {Promise<UserA | UserB>} [TODO:description]
   */
  async test(@Body() { idUser, userModel }: { idUser: ObjectId, userModel: string }): Promise<UserA | UserB> {}
}
