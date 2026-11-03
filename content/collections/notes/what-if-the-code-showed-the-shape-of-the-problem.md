---
title: "What if the code showed the shape of the problem?"
description: "Introducing M: a functional language design exploring how pipelines, tuples, pattern matching, and effects can reveal the structure of a computation."
published: 2026-11-03
tags: Programming, Software Design, Readability, Functional Programming, Types
---

# What if the code showed the shape of the problem?

*Introducing M, an experiment in functional language design.*

When I read a program, I often find myself doing two jobs.

First, I read what each line does. Then I reconstruct how those lines fit together: which calculations depend on earlier results, which are independent, where alternatives join, and when the program interacts with the outside world.

Good names and small functions help. So do familiar conventions. But I’m interested in whether the language itself could do more to reveal those relationships.

That is the experiment behind M:

**The structure of a program should resemble the structure of the problem it solves.**

Let’s start with JavaScript, then follow the same problems into M: a sequence of transformations, a calculation that branches, a choice between alternatives, and a computation that reaches outside the program.

## Sometimes the shape is already there

Suppose we want the sum of the squares of positive numbers.

JavaScript’s array methods give us a direct description of the work:

```js
const positiveSquaresTotal = numbers =>
  numbers
    .filter(n => n > 0)
    .map(n => n * n)
    .reduce((a, b) => a + b, 0)

positiveSquaresTotal([-2, 0, 3, 4])
// 25
```

M uses the same sequence, expressed through a forward pipe:

```m
// List.keep, List.map, and List.fold are standard-library functions.
positiveSquaresTotal numbers =
  numbers
  |> List.keep (n -> n > 0)
  |> List.map (n -> n * n)
  |> List.fold ((a, b) -> a + b, 0)

positiveSquaresTotal [-2, 0, 3, 4]
// 25
```

Both versions read in the order the work happens: keep positive values, square each one, then add the results. Each stage prepares the input for the next.

### Turning an expression outward

In JavaScript, `f(x)` applies `f` to `x`. M writes that application as `f x`, and the pipe gives us another reading direction: `x |> f`.

<figure><img src="/assets/diagrams/m-function-application.svg" alt="JavaScript f(x), M f x, and M x pipe f apply the same function to a value." width="760" height="180" loading="lazy" style="display:block;width:100%;height:auto"></figure>

The advantage becomes clearer as functions accumulate. Instead of reading a nested expression from the inside outward, we can read the data moving forward:

```js
const transform = text => text.trim()
const validate = text => text.length > 0 ? text : "Guest"
const format = name => `Hello, ${name}!`

format(validate(transform("  Ada  ")))
// "Hello, Ada!"
```

```m
transform text = text |> String.trim

validate =
  match
    "" -> "Guest"
    text -> text

format name = String.join "" ["Hello, ", name, "!"]

"  Ada  "
|> transform
|> validate
|> format
// "Hello, Ada!"
```

Here the helpers trim text, substitute "Guest" for an empty name, and build a greeting. Each M stage receives the whole preceding value. A stage can change its shape: text can become a record, a record can become a list, and a list can become one number.

### Tuples are inputs too

Look again at the fold:

```m
sum = List.fold ((a, b) -> a + b, 0)

sum [2, 4, 6, 8]
// 20
```

In the fold expression, there are two pairs. The outer pair contains the combining function and its starting value. The inner `(a, b)` is a **tuple pattern**: it unpacks the one pair passed to the combining function—accumulator first, current element second.

JavaScript’s `(a, b) => a + b` declares two parameters. M’s `(a, b) -> a + b` receives one tuple and gives its two components names. The punctuation looks similar, but the input model differs.

Parentheses in M group an expression; a comma makes a tuple. That distinction lets ordinary functions consume structured results later, without another recombination construct.

`List.fold` receives its configuration pair and returns a function waiting for the list. Similarly, `List.map square` returns a function waiting for a list. These library interfaces deliberately fit pipelines.

## A sequence of lines can describe a branch

Now consider an average. We need two calculations on the same input, followed by one calculation on their results.

JavaScript can make those parts explicit with local variables:

```js
const average = numbers => {
  const sum = numbers.reduce((a, b) => a + b, 0)
  const count = numbers.length

  return sum / count
}

average([2, 4, 6, 8])
// 5

average([])
// NaN
```

The two local values tell us what the final expression needs. M can instead name the relationship between those calculations:

```m
// Main function; add and checked divide come from the core library.
average numbers =
  numbers
  |> fork
       sum
       List.length
  |> divide

// Local helper; add comes from core, and List.fold and List.length from List.
sum numbers =
  numbers |> List.fold (add, 0)

average [2, 4, 6, 8]
// Ok 5

average []
// Error DivisionByZero
```

`fork` applies both branches to the same input and produces a tuple. The next function consumes that tuple. Here the visible shape is one input, two independent calculations, then recombination.

For `[2, 4, 6, 8]`, the fork produces `(20, 4)` in branch order. Checked `divide` consumes that pair and returns `Ok 5`.

<figure><img src="/assets/diagrams/m-fork-tuple.svg" alt="One list branches into sum and length; the results form (20, 4), passed to divide to produce Ok 5." width="760" height="260" loading="lazy" style="display:block;width:100%;height:auto"></figure>

The branch structure is explicit in the code. Both branches receive the original list; neither needs the other branch’s result. `fork` describes that dependency shape. Concurrent execution is a separate choice, which we’ll reach later.

The checked M version also makes an outcome visible: `Ok` carries a successful value, and `Error` carries a failure. JavaScript can represent the same alternatives with tagged objects:

```js
const average = numbers => {
  const sum = numbers.reduce((a, b) => a + b, 0)
  return divide(sum, numbers.length)
}

const divide = (a, b) => b === 0
  ? { kind: "Error", error: "DivisionByZero" }
  : { kind: "Ok", value: a / b }

average([2, 4, 6, 8])
// { kind: "Ok", value: 5 }

average([])
// { kind: "Error", error: "DivisionByZero" }
```

Our first JavaScript average used numeric `/`, so its empty-list result is `NaN`. This second version matches the checked contract of M’s core `divide`. The M version returns `Error DivisionByZero` for an empty list.

## Reading from the whole toward the parts

In the M example, `average` appears before `sum`. Top-level definitions can refer to functions declared later, allowing the source to introduce the overall operation before its lower-level details.

That reading order is part of the experiment: the main problem can appear first, followed by the machinery that supports it.

JavaScript’s `const` functions can also be arranged this way, provided calls happen after the referenced helpers are initialized, as in the checked example above. M aims to make top-level function reference independent of source order rather than depend on initialization timing.

There is another small visual relationship worth noticing:

```m
// The positiveSquaresTotal definition above.
positiveSquaresTotal [-2, 0, 3, 4]
// 25
```

In the definition `positiveSquaresTotal numbers = …`, the actual input occupies the same position as the parameter when we call the function. Substitute the list for `numbers` in the body and we have a concrete expression:

```m
[-2, 0, 3, 4]
|> List.keep (n -> n > 0)
|> List.map (n -> n * n)
|> List.fold ((a, b) -> a + b, 0)
// 25
```

For this pure computation, the call can also be replaced with its value, `25`, without changing the program’s behaviour.

The definition and call have a useful symmetry: the input occupies the place of the parameter. Following a pure computation becomes a matter of substituting the input and following its transformations.

### Giving a boundary a name

Once we understand the implementation, a type signature can summarize its boundary:

```m
positiveSquaresTotal : List Number -> Number
positiveSquaresTotal numbers =
  numbers
  |> List.keep (n -> n > 0)
  |> List.map (n -> n * n)
  |> List.fold ((a, b) -> a + b, 0)

positiveSquaresTotal []
// 0
```

Read that as “a list of numbers goes in; one number comes out.” The annotation is optional: M infers types, and an explicit annotation must agree with the definition. Here it also explains why an empty list still returns a number: the fold starts at `0` and has no elements to add.

The signature tells us the shape at the boundary. The pipeline tells us how the value gets there.

## Alternatives have a shape too

A user can have one of several account states. JavaScript can represent those states with tagged objects and choose a response with `switch`:

```js
const describe = status => {
  switch (status.kind) {
    case "Active": return "Welcome"
    case "Inactive": return "Reactivate"
    case "Suspended": return "Contact support"
  }
}

describe({ kind: "Suspended", reason: "Payment overdue" })
// "Contact support"
```

M declares the alternatives and matches their shapes:

```m
type Status =
  Active
  Inactive
  Suspended String

describe =
  match
    Active -> "Welcome"
    Inactive -> "Reactivate"
    Suspended _ -> "Contact support"

describe (Suspended "Payment overdue")
// "Contact support"
```

`Suspended String` associates a reason with that alternative. `_` says the reason exists but this function does not need it. Because `match` produces a function, the alternatives themselves can be the definition of `describe`.

The shape of the data and the shape of the decision sit next to each other. M’s static checker can require a response for every alternative; plain JavaScript’s `switch` depends on the programmer covering the tags. TypeScript can add static checking to a tagged-union design as well. These are different guarantees around a shared way of modeling the problem.

## Names reveal domain structure

Records let us describe several facts together. A structural record function needs the fields it uses, rather than a particular declared record name.

```js
const activeNames = users =>
  users.filter(user => user.active).map(user => user.name)

activeNames([
  { name: "Ada", active: true },
  { name: "Lin", active: false }
])
// ["Ada"]
```

```m
// .active and .name are field-projection functions.
activeNames users =
  users
  |> List.keep .active
  |> List.map .name

activeNames [
  { name: "Ada", active: true },
  { name: "Lin", active: false }
]
// ["Ada"]
```

`.active` means `user -> user.active`. The projection makes the relationship concise: retain users by their active field, then project their names. `List.keep` requires a Boolean predicate, so `active` must be Boolean in this use.

A module can expose that operation with `export` while keeping its helpers private:

```m
export activeNames users =
  users
  |> List.keep .active
  |> List.map .name

activeNames [
  { name: "Ada", active: true },
  { name: "Lin", active: false }
]
// ["Ada"]
```

This is another level of structure. A pipeline exposes a computation, a function names a useful piece of it, and a module chooses the boundary other code can depend on.

These shapes recur: a sequence, branches sharing an input, alternatives selected by a value, and named boundaries around a coherent operation. Effects introduce another relationship: some stages must wait for work outside the pure computation.

## When a decision requires the outside world

Pure arithmetic is a useful laboratory, but applications also read files, contact services, and wait for responses.

Consider a cached price. If it is fresh, use it. If it is expired, fetch a replacement. Validate the amount, then apply a discount and tax.

JavaScript’s `async` functions express this naturally:

```js
const total = async cachedPrice => {
  const price = await ensurePrice(cachedPrice)
  const discounted = price * 0.9
  return discounted * 1.08
}

const ensurePrice = async cachedPrice => {
  const amount = cachedPrice.kind === "Fresh"
    ? cachedPrice.amount
    : await api.fetchPrice(cachedPrice.itemId)

  if (amount < 0) {
    throw new Error("Invalid price")
  }

  return amount
}

// For this call, the API adapter resolves to 100.
try {
  const amount = await total({ kind: "Expired", itemId: "item-42" })
  console.log(amount)
} catch (error) {
  console.error("Could not calculate the total:", error)
}
// Logs: 97.2

try {
  await total({ kind: "Fresh", amount: -1 })
} catch (error) {
  console.error("Could not calculate the total:", error.message)
}
// Logs: Could not calculate the total: Invalid price
```

Here `api.fetchPrice` is an application-provided adapter that resolves to a finite price or rejects on failure. The caller handles the rejected computation with `try` / `catch`; the `await` inside the `try` makes both fetch failures and our invalid-price error reach that handler.

That is a valid error-handling strategy. Its contract is not expressed by the JavaScript function’s type: a caller must know to handle rejection, and an unhandled path can survive until runtime. M takes a different approach by including expected failures in the effect’s type. Static typing makes those failure cases available to the compiler and caller; it does not automatically decide how the application should recover.

In M’s effect-value model, we describe the work, including its possible failures, before executing it:

```m
type Price =
  Fresh Number
  Expired String

type AppError =
  FetchFailed ApiError
  InvalidPrice

// Main computation.
total cachedPrice =
  cachedPrice
  |> ensurePrice
  |> Effect.flatMap validatePrice
  |> Effect.map (price -> price * 0.9)
  |> Effect.map (price -> price * 1.08)

// Lower-level decisions.
ensurePrice =
  match
    Fresh amount -> Effect.of amount
    Expired itemId ->
      Api.fetchPrice itemId
      |> Effect.mapError FetchFailed

validatePrice =
  match
    amount if amount >= 0 -> Effect.of amount
    _ -> Effect.fail InvalidPrice

// For this call, the API adapter supplies 100 when executed.
total (Expired "item-42")
// Constructs an effect; when executed: Succeeded 97.2

total (Fresh (-1))
// Constructs an effect; when executed: Failed (Error InvalidPrice)
```

The execution-result comments use the proposed runtime outcome names `Succeeded` and `Failed`; the function call itself returns a dormant effect description.

`Api.fetchPrice` is the corresponding application adapter returning `Effect ApiError Number`. `FetchFailed` translates its error into our application’s `AppError`; `InvalidPrice` represents the validation failure.

The operations spell out their roles: `Effect.of` describes an existing successful value, `Effect.fail` describes a failure, and `Effect.mapError` translates an error. The runtime executes the completed description at the application boundary. Calling the JavaScript async function starts executing it; constructing the M effect describes the work to be run.

The M pipeline distinguishes the kinds of steps:

- `ensurePrice` selects a source for the value.
- `Effect.flatMap validatePrice` selects a succeeding or failing effect.
- `Effect.map` applies a pure transformation to a successful value.

A failure skips the later success stages. Constructing the description performs no request.

## Independent work deserves a different shape

If several requests are independent, sequential composition would hide that fact. JavaScript offers an explicit way to express their concurrency:

```js
// Example adapter responses: /greeting -> "Hello", /farewell -> "Goodbye".
const urls = ["/greeting", "/farewell"]
const requests = urls.map(url => api.getText(url))

await Promise.all(requests)
// ["Hello", "Goodbye"]
```

Assume `api.getText` is an application adapter returning a promise for text. Calling it may start work as the list is constructed.

M builds a concurrent description:

```m
// Same example adapter responses as the JavaScript version.
["/greeting", "/farewell"]
|> List.map Api.getText
|> Effect.all
// Constructs an effect; when executed: Succeeded ["Hello", "Goodbye"]
```

Here `Api.getText` is the equivalent adapter returning an effect description. `Effect.all` accepts a homogeneous list of effects and returns an effect producing their results in input order. Work begins when the description is executed.

The proposed failure contract also differs: unfinished siblings are canceled and their cleanup is awaited. `Promise.all` does not itself cancel its remaining inputs. That cancellation policy belongs to the effect combinator, making the lifetime of the child operations part of its contract.

This distinction matters to M’s philosophy. Dependent work, independent work, and alternatives are different computational relationships. A useful vocabulary should let us express each deliberately.

## What the experiment still has to earn

M is an exploratory design, without a compiler or a selected runtime target. The effects and concurrency APIs in this article describe the direction under investigation, rather than an implemented system. In particular, composing infallible effects with fallible ones still needs a formal typing rule. Resource lifetimes, cancellation, and cleanup failures need precise contracts and practical tests.

The numeric model is also open. M currently distinguishes numeric `/` from checked `divide`, with operator division by zero provisionally returning zero. Precision and rounding need further work; the discount and tax examples illustrate dependencies rather than a production monetary policy.

A static type system can check the contracts we express. It cannot guarantee that a service is available, that an algorithm is correct, or that a caller has chosen useful recovery behaviour. Comparisons with JavaScript need to distinguish its dynamic typing from the structure it can express, and account for the extra guarantees TypeScript or runtime validation can provide.

M borrows established functional ideas: immutable values, algebraic data types, structural records, pattern matching, higher-order functions, and explicit composition. Substitution and referential transparency are not new discoveries. The experiment is how visibly and consistently the language can put those ideas to work.

The next major milestone is a formal language design proposal. Before then, the examples need to keep challenging the design. Some computations need branches, some need nesting, and some are clearest with intermediate names. A pipe or a fork earns its place when it reveals a useful relationship, rather than merely producing a preferred visual style.

The question is whether M can offer a small, coherent set of choices that helps us spend less effort reconstructing the relationships between operations—and more effort understanding the problem they solve.
