---
title: "What Is a Program, Really?"
description: "An investigation into values, functions, types, and composition—and the surprising idea that a pure program is itself a value."
published: 2026-10-13
publication_order: 1
tags: Programming, Functional Programming, Types, Mathematics
featured_image: /assets/images/note-what-is-a-program-really.webp
featured_alt: Translucent teal and amber glass spheres and cubes joined into one geometric sculpture, with individual pieces nearby
---

<link rel="stylesheet" href="/assets/katex/katex.min.css">
<style>
.item-content .katex { font-size: 1.1em; }
.article-equation { overflow-x: auto; padding: .5rem 0; }
</style>

# What Is a Program, Really?

{{ featured-image }}

*How much do you actually need to make a program?*

Think about that for a moment.

Not how much JavaScript you need. Or Python. Or Rust. Not which framework, runtime, package manager, or architectural pattern you should use.

How much do you actually need?

We tend to think of programs as collections of instructions. Variables, functions, loops, conditionals, classes, methods, exceptions, and all the other machinery our programming languages provide.

Those are features of programming languages. I'm asking about the program itself.

What if we stripped away the syntax, the language-specific abstractions, and the conveniences we've accumulated over decades of software development?

What would remain?

Let's find out.

## First, We Need Something

We need information.

A number, perhaps.

```js
42
```

Or a string.

```js
"Hello"
```

Maybe a Boolean.

```js
true
```

These are values. Simple, ordinary values.

We can combine them into more elaborate structures.

```js
[1, 2, 3]
```

Or:

```js
{
  name: "Alice",
  age: 30,
  active: true
}
```

We've introduced arrays and objects, but we haven't fundamentally changed what we're working with. We still have values: some simple, others composed of smaller values.

Mathematically, we can describe a collection of values as a set:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>A</mi><mo>=</mo><mo stretchy="false">{</mo><mn>1</mn><mo separator="true">,</mo><mn>2</mn><mo separator="true">,</mo><mn>3</mn><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
A = \{1, 2, 3\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">3</span><span class="mclose">}</span></span></span></span></span></div>

And we can describe combinations of values using products:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>A</mi><mo>×</mo><mi>B</mi></mrow><annotation encoding="application/x-tex">
A \times B
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">×</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span></span></div>

For example, if:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>A</mi><mo>=</mo><mo stretchy="false">{</mo><mn>1</mn><mo separator="true">,</mo><mn>2</mn><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
A = \{1, 2\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mclose">}</span></span></span></span></span></div>

and:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>B</mi><mo>=</mo><mo stretchy="false">{</mo><mi>a</mi><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
B = \{a, b\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord mathnormal">a</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">}</span></span></span></span></span></div>

then:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>A</mi><mo>×</mo><mi>B</mi><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>a</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>a</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
A \times B = \{(1,a), (1,b), (2,a), (2,b)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">×</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">a</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">a</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">)}</span></span></span></span></span></div>

We've constructed a more elaborate collection of possible values from two simpler collections. Nothing particularly surprising.

But there's a problem.

Our values don't do anything.

We can arrange them, collect them, and give them names. We can construct increasingly elaborate structures.

But a program that consists entirely of static information isn't especially interesting.

We need something that can transform a value into another value.

Finally, something other than a value.

Or so it seems.

## We Need a Way to Transform Values

Suppose we have the number `3`, and we want to double it.

We could simply write:

```js
6
```

Problem solved.

Except we haven't described how we arrived at six. We've only written down the answer.

What happens when the input is four? Or five? Or a thousand?

We need something more general.

Let's start with a table.

<table><thead><tr><th>Input</th><th>Output</th></tr></thead><tbody><tr><td>1</td><td>2</td></tr><tr><td>2</td><td>4</td></tr><tr><td>3</td><td>6</td></tr><tr><td>4</td><td>8</td></tr></tbody></table>

Now we have something useful.

Give us an input, and we'll look up its corresponding output.

Three?

Six.

Four?

Eight.

Five?

Well, that's a problem. Five isn't in our table.

But perhaps you've noticed a pattern.

Every output is twice its input.

Instead of writing down every possible association, we could describe the relationship with a rule:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><mn>2</mn><mi>x</mi></mrow><annotation encoding="application/x-tex">
f(x) = 2x
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">2</span><span class="mord mathnormal">x</span></span></span></span></span></div>

Now we can determine the output for any integer.

We've replaced our lookup table with a mathematical function.

Or have we?

## The Lookup Table That Never Ends

Consider what our function actually represents.

For every integer <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>x</mi></mrow><annotation encoding="application/x-tex">x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span>, it associates exactly one output with that input.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo>:</mo><mi mathvariant="double-struck">Z</mi><mo>→</mo><mi mathvariant="double-struck">Z</mi></mrow><annotation encoding="application/x-tex">
f : \mathbb{Z} \rightarrow \mathbb{Z}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span></span></span></span></span></div>

This notation says that <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> maps integers to integers.

And we can describe the function as a set of ordered pairs:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mn>2</mn><mi>x</mi><mo stretchy="false">)</mo><mo>∣</mo><mi>x</mi><mo>∈</mo><mi mathvariant="double-struck">Z</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f = \{(x, 2x) \mid x \in \mathbb{Z}\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">∣</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.5782em;vertical-align:-0.0391em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">∈</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathbb">Z</span><span class="mclose">}</span></span></span></span></span></div>

In other words:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo>=</mo><mo stretchy="false">{</mo><mo>…</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mo>−</mo><mn>1</mn><mo separator="true">,</mo><mo>−</mo><mn>2</mn><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>0</mn><mo separator="true">,</mo><mn>0</mn><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mn>2</mn><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mn>4</mn><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>3</mn><mo separator="true">,</mo><mn>6</mn><mo stretchy="false">)</mo><mo separator="true">,</mo><mo>…</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f = \{\ldots, (-1,-2), (0,0), (1,2), (2,4), (3,6), \ldots\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="minner">…</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">−</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">−</span><span class="mord">2</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">0</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">0</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">4</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">3</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">6</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="minner">…</span><span class="mclose">}</span></span></span></span></span></div>

Look familiar?

It's our lookup table.

An infinitely large lookup table, in fact.

We couldn't possibly store every entry in a computer's memory. But we don't need to.

The expression <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mn>2</mn><mi>x</mi></mrow><annotation encoding="application/x-tex">2x</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">2</span><span class="mord mathnormal">x</span></span></span></span> gives us a compact way to describe every association. Instead of storing the answers, we calculate them when they're needed.

You might imagine it as a *lazy lookup table*: a table whose entries don't have to be written down in advance.

> Strictly speaking, this isn't what programming languages mean by lazy evaluation. We're using the term informally to describe a mapping whose results can be computed on demand.

But the analogy reveals something important.

**A mathematical function is not the calculation used to obtain an answer. It's the relationship between inputs and outputs.**

The calculation is one way to describe or implement that relationship.

We could use multiplication.

```js
const double = x => x * 2
```

Or addition.

```js
const double = x => x + x
```

Or, for a small domain, an actual lookup table.

```js
const double = new Map([
  [1, 2],
  [2, 4],
  [3, 6],
  [4, 8]
])
```

Over the inputs covered by the table, these describe the same mathematical relationship.

The implementations differ. The underlying associations do not.

> Of course, real programming languages have practical details. JavaScript numbers aren't mathematical integers, and floating-point arithmetic introduces behavior that our simple equations don't capture.

Those are properties of the implementation. We're investigating the mathematical idea underneath it, and that idea is remarkably simple.

A function maps values to values.

That's it.

## Wait. Isn't a Function Something That Does Something?

This is where our intuition starts working against us.

Programmers often think of functions as little machines: you put something in, the machine does some work, and something comes out.

And that's a perfectly reasonable way to think about executing a function.

But it's not the only way to understand one.

Consider:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><msup><mi>x</mi><mn>2</mn></msup></mrow><annotation encoding="application/x-tex">
f(x) = x^2
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.8641em;"></span><span class="mord"><span class="mord mathnormal">x</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8641em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span></span></span></span></span></span></span></span></span></div>

Mathematically, this function associates every integer with its square.

The association between 3 and 9 doesn't depend on whether anybody calculates it, whether a computer is running, or even whether somebody has written the function down.

The relationship is defined mathematically. Our program is simply one way of expressing and evaluating it.

This gives us two perspectives on the same function.

**Operationally**, we can ask how the computer calculates the result.

**Mathematically**, we can ask which output corresponds to a given input.

The first perspective concerns execution; the second concerns meaning.

For our investigation, the second is particularly interesting.

Because once we stop thinking about functions as machines and start thinking about them as mappings, something unexpected happens.

Functions begin to look suspiciously like values.

## Functions Are Values?

You've probably heard somebody say that functions are *first-class citizens* in JavaScript.

I certainly have.

It usually comes with an example like this:

```js
const double = x => x * 2

const operations = [double]
```

Look! We put a function in an array.

Or this:

```js
const apply = (fn, value) => fn(value)
```

Look! We passed a function to another function.

And we're told that this demonstrates that functions are first-class values.

Which it does.

But why should that be possible in the first place?

Why should a function be something we can pass around like a number or a string?

Let's return to mathematics.

Suppose we have two sets:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>A</mi><mo>=</mo><mo stretchy="false">{</mo><mn>1</mn><mo separator="true">,</mo><mn>2</mn><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
A = \{1, 2\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mclose">}</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>B</mi><mo>=</mo><mo stretchy="false">{</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
B = \{Yes, No\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">}</span></span></span></span></span></div>

A function from <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>A</mi></mrow><annotation encoding="application/x-tex">A</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span></span></span></span> to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>B</mi></mrow><annotation encoding="application/x-tex">B</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span> must associate each element of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>A</mi></mrow><annotation encoding="application/x-tex">A</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span></span></span></span> with exactly one element of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>B</mi></mrow><annotation encoding="application/x-tex">B</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span>.

How many different functions can we construct?

Four.

We can write them as lookup tables:

<table><thead><tr><th>Input</th><th>Function 1</th><th>Function 2</th><th>Function 3</th><th>Function 4</th></tr></thead><tbody><tr><td>1</td><td>Yes</td><td>Yes</td><td>No</td><td>No</td></tr><tr><td>2</td><td>Yes</td><td>No</td><td>Yes</td><td>No</td></tr></tbody></table>

Each column describes a different function. Mathematically:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msub><mi>f</mi><mn>1</mn></msub><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f_1 = \{(1,Yes),(2,Yes)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">1</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mclose">)}</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msub><mi>f</mi><mn>2</mn></msub><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f_2 = \{(1,Yes),(2,No)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">)}</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msub><mi>f</mi><mn>3</mn></msub><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f_3 = \{(1,No),(2,Yes)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">3</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mclose">)}</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msub><mi>f</mi><mn>4</mn></msub><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mn>1</mn><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mn>2</mn><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
f_4 = \{(1,No),(2,No)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">4</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">)}</span></span></span></span></span></div>

Now here's the interesting part: we can collect those functions into another set.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>F</mi><mo>=</mo><mo stretchy="false">{</mo><msub><mi>f</mi><mn>1</mn></msub><mo separator="true">,</mo><msub><mi>f</mi><mn>2</mn></msub><mo separator="true">,</mo><msub><mi>f</mi><mn>3</mn></msub><mo separator="true">,</mo><msub><mi>f</mi><mn>4</mn></msub><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
F = \{f_1, f_2, f_3, f_4\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">1</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">3</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3011em;"><span style="top:-2.55em;margin-left:-0.1076em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">4</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mclose">}</span></span></span></span></span></div>

We have a set whose elements are functions.

Mathematicians have notation for this. The set of all functions from <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>A</mi></mrow><annotation encoding="application/x-tex">A</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span></span></span></span> to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>B</mi></mrow><annotation encoding="application/x-tex">B</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span> is written:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><msup><mi>B</mi><mi>A</mi></msup></mrow><annotation encoding="application/x-tex">
B^A
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8913em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8913em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">A</span></span></span></span></span></span></span></span></span></span></span></span></div>

And for finite sets:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi mathvariant="normal">∣</mi><msup><mi>B</mi><mi>A</mi></msup><mi mathvariant="normal">∣</mi><mo>=</mo><mi mathvariant="normal">∣</mi><mi>B</mi><msup><mi mathvariant="normal">∣</mi><mrow><mi mathvariant="normal">∣</mi><mi>A</mi><mi mathvariant="normal">∣</mi></mrow></msup></mrow><annotation encoding="application/x-tex">
|B^A| = |B|^{|A|}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1.1413em;vertical-align:-0.25em;"></span><span class="mord">∣</span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8913em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">A</span></span></span></span></span></span></span></span><span class="mord">∣</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1.188em;vertical-align:-0.25em;"></span><span class="mord">∣</span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mord"><span class="mord">∣</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.938em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight"><span class="mord mtight">∣</span><span class="mord mathnormal mtight">A</span><span class="mord mtight">∣</span></span></span></span></span></span></span></span></span></span></span></span></span></div>

Two possible outputs, two possible inputs, four possible functions.

The important observation isn't the arithmetic.

It's that **functions can themselves be elements of a collection**.

We can select one, associate it with something else, or pass it into another mapping.

There's nothing inherently contradictory about treating a function as an object of mathematical study.

Programming languages with first-class functions make a related idea available directly to programmers.

A function can be stored, passed, returned, and composed like other values.

Not because JavaScript invented some peculiar trick.

But because there's a perfectly coherent mathematical model in which functions are objects we can reason about and combine.

> We should distinguish the mathematical model from the programming-language feature. Not every language exposes functions as first-class runtime values, and a mathematical function isn't identical to every detail of a function object in JavaScript.

Nevertheless, the connection is real, and it gives us a much better explanation than simply declaring that functions are first-class citizens and moving on.

A function is a mapping, and a mapping can be treated as a mathematical object. In languages that support it, a function can be represented as a value.

So we've introduced something to transform our values.

A function.

And somehow, we've ended up with another value.

We're right back where we started.

## Fine. But Programs Need to Make Decisions.

Of course they do.

Suppose we're writing a program that determines whether somebody is old enough to vote.

We might write:

```js
const canVote = age => age >= 18
```

That returns a Boolean.

But perhaps we want to choose between two outcomes.

```js
const message = age =>
  age >= 18
    ? "You can vote"
    : "You cannot vote"
```

Now we have conditional logic.

Surely that's something fundamentally different from a value or a mapping.

Let's investigate.

We can describe our function mathematically:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><mrow><mo fence="true">{</mo><mtable rowspacing="0.36em" columnalign="left left" columnspacing="1em"><mtr><mtd><mstyle scriptlevel="0" displaystyle="false"><mtext>&quot;You can vote&quot;</mtext></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="false"><mrow><mi>x</mi><mo>≥</mo><mn>18</mn></mrow></mstyle></mtd></mtr><mtr><mtd><mstyle scriptlevel="0" displaystyle="false"><mtext>&quot;You cannot vote&quot;</mtext></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="false"><mrow><mi>x</mi><mo>&lt;</mo><mn>18</mn></mrow></mstyle></mtd></mtr></mtable></mrow></mrow><annotation encoding="application/x-tex">
f(x) =
\begin{cases}
\text{&quot;You can vote&quot;} &amp; x \geq 18 \\
\text{&quot;You cannot vote&quot;} &amp; x &lt; 18
\end{cases}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:3em;vertical-align:-1.25em;"></span><span class="minner"><span class="mopen delimcenter" style="top:0em;"><span class="delimsizing size4">{</span></span><span class="mord"><span class="mtable"><span class="col-align-l"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:1.69em;"><span style="top:-3.69em;"><span class="pstrut" style="height:3.008em;"></span><span class="mord"><span class="mord text"><span class="mord">&quot;You can vote&quot;</span></span></span></span><span style="top:-2.25em;"><span class="pstrut" style="height:3.008em;"></span><span class="mord"><span class="mord text"><span class="mord">&quot;You cannot vote&quot;</span></span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:1.19em;"><span></span></span></span></span></span><span class="arraycolsep" style="width:1em;"></span><span class="col-align-l"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:1.69em;"><span style="top:-3.69em;"><span class="pstrut" style="height:3.008em;"></span><span class="mord"><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">≥</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord">18</span></span></span><span style="top:-2.25em;"><span class="pstrut" style="height:3.008em;"></span><span class="mord"><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">&lt;</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord">18</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:1.19em;"><span></span></span></span></span></span></span></span><span class="mclose nulldelimiter"></span></span></span></span></span></span></div>

We've defined a piecewise function: for every input, there's exactly one corresponding output. We're still describing a mapping.

The conditional expression in JavaScript is one way to implement that mapping.

But the mathematical relationship doesn't depend on JavaScript having a ternary operator.

In fact, we can represent the choice itself as a function.

Consider a set containing just two values:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>B</mi><mi>o</mi><mi>o</mi><mi>l</mi><mi>e</mi><mi>a</mi><mi>n</mi><mo>=</mo><mo stretchy="false">{</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo separator="true">,</mo><mi>N</mi><mi>o</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
Boolean = \{Yes, No\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mord mathnormal">oo</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mord mathnormal">an</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mclose">}</span></span></span></span></span></div>

We could construct a mapping that associates each Boolean with a particular result.

For example:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>c</mi><mi>h</mi><mi>o</mi><mi>o</mi><mi>s</mi><mi>e</mi><mo stretchy="false">(</mo><mi>Y</mi><mi>e</mi><mi>s</mi><mo separator="true">,</mo><mi>a</mi><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">)</mo><mo>=</mo><mi>a</mi></mrow><annotation encoding="application/x-tex">
choose(Yes, a, b) = a
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">c</span><span class="mord mathnormal">h</span><span class="mord mathnormal">oose</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.22222em;">Y</span><span class="mord mathnormal">es</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">a</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">a</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>c</mi><mi>h</mi><mi>o</mi><mi>o</mi><mi>s</mi><mi>e</mi><mo stretchy="false">(</mo><mi>N</mi><mi>o</mi><mo separator="true">,</mo><mi>a</mi><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">)</mo><mo>=</mo><mi>b</mi></mrow><annotation encoding="application/x-tex">
choose(No, a, b) = b
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">c</span><span class="mord mathnormal">h</span><span class="mord mathnormal">oose</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">o</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">a</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span></span></span></span></span></div>

That's a perfectly ordinary mathematical function.

And here's a JavaScript implementation that doesn't use an `if` statement or a ternary operator:

```js
const Yes = (yes, no) => yes
const No = (yes, no) => no

const choose = (condition, yes, no) =>
  condition(yes, no)
```

Now:

```js
choose(Yes, "Coffee", "Tea") // "Coffee"

choose(No, "Coffee", "Tea") // "Tea"
```

We've represented the two possible choices as functions.

This technique is related to *Church encoding*, a way of representing data using functions.

> Our example is deliberately simple. Both alternatives are evaluated before being passed to `choose`, so it doesn't reproduce the evaluation behavior of a language's ordinary conditional. We could pass functions representing deferred computations if we needed that behavior.

But the point stands.

**We can represent selection through function application.**

A language's conditional syntax is useful and often much more readable, but it isn't the only way to express a choice.

And our mathematical model hasn't required a fundamentally new kind of object.

We're still working with values and mappings.

## But We Need Loops

Now we're getting somewhere.

Programs need to process collections.

Suppose we have a list of numbers:

```js
[1, 2, 3, 4]
```

And we want to double every number.

We could write a loop:

```js
const numbers = [1, 2, 3, 4]
const results = []

for (const number of numbers) {
  results.push(number * 2)
}
```

That works.

But is the loop fundamental to the computation?

What are we actually trying to describe?

A relationship between two lists:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mo stretchy="false">[</mo><mn>1</mn><mo separator="true">,</mo><mn>2</mn><mo separator="true">,</mo><mn>3</mn><mo separator="true">,</mo><mn>4</mn><mo stretchy="false">]</mo><mo>↦</mo><mo stretchy="false">[</mo><mn>2</mn><mo separator="true">,</mo><mn>4</mn><mo separator="true">,</mo><mn>6</mn><mo separator="true">,</mo><mn>8</mn><mo stretchy="false">]</mo></mrow><annotation encoding="application/x-tex">
[1,2,3,4] \mapsto [2,4,6,8]
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">[</span><span class="mord">1</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">3</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">4</span><span class="mclose">]</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">↦</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">[</span><span class="mord">2</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">4</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">6</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">8</span><span class="mclose">]</span></span></span></span></span></div>

We want a function that accepts a list and returns another list.

We can describe that relationship recursively.

Let's borrow a little OCaml:

```ocaml
let rec map f xs =
  match xs with
  | [] -> []
  | head :: tail -> f head :: map f tail
```

If you're unfamiliar with OCaml, don't worry. The idea is straightforward.

The function accepts another function, `f`, and a list, `xs`. If the list is empty, it returns an empty list; otherwise, it applies `f` to the first element and recursively processes the remaining elements.

We can express the same definition mathematically:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>m</mi><mi>a</mi><mi>p</mi><mo stretchy="false">(</mo><mi>f</mi><mo separator="true">,</mo><mo stretchy="false">[</mo><mo stretchy="false">]</mo><mo stretchy="false">)</mo><mo>=</mo><mo stretchy="false">[</mo><mo stretchy="false">]</mo></mrow><annotation encoding="application/x-tex">
map(f, []) = []
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">ma</span><span class="mord mathnormal">p</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">[</span><span class="mclose">])</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">[</span><span class="mclose">]</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>m</mi><mi>a</mi><mi>p</mi><mo stretchy="false">(</mo><mi>f</mi><mo separator="true">,</mo><mi>x</mi><mo>:</mo><mo>:</mo><mi>x</mi><mi>s</mi><mo stretchy="false">)</mo><mo>=</mo><mi>f</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>:</mo><mo>:</mo><mi>m</mi><mi>a</mi><mi>p</mi><mo stretchy="false">(</mo><mi>f</mi><mo separator="true">,</mo><mi>x</mi><mi>s</mi><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">
map(f, x :: xs) = f(x) :: map(f, xs)
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">ma</span><span class="mord mathnormal">p</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">::</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">x</span><span class="mord mathnormal">s</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">::</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">ma</span><span class="mord mathnormal">p</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">x</span><span class="mord mathnormal">s</span><span class="mclose">)</span></span></span></span></span></div>

Here, `::` means constructing a list by placing an element at its front.

Notice what we haven't described:

- A loop counter.
- A mutable accumulator.
- An instruction to jump backward to an earlier statement.

We've simply defined the result in terms of smaller instances of the same problem.

> The programming language still needs a way to evaluate this definition. Recursion has operational consequences, including stack usage and termination.

Mathematically, we've described another mapping: a function from lists to lists. Because `map` accepts a function, it's a higher-order function.

Which means?

Yes.

Another function that can be treated as a value.

At this point, our investigation is becoming a little suspicious.

Every time we introduce something that seems fundamentally different, we discover another way to express a relationship between values.

## What About Errors?

Programs fail.

They encounter invalid input, missing information, unexpected conditions, and operations that cannot produce a useful result.

Surely errors are different.

Suppose we want to divide two numbers.

Mathematically:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>d</mi><mi>i</mi><mi>v</mi><mi>i</mi><mi>d</mi><mi>e</mi><mo stretchy="false">(</mo><mi>a</mi><mo separator="true">,</mo><mi>b</mi><mo stretchy="false">)</mo><mo>=</mo><mfrac><mi>a</mi><mi>b</mi></mfrac></mrow><annotation encoding="application/x-tex">
divide(a,b)=\frac{a}{b}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">d</span><span class="mord mathnormal">i</span><span class="mord mathnormal" style="margin-right:0.03588em;">v</span><span class="mord mathnormal">i</span><span class="mord mathnormal">d</span><span class="mord mathnormal">e</span><span class="mopen">(</span><span class="mord mathnormal">a</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal">b</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1.7936em;vertical-align:-0.686em;"></span><span class="mord"><span class="mopen nulldelimiter"></span><span class="mfrac"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:1.1076em;"><span style="top:-2.314em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal">b</span></span></span><span style="top:-3.23em;"><span class="pstrut" style="height:3em;"></span><span class="frac-line" style="border-bottom-width:0.04em;"></span></span><span style="top:-3.677em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal">a</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.686em;"><span></span></span></span></span></span><span class="mclose nulldelimiter"></span></span></span></span></span></span></div>

But what happens when <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>b</mi><mo>=</mo><mn>0</mn></mrow><annotation encoding="application/x-tex">b=0</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">b</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">0</span></span></span></span>?

Our function isn't defined there.

We have a few choices. We could restrict the domain to exclude zero denominators, or expand the possible outputs to include failure.

Imagine a result that can be either:

- A successful value.
- An error describing what went wrong.

In a language with algebraic data types, we might express that as:

```gleam
type Result(value, error) {
  Ok(value)
  Error(error)
}
```

Now division doesn't need to pretend that every input produces a number.

It can return a result.

Mathematically, we can describe its output type as a sum:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>R</mi><mi>e</mi><mi>s</mi><mi>u</mi><mi>l</mi><mi>t</mi><mo stretchy="false">(</mo><mi>A</mi><mo separator="true">,</mo><mi>E</mi><mo stretchy="false">)</mo><mo>=</mo><mi>A</mi><mo>+</mo><mi>E</mi></mrow><annotation encoding="application/x-tex">
Result(A,E)=A+E
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.00773em;">R</span><span class="mord mathnormal">es</span><span class="mord mathnormal">u</span><span class="mord mathnormal">lt</span><span class="mopen">(</span><span class="mord mathnormal">A</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.7667em;vertical-align:-0.0833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span></span></span></span></span></div>

The plus sign here describes a choice between two distinct possibilities: a successful value belonging to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>A</mi></mrow><annotation encoding="application/x-tex">A</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span></span></span></span>, or an error belonging to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>E</mi></mrow><annotation encoding="application/x-tex">E</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span></span></span></span>. It doesn't mean numerical addition.

Our function becomes:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>d</mi><mi>i</mi><mi>v</mi><mi>i</mi><mi>d</mi><mi>e</mi><mo>:</mo><mi>N</mi><mi>u</mi><mi>m</mi><mi>b</mi><mi>e</mi><mi>r</mi><mo>×</mo><mi>N</mi><mi>u</mi><mi>m</mi><mi>b</mi><mi>e</mi><mi>r</mi><mo>→</mo><mi>R</mi><mi>e</mi><mi>s</mi><mi>u</mi><mi>l</mi><mi>t</mi><mo stretchy="false">(</mo><mi>N</mi><mi>u</mi><mi>m</mi><mi>b</mi><mi>e</mi><mi>r</mi><mo separator="true">,</mo><mi>E</mi><mi>r</mi><mi>r</mi><mi>o</mi><mi>r</mi><mo stretchy="false">)</mo></mrow><annotation encoding="application/x-tex">
divide : Number \times Number \rightarrow Result(Number, Error)
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">d</span><span class="mord mathnormal">i</span><span class="mord mathnormal" style="margin-right:0.03588em;">v</span><span class="mord mathnormal">i</span><span class="mord mathnormal">d</span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.0833em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">u</span><span class="mord mathnormal">mb</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">×</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">u</span><span class="mord mathnormal">mb</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.00773em;">R</span><span class="mord mathnormal">es</span><span class="mord mathnormal">u</span><span class="mord mathnormal">lt</span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">u</span><span class="mord mathnormal">mb</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="mord mathnormal" style="margin-right:0.02778em;">rror</span><span class="mclose">)</span></span></span></span></span></div>

And now every pair of inputs can produce a well-defined result, including division by zero.

We've modeled failure as data.

The error and the result are values, and the function that produces them is still a mapping.

> This doesn't mean every real-world failure automatically becomes harmless. A computer can run out of memory, a process can be terminated, and a computation can fail to terminate.

We're talking about failures deliberately represented within our mathematical model.

But within that model, errors don't require us to abandon the idea of pure functions.

We can make failure part of the output.

One more objection handled.

One more apparent exception that turns out to be a value.

## Maybe We're Asking the Wrong Question

Let's reconsider what we've done. We started with simple values and constructed more elaborate ones. Then we needed:

- Transformations, so we introduced functions.
- Decisions, so we explored functions that select between alternatives.
- Repetition, so we defined recursive functions.
- Failure, so we constructed values that distinguish success from error.

Every time, the mathematical description remained surprisingly consistent.

Values.

Mappings.

Compositions of values and mappings.

Perhaps the question isn't how many programming constructs we need.

Perhaps it's how many different *kinds of things* we actually need.

And perhaps the answer is considerably smaller than the syntax of our favorite programming language suggests.

But there's something we haven't discussed.

We've been casually throwing values into functions without asking whether those values make sense.

What prevents us from passing a person's name into a function that expects a temperature?

What prevents us from confusing a completed payment with a pending one?

What prevents us from combining things that shouldn't be combined?

We need some way to describe which values belong together.

And which mappings are valid between them.

We need types.

## The Space of Possible Values

Let's return to our mathematical sets.

Suppose we're modeling the directions on a compass.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>D</mi><mi>i</mi><mi>r</mi><mi>e</mi><mi>c</mi><mi>t</mi><mi>i</mi><mi>o</mi><mi>n</mi><mo>=</mo><mo stretchy="false">{</mo><mi>N</mi><mi>o</mi><mi>r</mi><mi>t</mi><mi>h</mi><mo separator="true">,</mo><mi>S</mi><mi>o</mi><mi>u</mi><mi>t</mi><mi>h</mi><mo separator="true">,</mo><mi>E</mi><mi>a</mi><mi>s</mi><mi>t</mi><mo separator="true">,</mo><mi>W</mi><mi>e</mi><mi>s</mi><mi>t</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
Direction = \{North, South, East, West\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.02778em;">D</span><span class="mord mathnormal">i</span><span class="mord mathnormal">rec</span><span class="mord mathnormal">t</span><span class="mord mathnormal">i</span><span class="mord mathnormal">o</span><span class="mord mathnormal">n</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal" style="margin-right:0.02778em;">or</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">S</span><span class="mord mathnormal">o</span><span class="mord mathnormal">u</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="mord mathnormal">a</span><span class="mord mathnormal">s</span><span class="mord mathnormal">t</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">W</span><span class="mord mathnormal">es</span><span class="mord mathnormal">t</span><span class="mclose">}</span></span></span></span></span></div>

That's a set containing four possible values.

We can define a function that returns the opposite direction:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>o</mi><mi>p</mi><mi>p</mi><mi>o</mi><mi>s</mi><mi>i</mi><mi>t</mi><mi>e</mi><mo>:</mo><mi>D</mi><mi>i</mi><mi>r</mi><mi>e</mi><mi>c</mi><mi>t</mi><mi>i</mi><mi>o</mi><mi>n</mi><mo>→</mo><mi>D</mi><mi>i</mi><mi>r</mi><mi>e</mi><mi>c</mi><mi>t</mi><mi>i</mi><mi>o</mi><mi>n</mi></mrow><annotation encoding="application/x-tex">
opposite : Direction \rightarrow Direction
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.854em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">o</span><span class="mord mathnormal">pp</span><span class="mord mathnormal">os</span><span class="mord mathnormal">i</span><span class="mord mathnormal">t</span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.02778em;">D</span><span class="mord mathnormal">i</span><span class="mord mathnormal">rec</span><span class="mord mathnormal">t</span><span class="mord mathnormal">i</span><span class="mord mathnormal">o</span><span class="mord mathnormal">n</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.02778em;">D</span><span class="mord mathnormal">i</span><span class="mord mathnormal">rec</span><span class="mord mathnormal">t</span><span class="mord mathnormal">i</span><span class="mord mathnormal">o</span><span class="mord mathnormal">n</span></span></span></span></span></div>

With the associations:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mtable rowspacing="0.25em" columnalign="right left" columnspacing="0em"><mtr><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mi>N</mi><mi>o</mi><mi>r</mi><mi>t</mi><mi>h</mi></mrow></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mrow></mrow><mo>↦</mo><mi>S</mi><mi>o</mi><mi>u</mi><mi>t</mi><mi>h</mi></mrow></mstyle></mtd></mtr><mtr><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mi>S</mi><mi>o</mi><mi>u</mi><mi>t</mi><mi>h</mi></mrow></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mrow></mrow><mo>↦</mo><mi>N</mi><mi>o</mi><mi>r</mi><mi>t</mi><mi>h</mi></mrow></mstyle></mtd></mtr><mtr><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mi>E</mi><mi>a</mi><mi>s</mi><mi>t</mi></mrow></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mrow></mrow><mo>↦</mo><mi>W</mi><mi>e</mi><mi>s</mi><mi>t</mi></mrow></mstyle></mtd></mtr><mtr><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mi>W</mi><mi>e</mi><mi>s</mi><mi>t</mi></mrow></mstyle></mtd><mtd><mstyle scriptlevel="0" displaystyle="true"><mrow><mrow></mrow><mo>↦</mo><mi>E</mi><mi>a</mi><mi>s</mi><mi>t</mi></mrow></mstyle></mtd></mtr></mtable><annotation encoding="application/x-tex">
\begin{aligned}
North &amp;\mapsto South \\
South &amp;\mapsto North \\
East &amp;\mapsto West \\
West &amp;\mapsto East
\end{aligned}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:6em;vertical-align:-2.75em;"></span><span class="mord"><span class="mtable"><span class="col-align-r"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:3.25em;"><span style="top:-5.41em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal" style="margin-right:0.02778em;">or</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span></span></span><span style="top:-3.91em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05764em;">S</span><span class="mord mathnormal">o</span><span class="mord mathnormal">u</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span></span></span><span style="top:-2.41em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="mord mathnormal">a</span><span class="mord mathnormal">s</span><span class="mord mathnormal">t</span></span></span><span style="top:-0.91em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord mathnormal" style="margin-right:0.13889em;">W</span><span class="mord mathnormal">es</span><span class="mord mathnormal">t</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:2.75em;"><span></span></span></span></span></span><span class="col-align-l"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:3.25em;"><span style="top:-5.41em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord"></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">↦</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">S</span><span class="mord mathnormal">o</span><span class="mord mathnormal">u</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span></span></span><span style="top:-3.91em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord"></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">↦</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal" style="margin-right:0.02778em;">or</span><span class="mord mathnormal">t</span><span class="mord mathnormal">h</span></span></span><span style="top:-2.41em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord"></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">↦</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">W</span><span class="mord mathnormal">es</span><span class="mord mathnormal">t</span></span></span><span style="top:-0.91em;"><span class="pstrut" style="height:3em;"></span><span class="mord"><span class="mord"></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">↦</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mord mathnormal" style="margin-right:0.05764em;">E</span><span class="mord mathnormal">a</span><span class="mord mathnormal">s</span><span class="mord mathnormal">t</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:2.75em;"><span></span></span></span></span></span></span></span></span></span></span></span></div>

We've defined a mapping between two sets.

In fact, they're the same set.

Now suppose we want to represent this domain in a programming language.

In Gleam, we could write:

```gleam
type Direction {
  North
  South
  East
  West
}
```

And:

```gleam
fn opposite(direction) {
  case direction {
    North -> South
    South -> North
    East -> West
    West -> East
  }
}
```

The type describes the possible values, the function describes the mapping, and the compiler can check whether our implementation respects the type.

For example, if we introduce a fifth direction, the compiler can help identify pattern matches that no longer handle every possibility.

This is an important practical benefit.

We aren't merely documenting what we intend.

We're giving the compiler information it can use to verify parts of our program.

### Types as Sets

It's useful to think of many ordinary types as sets of possible values.

A Boolean type has two inhabitants:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>B</mi><mi>o</mi><mi>o</mi><mi>l</mi><mi>e</mi><mi>a</mi><mi>n</mi><mo>=</mo><mo stretchy="false">{</mo><mi>T</mi><mi>r</mi><mi>u</mi><mi>e</mi><mo separator="true">,</mo><mi>F</mi><mi>a</mi><mi>l</mi><mi>s</mi><mi>e</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
Boolean = \{True, False\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mord mathnormal">oo</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mord mathnormal">an</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{</span><span class="mord mathnormal" style="margin-right:0.13889em;">T</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">u</span><span class="mord mathnormal">e</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mord mathnormal">a</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">se</span><span class="mclose">}</span></span></span></span></span></div>

A direction type might have four.

A pair of Booleans has four possible combinations:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>B</mi><mi>o</mi><mi>o</mi><mi>l</mi><mi>e</mi><mi>a</mi><mi>n</mi><mo>×</mo><mi>B</mi><mi>o</mi><mi>o</mi><mi>l</mi><mi>e</mi><mi>a</mi><mi>n</mi></mrow><annotation encoding="application/x-tex">
Boolean \times Boolean
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.0833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mord mathnormal">oo</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mord mathnormal">an</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">×</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mord mathnormal">oo</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mord mathnormal">an</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mi>T</mi><mo separator="true">,</mo><mi>T</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mi>T</mi><mo separator="true">,</mo><mi>F</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mi>F</mi><mo separator="true">,</mo><mi>T</mi><mo stretchy="false">)</mo><mo separator="true">,</mo><mo stretchy="false">(</mo><mi>F</mi><mo separator="true">,</mo><mi>F</mi><mo stretchy="false">)</mo><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
= \{(T,T),(T,F),(F,T),(F,F)\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.3669em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord mathnormal" style="margin-right:0.13889em;">T</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">T</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.13889em;">T</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">T</span><span class="mclose">)</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord mathnormal" style="margin-right:0.13889em;">F</span><span class="mclose">)}</span></span></span></span></span></div>

A type containing either a number or a string can be modeled using a sum:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>N</mi><mi>u</mi><mi>m</mi><mi>b</mi><mi>e</mi><mi>r</mi><mo>+</mo><mi>S</mi><mi>t</mi><mi>r</mi><mi>i</mi><mi>n</mi><mi>g</mi></mrow><annotation encoding="application/x-tex">
Number + String
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.7778em;vertical-align:-0.0833em;"></span><span class="mord mathnormal" style="margin-right:0.10903em;">N</span><span class="mord mathnormal">u</span><span class="mord mathnormal">mb</span><span class="mord mathnormal" style="margin-right:0.02778em;">er</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8778em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">St</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">in</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span></span></div>

These constructions are the mathematical ideas behind product types and sum types.

And they're the building blocks of algebraic data types.

> Of course, type theory is richer than simply treating every type as a set. There are important differences involving computation, constructive proofs, nontermination, and more sophisticated type systems.

But for understanding ordinary algebraic data types, the set interpretation is remarkably useful.

We can construct types from simpler types, just as we construct values from simpler values. Those types describe the possible inputs and outputs of our functions.

Which brings us back to our mappings.

## The Compiler Knows the Rules

Suppose we have:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>f</mi><mo>:</mo><mi>A</mi><mo>→</mo><mi>B</mi></mrow><annotation encoding="application/x-tex">
f : A \rightarrow B
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span></span></div>

And:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>g</mi><mo>:</mo><mi>B</mi><mo>→</mo><mi>C</mi></mrow><annotation encoding="application/x-tex">
g : B \rightarrow C
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.07153em;">C</span></span></span></span></span></div>

We can compose them:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>g</mi><mo>∘</mo><mi>f</mi><mo>:</mo><mi>A</mi><mo>→</mo><mi>C</mi></mrow><annotation encoding="application/x-tex">
g \circ f : A \rightarrow C
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6389em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.07153em;">C</span></span></span></span></span></div>

Why?

Because the output of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> belongs to the set of values that <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span> accepts.

The pieces fit together.

But suppose instead:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>g</mi><mo>:</mo><mi>D</mi><mo>→</mo><mi>C</mi></mrow><annotation encoding="application/x-tex">
g : D \rightarrow C
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.02778em;">D</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.07153em;">C</span></span></span></span></span></div>

Now we have a problem.

Unless there's some valid relationship between <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>B</mi></mrow><annotation encoding="application/x-tex">B</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.05017em;">B</span></span></span></span> and <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>D</mi></mrow><annotation encoding="application/x-tex">D</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal" style="margin-right:0.02778em;">D</span></span></span></span>, we cannot simply assume that the output of <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>f</mi></mrow><annotation encoding="application/x-tex">f</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span> is acceptable to <span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mi>g</mi></mrow><annotation encoding="application/x-tex">g</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span></span></span></span>.

The composition may not make sense.

This is where a type checker becomes valuable.

It helps determine whether the pieces of our program fit together according to the rules we've established.

And when we model our domain with carefully constructed types, those rules can become surprisingly expressive.

We can describe not only what values exist, but which combinations of values are possible. This lets us distinguish kinds of results, represent different states of a process, and make certain invalid combinations impossible to construct.

But let's not wander too far into type-driven design.

That's another investigation.

For now, the important observation is simpler.

**Types describe the spaces of possible values. Functions describe mappings between those spaces.**

And the compiler can help us determine whether our compositions are valid.

We're beginning to see a structure emerge.

## Putting the Pieces Together

Let's build something.

Not a particularly useful program. Just enough to demonstrate what we've discovered.

Suppose we have three functions:

```js
const increment = x => x + 1

const double = x => x * 2

const square = x => x * x
```

Each accepts a number and returns a number.

Mathematically:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>i</mi><mi>n</mi><mi>c</mi><mi>r</mi><mi>e</mi><mi>m</mi><mi>e</mi><mi>n</mi><mi>t</mi><mo>:</mo><mi mathvariant="double-struck">Z</mi><mo>→</mo><mi mathvariant="double-struck">Z</mi></mrow><annotation encoding="application/x-tex">
increment : \mathbb{Z} \rightarrow \mathbb{Z}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6595em;"></span><span class="mord mathnormal">in</span><span class="mord mathnormal">cre</span><span class="mord mathnormal">m</span><span class="mord mathnormal">e</span><span class="mord mathnormal">n</span><span class="mord mathnormal">t</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>d</mi><mi>o</mi><mi>u</mi><mi>b</mi><mi>l</mi><mi>e</mi><mo>:</mo><mi mathvariant="double-struck">Z</mi><mo>→</mo><mi mathvariant="double-struck">Z</mi></mrow><annotation encoding="application/x-tex">
double : \mathbb{Z} \rightarrow \mathbb{Z}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">d</span><span class="mord mathnormal">o</span><span class="mord mathnormal">u</span><span class="mord mathnormal">b</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>s</mi><mi>q</mi><mi>u</mi><mi>a</mi><mi>r</mi><mi>e</mi><mo>:</mo><mi mathvariant="double-struck">Z</mi><mo>→</mo><mi mathvariant="double-struck">Z</mi></mrow><annotation encoding="application/x-tex">
square : \mathbb{Z} \rightarrow \mathbb{Z}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">s</span><span class="mord mathnormal" style="margin-right:0.03588em;">q</span><span class="mord mathnormal">u</span><span class="mord mathnormal">a</span><span class="mord mathnormal">re</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span></span></span></span></span></div>

Now we combine them:

```js
const program = x =>
  square(double(increment(x)))
```

For an input of 3:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mn>3</mn><mover><mo stretchy="true" minsize="3.0em">→</mo><mpadded width="+0.6em" lspace="0.3em"><mrow><mi>i</mi><mi>n</mi><mi>c</mi><mi>r</mi><mi>e</mi><mi>m</mi><mi>e</mi><mi>n</mi><mi>t</mi></mrow></mpadded></mover><mn>4</mn></mrow><annotation encoding="application/x-tex">
3 \xrightarrow{increment} 4
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1.0947em;vertical-align:-0.011em;"></span><span class="mord">3</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel x-arrow"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:1.0837em;"><span style="top:-3.322em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight x-arrow-pad"><span class="mord mtight"><span class="mord mathnormal mtight">in</span><span class="mord mathnormal mtight">cre</span><span class="mord mathnormal mtight">m</span><span class="mord mathnormal mtight">e</span><span class="mord mathnormal mtight">n</span><span class="mord mathnormal mtight">t</span></span></span></span><span class="svg-align" style="top:-2.689em;"><span class="pstrut" style="height:2.7em;"></span><span class="hide-tail" style="height:0.522em;min-width:1.469em;"><svg xmlns="http://www.w3.org/2000/svg" width="400em" height="0.522em" viewBox="0 0 400000 522" preserveAspectRatio="xMaxYMin slice"><path d="M0 241v40h399891c-47.3 35.3-84 78-110 128
-16.7 32-27.7 63.7-33 95 0 1.3-.2 2.7-.5 4-.3 1.3-.5 2.3-.5 3 0 7.3 6.7 11 20
 11 8 0 13.2-.8 15.5-2.5 2.3-1.7 4.2-5.5 5.5-11.5 2-13.3 5.7-27 11-41 14.7-44.7
 39-84.5 73-119.5s73.7-60.2 119-75.5c6-2 9-5.7 9-11s-3-9-9-11c-45.3-15.3-85
-40.5-119-75.5s-58.3-74.8-73-119.5c-4.7-14-8.3-27.3-11-40-1.3-6.7-3.2-10.8-5.5
-12.5-2.3-1.7-7.5-2.5-15.5-2.5-14 0-21 3.7-21 11 0 2 2 10.3 6 25 20.7 83.3 67
 151.7 139 205zm0 0v40h399900v-40z"/></svg></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.011em;"><span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">4</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mn>4</mn><mover><mo stretchy="true" minsize="3.0em">→</mo><mpadded width="+0.6em" lspace="0.3em"><mrow><mi>d</mi><mi>o</mi><mi>u</mi><mi>b</mi><mi>l</mi><mi>e</mi></mrow></mpadded></mover><mn>8</mn></mrow><annotation encoding="application/x-tex">
4 \xrightarrow{double} 8
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1.1191em;vertical-align:-0.011em;"></span><span class="mord">4</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel x-arrow"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:1.1081em;"><span style="top:-3.322em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight x-arrow-pad"><span class="mord mtight"><span class="mord mathnormal mtight">d</span><span class="mord mathnormal mtight">o</span><span class="mord mathnormal mtight">u</span><span class="mord mathnormal mtight">b</span><span class="mord mathnormal mtight" style="margin-right:0.01968em;">l</span><span class="mord mathnormal mtight">e</span></span></span></span><span class="svg-align" style="top:-2.689em;"><span class="pstrut" style="height:2.7em;"></span><span class="hide-tail" style="height:0.522em;min-width:1.469em;"><svg xmlns="http://www.w3.org/2000/svg" width="400em" height="0.522em" viewBox="0 0 400000 522" preserveAspectRatio="xMaxYMin slice"><path d="M0 241v40h399891c-47.3 35.3-84 78-110 128
-16.7 32-27.7 63.7-33 95 0 1.3-.2 2.7-.5 4-.3 1.3-.5 2.3-.5 3 0 7.3 6.7 11 20
 11 8 0 13.2-.8 15.5-2.5 2.3-1.7 4.2-5.5 5.5-11.5 2-13.3 5.7-27 11-41 14.7-44.7
 39-84.5 73-119.5s73.7-60.2 119-75.5c6-2 9-5.7 9-11s-3-9-9-11c-45.3-15.3-85
-40.5-119-75.5s-58.3-74.8-73-119.5c-4.7-14-8.3-27.3-11-40-1.3-6.7-3.2-10.8-5.5
-12.5-2.3-1.7-7.5-2.5-15.5-2.5-14 0-21 3.7-21 11 0 2 2 10.3 6 25 20.7 83.3 67
 151.7 139 205zm0 0v40h399900v-40z"/></svg></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.011em;"><span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">8</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mn>8</mn><mover><mo stretchy="true" minsize="3.0em">→</mo><mpadded width="+0.6em" lspace="0.3em"><mrow><mi>s</mi><mi>q</mi><mi>u</mi><mi>a</mi><mi>r</mi><mi>e</mi></mrow></mpadded></mover><mn>64</mn></mrow><annotation encoding="application/x-tex">
8 \xrightarrow{square} 64
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.9344em;vertical-align:-0.011em;"></span><span class="mord">8</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel x-arrow"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.9234em;"><span style="top:-3.322em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight x-arrow-pad"><span class="mord mtight"><span class="mord mathnormal mtight">s</span><span class="mord mathnormal mtight" style="margin-right:0.03588em;">q</span><span class="mord mathnormal mtight">u</span><span class="mord mathnormal mtight">a</span><span class="mord mathnormal mtight">re</span></span></span></span><span class="svg-align" style="top:-2.689em;"><span class="pstrut" style="height:2.7em;"></span><span class="hide-tail" style="height:0.522em;min-width:1.469em;"><svg xmlns="http://www.w3.org/2000/svg" width="400em" height="0.522em" viewBox="0 0 400000 522" preserveAspectRatio="xMaxYMin slice"><path d="M0 241v40h399891c-47.3 35.3-84 78-110 128
-16.7 32-27.7 63.7-33 95 0 1.3-.2 2.7-.5 4-.3 1.3-.5 2.3-.5 3 0 7.3 6.7 11 20
 11 8 0 13.2-.8 15.5-2.5 2.3-1.7 4.2-5.5 5.5-11.5 2-13.3 5.7-27 11-41 14.7-44.7
 39-84.5 73-119.5s73.7-60.2 119-75.5c6-2 9-5.7 9-11s-3-9-9-11c-45.3-15.3-85
-40.5-119-75.5s-58.3-74.8-73-119.5c-4.7-14-8.3-27.3-11-40-1.3-6.7-3.2-10.8-5.5
-12.5-2.3-1.7-7.5-2.5-15.5-2.5-14 0-21 3.7-21 11 0 2 2 10.3 6 25 20.7 83.3 67
 151.7 139 205zm0 0v40h399900v-40z"/></svg></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.011em;"><span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">64</span></span></span></span></span></div>

So:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo stretchy="false">(</mo><mn>3</mn><mo stretchy="false">)</mo><mo>=</mo><mn>64</mn></mrow><annotation encoding="application/x-tex">
program(3)=64
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mopen">(</span><span class="mord">3</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6444em;"></span><span class="mord">64</span></span></span></span></span></div>

Nothing extraordinary.

But consider what we've constructed.

We started with three functions.

We composed them.

And what did we get?

Another function.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo>=</mo><mi>s</mi><mi>q</mi><mi>u</mi><mi>a</mi><mi>r</mi><mi>e</mi><mo>∘</mo><mi>d</mi><mi>o</mi><mi>u</mi><mi>b</mi><mi>l</mi><mi>e</mi><mo>∘</mo><mi>i</mi><mi>n</mi><mi>c</mi><mi>r</mi><mi>e</mi><mi>m</mi><mi>e</mi><mi>n</mi><mi>t</mi></mrow><annotation encoding="application/x-tex">
program = square \circ double \circ increment
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6389em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">s</span><span class="mord mathnormal" style="margin-right:0.03588em;">q</span><span class="mord mathnormal">u</span><span class="mord mathnormal">a</span><span class="mord mathnormal">re</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">d</span><span class="mord mathnormal">o</span><span class="mord mathnormal">u</span><span class="mord mathnormal">b</span><span class="mord mathnormal" style="margin-right:0.01968em;">l</span><span class="mord mathnormal">e</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.6595em;"></span><span class="mord mathnormal">in</span><span class="mord mathnormal">cre</span><span class="mord mathnormal">m</span><span class="mord mathnormal">e</span><span class="mord mathnormal">n</span><span class="mord mathnormal">t</span></span></span></span></span></div>

Its type is:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo>:</mo><mi mathvariant="double-struck">Z</mi><mo>→</mo><mi mathvariant="double-struck">Z</mi></mrow><annotation encoding="application/x-tex">
program : \mathbb{Z} \rightarrow \mathbb{Z}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6889em;"></span><span class="mord mathbb">Z</span></span></span></span></span></div>

We could pass this function to another function, store it in a collection, compose it with additional functions, or give it a different name.

And mathematically, we could describe its entire input-output relationship as:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><mo stretchy="false">(</mo><mn>2</mn><mo stretchy="false">(</mo><mi>x</mi><mo>+</mo><mn>1</mn><mo stretchy="false">)</mo><msup><mo stretchy="false">)</mo><mn>2</mn></msup></mrow><annotation encoding="application/x-tex">
program(x) = (2(x+1))^2
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord">2</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1.1141em;vertical-align:-0.25em;"></span><span class="mord">1</span><span class="mclose">)</span><span class="mclose"><span class="mclose">)</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8641em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span></span></span></span></span></span></span></span></span></div>

Or:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><mn>4</mn><mo stretchy="false">(</mo><mi>x</mi><mo>+</mo><mn>1</mn><msup><mo stretchy="false">)</mo><mn>2</mn></msup></mrow><annotation encoding="application/x-tex">
program(x)=4(x+1)^2
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord">4</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1.1141em;vertical-align:-0.25em;"></span><span class="mord">1</span><span class="mclose"><span class="mclose">)</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8641em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span></span></span></span></span></span></span></span></span></div>

Or even as a set of ordered pairs:

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>p</mi><mi>r</mi><mi>o</mi><mi>g</mi><mi>r</mi><mi>a</mi><mi>m</mi><mo>=</mo><mo stretchy="false">{</mo><mo stretchy="false">(</mo><mi>x</mi><mo separator="true">,</mo><mn>4</mn><mo stretchy="false">(</mo><mi>x</mi><mo>+</mo><mn>1</mn><msup><mo stretchy="false">)</mo><mn>2</mn></msup><mo stretchy="false">)</mo><mo>∣</mo><mi>x</mi><mo>∈</mo><mi mathvariant="double-struck">Z</mi><mo stretchy="false">}</mo></mrow><annotation encoding="application/x-tex">
program = \{(x,4(x+1)^2) \mid x \in \mathbb{Z}\}
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.625em;vertical-align:-0.1944em;"></span><span class="mord mathnormal">p</span><span class="mord mathnormal">ro</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mord mathnormal" style="margin-right:0.02778em;">r</span><span class="mord mathnormal">am</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">{(</span><span class="mord mathnormal">x</span><span class="mpunct">,</span><span class="mspace" style="margin-right:0.1667em;"></span><span class="mord">4</span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">+</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1.1141em;vertical-align:-0.25em;"></span><span class="mord">1</span><span class="mclose"><span class="mclose">)</span><span class="msupsub"><span class="vlist-t"><span class="vlist-r"><span class="vlist" style="height:0.8641em;"><span style="top:-3.113em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mtight">2</span></span></span></span></span></span></span></span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">∣</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.5782em;vertical-align:-0.0391em;"></span><span class="mord mathnormal">x</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">∈</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathbb">Z</span><span class="mclose">}</span></span></span></span></span></div>

Another lookup table.

An infinite one.

We've constructed a program by composing functions.

And the result is itself a function.

A mapping.

A mathematical object.

In a language with first-class functions, a value.

**Our program is a value.**

There it is.

But let's make sure we understand exactly what we've claimed.

## A Pure Program Is a Value

We've spent a considerable amount of time arriving at a statement that might initially sound ridiculous.

A program is a value.

Not merely something that contains values.

Not merely something that transforms values.

The program itself.

A value.

How can that be?

Because we've been investigating a particular kind of program: one whose meaning can be described entirely through pure computation.

A pure function associates inputs with outputs without producing externally observable side effects.

Given the same input, it produces the same result.

It doesn't secretly modify unrelated state or depend on the current time or the contents of a file.

And when such functions are composed, the resulting computation remains pure.

We can describe that composition mathematically as another mapping.

If our programming language supports first-class functions, we can represent that mapping as another function value.

That's the argument.

It doesn't mean every executable program in every language is literally a first-class runtime value.

Nor does it mean every detail of execution is captured by a mathematical lookup table.

Performance matters. Termination matters. Memory consumption matters. And not every function we can describe mathematically is computable.

Even a pure computation might never terminate, which means we need a more careful mathematical model than an ordinary total function if we want to describe every possible program.

But these qualifications don't erase the central observation.

**A terminating pure computation can be understood by the mapping it defines, and a pure program constructed through function composition can itself be represented as a function value.**

That's a remarkably powerful way to think about programming.

Instead of seeing a program primarily as a sequence of instructions, we can see it as a composition of mathematical relationships.

The implementation tells the computer how to evaluate those relationships, the mathematical model tells us what they mean, and the types help describe which compositions make sense.

## We Didn't Invent Anything

There's something almost disappointing about this discovery.

We started with values.

We introduced functions.

We added decisions, recursion, errors, and types.

We composed increasingly elaborate structures.

And after all that effort, we ended up with another value.

We haven't discovered a new fundamental substance called *program*.

We've constructed something elaborate from simpler mathematical objects.

And perhaps that shouldn't surprise us.

Look around:

- A computer is a composition of components.
- A song is a composition of notes, rhythms, and harmonies.
- A painting is a composition of colors, shapes, and textures.
- A building is a composition of materials arranged according to structural relationships.

The complexity of the result doesn't require its components to become something fundamentally different.

Composition is everywhere.

It was happening long before anybody invented a programming language, a computer, or the word *algorithm*.

Nature doesn't need a `for` loop to describe a repeating pattern, and a tree doesn't need a class definition to have branches. The laws of mathematics don't depend on whether a programming language supports pattern matching.

Those are human inventions—useful ones, certainly, but inventions nonetheless.

The relationships they help us express are more fundamental than the syntax.

And that's worth remembering when we find ourselves debating whether a program should use classes or functions, statements or expressions, loops or recursion.

Those choices matter when we implement software.

But they aren't necessarily the best place to begin when asking what a program actually is.

Perhaps we should start with values.

And the relationships between them.

And the ways those relationships compose.

Because once we understand those things, an enormous amount of programming machinery begins to look like different ways of expressing the same underlying ideas.

## There's a Name for Some of This

We've deliberately avoided introducing much mathematical terminology before we needed it.

But there's one more connection worth mentioning.

In mathematics, there's a field called *category theory*.

Among other things, it studies objects and the relationships between them, with particular attention to composition.

One familiar example is the category **Set**.

Its objects are sets, and its morphisms are functions between sets. Those functions can be composed, provided their domains and codomains line up, and every set has an identity function.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>i</mi><msub><mi>d</mi><mi>A</mi></msub><mo>:</mo><mi>A</mi><mo>→</mo><mi>A</mi></mrow><annotation encoding="application/x-tex">
id_A : A \rightarrow A
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.8444em;vertical-align:-0.15em;"></span><span class="mord mathnormal">i</span><span class="mord"><span class="mord mathnormal">d</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3283em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">A</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">:</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">→</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.6833em;"></span><span class="mord mathnormal">A</span></span></span></span></span></div>

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>i</mi><msub><mi>d</mi><mi>A</mi></msub><mo stretchy="false">(</mo><mi>x</mi><mo stretchy="false">)</mo><mo>=</mo><mi>x</mi></mrow><annotation encoding="application/x-tex">
id_A(x)=x
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal">i</span><span class="mord"><span class="mord mathnormal">d</span><span class="msupsub"><span class="vlist-t vlist-t2"><span class="vlist-r"><span class="vlist" style="height:0.3283em;"><span style="top:-2.55em;margin-left:0em;margin-right:0.05em;"><span class="pstrut" style="height:2.7em;"></span><span class="sizing reset-size6 size3 mtight"><span class="mord mathnormal mtight">A</span></span></span></span><span class="vlist-s">​</span></span><span class="vlist-r"><span class="vlist" style="height:0.15em;"><span></span></span></span></span></span></span><span class="mopen">(</span><span class="mord mathnormal">x</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:0.4306em;"></span><span class="mord mathnormal">x</span></span></span></span></span></div>

Composition also obeys an important law: associativity.

<div class="article-equation"><span class="katex-display"><span class="katex"><span class="katex-mathml"><math xmlns="http://www.w3.org/1998/Math/MathML" display="block"><semantics><mrow><mi>h</mi><mo>∘</mo><mo stretchy="false">(</mo><mi>g</mi><mo>∘</mo><mi>f</mi><mo stretchy="false">)</mo><mo>=</mo><mo stretchy="false">(</mo><mi>h</mi><mo>∘</mo><mi>g</mi><mo stretchy="false">)</mo><mo>∘</mo><mi>f</mi></mrow><annotation encoding="application/x-tex">
h \circ (g \circ f) = (h \circ g) \circ f
</annotation></semantics></math></span><span class="katex-html" aria-hidden="true"><span class="base"><span class="strut" style="height:0.6944em;"></span><span class="mord mathnormal">h</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2778em;"></span><span class="mrel">=</span><span class="mspace" style="margin-right:0.2778em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mopen">(</span><span class="mord mathnormal">h</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:1em;vertical-align:-0.25em;"></span><span class="mord mathnormal" style="margin-right:0.03588em;">g</span><span class="mclose">)</span><span class="mspace" style="margin-right:0.2222em;"></span><span class="mbin">∘</span><span class="mspace" style="margin-right:0.2222em;"></span></span><span class="base"><span class="strut" style="height:0.8889em;vertical-align:-0.1944em;"></span><span class="mord mathnormal" style="margin-right:0.10764em;">f</span></span></span></span></span></div>

In other words, when the types line up, we can group a composition of functions differently without changing the resulting mapping.

This is part of what makes function composition so useful.

And it should sound familiar.

We've spent this entire investigation working with sets, functions, and composition.

We didn't need to know the terminology to discover the structure.

We arrived there by asking what we actually needed to construct a program.

> There's a great deal more to category theory than this, and real programming languages introduce complications that the category of sets alone doesn't capture.

But it's a fitting place to end our mathematical investigation.

We've been exploring an idea that mathematicians have studied with considerable rigor.

We just approached it from the other direction.

Starting with a program.

And taking things away.

Until there was almost nothing left.

Except values.

## And Then Somebody Opened a File

We've constructed a rather elegant little universe.

Values belong to sets, functions map between sets, and functions compose into other functions. Types describe the possibilities.

And a pure program can itself be understood as a value.

Everything fits together.

Everything is predictable.

Everything is mathematical.

Then somebody asks our program to save a file, read a database, display something on a screen, or tell us what time it is.

Consider:

```js
const getTemperature = () => 20
```

This function always returns 20.

Its behavior is entirely predictable.

Now consider:

```js
const getTemperature = () => readThermometer()
```

Same apparent interface.

Very different situation.

Call it once, and you might get 20.

Call it again, and you might get 21.

The result depends on something outside the function's explicit inputs.

The world has entered our program.

And the world isn't particularly interested in preserving our tidy mathematical assumptions.

Of course, that doesn't mean mathematics has nothing to say about side effects.

Quite the opposite.

There are sophisticated ways to model computations that interact with the outside world while preserving many of the benefits of pure functional reasoning.

But those models introduce questions we've deliberately avoided.

- What happens when a computation changes something?
- What does it mean for a function to depend on the outside world?
- Can we represent effects as values and compose them?
- And if we can, does our original argument survive?

We've spent this entire article reducing a program to a composition of values.

Now we have to confront the one thing we've been ignoring.

**What happens when our program actually does something?**

Continue with [And Then Somebody Opened a File](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/).

