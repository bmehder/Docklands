---
title: "Solving Problems with Values"
description: "Use types, messages, and pure transitions to solve a search-interface problem, with a small coordinator that handles effects."
published: 2026-10-13
publication_order: 3
tags: Programming, Functional Programming, Types, Gleam
featured_image: /assets/images/note-solving-problems-with-values.webp
featured_alt: Four glass chambers linked by amber channels, with one glowing sphere marking the current state
---

# Solving Problems with Values

{{ featured-image }}

*How can we make a program easier to understand?*

We have been taking programs apart.

In [What Is a Program, Really?](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/), we found values, functions, types, and composition.

In [And Then Somebody Opened a File](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/), we let the world back in. Files could be read. Messages could be sent. We discovered that a program describing those interactions could still be represented as a value.

That's a satisfying idea, but eventually we have to build something.

Somebody wants a search box. They type a few words, press a button, and results appear.

How difficult could that be?

## Apparently, Quite Difficult

What should the screen show before the first search?

What should it show while we're waiting?

What if the search fails?

What if it succeeds but finds nothing?

What if somebody searches again before the first request finishes?

What if the second request finishes first?

The search box hasn't become especially complicated.

Our understanding of the problem has.

And this is where programming often becomes harder than we expected.

We know how to send a request, display a list, and respond to a button click.

But those individual abilities don't tell us how the whole thing should behave.

We need rules.

Before we choose where to put the code, perhaps we should decide what the code is supposed to mean.

## What Situations Can We Be In?

Let's start with a question we can answer without a framework.

What situations can our search be in?

- We haven't searched yet.
- We're waiting for a search.
- We have results.
- The search failed.

Four possibilities.

We could represent them with several independent values: a loading flag, a list of results, and an optional error.

But then we would have to decide what every combination means.

Loading and an error?

An error and results?

All three at once?

Some interfaces deliberately support those combinations. A search might keep old results visible while refreshing them.

Ours won't.

For this example, starting a search replaces the previous outcome with a waiting state. A completed search gives us either results or an error.

That's a decision about the problem.

Now we can describe it.

Let's use a little Gleam.

```gleam
pub type SearchState {
  Idle
  Searching(query: String)
  Found(query: String, results: List(String))
  Failed(query: String, reason: String)
}
```

If Gleam is unfamiliar, read this as a list of alternatives.

A `SearchState` is one of these four things.

Some alternatives carry additional information. A successful search carries the query and its results. A failed search carries the query and a reason.

An empty list of results still belongs to `Found`: we searched successfully but found nothing. That's different from failing to search, and we've made the distinction explicit.

And we cannot construct a value that is simultaneously `Searching` and `Failed` using this type.

> Types enforce the distinctions we actually encode. They don't decide whether those distinctions fit the product, guarantee a successful request, or prevent us from writing an incorrect transition.

The compiler can help us keep our promises.

We still have to choose sensible promises.

## What Do We Need to Remember?

The search state isn't everything we know.

There's also the text currently in the input box.

Isn't that the query we've already stored?

Sometimes.

But suppose somebody submits “values” and then starts typing “functions” while waiting.

The input contains “functions”, while the pending search concerns “values”. Those are different facts, so let's give them different places in our model.

```gleam
pub type Model {
  Model(
    query: String,
    search: SearchState,
    next_request_id: Int,
  )
}
```

The `query` field contains the draft in the input box. The `search` field describes the submitted search.

The final field will help us distinguish requests. We'll need it shortly.

Our starting value is straightforward:

```gleam
pub fn initial_model() -> Model {
  Model(query: "", search: Idle, next_request_id: 1)
}
```

Nothing has happened yet.

We have a value describing that situation.

## What Can Happen?

- The user can edit the query.
- The user can submit a search.
- The outside world can report the outcome of a request.

These are things that happen to our application.

Could we describe them as values too?

We already know the answer.

First, let's give each request an identity:

```gleam
pub type RequestId {
  RequestId(Int)
}
```

Wrapping the number lets us distinguish a request identifier from an ordinary integer in function signatures.

Now we can describe our events:

```gleam
pub type Message {
  UserEditedQuery(String)
  UserSubmittedSearch
  HttpReturnedSearch(RequestId, Result(List(String), String))
}
```

`UserEditedQuery` carries the new text.

`UserSubmittedSearch` says that the user wants to search using the current draft.

`HttpReturnedSearch` identifies the request and carries either results or an error. Gleam's `Result` uses `Ok` for success and `Error` for failure.

The names tell us where each message comes from. `User` identifies an interaction with the interface; `Http` identifies a response from the search request.

Before we inspect the data it carries, we can already tell what produced the message.

We could call these events. We've called them messages because each value communicates something that happened.

## What Should We Ask the World to Do?

Submitting a search should cause a request.

But we don't need to send the request inside the function that decides our next state.

We explored that distinction in [the previous article](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/).

We can return a description of the interaction we want.

```gleam
pub type Effect {
  SearchRequested(RequestId, String)
}
```

A request identifier and a query.

That's enough to describe the operation for this example.

It doesn't contact a server, start a timer, or secretly update the screen.

Another part of the program will interpret it, perform the request, and report a `HttpReturnedSearch` message with the same identifier.

We've described both sides of the conversation.

What we ask for.

What comes back.

Now we need to decide what those messages mean for our application.

## One Question, Asked Repeatedly

Given what we know, and what just happened, what should happen next?

That's the question.

We can express its shape before writing its rules:

```gleam
pub fn update(model: Model, message: Message) -> #(Model, List(Effect)) {
  case message {
    UserEditedQuery(text) -> #(Model(..model, query: text), [])
    UserSubmittedSearch -> submit(model)
    HttpReturnedSearch(id, result) -> receive(model, id, result)
  }
}
```

The function receives the current model and a message.

It returns a pair: the next model and a list of requested effects. In Gleam, `#(...)` constructs a tuple.

Editing the input produces a new model with different draft text. `Model(..model, query: text)` preserves the other fields.

The empty list means that this transition requests no effect.

Submitting a search and receiving a result need a little more explanation. We've given those rules names so we can examine them separately.

Notice what we haven't written:

- A request callback that changes a loading flag.
- A click handler that changes several pieces of state.
- A second callback that changes some of them back.

We have a function describing a relationship.

Current model and message in.

Next model and effect descriptions out.

Same inputs. Same outputs.

We're using the ideas from [the first article](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/) and [the second](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/) to organize an actual problem.

## Starting a Search

Let's choose a rule for submission.

Trim the query. If it's blank, return to `Idle` and request nothing.

Otherwise, give the search a fresh identifier, enter the waiting state, and request the search.

To remember which request we're waiting for, we'll refine our earlier `SearchState` definition:

```gleam
pub type SearchState {
  Idle
  Searching(id: RequestId, query: String)
  Found(query: String, results: List(String))
  Failed(query: String, reason: String)
}
```

The `Searching` alternative now carries the request identity as well as its query. This definition replaces our first sketch.

Here is the submission rule:

```gleam
import gleam/string

pub fn submit(model: Model) -> #(Model, List(Effect)) {
  let query = string.trim(model.query)

  case query {
    "" -> #(Model(..model, search: Idle), [])
    _ -> {
      let id = RequestId(model.next_request_id)

      let next_model = Model(
        ..model,
        search: Searching(id, query),
        next_request_id: model.next_request_id + 1,
      )

      #(next_model, [SearchRequested(id, query)])
    }
  }
}
```

There is no network code here.

But the decision is complete.

We know what the application should remember. We know what it should ask the world to do.

And we can inspect both values before anything is sent.

> The counter is a simple identity policy for one running application. The wrapper distinguishes types; our transition rule allocates fresh identifiers. Neither alone solves persistence, coordination between applications, or unbounded counter growth.

That may sound like a lot of ceremony for a search box.

Let's see what it buys us.

## The Wrong Answer Arrives

The user searches for “values”, starting request 1. Then they search for “functions”, starting request 2.

Request 2 finishes first, and we display its results. Then request 1 finishes.

Should it replace them?

Probably not.

But “probably not” isn't a rule the computer can follow.

Let's make it one.

**Only the request we're currently waiting for may determine the search outcome.**

We can express that rule directly:

```gleam
pub fn receive(
  model: Model,
  id: RequestId,
  result: Result(List(String), String),
) -> #(Model, List(Effect)) {
  case model.search {
    Searching(active_id, query) if id == active_id -> {
      let search = case result {
        Ok(results) -> Found(query, results)
        Error(reason) -> Failed(query, reason)
      }

      #(Model(..model, search: search), [])
    }

    _ -> #(model, [])
  }
}
```

If we're waiting for this request, its result determines the next search state.

Otherwise, we keep the model we already have.

Neither an old success nor an old failure replaces newer results.

And a response arriving after we've returned to `Idle` doesn't revive a search we've stopped treating as current.

That last possibility follows from the blank-submission rule we chose earlier.

We can see how the rules fit together.

> Ignoring an obsolete result isn't the same as canceling its request. The request may still consume resources or finish elsewhere. Cancellation could be another requested effect, but this example only establishes which responses may change our model.

We haven't made asynchronous work arrive in order.

We've described which arrival matters.

That's a smaller problem.

And we've solved it with a function over values.

## Walk Through It

We can follow the application without running a browser.

<table><thead><tr><th>What happened</th><th>Search state afterward</th><th>Requested effect</th></tr></thead><tbody><tr><td>Submit “values”</td><td>Waiting for request 1, “values”</td><td>Search for “values”, request 1</td></tr><tr><td>Submit “functions”</td><td>Waiting for request 2, “functions”</td><td>Search for “functions”, request 2</td></tr><tr><td>Request 1 succeeds</td><td>Still waiting for request 2</td><td>None</td></tr><tr><td>Request 2 succeeds</td><td>Results for “functions”</td><td>None</td></tr><tr><td>Request 1 reports again</td><td>Still results for “functions”</td><td>None</td></tr></tbody></table>

Each row asks the same question.

What do we know?

What happened?

What should happen next?

The answer doesn't depend on finding the right callback, guessing which flags have already changed, or reconstructing a sequence of assignments.

It depends on two inputs to a function.

That doesn't make every program easy.

But it gives us a very useful place to look.

## What Should the User See?

Our application now knows its situation, and the screen should express it.

Do we need another collection of flags to remember whether the spinner is visible, the error is displayed, and the results are showing?

We could introduce them, but then we'd have to keep them consistent with the search state.

Perhaps we should derive the description instead.

For this article, we'll describe a screen as ordinary data:

```gleam
pub type Screen {
  Screen(input: String, notice: String, items: List(String))
}

pub fn view(model: Model) -> Screen {
  let #(notice, items) = case model.search {
    Idle -> #("Enter a query to begin.", [])
    Searching(_, query) -> #("Searching for " <> query <> "…", [])
    Found(query, []) -> #("No results for " <> query <> ".", [])
    Found(query, results) -> #("Results for " <> query <> ":", results)
    Failed(query, reason) -> #("Search for " <> query <> " failed: " <> reason, [])
  }

  Screen(input: model.query, notice: notice, items: items)
}
```

The `<>` operator joins strings.

We haven't chosen HTML elements or a component library. `Screen` just describes the draft text, a notice, and any results to display.

Notice that a completed search names its submitted query, even if the user has since edited the input.

The two facts remain distinct on the screen because they remain distinct in our model.

Same model. Same description.

The rendering machinery can turn that description into something visible.

The browser still has to change what it displays.

But deciding what it should display is another pure function.

## Somebody Still Has to Run It

We've written down our rules.

We haven't produced a working search interface yet.

Something must translate input changes and button clicks into messages.

Something must call `update`, retain its returned model, and arrange to display `view(model)`.

Something must interpret `SearchRequested`, perform the request, and translate its response into another message.

Let's write the coordination ourselves.

We'll give it four operations supplied by its surroundings:

- Receive the next message from a queue.
- Put a message into that queue.
- Render a screen description.
- Start a search and report its result when it finishes.

User interactions put messages into the queue. Search responses will use the same entrance.

Here's the small interface between our coordinator and the outside world:

```gleam
pub type Runtime {
  Runtime(
    next_message: fn() -> Result(Message, Nil),
    enqueue: fn(Message) -> Nil,
    render: fn(Screen) -> Nil,
    search: fn(String, fn(Result(List(String), String)) -> Nil) -> Nil,
  )
}
```

The `search` operation receives a query and a function to call with the eventual result. It starts the request and returns without waiting for that result.

`next_message` waits for a queued message and returns `Ok(message)`. An `Error(Nil)` means the queue has closed and our coordinator should stop.

Those operations deal with the environment. The coordination itself is ours:

```gleam
import gleam/list

pub fn run(runtime: Runtime) -> Nil {
  let model = initial_model()
  runtime.render(view(model))
  loop(model, runtime)
}

fn loop(model: Model, runtime: Runtime) -> Nil {
  case runtime.next_message() {
    Ok(message) -> {
      let next_model = handle(model, message, runtime)
      loop(next_model, runtime)
    }
    Error(Nil) -> Nil
  }
}

pub fn handle(model: Model, message: Message, runtime: Runtime) -> Model {
  let #(next_model, effects) = update(model, message)
  runtime.render(view(next_model))
  list.each(effects, fn(effect) { perform(effect, runtime) })
  next_model
}

pub fn perform(effect: Effect, runtime: Runtime) -> Nil {
  case effect {
    SearchRequested(id, query) -> {
      runtime.search(query, fn(result) {
        runtime.enqueue(HttpReturnedSearch(id, result))
      })
    }
  }
}
```

[`list.each`](https://gleam-stdlib.hexdocs.pm/gleam/list.html#each) calls our function for every requested effect. There may be none.

Look at where the model lives: it's the argument to `loop`. Each turn passes the returned model into the next turn. That's how our coordinator remembers the current state.

And look at what the search callback remembers: the request identifier. It doesn't keep a copy of the model or try to change one. It puts a result message into the queue.

**The effect handler reports what happened. `update` decides what it means.**

Suppose the user submits “values”. Our coordinator receives `UserSubmittedSearch`, calls `update`, renders the waiting screen, and starts the requested search. Then it continues receiving messages with the new model.

When the response arrives, the callback queues `HttpReturnedSearch`. The coordinator handles that message using whatever model is current at that point.

If another search has replaced the first, our existing rule rejects the obsolete response. The effect handler doesn't need to know that rule.

Even if a search reports its result immediately, the callback only queues a message. That message is handled on a subsequent turn, after `handle` has returned the new model.

> This is a mailbox-style coordinator: it needs a queue that can wait independently of the work producing messages. It could run in an Erlang process. A browser would arrange the turns through its event loop instead of blocking for a message. We've left the queue, HTTP client, and rendering adapters outside this example; we've implemented the coordination that connects them.

Now the diagram has something concrete behind it.

The structure we want it to coordinate looks like this:

<figure><img src="/assets/diagrams/model-message-effects.svg" alt="Messages update a model, derive a view, and request effects that produce more messages" style="width:100%;height:auto" loading="lazy"></figure>

The arrows describe how information moves.

The functions describe what it means.

And the runtime coordinates execution.

Those responsibilities fit together, but they don't have to collapse into one place.

In [the previous article](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/), a continuation described what to do with an interaction's result.

Here, we express that continuation through a result message and the next call to `update`.

The result still becomes an input to a pure decision.

We've organized the same underlying idea around an application that keeps receiving events.

> Our effect type is a small domain-specific description. Frameworks may represent effects differently, and a real adapter must translate external responses into the values our model expects. We've deliberately left networking, decoding, HTML, and the environment's queue implementation outside this example.

We can now discuss those implementation choices without asking them to invent our behavior for us.

We've already described the behavior.

## Did We Solve the Problem, or Just Organize It?

Both.

But we should distinguish them.

We solved several particular problems by choosing particular rules:

- An empty submission returns to `Idle`.
- A new search replaces the previous outcome.
- Only the current pending request may determine the outcome.
- Editing draft text doesn't change the identity of a submitted search.

Those are our decisions.

Another product might make different ones.

It might retain previous results while loading. It might search as the user types. It might support several simultaneous searches.

The structure doesn't tell us which product to build.

It gives us a way to express the decisions, examine their consequences, and change them deliberately.

That's where much of the benefit lies.

We can ask:

- Does a state mean what we think it means?
- Does an event carry the information needed to handle it?
- Does a transition preserve the rules we chose?
- Does an effect description request the right interaction?

The names and types make those questions concrete, and the functions give us answers we can inspect.

## There's a Name for This, Too

We can write this coordination ourselves, as we just did. We can also use a framework that provides it.

If the shape looks familiar, there's a reason.

Model. Messages. Update. View.

This is the structure associated with [The Elm Architecture](https://guide.elm-lang.org/architecture/). Elm organizes interactive applications around a model, an update function responding to messages, and a view derived from the model.

[Lustre](https://lustre.hexdocs.pm/lustre.html) brings a related Model–View–Update structure to Gleam, with a runtime coordinating messages, rendering, and effects.

We haven't implemented either framework's complete application interface here.

We arrived at the structure by asking what our problem needed:

- A description of what we know.
- A description of what happened.
- A function determining what should happen next.
- A description of what to show.
- A way to request interactions with the world.

The architecture has a name.

The questions were useful before we knew it.

## How Does This Make Programming Easier?

It doesn't remove the need to understand the problem.

It gives us somewhere to put that understanding.

The possible situations become types.

The current situation becomes a value.

Events become values.

The rules for change become functions.

Interactions become descriptions we can return.

And the visible interface follows from what we know.

We have fewer facts to keep synchronized and clearer relationships to examine.

We can reason about a response before the server exists.

We can examine a transition without clicking a button.

We can ask what the screen should show without making the screen remember a second version of our state.

The world is still unpredictable.

The requirements can still be difficult.

And the program can still be wrong.

But we have made its decisions easier to find.

That's a substantial improvement.

We started this series by asking [what a program is](https://docklands-ssg.vercel.app/notes/what-is-a-program-really/).

We found values.

Then we asked [what happens when the program interacts with the world](https://docklands-ssg.vercel.app/notes/and-then-somebody-opened-a-file/).

We found ways to describe those interactions as values too.

Now we have a problem to solve.

And our most useful question turns out to be remarkably ordinary.

Given what we know, and what just happened:

**What should happen next?**
