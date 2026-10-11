---
title: "State and Effects, Part 4: Messages, Updates, and Effects in Lustre"
description: "Rebuild the API explorer with Gleam and Lustre, then compare custom and packaged HTTP boundaries without moving application policy with them."
published: 2026-10-09
tags: Gleam, Lustre, State, Effects, Cheeky Tester
featured_image: /assets/images/note-state-and-effects-part-4.webp
featured_alt: Teal message beads travel through a central chamber and across a gap toward a separate amber mechanism
---

# State and Effects, Part 4: Messages, Updates, and Effects in Lustre

{{ featured-image }}

The first three parts kept Cheeky Tester inside Svelte. They moved from several reactive fields, to one tagged request value, to [a TypeScript union that checks the value's shapes](/notes/state-and-effects-part-3-checking-the-request-model-with-typescript/). The async `load` operation still decided what should change while it performed the request.

This version keeps the same API explorer and display policy, but rebuilds it in Gleam and Lustre. Selecting an endpoint produces a message. A pure `update` function decides the next model and describes an effect. The Lustre runtime performs that effect and returns another message.

That structure makes the path through the application explicit. It also introduces more names, more wiring, and a transport boundary that has to live somewhere.

## Give the application a vocabulary

The request lifecycle becomes a Gleam custom type, while the model also records the selected URL and the identity of the current request:

```gleam
pub type RequestState {
  Idle
  Loading
  Success(Response)
  Failure(String)
}

pub type RequestId =
  Int

pub type Model {
  Model(url: EndpointUrl, request: RequestState, request_id: RequestId)
}
```

`EndpointUrl` and `RequestId` are aliases for `String` and `Int`. They make function signatures easier to read, but they neither validate their values nor create distinct runtime representations. These are naming choices rather than new guarantees.

Two messages describe the events this model handles:

```gleam
pub type Message {
  UserSelectedEndpoint(url: EndpointUrl)
  HttpCompletedRequest(request_id: RequestId, result: Result(Response, String))
}
```

The names identify where each event came from and what happened. When the user selects an endpoint, the view produces a `UserSelectedEndpoint` message. When a request completes, the request effect produces an `HttpCompletedRequest` message. Neither message changes state on its own; `update` interprets it.

Those descriptive message names, labeled arguments, and domain-oriented parameter names make some expressions longer. They also reduce how much a reader must infer from a short name or a positional value. That balance comes from the conventions and architecture chosen here, not from a rule that every Gleam program must maximize names or labels.

## Put state decisions in one function

The central transition is ordinary data in, ordinary data out:

```gleam
pub fn update(
  controller controller: RequestController,
  model model: Model,
  message message: Message,
) -> #(Model, Effect(Message)) {
  case message {
    UserSelectedEndpoint(url) -> start_request(controller:, model:, url:)

    HttpCompletedRequest(id, result) -> {
      let next = case id == model.request_id, model.request {
        True, Loading -> {
          let request = case result {
            Ok(response) -> Success(response)
            Error(message) -> Failure(message)
          }
          Model(..model, request:)
        }
        _, _ -> model
      }

      #(next, effect.none())
    }
  }
}
```

A completion may change the model only when its request ID is current and the model is still loading. A late success can contain a perfectly valid `Response` and still be rejected. The custom types describe valid values; this branch describes a permitted transition.

Starting a request makes the complementary decision:

```gleam
pub fn start_request(
  controller controller: RequestController,
  model model: Model,
  url url: EndpointUrl,
) -> #(Model, Effect(Message)) {
  let next = Model(url:, request: Loading, request_id: model.request_id + 1)
  let effect =
    request.get(controller:, url:, completed: HttpCompletedRequest(
      request_id: next.request_id,
      result: _,
    ))

  #(next, effect)
}
```

Constructing the effect does not execute the network request. `update` returns a description of the effect alongside the new model; Lustre runs it afterward. This keeps the state decision pure even though the application still performs effects.

The view follows the same message path. Its select element uses `event.on_change(UserSelectedEndpoint)`, and its rendering functions pattern-match on every request variant. The view still declares how the current model should appear; coordination now runs through messages and `update` rather than through this component's reactive dependencies.

## Test the permission, not the network

Because constructing an effect does not perform it, transition tests can call the real `update` function with plain values. A stale failure is one input:

```gleam
let current = Model(url: "B", request: Loading, request_id: 2)

state_after(
  model: current,
  message: HttpCompletedRequest(
    request_id: 1,
    result: Error("Old failure"),
  ),
)
|> should.equal(current)
```

The test needs no mounted interface, clock, or promise scheduling. It proves that this application rejects an obsolete completion message. It does not prove that the browser request code dispatches the correct message, so the effect boundary needs its own tests.

## Effects still cross a boundary

The first Lustre implementation uses a small JavaScript adapter for `fetch`, `AbortController`, `performance.now()`, JSON parsing, and pretty-printing. Gleam exposes it through typed functions that construct a Lustre effect:

```gleam
pub fn get(
  controller controller: RequestController,
  url url: EndpointUrl,
  completed completed: fn(Result(Response, String)) -> message,
) -> Effect(message) {
  use dispatch <- effect.from

  start(
    controller:,
    url:,
    succeeded: fn(response) { dispatch(completed(Ok(response))) },
    failed: fn(message) { dispatch(completed(Error(message))) },
  )
}
```

The adapter owns mutable cancellation machinery. It aborts superseded work and suppresses callbacks from aborted requests. The pure update independently rejects stale messages by request ID.

Those are two layers of policy. The transport may stop unnecessary work; the application decides whether a result still has permission to change its model. Cancellation alone does not establish ownership, and messages alone do not cancel work.

This boundary also marks where Gleam's checks stop. The compiler checks how application code handles `Response` and `Result`, but it trusts the foreign function to construct and dispatch them correctly. Boundary tests cover cancellation, late callbacks, HTTP failures, invalid JSON, response metadata, and cleanup.

## Move the transport boundary into packages

Hand-written application JavaScript is not required to perform this request. One experiment uses [RSVP](https://hexdocs.pm/rsvp/2.0.0/rsvp.html) for HTTP, `gleam_json` for JSON syntax validation, and Plinth for clock reads. RSVP supplies typed transport errors, but its public interface does not expose a cancellation handle. In that version, superseded requests may finish while request IDs prevent their results from changing the interface.

The RSVP version reads a wall clock through a managed effect. Its `ClockRecordedRequestStart` message returns the start time to `update`, which checks that the request is still current before beginning HTTP. It displays the original response body after checking that it is valid JSON, along with the HTTP response code, such as `200`. It does not include the accompanying status text, such as `OK`. The custom adapter instead pretty-prints the JSON, retains both the response code and status text, and measures response duration with the monotonic `performance.now()` clock.

That is one package interface, not a general limit of package-based effects. A second experiment composes `gleam_fetch` with Gossamer's documented [`fetch_extra`](https://gossamer.hexdocs.pm/gossamer/fetch_extra.html) and [`abort_signal`](https://gossamer.hexdocs.pm/gossamer/abort_signal.html) modules. The transport exposes cancellation as a named payload and distinguishes the callback that provides it from the callback that reports completion:

```gleam
pub type RequestCancellation {
  RequestCancellation(cancel: fn() -> Nil)
}

pub fn get(
  scope scope: AbortSignal,
  url url: EndpointUrl,
  on_cancel_available on_cancel_available: fn(RequestCancellation) -> message,
  on_completed on_completed: fn(Result(Response, String)) -> message,
) -> Effect(message)
```

Each managed request effect creates a signal and abort function, combines the signal with the application's scope, and passes it into transport. It provides the cancellation handle before starting the request. The relevant steps appear in this source order:

```gleam
let #(signal, abort) = abort_signal.new()
let signal = abort_signal.any([scope, signal])

let cancellation =
  RequestCancellation(cancel: fn() { abort(abort_signal.Default) })
cancellation |> on_cancel_available |> dispatch
let started_at = performance.now()

case http_request.to(url) {
  Error(_) -> dispatch(on_completed(Error("The endpoint URL is invalid")))
  Ok(request) -> {
    let options = fetch_extra.options() |> fetch_extra.set_signal(signal)
    let _pending =
      request
      |> fetch_extra.send(with: options)
      |> promise.map(result.map_error(_, TransportError))
      |> promise.try_await(read_ok_body)
      |> promise.map(result.map_error(_, error_message))
      |> promise.rescue(fn(_) { Error("Could not connect to the server") })
      |> promise.map(fn(result) {
        case result {
          Ok(response) ->
            case json.parse(response.body, decode.dynamic) {
              Ok(_) ->
                Ok(Response(
                  output: response.body,
                  elapsed: duration.to_seconds(duration.subtract(
                    performance.now(),
                    started_at,
                  ))
                    *. 1000.0,
                  status: response.status,
                  status_text: "",
                ))
              Error(_) -> Error("The response was not valid JSON")
            }
          Error(message) -> Error(message)
        }
      })
      |> promise.tap(fn(result) {
        case abort_signal.is_aborted(signal) {
          True -> Nil
          False -> dispatch(on_completed(result))
        }
      })
    Nil
  }
}
```

The transport provides the cancellation handle through `TransportProvidedCancellation`. The model stores that handle only while it belongs to the current pending request:

```gleam
pub type Model {
  Model(
    url: EndpointUrl,
    request: RequestState,
    request_id: RequestId,
    cancellation: Option(RequestCancellation),
  )
}

TransportProvidedCancellation(id, cancellation) -> {
  case id == model.request_id, model.request {
    True, Loading -> #(
      Model(..model, cancellation: Some(cancellation)),
      effect.none(),
    )
    _, _ -> #(
      model,
      request.cancel(cancellation: Some(cancellation)),
    )
  }
}
```

Selection returns a batch of effects that invokes the previous handle and begins new work. A cancellation handle that arrives after its request is obsolete is immediately invoked. Current completion clears the stored handle. The existing request-ID guard remains: cancellation suppresses work and callbacks, while the model independently decides which completion may commit state.

An application-wide signal is combined with every request signal. The cleanup returned by `mount` aborts that scope and shuts down Lustre, so an embedding host must call it before removing the app. Gossamer's `performance.now` supplies monotonic timing around transport, body reading, and JSON validation.

This version has no application-owned JavaScript foreign function, although the browser packages contain JavaScript internals. It retains the original JSON text and HTTP response code, but does not include status text such as `OK`. Parsing checks that the body is valid JSON; it does not check that the data has the shape the application expects.

Package composition therefore preserves cancellation, but does not remove application design. `RequestCancellation` contains a function, so a model holding it is not entirely serializable, and the cancellation-handle lifecycle adds explicit wiring.

## What changed, and what did not

The Lustre version puts valid request shapes in custom types and state decisions in `update`. Effects are values returned to a runtime, and request identity is application data.

The network, clock, JSON parsing, DOM, and some mutable runtime machinery still exist. Pure updates organize those effects; they do not erase them. The package variants show that libraries can take responsibility for general effect mechanics—including cancellation when their interfaces expose it—while the application retains relevance and lifecycle policy.

This implementation is more explicit than the Svelte versions. It is also larger and asks the reader to learn models, messages, effects, and runtime dispatch. Whether that exchange helps depends on the application and its readers. The experiment establishes where the decisions live, not that every interface should put them there.

Continue to [Part 5: What Organizes Change?](/notes/state-and-effects-part-5-what-organizes-change/).
