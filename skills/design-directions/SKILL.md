---
name: design-directions
description: Explore and refine a product's visual language when the user wants genuinely different design options, has found a direction worth developing, or is dissatisfied with generic AI-generated UI. Use before converging on a redesign or design system; use ordinary UI implementation for already-settled direction.
---

# Design Directions

Create meaningfully different visual directions, make them concrete enough to evaluate, and turn the user's response into a coherent design language. Optimize for informed taste and product fit rather than novelty alone.

## Core Principles

- Start from the product thesis, audience, use context, and the user's taste—not a catalog of fashionable styles.
- Research precedents before generating directions. Include adjacent fields and cultural references, not only direct competitors.
- Compare directions using the same representative content or interaction so visual differences remain legible.
- Make alternatives structurally different. A palette or border-radius swap is not a new direction.
- Keep early explorations rough enough to invite change. Polish the selected direction after learning from alternatives.
- Treat accessibility and usability as a shared quality floor, not the axis that distinguishes directions.
- Record the reasoning behind what the user likes. The goal is a reusable visual grammar, not merely a preferred screenshot.

## Direction Progress

Copy this checklist and scale the depth to the request:

```text
Design Direction Progress:
- [ ] Understand the product, current interface, and user's taste
- [ ] Research relevant and unexpected precedents
- [ ] Define independent creative territories
- [ ] Make comparable visual explorations
- [ ] Gather specific reactions and synthesize a direction
- [ ] Refine the selected direction on a representative surface
- [ ] Persist the durable design language when warranted
- [ ] Verify the result in its real rendering environment
```

## 1. Establish the Design Question

Determine what is actually unsettled: overall identity, typography, composition, density, interaction character, color behavior, imagery, motion, or the relationship between them.

Inspect the current product, existing tokens and components, prior design artifacts, screenshots, and any examples the user likes or dislikes. When the user already likes something, analyze why before proposing replacements. Extract its visual grammar:

- hierarchy and typographic voice;
- rhythm, density, and use of space;
- composition and alignment;
- geometry, borders, depth, and material qualities;
- color roles and contrast behavior;
- imagery, illustration, iconography, and texture;
- interaction and motion character;
- details that feel specific to this product.

Ask only about taste or product decisions that cannot be inferred from the evidence. Prefer questions such as “what feels right about this?” over asking the user to select a style label.

If the product, reference, or rendering context needed for a meaningful
comparison is unavailable, state the gap. Continue provisionally when the
remaining evidence can still support useful directions; otherwise stop with the
smallest concrete input or access needed.

## 2. Research Precedents

Research a small, relevant reference set. Depending on the product, draw from:

- direct competitors, to understand category conventions and sameness;
- adjacent products with similar interaction or trust requirements;
- editorial, industrial, environmental, game, fashion, architectural, or information-design references;
- historical visual systems or movements that fit the intended character;
- existing brand materials and the product's real content.

For each useful precedent, identify the transferable principle rather than copying its surface. Cite or link references so the influence remains inspectable.

Avoid trend aggregation as the primary research method. Popular galleries tend to reinforce the same visual center the exercise is meant to escape.

## 3. Construct Independent Territories

Create three or four directions by default, adjusted when the scope calls for fewer or more. Name each direction for its product-specific idea, not a generic adjective alone.

Define every direction across the same dimensions:

1. **Concept** — the product truth or emotional quality it expresses.
2. **Composition** — hierarchy, grid, alignment, density, and spatial rhythm.
3. **Typography** — roles, contrast, voice, and plausible type choices.
4. **Color** — functional roles, dominance, contrast, and temperature.
5. **Form** — geometry, borders, depth, material, and component character.
6. **Imagery** — photography, illustration, iconography, data display, or intentional absence.
7. **Behavior** — interaction feedback, transitions, and motion temperament.
8. **Signature move** — one memorable device that belongs to the product.

Require each pair of directions to differ materially across several dimensions. If two directions could be converted into one another by changing tokens, merge or replace one before presenting them.

Do not use a universal banned-pattern list as a substitute for judgment. Familiar fonts, cards, gradients, or rounded forms are acceptable when they express the chosen direction and serve the product. Reject unexamined defaults, not ingredients categorically.

## 4. Make the Directions Comparable

Use style tiles by default because they make visual-language differences cheap
to explore. Use a representative screen, interaction prototype, or component
family instead when composition, behavior, or extension of an existing system
is the actual uncertainty:

- **Style tiles** for typography, palette, controls, imagery, and surface language.
- **A representative screen** when composition and hierarchy matter.
- **A focused interaction prototype** when behavior or motion is decisive.
- **A component family** when the existing language needs expansion rather than replacement.

Use the same content, data, viewport, and functional requirements across directions. Keep exploration implementations isolated from production code unless the user explicitly wants an in-place redesign.

Render the alternatives. Inspect them visually rather than judging code or prose alone. Present them together when the environment supports side-by-side comparison.

## 5. Learn From the User's Reaction

Do not reduce feedback to “pick A, B, or C.” Ask what specifically attracts or repels the user:

- Which hierarchy feels natural?
- Which details feel generic, forced, or unlike the product?
- What emotional signal is right or wrong?
- Which direction would remain interesting after repeated daily use?
- Which elements should be combined, and why do they belong together?

Translate reactions into principles. When combining directions, maintain a coherent underlying concept rather than assembling favorite fragments indiscriminately.

If none succeeds, identify what all directions assumed in common and make the next round challenge that assumption. Change the governing idea, not merely the styling.

After two materially different rounds without a viable direction, stop
generating alternatives. Summarize what the reactions established and ask
whether to gather stronger references, change the brief, prototype a narrower
surface, or pause the exploration.

## 6. Converge and Persist

Refine the selected or synthesized direction on one realistic surface before expanding it across the product. Include real content and important edge states where they affect the visual language.

When the direction will guide future work, update the project's existing design-system artifact. If none exists, propose `DESIGN_LANGUAGE.md` before creating it. Capture only durable guidance:

- design thesis and principles;
- reference influences and transferable lessons;
- typography, color, spacing, composition, form, imagery, and motion rules;
- tokens and components that embody the language;
- signature elements;
- intentional constraints and context-specific anti-patterns;
- representative examples or screenshots.

Record rejected directions only when their rejection teaches a durable boundary. Temporary explorations do not need to remain in the product repository after their useful ideas and decisions have been captured.

After writing or updating the design-language artifact, read it back and verify
that it matches the selected direction and distinguishes established rules from
ideas that still need validation.

## 7. Verify in Context

Render the refined direction in the real application or an equivalent browser environment. Check:

- whether hierarchy and character survive real content;
- responsive layouts and relevant viewport sizes;
- contrast, focus, keyboard, and motion accessibility;
- loading, empty, error, overflow, and dense-data states when relevant;
- consistency between documented principles, tokens, and implementation;
- whether the result still resembles the selected direction rather than drifting toward framework defaults.

Iterate on observed problems and render again. If the environment cannot provide visual verification, state what remains unverified and provide the exact next viewing or testing step.

## Method Foundations

This approach adapts established practices rather than prescribing a fixed visual style:

- [Style tiles](https://digital.gov/guides/research-collaboration/designing/visual-language) establish and iterate toward a shared visual language before full-page polish.
- [Parallel design](https://www.nngroup.com/articles/parallel-design/) explores independent alternatives before synthesizing their strongest ideas.
- [Rough, rapid, and focused prototyping](https://www.ideo.com/journal/rough-rapid-and-right-in-the-age-of-ai) keeps early artifacts useful for learning instead of mistaking polish for evidence.

Existing agent-design skills provide valuable implementation guidance and anti-default reminders. This skill's distinct purpose is the divergence-and-convergence loop: create genuinely different options, understand the user's response, and preserve the resulting visual language.
