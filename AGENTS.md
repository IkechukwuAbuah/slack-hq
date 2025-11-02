# Repository Guidelines

This repository is an empty scaffold for the Slack HQ initiative. Keep this guide close as you bring the first services online so that contributions remain predictable, reviewable, and easy to automate.

## Project Structure & Module Organization
The root currently contains `CLAUDE.md` (agent onboarding notes) and `logs/` (prior AI session telemetry). When you introduce code, place runtime modules under `src/`, shared configuration in `config/`, tests in `tests/`, and developer scripts in `scripts/`. Favor shallow slices over deep nesting; for example:

```
src/
  slack/
    client.ts
    workflows/
tests/
  slack/
    client.spec.ts
```

## Build, Test, and Development Commands
Record every runnable script in `package.json` or a `Makefile` so agents can execute them non-interactively. Expected baseline once tooling is added:

```
npm install          # install dependencies
npm run dev          # start the local Slack integration sandbox
npm test             # run the entire automated test suite
```

If another toolchain is chosen (e.g., Poetry, Taskfile), replicate the same triad: install, dev loop, and tests.

## Coding Style & Naming Conventions
Default to TypeScript with ES2022 targets. Use 2-space indentation, trailing commas, and single quotes. Name modules in kebab-case (`user-routing.ts`), export classes in PascalCase, and keep pure helpers in `utils/`. Enforce consistency with ESLint + Prettier (`npm run lint` and `npm run format` once configured). Document any intentional deviations directly in `CLAUDE.md`.

## Testing Guidelines
Adopt a fast unit runner (Jest or Vitest) and add integration coverage for Slack API flows. Mirror source paths inside `tests/`, suffixing files with `.spec.ts` or `.test.ts`. Ensure PRs include the relevant new or updated tests and keep coverage at ≥80% for core packages. Run `npm test -- --watch` during development to catch regressions early.

## Commit & Pull Request Guidelines
There is no existing Git history, so start with Conventional Commits (`feat:`, `fix:`, `chore:`). Link issues in the body, describe behavior changes, and list impacted services. Pull requests should state deployment impact, include screenshots or console logs for user-facing changes, and confirm the test command output. Flag any manual Slack workspace steps so reviewers can reproduce them.

## Security & Configuration Tips
Store workspace secrets in `.env.local`, never in version control. Supply `.env.example` with placeholder keys (`SLACK_BOT_TOKEN`, `SLACK_SIGNING_SECRET`). Validate environment variables at startup and gate any production toggles behind feature flags so agents can exercise staging environments safely.
