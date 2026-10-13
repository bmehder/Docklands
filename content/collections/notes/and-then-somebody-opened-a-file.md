---
title: "And Then Somebody Opened a File"
description: "How programs can describe interactions with the outside world as values, while execution still performs the work."
published: 2026-10-13
tags: Programming, Functional Programming, Side Effects
featured_image: /assets/images/note-and-then-somebody-opened-a-file.webp
featured_alt: Glass components connected through a transparent panel to a stack of paper
---

# And Then Somebody Opened a File

{{ featured-image }}

*Can a program that changes the world still be a value?*

We had everything under control.

Values belonged to sets. Functions mapped between sets. Functions composed into other functions.

We built increasingly elaborate computations from simpler ones.

And the result was another function.

Another value.

In [the previous article](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/), we arrived at a rather satisfying conclusion:

**A pure program is a value.**

Then somebody opened a file.

And now we have a problem.

## The World Doesn't Take Arguments

Suppose we have a function that counts the words in some text. Give it the same text, and it returns the same count. Nothing particularly difficult to explain.

Now suppose we have a function that counts the words in a file. Give it a filename, and it reads the file and returns the count.

Same filename. Same count?

Perhaps—unless somebody edited the file, deleted it, or changed our permission to read it.

The filename hasn't changed. The result might have.

We've introduced something that isn't accounted for by the function's explicit input.

The state of the world.

And the world has a habit of changing without asking us first.

Our simple picture of a mapping from inputs to outputs no longer tells the whole story.

> We're using “effects” broadly to include both observing external conditions and changing them. Reading a file need not modify its contents, but its result can depend on state outside the computation's explicit inputs.

So what do we do?

Abandon the picture?

Perhaps we should try something smaller first.

## Could We Just Pass the Text In?

Our word-counting function doesn't actually need a file; it needs text. The file is where the text happens to be. Those are different concerns.

Suppose somebody else reads the file and gives us its contents.

Now our function accepts text and returns a number.

```js
const countWords = text => {
  const words = text.trim()
  return words === "" ? 0 : words.split(/\s+/u).length
}

countWords("A program is a value") // 5
```

No filename. No filesystem. Just text and a count.

Same text. Same number.

We're back to a pure computation.

That was easy.

A little too easy.

Because somebody else still had to read the file.

We haven't removed the interaction with the world. We've moved it.

Which can be useful. We now have a computation we can understand without knowing anything about files, permissions, or disks.

But we haven't answered the original question.

Our complete program still needs to open a file.

And eventually, somebody has to do it.

## What If We Asked Instead?

Let's consider what we mean when we say that our program needs to read a file.

We know which file we want, which operation we want to perform, and what kind of result we're expecting.

Could we write that down?

Of course we could.

Imagine a little request:

<table><thead><tr><th>Operation</th><th>File</th></tr></thead><tbody><tr><td>Read text</td><td>article.txt</td></tr></tbody></table>

Nothing has been read.

The file might not even exist.

We've simply described an interaction we'd like to perform.

In JavaScript, that request could be an ordinary object:

```js
const readRequest = {
  operation: "readText",
  file: "article.txt"
}
```

And what is that description?

Information.

A value.

Now imagine another request:

<table><thead><tr><th>Operation</th><th>File</th><th>Contents</th></tr></thead><tbody><tr><td>Write text</td><td>count.txt</td><td>427</td></tr></tbody></table>

Nothing has been written.

But we've described what we want written, and where.

Another value.

```js
const writeRequest = {
  operation: "writeText",
  file: "count.txt",
  contents: "427"
}
```

These objects don't perform file operations. They contain information describing them.

This is beginning to look familiar.

We introduced something that seemed to require an escape from our universe of values, and our first attempt to describe it has produced another value.

But there's an objection.

A fairly obvious one.

## You Haven't Actually Done Anything

Correct.

Writing down a request to save a file doesn't save a file.

Writing down a request to turn on a light doesn't turn on a light.

And writing down a request to send a message doesn't mean anybody received it.

A description of an action and the action itself are different things. We should keep that distinction; it's doing useful work.

Think about a recipe.

A recipe describes what to do, but it doesn't heat the oven or crack an egg. And we would be disappointed if we tried to eat it.

Nevertheless, it can describe a process that produces dinner.

Its existence as a description doesn't prevent somebody from carrying it out.

The same is true of our request.

Something with access to the filesystem has to interpret it: read the request, attempt the operation, and report what happened.

The request is a value.

Carrying it out is an interaction with the world.

**Representing an interaction as a value doesn't make the interaction disappear.**

It gives us something we can examine and compose before the interaction happens.

That's a more modest claim.

But perhaps it's enough.

## The World Can Answer With a Value

Suppose our request is interpreted.

The file is opened.

What comes back?

Text, if the read succeeds.

Or information explaining why it failed.

We explored that possibility in [the previous article](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/). A result can distinguish a successful value from an error.

The file interaction happened outside our pure computation, but the result can come back into it as a value.

Now we can count the words.

If the read failed, we can decide what to do with the error.

If it succeeded, we can decide what to do with the count.

Those decisions can be pure computations because they depend on the result we were given.

Same result. Same decision.

The world might give us different results on different occasions, but our response to each particular result can still be described predictably.

That's an important distinction.

**We don't have to predict what the world will do to describe how our program will respond.**

> This accounts for outcomes our interaction model can report. It doesn't guarantee that every interruption becomes a result: a process can be terminated, a machine can lose power, or an operation can fail to finish.

So far, we have a request.

And we have a possible response.

But a program usually needs more than one conversation with the world.

## What Happens Next?

Let's make our program slightly more ambitious.

1. Read a file.
2. Count its words.
3. Write the count to another file.

We could describe this as a list of requests.

Read this. Write that.

Except we don't yet know what “that” is.

We haven't read the first file, so we don't know its contents or its word count. We don't even know whether reading it will succeed.

A fixed list of fully specified requests won't capture this dependency.

We need something that accepts a result and describes the next step *after we receive that result*.

What kind of thing could do that?

A function.

Of course.

We already have those.

The function doesn't need to read or write anything itself.

Give it a successful read result, and it produces a request to write the word count.

Give it a failed read result, and it produces whatever next step we've chosen for that failure.

Perhaps a request to display an explanation, or a completed result saying that the program couldn't proceed.

We can describe the relationship even though we don't yet know which input we'll receive.

That's what functions are for.

And in the representation we're exploring, that function is another value.

We can put the request and its continuation together:

```js
const program = {
  request: readRequest,
  next: afterRead
}
```

Two fields. A request and a function describing how to continue.

What does `afterRead` describe?

```js
function afterRead(result) {
  if (!result.ok) {
    return { finished: result }
  }

  return {
    request: {
      operation: "writeText",
      file: "count.txt",
      contents: String(countWords(result.text))
    },
    next: afterWrite
  }
}

function afterWrite(result) {
  return { finished: result }
}
```

Here, we're imagining a read result shaped like `{ ok: true, text: "..." }` or `{ ok: false, error: "..." }`. A write result reports success or failure. An object with `finished` says there are no more requests to perform.

Give `afterRead` a failed read result, and it finishes with that result. Give it some text, and it produces a write request containing the word count. The write request names another continuation, `afterWrite`, which finishes with the write result.

The program description is an object. Its `next` field contains a function value. That function describes the relationship between a result we haven't received yet and the next step.

Nothing in this example opens a file.

Now our program description has two parts:

- A request describing the interaction we want to perform.
- A function describing how to continue when its result arrives.

We've combined a value with a function value.

And what have we constructed?

Another value.

## A Program With a Blank Space

There is something slightly strange about this description: it represents a program whose future isn't fully known.

We know what to request first.

We know how to respond.

But we don't know which response the world will supply.

You might picture a branching diagram.

<figure><img src="/assets/diagrams/effect-branches.svg" alt="Possible outcomes of reading and writing a file" style="width:100%;height:auto" loading="lazy"></figure>

The read request doesn't yet contain the word count. The continuation determines the write request from the text that comes back.

At each interaction, several outcomes are possible, and each leads to a next step. Some steps request another interaction; others finish with a result.

The actual execution follows one path through those possibilities.

The program describes how that path is determined.

We don't need to draw every branch in advance. There might be infinitely many possible file contents, but our continuation function can describe what to do with any result in its domain.

That should remind us of something.

Our infinite lookup table.

We didn't need to store every association to describe a pure function.

Here, we don't need to enumerate every possible conversation with the world to describe how to continue one.

The function gives us a compact relationship between a response and the rest of the program.

> This is a conceptual model, not a requirement to store a literal tree of future actions. Loops, ongoing interactions, and computations that never finish require descriptions that can keep producing further steps.

The program has a blank space for the world's answer, but the relationship around that blank space is already defined.

## Order Hasn't Gone Away

There's another objection waiting for us.

Side effects have an order.

Read a file before deleting it, and we might obtain its contents.

Delete it before reading it, and we might obtain an error.

Those are different programs.

Can a value express that difference?

Certainly.

A list is a value, and its elements have an order.

A more elaborate program description can express dependencies as well.

Our word-counting example doesn't merely say that reading and writing both occur.

It says that the write request is determined by the read result.

The dependency is part of the description.

Representing a program as a value doesn't erase its structure.

It allows us to describe that structure.

Order. Choices. Repetition. Dependencies.

Values can carry information about all of those things.

We should remember this when we hear the word “value” and imagine something small and inert.

The number 42 is a value.

So is a function describing infinitely many associations.

And so is a structure describing an extended interaction with the outside world.

Being a value doesn't mean being simple.

## Can We Compose These Things?

Now we can ask the question that made [the first article](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/) interesting.

Suppose we have one description of a program that reads some text.

And another way to construct a program that writes a word count, given some text.

Can we connect them?

The first program's result becomes the input used to determine the second.

We've described a larger program.

And that larger program can use the same form of description as its smaller pieces.

It can request an interaction, accept a response, determine a next step, and eventually produce a result.

We haven't introduced a new kind of thing called “a program made of two programs.”

We have another program description.

Another value.

We can connect it to a third.

Or choose between it and another description.

Or construct it only when a previous response tells us that it's needed.

The pieces compose.

And the result is another piece of the same general kind.

We are finding our way back to familiar territory.

> Composing effectful descriptions isn't always ordinary mathematical function composition. The connections must preserve the intended interactions and their dependencies. We're exploring the underlying idea here, rather than the machinery a particular language uses to express it.

But there's still something unsettled.

Where did the actual effects go?

## They Didn't Go Anywhere

The filesystem, the thermometer, and the person waiting for our message are still there. Our program doesn't get to wish any of them away.

Eventually, an interpreter has to perform the described interactions.

And the choice of interpreter matters.

One might read from a real filesystem.

Another might answer from a collection of example files held in memory.

Another might record the requested operations so we can inspect them.

The same description can be interpreted in different ways, provided those interpreters can handle its requests.

They won't necessarily produce the same results.

They aren't necessarily interchangeable for every purpose.

But the distinction gives us something useful to reason about.

- What did the program request?
- What response did it receive?
- What did it determine should happen next?
- What did the interpreter actually do?

Those questions concern related parts of one process.

We can examine them separately.

We can also distinguish a request from a guarantee.

Our program may request that a file be written.

The interpreter may attempt it.

The attempt may fail.

Representing the request as a value doesn't guarantee that the world will cooperate.

It gives us a clear place to express what cooperation we're asking for, and how to respond when we don't get it.

That's useful enough.

## But Isn't This Just Writing Down Instructions?

Yes.

In a sense, we've come full circle.

We began [the previous article](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/) by questioning the idea that a program must be understood as a collection of instructions.

Now we're describing instructions as values.

Have we contradicted ourselves?

No.

An instruction can describe an operation.

That description can have structure.

It can be combined with other descriptions.

It can contain functions determining how to continue.

And it can be represented as a value.

The fact that somebody can interpret a value as an instruction doesn't stop it from being a value.

Consider the distinction we made for pure functions.

A function's meaning and the process of evaluating it weren't the same thing.

The function could be a value.

Evaluating it still required a computation.

Here, the program description can be a value.

Interpreting it still requires a computation.

And that computation may interact with the world.

The distinction has become more consequential.

But it hasn't become incoherent.

## So Are Side Effects Values Too?

We should answer carefully.

A file being changed is an event in the world.

A request to change that file can be a value.

A computation that describes how to request the change, respond to its outcome, and continue can also be represented as a value.

When programmers talk about representing effects as values, this is the kind of distinction we need to keep in view.

We aren't claiming that describing a file write performs it.

We're claiming that an effectful computation can have a representation we can construct and compose before running it.

Our word-counting program reads a file and writes another.

Its execution interacts with external state.

It is effectful.

Yet we can represent the whole program as a value.

The requests.

The possible responses.

The functions determining what happens next.

The resulting composition.

All of it.

**Even an impure program can be represented as a value.**

> This is a claim about how we can represent a program, not a claim that every language exposes every effectful program as a first-class value. Constructing the representation must also be distinguished from executing it; eagerly performing an action and storing its result doesn't defer that action.

That qualification matters.

But so does the conclusion.

We don't have to give up composition when the world enters our program.

We have to account for the interaction.

## Right Back Where We Started

We thought side effects would take us outside our universe of values.

And executing them does bring something else into the picture.

The world.

But the program that describes those interactions?

The requests it makes. The results it accepts. The relationships that determine what happens next.

We can compose all of that into a value.

Running it might change a file.

Or send a message.

Or turn on a light.

The program can still be a value.

We haven't made the world pure.

We've found a way to describe how we intend to interact with it.

And somehow, after everything we've introduced, we're right back where we started.

Values.

Continue with [Solving Problems with Values](https://docklands-ssg.vercel.app/notes/solving-problems-with-values/).
