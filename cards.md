# Type Driven Development Cards

---

## Card 1

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Parse, Don't Validate |
| **Description** | Transform untyped data into typed structures at system boundaries. Once parsed, trust the types in the rest of your code. |
| **Visual Metaphor** | Full Trust, no need to validate credentials, unconditional love. Once you make it through security, you have free reign, and everyone trusts you. There are no multiple security gates; just a simple badge swipe, and you're in. This makes everyone's interaction with you super easy; you're in the club, they trust you, and it puts everyone at ease. |
| **Example** | `const user = ZodUserSchema.parse(json)` at the boundary, then `user.name` and `user.email` are guaranteed valid everywhere |
| **Level** | Beginner |
| **When to Apply** | Boundaries/IO |
| **Learn More** | https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Shotgun Parsing |
| **Description** | Validation logic scattered throughout codebase, checking the same fields repeatedly in different places, only checking the fields a function/method needs, inconsistent handling of invalid data. |
| **Visual Metaphor** | Paranoid. Many parts could look good yet 1 part could be broken. When something is "off", you don't verify anything else, just rejection. One wrong piece of data, and boom, entire program crashes. Every single step is this terrifying, check each section before you walk. Like walking on a thinly frozen lake or one of those rickety rope bridges in Indian Jones and The Temple of Doom. |
| **Example** | `if (json.name && typeof json.name !== 'string') { throw new Error('Name is needs to be a string') }` repeated in 5 different files. What about `json.email` or other fields? At any point of the code, bad data on just 1 field can crash the application. |

---

## Card 2

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Discriminated Unions |
| **Description** | Use a `tag` field to distinguish between variants of a type. Enables exhaustive pattern matching. |
| **Visual Metaphor** | This or that. Or. There is a set of things, but only 1 can be choosen. Like a dog breed; you can pick Lab, or Sheltie, or Mutt... but you can only pick 1. The Set part is important too; like rainbow colors that you choose from a color swatch in Adobe Photoshop; so many choices, but you can only pick 1. However, all of those choices ARE the set you can choose from. A row of weapons, like what Pow Mai had in Kill Bill or Neo from the Matrix; you can carry all of those weapons, but only use 1 at a time. NOTE: Out of all cards in the deck, this is the most important one, and Record is number 2. |
| **Example** | `type Result<T, E> = { tag: 'Ok', value: T } \| { tag: 'Err', error: E }` |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, State Machines |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#discriminated-unions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Boolean Blindness |
| **Description** | Using booleans or strings to represent states loses information and requires runtime checks to determine meaning. |
| **Visual Metaphor** | Like a sticky note you left for yourself, but it's vague or doesn't describe exacly why you left the note. Like "Remember to do the thing"... what thing? Missing context. You call FedEx/UPS "Did you ship my package?" "No". "Uh... ok, what's the status of it? Waiting for label... waiting for pickup... shipped... in customs... in cross dock... in a plane... on truck... at my doorstep???" "No" "Dude, that's not helpful... what does 'no' mean?" |
| **Example** | `process(true, {}, undefined)` — caller must remember what `true` means, often having to read the function/method contents to understand. |

---

## Card 3

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Make Impossible States Impossible |
| **Description** | Design types so invalid states cannot be represented. Use discriminated unions to make each state explicit. |
| **Visual Metaphor** | Bad things can't happen if you only allow success to be the only path available. Instead of "I could win or fail" intsead it's "I can win or I can learn and retry". You could carry your coffee cup out the door and it may spill as you open the door, or spill while not fitting in the car's cup holder... OR you can get a waterproof coffee mug with a waterproof lid that fits perfet in the cupholder. The choices you have are obvious, and expected. Pro atheletes visualize themselves being successful, then go do it. You can't screw up if you're awesome. |
| **Example** | `type Request = { tag: 'loading' } \| { tag: 'success', data: User } \| { tag: 'error', error: string }` |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, State machines |
| **Learn More** | https://www.youtube.com/watch?v=IcgmSRJHu_8 |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Invalid State Combinations |
| **Description** | Optional fields with implicit relationships where certain combinations are meaningless or contradictory. |
| **Visual Metaphor** | Imagine getting an empty box from FedEx, "Yes, I got my pacakge, but... the box didn't have the clothes I ordered inside it?" In America, they have these hexagon red signs that say "STOP". If they were green, but still said "STOP", Americans would probably crash into each other. In America, we have stop lights that go from red (stop), yellow (prepare to stop), and green (go). If it was red and green at the same time... I'd have no idea what to do. I'd probably try to go, but... only if others were stopped maybe? |
| **Example** | `type Request = { loading: boolean, data?: User, error?: string }` — what does `{ loading: true, data: someUser, error: "failed" }` mean? |

---

## Card 4

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Exhaustiveness Checking |
| **Description** | Compiler ensures all union cases are handled. Add new variant and compiler shows every place to update. |
| **Visual Metaphor** | You never forget anything. If you have a routine that requires 9 steps, you know all are done. If you have a pre-flight check, all steps are done. Your bug out bag has all that's needed for you to leave the house immediately in an emergency. Your fallout shelter has all you need to survive for 10 years. If you're a detective, every possible lead is followed up on. |
| **Example** | `switch(request.tag) { case 'loading': ... case 'success': ... }` Compiler will tell you that you forgot the 'error' case. Also, you don't need a `default` case. |
|**Level** | Beginner |
| **When to Apply** | Domain modeling, State machines |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#exhaustiveness-checking |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Forgotten Case Bugs |
| **Description** | Adding a new string status and missing handlers in switch statements, discovered only at runtime. |
| **Visual Metaphor** | You left the house with your wallet, phone, purse, laptop, jacket, but forget your keys. You did the pre-flight check, but didn't notice you're low on fuel. You backpack to go camping didn't have any freeze dried food. You bought groceries and got all the ingredients you need for soup, but forgot to get a can opener. |
| **Example** | `type Request = { status: string, data?: User, error?: string } switch (request.status) { case 'loading': ...; case 'success': ... }` — added `'cancelled'` but forgot to handle it. |

---

## Card 5

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Result Types |
| **Description** | Return success or failure explicitly in the type. Caller must handle both cases. |
| **Visual Metaphor** | The chef is out of your favorite Ramen, but has great katsu curry recommendation because she knows you like pork. If turning your car on doesn't work, you know you have a battery charger in the garage to jump start it. If you Doordash food but the restuarant is out of stock, you provided a backup dish. (I don't know why I keep thinking of food for this one). You can safely turn on the light without worry of overloading because you have a circuit breaker. You can handle failure, and are forced to vs. something bad happening and you can ignore it. You know things can possibly break, and you go in with the expetations it might (e.g. "expect the worst, hope for the best"). Bottom line, failure is a visible, possibility vs. ignoring it and just having faith everyone will magically work out. |
| **Example** | `function readFile(fileName: string): Result<File, NotFound \| NoPermission>` |
|**Level** | Beginner |
| **When to Apply** | Boundaries/I/O, API design |
| **Learn More** | https://github.com/supermacro/neverthrow |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Exception Blindness |
| **Description** | `try/catch` doesn't tell you what can fail from the type signature. Exceptions bypass the type system entirely. Error type also tells you how to recover if possible, e.g. `ValidationError`: user can fix input. `Throttled`: retry/backoff is valid. `Unknown`: unrecoverable here; escalate/fail fast. |
| **Visual Metaphor** | You know that scene in Star Wars where the Millenium Falcon can't go to Light Speed to escape and there's zero indication as to why and everyone gets all stressed out? You know those people who go camping with blanket and sneakers and it's like "Dude, what if it rains? Are you preprared at all?" Imagine someone texting you "I have a problem", but... then they don't respond. Do they need help now? Are they ok, just dealing with deciding what to watch on Netflix? You know when the power goes out... is it ever going to come back on? If so, when? Bottom line, you have to guess at what's wrong when something bad happens, often with no hint at what to try to fix the situation. |
| **Example** | `function getUser(id: string): User` — throws `NotFoundError`? `ValidationError`? `DatabaseError`? Who knows! Have to read the code and write unit tests in case code stops throwing error you may want to recover from. |

---

## Card 6

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Branded Types |
| **Description** | Distinguish semantically different values that share the same primitive type. |
| **Visual Metaphor** | You know how solidiers have a country flag on their uniform to differntiate between them? The uniforms may look similiar, but the flags help distinquish them despite them looking nearly identifical, it's a clear marker. Some animals in the wild are tagged so people know scientists are tracking them so to leave them alone. You can't easily tell 1 dolphin from another, but the electric fin collar indicates it is different than the others. |
| **Example** | `type UserID = string & { brand: 'UserID' }` and `type ProductID = string & { brand: 'ProductID' }` then create a value `const UserID = '123' as UserId` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://egghead.io/blog/using-branded-types-in-typescript |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Primitive Obsession |
| **Description** | Accidentally passing one ID where another is expected. Compiler can't distinguish between two `string` values. |
| **Visual Metaphor** | "I thought this was a water, but it was Perrier, blech!" I thought this was a Bell Pepper, but it was a Habanero! All these eggs looked good, but I cracked one open, and it was spoiled (... there's the food thing again). I saw a stack of shirts, all my size, grabbed one... and of course it was the one with a hole in it. |
| **Example** | Accidentally passing a `userID` to `getProduct(userID)` compiles fine but fails at runtime — both are just `string` |

---

## Card 7

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Opaque Types |
| **Description** | Hide internal representation, force construction through validated factory function. |
| **Visual Metaphor** | If you buy a brand new motorcycle from a reputable brand & dealer, it will work. If you go to the Passport office, you'll get your 1 year passport in a day, or your 5 year in a couple weeks. The key here is you have to go to specific place, or use a specific methodology to get good quality or a well know reason why you can't (e.g. can't afford a new bike, forgot your drivers license at home for the passport office). Another angle is Notaries; you need to have some official sign a document, else it isn't official. You have to go to some government agency to get a marriage license to make it legit. You buy jewerely from a reputable brand to ensure you don't get fake stones. You could mine them yourself, but then you'd have to learn gem cutting and ... that has a high cost of failure. |
| **Example** | `type ValidEmail = ...` (internal) with only `createEmail(s: string): ValidEmail \| undefined` exported |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling, Module-level |
| **Learn More** | https://michalzalecki.com/nominal-typing-in-typescript/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Accidental Forgery |
| **Description** | Creating invalid values directly by bypassing validation, since the type is just a primitive alias. |
| **Visual Metaphor** | I once saw a Kawasaki Ninja 400 for sale on Ali Express. The price was like $2,000 less than a new one (normally $5,000/18,000 PLN). The pictures were convincing, and I WAS tempted, but no way that was real. No way to return it either. Not using Opaque types results in fakes, disappointment, or well intended, but ended up doing the wrong thing. (More food) when kids make you a mud pie... or ... just cook for you in general, it's usually a disaster. Cute, but ... bad.   |
| **Example** | `const email: Email = "not-an-email"` — compiles if `Email` is just `type Email = string` |

---

## Card 8

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | NonEmpty Collections |
| **Description** | Type that guarantees at least one element exists in an Array. |
| **Visual Metaphor** | Her majesty will tell me when I go to the grocery store to buy her stuff; she'll send me a list. When I get the list, I notice we already have all the things she's asking me to buy. So I always end buying something for her ANYWAY because if she finds out I went out and didn't buy her something... that's no good. (Can't have an empty list, need to ensure always at least 1 item). Another example is when get invited to a friends/family's house for dinner. They say "You don't need to bring anything..." but her majesty and I bring something anyway, like at least 1 bottle of wine and some weird house warming gift. |
| **Example** | `type NonEmptyArray<T> = [T, ...T[]]` or `type AtLeast1Item<T> = { first: T, rest: T[] }` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://gcanti.github.io/fp-ts/modules/NonEmptyArray.ts.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Empty Collection Crashes |
| **Description** | Accessing first element or reducing without initial value on potentially empty arrays. |
| **Visual Metaphor** | You know how magicians pull a rabbit out of a hat? This would be you go in the hat... and what you thought was there ain't. You how you get a check back sometimes from companies (you overpaid or they give you a tax credit or whatever) and it's for a paltry amount... like 1 cent? Imagine getting one for $0 / 0zł. Like... thanks for the check, I guess? |
| **Example** | `const first = items[0]` — `undefined` if empty; `items.reduce((a, b) => a + b)` — throws if empty |

---

## Card 9

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Total Functions |
| **Description** | Function that returns a value for every possible input. No exceptions, no undefined behavior. |
| **Visual Metaphor** | You know how a Mac "always works" and a PC "sometimes works"? A lamen would look at both laptops and go "Yeah... they're computers..." but we know better. Need to put it to sleep, then open it again? Works. Need to print something? Works. Need wifi? Works. Tether to your phone? Works. Another would be "any" Honda. Cold? Hot? Starts up. Haven't changed oil in 20 years? Starts anyway. Crashed? Still driveable. Another example is the water filter; whether the bacterial rivers of North America, the virus ones in South America, or just a mud filled pond... you'll predictably always get fresh water. |
| **Example** | `divide(a: number, b: PositiveNumber): number` — impossible to pass zero |
|**Level** | Intermediate |
| **When to Apply** | Function-level |
| **Learn More** | https://wiki.haskell.org/Partial_functions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Partial Functions |
| **Description** | Functions that throw or crash for some inputs, with hidden failure modes not visible in the type signature. |
| **Visual Metaphor** | I always think of those fast food commercials / photos where they show this amazing burger, and people take a picture of the real thing and it's just NOT even remotely similiar. There's this vibe of "fake" or "exagerating your capabilities". Yes, in normal circumstances, Green Arrow could fight off most villians, but Darkseid? No, another level. You'd need someone like Superman to handle something of that maginitude; partial functions "work in most happy path scenarios", but they're lying about their capabilities. For example, divide says "Yo, I can divide for you" but if you give it a 0 it's all like "Here's Infinity"... like how is that even helpful? Going back to the Honda metaphor, or even Toyota, you buy a Toyata Tacoma, that thing will do everything and last forever. You buy a Cybertruck... I mean, yes, it'll get you from Point A to Point B, but he quality is meh, and it's capabilities ain't all that. It's billed as something rivaling a Ford 150, but... you'll end up breaking it. I'm not sure if "cheap imitation" is a good metaphor; partial functions run our digital world, no doubt, but ...not on airplane software, nor medical software, or _most_ rockets. You want to sure that thing always works or fails for all possible scenarios. Partial Functions don't, and once you learn about Total Functions, you suddenly realize all of those functions have been lying to you for years; not maleovent, mind you, but still not solid engineering by any stretch. |
| **Example** | `function divide(a: number, b: number): number { return a / b }` — returns `Infinity` or `NaN` for edge cases. |

---

## Card 10

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Smart Constructors |
| **Description** | Factory functions that validate and return `Result` or `Option` instead of throwing. |
| **Visual Metaphor** | Similiar to the Opaque ones, if you want something valid, you buy from a reputable source. Want a good car? Buy from a top rated dealership. Want good food? By from a reputable grocery story / farmers market. Don't just "oh it's organic, it must be good"; dude, you bought it from Walmart, like... you need to raise your expectations and shop at places that WILL deliver. Speaking of deliver, you know how Amazon has that "Delivered Through Amazon"; it's a guarentee the seller won't screw you over, and you have piece of mind for the purchase. Smart Constructors are like housing inspectors; they tell you in no uncertain terms: what is wrong with this house, and if it's worth buying, and if so, with what repair/replace stipulations. |
| **Example** | `const email = Email.create(input) // Result<Email, InvalidEmailError>` |
|**Level** | Intermediate |
| **When to Apply** | Domain modeling |
| **Learn More** | https://dev.to/gcanti/functional-design-smart-constructors-14nb |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Constructor Exceptions |
| **Description** | Constructors that throw on invalid input — caller doesn't know from type signature that it can fail. |
| **Visual Metaphor** | Whenever I buy clothes from a non-good brand, I almost always regret it. The stiching is bad, or I think the shirt looks cool online, but in person it's just cheap, or already falling apart. My daughter had to learn the hard way on both Roblox purchases as well on Ali Express, there are nuermous scams, so you have to vigilant. NOT being vigilant or careful or caring about quality is what leads to constructor exceptions. "Oh, this email some random person typed into a web form is fine... BOOM!" |
| **Example** | `new Email("invalid")` throws — but `new Email(input)` looks safe in the code |

---

## Card 11

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Anti-Corruption Layer |
| **Description** | Translate external/legacy types into your domain types at the boundary. Keep external shapes outside. |
| **Visual Metaphor** | Man, so many ways you could go with this. Let's talk about pro's. My cousin is into fashion, she runs a consignment shop in a city nearby. So I'll ask her fashion questions. Her answers are heavily influenced by a tax bracket, high level of quality, and specific rules and manners. I have to take this advice, and only keep what works because I still "have to be me". So it's all good advice, no doubt, but if want a blue mohawk, I'm going to do that and still follow some of the rules she told me about. Both are valid in their own context, but she's coming from a well to do, proper, polite, and professional context, and I'm ... a punk. The result would hopefully more "Frank Zappa" and less "Guttermouth". That clear dileantion means I'm not constrained or have self-image problems by being someone I'm not. I'm true to myself, but still keep an open mind to learn and improve. Another example, there's this mountain nearby where you can hike up and camp up top; tons of camping spots. However, while the view is great, it's actually more enjoyable for me to go nearby to the spring, slightly lower elevation, in the woods, with a bit of bushwhacking (off trail). I have my own fire pit, privacy, and am in the woods with way less wind, but still "in the mountains" to enjoy camping. I take the standard advice "take this trail to beautiful view", but modify for my context, so I still enjoy myself; I'm not constrained by the default park/forest service limitations. You could also go back to the water straw/filter example; there IS good water there, you just have to filter out the dirt, backteria, and viruses. |
| **Example** | `const user = toUser(apiResponse)` — API shape stays at edge, domain shape inside |
|**Level** | Advanced |
| **When to Apply** | Boundaries/IO, System-level |
| **Learn More** | https://docs.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Leaky Abstractions |
| **Description** | External API shapes spreading through codebase, coupling your domain to third-party structures. Also leads to Shotgun Parsing. |
| **Visual Metaphor** | Me in high school. I only liked some music or wore specific music shirts to fit in with a specific friend group. For example, I did like Alice and Chains and Pearl Jam, but... only liked Dinosaur Jr because this girl I liked raved about their albums. I... liked their music, but hated their singer. I only listened to Sonic Youth to annoy my parents. Another angle is the "jury rig" fix. For example, most modern vehicles (cars, motorcycles) have water that goes into the engine, then comes out carrying heat, the disapates that heat near the radiator, then goes back in cold again; this is how it keeps the engines cool. If that tube hits a rock or gets damnaged and starts leaking, most engines won't work without that heat disappation system. So what I've seen people do is use duct tape to quikly fix it. That is SUPER awesome for like an hour to the next car parts store... but not for weeks on end? Same for my sink; we have the handle on it break, so I added some super glue until I had time to go the hardware store. Except I forgot, and my daughter and wife here so ticked off it kept breaking. Not fixing things properly, and just jury rigging a fix leads to all kinds of other problems, ecspecially if you keep doing that like all over the car or house. |
| **Example** | `function processUser(user: APIYouDontOwnResponse)` used deep in business logic — API changes, everything breaks. Their messy data makes your code messy. Data in Python snake case (e.g. `first_name`)? Now used in your `cameCase` code base making it harder to read. |

---

## Card 12

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Pipeline Builder |
| **Description** | Pattern to build a function for processing some data using a series of piped functions. |
| **Visual Metaphor** | The Roman Aquaducts. I'm not even a history savaant, and even I know they are beyond amazing with all the ways to speed up and slow down the water/erosion/water quality. The ability to get "water from here to there" is what a good pipeline does, and leveraging that with types ensures it works. For example, the Romans would use a Settling Basic when the water went too fast and risked eroding or washing over the duct. This "pool" would stop the water, and then force it to pool and raise up to exit slowly. Types in pipeline programming help ensure "ah, you need to connect the settling basin to the fast duct" so you have a safe pipeline.  |
| **Example** | ```Success().concat(isPasswordLongEnough(password)).concat(isPasswordStrongEnough(password)).map(_ => password);``` returns `Success(password)` if it's valid or `Failure([validation failures here])` |
|**Level** | Advanced |
| **When to Apply** | Decoders, Validation |
| **Learn More** | https://sporto.github.io/elm-patterns/advanced/pipeline-builder.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Fast-Fail Validation Chains |
| **Description** | Imperative or monadic validation often stops at the first failure, so users only see one error at a time. |
| **Visual Metaphor** | The opposite; plastic pipes used in northern, frigid climates that burst when it gets too cold. I live in the South which is shielded from the extreme cold, but even my house occasionally can be affected by it; we have our AC / heater in the attik. When both run, it sheds water; that water goes into a pool, and a pump pushes it out of the house. When it gets below 12F/-11C for longer than a day, the rubber pipes can fresh, and your heater turns off to prevent flooding your house. You have to use a hair dryer to make it work again, or pile insulation on the pipes like I did. One weak link in the chain can make the entire system not work... and even then you don't know if anything else is affected. For example, one year I fixed the attic... then found out the pipe outside the house was frozen too! The ice was like 30ft tall in the pipe; we had to pour hot water on the bottom pipe outside to allow the water to fall out of the house pipe. Another example is the DMV (Depart of Motor Vehicles), I sure hope you don't have that in Poland. You go there, and are missing some stupid form, or filled out the wrong thing, you have to spend yet another 2 hours getting a new appointment or dealing with people who won't help you or are just rude/angry, and its' frustrating not knowing ahead of time the 13 wonky steps you're suppposed to magically know about. |
| **Example** | `if (!name) return Left('name'); if (!email) return Left('email');` — only the first error is returned. |

---

## Card 13

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Typestate |
| **Description** | Encode lifecycle states in types so only valid transitions are possible at compile time. |
| **Visual Metaphor** | This would be instructions for a robot, like a Roomba. It's extremely clear what steps to do, when (e.g. if full power, and time to clean then go clean. If stuck, turn around. If not memorized floorplan, go do that. If dust bin full, go empty it and keep vacuuming if we have some battery. If out of battery or done, go back to home and recharge). All of those transitions are clear, and you can only go from 1 to the other in specific situations. A light switch is another; it's either on or off; each to transition. e.g. you can't go from "On to On"; it's very clear you "turn it on" meaning, "off to on" and "turn it off" meaning "on to off". Another example could be driving directions; you can't "turn left on I-84" unless you've made it to step 5 first, that kind of linear, clear step style of transition. |
| **Example** | `type Draft = { tag: 'Draft' }; type Submitted = { tag: 'Submitted' }; function submit(d: Draft): Submitted` |
|**Level** | Intermediate |
| **When to Apply** | State machines |
| **Learn More** | https://sporto.github.io/elm-patterns/advanced/flow-phantom-types.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Illegal State Transitions |
| **Visual Metaphor** | Operations run in the wrong order because lifecycle rules are only enforced by runtime checks. |
| Most machines nowadays don't allow this, but I've seen a few. Examples are when you turn the hair dryer on and it's accientally in full blast and you want it on low. Or you turn on the car and accidentally left the volume to max and you're like "AHHHHH", or you're driving a car/motorcycle with a clutch and you let it all out while in gear, but no acceleration and it shuts off the engine. Or you put food in the oven, and 20 minutes later realize you didn't turn the oven on (you set the tempature but forgot to hit start). You know how you submit an empty form and it's like "Hey, all 30 of these fields are wrong and now red"; like... why did you let me submit something blank, bruh? You ever hit an elevator button like a millisecond before an elevator in front of you is closing, and it suddenly reopens and everyone inside is like "Hey, jerk!"... like why did it not just ignore me at halfway? Making Matzo ball soup, but forgetting to mix the eggs, and now you have yolk and powder and you're like "ugh, this'll be a pain to stir". |
| **Example** | `approve(order)` compiles even when `order` is still draft |

---

## Card 14

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Indexed Types |
| **Description** | Carry useful facts in type parameters (length, state, currency, etc.) so operations preserve invariants. |
| **Visual Metaphor** | You know how rulers have inches on one side for stupid Americans who use the ungodly Imperial System and Metric on the other side for sane people? This is cool because you can convert pretty quickly on the edge, and it's extremely clear if you're measuring inches or centimeters. Another is how currency _looks_ different; it's clear if you're using American green dollars, or Australia's cool plastic, transparent head radness. All Legos fit other Legos. You use metric tools on a metric car. This screwdriver goes into the screwdriven screw; phillips only fits phillips screw heads. |
| **Example** | ```typescript
type USD = { readonly _unit: "USD" };
type EUR = { readonly _unit: "EUR" };

type Money<C> = { amount: number; currency: C; };

function add<C>(a: Money<C>, b: Money<C>): Money<C> {
  return { amount: a.amount + b.amount, currency: a.currency };
}

const usd1: Money<USD> = { amount: 10, currency: { _unit: "USD" } };
const eur1: Money<EUR> = { amount: 7, currency: { _unit: "EUR" } };

add(usd1, usd2); // ok
// add(usd1, eur1); // compile-time error``` |
| **Level** | Advanced |
| **When to Apply** | Domain modeling, Value-level |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/generics.html |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Currency Mixups |
| **Description** | Monetary values with different currencies are treated as plain numbers, so invalid operations compile and produce incorrect totals. |
| **Visual Metaphor** | My youngest daughter kept getting clothes the wrong size from Ali Express because their American size was actually mapped to like Thailand sizes somehow (or she forgets Americans are... unfortuntely too big on average). She was a 6, but realized from specific Asian brands she had to convert the sizes based on measurements; each brand on their site has a size converter that is NOT correct. She had to use a ruler to convert, else many of the clothes just wouldn't fit. (She had a lot of returns). We constantly had to redo this, too because she started remembering "yeah, this brand is wayyy smaller than they say they are" and "this brand is fine, but for whatever reason their skirts are 1 American size smaller". |
| **Example** | `add({ amount: 10, currency: 'USD' }, { amount: 7, currency: 'EUR' })` silently mixes currencies without conversion |

---

## Card 15

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Units-of-Measure Types |
| **Description** | Encode physical/business units in types to prevent invalid arithmetic across incompatible dimensions. |
| **Visual Metaphor** | Same as currency. |
| **Example** | ```typescript
// Branded unit types
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
const speed = divideMetersBySeconds(distance, time);``` |
| **Level** | Intermediate |
| **When to Apply** | Value-level |
| **Learn More** | https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure |



### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Unit Mixups |
| **Description** | Values with different units are treated as plain numbers and combined incorrectly. |
| **Visual Metaphor** | Same as currency. |
| **Example** | <pre><code>// const bad = addMeters(distance, time);
//            ^ Type error: Seconds is not assignable to Meters</code></pre> |

---

## Card 16

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Capability-Based Design |
| **Description** | Pass explicit capabilities (permissions/operations) into functions instead of relying on ambient global authority. |
| **Visual Metaphor** | Wow this one is tough... lemme just stream of conciousness and see what happens. In math, if you got 1 + 1 = 2 in your head, nothing happens when you see/hear "2". Like, you're still you, the world goes on. But if you do that on a calculator... something DOES happen; you see a "2" on the screen. Not "1 + 1", but just "2". The world has changed. If you now press "+ 1" on the calculator... you suddenly get "3". Both the screen changes, and you're understanding of "+ 1" because it's a different time. Math "always works", but the real world... with time... that's when things get real and we call that "Effects". Or rather "side-effects"; things that happen outside of the math. The messy, impossible to predict, real world. However, if we explicitly cite those capabilities, 2 cool things happen: First, you can have expectations ahead of time by reading it; "Ah, this will send an email... maybe, else it'll tell us why the email failed to send". Second, you know what it IS NOT doing; meaning all this does is send an email, it doesn't actually update their user profile, or change their hotel reservation time... or anything else dangerous. For example, I know when I go Backpacking in the woods, I don't just need "a hammock to sleep in". I'm in nature... it _could_ rain/snow, so I bring rain gear just in case. Everyone who rides a motorcycle in America (excluding Californians) ALWAYS checks their phone to know what the weather is. They could be 30 year experts at riding and mechanics so they know they can ride and the bike will work... but will it rain? Who knows, better check so I know if I need to bring/wear rain gear. Capability-Based Design means making those "random, dangerous real world things" apparent. e.g. "It could rain", "bring bear spray in case of bear", "bring cold food in case fire starter fails", "bring water in case no stream/lake for water filter". It's like how every building has a fire estinquisher, and in America at least, wayyyyyy too much parking "just in case everyone and their mom shows up". You make that explicit, know. Airplanes: "The emergency exits are here". I think a key point to this one compared to the "Effect Typing (Function Coloring)" one is that this is all about "the entire system". There are things inside the system happening we may not even see; we just want to be clear about it. The "Effect Typing" one is way more small and explicit; e.g. "This lightswitch also turns on the celing fan". |
| **Example** | `function registerUser(sendEmail: SendEmail, user: User)` |
| **Level** | Advanced |
| **When to Apply** | System-level, API design |
| **Learn More** | https://fsharpforfunandprofit.com/posts/dependencies-3/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Ambient Authority |
| **Description** | Code can perform hidden side effects because it can reach global DB/fs/network clients directly. You can also require a lot of dependencies to child functions through Dependency Injection. |
| **Visual Metaphor** | There are 2 things here, but I wouldn't stress being able to visualize both. The first is you know how you turn on a light switch that "turns power on for the room"? You were expecting it to turn a light on, but suddenly a clock turns on, an fan starts spinning, and you hear a random beep. My favorite (not really) is when I used to travel for work; I'd get into some random hotel, turn on the bath tub, and my head would get blasted with water from the shower. I swear even in 2026 we still don't have a standard on how to switch "tub to shower head". You ever buy soda/a coke, get home, open it, and it explodes all over your kitchen because you didn't know it had been shaken on the ride home? It was supposed to be simple, but now you're cleaning up a disaster in the kitchen. Ok, so that's the first, the 2nd is more about layered dependencies. For example, we were going on an errand with my kids once, and the wife says "Bring a paper towel" and I'm like "uh... ok... why?" and she's like "for the dance" and I'm like "When I was a kid, we typically dressed up and danced, we didn't chow down on messy food and assume the school wouldn't provide napkins". The wife is like "wtf are you talking about, it's for the boy" and I'm like "The boy... what in the heck are you ... talking... about..." and she's like "Ssh, we have to whisper! Your daughter wants to impress the boy" and I'm like "oh you mean that one dude she likes?" and she's like "Ssh! Yes" and I'm like "so what does... a ... paper towel have to do with that" and she's like "for the lipstick, you dummy! She needs to blot it" and I'm like "geez, that was complicated... ok". Like I said, layers. It's clear to the wife, but to me I'm like "wait, there are levels here I need to understand...". |
| **Example** | A function that should only email users also mutates billing records. Also `function getUsers(fetch)` now requires all fucntions that use `getUsers` to also supply `fetch` in their dependencies, even if they don't ever actually use the `fetch`. |

---

## Card 17

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Type Proofs (Assertion Functions) |
| **Description** | Use `asserts` functions to prove runtime predicates to the type system, enabling refined types after checks and composed proofs. |
| **Visual Metaphor** | When you do the math, show your work, and test that work. |
| **Example** | `type OrderedPair = readonly [Lower, Upper]` and `function assertOrdered(p: readonly [number, number]): asserts p is OrderedPair { if (p[0] >= p[1]) throw new Error("Expected a < b") }` |
| **When to Apply** | Value-level, Function-level, Domain modeling |
| **Level** | Advanced |
| **Learn More** | https://www.typescriptlang.org/docs/handbook/2/narrowing.html#assertion-functions |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Unproven Invariants |
| **Description** | Code assumes ordering or constraints that are only documented in comments, forcing unsafe casts and brittle logic. |
| **Visual Metaphor** | The types aren't total. |
| **Example** | A tuple is assumed sorted, but later code reorders it and breaks range checks. |

---

## Card 18

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Error Algebra "Errors as Values" |
| **Description** | Model domain errors as discriminated unions with explicit recovery meaning (retry, fix input, escalate, abort). |
| **Visual Metaphor** | People kind of ignore failure in programming, and just optmize for the happy path. When thigns break, they're like "oh, we'll we just look at the error, which doesn't happen much, fix it, deploy". As a UI developer... the cost here is the user is frustrated. Something didn't work. In back-end, you're pretty separated from the people that use your code, even if you talk to customers. In UI, they are clicking your button; it's intimate. So you care that much more because you're the one that has to deliver the bad news; all that work they put into a form "Sorry... but the guy I ask to proess this form... well, he exploded". So we take a hard stance. We say "Anything that can go wrong, let's explicitly talk about it." Once it's obvious, anything you're doing that's related to that thing that can go wrong ALSO has to handle it as well. You no longer hide the failings; you bring them into the light, and you unsure you handle every single one. This changes your worldview: 1, if something can go wrong, we think about it in 2 ways: "Does the user care?" or "Do we have no clue, and that's just life". The first, we think about naming them and how we can possibly recover. The second... well, those truly are the bad luck of life, but we know once they happen, we'll learn and make things better, all in the spirit of fighting for the user. We call it "algebra" because in the chaos that is code, having mathematical assuredness helps wrangle the chaos into predictable outcomes. It's a Klingon Warbird in an asteroid storm. Using that tool, you can forge something powerful amidst the maelstrom of "just ignore the bad things". Not sure if you're familiar with Planetscape, but they have this name for the plane of chaos, "Limbo". It's a infinite soup of matter and the more will you have, the more ability you have to force that will on the chaos and "build" things. Everything from a bubble of air you can live in to an entire city with orante buildings... all from your mind. This is what it means to "use Alegbra predictability to look for failures, bring them to the light, and handle when they occur". |
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
| **Visual Metaphor** | If you're like me and your car won't start and no lights on the dash show anything... this is what that means. "Something broke, we have no idea why, or what to do... or NOT to do, to fix it". For example, if you're buying something, and your credit card doesn't work... usually you get a text saying "suspicious transaction"; you call your bank, voila, it works. But if it doesn't work, and the bank says its fine... WHY IS MY CARD NOT WORKING!? I remember some friends, we went to their house for dinner. Their dog ran out the front door... and ... they just said... "I guess she's gone". The wife and I were like "wat?" so we went driving around the neihborhood they lived in, found the dog, brought it back. That kind of "something's wrong... I guess we're helpless" is the opposite end of this; something went wrong, but nothing you can do other than say "woe is me". Another idea is when people get advanced / alien technology in movies, and they go to use it at some pivotal moment and it doesn't work and they're like "wat? oh no..." |
| **Example** | `throw new Error("checkout failed")` |

---

## Card 19

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Schema/Codec Single Source of Truth |
| **Description** | Define runtime schema once and derive parser, encoder, and static types from it to avoid drift. |
| **Visual Metaphor** | "I'll meet you at 6pm EST inside the coffee shop on the corner of Baker and George St". We've establed 6pm, not 18. We've established New York time zone. We've establed the 2 streets that connect and have a coffee shop on it implying there are no other coffee shops there. Finally, we define inside instead of outside. That language is mostly clear since we all share it. There is an international community devoted to timezones, both defining now, AND the past (e.g. when New Zealand moved theirs back, and handling the math for what time it was in 1970 vs now with day light savings time). Same with Metric weights and volumes; we all agree to speak the same language to ensure we have a single source of truth to help communication (I know... I'm American, a bit... hypocritical, but... self aware at least 😜?) |
| **Example** | `const UserSchema = z.object({ id: z.string(), email: z.string().email() }); type User = z.infer<typeof UserSchema>` |
|**Level** | Beginner |
| **When to Apply** | Boundaries/I/O, Module-level |
| **Learn More** | https://zod.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Schema Drift |
| **Description** | Runtime validators, TypeScript types, and API docs diverge over time and create subtle bugs. |
| **Visual Metaphor** | Basic miscommunication. "You said 6?" "Yeah, 6pm, not am". A common one that happens all the time is Python people saying `first_name` (snake case) and JavaScript people saying `firstName` (camel case). |
| **Example** | Type says `email?`, parser requires `email` |

---

## Card 20

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Property-Based Testing from Types |
| **Description** | Generate many test cases from typed generators and assert invariants instead of relying only on hand-picked examples. |
| **Visual Metaphor** | Like the Total Functions, but a way to PROVE they handle all possible situations. Kind of like those brutal Japanese quality engineers you see in lab coats. Even a "Honda" or "Toyota"; they STILL use a Kanban style to be brutal on quality, THEN iterate to make it better. Fortnine has a good Kanban style. Property tests will actually generate a bunch of random inputs, then run the same test with those 100 random inputs. An example; You know that 99 beers on the wall song? A QA Engineer walks into a bar. He orders a beer. Orders 0 beers. Orders 99999999999 beers. Orders a lizard. Orders -1 beers. Orders a ueicbksjdhd. |
| **Example** | `fc.assert(fc.property(arbUser, u => deepEqual(decode(encode(u)), u)))` |
|**Level** | Intermediate |
| **When to Apply** | Function-level, Domain modeling |
| **Learn More** | https://fast-check.dev/ |

### BACK (Problem)

| Field | Content |
|-------|---------|
| **Title** | Example Blind Spots |
| **Description** | Small example-based tests miss edge cases that violate invariants in production. |
| **Visual Metaphor** | Like the "divide by 0", you can miss things. The type "says" number, but that could be not a real number like 0 / 0, or 12 / 0 which is infinity... rather than just remember that, it's easier to use property tests to find all these edge cases you didn't think about. "My house has 12 doors... did I lock them all?" or that one time Deadpool was fighting 12 army dudes and he's like "Oh god... did I leave the oven on!?" |
| **Example** | Tests pass for ASCII names but fail for Unicode input |

---

## Card 21

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Option / Maybe Type |
| **Description** | Represent absence explicitly with `Some`/`None` instead of `null` or `undefined`. |
| **Visual Metaphor** | Giving a name, and value to "Nothing". The mathematical equivlanet to The Neverending Story. Tony Hoare, a British knight and... smart engineer computer guy, invented "null" back in the 1960's or 70's. He called it his Billion Dollar mistake because computers crash mostly "because of null". So math people were like "Yeah, no... we have a value in math for null, it's called 0, and we can ensure when data isn't found, instead of exploding the world, we can instead force programs to handle 0", and thus the "Option" or "Maybe" type was born. For example, WILL that Thai place I like down the street have any Pork Belly Basil today? I can't ever order and go "1 pork basil, please". Instead, it's "Do you have any pork basil today?" because "maybe" they have some... maybe they don't. If they don't, instead of collapsing, I handle that case; I say "Ok, I'll have the popcorn chicken instead". That's how the Option or more popular "Maybe" type work; they force you to handle the Nothing scenario. |
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
| **Visual Metaphor** | Imagine meeting someone with no name. That would make your head explode. That only works with that dude in Game of Thrones. I say computers have `null` and make it explode, but some languages will have some people actively check for it first; e.g. "If this isn't null, then keep doing more code". This, however, makes your entire code base gross because you're constantly paranoid that at any point, your data is foobarred. Image taking a walk to the park, but you are all paranoid it might snow, rain, or lava or asteroids from the sky... then while walking, you have your shotgun all looking around in case wolves jump out at you... then ensuring you have enough money for the ice cream truck, which doesn't usually come today... like that's no way to live, man. I listened to an AI YouTube once that I think was a cut up lecture from Richard Feynman that said "Actually, nothing doesn't actually exist" which ... is quite amazing from a philosophical stand point, but in programming & math it most certainly does, and we're forced to handle it. When we ignore it, things explode/go boom in computer land. |
| **Example** | `user.address.city` throws when `address` is `undefined` |

---

## Card 22

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Product Types (Records) |
| **Description** | Model data that must exist together with named fields (`AND` composition). |
| **Visual Metaphor** | This one is easy; it's the blueprint of everything. We're all made up of many parts; a first name, last name, where we live, our interests; that single definition is our Record. It's called "Product" because of multiplication effect of "having all these things that make up, you". Like, even a dog could be a record; a breed + a name + an age. They usually define "things" that can't be summed up in a simpler way; like bank account, or person, or cow. |
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
| **Visual Metaphor** | When people don't model things, they say "100" and you're like "100 wat... dollars... peso's... bitcoin...?". Same for when things break, they'll say "It broke", but then you have to look somewhere else for _why_ it broke. Records are nice because they contain all the data, like "100 USD dollars" or "it broke, here's the error, and here's what you should try to fix it". |
| **Example** | `charge(100, "USD")` vs `charge("USD", 100)` |

---

## Card 23

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Unknown at Boundaries |
| **Description** | Accept external input as `unknown`, then parse/narrow once into trusted domain types. |
| **Visual Metaphor** | This one is kind of weird and subtle. For example, at my work, we have a badge to get in the doors of the buildings. It knows who we are. If we bring a guest or our kids, we have to get them temporary badges. Now, those badges work the same, BUT you have to register that person first; you can't just get a badge. This "conversion", e.g. "Making sure we know who this is" is what `unknown` enforces; you can't just go converting a "string" to a "number", or in the badge case "a random person is suddenly an authorized employee". That registration office part is the important part to ensure we convert "unknown" to "known" safely, and you enforce that. |
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
| **Visual Metaphor** | The alternative is `any`; meaning, no badges, no forced conversions, you just go "Oh yeah, this random dude I found on the street is with me". That's... not safe. Like, I can emphasize this enough, it's really convienant, no doubt, but super dangerous. |
| **Example** | API payload typed as `any` reaches business logic and crashes on missing fields |

---

## Card 24

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Readonly by Default |
| **Description** | Prefer immutable shapes so mutation is explicit and local, reducing aliasing bugs. |
| **Visual Metaphor** | We kind of take immutability for granted. Like, you don't wake up one day and "1" suddenly equals "2". You can't change the meaning/value of "1"; it's... always 1. Same with life. The sun always comes up and goes down. We all live and die. What goes up must come down. There is a Yin and Yang. Following this rule, while sometimes painful to make copies of everything to make any change, DOES ensure you don't get spooky action at a distance. For example, if you went into my head and changed my name to "Mary", I'd wake up the next morning, and wonder why my Slack is wrong at work, and everyone I interact with would be freaking out. Certain things are immutable, but if you want to change them, you make it explicit. For example, I've learned it's better to warn the wife and co-workers when I'm about the shave the beard. Conversely, I've learned that people LOVE to embarass me when my age changes (e.g. birthday, e.g. my age increases by 1). When you change things, e.g. "mutate them", unexpected, bad things can happen. Just look at the drama the X-men have with the "mutant X gene". Keeping things immutable means they are predictable and easy to test. |
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
| **Visual Metaphor** | You know in video games how things can change, like your score, or how zoomed you with a sniper rifle? This is fast and easy to do, but also dangerous. For example, there used to be a bug in CounterStrike where you could zoom in and it'd allow you to see through walls because the camera in the game physically moved _through_ the wall. The other players couldn't see your character through the wall, but what you saw on your screen was your sniper rifle's scope seeing players through walls. Same with various "infinite gold" or items glitches, like in Dying Light where a player gives you an item, but they close the window before it finishes transfering. If you get the item, normally it'd mutate your amount by negative 1... but if you close the window, you get a few, new thing, but the other player keeps their copy. Mutation/changing things is dangerous. |
| **Example** | A helper function mutates `user.roles` and breaks permission checks elsewhere |

---

## Card 25

### FRONT (Solution)

| Field | Content |
|-------|---------|
| **Title** | Railway-Oriented Programming |
| **Description** | Compose `Result`/`Maybe` steps left-to-right; stop at first failure, continue on success. |
| **Visual Metaphor** | This one is actually easy (but if you don't like the default, no worries). There are 2 tracks; green and red. There is a branch that's red going to a separate track in parallel. There tends to be multiple of these; 3, 7, whatever. The point is, if everything is going well, you stay on the green track and at each turn to the red track, you just keep going. If something at any of the branch points goes wrong, you just go on the red track. There's no way to from the red track back to the green track. You'll often see this visualization going vertically (because that's how programmers think), but horizontal is fine too or diagonal; it doesn't matter, just that once you're on the the red, there is no going back. Unlike pipeline, there are 2 tracks. It has a ton in common with pipeline; in fact, it's based on it. However, pipes, if something is wrong, or you have a bunch of information; you have to keep shuttling that along in the pipes. Railyway is nice because you can have 2 outcomes; success or failure, valid or invalida, something or nothing, etc. ... now, TECHNICALLY you can go back from Red to Green in certain, common conditions, but to get the basics, most people start with "if something's wrong, go on the red track and stay there". If you look up Scott Wlaschin and his railyway, he has some good visualizations. |
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
| **Visual Metaphor** | This one is easy too. If you you look up the Ryu hadoken punch if then statements, you'll see how they nest to the right, and it's so hard to read. It's not so much the "nest", it's just that it's hard to follow. You know how maps sometimes have a bunch of roads overlapping in the same color and you're like "dude, I'm getting lost". You need to follow the threads because you need to figure out where the errors are. I tend to think of it like sailing a boat in waters near a lighthouse; there are so many submerged or small rocks hard to see a frothing sea, and in those conditions, no one is going to rescue you.  |
| **Example** | `if (ok1) { if (ok2) { try { ... } catch { ... } } else { ... } } else { ... }` |

---
