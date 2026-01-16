# Guidelines

- Dont write READMEs or other markdown files unless specifically asked for

## Strategic approach

- NEVER assume your assumptions are correct. ALWAYS verify them using cli tools, if possible.
- ALWAYS discuss proposed changes with the user and wait for explicit approval before implementing. Do not start editing files until the user confirms the approach is correct.
- When proposing fixes, always present both a quick fix and a proper fix, if available. Prefer the proper fix, but let the user decide based on time/complexity tradeoffs.

## Cli Commands

- ALWAYS run the lint, format, compiler, and build commands after your changes, if available in the project.
- ALWAYS check available cli tools for the project before running commands.

## Coding Rules

The following coding rules must be followed, with common sense, in all implementations:

### Variables & Naming

- Always use `const` variables. NEVER reassign using `let`.
- NEVER use meaningless one-letter or short variables that don't clearly state the value they hold. Some shorthands, such as `acc`, that are used commonly are allowed.
- NEVER use variable names that don't explain WHAT they are. For example `current` is a bad name as it doesn't say what it is.
- NEVER name variables `data`. All values in programming are data, therefore this name is meaningless.
- ALWAYS start constants holding booleans with `is`, `has`, `does`, or similar.
- Variables holding an `Option` type OR optional values (values that could be undefined) should be prefixed with `maybe` (e.g., `const maybeValue = Option.none()` or `const maybeUser = users.at(0)`).
- Ensure variables and constants have the unit in their name if applicable. For example `TIME_IN_MS` vs `TIME`.
- Write numbers using `_` as a separator for readability. For example, `1_000_000` instead of `1000000`.
- Avoid magic numbers. Always move them to named constants. Numbers assigned to descriptive constant names (e.g., `const fontSizeInPx = 48`) or descriptive object keys (e.g., `{ fontSize: 48 }`) are acceptable as the name provides meaning.
- ALWAYS name mapping objects using the pattern `X_BY_Y` (e.g., `ITALIC_VARIANT_BY_FONT_VARIANT`, `COLOR_BY_GENRE`). NEVER use `X_MAP` or similar patterns.
- NEVER use `derive` as a function prefix. Use `get` instead (e.g., `getColorFromHsl` not `deriveColor`).
- NEVER extract single-use expressions into variables. Inline them at the call site. Only create a variable when the value is used multiple times or the expression is genuinely complex.

### Arrays & Data Access

- NEVER use `[index]` array access. Prefer array destructuring when appropriate (e.g., `const [first, second] = array`). Use `.at(index)` as a fallback when destructuring isn't practical.
- Prefer pattern matching arrays over access through indexes. For example, `const [a, b] = text.match(regex) ?? []` is preferred over `const match = text.match(regex)[0]; const a = match.at(1); const b = match.at(2);`
- ALWAYS use nested destructuring in a single statement, including with function calls. For example, `const { items: [firstItem] } = getResult()` instead of `const { items } = getResult(); const [firstItem] = items;` or `const result = getResult(); const { items: [firstItem] } = result;`

### Code Style & Formatting

- ALWAYS add spacing before and after conditions.
- NEVER use single-line if statements.
- ALWAYS add spacing before `return`.
- Use consistent formatting for object keys, for example if all keys use `"test key"`, `"key"` should use quotes as well.
- ALWAYS use `dedent` for multiline strings, if available in the current project.
- ALWAYS prefer object shorthand syntax when the variable name matches the key name (e.g., `{ imageBuffer }` not `{ imageBuffer: imageBuffer }`).

### Functions & Structure

- NEVER define named helper functions inside other functions. Define helper functions above the function that uses them. This does NOT apply to callbacks passed directly to higher-order functions like `map`, `filter`, `reduce`, `Array.from`, etc. - those should remain inline.
- NEVER define callback functions separately from their usage. Always write callbacks inline at the call site (e.g., `items.map((item) => item.value)` not `const callback = (item) => item.value; items.map(callback)`).
- ALWAYS use functional equivalents of loops. NEVER use `.forEach`.
- NEVER use functional equivalents of loops for side effects. Use regular `for` loops instead.
- Follow functional programming principles.

### Type Safety

- NEVER use type casting (`as`) unless absolutely unavoidable. Type casting is a last resort and indicates a design flaw. Prefer type guards, proper generic constraints, `satisfies`, or refactoring the code to achieve type safety naturally.
- ALWAYS specify the accumulator type in `.reduce()` using the generic parameter (e.g., `.reduce<Record<string, number>>((acc, item) => ..., {})`) instead of casting the initial value with `as`.
- NEVER declare inline type aliases inside functions. Either repeat the type directly or define reusable types at module level.

### Control Flow

- NEVER use `switch` statements. Use the package `ts-pattern` and its `match`-function instead.

### Comments & Maintenance

- NEVER add explanatory comments unless specifically instructed.
- NEVER try to preserve code only for avoiding breaking changes.

## Tests

- Always write unit tests with the given/when/then pattern.

## Dependencies

- Always use the package manager used in the project, in most cases this is pnpm or bun
- When installing npm packages, always fix the version. Ensure you are installing the latest version.
- Always use context7 when I need code generation, setup or configuration steps, or library/API documentation. This means you should automatically use the Context7 MCP tools to resolve library id and get library docs without me having to explicitly ask.
