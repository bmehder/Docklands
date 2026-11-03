---
title: "The Unnecessary Mental Work of Programming"
description: "Mutable state, asymmetric syntax, nesting, and indirection: how programming makes us reconstruct context, and how notation can reduce mental bookkeeping."
published: 2026-10-31
tags: Programming, Software Design, Readability, Functional Programming, Types
featured_image: /assets/images/note-unnecessary-mental-work.webp
featured_alt: An amber thread passes through tangled teal glass frames and emerges into a clear sequence
---

# The Unnecessary Mental Work of Programming

{{ featured-image }}

Mental bookkeeping connects several important ideas in programming language design, cognitive science, and functional programming. Three distinct sources of cognitive difficulty are:

1. Mutable state: The meaning of an expression can depend on what happened earlier.
2. Asymmetric syntax: The visual structure of an expression doesn't necessarily reflect its conceptual structure.
3. Nesting: Understanding an expression requires keeping several incomplete expressions in your head simultaneously.

There's a useful distinction here: complexity in what a program does versus complexity in how a program is represented.

Mutable state primarily affects the former. Syntax and nesting primarily affect the latter. But all three can increase the mental work required to understand a program.

Some influential language designers and researchers have explored remarkably similar ideas.

## Remembering the Past

### Mutable state: Referential transparency and local reasoning

This is probably the most established of the three ideas.

Consider:

```js
let total = 10

function add(n) {
  total += n
  return total
}
```

To understand `add(5)`, you need to know the history of `total`.

Compare that with:

```js
const add = (a, b) => a + b
```

Now the meaning of the function is contained in its inputs and definition.

This is the motivation behind referential transparency, one of the foundations of functional programming.

John Backus addressed related problems in his 1977 Turing Award lecture, [Can Programming Be Liberated from the von Neumann Style?](https://research.ibm.com/publications/can-programming-be-liberated-from-the-von-neumann-style-a-functional-style-and-its-algebra-of-programs) He criticized conventional programming's reliance on changing state and proposed a function-oriented alternative.

The idea fits comfortably within that tradition: reducing the amount of historical information a programmer must retain makes local reasoning easier.

But the next two observations concern something different, and potentially more interesting: the visual grammar of programming.

## Keeping Track of Where We Are

### Nesting: The cognitive dimensions of notations

This is where these observations have perhaps their closest match in academic research.

Thomas Green and Marian Petre developed the Cognitive Dimensions of Notations framework, which examines how different representations affect the mental effort required to use them.

Some particularly relevant dimensions are:

<div class="article-table"><table><thead><tr><th scope="col">Dimension</th><th scope="col">Connection to cognitive difficulty</th></tr></thead><tbody><tr><td>Hard mental operations</td><td>How much information must be mentally processed?</td></tr><tr><td>Hidden dependencies</td><td>How difficult is it to discover what affects what?</td></tr><tr><td>Closeness of mapping</td><td>Does the representation resemble the conceptual problem?</td></tr><tr><td>Visibility</td><td>Can the relevant information be seen together?</td></tr><tr><td>Viscosity</td><td>How difficult is it to change the representation?</td></tr></tbody></table></div>

Their 1996 paper, [Usability Analysis of Visual Programming Environments](https://doi.org/10.1006/jvlc.1996.0009), is especially relevant.

For example, compare:

```js
const result = a(b(c(d(e(value)))))
```

With:

```js
const result = pipe(
  value,
  e,
  d,
  c,
  b,
  a
)
```

The second representation exposes the order of operations without requiring you to mentally unwind nested expressions.

Interestingly, [a 2025 paper comparing block-based and data-flow programming](https://academic.oup.com/iwc/article/38/1/40/8151473) explicitly identifies untangling nested expressions as a hard mental operation.

That is remarkably close to the nesting problem described here.

### Peter Landin and the off-side rule (1966)

In [The Next 700 Programming Languages](https://homepages.inf.ed.ac.uk/wadler/papers/papers-we-love/landin-next-700.pdf), Peter Landin introduced the off-side rule, which uses indentation to communicate syntactic structure.

This idea influenced languages such as Haskell and, indirectly, the layout conventions familiar from Python and other languages.

Instead of requiring explicit delimiters everywhere, indentation itself can establish boundaries.

That suggests a related principle: the visual arrangement of a program should help reveal its grammatical structure.

There is a tradeoff, though. Explicit closing tags can improve boundary recognition while increasing verbosity. Indentation can reduce punctuation but make correct alignment more important.

## Reading Code Backwards

### Asymmetric syntax: Does the shape of code affect comprehension?

The shape of function syntax deserves some attention.

Consider:

```js
const result = transform(validate(parse(input)))
```

The conceptual sequence—the order in which the data is transformed—is:

```text
input → parse → validate → transform
```

But the source code makes us read inward before working outward.

The function names and their arguments are also arranged asymmetrically. The function name sits on the left, while its arguments extend to the right. As calls are nested, those arguments contain more expressions, and the visual weight becomes heavier on that side. We have to mentally compensate when reading it—almost as though we need to tilt our heads to the left to balance the code.

<figure class="syntax-weight"><img src="/assets/diagrams/function-call-weight.svg" alt="Three function calls align at their opening parentheses; the argument expression grows to the right as calls are nested." width="800" height="424" loading="lazy"></figure>

The parentheses match. The question is whether the notation gives us a useful visual balance: structural symmetry, or visual correspondence.

Compare this with HTML:

```html
<article>
  <section>
    <p>Hello</p>
  </section>
</article>
```

HTML is still nested, but it gives us explicit opening and closing boundaries. The closing tags even repeat the names of the structures they terminate, whereas ordinary function calls use an anonymous `)`.

A question worth exploring is whether structural symmetry is independently valuable, or whether its apparent benefits are explained by explicit boundaries, locality, and reduced working-memory demands.

### A hierarchy of expressions, a sequence of operations

There is another difference between the two examples. In the markup, the paragraph belongs to the section, and the section belongs to the article. The nesting expresses containment.

In `transform(validate(parse(input)))`, the inner calls are syntactically subexpressions of the outer call. But that doesn't make parsing conceptually a subdivision of validation, or validation a subdivision of transformation. Here, they are stages in a sequence: one operation produces the input for the next.

The syntax presents that sequence as a hierarchy of expressions. We have to recover the sequence from the hierarchy.

### Pipes: Someone articulated almost exactly this argument

A pipe makes that sequence visible directly. In Gleam:

```gleam
input
|> parse
|> validate
|> transform
```

There are two distinct benefits.

First, nesting disappears. Every transformation occupies the same syntactic level.

Second, the written order matches the conceptual order. We read the program in the direction that the data flows.

This is arguably more important than merely reducing parentheses.

One particularly striking source is [SRFI 197: Pipeline Operators](https://srfi.schemers.org/srfi-197/srfi-197.html), a Scheme language proposal finalized in 2020. Its rationale explicitly identifies deeply nested expressions, excessive indentation, and parenthesis-matching errors as problems that pipeline operators address. It also notes that expressing operations in their natural sequence can make them easier to read.

A pipe doesn't eliminate functional composition; it changes how composition is presented. The operations remain the same, but the notation does more of the work of showing how they fit together.

## The Treasure Hunt

### Indirection makes us navigate instead of understand

Indirection introduces spatial distance.

Consider:

```js
const result = processOrder(order)
```

Nothing complicated here.

Until you discover that `processOrder` calls `validateOrder`, which calls `getValidationRules`, which loads a configuration, which delegates to a registered validator.

And now you're six files away from the code you were trying to understand.

There's an important distinction between abstraction and indirection.

Abstraction can reduce mental work by hiding details that aren't relevant.

Indirection can increase mental work when it forces us to chase details that are relevant.

The problem isn't the number of functions. It's the number of boundaries we must cross to understand the behavior we're investigating.

This connects to David Parnas's 1972 paper, [On the Criteria To Be Used in Decomposing Systems into Modules](https://www.cs.lafayette.edu/~gexia/cs301/resources/parnas.html). Parnas made a powerful case for information hiding, but the underlying lesson isn't that more modules are automatically better.

A good boundary hides a decision we don't need to know. A poor boundary makes us go looking for information that should have been nearby.

This also connects to local reasoning: the extent to which we can understand one piece of a program without understanding the entire system.

## Turning Decisions into Data

### Matching two values simultaneously

A conventional nested decision might look like this:

```js
switch (direction) {
  case "Next":
    switch (selected) {
      case "View":
        return "ModelAndUpdate"
      case "ModelAndUpdate":
        return "Effects"
      case "Effects":
        return "View"
    }
}
```

But Gleam can match on two values simultaneously:

```gleam
case direction, selected {
  Next, View -> ModelAndUpdate
  Next, ModelAndUpdate -> Effects
  Next, Effects -> View
}
```

The difference isn't just fewer lines or braces.

We've transformed a hierarchy of decisions into a table of relationships.

That's significant. The programmer no longer needs to mentally maintain the context of an outer branch while examining an inner one.

And this isn't uniquely Gleam. Languages with tuple pattern matching, such as Haskell, Rust, and F#, can express similar relationships.

Even JavaScript can approximate the idea with a lookup table.

### Pattern matching makes possibilities visible

Consider:

```js
if (status === "loading") {
  // ...
} else if (status === "success") {
  // ...
} else if (status === "error") {
  // ...
}
```

Now compare an algebraic data type and pattern matching:

```gleam
case state {
  Loading -> ...
  Success(data) -> ...
  Failure(error) -> ...
}
```

The syntax is only part of the story.

With a properly modeled sum type, the compiler can check whether every possibility has been handled.

That's a shift from remembering the possibilities ourselves to having the language account for them.

It is also why pattern matching and algebraic data types belong alongside mutation, nesting, and indirection. They reduce different kinds of cognitive work.

Languages such as ML, [Hope](https://doi.org/10.1145/800087.802799), and Miranda were exploring algebraic data types and pattern matching decades ago.

## We Knew This Decades Ago

<div class="article-table"><table><thead><tr><th scope="col">Year</th><th scope="col">Researcher or development</th><th scope="col">Connection</th></tr></thead><tbody><tr><td>1966</td><td>Peter Landin, The Next 700 Programming Languages</td><td>Language design, expression structure, and abstraction</td></tr><tr><td>1972</td><td>David Parnas, modular decomposition</td><td>Information hiding and boundaries</td></tr><tr><td>1977</td><td>John Backus, Turing Award lecture</td><td>State, composition, and functional programming</td></tr><tr><td>1980s</td><td>ML and related functional languages</td><td>Pattern matching and algebraic data types</td></tr><tr><td>1981</td><td>Richard E. Mayer, <a href="https://doi.org/10.1145/356835.356841">The Psychology of How Novices Learn Computer Programming</a></td><td>Mental models and program comprehension</td></tr><tr><td>1996</td><td>Green and Petre, Cognitive Dimensions of Notations</td><td>Mental operations, dependencies, and notation</td></tr><tr><td>2020</td><td>Scheme SRFI 197</td><td>Pipelines and nested-expression readability</td></tr></tbody></table></div>

One particularly relevant reference is Marian Petre's 1995 paper, "[Why Looking Isn't Always Seeing: Readership Skills and Graphical Programming.](https://www.cs.toronto.edu/~chechik/courses18/csc2125/paper12.pdf)" It examines how experienced programmers interpret representations differently from novices.

That could help explain why syntax that feels natural to experienced developers isn't necessarily cognitively simple.

And it raises an uncomfortable question: are experienced programmers better at recognizing good notation, or have they simply become better at compensating for bad notation?

Probably some of both.

We have decades of research into how people understand programs. Language ergonomics deserves more attention than a fresh round of arguments about the latest tool. The contrasts between languages here demonstrate that these are language-design decisions, not inevitable properties of programming.

### Essential and incidental complexity

The underlying theme is the difference between essential and incidental complexity.

Fred Brooks's 1986 essay [No Silver Bullet](https://www.cs.unc.edu/techreports/86-020.pdf) gives us useful language for this distinction.

Some complexity belongs to the problem itself. A chess engine, compiler, or distributed database has genuinely difficult requirements.

Other complexity is introduced by how we choose to express the solution.

> We congratulate ourselves for mastering complicated tools. We build elaborate abstractions to manage the complexity of our abstractions. We write tutorials explaining how to navigate the indirection introduced by our architectures.
>
> Occasionally, someone suggests making the original problem simpler.
>
> Naturally, we ask whether it scales.

One more distinction is important: reducing lines of code is not the same as reducing cognitive load.

A dense one-liner may be shorter than a five-line pattern match but harder to understand. Conversely, introducing a well-named function can add indirection while substantially improving readability.

So we shouldn't optimize for the absence of mutation, parentheses, nesting, or function calls in isolation.

We should optimize for the amount of mental reconstruction required to understand what a program means.

## The Code We Don't Have to Think About

### The common thread: Reducing mental bookkeeping

The three observations can be understood as kinds of mental bookkeeping.

### Three kinds of mental bookkeeping

#### Temporal bookkeeping

Mutable state requires remembering what happened previously.

What is the value now?

#### Structural bookkeeping

Nesting requires remembering which expressions are still open.

Where am I in the expression?

#### Directional bookkeeping

Inside-out syntax requires mentally reconstructing the order of computation.

In what order does this happen?

These aren't established academic names for three distinct categories. They're a proposed synthesis of these observations.

The distinction is useful because it suggests that good programming language design can reduce the amount of information a programmer must hold in working memory.

It also explains why a language with relatively little syntax can nevertheless be difficult to read, and why a more verbose language can sometimes feel easier.

### One qualification: Nesting isn't inherently bad

Nesting is how we represent hierarchy, and hierarchy is indispensable.

HTML demonstrates that nested structures can be quite readable when their boundaries are clear.

Likewise, a tree-shaped expression might be more naturally represented as a tree than as a pipeline. A pipeline is particularly effective when computation is essentially linear.

And not all mutable state is equally difficult: tightly encapsulated local mutation is generally easier to reason about than shared state modified from many locations.

The conclusion is not that all mutation, nesting, and asymmetry should disappear. The broader principle is:

Programming becomes easier to reason about when its notation minimizes the amount of invisible context a reader must reconstruct.

That's a fairly broad principle, but it unifies these observations without pretending they are identical problems.

How much of the difficulty of programming comes from the problems we're solving, and how much comes from the tools we've learned to tolerate?

## Further reading

Three particularly useful references are:

- [SRFI 197: Pipeline Operators](https://srfi.schemers.org/srfi-197/srfi-197.html) — the closest direct match for the nesting and pipes argument.
- [Green and Petre: Cognitive Dimensions of Notations](https://www.sciencedirect.com/science/article/pii/S1045926X96900099) — the strongest framework for analyzing the cognitive properties of syntax.
- [John Backus: Can Programming Be Liberated from the von Neumann Style?](https://research.ibm.com/publications/can-programming-be-liberated-from-the-von-neumann-style-a-functional-style-and-its-algebra-of-programs) — the philosophical foundation connecting state, functional composition, and reasoning.
