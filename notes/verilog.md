# The Verilog Language

## Modules, Instantiations & Gates

Modules are defined and then can be instantiated as many times as necessary.
Module instantiations can be name and connected differently.
Primitive gates (NAND, OR, XOR, etc) are predefined logic primitives of Verilog.
The gates are connected by nets.

## The 2 Fundamental Datatypes: Nets and Regs

### Nets

Electrical connection between structural entities like gates.
A wire is a type of net.

**Code Conventions**

-	Names must start with a letter.
-	Names can contain numbers, letters and the _ and $ characters.
-	case sensitive.
-	Spaces and tabs are ignored.
-	Comments begin with “//”.

**4 Possible Signal Values**

-	0
-	1
-	z or Z: high-impedance
-	x or X: unknown value


## Logic Circuits Specification

A logic circuit is specified in the form of a module.
A module has inputs and outputs called ports.
The module definition statement gives the module a name and lists its port signals.
The next lines should indicate whether or not those signals are inputs or outputs.
The actual structure is then defined.

### Structural versus Behavioral Specifications

**Structural** specifications involves direct definitions of every individual gate.

**Behavioral** specifications are a more abstracted form of circuit definition.

## Hierarchical Verilog Code

In hierarchical code, there is a top-level module which includes multiple instances of lower-level modules.

### Connecting Two Modules

```verilog
module firstmodule(in1, inN, out1, outN)	// ...module definition...
endmodule
```

```verilog
module secondmodule(in1, inN, out1, outN)// ...module definition...
endmodule
```

```verilog
module topLevelmodule(topIn1, topInN, topOut1, topOutN)
  input topIn1, topInN;
  output topOut1, topOutN;
  wire w1, wN;	// Wire connections!

  // module instantiations.
  firstmodule mod1(in1, inN, w1, wN);
  secondmodule mod2(w1, wN, topOut1, topOutN);
endmodule
```

## Using Vectored Signals

### Vectors

Vectors are multibit representations of signals.
Individual bits can be referred to using an index value in brackets.

Example, from an adder where X and Y are 4-bit inputs, S is the 4-bit output sum, and C is the one-bit carryout:

```verilog
input [3:0] X;
wire [3:1] C;
output [3:0] S;
output C;
```

## Using a Generic Specification

Instead of the 4-bit adder defined above, we want to create an adder of any size, where the size is a given parameter.

Example, an n-bit vector representing a number may be given as (with the parameter declaration:

```verilog
parameter n = 4;
X[n-1:0];	// Creates a vector of 4-bit range [3:0].
```

### The `for` Statement/Loop

The `for` statement is a procedural statement that must be placed inside an `always` block.

As before, any signal assigned a value inside an `always` block must retain this value until it is re-evaluated by changes in the sensitivity variables.

These signals are first declared as `reg` type.

The `for` loops consists of two statements delineated by `begin` and `end`.

Incrementing of the loop variable must be given as` k = k + 1` or `k = k – 1`,
where `k` is declared as an integer, and does not represent a physical connection in the circuit.

### Using the Generate Capability

The `generate` construct allows instantiation statements to be included inside `for` loops and if-else statements.

If a `for` loop is included in the `generate` block, the loop index variable has to be declared of type `genvar`. A `genvar` variable is similar to an integer, but it can only have positive values and must be inside `generate` blocks.

## Nets and Variables in Verilog

A logic circuit is modeled by a collection of interconnected logic elements and/or by procedural statements that describe its behavior.

-	Connections between logic elements are defined using nets.
-	Signals produced by procedural statements are referred to as variables.

### Nets (Wire)

A net represents a circuit node. For synthesis purposes, the only important nets are of type `wire`.

A `wire` connects an output of one logic element to the the input of another logic element.

It can be a scalar that represents a single connection or a vector which represents multiple connections.

Specific connections in a vector are defined by the way the modules are instantiated.

Scalar nets do not have to be declared in the code because Verilog syntax assumes that all signals are nets by default.

Vector nets must be declared as type `wire`.

### Variables

Verilog provides variables to allow a circuit to be described in terms of its behavior. After a variable is assigned a value in a Verilog statement, it retains this value until it is overwritten by a subsequent assignment statement.

Two type of variables: `reg` and `integer`

All signals that are assigned a value using procedural statements must be declared as variables using the `reg` or `integer` keywords.

## Arithmetic Assignment Statements

If we defined the `input` and `output` vectors, the arithmetic assignment statement to represent an n-bit adder is:

```verilog
input [n-1:0] X, Y;
output [n-1:0] S;
S = X + Y;
```

### Concatenate Operator `{ , }`

If `A` is an m-bit vector and `B` is a k-bit vector, then `{A, B}` creates an (m + k)-bit vector comprising `A` as its MS `m` bits and `B` and its LS `k` bits.


## Module Hierarchy in Verilog Code

In the usual case that a module instantiates other modules as subcircuits,
if the instantiated modules include parameters, we can handle them in two ways.

-	The default value of the parameter can be used for each instance.
-	A new value of the parameter can be specified.

For example, if we're creating a circuit that has two adders of type `addern`, where `n` specifies the bit size.

```verilog
addern U1 (...inputs and outputs...)	// First adder module instantiation
addern U2 (...inputs and outputs...)	// Second adder module instantiation

// We can set the bit sizes using the defparam statement.
defparam U1.n = 16;			// Sets sum bitcount to 16
defparam U2.n = 8;			// Sets sum bitcount to 8
```

### `#` Operator

The `#` operator can be used instead of the `defparam` statement.

```verilog
// From the above example, the module instantiations become
addern #(16) U1 (...inputs and outputs...)
addern #(8) U2 (...inputs and outputs...)

// Or, we can even explicitly refer to the parameter being set
addern #(.n(16)) U1 (...inputs and outputs...)
addern #(.n(8)) U2 (...inputs and outputs...)
```

In module instantiation, the port connections can be given in the order in which they are received (in which case, order matters), or, they can be explicitly listed (order does not matter).

We can use the adder examples above, the following instantiations are equivalent:

```verilog
// Ordered Port Associations (Order Matters)
addern #(16) U1 (1'b0, A, B, S[15:0], S[16], o1);

// Named Port Associations (Order Does Not Matter)
addern #(.n(16)) U1
(
  .carryin (1'b0), .X (A), .Y (B),
  .S (S[15:0]), .carryout (S[16]), .overflow (o1)
);
```


# Flip-Flops, Registers and Counters

## Summary of Terminology

### Basic Latch

Feedback connection of two `NOR` gates or two `NAND` gates, which can store one bit of information.

It can be set to 1 using the `S` input and reset to 0 using the `R` input.

### Gated Latch

Latch that includes input gating and a control input signal. The latch retains its existing state when the control input is equal to `0`. Its state may be changed when the control input is equal to `1`.

The control input is usually the clock signal.

#### SR

Uses the `S` and `R` inputs to set the latch to 1 or reset it to 0, respectively.

#### D

Uses the `D` input to force the latch into a state that has the same logic value as the `D` input.

### Flip-Flop

Storage element that can have its output state changed only on the edge of the controlling clock signal.

If the state changes when the clock signal goes from 0 to 1, it is *positive-edge* triggered. If it changes when the clock goes from 1 to 0, it is *negative-edge* triggered.

## Using Verilog Constructs for Storage Elements

Using an if-else with sensitivities for the data and clock input signals, we can specify the module definition of a gated D latch.

```verilog
module D_latch(D, Clk, Q);
  input D, Clk;
  output reg Q;

  always @(D, Clk)
    if(Clk) // Only changes the value of Q if Clk is positive (implied memory)
      Q = D;
endmodule
```

The above code utilizes the notion of *implied memory*. We only specified what the value of `A` should be in the event that `Clk` equals `1`, but not what to do in the event that `Clk` equals `0`. In the absence of an assigned valued, the compiler assumes that the value of the variable does not change.

Rather than being level-sensitive as with the `D` latch definition, we can also create code that is edge-sensitive.

```verilog
module flipflop(D, Clock, Q);
  input D, Clock;
  output reg Q;

  always @(posedge Clock)
    Q = D;
endmodule
```

## Blocking and Non-Blocking Assignments

Be very, very careful! The difference between using blocking and non-blocking assignments can be 2 completely different circuits.

In general, blocking assignments are NOT used when defining sequential circuits.

### Blocking

```verilog
input D, Clock;
output reg Q;
always @(posedge Clock)
  begin
    Q1 = D;
    Q2 = Q1;
  end

// Results in Q1 = D and Q2 = Q1: D = Q1 = Q2
// NOT what you want for two cascaded flipflops.
```

Assignment statements within the always block are evaluated in the order in which they are written.

### Non-Blocking

```verilog
input D, Clock;
output reg Q;
always @(posedge Clock)
  begin
    Q1 <= D;
    Q2 <= Q1;
  end

// Results in Q2 = previous Q1, Q1 = previous D
// Creates 2 cascaded D flipflops!
```

Assignment statements within the `always` block are evaluated using the values that the variables had at the moment the `always` block was entered.

The result of each assignment is not seen until the end of the `always` block.

## Flip-Flops with Clear Capability

### Asynchronous Reset D Flip-Flop

```verilog
module flipflop(D, Clock, Resetn, Q);
  input D, Clock, Resetn;
  output reg Q;
  always @(negedge Resetn, posedge clock)
    if (!Resetn)
      Q <= 0;
    else
      Q <= D;
endmodule
```

### Synchronous Reset D Flip-Flop

```verilog
module flipflop(D, Clock, Resetn, Q);
  input D, Clock, Resetn;
  output reg Q;
  always @(posedge clock)
    if (!Resetn)
      Q <= 0;
    else
      Q <= D;
endmodule
```

# Operators

Type | Operation | Operator Symbol | Number of Operands
|---|---|---|---|
Bitwise | 1's Complement | `~` | 1
Bitwise | AND | `&` | 2
Bitwise | OR | `|` | 2
Bitwise | XOR | `^` | 2
Bitwise | XNOR | `~^` | 2
Bitwise | XNOR | `^~` | 2
Logical | NOT | `!` | 1
Logical | AND | `&&` | 2
Logical | OR | `||` | 2
Reduction | AND | `&` | 1
Reduction | NAND | `~&` | 1
Reduction | OR | `|` | 1
Reduction | NOR | `~|` | 1
Reduction | XOR | `^` | 1
Reduction | XNOR | `~^` | 1
Arithmetic | Addition | `+` | 2
Arithmetic | Subtraction | `-` | 2
Arithmetic | 2's Complement | `-` | 1
Arithmetic | Multiplication | `*` | 2
Arithmetic | Division | `/` | 2
Relational | Greater than | `>` | 2
Relational | Less than | `<` | 2
Relational | Greater than or equal to | `>=` | 2
Relational | Less than or equal to | `<=` | 2
Logical | Equality | `==` | 2
Logical | Inequality | `!=` | 2
Shift | Right | `>>` | 2
Shift | Left | `<<` | 2
Special | Concatenation | `{ , }` | Any number
Special | Replication | `{{}}` | Any number
Special | Conditional | `?:` | 3

# Structures

```verilog
assign y = // operation...
```

Provides a continuous assignment for the signal `y`. Whenever any signal on the right-hand side changes state, the value of `y` is re-evaluated. Assignment statements are all evaluated concurrently!

---

```verilog
if (conditional_expression)
  statement;
else if (conditional_expression)
  statement;
else
  statement;
```

If more than one statement per `if` or `else`, then `begin` and `end` must be used as delineators.

---

```verilog
case (expression)
  alternative1: statement;
  …
  alternativeN: statement;
  [default: statement;]
endcase
```

The value of the controlling expression and alternatives are compared bit by bit.

- `casex`	Treats all z and x values as don't cares.
- `casez`	Treats all z values as don't cares.

---

```verilog
for (init_index; end_index; inc)
  statement;
```

The loop control variable must be declared as an integer!

---

```verilog
task taskName;
  // ...block of statements...
endtask
```

The `task` must be included in the `module` that calls it.

It may contain `input` and `output` ports. These are not the ports of the module that contain the `task`, which are used to make external connections to the module. The `task` ports are used only to pass values between the module and tasks.

A `task` can call another `task` or a function.

---

```verilog
function functionName;
  // ...block of statements...
endfunction
```

The `function` must have at least one keyword and it returns a single value that is placed where the `function` is invoked.

A `function` can invoke another `function` but it cannot call a `task`. Some tools require functions to be defined before the statements that invoke them, but it's usually not required.


## Procedural Statements

Must be contained in an `always` block! These mostly derive from use in simulation. If a signal is assigned a value using procedural statements, then it must be declared as a variable using the `reg` statement.

# Number Notation

## Syntax

```
[size]'[signed][radix]value
```

### `size`

Number of binary bits comprising the number, 32 is default.

### `signed`

Indicates sign, default is unsigned.

Possible values:
- `s` or `S`: signed
- Blank: unsigned

### `radix`

Radix of the number, default is decimal.

Possible values:
- `'b` or `'B`: binary
- `'o` or `'O`: octal
- `'h` or `'H`: hex
- `'d` or `'D`: decimal

### `value`

Value or representation of number.

Possible values:
- `x` or `X`: unknown value
- `z` or `Z` or `?`: high impedance
- `?`: don't care
