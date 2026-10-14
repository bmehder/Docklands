---
title: "State and Effects, Part 2: Modeling a Request in Svelte"
description: "Revise the Svelte API explorer to give its request lifecycle one value, one named operation, and a clearer path between events and state."
published: 2026-10-07
series_label: "State and Effects · Part 2 of 5"
tags: JavaScript, Svelte, State, Effects, Cheeky Tester
featured_image: /assets/images/note-state-and-effects-part-2.webp
featured_alt: Teal geometric pieces grouped in a central tray with four separate tiles around it
---

# State and Effects, Part 2: Modeling a Request in Svelte

{{ featured-image }}

Cheeky Tester is a small Svelte API explorer. Choose an endpoint and it requests JSON, then shows loading, failure, response status, and response duration. [Part 1: Where Does Change Live?](/notes/state-and-effects-part-1-svelte-api-explorer/) examined how the original component coordinates that lifecycle across several reactive fields and asynchronous callbacks.

This revision keeps Svelte, JavaScript, the component boundary, and the same interface. It changes how the program describes and initiates a request. Four related view-state fields become one request value, and a URL-watching effect becomes a named `load` operation.

The result is not an escape from mutation or reactivity. It is a smaller claim: reactive machinery does not have to dictate how we organize change.

[Run the original implementation](https://svelte.dev/playground/c592c1110b2a469eb915157f31117019?version=5.57.2) and compare it with the [revised Svelte implementation](https://svelte.dev/playground/1adc48dc49c64f37bd86e3f419f59086?version=5.57.2).

## Replace one request value

The original component stores output, loading, error, and response duration separately. The revision groups those related fields into one reactive variable, `request`. The selected endpoint remains a separate reactive variable, `value`, while `activeController` holds the controller used to cancel the current request:

```js
let value = $state(base + routes.health)
let request = $state({ tag: 'idle' })
let activeController
```

During execution, `request` takes one of four intended shapes:

- `{ tag: 'idle' }`
- `{ tag: 'loading' }`
- `{ tag: 'success', data, elapsed, status, statusText }`
- `{ tag: 'failure', message }`

Starting, succeeding, and failing now replace that value completely:

```js
request = { tag: 'loading' }
```

```js
request = {
  tag: 'success',
  data,
  elapsed: performance.now() - startedAt,
  status: response.status,
  statusText: response.statusText
}
```

```js
request = {
  tag: 'failure',
  message: cause instanceof Error ? cause.message : 'Request failed'
}
```

**A reader no longer has to combine several fields to discover what a successful request contains.** The success value keeps the data, status, and elapsed time together. The template follows the same vocabulary:

```svelte
{#if request.tag === 'failure'}
  <div>{request.message}</div>
{:else if request.tag === 'success'}
  <pre>{JSON.stringify(request.data, null, 2)}</pre>
{/if}
```

Whole-value replacement also records a user-interface decision. Replacing success with `{ tag: 'loading' }` clears the previous response while the next request runs. Another interface might deliberately retain old data during loading. Its model would need to represent both facts. The representation follows the intended behavior; it does not choose that behavior for us.

Assigning to `request` still mutates reactive state. What changes is how the next state is described: the original version updates several fields separately, while this version replaces the entire request value in one assignment. A reader can see the complete loading, success, or failure state at that assignment, without tracing changes to the other fields.

## Name the operation that causes change

The original version watches the selected URL through `$effect`. Assigning a URL changes a reactive dependency, which reruns the effect and starts a request.

The revision makes the operation direct. Selecting an endpoint calls `load`:

```svelte
<select
  id="route"
  value={value}
  onchange={(event) => load(event.currentTarget.value)}
>
```

The event-to-operation path is visible in one place: selection, then `load`. Changing `value` from some other piece of code would not silently start a request; that code would also need to call the operation.

This is a coordination choice, not a rejection of Svelte reactivity. The component still uses reactive state, and Svelte still rerenders the template when `request` changes. A URL-watching effect remains available when automatic synchronization is the clearer policy. Both direct operations and dependency-driven effects can coexist with whole-value replacement or pure transformations.

The initial client request needs no selection event, so the component starts it in [`onMount`](https://svelte.dev/docs/svelte/lifecycle-hooks#onMount). The synchronous callback can return cleanup for unmounting:

```js
onMount(() => {
  load(value)
  return () => activeController?.abort()
})
```

## The complete request operation

With those choices in context, the revised script is compact:

```svelte
<script>
  import { onMount } from 'svelte'
  import routes from './routes.js'

  const base = 'https://cheekycms.fly.dev/'

  let value = $state(base + routes.health)
  let request = $state({ tag: 'idle' })
  let activeController

  async function load(url) {
    activeController?.abort()
    const controller = new AbortController()
    activeController = controller
    const startedAt = performance.now()

    value = url
    request = { tag: 'loading' }

    try {
      const response = await fetch(url, { signal: controller.signal })

      if (!response.ok) {
        throw new Error(`Request failed: ${response.status}`)
      }

      const data = await response.json()

      if (controller.signal.aborted) return

      request = {
        tag: 'success',
        data,
        elapsed: performance.now() - startedAt,
        status: response.status,
        statusText: response.statusText
      }
    } catch (cause) {
      if (controller.signal.aborted) return

      request = {
        tag: 'failure',
        message: cause instanceof Error ? cause.message : 'Request failed'
      }
    }
  }

  onMount(() => {
    load(value)
    return () => activeController?.abort()
  })
</script>
```

`load` gives the lifecycle a name and one place to read it. It also reveals what remains combined: starting a fetch, reading a clock, deciding whether a result is current, and assigning the next request value all happen in one imperative async function.

There is no pure transition function here. The revision makes state meaning and ownership easier to locate without yet separating decisions from effects.

## Permission to commit a result

Each invocation of `load` owns its own controller. Starting B aborts A and makes B current:

```js
activeController?.abort()
const controller = new AbortController()
activeController = controller
```

Aborting asks the underlying operation to stop. The later guards answer a separate question: may this invocation still change shared state?

```js
const data = await response.json()

if (controller.signal.aborted) return

request = {
  tag: 'success',
  data,
  elapsed: performance.now() - startedAt,
  status: response.status,
  statusText: response.statusText
}
```

The failure path checks the same permission before assigning failure.

Suppose request A starts, then the user selects B. B aborts A, installs its own controller, and sets the shared value to loading. If A rejects late, A sees that its controller was aborted and returns. It cannot replace B's loading state with an obsolete failure. If A reaches its success guard late, it returns there for the same reason. B alone retains permission to commit its result.

This is not a general cancellation architecture. It is the ownership policy this small operation needs, expressed next to the assignments it protects.

## Success carries one meaning

A successful request commits its parsed data, elapsed time, HTTP status, and status text together. Response duration is measured after `response.json()` completes, so it covers the fetch, body reading, and JSON parsing rather than server work alone. A non-OK response and invalid JSON take the failure path.

Parsing JSON only establishes that the body is valid JSON. It does not establish the application's expected data shape. That boundary becomes relevant in the next experiment, when the same runtime design moves to TypeScript.

## What this experiment establishes

The revised component demonstrates several choices that were available inside Svelte all along:

- Related view state can be represented by one tagged value.
- An event can call a named operation directly instead of relying on a reactive dependency as its trigger.
- Reactive rendering can continue after either choice.
- Per-invocation ownership can prevent obsolete callbacks from committing state.

It also shows where those choices stop. JavaScript does not prevent `{ tag: 'success' }` without data, an unknown tag, or any other object from being assigned. The tags name intended states by convention. They do not restrict which transition sequences may occur.

The async `load` operation still mixes effects, decisions, and assignments. A pure transition core would move state decisions into a function of ordinary inputs and outputs, but it would add another architectural boundary. This revision does not assume the component needs one merely to complete the pattern.

The controlled tests for this version resolve request promises in different orders. They verify that a stale success or failure cannot overwrite the current request. Because `load` owns both effects and decisions, those tests need mocked fetches, clocks, and promise scheduling. Pure transitions could be tested with plain values; their connection to real network effects would still need integration testing.

The emerging point is not that one coordination style wins. Svelte supplies reactive state and rendering, while the developer still chooses the shape of state, the path that initiates work, and the policy that permits asynchronous results to commit.

Part 3 keeps this organization and asks a narrower question: which of its conventions can TypeScript turn into checked guarantees, and which remain matters of control flow and developer discipline?

Continue to [Part 3: Checking the Request Model with TypeScript](/notes/state-and-effects-part-3-checking-the-request-model-with-typescript/).
