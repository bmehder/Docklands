---
title: "State and Effects, Part 1: An API Explorer in Svelte"
description: "Read a small Svelte 5 API explorer closely: what triggers its requests, what its state communicates, and where asynchronous work deserves extra care."
published: 2026-10-09
tags: JavaScript, Svelte, State, Effects, Cheeky Tester
---

<!-- Artwork TODO: this four-part series needs a distinct featured image for each installment before the series is complete. -->

# State and Effects, Part 1: An API Explorer in Svelte

This is the first of four readings of the same small API explorer. We will begin with the original Svelte 5 JavaScript implementation, then revisit the design in idiomatic Svelte JavaScript, TypeScript, and finally Gleam with Lustre.

The point is not to arrange the languages and frameworks on a podium. It is to watch where state lives, what starts an effect, and which guarantees come from our own design rather than the tool.

You can open the [original Svelte playground](https://svelte.dev/playground/c592c1110b2a469eb915157f31117019?version=5.57.2) and an [untouched fork for the next installment](https://svelte.dev/playground/1adc48dc49c64f37bd86e3f419f59086?version=5.57.2).

## The explorer in two files

`routes.js` is data: an object mapping 31 human-readable labels to relative CheekyCMS paths. The choices cover health, collections, singletons, filters, sorting, and limits.

`App.svelte` owns the presentation and all behavior. Its dropdown is bound to `value`; each option value is already a complete URL made from `https://cheekycms.fly.dev/` and one relative route. Selecting an option therefore changes the URL that the component is watching.

Here is the original script exactly as it appeared in the first playground:

```svelte
<script>
  import routes from "./routes.js"
  const base = 'https://cheekycms.fly.dev/'
  let value = $state(base + routes.health)
  let output = $state(null)
  let loading = $state(false)
  let error = $state(null)
  let responseTime = $state(null)
  $effect(() => {
    const controller = new AbortController()
    const startedAt = performance.now()
    loading = true
    error = null
    responseTime = null
    fetch(value, { signal: controller.signal })
      .then(response => {
        responseTime = performance.now() - startedAt
        if (!response.ok) {
          throw new Error(`Request failed: ${response.status}`)
        }
        return response.json()
      })
      .then(data => {
        output = data
        responseTime = performance.now() - startedAt
      })
      .catch(cause => {
        if (cause.name !== 'AbortError') {
          error = cause.message
        }
      })
      .finally(() => loading = false)
    return () => controller.abort()
  })
</script>
```

## What makes the request run?

The effect runs after the component mounts. During that run it synchronously reads `value` in `fetch(value, ...)`, so Svelte records `value` as a reactive dependency. Choosing another endpoint changes `value`, which schedules another run.

The assignments to `loading`, `error`, and `responseTime` do not make those fields dependencies. Svelte tracks reactive values that an effect *reads synchronously*; merely writing a field does not create a feedback loop. Values read later in promise callbacks are asynchronous reads and are not tracked as effect dependencies either.

Before the effect runs again, its cleanup calls `controller.abort()`. The same cleanup runs when the component is destroyed. This gives the explorer automatic cancellation when someone switches endpoints or leaves the component. It is not a user-facing Cancel button, and there is no Retry button in this version.

Svelte's current [`$effect` documentation](https://svelte.dev/docs/svelte/$effect) explicitly lists network requests as a use for effects. It also says that, generally, updating state inside effects can make code more complicated and can create never-ending cycles. Both points matter here. Fetching in an effect is supported, and the code avoids a reactive loop because its dependency is the URL it reads—not the state it writes. The broader caution still invites us to examine how much request state one effect coordinates.

## Abort is not the whole stale-work story

Aborting the previous request is valuable: it tells the browser that request A is no longer wanted. It does not, by itself, make every callback belonging to A unable to change shared state.

From code inspection, there is a possible lifecycle race:

1. Request A starts and sets `loading = true`.
2. The selection changes, so cleanup aborts A.
3. Request B starts and sets `loading = true`.
4. A's promise chain reaches its unconditional `finally` and sets `loading = false` while B is still pending.

This is a risk to investigate, not a claim that every quick selection reproduces it. Promise and abort timing matter. The important distinction is conceptual: **cancelling obsolete work** and **ignoring callbacks from obsolete work** are related responsibilities, but they are not identical.

## What does the screen mean while loading?

Starting a request clears the error and timing, but it does not clear `output`. The previous response can remain visible beneath the newly selected URL while the next request loads.

That may be a deliberate display policy. Keeping useful data on screen can feel steadier than replacing it with an empty panel. The tradeoff is attribution: the URL describes request B while the JSON may still belong to request A. A loading label, a retained-response label, or clearing the output would each communicate a different policy.

The template also displays `200 OK` whenever it is neither loading nor showing an error. Because the component does not retain the actual response status, that label describes an assumption rather than recorded response data. It can even appear in the initial render before the first request has completed.

## What exactly does the timer measure?

The first response callback records elapsed time when the response headers arrive. On a successful response, the following callback overwrites that number after the body has been read and parsed as JSON.

The final displayed value therefore means approximately “time until parsed JSON was available” for a successful request. For a non-OK response it means “time until response headers were available.” Neither definition is inherently unsuitable, but a metric is easier to reason about when its endpoint is consistent and named.

## Several fields, several possible combinations

The request is represented by independent fields:

- `output`
- `loading`
- `error`
- `responseTime`

That permits combinations such as loading with earlier output, or an error alongside output from a previous success. Those combinations are not automatically invalid. Some express the retention policy described above. The design question is whether every combination has an intentional meaning that the interface communicates clearly.

This connects to [Make Impossible States Impossible with PHP Enums](/notes/make-impossible-states-impossible/), but with an important difference. The stoplight example has a small closed set of mutually exclusive states. A request interface may intentionally combine current activity with retained data. Before changing the representation, we have to decide what the product is supposed to say.

## Questions for Part 2

The untouched fork gives us somewhere to explore, but not a predetermined answer:

- Should request state be one coherent value, several coordinated fields, or a mixture?
- Should changing the selected endpoint trigger immediately, or should the user explicitly submit?
- How should callbacks prove that they still belong to the current request?
- Should earlier output remain visible during loading and after an error, and how should it be labelled?
- Which response status and timing measurements should the interface retain?

Part 2 will make those policies explicit in idiomatic Svelte JavaScript. The findings from that implementation—not a preference for mutation, immutability, Svelte, or any later tool—will guide what comes next.
