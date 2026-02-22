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
| **Description** | Transform untyped data into typed structures at system boundaries. Once parsed, trust the types internally. |
| **Example** | `const user = UserSchema.parse(json)` at the boundary, then `user.name` and `user.email` are guaranteed valid everywhere |
| **Color** | Green (Beginner) |
| **Edge Color** | Blue |
| **When to Apply** | Boundaries/I/O |
| **Concept Type** | Principle |
| **Learn More** | https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Shotgun Parsing |
| **Description** | Validation logic scattered throughout codebase, checking the same fields repeatedly in different places, inconsistent handling of invalid data. |
| **Example** | `if (json.name && typeof json.name === 'string' && json.email && json.email.includes('@')) { ... }` repeated in 5 different files |

---

## Card 2

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Make Impossible States Impossible |
| **Description** | Design types so invalid states cannot be represented. Use discriminated unions to make each state explicit. |
| **Example** | `type Request = { tag: 'loading' } \| { tag: 'success', data: User } \| { tag: 'error', error: string }` |
| **Color** | Green (Beginner) |
| **Edge Color** | Purple / Orange |
| **When to Apply** | Domain modeling, State machines |
| **Concept Type** | Principle |
| **Learn More** | https://www.youtube.com/watch?v=IcgmSRJHu_8 |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Invalid State Combinations |
| **Description** | Optional fields with implicit relationships where certain combinations are meaningless or contradictory. |
| **Example** | `type Request = { loading?: boolean, data?: User, error?: string }` — what does `{ loading: true, data: someUser, error: "failed" }` mean? |

---

## Card 3

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Discriminated Unions |
| **Description** | Use a `tag` field to distinguish between variants of a type. Enables exhaustive pattern matching. |
| **Example** | `type Result<T, E> = { tag: 'Ok', value: T } \| { tag: 'Err', error: E }` |
| **Color** | Green (Beginner) |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **Concept Type** | Pattern |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Boolean Blindness |
| **Description** | Using booleans or strings to represent states loses information and requires runtime checks to determine meaning. |
| **Example** | `function process(success: boolean, data?: User, error?: string)` — caller must remember what `true` means |

---

## Card 4

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Exhaustiveness Checking |
| **Description** | Compiler ensures all union cases are handled. Add new variant and compiler shows every place to update. |
| **Example** | `const _exhaustive: never = result` in default case — compile error if case is unhandled |
| **Color** | Green (Beginner) |
| **Edge Color** | Purple / Orange |
| **When to Apply** | Domain modeling, State machines |
| **Concept Type** | Technique |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#exhaustiveness-checking |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Forgotten Case Bugs |
| **Description** | Adding a new enum value or status and missing handlers in switch statements, discovered only at runtime. |
| **Example** | `switch (status) { case 'pending': ...; case 'complete': ... }` — added `'cancelled'` but forgot to handle it |

---

## Card 5

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Result Types |
| **Description** | Return success or failure explicitly in the type. Caller must handle both cases. |
| **Example** | `function getUser(id: string): Result<User, NotFoundError \| ValidationError>` |
| **Color** | Green (Beginner) |
| **Edge Color** | Blue / Teal |
| **When to Apply** | Boundaries/I/O, API design |
| **Concept Type** | Pattern |
| **Learn More** | https://github.com/supermacro/neverthrow |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Exception Blindness |
| **Description** | `try/catch` doesn't tell you what can fail from the type signature. Exceptions bypass the type system entirely. |
| **Example** | `function getUser(id: string): User` — throws `NotFoundError`? `ValidationError`? `DatabaseError`? Who knows! |

---

## Card 6

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Branded Types |
| **Description** | Distinguish semantically different values that share the same primitive type. |
| **Example** | `type UserId = string & { _brand: 'UserId' }` and `type ProductId = string & { _brand: 'ProductId' }` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **Concept Type** | Technique |
| **Learn More** | https://egghead.io/blog/using-branded-types-in-typescript |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Primitive Mixups |
| **Description** | Accidentally passing one ID where another is expected. Compiler can't distinguish between two `string` values. |
| **Example** | `getProduct(userId)` compiles fine but fails at runtime — both are just `string` |

---

## Card 7

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Opaque Types |
| **Description** | Hide internal representation, force construction through validated factory function. |
| **Example** | `type Email = ...` (internal) with only `createEmail(s: string): Email \| null` exported |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple / Pink |
| **When to Apply** | Domain modeling, Module-level |
| **Concept Type** | Pattern |
| **Learn More** | https://michalzalecki.com/nominal-typing-in-typescript/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Accidental Forgery |
| **Description** | Creating invalid values directly by bypassing validation, since the type is just a primitive alias. |
| **Example** | `const email: Email = "not-an-email"` — compiles if `Email` is just `type Email = string` |

---

## Card 8

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Refinement Types |
| **Description** | Narrow primitives to constrained subsets with semantic meaning. |
| **Example** | `type PositiveNumber = number & { _brand: 'positive' }` with smart constructor |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple / Cyan |
| **When to Apply** | Domain modeling, Value-level |
| **Concept Type** | Pattern |
| **Learn More** | https://zod.dev/?id=refine |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Primitive Obsession |
| **Description** | Using raw primitives when only a subset of values is valid, requiring defensive checks everywhere. |
| **Example** | `function divide(a: number, b: number)` — must check `b !== 0` inside, caller can pass anything |

---

## Card 9

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | NonEmpty Collections |
| **Description** | Type that guarantees at least one element exists. |
| **Example** | `type NonEmptyArray<T> = [T, ...T[]]` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **Concept Type** | Pattern |
| **Learn More** | https://gcanti.github.io/fp-ts/modules/NonEmptyArray.ts.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Empty Collection Crashes |
| **Description** | Accessing first element or reducing without initial value on potentially empty arrays. |
| **Example** | `const first = items[0]` — undefined if empty; `items.reduce((a, b) => a + b)` — throws if empty |

---

## Card 10

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Total Functions |
| **Description** | Function that returns a value for every possible input. No exceptions, no undefined behavior. |
| **Example** | `divide(a: number, b: NonZeroNumber): number` — impossible to pass zero |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Gray |
| **When to Apply** | Function-level |
| **Concept Type** | Principle |
| **Learn More** | https://wiki.haskell.org/Partial_functions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Partial Functions |
| **Description** | Functions that throw or crash for some inputs, with hidden failure modes not visible in the type signature. |
| **Example** | `function divide(a: number, b: number): number { return a / b }` — returns `Infinity` or `NaN` for edge cases |

---

## Card 11

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Smart Constructors |
| **Description** | Factory functions that validate and return `Result` or `Option` instead of throwing. |
| **Example** | `const email = Email.create(input) // Result<Email, InvalidEmailError>` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **Concept Type** | Technique |
| **Learn More** | https://wiki.haskell.org/Smart_constructors |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Constructor Exceptions |
| **Description** | Constructors that throw on invalid input — caller doesn't know from type signature that it can fail. |
| **Example** | `new Email("invalid")` throws — but `new Email(input)` looks safe in the code |

---

## Card 12

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Phantom Types |
| **Description** | Type parameters that exist only at compile time to track state or constraints. Zero runtime cost. |
| **Example** | `type Email<State> = { value: string }` — `Email<Validated>` vs `Email<Unvalidated>` |
| **Color** | Red (Advanced) |
| **Edge Color** | Orange |
| **When to Apply** | State machines |
| **Concept Type** | Technique |
| **Learn More** | https://www.learninghaskell.com/phantom-types |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Runtime State Checks |
| **Description** | Manually tracking state with booleans or flags, requiring `if (isValidated)` checks scattered throughout code. |
| **Example** | `if (email.isValidated) { sendEmail(email) }` — easy to forget the check |

---

## Card 13

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Anti-Corruption Layer |
| **Description** | Translate external/legacy types into your domain types at the boundary. Keep external shapes outside. |
| **Example** | `const user = toUser(apiResponse)` — API shape stays at edge, domain shape inside |
| **Color** | Red (Advanced) |
| **Edge Color** | Blue / Brown |
| **When to Apply** | Boundaries/I/O, System-level |
| **Concept Type** | Pattern |
| **Learn More** | https://docs.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Leaky Abstractions |
| **Description** | External API shapes spreading through codebase, coupling your domain to third-party structures. |
| **Example** | `function processUser(user: StripeCustomerResponse)` used deep in business logic — Stripe changes, everything breaks |

---

## Card 14

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Type-Safe Builder |
| **Description** | Use phantom types to enforce required steps in builder pattern at compile time. |
| **Example** | `RequestBuilder<{ url: Set, method: Unset }>` — `.build()` only available when all required fields set |
| **Color** | Red (Advanced) |
| **Edge Color** | Teal |
| **When to Apply** | API design |
| **Concept Type** | Technique |
| **Learn More** | https://blog.rust-lang.org/2015/05/11/traits.html#the-builder-pattern |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Runtime Builder Errors |
| **Description** | Forgetting required fields in builder pattern, discovered only when `.build()` throws at runtime. |
| **Example** | `new RequestBuilder().setHeaders({...}).build()` — forgot URL, throws "URL is required" |


Below are new cards (continuing from Card 14). I skipped **Smart Constructors** and **Refinement Types** since you already have them.

---

## Card 15

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Typestate |
| **Description** | Encode lifecycle states in types so only valid transitions are possible at compile time. |
| **Example** | `type Draft = { tag: 'Draft' }; type Submitted = { tag: 'Submitted' }; function submit(d: Draft): Submitted` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Orange |
| **When to Apply** | State machines |
| **Concept Type** | Pattern |
| **Learn More** | https://en.wikipedia.org/wiki/Typestate_analysis |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Illegal State Transitions |
| **Description** | Operations run in the wrong order because lifecycle rules are only enforced by runtime checks. |
| **Example** | `approve(order)` compiles even when `order` is still draft |

---

## Card 16

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Indexed Types |
| **Description** | Carry useful facts in type parameters (length, state, currency, etc.) so operations preserve invariants. |
| **Example** | `type Vec<T, N extends number> = { values: T[]; length: N }; zip<A, B, N>(a: Vec<A, N>, b: Vec<B, N>): Vec<[A, B], N>` |
| **Color** | Red (Advanced) |
| **Edge Color** | Purple / Cyan |
| **When to Apply** | Domain modeling, Value-level |
| **Concept Type** | Technique |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/generics.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Lost Invariants |
| **Description** | Important relationships between values are implicit and can be broken silently. |
| **Example** | `zip([1,2,3], ['a'])` truncates unexpectedly |

---

## Card 17

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Units-of-Measure Types |
| **Description** | Encode physical/business units in types to prevent invalid arithmetic across incompatible dimensions. |
| **Example** | `type Meters = number & { _unit: 'm' }; type Seconds = number & { _unit: 's' }` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Cyan |
| **When to Apply** | Value-level |
| **Concept Type** | Pattern |
| **Learn More** | https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Unit Mixups |
| **Description** | Values with different units are treated as plain numbers and combined incorrectly. |
| **Example** | Adding miles to kilometers without conversion |

---

## Card 18

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Capability-Based Design |
| **Description** | Pass explicit capabilities (permissions/operations) into functions instead of relying on ambient global authority. |
| **Example** | `function registerUser(sendEmail: SendEmail, user: User)` |
| **Color** | Red (Advanced) |
| **Edge Color** | Brown / Teal |
| **When to Apply** | System-level, API design |
| **Concept Type** | Principle |
| **Learn More** | https://en.wikipedia.org/wiki/Object-capability_model |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Ambient Authority |
| **Description** | Code can perform hidden side effects because it can reach global DB/fs/network clients directly. |
| **Example** | A function that should only email users also mutates billing records |

---

## Card 19 (REVISED)

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Effect Typing (Function Coloring) |
| **Description** | Make effects explicit in signatures (`Async`, `IO`, `DB`, `Network`) so effectful code is visible and composable. |
| **Example** | `type TaskResult<A, E> = () => Promise<{ tag: 'Ok', value: A } \| { tag: 'Err', error: E }>` |
| **Color** | Red (Advanced) |
| **Edge Color** | Gray / Teal |
| **When to Apply** | Function-level, API design |
| **When NOT to Apply** | Tiny scripts where effect boundaries are obvious and short-lived. |
| **Runtime Pair** | Structured effect wrappers (`Task`, `ReaderTaskEither`, service interfaces). |
| **Concept Type** | Principle |
| **Learn More** | https://en.wikipedia.org/wiki/Effect_system |

---

## Card 20

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Validation vs Computation Split |
| **Description** | Use accumulating validation for input errors, then use fail-fast `Result` for domain workflows. |
| **Example** | `SignupSchema.safeParse(raw)` for field errors, then `createUser(parsed.data): Result<User, DomainError>` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Blue / Gray |
| **When to Apply** | Boundaries/I/O, Function-level |
| **Concept Type** | Pattern |
| **Learn More** | https://fsharpforfunandprofit.com/posts/recipe-part2/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Conflated Error Handling |
| **Description** | Same mechanism handles user input issues and domain failures, causing poor UX and confusing control flow. |
| **Example** | Form submit returns only first validation error and hides the rest |

---

## Card 21

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Error Algebra |
| **Description** | Model domain errors as discriminated unions with explicit recovery meaning (retry, fix input, escalate, abort). |
| **Example** | `type CheckoutError = { tag: 'CardDeclined' } \| { tag: 'InventoryChanged' } \| { tag: 'TransientNetwork'; retryAfterMs: number }` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Teal / Brown |
| **When to Apply** | API design, System-level |
| **Concept Type** | Pattern |
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
| **Color** | Green (Beginner) |
| **Edge Color** | Blue / Pink |
| **When to Apply** | Boundaries/I/O, Module-level |
| **Concept Type** | Technique |
| **Learn More** | https://zod.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Schema Drift |
| **Description** | Runtime validators, TypeScript types, and API docs diverge over time and create subtle bugs. |
| **Example** | Type says `email?`, parser requires `email` |

---

## Card 23

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Lawful Abstractions |
| **Description** | Use abstractions with algebraic laws so composition is predictable and refactors are safer. |
| **Example** | `map(id, x) === x` and `map(f, map(g, x)) === map(x => f(g(x)), x)` |
| **Color** | Red (Advanced) |
| **Edge Color** | Gray |
| **When to Apply** | Function-level |
| **Concept Type** | Principle |
| **Learn More** | https://wiki.haskell.org/Typeclassopedia |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Unreliable Composition |
| **Description** | Custom abstractions behave inconsistently, so combining operations introduces surprising behavior. |
| **Example** | A custom `map` mutates data or drops elements |

---

## Card 24

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Property-Based Testing from Types |
| **Description** | Generate many test cases from typed generators and assert invariants instead of relying only on hand-picked examples. |
| **Example** | `fc.assert(fc.property(arbUser, u => deepEqual(decode(encode(u)), u)))` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Gray / Purple |
| **When to Apply** | Function-level, Domain modeling |
| **Concept Type** | Technique |
| **Learn More** | https://fast-check.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Example Blind Spots |
| **Description** | Small example-based tests miss edge cases that violate invariants in production. |
| **Example** | Tests pass for ASCII names but fail for Unicode input |

---

## Card 25

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Temporal Modeling Types |
| **Description** | Distinguish machine instants, calendar dates, and zoned local times with separate types. |
| **Example** | `Temporal.Instant` vs `Temporal.PlainDate` vs `Temporal.ZonedDateTime` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple / Blue |
| **When to Apply** | Domain modeling, Boundaries/I/O |
| **Concept Type** | Pattern |
| **Learn More** | https://tc39.es/proposal-temporal/docs/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Timezone Ambiguity |
| **Description** | Treating all date/time values as the same type causes off-by-hours/day bugs across locales. |
| **Example** | Storing `"2026-03-10 09:00"` without timezone and sending at wrong local time |

---

## Card 26

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Versioned Domain Types |
| **Description** | Represent schema/domain versions explicitly and migrate with typed translators instead of ad-hoc conditionals. |
| **Example** | `type UserEvent = UserCreatedV1 \| UserCreatedV2; function toV2(v1: UserCreatedV1): UserCreatedV2` |
| **Color** | Red (Advanced) |
| **Edge Color** | Blue / Brown |
| **When to Apply** | Boundaries/I/O, System-level |
| **Concept Type** | Pattern |
| **Learn More** | https://martinfowler.com/bliki/ParallelChange.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Version Drift |
| **Description** | Old and new payloads are handled inconsistently across services, causing brittle compatibility logic. |
| **Example** | `if (payload.version === 1) ... else ...` duplicated in many modules |

---

## Card 27

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Compiler Strictness as Practice |
| **Description** | Treat strict compiler flags as design constraints so weak assumptions are rejected early. |
| **Example** | `\"strict\": true, \"noUncheckedIndexedAccess\": true, \"exactOptionalPropertyTypes\": true` |
| **Color** | Green (Beginner) |
| **Edge Color** | Pink / Gray |
| **When to Apply** | Module-level, Function-level |
| **Concept Type** | Practice |
| **Learn More** | https://www.typescriptlang.org/tsconfig#strict |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Silent Unsoundness |
| **Description** | Looser compiler settings allow unsafe assumptions that surface later as runtime bugs. |
| **Example** | `users[id].name` compiles, but `users[id]` can be `undefined` |
## Card 28

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Option / Maybe Type |
| **Description** | Represent absence explicitly with `Some`/`None` instead of `null` or `undefined`. |
| **Example** | `type Option<T> = { tag: 'Some', value: T } \| { tag: 'None' }` |
| **Color** | Green (Beginner) |
| **Edge Color** | Purple / Gray |
| **When to Apply** | Domain modeling, Function-level |
| **When NOT to Apply** | When absence needs rich failure context; use `Result` for error details. |
| **Runtime Pair** | Helpers like `map`, `flatMap`, `getOrElse` to avoid null checks. |
| **Concept Type** | Pattern |
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
| **Color** | Green (Beginner) |
| **Edge Color** | Purple |
| **When to Apply** | Domain modeling |
| **When NOT to Apply** | When values are alternatives, not combinations; use unions for `OR` cases. |
| **Runtime Pair** | Structural validation for required fields at boundaries. |
| **Concept Type** | Pattern |
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
| **Color** | Green (Beginner) |
| **Edge Color** | Blue |
| **When to Apply** | Boundaries/I/O |
| **When NOT to Apply** | Internal code paths where values are already trusted domain types. |
| **Runtime Pair** | Schema validators/codecs (Zod, io-ts, valibot). |
| **Concept Type** | Technique |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/functions.html#unknown |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Any-Typed Boundary Leaks |
| **Description** | Untrusted inputs enter the core system without parsing, causing late runtime failures. |
| **Example** | API payload typed as `any` reaches business logic and crashes on missing fields |

---

## Card 31

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Type Predicates and Assertion Functions |
| **Description** | Centralize narrowing logic in reusable guards so callers gain precise types after checks. |
| **Example** | `function isEmail(x: unknown): x is Email { ... }` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Gray |
| **When to Apply** | Function-level |
| **When NOT to Apply** | If a schema parser already does full validation at boundary. |
| **Runtime Pair** | Shared guard/assert modules plus exhaustive unit tests for guards. |
| **Concept Type** | Technique |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Ad-Hoc Narrowing |
| **Description** | Inline checks diverge over time, yielding inconsistent behavior and weak inferred types. |
| **Example** | Three different `isUser` checks in three files with different required fields |

---

## Card 32

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Readonly by Default |
| **Description** | Prefer immutable shapes so mutation is explicit and local, reducing aliasing bugs. |
| **Example** | `type User = { readonly id: UserId, readonly email: Email }` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Pink / Gray |
| **When to Apply** | Module-level, Function-level |
| **When NOT to Apply** | Hot paths where copying costs dominate and mutability is intentionally encapsulated. |
| **Runtime Pair** | Copy-on-write updates and immutable helpers. |
| **Concept Type** | Practice |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/objects.html#readonly-properties |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Incidental Mutation |
| **Description** | Shared object references are mutated unexpectedly, causing non-local bugs and flaky behavior. |
| **Example** | A helper function mutates `user.roles` and breaks permission checks elsewhere |

---

## Card 33

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Type-Level Tests |
| **Description** | Add compile-time tests that lock API type behavior (`inference`, `assignability`, `errors`). |
| **Example** | `expectType<UserId>(createUserId("u_123"))` and `// @ts-expect-error createUserId(123)` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Pink / Teal |
| **When to Apply** | Module-level, API design |
| **When NOT to Apply** | Throwaway prototypes where API stability is not a goal. |
| **Runtime Pair** | `tsd`, `dtslint`, or `vitest` + `expectTypeOf`. |
| **Concept Type** | Technique |
| **Learn More** | https://github.com/SamVerschueren/tsd |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Silent Type Regressions |
| **Description** | Refactors preserve runtime behavior but accidentally widen or break type contracts. |
| **Example** | A helper returns `string` instead of `UserId`, and misuse spreads |

---

## Card 34

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Nominal Type Toolbox |
| **Description** | Use a progression: `Branded` for distinction, `Opaque` for encapsulation, `Refinement` for constraints, `Phantom` for state/index tracking. |
| **Example** | `UserId` (brand), `Email` (opaque + smart constructor), `NonZero` (refinement), `Order<Submitted>` (phantom) |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Purple / Pink / Orange / Cyan |
| **When to Apply** | Domain modeling, Module-level, State machines, Value-level |
| **When NOT to Apply** | When the domain does not justify extra type ceremony. |
| **Runtime Pair** | Smart constructors and explicit conversion functions at boundaries. |
| **Concept Type** | Guide |
| **Learn More** | https://michalzalecki.com/nominal-typing-in-typescript/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Nominal Modeling Confusion |
| **Description** | Teams mix branding, opacity, and phantom techniques inconsistently, causing accidental complexity. |
| **Example** | One module uses raw `string` IDs while another uses opaque IDs, forcing unsafe casts |

---

## Card 35

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Boundary Type Stack |
| **Description** | Treat boundaries as a stack: `Unknown -> Parse/Codec -> Domain Type -> Anti-Corruption Mapping`. |
| **Example** | `rawJson (unknown) -> ApiUserSchema.parse -> ApiUser -> toDomainUser -> User` |
| **Color** | Red (Advanced) |
| **Edge Color** | Blue / Pink / Brown |
| **When to Apply** | Boundaries/I/O, Module-level, System-level |
| **When NOT to Apply** | Tiny apps with one trusted data source and minimal integration risk. |
| **Runtime Pair** | Shared codec package plus boundary mappers per integration. |
| **Concept Type** | Strategy |
| **Learn More** | https://docs.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Boundary Drift |
| **Description** | External payloads, parser logic, and domain shapes drift independently and break in subtle ways. |
| **Example** | API adds `middle_name`; parser accepts it, but domain mapper silently drops required semantics |

---

## Card 36

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Typestate Builder |
| **Description** | Merge builder ergonomics with typestate constraints so required steps are enforced before `build`. |
| **Example** | `RequestBuilder<{ url: Set, method: Set, body: Optional }>.build()` |
| **Color** | Red (Advanced) |
| **Edge Color** | Orange / Teal |
| **When to Apply** | State machines, API design |
| **When NOT to Apply** | Simple constructors with few required fields. |
| **Runtime Pair** | Minimal runtime assertions for cross-field invariants not expressible in types. |
| **Concept Type** | Technique |
| **Learn More** | https://en.wikipedia.org/wiki/Typestate_analysis |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Runtime Builder Failures |
| **Description** | Missing required steps are discovered only at runtime when `build()` throws. |
| **Example** | `new RequestBuilder().setHeaders(h).build()` fails because URL was never set |

---

## Card 37

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Railway-Oriented Programming |
| **Description** | Compose `Result`/`Maybe` steps left-to-right; stop at first failure, continue on success. |
| **Example** | `parse(input).andThen(validate).andThen(save).andThen(sendWelcomeEmail)` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Gray / Teal |
| **When to Apply** | Function-level, API design |
| **When NOT to Apply** | When you need all validation errors at once (not first-error wins). |
| **Runtime Pair** | `neverthrow` `Result/ResultAsync` with `.andThen`, `.map`, `.mapErr`. |
| **Concept Type** | Pattern |
| **Learn More** | https://fsharpforfunandprofit.com/rop/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Nested Error Handling |
| **Description** | `if/else` + `try/catch` chains become hard to read and easy to break as steps grow. |
| **Example** | `if (ok1) { if (ok2) { try { ... } catch { ... } } else { ... } } else { ... }` |

---

## Card 38

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Validation Pipeline (Error Accumulation) |
| **Description** | Run independent validators and collect all failures, returning valid output only when all pass. |
| **Example** | `Result.combineWithAllErrors([validateName(f.name), validateEmail(f.email), validatePassword(f.password)]).map(([name,email,password]) => ({ name, email, password }))` |
| **Color** | Yellow (Intermediate) |
| **Edge Color** | Blue / Gray |
| **When to Apply** | Boundaries/I/O, Function-level |
| **When NOT to Apply** | When later steps depend on earlier successful outputs; use Railway there. |
| **Runtime Pair** | `ValidationError[]` + combinators like `combineWithAllErrors`. |
| **Concept Type** | Pattern |
| **Learn More** | https://github.com/supermacro/neverthrow |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | First-Error-Only UX |
| **Description** | Users fix one form error at a time because validation stops too early. |
| **Example** | Submit shows `"Email invalid"`; after fix, next submit shows `"Password too short"`; repeat. |