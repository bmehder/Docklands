---
title: "State and Effects, Part 1: Where Does Change Live?"
description: "Use a small Svelte API explorer to ask where an interface describes its state transitions, and what reactivity, components, and developer choices each contribute."
published: 2026-10-06
tags: JavaScript, Svelte, State, Effects, Cheeky Tester
featured_image: /assets/images/note-state-and-effects-part-1.webp
featured_alt: Five glass nodes linked by fine threads within a dark open enclosure
---

# State and Effects, Part 1: Where Does Change Live?

{{ featured-image }}

An interface shows us the current state. Understanding its behavior means following how that state changes: what triggers a change, which combinations of values make sense, and which asynchronous operation is still allowed to update the screen.

This series follows one small application through JavaScript and Svelte, then TypeScript, then Gleam and Lustre. The question throughout is **where the rules for change live, and what helps us understand and enforce them**. Keeping the application familiar lets us examine what comes from organizing the code differently, what a type system can check, and what a framework coordinates. The goal is to give you questions to bring to your own applications, with concrete examples of the tradeoffs involved.

Basic JavaScript and familiarity with reactive interfaces will help with the early examples. Some Svelte knowledge is useful, but the relevant behavior is explained as we go. You do not need to know Gleam or Lustre in advance; experience with Elm or Haskell may make the later examples familiar. The series introduces the state and effect concepts through code rather than assuming you already know their terminology.

Cheeky Tester is a compact API explorer for CheekyCMS. Choose an endpoint and it sends a request, then displays JSON, loading state, errors, and response duration. There is one Svelte component and very little code. That makes it a useful place to ask one focused question:

> A component can own its state, but where does it describe how that state is allowed to change?

This example can show us how one request lifecycle is coordinated. It cannot tell us how the same approach feels across dozens of components, years of maintenance, or a large team. Those remain questions for later, not conclusions hidden inside a small demo.

[Run and inspect the original Svelte implementation](https://svelte.dev/playground/c592c1110b2a469eb915157f31117019?version=5.57.2).

## Five values, one interface

The component starts with five reactive values:

```js
let value = $state(base + routes.health)
let output = $state(null)
let loading = $state(false)
let error = $state(null)
let responseTime = $state(null)
```

The template renders those values declaratively: if `loading` is true, show loading; if `error` contains a message, show the failure; if `output` contains data, print the JSON.

The changes that produce each snapshot are imperative assignments. At the beginning of a request, the effect resets three fields:

```js
loading = true
error = null
responseTime = null
```

After a successful response is parsed, a callback changes two others:

```js
output = data
responseTime = performance.now() - startedAt
```

Failure and completion have their own assignments:

```js
if (cause.name !== 'AbortError') {
  error = cause.message
}
```

```js
.finally(() => loading = false)
```

None of this is concealed from the reader. The assignments are ordinary JavaScript, close to the asynchronous events that produce them. But there is no single description of “request started,” “request succeeded,” or “request failed.” A reader reconstructs those transitions by following the effect and its callbacks.

Svelte makes this combination natural: imperative changes to reactive values, followed by declarative rendering of the latest values.

## The coordination chain

Selecting an endpoint changes the bound URL. The `$effect` reads that URL synchronously, so Svelte records it as a dependency. Changing the selection therefore starts this chain:

```text
selection changes
    ↓
value receives the new URL
    ↓
Svelte detects a tracked dependency
    ↓
the effect runs
    ↓
fetch starts
    ↓
an asynchronous callback assigns state
    ↓
Svelte updates the rendered output
```

Svelte coordinates dependency tracking, schedules the effect, updates the DOM, and runs the effect's cleanup before a rerun or component destruction. The developer coordinates the meaning of the state fields, the assignments made at each asynchronous step, and the policy for obsolete requests.

Those responsibilities should not be blurred together. The framework gives the program a reactive mechanism; it does not decide the application's transitions for us.

## Ownership is not the same as transformation

All five values belong to one component. That boundary limits which code can access them and keeps the implementation local. Component encapsulation is one effective way to manage mutable state: reduce the number of places that can reach it.

A different question is which transformations of that state are valid. Encapsulation answers “who can change this?” A transition function or named operation can answer “how may it change?” The two approaches can coexist. A component can own state while delegating its state decisions to explicit transformations.

This app has only one component, so it is not evidence for or against a multi-component Svelte architecture. Svelte runes can also live in `.svelte.js` and `.svelte.ts` modules outside components. Local component state is the choice visible here, not the only organizational tool Svelte provides.

The interesting point is narrower: state does not need to escape its owner before its transitions become distributed across several assignments and callbacks.

## One request lifecycle, spread across fields

`output`, `loading`, `error`, and `responseTime` are separate values, but together they describe one request lifecycle. Their combinations carry meaning:

- Loading with no result can mean the first request is pending.
- Loading with existing output can mean a new request is pending while old data remains visible.
- An error alongside older output can preserve useful context after a failure.
- No loading, error, or output can describe the initial render.

Some combinations may be accidental; others may be deliberate interface policy. Keeping old output during loading is not automatically invalid. It does, however, raise an attribution question when the selected URL belongs to request B and the displayed JSON still belongs to request A.

The aim of state modeling is to represent the combinations the interface actually needs. If loading, success, and failure are mutually exclusive, a single tagged value can express that choice. If the interface retains an earlier response while another request loads, the model needs to represent both facts. Choosing the intended behavior comes before choosing the representation. [Make Impossible States Impossible with PHP Enums](/notes/make-impossible-states-impossible/) explores the same principle in another setting.

The same architectural question appears in smaller details. The component displays `200 OK` when it is neither loading nor showing an error, rather than retaining the actual response status. It measures elapsed time once at response headers and overwrites it after JSON parsing. These are not merely labels to fix; they show that the meaning of the request is distributed between state assignments and rendering conditions.

## Ownership also changes over time

Asynchronous work adds another kind of ownership: which request is still allowed to update shared state?

The effect returns cleanup that aborts its controller before the next run and on destruction. That asks the browser to cancel obsolete work. From code inspection, there is still a possible sequence worth examining:

1. Request A starts and sets `loading = true`.
2. A new selection aborts A, then request B starts and sets `loading = true`.
3. A's promise chain reaches its unconditional `finally`.
4. A sets `loading = false` while B may still be pending.

This is a possible lifecycle race, not a claim that every rapid selection reproduces it. Timing matters. It illustrates the larger issue precisely: owning the current component state is not enough; an asynchronous operation also needs a policy for whether it still owns permission to commit a transition.

The problem is not unique to Svelte, and a message-based architecture would not solve it automatically. When requests can overlap and obsolete results should not replace the current state, the implementation needs a way to decide which request may still update it. Cancellation and request identity are two tools for expressing that policy.

## What would an explicit transition look like?

One alternative is to name events and make the state decision in a pure function. Svelte can support this style; it does not require changing frameworks.

Here is conceptual JavaScript, not a completed rewrite of Cheeky Tester:

```js
function update(request, message) {
  switch (message.type) {
    case 'started':
      return { tag: 'loading' }

    case 'succeeded':
      return {
        tag: 'success',
        data: message.data,
        elapsed: message.elapsed
      }

    case 'failed':
      return {
        tag: 'failure',
        message: message.error
      }

    default:
      return request
  }
}
```

The imperative boundary could still assign the result to reactive state:

```js
request = update(request, {
  type: 'started'
})
```

This changes where a reader finds the state decisions. Instead of reconstructing them from assignments in several callbacks, the reader can inspect one transition function. Because the function only maps an old value and a message to a new value, its decisions can be tested without mounting a component or making a request.

The HTTP request, clock, cancellation, and connection between effects and messages still require integration code and integration tests. With this structure, a request callback reports what happened, and the transition function decides how the state changes in response. The effect still performs the external work; the state decision has an identifiable home.

That structure has a cost: more names, more messages, more wiring, and another concept for a reader to learn. For a component this small, it might clarify the program or merely restate obvious control flow at greater length. That is the fair comparison question, not a conclusion we can answer in advance.

## The experiment ahead

This series compares four core implementations across five articles:

1. The original Svelte JavaScript
2. A revised Svelte JavaScript design
3. The same revised runtime design with TypeScript
4. An idiomatic Gleam and Lustre design

The comparison separates developer choices from language and framework contributions. Revising the Svelte version can show what changes when we organize the same JavaScript differently. TypeScript can then show which conventions become static guarantees. Gleam and Lustre can show what custom types, messages, pure updates, and runtime-managed effects look like in their native architecture—including their costs. Part 4 also compares multiple ways to place the Lustre version's HTTP boundary, while Part 5 draws the findings together rather than adding a fifth implementation.

Part 2 stays in Svelte and JavaScript. Its question is not “how do we fix every detail?” It is whether naming the request lifecycle, choosing explicit triggers, and making stale-result ownership visible improves the path between snapshots enough to justify the added structure.

Continue to [Part 2: Modeling a Request in Svelte](/notes/state-and-effects-part-2-modeling-a-request-in-svelte/).
