# Type Driven Development Cards

## Edge Color Legend (When to Apply)

| Category | Edge Color |
|----------|------------|
| Boundaries/I/O | Blue |
| Domain modeling | Purple |
| State machines | Orange |
| API design | Teal |
| Function-level | Gray |
| System-level | Brown |
| Module-level | Pink |
| Value-level | Cyan |

---

## Card 1

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Parse, Don't Validate |
| **Description** | Transform untyped data into typed structures at system boundaries. Once parsed, trust the types in the rest of your code. |
| **Example** | `const user = ZodUserSchema.parse(json)` at the boundary, then `user.name` and `user.email` are guaranteed valid everywhere |
| **Level** | Beginner |
| **When to Apply** | Boundaries/IO |
| **Learn More** | https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Shotgun Parsing |
| **Description** | Validation logic scattered throughout codebase, checking the same fields repeatedly in different places, only checking the fields a function/method needs, inconsistent handling of invalid data. |
| **Example** | `if (json.name && typeof json.name !== 'string') { throw new Error('Name is needs to be a string') }` repeated in 5 different files. What about `json.email` or other fields? At any point of the code, bad data on just 1 field can crash the application. |

---

## Card 2

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Discriminated Unions |
| **Description** | Use a `tag` field to distinguish between variants of a type. Enables exhaustive pattern matching. |
| **Example** | `type Result<T, E> = { tag: 'Ok', value: T } \| { tag: 'Err', error: E }` |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, State Machines |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Boolean Blindness |
| **Description** | Using booleans or strings to represent states loses information and requires runtime checks to determine meaning. |
| **Example** | `process(true, {}, undefined)` — caller must remember what `true` means, often having to read the function/method contents to understand. |

---

## Card 3

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Make Impossible States Impossible |
| **Description** | Design types so invalid states cannot be represented. Use discriminated unions to make each state explicit. |
| **Example** | `type Request = { tag: 'loading' } \| { tag: 'success', data: User } \| { tag: 'error', error: string }` |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, State machines |
| **Learn More** | https://www.youtube.com/watch?v=IcgmSRJHu_8 |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Invalid State Combinations |
| **Description** | Optional fields with implicit relationships where certain combinations are meaningless or contradictory. |
| **Example** | `type Request = { loading: boolean, data?: User, error?: string }` — what does `{ loading: true, data: someUser, error: "failed" }` mean? |

---

## Card 4

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Exhaustiveness Checking |
| **Description** | Compiler ensures all union cases are handled. Add new variant and compiler shows every place to update. |
| **Example** | `switch(request.tag) { case 'loading': ... case 'success': ... }` Compiler will tell you that you forgot the 'error' case. Also, you don't need a `default` case. |
|**Level** | Beginner |
| **Edge Color** | Purple / Orange |
| **When to Apply** | Domain modeling, State machines |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#exhaustiveness-checking |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Forgotten Case Bugs |
| **Description** | Adding a new string status and missing handlers in switch statements, discovered only at runtime. |
| **Example** | `type Request = { status: string, data?: User, error?: string } switch (request.status) { case 'loading': ...; case 'success': ... }` — added `'cancelled'` but forgot to handle it. |

---

## Card 5

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Result Types |
| **Description** | Return success or failure explicitly in the type. Caller must handle both cases. |
| **Example** | `function readFile(fileName: string): Result<File, NotFound \| NoPermission>` |
|**Level** | Beginner |
| **When to Apply** | Boundaries/I/O, API design |
| **Learn More** | https://github.com/supermacro/neverthrow |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Exception Blindness |
| **Description** | `try/catch` doesn't tell you what can fail from the type signature. Exceptions bypass the type system entirely. Error type also tells you how to recover if possible, e.g. `ValidationError`: user can fix input. `Throttled`: retry/backoff is valid. `Unknown`: unrecoverable here; escalate/fail fast. |
| **Example** | `function getUser(id: string): User` — throws `NotFoundError`? `ValidationError`? `DatabaseError`? Who knows! Have to read the code and write unit tests in case code stops throwing error you may want to recover from. |

---

## Card 6

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Branded Types |
| **Description** | Distinguish semantically different values that share the same primitive type. |
| **Example** | `type UserID = string & { brand: 'UserID' }` and `type ProductID = string & { brand: 'ProductID' }` then create a value `const UserID = '123' as UserId` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://egghead.io/blog/using-branded-types-in-typescript |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Primitive Obsession |
| **Description** | Accidentally passing one ID where another is expected. Compiler can't distinguish between two `string` values. |
| **Example** | Accidentally passing a `userID` to `getProduct(userID)` compiles fine but fails at runtime — both are just `string` |

---

## Card 7

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Opaque Types |
| **Description** | Hide internal representation, force construction through validated factory function. |
| **Example** | `type ValidEmail = ...` (internal) with only `createEmail(s: string): ValidEmail \| undefined` exported |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling, Module-level |
| **Learn More** | https://michalzalecki.com/nominal-typing-in-typescript/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Accidental Forgery |
| **Description** | Creating invalid values directly by bypassing validation, since the type is just a primitive alias. |
| **Example** | `const email: Email = "not-an-email"` — compiles if `Email` is just `type Email = string` |

---

## Card 9

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | NonEmpty Collections |
| **Description** | Type that guarantees at least one element exists in an Array. |
| **Example** | `type NonEmptyArray<T> = [T, ...T[]]` or `type AtLeast1Item<T> = { first: T, rest: T[] }` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://gcanti.github.io/fp-ts/modules/NonEmptyArray.ts.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Empty Collection Crashes |
| **Description** | Accessing first element or reducing without initial value on potentially empty arrays. |
| **Example** | `const first = items[0]` — `undefined` if empty; `items.reduce((a, b) => a + b)` — throws if empty |

---

## Card 10

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Total Functions |
| **Description** | Function that returns a value for every possible input. No exceptions, no undefined behavior. |
| **Example** | `divide(a: number, b: PositiveNumber): number` — impossible to pass zero |
|**Level** | Intermediate |
| **When to Apply** | Function-level |
| **Learn More** | https://wiki.haskell.org/Partial_functions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Partial Functions |
| **Description** | Functions that throw or crash for some inputs, with hidden failure modes not visible in the type signature. |
| **Example** | `function divide(a: number, b: number): number { return a / b }` — returns `Infinity` or `NaN` for edge cases. |

---

## Card 11

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Smart Constructors |
| **Description** | Factory functions that validate and return `Result` or `Option` instead of throwing. |
| **Example** | `const email = Email.create(input) // Result<Email, InvalidEmailError>` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://dev.to/gcanti/functional-design-smart-constructors-14nb |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Constructor Exceptions |
| **Description** | Constructors that throw on invalid input — caller doesn't know from type signature that it can fail. |
| **Example** | `new Email("invalid")` throws — but `new Email(input)` looks safe in the code |

---

## Card 13

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Anti-Corruption Layer |
| **Description** | Translate external/legacy types into your domain types at the boundary. Keep external shapes outside. |
| **Example** | `const user = toUser(apiResponse)` — API shape stays at edge, domain shape inside |
|**Level** | Advanced |
| **When to Apply** | Boundaries/IO, System-level |
| **Learn More** | https://docs.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Leaky Abstractions |
| **Description** | External API shapes spreading through codebase, coupling your domain to third-party structures. Also leads to Shotgun Parsing. |
| **Example** | `function processUser(user: APIYouDontOwnResponse)` used deep in business logic — API changes, everything breaks. Their messy data makes your code messy. Data in Python snake case (e.g. `first_name`)? Now used in your `cameCase` code base making it harder to read. |

---

## Card 14

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Pipeline Builder |
| **Description** | Pattern to build a function for processing some data using a series of piped functions. |
| **Example** | ```Success().concat(isPasswordLongEnough(password)).concat(isPasswordStrongEnough(password)).map(_ => password);``` returns `Success(password)` if it's valid or `Failure([validation failures here])` |
|**Level** | Advanced |
| **When to Apply** | Decoders, Validation |
| **Learn More** | https://sporto.github.io/elm-patterns/advanced/pipeline-builder.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Fast-Fail Validation Chains |
| **Description** | Imperative or monadic validation often stops at the first failure, so users only see one error at a time. |
| **Example** | `if (!name) return Left('name'); if (!email) return Left('email');` — only the first error is returned. |

---

## Card 15

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Typestate |
| **Description** | Encode lifecycle states in types so only valid transitions are possible at compile time. |
| **Example** | `type Draft = { tag: 'Draft' }; type Submitted = { tag: 'Submitted' }; function submit(d: Draft): Submitted` |
|**Level** | Intermediate |
| **When to Apply** | State machines |
| **Learn More** | https://sporto.github.io/elm-patterns/advanced/flow-phantom-types.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Illegal State Transitions |
| **Description** | Operations run in the wrong order because lifecycle rules are only enforced by runtime checks. |
| **Example** | `approve(order)` compiles even when `order` is still draft |

---

## Card 16

### FRONT (Solution)

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Content</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Title</strong></td>
      <td>Indexed Types</td>
    </tr>
    <tr>
      <td><strong>Description</strong></td>
      <td>Carry useful facts in type parameters (length, state, currency, etc.) so operations preserve invariants.</td>
    </tr>
    <tr>
      <td><strong>Example</strong></td>
      <td>
        <pre><code class="language-typescript">type USD = { readonly _unit: "USD" };
type EUR = { readonly _unit: "EUR" };

type Money&lt;C&gt; = { amount: number; currency: C; };

function add&lt;C&gt;(a: Money&lt;C&gt;, b: Money&lt;C&gt;): Money&lt;C&gt; {
  return { amount: a.amount + b.amount, currency: a.currency };
}

const usd1: Money&lt;USD&gt; = { amount: 10, currency: { _unit: "USD" } };
const eur1: Money&lt;EUR&gt; = { amount: 7, currency: { _unit: "EUR" } };

add(usd1, usd2); // ok
// add(usd1, eur1); // compile-time error</code></pre>
      </td>
    </tr>
    <tr>
      <td><strong>Level</strong></td>
      <td>Advanced</td>
    </tr>
    <tr>
      <td><strong>When to Apply</strong></td>
      <td>Domain modeling, Value-level</td>
    </tr>
    <tr>
      <td><strong>Learn More</strong></td>
      <td><a href="https://www.typescriptlang.org/docs/handbook/2/generics.html">https://www.typescriptlang.org/docs/handbook/2/generics.html</a></td>
    </tr>
  </tbody>
</table>

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Currency Mixups |
| **Description** | Monetary values with different currencies are treated as plain numbers, so invalid operations compile and produce incorrect totals. |
| **Example** | `add({ amount: 10, currency: 'USD' }, { amount: 7, currency: 'EUR' })` silently mixes currencies without conversion |

---

## Card 17

### FRONT (Solution)

<table>
  <thead>
    <tr>
      <th>Field</th>
      <th>Content</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Title</strong></td>
      <td>Units-of-Measure Types</td>
    </tr>
    <tr>
      <td><strong>Description</strong></td>
      <td>Encode physical/business units in types to prevent invalid arithmetic across incompatible dimensions.</td>
    </tr>
    <tr>
      <td><strong>Example</strong></td>
      <td>
        <pre><code class="language-typescript">// Branded unit types
type Meters = number & { readonly _unit: "m" };
type Seconds = number & { readonly _unit: "s" };
type MetersPerSecond = number & { readonly _unit: "m/s" };

// Smart constructors
const meters = (n: number): Meters => n as Meters;
const seconds = (n: number): Seconds => n as Seconds;

// Unit-safe operations
const addMeters = (a: Meters, b: Meters): Meters => meters(a + b);
const addSeconds = (a: Seconds, b: Seconds): Seconds => seconds(a + b);
const divideMetersBySeconds = (d: Meters, t: Seconds): MetersPerSecond =>
  (d / t) as MetersPerSecond;

// Usage
const distance = meters(100);
const time = seconds(9.58);
const speed = divideMetersBySeconds(distance, time);</code></pre>
      </td>
    </tr>
    <tr>
      <td><strong>Level</strong></td>
      <td>Intermediate</td>
    </tr>
    <tr>
      <td><strong>When to Apply</strong></td>
      <td>Value-level</td>
    </tr>
    <tr>
      <td><strong>Learn More</strong></td>
      <td><a href="https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure">https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure</a></td>
    </tr>
  </tbody>
</table>
```

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Unit Mixups |
| **Description** | Values with different units are treated as plain numbers and combined incorrectly. |
| **Example** | <pre><code>// const bad = addMeters(distance, time);
//            ^ Type error: Seconds is not assignable to Meters</code></pre> |

---

## Card 18

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Capability-Based Design |
| **Description** | Pass explicit capabilities (permissions/operations) into functions instead of relying on ambient global authority. |
| **Example** | `function registerUser(sendEmail: SendEmail, user: User)` |
|**Level** | Advanced |
| **When to Apply** | System-level, API design |
| **Learn More** | https://fsharpforfunandprofit.com/posts/dependencies-3/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Ambient Authority |
| **Description** | Code can perform hidden side effects because it can reach global DB/fs/network clients directly. You can also require a lot of dependencies to child functions through Dependency Injection. |
| **Example** | A function that should only email users also mutates billing records. Also `function getUsers(fetch)` now requires all fucntions that use `getUsers` to also supply `fetch` in their dependencies, even if they don't ever actually use the `fetch`. |

---

## Card 19 (REVISED)

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Effect Typing (Function Coloring) |
| **Description** | Make effects explicit in signatures (`Async`, `IO`, `DB`, `Network`) so effectful code is visible, composable, and can reduce unit testing using spies. |
| **Example** | `type TaskResult<A, E> = () => Promise<{ tag: 'Ok', value: A } \| { tag: 'Err', error: E }>` |
|**Level** | Advanced |
| **When to Apply** | Function-level, API design |
| **When NOT to Apply** | Tiny scripts where effect boundaries are obvious and short-lived. |
| **Runtime Pair** | Structured effect wrappers (`Task`, `ReaderTaskEither`, service interfaces). |
| **Learn More** | https://lackofimagination.org/2025/11/managing-side-effects-a-javascript-effect-system-in-30-lines-or-less/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Hidden Effects / Function Coloring |
| **Description** | A function starts pure, then calls async/IO code, and effect requirements leak upward unexpectedly. |
| **Example** | `getDisplayName()` becomes `async getDisplayName()` after one Promise call |

---

## Card 21

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Error Algebra "Errors as Values" |
| **Description** | Model domain errors as discriminated unions with explicit recovery meaning (retry, fix input, escalate, abort). |
| **Example** | `type CheckoutError = { tag: 'CardDeclined' } \| { tag: 'InventoryChanged' } \| { tag: 'TransientNetwork'; retryAfterMs: number }` |
|**Level** | Intermediate |
| **Edge Color** | Teal / Brown |
| **When to Apply** | API design, System-level, Discriminated Unions |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Stringly-Typed Failures |
| **Description** | Generic errors hide cause and recovery strategy, so callers guess what to do next. |
| **Example** | `throw new Error("checkout failed")` |

---

## Card 22

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Schema/Codec Single Source of Truth |
| **Description** | Define runtime schema once and derive parser, encoder, and static types from it to avoid drift. |
| **Example** | `const UserSchema = z.object({ id: z.string(), email: z.string().email() }); type User = z.infer<typeof UserSchema>` |
|**Level** | Beginner |
| **When to Apply** | Boundaries/I/O, Module-level |
| **Learn More** | https://zod.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Schema Drift |
| **Description** | Runtime validators, TypeScript types, and API docs diverge over time and create subtle bugs. |
| **Example** | Type says `email?`, parser requires `email` |

---

## Card 24

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Property-Based Testing from Types |
| **Description** | Generate many test cases from typed generators and assert invariants instead of relying only on hand-picked examples. |
| **Example** | `fc.assert(fc.property(arbUser, u => deepEqual(decode(encode(u)), u)))` |
|**Level** | Intermediate |
| **When to Apply** | Function-level, Domain modeling |
| **Learn More** | https://fast-check.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Example Blind Spots |
| **Description** | Small example-based tests miss edge cases that violate invariants in production. |
| **Example** | Tests pass for ASCII names but fail for Unicode input |

---

## Card 28

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Option / Maybe Type |
| **Description** | Represent absence explicitly with `Some`/`None` instead of `null` or `undefined`. |
| **Example** | `type Option<T> = { tag: 'Some', value: T } \| { tag: 'None' }` |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, Function-level |
| **When NOT to Apply** | When absence needs rich failure context; use `Result` for error details. |
| **Runtime Pair** | Helpers like `map` and `getWithDefault` to avoid null checks. |
| **Learn More** | https://gcanti.github.io/fp-ts/modules/Option.ts.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Null Pointer Branching |
| **Description** | `null`/`undefined` checks spread across code and are easy to forget in one branch. |
| **Example** | `user.address.city` throws when `address` is `undefined` |

---

## Card 29

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Product Types (Records) |
| **Description** | Model data that must exist together with named fields (`AND` composition). |
| **Example** | `type Money = { amount: number, currency: Currency }` |
|**Level** | Beginner |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **When NOT to Apply** | When values are alternatives, not combinations; use unions for `OR` cases. |
| **Runtime Pair** | Structural validation for required fields at boundaries. |
| **Learn More** | https://en.wikipedia.org/wiki/Algebraic_data_type |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Positional and Parallel Data Bugs |
| **Description** | Loosely related values are passed separately, reordered accidentally, or updated inconsistently. |
| **Example** | `charge(100, "USD")` vs `charge("USD", 100)` |

---

## Card 30

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Unknown at Boundaries |
| **Description** | Accept external input as `unknown`, then parse/narrow once into trusted domain types. |
| **Example** | `function parseUser(input: unknown): Result<User, ParseError>` |
|**Level** | Beginner |
| **When to Apply** | Boundaries/I/O |
| **When NOT to Apply** | Internal code paths where values are already trusted domain types. |
| **Runtime Pair** | Schema validators/codecs (Zod, io-ts, valibot). |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/functions.html#unknown |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Any-Typed Boundary Leaks |
| **Description** | Untrusted inputs enter the core system without parsing, causing late runtime failures. |
| **Example** | API payload typed as `any` reaches business logic and crashes on missing fields |

---

## Card 32

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Readonly by Default |
| **Description** | Prefer immutable shapes so mutation is explicit and local, reducing aliasing bugs. |
| **Example** | `type User = { readonly id: UserId, readonly email: Email }` |
|**Level** | Intermediate |
| **When to Apply** | Module-level, Function-level |
| **When NOT to Apply** | Hot paths where copying costs dominate and mutability is intentionally encapsulated. |
| **Runtime Pair** | Copy-on-write updates and immutable helpers. |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/objects.html#readonly-properties |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Incidental Mutation |
| **Description** | Shared object references are mutated unexpectedly, causing non-local bugs and flaky behavior. |
| **Example** | A helper function mutates `user.roles` and breaks permission checks elsewhere |

---

## Card 37

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Railway-Oriented Programming |
| **Description** | Compose `Result`/`Maybe` steps left-to-right; stop at first failure, continue on success. |
| **Example** | `parse(input).andThen(validate).andThen(save).andThen(sendWelcomeEmail)` |
|**Level** | Intermediate |
| **When to Apply** | Function-level, API design |
| **When NOT to Apply** | When you need all validation errors at once (not first-error wins). |
| **Runtime Pair** | `neverthrow` `Result/ResultAsync` with `.andThen`, `.map`, `.mapErr`. |
| **Learn More** | https://fsharpforfunandprofit.com/rop/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Nested Error Handling |
| **Description** | `if/else` + `try/catch` chains become hard to read and easy to break as steps grow. |
| **Example** | `if (ok1) { if (ok2) { try { ... } catch { ... } } else { ... } } else { ... }` |

---
