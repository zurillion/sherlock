# Sherlock autonomous rewrite: fidelity contract

The user's target is a standalone JavaScript reconstruction that is functionally indistinguishable from the original game. Similar-looking responses or approximate probabilities are not acceptable substitutes. This applies to every gameplay component, not just Watson.

- Keep the playable engine autonomous: no CPU interpreter, legacy-game backend, or recorded trace replay. The original executable is an offline research oracle; extracted content remains data.
- Preserve understood behaviour, including quirks, exact output/control packets, time costs, turn order, state changes and random choices. Do not hide differences by normalizing the acceptance comparison; old normalized tests have explicitly narrower scope.
- Never invent a fixed alternative, random distribution, duration, callback or NPC action where the original behaviour is unknown. Expose that path as unimplemented outside the game's own text. Where possible, reject before queuing or mutating state.
- Treat randomness as shared original state. The original algorithm reads context-dependent state bytes, including display memory. Seed equality alone and arithmetic tested with recorded inputs do not establish gameplay equivalence. Reconstruct initialization, all contributing draws and their input dependencies before claiming identical sequences.
- Save/load must preserve future behaviour, including the current random state and all its inputs and pending continuations. Saving only the initial seed is insufficient.
- Differential evidence must declare startup profile, active actors, input/event protocol and compared fields. A run with other NPCs disabled is not proof for the full game. Compare each random draw and report the first divergence.
- Existing intentional analysis extensions (free initial LOOK, map teleport, presentation preferences) remain documented separately from original-profile comparisons.
- Read FIDELITY.md and results/fidelity-audit.json before further random/NPC work. The fixed greeting was removed. Original seeded greetings and whole-game equivalence are still unimplemented. Priority is the shared state/random-input foundation, not additional approximated responses.
