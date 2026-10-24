# Shared NPC implementation: current work

The requested full behaviour of Watson, the cabbie and Lestrade is **not complete**. These modules implement necessary shared components. They are not enabled as a substitute NPC engine in the page. The page now connects generated-input HELLO/TELL and the historical Watson branches described in [WATSON-RUNTIME.md](WATSON-RUNTIME.md); the generic kernel described here remains component work. There is no statistical or scripted substitute for the original random source.

Subsequent work on the TELL table, generated text-choice context and the playable ordinary PAY action is documented in [CONVERSATIONS.md](CONVERSATIONS.md). The current test count is in results/verification.json. The subsequent runtime work enables conversations in a declared profile, but does not complete any of the three NPCs.

## Code added

- `src/npc-program.mjs`: the game's domain instruction language, with conditional control flow, argument aliases, failure yields, one-shot erasure, signals, typed requests and nested deferred continuations. This interprets NPC instructions, not Z80 instructions. Native program labels are data identifiers; native CPU bodies are never dispatched.
- `src/npc-primitives.mjs`: the understood counter, location, containment, ownership, hour and account predicates. These are bodies/predicates, not a completed generic rule-header executor. Random counter creation requires an explicit original input source; it has no fallback.
- `src/record-arena.mjs`: original best-fit record storage and linked lists. This preserves record identity, allocation bytes, stale bytes and metadata used by continuations and randomness. It is a 752-byte domain record arena, not a machine-memory image or CPU emulator.
- `src/cab-economy.mjs`: the 45 bidirectional routes, two speed modes, signed money fields and payment effects. This does not by itself implement the cocchiere's dialogue or service sequence.
- `data/game.json`: semantic graphs for all 23 non-player actors: 791 instructions and 66 rule contracts. Decoding a rule contract is not implementing its native body or predicate.

## Native details that must be preserved

The direct comparisons uncovered details a simpler state machine would lose:

1. Saved argument slots are filled only when still FF, after the rule checks pass and a non-deferred body runs. Subsequent operations can reuse the earlier values.
2. When the last deferred context of an actor returns, CFCF calls D008 with the list predecessor pointer. Without an outer context for the same actor, the resulting saved values come from adjacent queue metadata or another actor's context. Ordinary restoration of the actor's former variables is not equivalent. `RecordLists.returnSaved` models the observed layout. Requests and syntax-node addresses therefore affect future behaviour.
3. The allocator chooses the last of equal-size best fits, allocates from the high end, drops a remainder smaller than four bytes, and leaves stale bytes. Its second coalescing attempt uses the block start after an unsuccessful first merge (A1FD/A203), so ordinary eager coalescing changes the state. The implementation preserves this quirk. Positive record sizes 1–252 are supported; zero and larger allocation requests are not claimed.
4. PAY compares funds as unsigned 16-bit arithmetic, even for a negative account. It debits the sender when the recipient has no money record; it does not create an account. The helper preserves these effects instead of silently correcting them.
5. A furious journey can have zero cost. Prices use the original table duration, including the extra fare block at exact multiples of five.

## What is verified

236 tests pass in the isolated JS bundle. New comparisons cover nine controlled native program fixtures (96 returned steps), all 180 directed route/speed combinations, 11 signed money values, 21 payment cases, every byte and pointer after 140 allocator operations, and five context-return arrangements. Saving inside a deferred scope and restoring record storage are exercised as component operations.

The native fixtures have explicit data setup and do not run the entire world. These results are **not** evidence that the page now reproduces a full NPC, complete save/load or the original seed sequence. `results/npc-foundations.json` records that distinction.

## Reproduce the exports and tests

From `sherlock-js`, with Python available for the offline reference tools:

```sh
python3 tools/export-npc-programs.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output "/Users/giovanni/Documents/Development/Sherlock rebuild/sherlock-analisi/ai/results/domain-programs.json"
node tools/build-data.mjs --project "/Users/giovanni/Documents/Development/Sherlock rebuild"
python3 tools/probe-npc-foundations.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output test/fixtures/npc-foundations.json
python3 tools/probe-record-arena.py --project "/Users/giovanni/Documents/Development/Sherlock rebuild" --output test/fixtures/record-arena.json
node --test test/*.test.mjs
```

The packaged runtime has no Python dependency. The probes execute the original only offline. Their fixture inputs are test data and are never replayed as gameplay.

## Remaining implementation required for the requested result

1. Generate the complete original random inputs from reconstructed state: immutable source data and relevant display, buffers, parser allocations, stack-related values and mutable fields. The record arena is one part of this projection.
2. Implement shared rule argument selection, header checks, remaining predicates/bodies, action execution and output packets. None of the 66 exported contracts is declared complete just because its graph is present.
3. Connect Watson's complete requests, statements, fact memory, encounter callbacks and autonomous sequence. Replace the historical fixed counter profile with generated initialization.
4. Connect cab service, destinations, interruptions, debt, payment requests, refunds, departure and repeated encounters, including the exact shared draws and continuations.
5. Connect Lestrade's itinerary, requests, callbacks, train travel, signals and story interactions. Straker and the other actors that drive these transitions must run as well.
6. Compare all-actor sequences against the original, draw by draw and with exact output/state checks, then verify save/load branches and connect the verified driver to the page.

These are unfinished engineering dependencies. Full behavioural equivalence is not claimed, and the requested playable outcome has not yet been delivered.
