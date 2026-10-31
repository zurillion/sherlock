# Sherlock autonomous rewrite: fidelity contract

The user's target is a standalone JavaScript reconstruction that is functionally indistinguishable from the original game. Similar-looking responses or approximate probabilities are not acceptable substitutes. This applies to every gameplay component, not just Watson.

- Keep the playable engine autonomous: no CPU interpreter, legacy-game backend, or recorded trace replay. The original executable is an offline research oracle; extracted content remains data.
- Preserve understood behaviour, including quirks, exact output/control packets, time costs, turn order, state changes and random choices. Do not hide differences by normalizing the acceptance comparison; old normalized tests have explicitly narrower scope.
- Never invent a fixed alternative, random distribution, duration, callback or NPC action where the original behaviour is unknown. Expose that path as unimplemented outside the game's own text. Where possible, reject before queuing or mutating state.
- Treat randomness as shared original state. The original algorithm reads context-dependent state bytes, including display memory. Seed equality alone and arithmetic tested with recorded inputs do not establish gameplay equivalence. Reconstruct initialization, all contributing draws and their input dependencies before claiming identical sequences.
- Save/load must preserve future behaviour, including the current random state and all its inputs and pending continuations. Saving only the initial seed is insufficient.
- Differential evidence must declare startup profile, active actors, input/event protocol and compared fields. A run with other NPCs disabled is not proof for the full game. Compare each random draw and report the first divergence.
- Existing intentional analysis extensions (free initial LOOK, map teleport, presentation preferences) remain documented separately from original-profile comparisons.
- Read STATO-E-PROSSIMI-PASSI.md for the current backlog (older COPERTURA.md is historical). Also read OGGETTI-E-CONTENITORI.md and results/objects-verification.json: ordinary placement uses direct-child bulk and soft preflight masks; pair resolution requires exactly one surviving second argument. Preserve description-search return records, E0 token payloads and the player's ten-rule failure budget, including yields before rejected-node cleanup.
- Read IDENTITA-E-INDIZI.md and results/special-objects-verification.json for point 1's second pass. Disguises transfer the player actor 0/1/100, possessions and context ownership; precise identity references are not retargeted. Object domain programs must yield between stages: do not quench the note or reveal clues before their source stage. Preserve eight-bit recursive weight, original LOCK/UNLOCK refusals, coded text spacing and case changes on a buffered word. Failed NPC child returns keep working arguments separate from persistent actor-row bytes until the next successful operation or timed failure yield; a new deferred request may suspend them first. An already-open bookcase returns without CR; accepted input resets the pending word buffer. Source glyph AF/BC fields are owned only where their flags/caller count have been reconstructed. Native controlled setups are explicitly separate from natural-play certificates.
- Read COMANDI-ERRORI-E-SIGLE.md and results/error-recovery-verification.json for original syntax/lexical errors, optional TO in SAY, partial AST cleanup, deferred quotation records, exact lower-channel output and token byte order. Unsupported inputs cancel the entire input atomically as a documented prototype protection, preserving the last valid source state. Do not restore blanket parser invalidation or silently consume a stale quotation. Map badges are presentation metadata only.
- For clarification/record-lifetime work, read WATSON-E-CAB.md and results/follow-cab-verification.json. Simple clarification nodes now remain allocated across the question and reply; do not reintroduce blanket invalidation or drop the pointer from saves. The new corpus compares every arena byte, including released records, with all actors active.
- Also read CRONOLOGIA-E-SALUTO-CAB.md and results/cabbie-history-verification.json. Supported first-argument ALL retains its parsed node across each paid action and NPC turn, releasing it only after the final search. Quote queue nodes retain their token pointer. Do not revert these lifetimes or simply remove the unknown-context guard. The independent command journal is diagnostic metadata, excluded from world/random inputs.
- Read FIDELITY.md, WATSON-RUNTIME.md, results/fidelity-audit.json and results/runtime-watson-verification.json before further random/NPC work. Also read NPC-RUNTIME.md and results/world-npc-verification.json. New browser games use the world-v5 domain host with all actor slots; historical saves retain the Watson-only profile. The declared native prefixes are verified, not whole-game equivalence. Preserve explicit unsupported boundaries, parser-source validity and the documented teleport IO difference; continue reconstructing without approximated responses.
- Also read LESTRADE-ISPEZIONI.md and results/lestrade-verification.json. The natural seed-1 continuation compares 159 commands through 13:00 with all actors, every draw, all 752 record bytes and exact upper bitmap. Keep pre-movement visibility, both resolved TELL arguments, request argument isolation, source encounter-context propagation and noon's original time class. Renderer fields overwritten by unprojected AF/BC must lose ownership rather than retain stale values. The map-helper certificate stops before its first differing bitmap read; the restored 11:42 save is regenerated from the submitted history using JS only.

- Read BASIL-E-CONFINE-DEI-FATTI.md and results/fact-boundary-verification.json. The fact-table terminator at 99FB is immutable FF, separate from mutable fact terms ending at 99FA. Export player DOMAIN rule headers too; D7FA/D7FB are a header, not scratch. Missing random dependencies roll back the complete input and may repeat; do not promise another command can bypass them. The post-alibi tail deliberately controls the cursor after a natural prefix; do not call it a naturally reached random state. Preserve prefab TELL actor-name prefix glyph frames and anonymous shared-door notifications.

- Read CRONOLOGIA-BASIL-UTENTE.md and results/basil-user-verification.json. Exact submitted history compares 115 commands with 623 draws and 1,316 reads; it does not naturally read 99FB under the declared IO protocol. Earlier JS renderer differences led to that old path. Use the recovered 11:54 save only as replay of the first 98 commands, not migration of an old random state. D206 skips entity zero in bulk and recursive weight scans; ENTER uses DEE4 direct bulk. ALL exhaustion counts a DOMAIN failure. Preserve GO THROUGH arguments, class-9 absent-reference description search, loader residue overwritten at 5CEC/5CED, exit/passage pending words, SEE/AND calling contexts and final-column space clears from the carried-name caller. Do not project a later personal-contents phrase for an actor without listed possessions. Source evidence is offline only.

- Read WAIT-UNTIL.md and results/wait-until-verification.json. Single world-v5 WAIT UNTIL in the page is live: pause at A074 after clock update but before actor visits. ENTER changes the player deadline; text and arrivals do not. Do not precalculate the complete future or reparse every minute. Preserve PC 9945, arguments FE/FF, raw A02F literal including its tag, and the original unsigned 12-hour arithmetic. A final numeric suffix returns before CR, leaving the last period to the lexer. A later unsupported minute preserves the displayed past; saving is allowed after interruption, not from an incomplete input visit. Compound/historical commands keep the earlier frame path. UI Spectrum key handling prevents default browser events even when busy; do not suppress the global ENTER handler on defaultPrevented. MORE already consumes the key in capture phase.

- WAIT interruption keydown must run in capture phase before the Spectrum target input handler. A browser microtask checkpoint can start the job before that same event bubbles to document. Ignore repeated ENTER keydowns; preserve MORE capture precedence. Never gate on defaultPrevented.

- Read PORTE-E-NOTIFICHE.md before changing anonymous shared-door output. CAF0 alone does not prove a message: CB01/D471 requires an exit from the acting NPC room to Holmes' room. Entity 50 is reused in distant buildings. Keep both the silent Baker Street long-WAIT corpus and the existing audible adjacent dining-room-door test.

- Read INFORMAZIONI-E-DEDUZIONI.md and results/information-verification.json before changing statement/proof code. Statements keep NPC local cost zero and preserve its suspended arguments. Watson stops after the first accepted node, moves duplicate memories without reallocating, uses the existing node pointer as the response draw context, and recalls only when the second percentile value is exactly 1. Preserve BE22 first-six-byte pronoun copies. Proof trees are typed data; do not decode them as instructions. Lestrade returns through unprojected AF/BC frames: stale scratch ownership must be revoked, never filled with guessed values.

- Read NPC-AVANZATI.md and results/advanced-npcs-verification.json before changing late NPC branches. Preserve original sleep low-byte overflow, saved rooms and actor-only moves, dynamic descriptor/person flags, explicit identity references, police directed routes and current vehicle parent. Terminal outcomes stop before any later callback and clear the live WAIT job. Ordinary paid actions hold player PC 9945; failure-budget and local-object stages keep their own continuation. Police encounter early returns use 9D68. Boot RETURN/releaseScans is declared input-protocol state, not seed-only parity. D187 compound-vehicle scene fields are now derived by the scene and C374 wrap projection; see FINALI-E-CONFESSIONI.md before changing their ownership. Never publish guessed residues or invalidate unrelated still-owned bytes. Semantic NPC request rejection advances the syntax pointer before release (B9CA); statement cleanup follows its distinct path. Map identities survive sleeping/unconscious classification changes.

- Read LINGUAGGIO-COMPLESSO.md and results/language-verification.json before changing parser execution. Allocate an entire unit before actions; preserve speculative/released nodes and the AEEA orphaned exclusion. BUT scans after the current index and cannot exclude that same unique entity; do not replace this with a modern filter. Keep raw AST slots separate from ALL semantic roles. NPC ALL retains cursor, request flag and syntax node across visits and saves. A TALK consumes one quote pointer from the live token buffer; request mode is the final quote mode, not inferred per node. Respect the three explicitly separated corrupted-buffer boundaries: prototype rollback is not native parity. @ does not echo the previous line, and failed lexical input remains repeatable. Numeric scanning returns both value and cursor; preserve rotating decimal arithmetic, pound-separator quirks and editor capacity. Project lower errors before subsequent paid actions and do not reset scrolling again for a later syntax error in the same input. The TELL topic class includes unseen abstract references.

- Empty quotations still allocate a request node and preserve final quote mode. Implicit TALK reuses the previous addressee only when eligible; absent fallback clears the query and retains the clarification node for TALK TO WHAT. Do not discard either case as empty input.

- Read CONCLUSIONE-INDAGINE.md and results/endings-verification.json before changing final states. KILL is an always-failing class-zero predicate, before light/reference checks; ALL silently exhausts. Retain its rejected node through failure-budget yields. A terminal result stops local object programs and collective execution before cleanup; no prompt, callback or later actor may run. Terminal PCs 992D/9937 are valid saved end checkpoints. C1FD redraws the lower plus even when no prompt follows. C306 acknowledgement precedes the eighteen clear CRs and does not apply MORE counter changes. A statement request arrives before the next operation resolves its arguments: preserve the suspended context. E4C9 prints train departure before clearing visibility. Keep the explicitly bounded long-statement renderer case separate from full native histories; never fill 5D06 from a recording.

- Read COMANDI-E-CALENDARIO.md and results/command-limits-verification.json before changing player movement, controls or calendar. FOLLOW/COME WITH use the deferred player DOMAIN root and shared arena, with original success/failure return lifetimes. ENTER/GO INTO resolve adjacent room names and call movement DOMAIN; GO TO/GO FURIOUSLY TO/TAKE TO have no Holmes rule in this edition. LOOK THROUGH retains the parent and uses the container as viewer; gate size restricts passage, not viewing. PAY without TO swaps semantic roles only. PAUSE/PRINT/NOPRINT discard the rest of the line; SAVE continues it, costs one minute and retains old root action/args. SAVE during clarification allocates/releases its control record before ticking, then reuses pending syntax. Printer paper captures top eight scans before scroll, including NOPRINT clearing before disable. Preserve day-byte wrap and unsigned tick/deadline comparison quirks. Browser JSON tape and frozen QUIT are explicit adapters, not native tape/restart parity.

- Read FINALI-NATURALI.md and results/natural-loss-verification.json for the natural loss baselines. Staying home reaches 693A before arrest; 9D90 requires Holmes/Lestrade/Straker co-presence, not a HELLO alone. The 49-command real travel prefix followed by waits ends at Tue 01:03 in 6A26 under the declared seed-1 protocol. Missing local/global OPEN/CLOSE rules fail without a prototype exception. Nominal workspace clears after the completed group before its delimiter; dry-run WAIT analysis does not mutate it. Word workspace bytes survive flushing, including off-stage money formatter writes (uppercase raw D, slash/dash); raw name/formatter fields without established ownership remain null. ROM SEED is a boot-only initial condition, not a fallback for old saves. Shared rule phase, announcement and current-visit failure/request flags are live source inputs. Do not replace any missing byte with recorded native values.

- Read ALTRI-FINALI.md and results/other-endings-verification.json before further endings work. The two new natural histories both end in 759C, not separate terminal variants. Restricted Basil must refuse walking after a valid exit lookup (DCDD/CBA7); do not move him to manufacture 75D2. Revoke unprojected CBA7 renderer fields from 5D06. Nested proof atoms use BD51/BE5A lookup; BC46 walks atoms in reverse, BC9C skips groups with BE72, BC74 walks all active atoms with BE5A. The controlled 9972 observation tests are not a natural acquisition. OPEN-already-open retains resolved root arguments. SEE caller depth differs for literal personal names and dictionary names with article. Six terminal texts still lack natural certificates; no full-solution parity is claimed.

- Read FINALI-E-CONFESSIONI.md and results/final-solution-verification.json for the natural 69BF arrest, typed actor-local TELL programmes E17B/E1A3, Tricia-to-Jones identity transfer, and the controlled confession/proof tests. The native absent-clothes TELL hang is a declared rollback boundary, not invented game dialogue. Preserve audible successful NPC output in darkness, D1B2/68C1 brief-dark text, CBC2 indefinite cab arrival, and dictionary-vs-literal workspace writes outside the scene. C374 publishes its C377 return link before glyph fields. The police-cab D187 path retains its explicit low-field ownership boundary. F60B is profile state with no old-save fallback; A00D/A00E and CC0C are immutable data. Argument classes A00F/A010 come from action models and rule headers, with CDA7 changing the first class only. Four terminal texts have natural certificates; the witness/late-solution continuation remains research until its full differential test passes.

- Read PARSER-E-FASE-REGOLE.md and results/parser-rule-lifetimes-verification.json before continuing the witness ending. AB7C/AC17 overwrite the intermediate statement's verb BEFORE ACCC/AE6A allocate its successor; retain all three nodes. C591 reaches C5F4 BEFORE the predicate when arguments are explicit (including class-zero slots), so a failed predicate still leaves A00B=1. Literal classes 5/6 reject non-FE before phase one. Do not restore the old success-only executionPhase update.
- Read INGRESSI-TEMPORANEI-E-CONVERSAZIONI.md and results/transient-inputs-verification.json. That historical report certifies checkpoints 0–246; the current prefix and boundary are in CONTATORI-PARSER-E-DEDUZIONI.md. Five terminal variants still lack natural certificates; do not claim the recorded Thu 10:00 ending is certified.
- C388 fields through 5D19 are projected from glyph/caller inputs and verified by 45 native ABI cases and natural last-writer traces. EXAMINE must revoke the newly owned 5D12–5D19 even when older low fields survive. C8EF pointers select rooms for classes <5 (including zero) and entities otherwise; FE/FF retain earlier slots. Unprojected semantic searches must revoke pointers. BD7E/BDC2 iterators begin at 8B6C; unique searches exhaust at 8CB9, ambiguity stops on second match and can leave the other slot untouched. Preserve partial BA19–BA1B writes and old-save unknowns.
- DC13/DC14 length/prefix belong to actual lexical input, including failed words; numeric/punctuation scanning and parser dry runs do not reset them. Off-stage TELL still sends literal characters to the word workspace while dictionary/name emissions and the display sink are suppressed. ROM 127C–1285 copies fourteen stream bytes from 15C6 to 5C10 only at cold start; never fill unknown bytes of an old save. A011 is explicit false for the declared source graphics-off protocol, independent of web image preferences; old saves without the field remain unknown. Preserve all these fields through SAVE/LOAD.

- The user requested a memory-atlas digression. Preserve the gameplay backlog in RIPRESA-GAMEPLAY.md and resume from the first CURRENT differential boundary recorded in RIPRESA-GAMEPLAY.md. Memory-map coverage measures source-backed byte classification, not gameplay equivalence. The atlas is an analysis-only page; do not import its payload/listings into the playable engine.

- Whenever new source behaviour or data structures are understood, update the memory atlas in the same change: save the commented source dossier, regenerate with tools/build-memory-map.py, run the atlas tests, and keep source-backed byte coverage distinct from gameplay equivalence. The user explicitly requested this ongoing synchronization on 28 October 2026.

- Read CONTATORI-PARSER-E-DEDUZIONI.md and results/parser-counter-verification.json. Current natural witness prefix: 0–322 through Wed 01:30; that report’s boundary was 5C1F at checkpoint 323; see the current lexical-workspace report. A012 follows parser entry, speculative restore, BUT and THAT/HE/IT allocation differences, not AST length. Preserve accepted OPEN ALL BUT. A019 is the renderer counter; D714 resets on accepted editor input even after @. BA1C/D reset at statement verification, BA1E/F retain the last recognized fact before evaluation; scans select first complete or last incomplete without clearing counts. Old missing fields stay unknown until written. Reconstruct ROM stream-tail initialization AND lexical body copies before owning 5C1F; never publish a captured zero.

- Read LEXER-E-BUFFER-CONDIVISO.md and results/lexical-workspace-verification.json. Current natural prefix remains 0–322 through Wed 01:30; the same next checkpoint now passes 5C1F and stops on 5D1F. Bootstrap only 5C1E–5C35 from the cold-start RAM clear and unextended ROM streams; never repair old saves with zeros. DA34 consumes the initial, DA6D copies the lowercased body to 5C0B and DA75 appends zero without moving A9B5 or clearing the tail. Apply actual lexical copies even on failed input and @, never on parser dry runs. Input/candidate overlap starts at 5C42: high copied cells are revoked rather than published as final candidate bytes. Next reconstruct stack writers past 5D19: 5D1F can come from C39D or A969/A97C, and the natural observer starting at tick 2400 does not establish its earlier last writer. Suite: 719 tests. Atlas synchronized.

- Read NOMI-ORDINI-E-STACK.md and results/upper-stack-verification.json. Current witness certificate: 0–333 through Wed 03:20, all actors and LOAD futures. Next boundary 5D1A at checkpoint334 toward Wed03:30 (actual unsupported minute03:28). 5D1F is derived from the proper compound actor-name prefix of NPC orders: CE13/682A ->6804 ->67F7 ->A751/A7C5/D3E8; C388 frame5D2A leaves glyph row7 at frame-11. The native call chain at tick964 is an order to the cabbie, not merely Lestrade entering. Do not substitute the prefab TELL frame5D1A or a constant zero. Scene frame metadata still owns low fields only: a natural test caught an incorrect generic upper projection at Mon14:17. The high-byte caller scope must be explicit and restored in finally. Non-proper names, unprojected output, lexical errors and EXAMINE revoke the high byte; old missing saves remain unknown. Only 5D1F was added, not the intervening 5D1A–5D1E. ABI covers63 calls; natural upper ownership checks76 commands; suite722. Transition traces omit same-value stores, so do not call them absolute last-writer proofs. Atlas synchronized with221 instructions/393 payload bytes,92 newly classified unique bytes.

- Read FLAG-GLIFI-E-ANNUNCI.md and results/glyph-flags-verification.json. Current witness certificate: checkpoints0–337 through Wed04:00; next boundary A01A at checkpoint 338 toward04:10. 5D1A is now F of the final bottom-row glyph scan at frame 5D26, reached by a word wrap in the qualified first entity argument of ordinary CLIMB INTO/TAKE OFF announcements (prefix frame 5D2C). Only the explicitly annotated caller owns this flag; arbitrary scene frames do not. GO TO/GO FURIOUSLY TO orders preserve that separate flag under their verified shallow contract; the proper actor-name prefix supplies 5D20/5D21 from C/B at frame5D2A. Unprojected output and errors revoke extras; old absent saves remain unknown. The native store probe includes identical-value PUSH/CALL and EX(SP),HL stores, with no unclassified transitions. ABI covers432 cases; unit ownership checks74 commands through Tue07:00 and the native store probe covers76 through Wed03:40; suite725. Atlas adds251 instructions/446 annotated bytes and193 newly classified unique bytes. Next reconstruct A01A from its actual parser lifetime (AAB3/B03F/B026/AFE8), not zero for WAIT or the final AST node.

- Read ALL-BUT-E-CICLO-PARSER.md and results/parser-all-verification.json. Current witness prefix remains0–337 through Wed04:00: A01A is resolved, next boundary A020 (high byte of the global temporary cost word A01F) at checkpoint 338 toward04:10. A01A resets only on real unit entry AAB3, becomes1 after validated ALL and2 before BUT allocation; lexical errors retain it, parser errors retain reached writes, and AD3D restores only A012. Save/load preserves it without legacy boot fallback; dry analyses are pure. ALL validation uses shared unit state, not the last AST node. Nominal slot E bits survive BUT; ACA6 writes into the remaining slot and rejects a third group. Inherited verbs are committed at AE19 only after successful parsing: failed payloads keep zero rather than eager semantic inheritance. Count ALL exhaustion at9937 before a following ordinary node in the same unit. SAVE with only terminal punctuation has no extra parser reset. 34 state/write sequences and8 complete-state sequences support the new rules; suite768. Atlas source166 instructions/368 bytes; A01A becomes documented, other zones are refinements. User explicitly requests listing the new/refined map address ranges in chat whenever updated.


Aggiornamento 29 ottobre 2026: leggere COSTO-TEMPORANEO-E-ATTESE.md e
results/temporary-cost-verification.json. Il costo globale A01F/A020 è
proiettato da reset CC74, intestazioni CA09 prima del corpo, cab 9B07,
controlli B0BD/B0CC, yield CD85/CD8E, byte basso DDC5 e WAIT UNTIL DE42.
Le intestazioni di azioni/oggetti sono dati immutabili estratti; vecchi
salvataggi senza proprietà temporanea non ricevono fallback. Sei sequenze
naturali,32 input/97 checkpoint,302 draw/614 read confrontano anche il costo
a ogni estrazione, tutti gli attori, arena, bitmap e futuro dopo LOAD.
GET OUT dal cab in corsa deve fallire con maschere 80/28, mantenendo gli
argomenti già risolti e il punto finale del messaggio. Suite 775.
Prefisso witness invariato 0–337 fino a Wed04:00; A020 è superato e il
prossimo limite è A11A allo stesso checkpoint 338 verso 04:10. Nessun nuovo
finale certificato. Atlante:153 istruzioni/351 byte, 58 byte prima sconosciuti
ora documentati e 2 byte prima parziali; gli altri sono approfondimenti.


Aggiornamento 29 ottobre 2026, allocatore: leggere ALLOCATORE-E-LINK-PRECEDENTE.md
e results/allocation-link-verification.json. Prefisso witness 0–345 (346 checkpoint)
fino a Wed05:20, tutti gli attori, ogni draw/read, arena, bitmap e futuro dopo LOAD.
Nuovo confine 5D1B al checkpoint 346 verso 05:30: ricostruire il chiamante/ultimo
scrittore dello stack, incluse scritture dello stesso valore; non copiarlo da
una registrazione né dedurlo da 5D1A. Cinque finali ancora senza certificato naturale.
RecordArena.allocationLink conserva A11A/A11B: l’INDIRIZZO DEL LINK PRECEDENTE
al candidato scelto, 9FE3 per la testa o blocco precedente+2. Ogni candidato
migliore o uguale lo aggiorna; release e ricerche senza candidati lo conservano.
La scelta a parità è l’ultima, non la prima. Persiste in JSON; nei vecchi
salvataggi assenti rimane null fino a un’allocazione reale. Non ricavarlo
dalla lista finale e non usare un default 9FE3/zero. Dati controllati: 14 layout,
159 operazioni, 200 scritture con tutti i byte; naturali: 6 sequenze,97 checkpoint,
302 draw/614 read con confronto della word a ogni ingresso casuale. Suite 797.
Atlante: 176 istruzioni/307 byte prima grigi, inclusi 2 byte dati; nuove zone
A11A–A11B,A11C–A15F,A160–A1AE,A1AF–A1C6,A1C7–A20B,A20C–A24C.


Aggiornamento 29 ottobre 2026, byte dei glifi: leggere GLIFI-E-BYTE-DI-SCANSIONE.md
e results/glyph-byte-verification.json. Prefisso witness 0–348 (349 checkpoint)
fino a Wed05:50, tutti gli attori, ogni draw/read, arena, bitmap e futuro dopo LOAD.
Nuovo confine A01B al checkpoint 349 verso 06:00: ricostruirne il ciclo nel parser,
senza zero per WAIT o deduzione dal solo pending del modello. Cinque finali aperti.
5D1B è A dell’ultima scansione C388 solo nel chiamante verificato. Il probe
con store anche invariati identifica C3B8/tick 962/Lestrade/frame 5D26/spazio;
il giardiniere legge quel residuo a tick 2728 (Wed05:27). Il valore è glyph[7],
non il flag F a 5D1A: q può lasciare 6. Con frame 5D24, 5D1B è invece B=1.
La proprietà della coppia AF è preservata solo dal GO TO già verificato;
output non proiettato, scene generiche ed errori la revocano. Old LOAD non inventa byte.
Non estendere il contratto ai byte 5D1C–5D1E o a tutti i chiamanti del glifo.
ABI 432 casi, 216 espliciti sul nuovo byte; storia naturale 76 comandi fino a
Wed05:30 e lettura del giardiniere verificata per valore/tick/attore. Suite 800.
Atlante: 119 istruzioni/179 byte approfonditi; nessun nuovo byte grigio. Zone
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 e annotazione dello stack dinamico.


Aggiornamento 29 ottobre 2026, chiarimenti: leggere CHIARIMENTI-E-OFFSET-DEL-PARSER.md
e results/clarification-offset-verification.json. Witness invariato 0–348/349 checkpoint
fino a Wed05:50: A01B superato, prossimo limite A021 allo stesso checkpoint 349 verso 06:00.
Ricostruire la classificazione temporanea degli argomenti e la sua persistenza;
nessuno zero di default da successo, WAIT o costo. Cinque finali ancora aperti.
A01B è un offset fisico 08/12, non pending booleano/puntatore: boot A044=0,
B5B6 prima della domanda, D793 dopo il ritorno principale anche su errore.
Lexical errors e @ con domanda non lo azzerano; una risposta vuota o SAVE
può azzerare e porre di nuovo la domanda. Citazioni non aggiungono quel reset.
La vista semantica può riordinare i complementi, ma pending e risposta conservano
il nodo e lo slot fisico sorgente. Con PUT ON YOUR ARMCHAIR il referente richiesto
è nello slot 12. Il preflight C79A della classe 9 include oggetti tenuti da un altro
NPC, pur rifiutati in esecuzione: TAKE iniziale ha lampada 22 e giornale 25;
con un solo candidato si sceglie, non si chiede sempre WHAT. Mantenere peso,
percezione e altri controlli rigidi, e distinguere DCA2/DCA7 (possesso/ciclo)
dalla restrizione morbida. Rifiuti GET/CARRY/TAKE usano il verbo corretto.
GIVE richiede seconda scelta unica e ricerca descrittiva sul fallimento;
PAY ambiguo è DON'T BE SILLY, non una domanda. I finali prevalgono sulla domanda.
54 sequenze/156 input/182 store; 19 confronti completi (15 naturali, 4 controllati),
63 input/203 draw/406 read, arena/bitmap/LOAD. Suite 874. Atlante 197 istruzioni/454 byte:
51 byte prima grigi B5FC–B62E e A01B prima parziale; gli altri sono approfondimenti.


Aggiornamento 29 ottobre 2026, controlli argomenti: leggere
CONTROLLI-ARGOMENTI-E-RESIDUO.md e results/argument-check-verification.json.
Witness 0–355, 356 checkpoint sino a Wed07:00; 6.760 draw/14.470 read,
tutti gli attori, arena/bitmap/futuro LOAD. A021 superato; nuovo limite
5D1C al checkpoint 356 verso Wed07:10. Ricostruire chiamante/frame/ultimo
scrittore dello stack, comprese scritture invariate; non estendere il
contratto precedente di 5D1A/5D1B né copiare il valore dalla registrazione.
Cinque finali restano senza certificato naturale. A021 non è un esito globale:
C655=0, C6BA=1; C726 può conservare il vecchio valore sul rifiuto del secondo
ruolo. Nessun reset per successo, tick o costo. Avvio carica il dato0,
verificato sino al prompt con quattro seed; old save assente rimane unknown.
Le ricerche visitano anche candidati rifiutati. Due maschere ordinate,
restrizioni morbide in preflight e handler di fallimento rimangono distinti.
WAIT UNTIL 6D scrive0 e risponde DON'T BE SILLY.; OPEN senza regola applicabile
mantiene la ricerca descrittiva e l’arena. 692 ABI controllati e 10 sequenze
naturali/53 input/63 checkpoint/218 store/203 draw/406 read; ogni store,
A021 a ogni draw e stato completo verificati. Suite 889. Atlante:
414 istruzioni/909 byte, 32 byte prima grigi C571–C590 e A021 prima parziale;
approfonditi C4D1–C582,C583–C627,C628–C6BD,C6BE–C74D,C74E–C7A5,
C7A6–C820,C9BF–C9FA. Riferire sempre qui gli intervalli nuovi/approfonditi.


Aggiornamento 29 ottobre 2026, shift salvato: leggere GLIFI-E-SHIFT-SALVATO.md
 e results/glyph-shift-verification.json. 5D1C superato: C nel frame glifo5D26, shift=(2+7*colonna)&7.
Ultimo writer C3B7/tick962/Lestrade/spazio della pulizia dopo prefisso hansom;
lettura cuoca attore9/tick2826/Wed07:05:7. Non installare7: calcolarlo dal
cursore nel chiamante verificato. Con frame5D24 la stessa cella è un
indirizzo, con5D28 è F. GO TO verificato preserva; stampe sconosciute/scene
ed errori revocano; old LOAD senza cella rimane unknown. Nessuna proprietà
nuova su5D1D/5D1E/5D22. Prossimo limite5D22 è il SECONDO operando della
stessa estrazione; individuare ultimo writer/frame, non indovinare39 da HL.
Prefisso completo invariato0–355/356 checkpoint sino a Wed07:00, stessi
6.760 draw/14.470 read, attori/arena/bitmap/futuro LOAD. Il probe naturale
76 comandi arriva07:20 ma il modello confronta il primo operando e resta
fermato dal secondo: non spacciare07:20 per certificazione completa.
ABI432 casi,324 espliciti sul nuovo byte e108 frame che non lo raggiungono;
8 shift, proprietà/SAVE/LOAD e lettura naturale verificati. Suite892.
Atlante119 istruzioni/179 byte approfonditi, nessun nuovo byte grigio:
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 più annotazione workspace5D1C.
Cinque finali ancora aperti. Riportare sempre gli intervalli aggiornati in chat.


Aggiornamento 29 ottobre 2026, indirizzo video salvato: leggere
GLIFI-E-INDIRIZZO-VIDEO-SALVATO.md e results/glyph-address-verification.json.
5D22 è L salvato da C38B/C398 soltanto nel chiamante con frame5D2A del
prefisso letterale del nome dell’attore in682A. Calcolare
(5020+floor((2+7*colonna)/8))&FF; non installare39, né dedurlo da5D1C.
Il percorso è CE13 ->682A ->6804 ->67F7 ->nome attore/D3E8. Le altre
profondità conservano F/C/E del chiamante o F/C della scansione; tutti
sei i ruoli sono verificati in648 casi ABI, tre glifi e36 colonne.
Proprietà esplicita del chiamante; output sconosciuto, scene ed errori
revocano; old LOAD senza byte rimane unknown.5D23–5D27 sono osservati
nel probe per distinguere i writer, ma non ricevono nuovi valori runtime.
Il prefisso è ora0–358/359 checkpoint sino a Wed07:30, con6.834 draw e
14.644 read confrontati, tutti gli attori, arena/bitmap/futuro LOAD.
Nuovo limite A01C al checkpoint359 verso Wed07:40: ricostruire gli store
D800/B1EC/B1FD e relativi chiamanti; non inferire dal solo ALL o pending.
La prova precedente di5D1C ora esige assenza di not_translated fino al
proprio checkpoint finale07:20: il blocco su5D22 non è più accettato.
Suite complessiva895 test. Cinque finali rimangono aperti.
Atlante221 istruzioni/393 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C388–C3E3,
CE10–CE17,D3E8–D447 e annotazione workspace5D22. Riferire gli intervalli in chat.


Aggiornamento 29 ottobre 2026, modo semantico: leggere
MODALITA-ALL-E-CONTINUAZIONE-SEMANTICA.md e results/resolution-mode-verification.json.
A01C è0/128, distinto da A01A0/1/2 e A01B08/12. I quattro writer sono
D800 (D6B8 del giocatore), B959 (record richiesta+2), B1EC (bit ALL soltanto
se modo0 e modello trovato), B1FD (flag selezione singola CLIMB INTO/HAIL).
A041 azzera D6B8 all’avvio; A01C usa soltanto il dato iniziale caricato,
verificato con quattro seed. Old save senza campo resta unknown: nessun
fallback da ALL, pending, successo o costo. D81B conserva il modo prima dei
turni NPC; D85C azzera D6B8 ma non A01C. Fine ALL può lasciare128/0.
Le richieste prefabbricate e le affermazioni non attraversano B959.
Fine ALL NPC: B9B4/B9CA liberano quel nodo e B9C7 continua sul suffisso;
non cancellare gli altri comandi della richiesta. Reset del cursore privato
prima del nuovo nodo. CLIMB INTO ALL/HAIL ALL non iterano più azioni.
60 sequenze naturali/180 input/375 store/679 draw/1358 read, tutti i24 attori,
arena752 byte, bitmap/cursore, fatti e futuro LOAD. Errori del bridge possono
avere chunk diversi: il confronto del canale inferiore è nei byte originali,
non una normalizzazione dei messaggi. Test dedicato OPEN ALL AND CLOSE ALL
rivolto a Watson e seguito da I ripetuti. Suite complessiva956 test.
Prefisso invariato0–358/359 checkpoint sino a Wed07:30, 6.834 draw/14.644 read.
A01C superato; secondo ingresso sconosciuto A022 al checkpoint359 verso07:40.
Ricostruire ultimo writer e persistenza; non installare il97 della traccia.
Cinque finali ancora aperti. Atlante213 istruzioni/518 byte: A01C passa da
parziale a documentato, nessun nuovo byte grigio. Approfonditi D6B8,A040–A047,
82B1–82B8,8349–8350,B1DD–B258,B280–B2B6,B39C–B3AF,B936–B98B,
B9AC–B9F9,D7FC–D87C. Riferire sempre gli intervalli aggiornati in chat.


Aggiornamento29 ottobre2026 — consegna/restituzione NPC: leggere
CONSEGNA-E-RESTITUZIONE-NPC.md e results/npc-handover-verification.json.
GIVE senza TO usa l’ordine destinatario/oggetto del modello8321–8328,
B421/B445. La conversione semantica è idempotente e conserva i gruppi fisici
per continuazioni/arena; ALL può avere un gruppo vuoto. Nessun ramo speciale
Watson. YOUR resta qualificatore del nome; D275 verifica il possesso reale.
La classe D non esclude il soggetto: GIVE MONEY TO ME può riuscire; con
nessun destinatario esplicito conta anche Holmes e la coppia può non essere
unica. Non inventare un default Watson. Un fallimento semantico della
richiesta salta B973/B976 e non scrive l’iteratore nel record liberato.
A7D0–A7E9 mantiene YOU minuscolo dentro la frase, non è nome proprio.
25 sequenze naturali/99 input, Watson e cocchiere, tutti24 attori,376 draw/
754 read, arena752 byte, bitmap esatti e futuro dopo LOAD. Vale il protocollo
IO dichiarato, non una certificazione generale di ogni NPC o finale.
Atlante252 istruzioni/538 byte: A7D0–A7E9 documenta26 byte prima grigi;
approfonditi8321–8328,B280–B2B6,B405–B482,B936–B98B,B9AC–B9F9,
C7E4–C7F8,C814–C820,C8C6–C8EE,D275–D29C,DF02–DF2D.
Confine lungo invariato A022 al checkpoint359 verso Wed07:40; prefisso
naturale0–358 sino a Wed07:30. Cinque finali ancora aperti. Riferire in chat
le nuove zone dell’atlante, senza confondere copertura statica e gameplay.

Verifica conclusiva consegne NPC: suite completa982 test,982 passati,0 errori.


Aggiornamento30 ottobre2026 — leggere ULTIMO-RIFERIMENTO-LESSICALE.md e
results/dictionary-reference-verification.json. A022/A023 conserva il
riferimento lessicale completo (offset12 bit più contesto), scritto daA88C e
A8B5 soltanto con5C3C nonzero. Anche offset0 scrive il primo descrittore;
letterali e dizionario fuori scena conservano. I nomi usano40/50; i comandi
senza parola di terminazione non chiamanoA887. Non ricavare il campo dal
testo inglese finale o dal seed. Text.render lo proietta dalle operazioni;
output sintetici/errori privi di contratto revocano. Old LOAD assente resta
unknown fino a un writer, nessun valore iniziale/catturato di ripiego.
Ultimo writer naturale tick964 attore0, nome destinazione STREET0861 con
modo50:5861. Lettura giardiniere attore8/tick2852/Wed07:31:61hex.
Prefisso ora365 checkpoint0–364 sino a Wed08:30,6992 draw/14966 read,
tutti24 attori, arena752 byte, bitmap e futuro LOAD. Prossimo confine5D1D
al checkpoint365 verso Wed08:40; cinque finali naturali ancora aperti.
64 casi ABI;6 storie brevi complete più prefisso cab7 input:31 input,
158 draw/316 read. Il suffisso cab fallisce su5D0C (47 JS/0 nativo),
riprodotto sul baseline8e3b605: conservarlo come limite separato, senza
normalizzare o ignorare quel campo. Vedi unrelated-boundary.json.
Suite1054 test tutti passati. Atlante265 istruzioni/523 byte: A022–A023
parziale->documentato;78 byte prima grigi in A3E2–A413,A65C–A65D,A815–A82E.
Approfonditi A37D–A418,A5CD–A5F1,A63F–A65D,A880–A92E,D3E8–D447.
Riportare le nuove zone in chat; la copertura statica non è gameplay completo.


30 ottobre2026 — registro B salvato: leggere GLIFI-E-CONTEGGIO-SALVATO.md e
results/glyph-count-verification.json.5D1D è il B interno soltanto nel frame
C388=5D26: C399 imposta8, C39C/C3B7 salvano BC prima di DJNZ; l’ultimo
salvataggio è1. Gli altri frame hanno altri ruoli:5D1E:A chiamante,
5D20:B chiamante,5D22:D descrittore,5D24:H video,5D28:A font.
Non assegnare1 globalmente, né ricavarlo da C a5D1C. Proprietà condizionata
all’ABI del chiamante, GO TO verificato preserva AF/BC; output sconosciuti
revocano. B chiamante assente rimane sconosciuto. Old save senza5D1D non
riceve fallback e5D1E non è introdotto.
Ultimo writer naturale C3B7/tick962/Lestrade/spazio della pulizia del prefisso
hansom cab: frame5D26,BC0107. Lettura cuoca9/tick2918/Wed08:37:1.
1.728 casi ABI:8 frame,2 B chiamante,3 caratteri,36 colonne. Probe naturale
76 comandi sino08:50, nessuna transizione non classificata; il modello
confronta i valori posseduti prima del limite e la prima lettura, NON08:50.
5D1D è superato; manca5D23 nella stessa estrazione, checkpoint365 verso08:40.
Prefisso completo invariato0–364/365 sino Wed08:30,6992 draw/14966 read,
24 attori, arena/bitmap e futuro LOAD. Non dichiarare un nuovo checkpoint o
un finale per avere risolto soltanto il primo operando. Cinque finali aperti.
Atlante119 istruzioni/179 byte approfonditi, nessun nuovo byte grigio:
A3D6–A3E1,A9DF–AA0F,C363–C37C,C388–C3E3 e annotazione workspace5D1D.
Conservare il limite separato del cab5D0C, riportare le zone in chat.

Verifica conclusiva 5D1D: suite completa 1.104 test passati, 0 errori; 55 controlli mirati passati.


30 ottobre2026 — byte alto video: leggere GLIFI-E-BYTE-ALTO-VIDEO.md e
results/glyph-address-high-verification.json.5D23 è H salvato da C38B/C398
solo nel frame5D2A del prefisso proprio del nome attore in682A (CE13 ->6804
->67F7 ->A7C5/D3E8). Calcolare (5020+floor((2+7*colonna)/8))>>>8;
non installare80. Ultimo writer C398/tick964/Lestrade/r di Inspector,
colonna8,HL5027. Lettura cuoca9/tick2918/Wed08:37:80, dopo5D1D=1.
6 ruoli del glifo: frame5D24:A chiamante,5D26:B chiamante,5D28:D descrittore,
5D2A:H video,5D2C:B scansione,5D2E:A font. La vera CALL C374, con frame5D22,
scrive invece C377 e lascia C3 a5D23.1.728 ABI glifo più288 pulizie reali,
8 frame e36 colonne. Vecchi LOAD senza5D23 restano sconosciuti anche con
5D22 noto; chiamanti senza contratto revocano.5D24–5D27 e5D1E non introdotti.
Il vecchio test naturale5D1D ora ESIGE l’assenza di not_translated fino08:50;
non accetta più il vecchio limite5D23. Nuovo probe originale sino10:00,
modello confronta valori posseduti e lettura ma si ferma suA01D: non
spacciare10:00 per certificazione completa. Confine attualeA01D al
checkpoint368 verso Wed09:10. Prefisso esteso0–367/368 sino Wed09:00,
7059 draw/15134 read,24 attori, arena/bitmap e futuro LOAD. Cinque finali
naturali restano aperti. Il limite cab5D0C rimane separato.
Atlante235 istruzioni/419 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C363–C37C,
C388–C3E3,CE10–CE17,D3E8–D447 più workspace5D23. Riferire le zone in chat.

Verifica conclusiva 5D23: suite completa 1.155 test passati, 0 errori; 106 controlli mirati passati.


30 ottobre2026 — leggere MODELLI-LESSICALI-E-FLAG.md e
results/model-flags-verification.json. A01D/E provengono dai nibble alti
dei modelli lessicali8259, non dal solo ultimo input. A2BD scrive prima
A01E poiA01D; chiamantiB416,C4DF,A323,A38B. Classi delle regole interne
non riscrivono questi flag; il testo di un ordine può lasciare il modello
citato. Caricamento0/0 verificato su4 seed; old LOAD assente resta unknown
fino al writer. Dry parsing/errori lessicali conservano.11 storie naturali,
43 input/53 checkpoint,273 store nativi,197 draw/394 read; tutti24 attori,
arena752/bitmap/LOAD.310 ABI controllati comprendono54 modelli e256 dati
sintetici, non gameplay naturale. Prefisso ora0–373/374 checkpoint fino
Wed10:00,7223 draw/15464 read. Prossimo confine5D1E verso10:10 al374,
non inventare il byte dai campi adiacenti. Test5D23 deve completare10:00,
poi interrompere regolarmente il WAIT prima del SAVE. Cinque finali
restano aperti; limite cab5D0C separato. Atlante328 istruzioni/701 byte:
A01D–A01E parziale->documentato;51 byte prima grigiA2B1–A2E3.
ApprofonditiA31A–A35C,A37D–A418,B1DD–B212,B405–B467,C493–C4D0,
C4D1–C559,CA76–CA7E,E345–E34E. Annunci di movimento/pagamento
aggiornano il modello anche fuori scena (A30C/A310 in modo1). Il confronto
continuo di2821 checkpoint deve restare attivo nel tool di verifica.
Riportare sempre le zone nuove in chat.

Verifica flag: confronto continuo2821 checkpoint,30265 store nativi e
lettura reale cuoca9/tick2945 superati. Ultimo writer Daphne5/CLOSE/modello8371,
C4DF->A2E0 stesso tick. Non installare8 come default. Annunci offstage
CA76 e pagamento E34B devono passare il modello prima di sopprimere il testo.


30 ottobre2026 — leggere GLIFI-E-FLAG-DI-SCANSIONE.md e
results/glyph-scan-flags-verification.json.5D1E èF della scansione nel
frameC388=5D2A del prefisso proprio del nome attore682A. Derivare i flag
diINC H della settima scansione e, se shift nonzero,DEC/INC C prima
diC3B8. OR della bitmap azzera carry; non riusare carry iniziale.
Nella riga bassa video,56->57 e shift1..7 danno0, ma non è un0 globale.
Altri frame:5D20:F chiamante;5D22:C chiamante;5D24:E descrittore;
5D26:L video;5D28:C scansione. CALL realeC374 può lasciare77.
Proprietà solo upperGlyphKnown===true; GO TO verificato conserva1E,
scene/errori/chiamanti sconosciuti revocano. Old LOAD senza1E restaunknown.
Nessun nuovo byte5D24–5D27. Il primo operando è superato ma il secondo
5D24 blocca la stessa estrazione del checkpoint374 versoWed10:10.
Prefisso completo invariato0–373/374 sinoWed10:00,7223 draw/15464 read,
24 attori/arena/bitmap/LOAD. Cinque finali ancora aperti; cab5D0C separato.
Atlante235 istruzioni/419 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C363–C37C,
C388–C3E3,CE10–CE17,D3E8–D447 e workspace5D1E. Riportare le zone in chat.

Traccia naturale5D1E: lettura giardiniere8/tick3009/Wed10:08; ultimo
writerC3B8/tick964/Lestrade2/glifo r diInspector/frame5D2A/colonna8/shift2/
HL5027/AF0000. Osservati anche store invariati e5D1F per distinguereA daF;
nessuna transizione non classificata. Non chiamare11:00 del probe un nuovo
certificato completo: il secondo operando5D24 blocca ancora il modello.


30 ottobre2026 — leggere GLIFI-E-DESCRITTORE-SALVATO.md e
results/glyph-descriptor-low-verification.json.5D24 èE del descrittore
salvato daPUSH DE/C38A nel frameC388=5D2A del prefisso proprio nome
attore682A. Derivare descriptor&FF, non0B catturato o video5D23.
1152 nuove ABI conDE5C0B/5C42/5123 si aggiungono ai1728 casi archiviati
e288 vereCALL C374. Altri frame:5D26:F chiamante,5D28:C chiamante,
5D2A:E descrittore,5D2C:L video,5D2E:C scansione,5D30:F scansione.
Proprietà upperGlyphKnown; anche invalidateGlyphExtras revoca24 su output
non proiettato. Old LOAD assente restaunknown anche con23 noto. Non
introdurre25–27 per vicinanza. Test5D1E deve ora completareWed11:00,
poi interrompere regolarmente il WAIT prima delSAVE; nuovo probe24 fino
Wed12:00, distinto dal prefisso completo393 checkpoint0–392 finoWed13:10,
7718 draw/16516 read,24 attori,arena752,bitmap e futuroLOAD. Nuovo
confine5D26 al393 verso13:20. Cinque finali e cab5D0C ancora aperti.
Atlante235 istruzioni/419 byte approfonditi, nessun nuovo byte grigio:
682A–682F,A59F–A5CC,A720–A770,A7C5–A7CF,A95B–A98F,C363–C37C,
C388–C3E3,CE10–CE17,D3E8–D447 più workspace5D24. Riferire le zone in chat.

Verifica naturaleE: ultimo storeC38A/tick964/Lestrade2/glifo r diInspector/
frame5D2A/SP5D26/DE5C0B/HL5027. Lettura giardiniere8/tick3009/Wed10:08,
E=0B. Nessuna transizione non classificata; osservato25 per distinguereD,
ma non introdotto. Non installare0B come fallback dei vecchi salvataggi.


30 ottobre2026 — leggere NOMI-LOCAZIONI-E-STACK.md e
results/room-name-stack-verification.json.5D26 è sovrascritto dal prefisso
proprio del nome locazione nell’ordine CE13: A360/A3DE/A745/A4AB/A7BA/D405,
frameC388=5D32, C3B8 salvaF della scansione finale della t diParliament.
Il precedenteC diInspector/frame5D2A è un ruoloABI valido, non ultimo writer.
Soggetto temporaneoA036=0 nella citazione; non cambiare lo scheduler.
Delimitatore dopo il prefisso ancora nel frame; Street rimane nel buffer
fino al ritorno. DerivareF daINC H eDEC/INC C, non0 dalla traccia.
Lettura cuoca9/tick3192/Wed13:11; ultimo writer964/AF0000/HL5035/shift2.
1728ABI e1152 varianti archiviate;109 test mirati passati. OldLOAD senza26
restaunknown; output senza contratto revoca.25/27 ancora non posseduti.
9920 èFF immutabile dopo24 righe da8 byte: esportarlo dal payload;
metadato assente rimaneunknown, non fallback. Prefisso402 checkpoint0–401
sinoWed14:40,7959draw/17042read,24 attori/arena752/bitmap/LOAD.
Prossimo confine5D27 al402 verso14:50, lettura originale14:43/tick3284.
Probe originale sino16:00 non è certificato completo. Cinque finali naturali
e cab5D0C restano aperti. Atlante324 istruzioni/616byte elencati,40 byte
prima grigiA360–A37C eA7BA–A7C4; approfonditiA37D–A418,C388–C3E3,
D3E8–D447,CE10–CE17,9920,workspace5D26 e ponti del testo. Riferire le zone.


31 ottobre2026 — leggere GLIFI-E-ULTIMA-RIGA.md e
results/glyph-last-row-verification.json.5D27 è A dell’ultima scansione
prima dello shift, salvato daC39D/C3B8 nel frame5D32 del prefisso proprio
della destinazione CE13. Derivare glyph[7] dal font: t=0,q=6,underscore255;
non0 catturato néF di26 o byte video ruotato. Ultimo writer964/soggetto
citato0/glifo t/frame5D32/HL5035/shift2, lettura cuoca9/tick3284/Wed14:43.
Altri frame:5D28 A chiamante,5D2A B chiamante,5D2C D descrittore,
5D2E H video,5D30 B scansione,5D32 A font. CALL realeC374/frame5D26
lascia inveceC3 del returnC377.768 nuovi ABI tutti96glifi/8shift,
1728ABI archiviati e288CALL. OldLOAD senza27 restaunknown anche con26;
scene/errori/caller sconosciuti revocano; unknownRoomName revoca26/27.
25/28 non introdotti. Test naturale26 deve raggiungereWed15:00 senza
not_translated, poi interrompereWAIT regolarmente perSAVE; stesso limite
esplicito nel test27. Non chiamare la durata maggiore del probe originale
un certificato completo. Prefisso404 checkpoint0–403 sinoWed15:00,
8011 draw/17166 read,24attori/arena752/bitmap/futuroLOAD. ProssimoA027
al404 versoWed15:10. Cinque finali naturali e cab5D0C ancora aperti.
Atlante324istruzioni/616byte approfonditi, nessun nuovo byte prima grigio:
C388–C3E3,C363–C37C,A360–A418,A7BA–A7C4,D3E8–D447,CE10–CE17,
workspace5D27 e ponti del testo. Riferire le zone e distinguere i raffinamenti.

Verifica conclusiva27:164 test mirati distinti passati, nessun errore residuo.
Probe originale76 input sinoWed18:00, nessuna transizione non classificata;
modello verificato solo sinoWed15:00. Anche28 osservato al tick3373 ma
non introdotto: il prossimo confine del modello èA027, non28.


31 ottobre2026 — leggere CANALE-DEL-TESTO.md e
results/output-channel-verification.json. A027 è il canale superiore0 /
inferiore1, non un valore immutabile del decoder. Payload iniziale esportato
in argumentChecks.initialOutputChannel. Campo corrente npcs.outputChannel:
D8A0 prompt1,D8A8 ritorno0,erroriD6E7/D710,D7C0/D7CA,CB69/CB74 1->0;
A306 sceglie dal modoA00C eA352 resetta0 anche fuori scena,CBAF forza0,
9A90 distingue soggetto0 dagliNPC. Non ripristinare il valore precedente
sui reset0. Prompt iniziale differito finché terminano gli NPC dello stesso
tick; prompt idempotente riscrive comunque1. OldLOAD senza campo rimane
unknown nel lettore dominio E casuale fino al writer; nientefallback0.
Nuova traccia originale3241 checkpoint sinoWed16:10, canale e ogni draw;
ultima scrittura alla lettura giardiniere8 èA352/tick3305/cuoca9.
Protocollo oracolo forza1 riprendendo l’editor: distinto dagli store Z80.
12 storie brevi conformi; 2 esplorative mantengono differenze già su15db455:
PRINT dopo SAY WATSON "WAIT UNTIL 9AM",I:MORE JS0/nativo2;
TAKE TO:failure budget JS3/nativo0. Corpus intatto; test di controesempio
separati, non certificati di parità. Vedere unrelated-boundaries.json.
Prefisso411 checkpoint0–410 sinoWed16:10,8201draw/17558read,24attori,
arena752/bitmap/futuroLOAD. Prossimo5D28 al411 verso16:20; lettura
originale16:12 già osservata. Non introdurreA028 o5D28 per vicinanza.
Cinque finali naturali e cab5D0C restano aperti. Atlante160istruzioni/338byte:
79byte prima grigi9A80–9A98 eCB43–CB78; A027 parziale->documentato.
ApprofonditiA2E4–A35C,A9B7–A9BE,C1E1–C1F3,CBA7–CBBA,D6E5–D713,
D7BA–D7CF,D898–D8AC. Riferire le nuove zone in chat.

Verifica conclusivaA027:47 controlli mirati distinti passati. Il nuovo
confronto continuo ha un confine di stato completo al1671/Tue14:02:
giardiniere8 PC EDE1 savedJS[50,33,1] contro nativo[50,255,1]. Riprodotto
anche su15db455 in minute-boundary.json. Confronto completo0–1670, poi
ambito esplicito canale/draw fino3241; non normalizzare la riga per
certificare lo stato intermedio. I411 checkpoint originali conLOAD
restano integralmente confrontati. PRINT/TAKE TO e questo residuo vanno
ricostruiti separatamente; corpus completo conservato.


31 ottobre2026 — leggere GLIFI-SHIFT-SCANSIONE-5D28.md e
results/glyph-scan-shift-verification.json.5D28 è C della scansione nel
frame5D32 del prefisso proprio destinazioneCE13. Derivare(2+7*colonna)&7;
C39C salva sempre,C3B7 solo conC nonzero. Non2 globale,8-C oB contatore.
Ultimo writerC3B7/tick964/soggetto citato0/t diParliament/colonna24/BC0102;
lettura giardiniere8/tick3373/Wed16:12. La traccia naturale è riutilizzata
con percorso eSHA256 da glyph-last-row, non una nuova esecuzione naturale.
216 nuove ABI frame5D34, più1728 ABI/1152varianti/288 vereCALL archiviate.
Sei ruoli:5D2A F chiamante,5D2C C chiamante,5D2E E descrittore,5D30 Lvideo,
5D32 Cscan,5D34 Fscan. CALL realeC374/frame5D28 lascia77 del returnC377.
OldLOAD senza28 restaunknown anche con27; errori/scene/caller ignoti
revocano. UnknownRoomName revoca26–28.25/29 ancora non posseduti.
Il test27 deve completareWed16:10, quello28 Wed16:30, poi interrompere
WAIT regolarmente prima del SAVE. Prefisso413 checkpoint0–412 sinoWed16:30,
8254draw/17684read,24attori/arena752/bitmap/futuroLOAD. ProssimoA028
al413 versoWed16:40. Non cambiare i test di controesempioA027: PRINT/MORE,
TAKE TO e riga del giardiniere al1671. La prova continuaA027 resta solo
canale/draw dopo tale confine di stato. Cinque finali e cab5D0C aperti.
Atlante324istruzioni/616byte approfonditi: C388–C3E3,C363–C37C,A360–A418,
A7BA–A7C4,D3E8–D447,CE10–CE17,workspace5D28 e ponti del testo.
Nessun nuovo byte prima grigio: comunicarlo, senza aumentare la copertura.

Verifica conclusiva5D28:113 controlli mirati distinti passati. Il prossimo
ingresso osservato èA028, prima del successivo byte dello stack29; non
estendere il certificato sino18:00 per la sola presenza della traccia.


31 ottobre2026 — leggere QUALIFICATORI-DEI-NOMI-A028.md e
results/name-qualifier-mode-verification.json. A028 è il modo dei due
qualificatori nel formatter tupleD405:0 completo,nonzero solo sostantivo
più articolo. Nome entitàD3E8 NON leggeA028: non troncare i nomi ovunque.
Campo npcs.nameQualifierMode; valore iniziale estratto dal payload in
argumentChecks.initialNameQualifierMode. Writer A37E0,A65E0,A7210,
A72E1,A73D1,A7980/1,D1D20,D5360 per ogni oggetto elencato. Input
lessicale o singole parole non resettano automaticamente. Mappa/UI
world.name/roomName restano puri. Il formatter foglia può conservare1/7/128.
Comando testo0(nameMode:full) e4(letterale) non condividono il writer:
A65E0 controA709nessuna scrittura. L’argomento è una tuple nome anche
per entità, non sempre roomID. Token19A7B4 prende l’ID daD, lo conserva
inAF alternativo e scrive1, nonD come modo; nome+copula ora supportato
con argomenti semantici dichiarati. OldLOAD senza campo restaunknown
anche nel lettore casuale fino al writer; non fallback dal payload.
HAIL speciale degliNPC deve fare A37D0 anche se il suo messaggio è
costruito senza Text.compose. D658 nome passaggio conserva il modo.
12 storie naturali/47input/57checkpoint,205draw/410read;16ABI tuple
modi0/1/7/128 e18ABI ingressi token. Traccia continua3281 checkpoint fino
Wed16:50: modo e ogni draw, NON stato completo oltre il controesempio
precedente. Lettura cuoca9:ultimoA37E/tick3399/giardiniere8/callerA34B.
Prefisso completo415 checkpoint0–414 sinoWed16:50,8296draw/17768read,
24attori,arena752,bitmap e futuroLOAD. ProssimoC128 al415 versoWed17:00.
Cinque finali, cab5D0C e i tre controesempi precedenti restano aperti.
Atlante282istruzioni/607byte:89 byte prima grigiA65E–A678,A709–A71F,
A793–A7B9;A028 parziale->documentato. ApprofonditiA37D–A418,A720–A750,
A7BA–A7CF,D1C6–D1DA,D3D5–D447,D526–D559,D60B–D66F. Riferire le zone.

Verifica conclusivaA028:49 controlli mirati distinti passati. La prova
continua include3281 checkpoint/8296draw/17768read, senza allargare la
certificazione di stato completo oltre i415 checkpoint originali.


31 ottobre 2026 — leggere FINESTRA-DEL-TESTO-C128.md e
results/text-window-mode-verification.json. C128 è modo finestra sorgente:
0 largo36, nonzero stretto18. C129/C12E azzeraA019 e scrive1; C142/C143
scrive0 ma conservaA019. Entrambi riposizionano il cursore; non cancellano
la parola pendente. BootC15D e inputD71D chiamanoC142; inputD719 azzera
prima il contatore. MOREC311 chiamaC142 senza azzerareA019: callerC2D4
FF/INC ->0. CR senzaMORE non è writer. world.display.windowMode posseduto
solo da writer compresi; oldLOAD assente restaunknown anche dopo prompt,
eco ed errori lessicali. Preflight controlli speciali non stabilisce un
flag assente: conservare il controesempio PRINT/MORE. C142 funziona anche
con tokens workspace mancante. Profilo casuale historical-text-only largo:
LOAD nonzero rifiutato; controlli ABI stretti verificati, bitmap completi
nativi stretti no. SVG/pixel UI sono presentazione, non writerC128.
12 storie/57checkpoint/205draw/410read,36ABI C129/C142/C306, provenienza
SHA256 delle due letture C128 nel riferimento nativo completo riutilizzato.
Atlante140istruzioni/279byte approfonditi: C128,C129–C15F,A277–A295,
C2CA–C37C,D719–D725. Zero byte prima grigi; copertura invariata.
Tre controesempi precedenti, cinque finali naturali e cab5D0C ancora aperti.

Esito C128:25 test mirati distinti passati. Il lookahead completo riconferma
415checkpoint0–414 sinoWed16:50,8296draw/17768read, stato completo eLOAD,
poi si ferma ancora al415 ma oraCB28, cuoca9/draw19 nel riferimento nativo,
valore204. Non usare il valore catturato come fallback. La letturaC128 è
draw10 del giardiniere8. Il confronto dello stato e di ogni draw NON viene
esteso al checkpoint415 annullato. Prossimo lavoroCB28, non5D29 dedotto.


31 ottobre2026 — leggere RISULTATI-DELLE-REGOLE-CB28.md e
results/rule-registers-verification.json. CB28–CB2B sono risultati IX/IY:
CB2C li ricarica per il corpo; CB34 chiama; CB37/CB3B salvano anche dopo
predicato falso. Preflight fallito prima del ponte e corpo differito non
sono writer. Campo npcs.ruleResultPointers=[word|null,word|null], oldLOAD
assente restaunknown. Mai inferire IY da IX o installare zero/catture.
RuleResults ricostruisce counter.create/decrement/delete, entity.at,
location.save e i preservatori wait.tick/clock.hour/F198. Counter.create
pubblica il nuovo record solo dopo il draw; durante il draw CB28 è precedente.
E573 trova record o0 e conserva IY=intestazione. Rilascio E58C: IY è9FE7
per il primo contatore o il record predecessore; IX è link del precedente
blocco libero se la prima fusione riesce, altrimenti start del blocco
liberato (A1FD/A204), non start+2. Non modificare l’allocatore per “correggerlo”.
Game.executeNode resta il comportamento dell’azione; execute proietta solo
il corpo OPEN/CLOSE ordinario riuscito(DE9D/DEAF): IX=descrittore risolto daA013,
IY entrante se posseduto. Azioni rifiutate non stabiliscono il valore.
Callback ignoti, parser/input e ritorno al prompt revocano la proprietà:
D770 può sovrascrivere l’ultimoNPC. Non rivendicare tutti i rami del ponte.
12 storie native/57checkpoint/205draw/410read con tutti24attori; controllo
di ogni byte dichiarato posseduto, stato originale completo e futuroLOAD.
92ABI contatori/arena e162ABI dei corpi OPEN/CLOSE. Quest’ultime bypassano
maschere: non sono una prova di ammissibilità arbitraria dell’azione.
Lettura naturale CB28 al415/draw19/cuoca9: il modello deriva90CC dalla
plain door50 dopo l’azione del giardiniere; riferimento nativo legge204.
Traccia lunga originale riutilizzata con percorso/SHA256, non una nuova
acquisizione né una traccia dello store originale di quel minuto.
Prefisso completo421 checkpoint0–420 sinoWed17:50,8441draw/18066read,
24attori,arena752,bitmap e futuroLOAD. Prossimo5D29 al421 versoWed18:00,
ora osservato, non dedotto per vicinanza. Cinque finali,cab5D0C e i tre
controesempi precedenti restano aperti. Helper compareNaturalHistory ha
hook solo osservativi opzionali: nessuna asserzione è tolta o normalizzata.
Atlante255istruzioni/573byte:14 byte grigiF19A–F1A7 e31 byte parziali
E58C–E5A7/E5AA–E5AC ora documentati. Approfonditi CB28–CB40,C9BF–CA75,
A1C7–A24C,E52F–E5AC,DE9D–DEC0,D769–D77D,F198–F1A7,F1D6–F1F5.
Copertura38784documentati/433parziali/2383sconosciuti su41600.

Verifica conclusiva CB28:42 test mirati distinti passati, inclusi i due
controesempi conservati. Certificato positivo tools/verify-witness-prefix.mjs
completato e scritto. Il log di scoperta aveva trovato5D29 ma fallito solo
lo store del rapporto EPERM; lookahead.json lo distingue dal certificato
positivo, senza inventare un numero di draw parziali al421. Traccia cache
JS in /private/tmp usata solo per diagnosi rapida, non come prova nativa
o fixture giocabile; la prova completa riparte dall’avvio naturale.

31ottobre2026 — leggere PAY-SENZA-TO.md e results/pay-omitted-to-verification.json.
PAY senza TO seleziona modello37 anche con0/1 nominali, non solo2. Ruoli
sempre destinatario/importo: B421/B445 usa il modo dativo, non la presenza
del denaro nel secondo gruppo. Preservare sourceNode/sourceGroupOrder e
slot fisici. PAY10D, PAY10DWATSON, PAY e PAYWATSON dannoDON’T BE SILLY.,
nessun pagamento/tempo/continuation. PAYWATSON10D e PAY10DTO WATSON
restano validi. In resolve, PAY ambiguo viene rifiutato prima del nominale
vuoto che attiverebbe una falsa domanda non allocata.11 storie native/24input,
74draw/148read,24attori,stato completo/bitmap/futuroLOAD,78 test mirati.
Atlante141istruzioni/312byte:8379–8380,B39D–B482,E345–E38E con header
E370–E373 dati. Certificato lungo non ampliato:421 checkpoint0–420 fino
Wed17:50, prossimo5D29. Restano tutti i limiti precedenti.
