---
title: "State and Effects, Part 5: What Organizes Change?"
description: "Draw together the Svelte, TypeScript, Gleam, and Lustre experiments by asking which parts of an application describe state, transitions, effects, and ownership."
published: 2026-10-10
tags: JavaScript, TypeScript, Svelte, Gleam, Lustre, State, Effects, Cheeky Tester
featured_image: /assets/images/note-state-and-effects-part-5.webp
featured_alt: Six equal dark frames show different arrangements of glass pieces and connecting threads around an open center
---

# State and Effects, Part 5: What Organizes Change?

{{ featured-image }}

Cheeky Tester stayed small throughout this series: choose an endpoint, request JSON, and display loading, errors, or a successful response with its HTTP response code and response duration. What changed was how each implementation organized the decisions that move the interface from one state to the next.

The original Svelte component coordinated independent reactive fields through an effect and promise callbacks. The revised JavaScript version replaced those independent fields with one tagged request value inside a named operation. TypeScript checked that value's shapes. [Part 4's Gleam and Lustre implementation](/notes/state-and-effects-part-4-messages-updates-and-effects-in-lustre/) represented events as messages, moved state decisions into a pure update function, and performed HTTP through an effect boundary.

Those implementations are not rungs on a ladder. Each separates—or combines—different responsibilities. The useful conclusion is a set of questions we can ask in any application.

## Valid values and valid journeys are different

The JavaScript revision gave request state a recognizable shape:

```js
request = {
  tag: 'success',
  data,
  elapsed,
  status,
  statusText
}
```

TypeScript then checked that a success contains those fields:

```ts
type RequestState =
  | { tag: 'idle' }
  | { tag: 'loading' }
  | { tag: 'success', data: unknown, elapsed: number, status: number, statusText: string }
  | { tag: 'failure', message: string }
```

Gleam expressed the alternatives as custom variants:

```gleam
pub type RequestState {
  Idle
  Loading
  Success(Response)
  Failure(String)
}
```

These representations answer, with different levels of checking, “What may a request snapshot contain?” None alone answers “May this particular success follow the current state?” A well-formed stale response is still stale.

Transition rules live in control flow. In the revised Svelte version, a controller guard protects the assignment. In Lustre, `update` accepts a completion only when its ID matches and the model is loading. Types help describe values; application policy still determines their permitted journeys.

This distinction applies outside UI frameworks. Whenever a type names statuses, modes, or workflow stages, look separately for the code that says how one becomes another.

## Ownership and transformation are different boundaries

A Svelte component limits who can reach local state. State and the operations that change it sit together behind a component boundary. That object-like organization can make a small feature easy to locate: inspect the component and follow its assignments.

Lustre's `update` draws another kind of boundary. Instead of primarily limiting who may mutate a value, it describes how messages transform the model. In the RSVP variant, the actual selection and completion branches are:

```gleam
UserSelectedEndpoint(url) -> start_request(model:, url:)

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
```

These approaches can coexist. A Svelte component can call a pure transition function. A Lustre application still has modules and runtime ownership. These boundaries answer different questions: where does state belong, and where are the rules for changing it? A component can keep a feature’s state and behavior together, while a transition function gives its state-change rules a place of their own. When reading or changing a feature, can we find both its state and the rules that govern it?

## Mutation can be a mechanism without being the map

All browser versions ultimately interact with mutable systems: DOM state changes, requests begin and finish, and clocks advance. Versions that support application-directed cancellation also change controller or abort-signal state. The revised Svelte component assigns its reactive value directly:

```js
request = { tag: 'loading' }
```

That assignment is not opposed to functional design. A program can use mutation at its boundary while calculating the next value with a pure function. What matters is whether relationships among fields are expressed as coordinated mutations scattered through callbacks, as replacement of one coherent value, or as explicit transformations from model and message to a new model.

Lustre makes the pure transformation the normal application path. Svelte leaves the organization open and makes local reactive assignment convenient. Those defaults influence code, but developers still choose the model and boundaries.

## Starting an effect and accepting its result are separate decisions

Every implementation must initiate HTTP somewhere. The original Svelte version uses a reactive dependency. The revised version calls `load` from the selection event. Lustre returns an effect for its runtime to execute.

The more subtle decision comes later: does this result still belong to the current interface state?

```js
if (controller.signal.aborted) return
request = { tag: 'success', data, elapsed, status, statusText }
```

```gleam
case id == model.request_id, model.request {
  True, Loading -> Model(..model, request: Success(response))
  _, _ -> model
}
```

Both snippets express permission to commit. The JavaScript guard is located in the async operation; the Gleam guard is a transition rule tested with plain messages.

Cancellation is related but distinct. It can save work and prevent callbacks, yet an application may still need a relevance check. The RSVP experiment does not cancel superseded requests, but its request IDs prevent late results from replacing current state. A later package composition adds abort signals while retaining the same ID guard. Which combination is required is application policy.

## Libraries move boundaries; they do not remove decisions

The first Lustre implementation used a custom adapter to preserve browser cancellation, monotonic measurement of response duration, HTTP status text such as `OK`, and pretty-printed JSON. The RSVP version delegated general HTTP handling to a package. That removed application-owned JavaScript and supplied typed transport errors, while changing cancellation and response details.

A further version composes `gleam_fetch` with Gossamer's abort signals and fetch options. It has no application-owned JavaScript boundary and can abort individual requests or the application's whole request scope. The transport provides a named `RequestCancellation` handle to the application. The model stores it only for the current request, immediately invokes a late handle through an effect, and still uses request IDs to reject obsolete completions.

Packages can therefore expose more or less of the underlying platform. Neither arrangement is universally more correct, and the RSVP result does not establish what package-based code generally can do. A package can own transport mechanics and its JavaScript internals. It cannot decide whether request 12 is still relevant to the user's current selection. That decision depends on the application model.

The same applies to parsing. `response.json()` and `gleam_json` can establish valid JSON. Neither proves that arbitrary JSON has a domain-specific schema unless the application asks for and implements that validation.

## Explicitness and simplicity are not opposites

The smallest original component contains fewer concepts on the page. Its behavior emerges from familiar JavaScript assignments, reactive scheduling, and promise callbacks. For a reader fluent in that environment, this can be direct.

The Lustre version names more steps: messages, request IDs, model variants, update branches, effects, and callbacks that return messages. Descriptive message names and labeled arguments make individual expressions longer while reducing the inference required to understand their roles. That makes coordination inspectable and transition tests straightforward, but it also increases vocabulary and wiring. It is a tradeoff made by this design and its naming conventions, not a universal property of every Gleam program.

“More explicit” therefore does not automatically mean “simpler.” It can reduce the work required to reconstruct behavior while increasing the amount of structure a reader must understand. The useful measure is local: when a feature changes, where must a reader look, which mistakes are checked, and what ceremony does the structure impose?

## Who contributes which guarantees?

The experiment separates several sources of discipline:

- **Application design** chooses whether request state is four fields or one value, whether old output remains during loading, and how stale results are recognized.
- **JavaScript** permits the tagged-object convention but does not enforce its fields.
- **TypeScript** checks the declared union and narrows fields, but does not validate network data or enforce transition order by itself.
- **Gleam** checks custom variants, results, labeled records, and pattern handling inside typed code, while foreign boundaries remain trusted.
- **Svelte** supplies reactive state, dependency-driven effects, component boundaries, and declarative rendering; it does not require the particular state organization used here.
- **Lustre** supplies the model-message-update-effect path and runtime execution; it does not invent request relevance or cancellation policy.
- **Libraries such as RSVP, gleam_fetch, and Gossamer** can own transport, errors, timing, and cancellation mechanics; their interfaces determine which browser capabilities reach the application, while the application still chooses relevance and cleanup policy.

Frameworks and languages shape the available path. They do not replace product decisions.

## What to carry into an existing application

No migration is required to use the main lessons.

In JavaScript, when several fields jointly describe one lifecycle and their combinations are not independently meaningful, consider replacing one coherent value. If the interface deliberately retains earlier data during new work, model that combination instead of erasing it to fit a pattern. Give important operations names, and put stale-result guards next to the assignments they protect.

In TypeScript, use discriminated unions to check those shapes, keep external data `unknown` until it is validated, and remember that a union does not define temporal rules.

In Svelte, choose deliberately between dependency-driven coordination and direct operations. Reactive rendering works with either, and pure transition functions remain available when their testing or readability benefits justify another boundary.

In Gleam or Lustre, keep effect mechanics separate from the application's permission to accept results. Test pure transitions directly, then test transport and integration boundaries for the promises types cannot make.

Across all of them, ask four questions:

1. What states does the interface intend to represent?
2. Where are the rules that move it between those states?
3. What performs effects, and what decides whether their results still matter?
4. Which guarantees come from tools, and which still depend on application policy?

Cheeky Tester does not prove how any approach scales across a large team or a long-lived system. It does show that a tiny request can expose the architecture of change. Once those responsibilities are visible, we can choose where to place them with clearer expectations about both the help and the cost.
