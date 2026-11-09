# Evidence

Every design choice and where it comes from. No study has tested this timer. The studies support the parts, not the whole.

## Design choices backed by studies

| Choice | Finding | Source | How direct |
|---|---|---|---|
| Silence notifications during a block | Notifications alone hurt an attention task, even when people did not touch the phone. The harm was about as large as calling or texting. | Stothart, Mitchum, Yehnert 2015, *JEP: HPP* 41(4), [10.1037/xhp0000100](https://doi.org/10.1037/xhp0000100) | Direct. 212 students, phone alerts, not desktop alerts. |
| Log every block | Monitoring progress raised goal attainment, d = 0.40 (95% CI 0.32 to 0.48), 138 randomized studies, N = 19,951. Effects were larger when progress was physically recorded. | Harkin et al. 2016, *Psych. Bulletin* 142(2), [10.1037/bul0000025](https://doi.org/10.1037/bul0000025) | Direct for logging. |
| Name the task before starting | Implementation intentions: d = .65 across 94 tests. | Gollwitzer & Sheeran 2006, [10.1016/S0065-2601(06)38002-1](https://doi.org/10.1016/S0065-2601(06)38002-1) | Partial. The real method is an if-then plan; naming a task and a time is a weaker form. A 642-test update exists ([10.1080/10463283.2024.2334563](https://doi.org/10.1080/10463283.2024.2334563)); its numbers were not read. |
| Nothing blinks or animates | Steady motion does not grab attention. The start of motion does. | Abrams & Christ 2003, *Psych. Science* 14(5), PMID 12930472 | Inference. Lab letter-search task. Nobody has tested a bar clock. By this logic a seconds display, which changes once a second, is worse than minutes only. It shows seconds because that was the requirement. |
| Do not switch tasks casually | Attention stays on an unfinished task and the next task suffers. | Leroy 2009, *OBHDP* 109(2), 168-181 | Direct. |

## What the studies do not support

**Counting forward is only half right.** People are motivated by whichever number is smaller: done-so-far early on, remaining near the end (Koo & Fishbach 2012, *J. Consumer Research* 39(3), [10.1086/663827](https://doi.org/10.1086/663827)). Evidence comes from loyalty cards and similar goals. By that logic a count-up helps in the first half of a block and loses to a countdown in the second half. It counts forward because that was the requirement.

**Three hours straight is not proven good or bad.** Breaks of 10 minutes or less raised vigor (d = .36) and lowered fatigue (d = .35), but overall performance did not improve significantly (d = .16), and on cognitively demanding tasks the effect was d = -0.09, not significant. Longer breaks gave larger gains (Albulescu et al. 2022, *PLOS ONE*, [10.1371/journal.pone.0272460](https://doi.org/10.1371/journal.pone.0272460)). So there is no study-backed reason to interrupt a block for a short break, and the fatigue cost is real. The timer does not interrupt. To measure it, compare `focus log` output on 3h days and 90m days against what you actually finished.

**A visible clock has no clear effect.** Studies found more time pressure or less anxiety depending on the group. The ones found were small and mostly about children or tests, so none is used here.

**Not verified:** the "80-minute practice session" and "4 hours a day" numbers often credited to Ericsson 1993. The paper could not be opened, so they are not used.

## Napoleon: what the record says

Sources are people who were in the room. The memoirs are not lab data and they disagree in places.

| Fact | Source |
|---|---|
| Called at 7, often allowed to 8. Slept "seven hours out of the twenty-four, besides taking a short nap". "Bonaparte made others watch, but he himself slept, and slept well." First Consul years. | Bourrienne, *Memoirs*, Gutenberg #3567 |
| Valet enters between 6 and 7. Never more than six hours of sleep, in one stretch or in pieces. Empire years. | Masson, *Napoleon at Home* (1894) |
| Usually about 3 hours of sleep, then up to his study at night: figures alone, or dictation if the work was long, then back to bed. | Masson, vol. 2, p. 78-80 |
| "Be here to-night, at one o'clock, or at four in the morning; we will work together." Then back to bed, "if only to sleep an hour". | Méneval, *Memoirs*, vol. 1, p. 368-369 |
| 09:00 exactly: official day begins. | Masson, vol. 1 |
| Breakfast set for 09:30, audiences often ran to 11:00. Meal "no more than seven or eight minutes". In the First Consul years breakfast was at 10:00 (Bourrienne). | Masson, vol. 1 |
| Study "doors … shut and well guarded, and no one can possibly enter". | Masson, vol. 2, ch. VII |
| 18:00 "was the regular time for dinner". Often 19:00 or 20:00, sometimes 23:00. A quarter of an hour. | Masson, vol. 2 |
| 22:00 "the usual hour of the official coucher". | Masson, vol. 2, p. 77 |
| "One or two hours in every day" on army returns. | Napoleon to Joseph, 20 Aug 1806, quoted in Bourrienne |
| At one sitting he went through war, diplomacy, finance, commerce, public works, "and rested from one kind of work by engaging in another". | Méneval, vol. 1, p. 375 |
| "I close the drawer in which it is, and I open another. The two pieces of business never get mixed up." | Napoleon, reported by Méneval, vol. 1, p. 375 |
| Sometimes "whole days without doing any work". | Méneval, vol. 1, p. 376 |

**Hours per day.** Napoleon told Méneval he had worked sixteen hours a day since leaving military school (self-report, Méneval vol. 1). Masson's arithmetic gives 15 (24 minus 6 sleep minus 3 for meals and leisure, a figure Masson calls too high). Roederer said 18. Nobody measured it. These hours include audiences, meals with reports read aloud, and theatre: "he worked everywhere — while dining, at the ball, at the theatre" (Masson). They are not solo focused hours.

**There is no recorded block system.** No memoir gives a fixed block length. The closest numbers are the 1 to 2 hours a day on army returns in the 1806 letter to Joseph, which covers one subject only, and the fixed points of the day.

### What the timer takes from him

| From the record | In the timer |
|---|---|
| Shut, guarded doors | Do Not Disturb during a block |
| Drawers, one open at a time | `next` closes one task and opens another |
| Many subjects in one sitting | Block clock keeps running across tasks |
| 1 to 2 hours a day on army returns (one subject, one letter) | `01:00:00` and `02:00:00` work directly, and the log shows hours per subject |
| 18:00 dinner, 22:00 bed | A dashboard button fills in the exact time until the next of these |

### What the timer does not copy

His night work and short sleep. Six hours or less a night for 14 days caused cumulative deficits equal to up to 2 nights of total sleep loss, and people did not notice how impaired they were (Van Dongen et al. 2003, *Sleep* 26(2), PMID 12683469). Méneval, working beside him, wrote that he lacked "the precious gift of being able to go to sleep at will" (vol. 1, p. 376).

His switching is also the opposite of Leroy 2009, which found switching away from unfinished work hurts the next task. Napoleon said it never tired him; that is his own claim. For hard study, stay on one task.
