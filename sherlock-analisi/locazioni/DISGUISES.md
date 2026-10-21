# Disguise identity regression

The reported sequence was reproduced in the closet (location 9):

```text
TAKE DISGUISE
WHICH DISGUISE ?
CHINA
You take the china mans disguise.
WEAR DISGUISE
WHICH DISGUISE ?
CHINA
The command exceeded the execution limit.
```

This was an explorer bug, not evidence that the original game loops. The execution limit remains unchanged.

## Cause in the original code

Wearing a disguise calls `$E03A`. It finds the active actor row through `$CC0E` and replaces its entity ID at offset +0. The first scheduler row remains `$9860`, but its ID changes:

| Appearance | Entity ID |
|---|---:|
| Holmes | 0 |
| China man | 1 |
| Old man | 100 |

The routine also transfers position and containment to the new entity, hides the previous entity at location zero, reparents inventory and updates suspended actor contexts. Taking the disguise off switches the active row back to ID 0. Scene narration changes accordingly.

The explorer was skipping every row whose ID was not zero to keep NPCs inactive. After WEAR, it therefore skipped the player's own row too. It kept advancing the world clock but never returned to the input routine. The failed run reached tick 1260 with player ID 1 and its next deadline only 3; after nine million instructions it hit the execution limit. The guard rolled the state back.

Two other assumptions would also have broken subsequent commands: location lookup and context preparation were fixed to entity 0, and the visibility sidebar treated entity 0 as the player.

## Fix

- Identify the player's scheduler row by its fixed address `$9860`, independently of its entity ID.
- Read the current identity from that row for context preparation and location lookup.
- Use the active identity for Python perception checks and exclusion of the player from the visible entity list.
- Update the movement trace utility to look up the current identity too.

This preserves the original disguise routines and the rule costs. It does not implement a replacement WEAR action or raise the execution limit.

## Verification

`verify_disguises.py` compares the reported continuation sequence and the old man's disguise against independent runs of the full game using `entita/trace_semantics.py`. It checks active identity, room and clock at each prompt. It also checks LOOK, INVENTORY, movement, taking disguises off, map teleport while disguised and transfer of carried money.

Python perception is compared with the native `$C821` predicate for all 110 entities after each command. Results and original-game traces are saved in `results/disguise-verification.json` and `results/disguise-traces.json`.

Run from the project folder:

```sh
python3 -B sherlock-analisi/locazioni/verify_disguises.py
```
