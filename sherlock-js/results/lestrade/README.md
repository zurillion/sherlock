# Evidence for the Lestrade continuation

- `../lestrade-verification.json`: authoritative scope, counts, hashes and limitations.
- `full-suite.log`: all 318 tests pass, no failures or cancellations.
- `differential-tests.log`: seven focused tests, including the natural 159-command
  reference through 13:00 and a save/load branch during the house interviews.
- `user-history.txt`: the submitted input journal, including map moves.
- `user-replay-before.log`: reproduction of the old 11:42 failure.
- `native-natural.log`: original-engine output for the natural reference in
  `test/fixtures/lestrade-natural-reference.json`; all actors active.
- `natural-prefix.txt`: the 62-command prefix before the native walking test
  controller chooses ordinary movement/inventory inputs. It never teleports.
- `native-user.log`: original-engine reference for the submitted journal and
  40 subsequent I commands. The native teleport helper prints an extra scene;
  original parity is certified only through event 120, as declared in the report.
- `native-prefix.json` / `.log`: short independent native prefix including
  PAY CABBIE's actual `DON'T BE SILLY.` response.
- `examine-source.json` / `.log`: offline renderer observations for ordinary
  EXAMINE STREAM, NOTE and LAMP after controlled map relocation.
- `renderer146-natural.json` / `.log`: detailed original renderer trace at
  natural command 146, reproduced with all actors and no world overlays.
  A wrapped THERE in the container phrase publishes the final low glyph fields.
- `sherlock-seed1-1142-restored.json`: portable browser save rebuilt with
  `node tools/rebuild-lestrade-session.mjs`, using JS only. Load via Carica partita.
- `rebuilt-save.log`: successful reconstruction and identical next three I
  commands after load.
- `browser-qa.json`: independent browser session loading that save and advancing
  to 11:45 with the visible movement announcements.

The Python tools are offline research probes. The page never imports them,
these reference fixtures or a native memory checkpoint.
