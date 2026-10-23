# Functional equivalence is the target

23 October 2026. This supersedes the provisional greeting policy in SALUTI-E-CAB.md.

The autonomous engine is an incomplete reconstruction. It is **not functionally indistinguishable from the original**, and same-seed sequence equivalence is **not implemented**. Passing isolated tests does not establish either property. A plausible response, a similar frequency distribution or an original phrase selected by a substitute policy does not meet the requirement.

## What was wrong

The previous patch always selected the time-of-day alternative in Watson’s greeting. That was an approximation. It has been removed. Quoted HELLO requests now produce an explicit prototype notice outside the game text, before they enqueue a request, consume time or modify the world. HELLO without a quotation retains the independently verified original HI. response in the command area.

Old logical saves with an already pending greeting remain loadable. If that request runs, Watson is suspended at the unsupported random text operation with an explicit notice; no substitute answer is generated. Old saves were created by a partial model and cannot be promoted to original-equivalent states just by adding a seed label.

## What the original actually does

Text fragment 6920 uses a random choice in 6918 between Hello and the time-filtered fragment 6902 (Good morning/afternoon/evening). The selector A6D3 calls D2A4 with width `count - 1`. It counts *backwards* through the alternatives. The zero-based option index is:

```
count - 1 - absolute_draw(count - 1)
```

For two options, an absolute draw of one selects Hello; zero selects the time-of-day greeting. A conventional uniform array choice is not a replacement. The selection formula has now been translated in `OriginalRandom.chooseIndex` and compared with 1,280 controlled executions of the original selector: option counts 1, 2, 3, 4 and 8, with every raw byte value. These tests certify this operation with supplied inputs, **not the complete random source**. The selector is not connected to fabricated inputs in gameplay.

D2AD maintains an eight-bit accumulator and a 16-bit cursor. For each attempt it advances the cursor high byte first and mixes:

```
((accumulator + byte[cursor] + carry) & 255)
    XOR byte[(cursor + contextOffset + 1) & 65535]
```

If the raw result equals the previous accumulator it retries at another cursor. The raw accumulator is saved before the range reduction. `contextOffset` is the value in DE at the native call. The generator uses ROM bytes, display and attribute bytes, buffers, stack, world data and mutable program state. Some of the original code bytes are themselves data inputs to randomness; reconstructing their role does not require executing that code, but silently replacing them changes behaviour.

There is one shared stream. Other NPCs advance it even when their activity produces no visible message. The current JS game does not run those programs and does not generate all the source inputs. The fixed historical Watson counter 15 is also not a seeded initialization.

## Repeated-greeting evidence

`tools/probe-greetings-reference.py` observes the original offline from true startup with graphics enabled and injected input, without keyboard idle timeouts. `results/greeting-audit.json` records 14 scenarios, 401 commands, 1,271 random draws and 2,776 source reads. Six seeds (0, 1, 7, 42, 127, 255) have 32 repeated greetings each, both with all actors active and with only Watson active after startup. Two further scenarios repeat a prefix and interleave WAIT. These are oracle observations, not a recorded script replayed by gameplay.

For seed 1, the first eight answers in this protocol are:

| Actors active after startup | Answers (H = Hello, G = Good morning) |
|---|---|
| All original actors | H H H H G H G H |
| Only Watson | H G H G G G H G |

The second reply already differs. During the first command with all actors active, Watson consumes two draws, actor 5 another, and the first cocchiere three more. In the isolated Watson run those other draws are absent. Keeping only Watson’s own random accumulator would therefore give the wrong sequence.

For seed 1 in the full run, the greeting itself reaches display memory by question 16. At that draw it retries through several zero pairs before reaching a nonzero byte at 4900. Display output, including scrolling, is consequently part of the random-input dependency. A fixed ROM-only entropy table would also fail later.

The observed proportions depend on the seed, complete state and command history. No universal Hello/Good morning percentage is inferred from these samples.

## Acceptance criteria for all future ports

1. Define the original baseline: payload/ROM identity, initial state, graphics profile, seed injection point and input/event protocol. A seed alone is not the full state.
2. Reconstruct initialization and every participating actor’s effects and random draws in the original order, including invisible activity.
3. Generate each original random input from understood static data and a compatibility projection of logical state, including the relevant display, buffer, allocation and stack effects. This projection must use domain operations, without a CPU interpreter or runtime call to the old engine. Its completeness has not yet been established.
4. Compare each draw’s order, arguments, input bytes, result and successor state before comparing phrases and world transitions. For final IO equivalence compare the actual output and control packets, without hiding differences through case or whitespace normalization; the existing normalized prose tests have a narrower scope. Stop at the first divergence. Do not tune probabilities or replay captured sequences to conceal it.
5. Serialize the complete reconstructed random state and its dependencies. A save/load branch must produce the same subsequent draws, replies and state as an uninterrupted branch, including across browser reload and in a new session.
6. Extend the differential corpus beyond repeated greetings: follow/wait, movement and pictures, parser errors/continuations, other NPCs, transport, conversations and endings. Test several seeds and long enough runs to exercise cursor wrap and mutable memory reads.

These criteria apply to the whole rewrite. Existing partial rules retain their documented scope; the present test suite is not a certificate for the entire game. The intentional free initial LOOK and map teleport remain analysis extensions; comparisons with the original must use matching profiles and inputs.

## Current outcome and next dependency

The invented greeting has been removed; the backward text selector is reconstructed and tested. **Seeded greetings and full functional equivalence remain unfinished.** The next foundation is a functionally generated startup and the shared state/random-input projection, followed by the actor programs that advance it. More isolated cosmetic responses will not close this gap. The older Z80 reference remains available for checking the actual original behaviour.
