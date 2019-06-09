/**
 * This file contains test scenarios and their expected results. You should be
 * able to generate the examples below.
 */

// =============================================================================
//
// Vanilla
//
// =============================================================================

/**
 * @function
 * @description TODO
 * @param {*} window - TODO
 * @param {*} document - TODO
 * @param {*} $ - TODO
 */
((window, document, $) => {

  /**
   * @description TODO
   * @param {string} $arg1 - TODO
   */
  function myFunc($arg1: string = 'value') {}

})(window, document, jQuery);

/**
 * @description TODO
 * @function Person#greet
 * @param {string} arg1 - TODO
 * @param {Immutable.List} arg2 - TODO
 * @return {string[]} TODO
 */
Person.prototype.greet = (arg1: string = 'default', arg2: Immutable.List = Immutable.List()): string[] => {
  //
};

/**
 * @description TODO
 * @function Person#greet
 * @param {string} arg1 - TODO
 * @param {Immutable.List} arg2 - TODO
 * @return {string[]} TODO
 */
Person.prototype.greet = function (arg1: string = 'default', arg2: Immutable.List = Immutable.List()): string[] {
  //
};

/**
 * @description TODO
 * @function Person#greet
 */
Person.prototype.greet = function () {}

/**
 * @description TODO
 * @function perfectSquares
 */
perfectSquares = function*() {
  var num;
  num = 0;
  while (true) {
    num += 1;
    yield num * num;
  }
};

/**
 * @description TODO
 * @function perfectSquares
 */
perfectSquares = async function*() {
  var num;
  num = 0;
  while (true) {
    num += 1;
    yield num * num;
  }
};

/**
 * @description TODO
 * @async
 * @function myFunc
 * @param {*} $arg1 - TODO
 * @param {*} arg2 - TODO
 * @param {*} arg3 - TODO
 * @param {*} arg4 - TODO
 */
var myFunc = async function*($arg1 = 'value', arg2 = [], arg3, arg4) {}

/**
 * @description TODO
 * @async
 * @function myFunc
 * @param {*} $arg1 - TODO
 * @param {*} arg2 - TODO
 * @param {*} arg3 - TODO
 * @param {*} arg4 - TODO
 */
var myFunc = async ($arg1 = 'value', arg2 = [], arg3, arg4) => {}

/**
 * @description TODO
 * @param {string} $arg1 - TODO
 * @param {Foo|Bar|Baz} arg2 - TODO
 * @return {Foo|Bar} TODO
 */
/**
 * @description TODO
 * @param {string} $arg1 - TODO
 * @param {Foo|Bar|Baz} arg2 - TODO
 * @return {Foo|Bar} TODO
 */
function myFunc($arg1: string, arg2: Foo | Bar | Baz): (Foo | Bar) {}

/**
 * @description TODO
 * @function Person#greet
 */
Person.prototype.greet = () => {}

/**
 * @description TODO
 * @function myFunc
 * @param {*} $arg1 - TODO
 * @param {*} arg2 - TODO
 * @param {*} arg3 - TODO
 * @param {*} arg4 - TODO
 */
var myFunc = function($arg1 = 'value', arg2 = [], arg3, arg4) {}

/**
 * @description TODO
 * @function myFunc
 * @param {string} $arg1 - TODO
 * @param {string[]} arg2 - TODO
 * @param {number} arg3 - TODO
 * @param {float} arg4 - TODO
 * @return {string[]} TODO
 */
var myFunc = function($arg1: string = 'value', arg2: string[] = [], arg3: number, arg4: float): string[]  {}

/**
 * @description TODO
 * @param {*} arg1 - TODO
 */
function myFunc(arg1) {
  var a = 2;
}

var myObj = {
  myFunc: function() {
    /**
     * @description TODO
     * @param {string} arg1 - TODO
     * @param {Immutable.List} arg2 - TODO
     */
    function(arg1: string = 'default', arg2: Immutable.List = Immutable.List()) {
      var a = 2;
    };

    /* This function should be ignored by DoGe because of the 'return' prefix */
    return function() {
      //
    }
  },
};

// =============================================================================
//
// Node & ES6

// =============================================================================

/**
 * @description TODO
 * @function user
 * @param {*} arg1 - TODO
 */
const user = (arg1 = 'default') => (subarg1, subarg2 = 'default') => 5;

/**
 * @description TODO
 * @function
 * @param {string} arg1 - TODO
 * @param {int} arg2 - TODO
 * @param {*} arg3 - TODO
 * @param {Immutable.List} arg4 - TODO
 * @param {string[]} arg5 - TODO
 * @param {float} arg6 - TODO
 * @return {number[]} TODO
 */
(arg1: string = 'default', arg2: int = 5, arg3, arg4: Immutable.List = [], arg5: string[] = [], arg6: float = 0.5): number[] => { };

/**
 * @description TODO
 * @function user
 * @param {string} arg1 - TODO
 * @param {int} arg2 - TODO
 * @param {*} arg3 - TODO
 * @param {Immutable.List} arg4 - TODO
 * @param {string[]} arg5 - TODO
 * @param {float} arg6 - TODO
 * @return {number[]} TODO
 */
const user = (arg1: string = 'default', arg2: int = 5, arg3, arg4: Immutable.List = [], arg5: string[] = [], arg6: float = 0.5): number[] => { };

const myObj = {
  myFunc: () => {
    return () => {
      //
    },
  },

  /**
   * @description TODO
   * @param {string} arg1 - TODO
   * @param {int} arg2 - TODO
   * @return {string} TODO
   */
  myFunc(arg1: string, arg2: int = 5): string {
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
 * @description TODO
 * @param {any} one - TODO
 * @param {any} two - TODO
 * @return {number} TODO
 */
function add(one: any, two: any = 'default'): number {}

// =============================================================================
//
// Typescript (iirc, if we fix flowjs, we also fix typescript and vice-versa.)
//
// =============================================================================
const bar: number = 2;
let foo: number = 1;
let sn: string | null = "bar";
let Easing = "ease-in" | "ease-out" | "ease-in-out" = "ease-in";

/**
 * @description TODO
 * @function
 * @param {array} arg1 - TODO
 */
(arg1: array = []) => (arg2: string) => { console.log(5); }

/**
 * @description TODO
 * @param {History} history - TODO
 * @param {object} initialState - TODO
 * @return {Store<AppState>} TODO
 */
export function configureStore(history: History, initialState: object): Store<AppState> {}

/**
 * @description TODO
 * @param {History} history - TODO
 * @param {object} initialState - TODO
 * @return {Store} TODO
 */
function configureStore(history: History, initialState: object): Store {}

/**
 * @description TODO
 * @param {History} history - TODO
 * @param {object} initialState - TODO
 * @return {Store<AppState>} TODO
 */
function configureStore(history: History, initialState: object): Store<AppState> {}

/**
 * @description TODO
 * @function configureStore
 * @param {History} history - TODO
 * @param {object} initialState - TODO
 * @return {Store<AppState>} TODO
 */
const configureStore = (history: History, initialState: object): Store<AppState> => {}

/**
 * @description TODO
 * @return {1|2|3|4|5|6} TODO
 */
function rollDice(): 1 | 2 | 3 | 4 | 5 | 6 {}

/**
 * @description TODO
 * @return {1|2|3|4|5|6} TODO
 */
function rollDice(): (1 | 2 | 3 | 4 | 5 | 6) {}

/**
 * @description TODO
 * @param {T} o - TODO
 * @param {K[]} names - TODO
 * @return {T[K][]} TODO
 */
function pluck<T, K extends keyof T>(o: T, names: K[]): T[K][] {}

/**
 * @description TODO
 * @param {Fish|Bird} pet - TODO
 * @param {[User]} users - TODO
 * @return {[User, Fish]} TODO
 */
function isFish(pet: Fish | Bird, users: [User]): [User, Fish] {}

/**
 * @description TODO
 * @param {any} x - TODO
 * @return {x is number} TODO
 */
function isNumber(x: any): x is number {}

/**
 * @description TODO
 * @function
 * @param {int} arg1 - TODO
 */
(arg1: int = 5) => { console.log(5); }

/**
 * @description TODO
 * @function
 * @param {array} arg1 - TODO
 * @return {Sequence[T]} TODO
 */
(arg1: array = []): Sequence[T] => { console.log(5); }

/**
 * @description TODO
 * @function
 * @param {array} arg1 - TODO
 * @return {Sequence[undefined, Sequnence[T], None, 5]} TODO
 */
(arg1: array = []): Sequence[undefined, Sequnence[T], None, 5] => { console.log(5); }

/**
 * @description TODO
 * @function user1
 * @param {array} arg1 - TODO
 * @return {Sequence[undefined, Sequnence[T], None, 5]} TODO
 */
const user1 = (arg1: array = []): Sequence[undefined, Sequnence[T], None, 5] => { console.log(5); }

let user2 = (arg1: array = []): Sequence[undefined, Sequnence[T], None, 5] => { console.log(5); }

/**
 * @description TODO
 * @function user3
 * @param {array} arg1 - TODO
 * @return {Sequence[undefined, Sequnence[T], None, 5]} TODO
 */
var user3 = (arg1: array = []): Sequence[undefined, Sequnence[T], None, 5] => { console.log(5); }

/**
 * @description TODO
 * @function $_123user3
 * @param {array} arg1 - TODO
 * @return {x is number} TODO
 */
const $_123user3 = (arg1: array = []): x is number => { console.log(5); }

/**
 * @description TODO
 * @function rollDice
 * @param {array} arg1 - TODO
 * @return {1|2|3|4|5|6} TODO
 */
const rollDice = (arg1: array = []): 1 | 2 | 3 | 4 | 5 | 6 => { console.log(5); }

/**
 * @description TODO
 * @function rollDice
 * @return {1|2|3|4|5|6} TODO
 */
const rollDice = (): 1 | 2 | 3 | 4 | 5 | 6 => { console.log(5); }

/**
 * @description TODO
 * @function myFunc
 * @param {*} children - TODO
 * @return {PropTypes.Element|null} TODO
 */
const myFunc = ({ children }): (PropTypes.Element | null) => (
  <div>...</div>
);

/**
 * @description TODO
 * @function myFunc
 * @param {*} children - TODO
 */
const myFunc = ({ children }) => {
  <div>...</div>
};

/**
 * @description TODO
 * @function rollDice
 * @param {array} arg1 - TODO
 * @return {1|2|3|4|5|6} TODO
 */
const rollDice = (arg1: array = []): (1 | 2 | 3 | 4 | 5 | 6) => { console.log(5); }

/**
 * @description TODO
 * @function rollDice
 * @return {1|2|3|4|5|6} TODO
 */
const rollDice = () : (1 | 2 | 3 | 4 | 5 | 6) => { console.log(5); }

/**
 * @description TODO
 * @function add
 * @param {number} b - TODO
 * @return {number|Fish} TODO
 */
const add = (b: number): number | Fish => { console.log(5); }

/**
 * TODO
 * @implements Padder
 */
class SpaceRepeatingPadder implements Padder {
  /**
   * @description TODO
   * @param {number} numSpaces - TODO
   */
  constructor(private numSpaces: number) { }

  /**
   * @description TODO
   * @return {string} TODO
   */
  getPaddingString(): string {
    return Array(this.numSpaces + 1).join(" ");
  }
}

/**
 * TODO
 */
class Adder {
  /**
   * @description TODO
   * @function constructor
   * @param {number} a - TODO
   */
  constructor = (public a: number) => {}

  /**
   * @description TODO
   * @function add
   * @param {number} b - TODO
   * @return {number} TODO
   */
  add = (b: number): number => {
    return this.a + b;
  }
}

/**
 * TODO
 */
class Child {}

/**
 * TODO
 */
export class Child {}

/**
 * TODO
 * @extends Parent
 */
class Child extends Parent {}

/**
 * TODO
 * @extends Parent
 */
export class Child extends Parent {}

/**
 * TODO
 * @implements CustomInterfaceName
 */
class Child implements CustomInterfaceName {}

/**
 * TODO
 * @implements CustomInterfaceName
 */
export class Child implements CustomInterfaceName {}

/**
 * TODO
 * @extends Parent
 * @implements CustomInterfaceName
 */
class Child extends Parent implements CustomInterfaceName {}

/**
 * TODO
 * @extends Parent
 * @implements CustomInterfaceName
 */
export class Child extends Parent implements CustomInterfaceName {}

/**
 * @description TODO
 * @function myFunc
 * @param {string} $arg1 - TODO
 * @param {string[]} arg2 - TODO
 * @param {number} arg3 - TODO
 * @param {float} arg4 - TODO
 * @return {string[]} TODO
 */
const myFunc = ($arg1: string = 'value', arg2: string[] = [], arg3: number, arg4: float): string[]  {}

/**
 * TODO
 * @extends Parent
 */
class Child extends Parent {
  /**
   * @description TODO
   * @param {number} b - TODO
   */
  myMethod(public b: number) {
    return this.add(b);
  }

  /**
   * @description TODO
   * @function myMethod
   * @param {number} b - TODO
   */
  myMethod = (b: number) => {
    return this.add(b);
  }

  /**
   * @description TODO
   * @param {number} b - TODO
   * @return {number} TODO
   */
  myMethod({ b: number }): number {
    return this.add(b);
  }

  /**
   * @description TODO
   * @function myMethod
   * @param {number} b - TODO
   */
  myMethod = ({ b: number }) => {
    return this.add(b);
  }
}
