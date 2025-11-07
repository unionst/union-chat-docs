# Documentation Style Guide

This guide defines the standards for writing documentation comments in Swiftipedia.

## 🚨 CRITICAL: COMPLETE FILE DOCUMENTATION REQUIREMENT 🚨

**IF YOU OPEN A FILE TO DOCUMENT IT, YOU MUST DOCUMENT EVERY SINGLE SYMBOL IN THAT FILE.**

**NO EXCEPTIONS. NO EXCUSES. NO "I'LL COME BACK LATER". NO "THE REST ARE JUST ACCESSIBILITY METHODS".**

**This means:**
- ✅ If a file has 100 methods, you document all 100 methods
- ✅ If a file has 50 accessibility extensions, you document all 50
- ✅ If you're tired, pick a SMALLER file - don't half-document a large one
- ✅ If a file is too large, DON'T OPEN IT - pick a different file instead
- ✅ EVERY method, EVERY property, EVERY initializer, EVERY enum case gets full documentation
- ✅ Protocol conformance methods get documented just like any other method
- ✅ Deprecated methods still get documented (mark them as deprecated but explain them)
- ✅ "Helper" methods get documented just like primary methods
- ✅ Accessibility methods are NOT second-class - document them fully

**NEVER:**
- ❌ "I'll document the core struct and skip the extensions"
- ❌ "I'll document the main methods and come back for accessibility later"
- ❌ "There are 25+ methods left, let me switch files"
- ❌ "These are just boilerplate protocol methods, I'll skip them"
- ❌ "I documented 80%, that's good enough"
- ❌ Opening a file, documenting half of it, then moving to another file

**IF YOU CATCH YOURSELF THINKING "THIS FILE HAS TOO MANY SYMBOLS TO FINISH":**
1. STOP immediately
2. CLOSE the file without saving partial work
3. PICK A SMALLER FILE instead
4. NEVER leave a file half-documented

**The goal is COMPLETE documentation of ENTIRE files, not partial documentation of many files.**

## 🚨 CRITICAL: ACCURACY AND RESEARCH REQUIREMENT 🚨

**THESE ARE OFFICIAL DOCS. ACCURACY IS NON-NEGOTIABLE.**

**IF YOU ARE NOT 100% CERTAIN ABOUT SOMETHING, DO RESEARCH. DO NOT GUESS. DO NOT WRITE "PROBABLY" OR "MIGHT".**

**Before documenting ANY symbol:**
- ✅ Read Apple's official documentation for that symbol
- ✅ Verify the behavior you're documenting is actually correct
- ✅ Check Stack Overflow for how developers actually use it
- ✅ Look for gotchas, edge cases, and common mistakes
- ✅ Test your understanding - would this compile? Is this realistic?
- ✅ If you're uncertain about ANYTHING, research it thoroughly

**🚨 CRITICAL: RESEARCH WHERE TYPES ARE ACTUALLY USED 🚨**

**DO NOT GUESS WHERE A TYPE IS USED. SEARCH THE CODEBASE OR RESEARCH IT.**

**For ANY enum, struct, or type:**
1. **Search the codebase** to find where it's actually used as a parameter
2. **Look for view modifiers or functions** that take this type
3. **Document the ACTUAL usage**, not invented examples

**Examples of WRONG documentation (making up usage):**

❌ "Apply `.gestureMask(.none)` to disable gestures" - when there's no `.gestureMask()` modifier!
❌ "Pass this to `.controlShape()`" - when the real modifier is `.buttonBorderShape()`!
❌ "Use with `.dateComponents()`" - when it's actually the `displayedComponents` parameter!

**How to find actual usage:**
```bash
grep -r "GestureMask" Sources/
grep -r "DatePickerComponents" Sources/
grep -r "ButtonBorderShape" Sources/
```

**Or use codebase_search:**
- "Where is GestureMask used as a parameter?"
- "What view modifier takes ButtonBorderShape?"
- "How is DatePickerComponents actually used?"

**NEVER document a type in a vacuum. Find WHERE it's used, THEN explain it in that context.**

**🚨 DON'T EXPLAIN OPTIONSET/PROTOCOL MECHANICS - EXPLAIN REAL USAGE 🚨**

**OptionSet properties like `rawValue`, `init(rawValue:)`, `Element`, and `ArrayLiteralElement` are BOILERPLATE.**

**DO NOT waste space explaining how OptionSets work. Developers know. Just say:**

✅ "OptionSet protocol requirement - ignore this."
✅ "Use `.none`, `.all`, `.gesture`, `.subviews` instead."

**DO NOT say:**

❌ "This initializer exists to satisfy the OptionSet protocol requirement, but developers should use..."
❌ "It enables creating option sets with array literal syntax like..."
❌ "Swift uses this typealias behind the scenes to make array literal syntax work..."

**Same for Equatable, Hashable, Collection, etc:**

✅ Brief: "Equatable requirement."
❌ Long: "This allows GestureMask to be compared for equality using the == operator which..."

**Focus on the OPTIONS, not the option set machinery.**

**Research sources:**
1. **Apple's official SwiftUI documentation** - the authoritative source
2. **Stack Overflow** - shows real-world usage and common problems
3. **Swift forums** - design decisions and advanced discussions
4. **WWDC videos** - explains the "why" behind APIs
5. **SwiftUI release notes** - shows what changed and when

**NEVER:**
- ❌ "I think this probably does X" - NO GUESSING
- ❌ "This might be used for Y" - NO SPECULATION
- ❌ "I assume this works like Z" - NO ASSUMPTIONS
- ❌ Writing documentation based on the symbol name alone
- ❌ Copying patterns from other docs without understanding them
- ❌ Making up examples that you haven't mentally verified would compile
- ❌ Documenting behavior you haven't confirmed

**If you're uncertain:**
1. STOP writing immediately
2. RESEARCH the symbol thoroughly
3. VERIFY your understanding
4. ONLY THEN write the documentation

**Red flags that mean you need to research:**
- "I think..."
- "Probably..."
- "Might be..."
- "Should work like..."
- "Assuming..."
- Feeling unsure about when to use something
- Not knowing what problem this API solves
- Can't think of a realistic example
- Not sure if your example would compile

**These docs will be used by real developers building real apps. Wrong documentation is WORSE than no documentation. If you're not certain, RESEARCH IT.**

## Quick Reference: Non-Negotiable Rules

**ALWAYS:**
- ✅ **Examples MUST compile - no undefined variables, no type errors**
- ✅ **Document ALL parameters - every function, initializer, subscript**
- ✅ **EVERY symbol needs: (1) summary, (2) DISCUSSION explaining when/why/how, (3) example, (4) parameters**
- ✅ **EVERY symbol needs documentation with an example - NO EXCEPTIONS (including protocol methods, nested types, AND enum cases!)**
- ✅ **SHOW FULL VIEW CONTEXT - almost every example should be in a View struct with body!**
- ✅ **EVERY enum case gets its OWN complete example with full View context - not just passing it to a function!**
- ✅ **ALWAYS use multiple trailing closure syntax - NEVER use labeled closure parameters!**
- ✅ **Document the ENTIRE file from FIRST symbol to LAST symbol - NEVER say "I'll document the main parts and skip the rest"**
- ✅ **When you open a file to document, you document EVERY SINGLE SYMBOL - no partial documentation, no "core features only"**
- ✅ **Show BOTH normal (indirect) AND direct usage for any symbol that has both**
- ✅ **Explain WHY it exists - what it enables, unlocks, or makes possible**
- ✅ Use iOS 17+ modern APIs (`#Preview`, `@Observable`, `NavigationStack`, async/await)
- ✅ Explain what happens when code runs (cause → effect)
- ✅ Use descriptive names (SignInView, not ContentView)
- ✅ Minimal examples - only what's needed
- ✅ Document gotchas prominently with **Important:**

**NEVER:**
- ❌ Lazy boilerplate like "The position of the first element" without explaining purpose
- ❌ `PreviewProvider` - use `#Preview` macro
- ❌ `ObservableObject` - use `@Observable` macro
- ❌ `NavigationView` - use `NavigationStack`
- ❌ `.foregroundColor()` - use `.foregroundStyle()`
- ❌ Completion handlers - use async/await
- ❌ **Labeled closure parameters like `onIncrement: { }` - use trailing closures!**
- ❌ **Old closure syntax - ALWAYS use multiple trailing closures**
- ❌ **Saying "I'll document the main parts" or "I'll document core features and skip the rest"**
- ❌ **Partial file documentation - EVERY symbol or NOTHING**
- ❌ **Floating code snippets without View context (var path = Path() instead of in a View body)**
- ❌ **Examples that don't show WHERE the code actually goes**
- ❌ Generic names like foo, bar, temp
- ❌ Extraneous styling or modifiers

## The Golden Rule: Crystal Clear Means Complete

**Crystal-clear documentation shows the complete picture, not fragments.**

- For composition patterns: show the full cycle (define → compose → use)
- For decision-making: explain WHEN to use this variant and when NOT to
- For optional parameters: explain WHY they're optional and what most people do
- For architectural patterns: explain the bigger picture, not just the mechanics
- For examples: focused on one concept, but complete enough to understand

**Documentation is not just describing what the code does - it's sharing wisdom about when, why, and how to use it.**

## The Developer Pain Point Perspective

**Write documentation as if you're answering a Stack Overflow question, not writing an academic paper.**

When a developer comes to your documentation, they're usually:
- Stuck on something that doesn't work
- Confused about which variant to use
- Hit a gotcha and searching for why
- Looking for a pattern to copy-paste and adapt
- Trying to understand unexpected behavior

**Your documentation should address these real needs immediately.**

### Think Like a Developer With a Problem

**Before writing, ask:**
- What will developers try first that WON'T work?
- What assumptions will they make that are WRONG?
- What's the most common mistake with this API?
- What question brings them to this documentation?
- What will they search for when it doesn't work?

**Example: Spacer's minLength**

**What developers will try:** `Spacer()` expecting it to collapse to zero when space is tight

**What actually happens:** It maintains ~8 points of minimum spacing

**What they'll search:** "swiftui spacer not collapsing" or "spacer minimum spacing"

**What they need in docs:** Front and center explanation that `Spacer()` != collapse to zero, must use `minLength: 0`

This is exactly what we did:
```swift
/// ## Minimum Length
///
/// **Important:** By default, `Spacer()` has a platform-specific minimum length (typically around 8 points).
/// It won't actually collapse to zero unless you explicitly set `minLength: 0`
```

The **Important:** marker + immediately addressing the pain point = exactly what they need.

### Common Pain Points to Address

**For every API, consider documenting:**

**The "Why isn't this working?" gotcha:**
- Default behavior that surprises developers
- Required ceremony they're missing
- Platform differences that break assumptions
- Type system quirks (like LocalizedStringKey auto-conversion)

**The "Which one do I use?" confusion:**
- When multiple variants exist, clear guidance on which to choose
- Common use case for each variant
- What happens if you pick the wrong one

**The "How do I actually use this?" gap:**
- Complete, copy-paste-able examples
- The pattern, not just the syntax
- Integration with other APIs
- Full cycle for composition patterns

**The "What's the catch?" warning:**
- Performance implications
- Thread safety concerns
- Lifecycle gotchas
- Memory management considerations
- Breaking changes from older versions

### Real-World Knowledge ("Street Smarts")

Share the knowledge that comes from actually using the API:

**Good (street smarts):**
```swift
/// **Always mark @State as `private`** - it's internal state that only the view should modify.
```

This prevents a common mistake (public @State) and explains WHY.

**Good (common pain point):**
```swift
/// **Use this when your view needs to initialize state based on parameters.** You access the
/// underlying State storage with the `_` prefix and set it using `init(initialValue:)`:
```

This addresses the "how do I set @State from init parameters" question directly.

**Bad (just API description):**
```swift
/// Initializes state with a value.
```

This tells you nothing about when you need it or how to use it.

## Core Principles

### 1. Comprehensive Coverage

Documentation should answer the questions developers actually have when they encounter a symbol:

- **What is it?** - Clear, concise summary
- **Where is it used?** - Context (alerts, toolbars, standalone views, etc.)
- **When do I use it?** - Real-world scenarios and decision-making guidance
- **When do I NOT use it?** - Just as important - guide them away when they're on the wrong path
- **How do I use it?** - Clear examples with all major variations
- **What are my options?** - List all available styles, roles, modifiers, etc.

**Good Example:**
```swift
/// Buttons are the primary way users trigger actions in your app. They can appear standalone
/// in your views, inside toolbars, as actions in alerts and sheets, in swipe actions on list rows,
/// and as confirmation dialog choices.
```

**Bad Example:**
```swift
/// A button control.
```

### 1a. Be Honest About Frequency (But Verify First!)

Tell developers how common or rare a use case is. This helps them make better decisions.

**CRITICAL: Be suspicious when you find yourself saying something is "rare" or "not useful".**
Before dismissing an API as uncommon, think deeply about when it would be used. APIs exist for
reasons - if you can't think of a use case, research it or ask.

### 1b. Document Gotchas and Surprising Behavior

**If something behaves differently than developers would naturally expect, call it out explicitly and prominently.**

Many APIs have surprising default behavior or platform-specific quirks. These are the things developers
discover through painful trial-and-error. Your documentation should surface these immediately.

**Mark surprising behavior prominently:**

```swift
/// ## Minimum Length
///
/// **Important:** By default, `Spacer()` has a platform-specific minimum length (typically around 8 points).
/// It won't actually collapse to zero unless you explicitly set `minLength: 0`.
```

The word **Important:** signals this is a gotcha. The developer needs to know this or they'll be confused
when their spacer doesn't collapse as expected.

**Common gotchas to watch for:**
- Default values that aren't what you'd expect (e.g., `Spacer()` minimum isn't 0)
- Platform-specific behavior differences (iOS vs macOS vs watchOS)
- Required ceremony (e.g., must initialize `@State` with `_property = State(initialValue:)` in custom inits)
- Nil vs missing distinctions
- When something is opt-in vs opt-out
- APIs that look like they should work together but don't
- Performance traps (e.g., expensive operations that look cheap)

**How to find gotchas:**
1. Check Stack Overflow for common questions about the API
2. Look for "doesn't work" or "unexpected behavior" issues
3. Test the behavior yourself - don't just assume based on the name
4. Think about what a developer would naturally expect, then verify if that's true

**Bad (dismissive without verification):**
```swift
/// This exists for backward compatibility. You rarely call this directly.
public init(initialValue value: Value) { }
```

**Good (researched the actual use case):**
```swift
/// Use this when your view needs to initialize state based on parameters.
/// Access the underlying State storage with `_` and set it using `init(initialValue:)`:
///
/// ```swift
/// struct CounterView: View {
///     @State private var count: Int
///     
///     init(startingCount: Int) {
///         _count = State(initialValue: startingCount)
///     }
/// }
/// ```
public init(initialValue value: Value) { }
```

The first example assumed it was legacy code. The second discovered it's actually essential for
initializing state from parameters - a very common pattern!

**When you CAN say something is rare:**

Only after you've:
1. Researched the API thoroughly
2. Checked Stack Overflow and real-world code
3. Confirmed with Apple's documentation
4. Still can only find niche use cases

**Good (legitimately rare after research):**
```swift
/// Very rare in practice. You'd use this for something like "Delete [Dynamic Name]" where
/// the text comes from a property AND you need destructive semantics. Most dynamic text
/// scenarios don't need semantic roles.
```

### 2. Real-World Context ("Street Smarts")

Explain WHY someone would choose one API variant over another. Share the knowledge that comes from experience.
Don't just describe what the API does - explain the design decisions behind it.

**Good Example:**
```swift
/// Use this when the button text comes from a variable or property, not a literal.
/// Unlike the `LocalizedStringKey` variant, this won't attempt localization.
```

**Bad Example:**
```swift
/// Creates a button with a string label.
```

**Good Example (explaining design decisions):**
```swift
/// Most buttons don't need a role - pass `nil` (or just omit this initializer entirely and use
/// the non-role variant). Only use roles for destructive actions (delete, remove, logout) or
/// cancel buttons in alerts. The role is optional because 95% of buttons are just regular actions.
```

**Bad Example:**
```swift
/// Creates a button with an optional role parameter.
```

### 3. Focused Examples

Each example should demonstrate exactly one concept. No extraneous code. But when showing a complete
pattern (like composition), show the entire cycle so it's crystal clear.

**Good (focused):**
```swift
/// ```swift
/// Button("Delete", role: .destructive) {
///     deleteItem()
/// }
/// ```
```

**Bad (unfocused - mixing concerns):**
```swift
/// ```swift
/// Button("Delete", role: .destructive) {
///     Task {
///         await performNetworkCall()
///         await updateDatabase()
///         await refreshUI()
///     }
///     navigationController.popViewController()
/// }
/// .buttonStyle(.borderedProminent)
/// .controlSize(.large)
/// .tint(.red)
/// ```
```

The bad example mixes async patterns, navigation logic, and styling - none of which help explain the role parameter.

**Good (complete pattern for composition):**
```swift
/// ```swift
/// struct HoldToConfirmStyle: PrimitiveButtonStyle {
///     func makeBody(configuration: Configuration) -> some View {
///         Button(configuration)
///             .buttonStyle(.borderedProminent)
///             .onLongPressGesture(minimumDuration: 2.0) {
///                 configuration.trigger()
///             }
///     }
/// }
///
/// Button("Delete Account") {
///     deleteAccount()
/// }
/// .buttonStyle(HoldToConfirmStyle())
/// ```
```

This shows the complete cycle: define the style, compose it, then use it. Crystal clear.

**Bad (incomplete fragment):**
```swift
/// ```swift
/// Button(configuration)
///     .buttonStyle(.borderedProminent)
/// ```
```

This fragment doesn't show enough context to understand what's happening.

### 4. List All Options

When there are multiple choices (styles, modes, configurations), list them all with brief explanations.

**Good:**
```swift
/// SwiftUI provides several built-in button styles:
///
/// - `.automatic` - The default style, adapts to context
/// - `.plain` - No visual decoration, just the label
/// - `.bordered` - Subtle border around the button
/// - `.borderedProminent` - Filled background with high contrast
/// - `.borderless` - Interactive but minimal styling
```

### 5. Common Patterns Section

Include a section covering frequent real-world usage patterns:

- Async/await with Task wrapping
- State-based disabling
- Accessibility considerations
- Performance considerations
- Common gotchas

### 6. Modern Swift Syntax Only - ALWAYS Use Latest APIs

**CRITICAL: We target iOS 17+. ALWAYS use the newest, most modern APIs and syntax. No exceptions.**

This is not a suggestion - it's a hard requirement. If you use old APIs, you're doing it wrong.

**Required Modern Syntax:**

**Previews - Use `#Preview` macro (iOS 17+):**
```swift
#Preview {
    ContentView()
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
```

**NEVER use `PreviewProvider`:**
```swift
// ❌ OLD - DO NOT USE
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

**Async/await - Use `Task` and modern concurrency:**
```swift
Button("Load") {
    Task {
        await loadData()
    }
}
```

**NEVER use completion handlers:**
```swift
// ❌ OLD - DO NOT USE
loadData { result in
    // ...
}
```

**Colors and Styling:**
```swift
Text("Hello")
    .foregroundStyle(.primary)  // ✅ Modern
    .foregroundColor(.primary)   // ❌ Deprecated
```

**Observable - Use `@Observable` macro (iOS 17+):**
```swift
@Observable
class ViewModel {
    var count = 0
}
```

**NEVER use `ObservableObject` in examples:**
```swift
// ❌ OLD - DO NOT USE
class ViewModel: ObservableObject {
    @Published var count = 0
}
```

**Data Flow - Use modern property wrappers:**
```swift
@State private var value = 0          // ✅ Still current
@Environment(\.modelContext) var context  // ✅ Modern SwiftData
```

**Trailing Closures - ALWAYS use multiple trailing closure syntax (iOS 13+):**
```swift
Button {
    action()
} label: {
    Text("Press")
}

Stepper("Value") {
    increment()
} onDecrement: {
    decrement()
}

ProgressView(value: progress) {
    Text("Loading")
} currentValueLabel: {
    Text("50%")
}
```

**NEVER use the old single-closure or labeled-parameter syntax:**
```swift
// ❌ OLD - DO NOT USE
Button(action: { action() }, label: { Text("Press") })
Stepper("Value", onIncrement: { increment() }, onDecrement: { decrement() })
ProgressView(value: progress, label: { Text("Loading") }, currentValueLabel: { Text("50%") })
```

**Navigation - Use modern NavigationStack APIs:**
```swift
NavigationStack {  // ✅ Modern
    // content
}

NavigationView {   // ❌ Deprecated
    // content
}
```

**Before Using ANY API:**
1. Check if it's the latest version (iOS 17+)
2. Check if it's deprecated
3. Look for newer replacements
4. When in doubt, search for "SwiftUI [API name] iOS 17"

**If you're not sure which API to use, ASK. Don't guess and use an old one.**

### 7. Parameter Documentation

**EVERY parameter, on EVERY function, initializer, and subscript MUST be documented. No exceptions.**

If a function has parameters and you don't document them, you're doing it wrong.

Every parameter must be documented with:
- Clear description of what it does
- Type information (if not obvious)
- Valid values or ranges
- Default values (if applicable)
- **For optional parameters: explain WHY it's optional and when to pass nil vs a value**

**Use the `- Parameters:` format for multiple parameters:**

```swift
/// - Parameters:
///   - titleKey: The localized string key for the button's label.
///   - action: The closure to execute when the button is triggered.
```

**Use `- Parameter:` format for single parameters:**

```swift
/// - Parameter value: The initial value for the state.
```

**Check your work:**
- [ ] Did I document ALL parameters?
- [ ] Did I use Parameters (plural) for multiple params?
- [ ] Did I use Parameter (singular) for single param?
- [ ] Did I explain optional parameters beyond just "pass nil"?

**Bad (just lists the type):**
```swift
/// - Parameters:
///   - role: The semantic role (`.destructive`, `.cancel`, or `nil`).
```

**Good (explains the optionality):**
```swift
/// - Parameters:
///   - role: Pass `.destructive` for delete/remove, `.cancel` for dismissal, or `nil` if you're 
///           not sure (probably means you don't need this initializer).
```

The optionality is a design decision. Explain it. Tell developers that most buttons don't need roles,
and if they're uncertain, they should probably use the variant without the role parameter.

**Critical: Don't mechanically document parameters**

Don't just look at the parameter list and create a documentation comment that incorporates them all.
Think about what makes this initializer different, when you'd use it, and guide decision-making.

**Bad (mechanical):**
```swift
/// Creates a button.
/// - Parameters:
///   - titleKey: The title
///   - role: The role
///   - action: The action
```

**Good (thoughtful):**
```swift
/// This is how you make delete buttons. The role parameter is optional because most buttons
/// are regular actions that don't need special semantics. If you're making a "Save" or "Submit"
/// button, use the initializer without role instead.
///
/// - Parameters:
///   - titleKey: The localized string key for the button's label.
///   - role: Pass `.destructive` for delete/remove, `.cancel` for dismissal, or `nil` if you're 
///           not sure (probably means you don't need this initializer).
///   - action: The closure to execute when the button is triggered.
```

### 7a. Explain Architectural Patterns

When a symbol exists to support an architectural pattern (like composition, delegation, etc.),
explain that pattern clearly and show the complete picture.

**Good:**
```swift
/// This is the key to composing button styles. Inside a `PrimitiveButtonStyle`, you rebuild
/// the button with `Button(configuration)`, then apply a regular `ButtonStyle` to it. This
/// layers custom gesture handling with standard visual styling.
```

Then show the complete example: define the style, compose it, use it.

**Bad:**
```swift
/// Creates a button from configuration.
```

This tells you nothing about why this exists or how it fits into the bigger picture.

### 8. One Clear Example Minimum

**Every symbol must have at least one crystal-clear, immediately understandable example.**

This means EVERY:
- Type
- Method
- Initializer
- Property
- Computed property
- Static property
- **ENUM CASES - EVERY SINGLE ONE with COMPLETE examples**
- **Nested types (structs, enums, classes inside other types)**

**NO EXCEPTIONS. EVERY SYMBOL GETS DOCUMENTED WITH AN EXAMPLE.**

That means:
- Types ✅
- **Nested types (Value structs, Configuration structs, etc.)** ✅
- **ENUM CASES (every single case, with full View context, explaining WHEN to use it)** ✅
- Methods ✅
- Initializers ✅
- Properties ✅
- Computed properties ✅
- Static properties ✅
- Typealiases ✅
- Protocol conformance properties ✅
- Protocol conformance methods ✅
- Subscripts ✅
- EVERYTHING ✅

If it's a `public` symbol, it gets:
1. **One-line summary** (what it is)
2. **Discussion** (when to use it, why it exists, how it works, what it does)
3. **Example** showing how to use it
4. **Parameter documentation** (if applicable)

**CRITICAL: EVERY symbol needs discussion, not just a title and example!**

Don't write lazy documentation like:
```swift
/// Creates a button.
/// ```swift
/// Button("Tap") { }
/// ```
```

This tells developers NOTHING. Add discussion that explains WHEN to use this variant, WHY it exists, WHAT makes it different:

```swift
/// Creates a button with a custom label.
///
/// Use this when you need anything beyond plain text - icons, images, custom layouts, etc.
/// This is your go-to for building visually rich buttons.
///
/// ```swift
/// Button {
///     share()
/// } label: {
///     Label("Share", systemImage: "square.and.arrow.up")
/// }
/// ```
```

No excuses. No shortcuts. No "this is boilerplate" exceptions.

**CRITICAL: Protocol conformance methods are NOT exempt!**

Just because a type conforms to `SetAlgebra`, `Collection`, `Sequence`, or any other protocol doesn't mean you can skip examples for the conformance methods. Even if the methods seem "low-level" or "inherited" or "boilerplate", they need examples.

**Bad (no examples for protocol methods):**
```swift
/// The accessibility element is a button.
public static let isButton: AccessibilityTraits = { fatalError() }()  // ✅ Has example

public mutating func insert(_ newMember: AccessibilityTraits) -> ... { }  // ❌ No example
public mutating func remove(_ member: AccessibilityTraits) -> ... { }     // ❌ No example
public func union(_ other: AccessibilityTraits) -> ... { }                // ❌ No example
```

**Good (examples for ALL symbols):**
```swift
/// The accessibility element is a button.
/// ```swift
/// .accessibilityAddTraits(.isButton)
/// ```
public static let isButton: AccessibilityTraits = { fatalError() }()  // ✅

/// Adds a trait to this set.
/// ```swift
/// var traits = AccessibilityTraits()
/// traits.insert(.isButton)
/// ```
public mutating func insert(_ newMember: AccessibilityTraits) -> ... { }  // ✅
```

When documenting a file, document it COMPLETELY from top to bottom. Don't rush at the end. If you have 15 static properties and 10 protocol methods, all 25 symbols get examples.

**ABSOLUTELY NO PARTIAL FILE DOCUMENTATION.**

NEVER say things like:
- "I'll document the core initializers"
- "Let me document the main parts"
- "I'll focus on the important methods"
- "I'll get to the rest later"
- "Text.swift is huge, let me just document the essential parts"

**If you open a file to document it, you document EVERY SINGLE SYMBOL in that file. Period.**

The goal of this project is complete, comprehensive documentation of EVERYTHING. If a file has 50 methods, you document all 50. If it has nested enums with 20 cases each, you document all of them. No shortcuts. No "main parts only".

**CRITICAL: Nested types need examples too!**

If your type contains nested structs, enums, or classes (like `DragGesture.Value`), document those nested types with examples just like you would any other type. Don't just document the properties inside - document the nested type itself.

**Bad (nested type without documentation):**
```swift
public struct DragGesture {
    public struct Value {  // ❌ No documentation on the struct itself
        public var location: CGPoint  // ✅ Has documentation
    }
}
```

**Good (nested type properly documented):**
```swift
public struct DragGesture {
    /// The value provided during a drag gesture.
    ///
    /// Contains information about the drag state...
    /// ```swift
    /// DragGesture()
    ///     .onChanged { value in
    ///         print(value.translation)
    ///     }
    /// ```
    public struct Value {  // ✅ Documented with example
        public var location: CGPoint  // ✅ Has documentation
    }
}
```

**CRITICAL: EVERY enum case needs its OWN complete example!**

Do NOT just show the enum case being passed to a function. Show a COMPLETE example with full View context
that demonstrates WHEN and WHY you'd use THAT SPECIFIC CASE.

**Bad (lazy enum case documentation):**
```swift
public enum Orientation {
    /// The image is rotated right.
    /// ```swift
    /// Image(cgImage, scale: 1.0, orientation: .right, label: Text("Photo"))
    /// ```
    case right  // ❌ Just shows passing it to init, doesn't show WHEN/WHY
}
```

**Good (complete enum case documentation):**
```swift
public enum Orientation {
    /// The image is rotated 90 degrees clockwise.
    ///
    /// Use this when the camera was held with the right edge at the top. Common for landscape
    /// photos taken with the device rotated right.
    ///
    /// ```swift
    /// struct RightRotatedView: View {
    ///     let landscapePhoto: CGImage
    ///     
    ///     var body: some View {
    ///         Image(landscapePhoto, scale: 2.0, orientation: .right, label: Text("Landscape"))
    ///             .resizable()
    ///             .scaledToFit()
    ///     }
    /// }
    /// ```
    case right  // ✅ Shows complete context, explains WHEN to use this case
}
```

The good example:
- Explains what the case DOES
- Explains WHEN you'd use it
- Shows COMPLETE View context
- Uses a descriptive variable name that makes sense for this case
- Shows the result/behavior

The example should:
- Be realistic (not `foo()` or `doSomething()`)
- Be simple enough to grasp in 2 seconds
- Demonstrate the most common use case
- Use meaningful names
- Show the complete cycle for composition/architectural patterns
- **Show the full View context** - wrap examples in a ContentView or struct so developers see WHERE the code goes

### 8a. Show Full View Context

**CRITICAL: Almost EVERY example should show full View context with struct and body.**

Don't write floating code snippets that leave developers wondering WHERE this code goes. Show them the complete picture - a View struct with a body that demonstrates the API in realistic context.

**Bad (floating snippet):**
```swift
/// ```swift
/// var path = Path()
/// path.move(to: CGPoint(x: 50, y: 50))
/// path.addLine(to: CGPoint(x: 100, y: 100))
/// ```
```

WHERE does this code go? In a function? In a View? Developers don't know.

**Good (full View context):**
```swift
/// ```swift
/// struct CustomShapeView: View {
///     var body: some View {
///         Path { path in
///             path.move(to: CGPoint(x: 50, y: 50))
///             path.addLine(to: CGPoint(x: 100, y: 100))
///         }
///         .stroke(.blue, lineWidth: 2)
///     }
/// }
/// ```
```

Now developers see exactly where and how to use this.

**ONLY skip View context for:**
- Pure utility functions unrelated to views
- Property declarations with @State/@Binding (clear context)
- Tests or non-view code
- When it genuinely would be confusing

**Default assumption: SHOW THE VIEW.** If you're not sure, include it.

### 8aa. ALWAYS Show Both Normal AND Direct Usage

**CRITICAL: For any symbol that has both indirect (convenient) usage and direct usage, ALWAYS show both.**

This is one of the most important patterns in documentation. Many developers will only ever use the indirect/convenient form, but some will need to understand how to call the API directly for advanced use cases.

**The Pattern (ALWAYS follow this for ALL symbols):**

1. **Show normal/indirect usage** - How most developers interact with this (syntactic sugar, convenience APIs, higher-level wrappers)
2. **Show direct usage** - When and why you'd call it explicitly
3. **Explain the details** - What makes this work, why both exist

**Examples where this applies:**

**Property wrappers (`wrappedValue`, `projectedValue`):**
- Normal: `count += 1` (automatic)
- Direct: `_count.wrappedValue += 1` (explicit access)

**Shape methods (`inset(by:)`):**
- Normal: `.strokeBorder(.blue, lineWidth: 4)` (uses inset internally)
- Direct: `.inset(by: 10)` (explicit call for custom effects)

**Convenience vs explicit initializers:**
- Normal: High-level initializer with common defaults
- Direct: Low-level initializer with all parameters

**Protocol conformance methods (`path(in:)` on Shape):**
- Normal: SwiftUI calls it automatically when rendering
- Direct: You can call it to get the path for custom drawing

**Why this matters:**

Developers reading documentation for a specific symbol want to understand THAT symbol, not just be redirected to convenient alternatives. If someone is reading docs for `.inset(by:)`, they likely need to use it directly, even though `.strokeBorder()` is more common.

**Bad (only shows indirect usage):**
```swift
/// Returns a circle inset by the specified amount.
///
/// This is used by `.strokeBorder()` to keep strokes inside bounds:
/// ```swift
/// Circle().strokeBorder(.blue, lineWidth: 4)
/// ```
public func inset(by amount: CGFloat) -> some InsettableShape
```

**Good (shows both indirect AND direct):**
```swift
/// Returns a circle inset by the specified amount.
///
/// **Normal usage (indirect via `.strokeBorder()`):**
/// ```swift
/// Circle().strokeBorder(.blue, lineWidth: 4)
/// ```
///
/// **Direct usage (calling `.inset()` explicitly):**
/// ```swift
/// Circle()
///     .inset(by: 10)
///     .fill(.white)
/// ```
///
/// This creates a white circle 10 points smaller than the frame.
public func inset(by amount: CGFloat) -> some InsettableShape
```

The good example teaches both patterns, so developers understand the full picture.

### 8b. Explain What Happens, Not Just What To Write

**Crystal-clear examples don't just show code - they explain what happens when it runs.**

Developers need to understand cause and effect, execution flow, and how SwiftUI responds to their code.

**Bad (just shows code):**
```swift
/// ```swift
/// struct ContentView: View {
///     @State private var count = 0
///     
///     var body: some View {
///         Button("Increment") {
///             count += 1
///         }
///     }
/// }
/// ```
```

**Good (explains what happens):**
```swift
/// ```swift
/// struct ContentView: View {
///     @State private var count = 0
///     
///     var body: some View {
///         Button("Increment") {
///             count += 1
///         }
///     }
/// }
/// ```
///
/// When you tap the button, `count` increments to 1. This modification causes SwiftUI
/// to invalidate `ContentView` and recompute its `body`. The button now displays the
/// updated count value.
```

The good example explains the chain: user action → state change → view invalidation → UI update.

**Patterns for explaining what happens:**

**Cause and effect:**
- "Modifying `@State` causes the view's `body` to be recomputed"
- "When the button triggers, the action closure executes"
- "This binding allows `TextField` to read AND write the state"

**Execution flow:**
- "When `foo` updates, SwiftUI recomputes `ExampleView`'s body"
- "The new body is queued for the next render cycle"
- "On render, the view's display updates on screen"

**What SwiftUI does for you:**
- "This initializer creates a `Text` view on your behalf"
- "SwiftUI automatically applies red styling with bordered button styles"
- "The system reads the button's label and role for VoiceOver"

**Progressive building:**
- Start with simplest case
- Add one concept at a time
- Build up to complete patterns
- Each example adds ONE new thing

**Use inline notes for critical details:**
```swift
/// Note:
/// - Recomputing the `body` is also frequently referred to as "invalidating the view"
/// - While all SwiftUI views are value types, `@State` creates reference-based storage
```

### 8c. Examples Must Actually Compile

**CRITICAL: Every example you write MUST be valid, compilable Swift code. No exceptions.**

If you write an example that wouldn't compile, you're failing at documentation. Period.

**CRITICAL: Print Statements Must Show Output**

**Whenever you use `print()` in an example, ALWAYS add a comment showing what it outputs:**

```swift
print(value) // 5
print(type(of: shape)) // Circle
print(offset) // CGSize(width: 10.0, height: 20.0)
```

This helps developers understand what the code actually produces. Never write `print()` without the output comment.

**CRITICAL: Multi-Line Function Call Formatting**

**When breaking function calls across multiple lines, put parameters on new lines AFTER the opening parenthesis:**

```swift
// ✅ CORRECT
TransformedShape(
    shape: Ellipse(),
    transform: CGAffineTransform(translationX: 10, y: 20)
)

Button("Save") {
    save()
}

// ❌ WRONG - Don't align with opening parenthesis
TransformedShape(shape: Ellipse(), 
                transform: CGAffineTransform(translationX: 10, y: 20))
```

The correct format puts each parameter on its own line, indented once, after a line break following the opening parenthesis.

**Bad (wouldn't compile):**
```swift
/// ```swift
/// let binding = Binding(
///     get: { value },           // ❌ Where is 'value' defined?
///     set: { newValue in
///         print(transaction)     // ❌ Where is 'transaction'?
///         value = newValue       // ❌ Can't assign to undefined variable
///     }
/// )
/// ```
```

**Good (compiles and runs):**
```swift
/// ```swift
/// struct TransactionView: View {
///     @State private var value = 0.5
///     
///     var body: some View {
///         let binding = $value
///         Slider(value: binding, in: 0...1)
///     }
/// }
/// ```
```

**Before writing ANY example:**
1. Think through the context - where do variables come from?
2. Make sure all referenced values exist
3. Verify types match
4. Check that the syntax is valid
5. **If you're not 100% sure it compiles, DON'T WRITE IT**

**Common mistakes that break compilation:**
- Referencing undefined variables
- Using properties/methods that don't exist in scope
- Type mismatches
- Missing imports or context
- Closure capture issues

**If your example needs context to compile, SHOW THE CONTEXT.** That's why we use full View structs.

### 8d. Minimal Examples with Descriptive Names

**Show the absolute minimum needed to demonstrate the concept. Name things descriptively.**

**Bad (too much unrelated code):**
```swift
/// ```swift
/// struct ContentView: View {
///     @State private var count = 0
///     @State private var username = ""
///     @Environment(\.colorScheme) var colorScheme
///     
///     var body: some View {
///         VStack(spacing: 20) {
///             Text("Count: \(count)")
///                 .font(.title)
///                 .foregroundStyle(.primary)
///             
///             Button("Increment") {
///                 count += 1
///             }
///             .buttonStyle(.borderedProminent)
///             .controlSize(.large)
///         }
///         .padding()
///         .background(Color.gray.opacity(0.1))
///     }
/// }
/// ```
```

This has styling, padding, extra state, and environment values that distract from the core concept.

**Good (minimal and focused):**
```swift
/// ```swift
/// struct CounterView: View {
///     @State private var count = 0
///     
///     var body: some View {
///         Button("Increment") {
///             count += 1
///         }
///     }
/// }
/// ```
```

This shows ONLY what's needed: state, button, action. The name `CounterView` describes what it does.

**Naming guidelines:**

**Descriptive view names based on purpose:**
- `SignInView` - Shows a sign-in button
- `PlayerView` - Shows player controls
- `CounterView` - Shows a counter
- `NameInputView` - Collects name input
- `SettingsView` - Settings toggles

**NOT generic names for everything:**
- ❌ `ContentView` for every example
- ❌ `MyView`, `ExampleView`, `TestView` (unless it truly is just an example)
- ❌ `View1`, `View2`, `View3`

**Meaningful variable names:**
- `isEnabled`, `showingAlert`, `selectedItem` (describes state)
- `userName`, `emailAddress`, `password` (describes data)
- NOT `foo`, `bar`, `temp`, `x`, `myVar`

**Keep examples minimal:**
- No `.padding()` unless demonstrating padding
- No `.font()` unless demonstrating fonts
- No extra `@State` variables unrelated to the concept
- No navigation, sheets, or alerts unless that's the point
- No styling modifiers unless showing styling

**Exception:** Add just enough context to make it realistic:
```swift
/// ```swift
/// struct ListView: View {
///     let items = [Item(title: "🍌"), Item(title: "🍑")]
///     
///     var body: some View {
///         List {
///             ForEach(items) { item in
///                 Text(item.title)
///             }
///             Button("Add Item") { }
///         }
///     }
/// }
/// ```
```

This includes `items` array because it makes the List example realistic and clear, but nothing more.

**Good (shows context):**
```swift
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Button("Save") {
///             saveDocument()
///         }
///     }
/// }
/// ```
```

**Bad (floating snippet):**
```swift
/// ```swift
/// Button("Save") {
///     saveDocument()
/// }
/// ```
```

**Exceptions where floating snippets are OK:**

**Property declarations with @State/@Binding:**
```swift
/// ```swift
/// @State private var count = 0
/// ```
```
This is clear because property wrappers only go at property declaration level.

**Custom initializers showing the struct:**
```swift
/// ```swift
/// struct CounterView: View {
///     @State private var count: Int
///     
///     init(startingCount: Int) {
///         _count = State(initialValue: startingCount)
///     }
/// }
/// ```
```
This needs to show the full struct, not just the body.

**Generic functions or utilities:**
```swift
/// ```swift
/// func createDefaultState<T>(_ defaultValue: T) -> State<T> {
///     State(wrappedValue: defaultValue)
/// }
/// ```
```
These aren't View code.

**For properties:** Even if the property is typically set through an initializer, show how to access it:

```swift
/// ```swift
/// let spacer = Spacer(minLength: 20)
/// print(spacer.minLength)
/// ```
```

**General rule:** If it goes in a View's body, show it in a View's body. If it's a declaration/definition, show the declaration context.

### 8a. Documenting Property Wrapper wrappedValue and projectedValue

**These are THE MOST confusing properties in SwiftUI. You must be crystal clear about what they do and when to access them directly.**

Property wrappers like `@State` and `@Binding` have special syntax that hides direct access to these properties. Developers reading the docs for `wrappedValue` or `projectedValue` are trying to understand the MECHANISM, not just how to use the property wrapper.

**Critical points to cover:**

1. **Explain the automatic access first:**
   ```swift
   /// When you have `@Binding var volume: Double`, the property wrapper gives you automatic access:
   /// - `volume` → reads/writes the wrapped Double value (this property)
   /// - `$volume` → accesses the Binding itself (projectedValue property)
   ```

2. **Show what Swift does behind the scenes:**
   ```swift
   /// When you write `volume`, Swift automatically calls `_volume.wrappedValue` behind the scenes.
   ```

3. **Explain WHEN you directly access these (rare but real scenarios):**
   ```swift
   /// **Direct access - only when passing Binding structs around without @Binding:**
   ///
   /// ```swift
   /// func updateValue(in binding: Binding<Double>, to newValue: Double) {
   ///     binding.wrappedValue = newValue
   /// }
   /// ```
   ///
   /// You rarely write `.wrappedValue` explicitly - it's mainly for when you have a `Binding<T>`
   /// as a regular parameter (not with `@Binding`).
   ```

4. **For projectedValue, explain what it RETURNS and WHY:**
   ```swift
   /// **Why this exists:** A child view with `@Binding` needs to receive a `Binding<Int>`, not
   /// just an `Int`. The `$` prefix gets you that Binding to pass along.
   ```

5. **Call out differences between property wrappers:**
   ```swift
   /// For `@Binding`, the projected value is just the binding itself - unlike `@State` where
   /// the projected value creates a NEW binding.
   ```

**Bad (vague and unhelpful):**
```swift
/// The wrapped value.
///
/// Access this using the property name.
public var wrappedValue: Value { get set }
```

**Good (explains the mechanism):**
```swift
/// The underlying value that this binding reads and writes.
///
/// When you have `@Binding var volume: Double`, the property wrapper gives you automatic access:
/// - `volume` → reads/writes the wrapped Double value (this property)
/// - `$volume` → accesses the Binding itself (projectedValue property)
///
/// When you write `volume`, Swift automatically calls `_volume.wrappedValue` behind the scenes.
///
/// **Direct access - only when passing Binding structs around without @Binding:**
/// [show when you'd actually call .wrappedValue]
public var wrappedValue: Value { get set }
```

### 8b. No Throwaway Documentation for Niche Properties

**If someone is reading documentation for a specific property or method, they want to understand THAT property, not just be redirected to general usage.**

This is especially important for properties that are usually accessed indirectly (like `wrappedValue` and `projectedValue` in property wrappers).

**Pattern to follow:**
1. **Show normal usage** - How most developers interact with this (via syntactic sugar)
2. **Show direct access** - When and why you'd access it explicitly
3. **Explain the details** - What makes this property special or unique

### 8b. No Duplicate Examples with Trivial Changes

**When documenting similar APIs (like `init(wrappedValue:)` vs `init(initialValue:)`), you must show GENUINELY DIFFERENT use cases, not the same example with parameter names changed.**

This is lazy documentation that wastes the developer's time. They're reading both APIs to understand WHEN to use one vs the other - so show them different contexts.

**Bad (same example, different parameter name):**
```swift
/// init(wrappedValue:)
/// ```swift
/// struct CounterView: View {
///     init(startingCount: Int) {
///         _count = State(wrappedValue: startingCount)
///     }
/// }
/// ```

/// init(initialValue:)
/// ```swift
/// struct CounterView: View {
///     init(startingCount: Int) {
///         _count = State(initialValue: startingCount)
///     }
/// }
/// ```
```

These show the EXACT SAME use case. The only difference is the parameter name. Not helpful.

**Good (genuinely different contexts):**
```swift
/// init(wrappedValue:)
/// Use this for testing, generic utilities, and working with State outside views:
/// ```swift
/// func testCounterLogic() {
///     let counter = State(wrappedValue: 0)
///     counter.wrappedValue += 1
///     assert(counter.wrappedValue == 1)
/// }
/// 
/// func duplicateState<T>(_ original: State<T>) -> State<T> {
///     State(wrappedValue: original.wrappedValue)
/// }
/// ```

/// init(initialValue:)
/// Use this in custom view initializers to set state from parameters:
/// ```swift
/// struct ItemEditor: View {
///     @State private var name: String
///     
///     init(item: Item) {
///         _name = State(initialValue: item.name)
///     }
/// }
/// ```
```

These show DIFFERENT contexts: testing/utilities vs view initialization.

**Before documenting similar APIs, ask yourself:**
- Am I just changing variable names?
- Are these genuinely different use cases?
- Would a developer learn something new from the second example?
- What makes THIS variant the right choice over the other one?

**This applies to:**
- Similar initializers (`wrappedValue` vs `initialValue`)
- Overloaded methods with different parameter types
- Convenience APIs vs full-featured variants
- Methods that differ only in optionality or default parameters

**Bad (throwaway documentation):**
```swift
/// The underlying value.
///
/// Access this using the property name:
/// ```swift
/// @State private var count = 0
/// count += 1
/// ```
public var wrappedValue: Value { get set }
```

**Good (comprehensive with normal AND niche usage):**
```swift
/// The underlying value that SwiftUI stores and updates.
///
/// **Normal usage:** The property wrapper syntax automatically accesses this for you.
/// You read and write `count`, and Swift translates it to `_count.wrappedValue`:
///
/// ```swift
/// @State private var count = 0
/// Button("Count: \(count)") {
///     count += 1
/// }
/// ```
///
/// **Direct access:** You can explicitly access `.wrappedValue` when working with the
/// State struct itself (prefixed with `_`). This is rare but useful when you need to
/// pass or manipulate the State container:
///
/// ```swift
/// func logStateValue(_ state: State<Bool>) {
///     print("Current value: \(state.wrappedValue)")
/// }
/// 
/// _isEnabled.wrappedValue.toggle()
/// ```
public var wrappedValue: Value { get set }
```

The good example shows:
- How it's normally used (implicitly)
- How to access it directly (explicitly) 
- When you'd need direct access
- Real examples of both patterns

**This applies to:**
- Property wrapper `wrappedValue` and `projectedValue`
- Properties with special access patterns
- Lower-level APIs that have higher-level conveniences
- Implementation details that developers might need to understand

### 9. Make Every Symbol Engaging - Explain WHY It Exists

**NEVER write lazy, boilerplate documentation. Every symbol should explain WHY it exists and what it enables.**

Even "boring" protocol conformances have a purpose. Tell developers what that purpose is.

**Bad (lazy boilerplate):**
```swift
/// The position of the first element.
public var startIndex: Index { }
```

**Good (engaging, explains purpose):**
```swift
/// The position of the first element in the wrapped collection.
///
/// **Exposes the underlying collection's start index through the binding.** You rarely access this
/// directly - typically you use integer indices like `$items[0]` - but it's essential for generic
/// collection algorithms that work with any Collection type.
///
/// ```swift
/// struct SafeFirstEditor: View {
///     @Binding var items: [String]
///     
///     var body: some View {
///         if !items.isEmpty {
///             TextField("First", text: $items[items.startIndex])
///         }
///     }
/// }
/// ```
public var startIndex: Index { }
```

**Patterns for making documentation engaging:**

**Explain what it unlocks:**
- "This is what makes `ForEach($todos)` work"
- "This is the magic that makes `$items[0]` return a `Binding<String>`"
- "Without this, you couldn't edit individual array elements through bindings"

**Explain the purpose:**
- "Essential for generic collection algorithms"
- "Enables backward traversal through binding collections"
- "Marks the boundary for safe iteration"

**Contrast with common usage:**
- "You rarely access this directly - typically you use `$items[0]` - but..."
- "Though `ForEach` handles this automatically in most SwiftUI code..."
- "Most SwiftUI code uses `ForEach` or direct indexing instead"

**Explain performance or design trade-offs:**
- "Mutating version for performance when advancing repeatedly"
- "Modifies in place instead of creating a new one each time"

**Questions to answer in EVERY doc comment:**
- Why does this symbol exist?
- What does it enable or unlock?
- How does it fit into the bigger picture?
- When would a developer actually use this?
- What would be missing without it?

### 10. Extensions Are Not Documented

**Do NOT add documentation comments to extension declarations. Only document the members inside them.**

Extensions are organizational constructs, not APIs that developers use directly. Document the actual symbols (properties, methods, initializers) within the extension, not the extension itself.

**Bad (documenting the extension):**
```swift
/// When the wrapped value is Identifiable, the binding itself becomes Identifiable.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Identifiable where Value : Identifiable {
    public var id: Value.ID { fatalError() }
}
```

**Good (only documenting the member):**
```swift
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Binding : Identifiable where Value : Identifiable {

    /// The identity of the wrapped value.
    ///
    /// Forwards to the wrapped value's `id` property...
    public var id: Value.ID { fatalError() }
}
```

**Exception:** If the extension adds significant functionality that needs overview explanation, put that
in the main type's documentation, not on the extension itself.

### 11. No Obvious Comments

Never state the obvious or add comments that just restate the code.

**Bad:**
```swift
/// This initializer creates a button
/// - Parameter action: The action
/// - Parameter label: The label
```

**Good:**
```swift
/// Use this when you need anything beyond plain text - icons, images, custom layouts, etc.
/// This is your go-to for building visually rich buttons.
```

### 10. Structure

Organize documentation with this structure:

1. **One-line summary** (what it is)
2. **Discussion/Detailed description** (context, when to use, why it exists, how it works, real-world guidance)
3. **Example** (at least one, showing most common usage)
4. **Parameters** (if applicable)
5. **Returns** (if applicable)

**Every symbol MUST have discussion between the summary and example.** The discussion explains:
- WHEN to use this variant vs others
- WHY it exists (what problem does it solve?)
- HOW it works (what does it do?)
- WHAT makes it different from alternatives

For type documentation, add these sections after the summary:
- **Basic Usage**
- **Available Options** (styles, modes, etc.)
- **Common Patterns**
- **Accessibility** (if relevant)
- **Integration Points** (where it's used: alerts, toolbars, etc.)

## Template

### For Types

```swift
/// One-line description of what this type is.
///
/// Comprehensive explanation covering where it's used, when to use it,
/// and key concepts developers need to understand.
///
/// ## Basic Usage
///
/// ```swift
/// // Simplest possible example
/// ```
///
/// ## Available Options
///
/// List all styles, modes, configurations with brief descriptions.
///
/// ## Common Patterns
///
/// Real-world usage patterns, including:
/// - Async operations
/// - State management
/// - Accessibility
///
/// ## Integration Points
///
/// Where this appears: toolbars, alerts, etc.
```

### For Methods/Initializers

```swift
/// One-line description emphasizing WHEN and WHY to use this variant.
///
/// Additional context explaining what makes this different from other variants
/// and providing guidance on choosing between options.
///
/// - Parameters:
///   - param1: Clear description with valid values
///   - param2: Clear description with type info if needed
///
/// ```swift
/// // Crystal clear example
/// ```
```

## The LocalizedStringKey vs StringProtocol Pattern

This is a **universal SwiftUI pattern** that appears in virtually every text-based control (Button, Toggle, TextField, Label, Text, etc.). You'll document this pair of initializers hundreds of times, so it's critical to get it right.

### The Pattern

Most SwiftUI views with text labels have two nearly identical initializers:

```swift
public init(_ titleKey: LocalizedStringKey, ...) { }
public init<S>(_ title: S, ...) where S : StringProtocol { }
```

### What Developers Need to Understand

1. **They don't choose** - Swift's type inference automatically picks the right initializer
2. **Literals → LocalizedStringKey** - `"Save"` becomes a key for translation lookup
3. **Variables → StringProtocol** - `userName` displays its value directly without localization
4. **This is intentional** - Variables contain final display text, not lookup keys

### How to Document This Pair

**For the LocalizedStringKey variant:**

```swift
/// Creates a [control] with a localizable text label.
///
/// **Automatically used when you pass a string literal.** Swift's type system sees `"Save"`
/// and treats it as a `LocalizedStringKey`, which means it looks up translations in your
/// Localizable.strings file. If you don't have translations, it displays the literal text.
///
/// This is the most common [control] initializer - use it for any hardcoded text that should
/// support multiple languages.
///
/// - Parameters:
///   - titleKey: The localized string key for the [control]'s label. String literals automatically become localized keys.
///   - [other params]: ...
///
/// ```swift
/// Button("Save") {
///     document.save()
/// }
/// ```
```

**For the StringProtocol variant:**

```swift
/// Creates a [control] with dynamic text from a variable.
///
/// **Automatically used when you pass a variable or property.** Unlike the literal variant,
/// this displays the variable's value directly without attempting localization. This is exactly
/// what you want - if `userName` is "John Smith", you want to display "John Smith", not look it
/// up as a translation key.
///
/// Swift's type inference handles this automatically. You don't choose between these initializers -
/// Swift picks the right one based on whether you pass `"literal"` or `variable`.
///
/// - Parameters:
///   - title: The string to display as the [control]'s label. Displays the value as-is without localization.
///   - [other params]: ...
///
/// ```swift
/// Button(user.displayName) {
///     viewProfile()
/// }
/// ```
```

### Key Phrases to Use Consistently

- **LocalizedStringKey:** "Automatically used when you pass a string literal"
- **StringProtocol:** "Automatically used when you pass a variable or property"
- **Both:** Emphasize that Swift chooses automatically via type inference
- **LocalizedStringKey:** "String literals automatically become localized keys"
- **StringProtocol:** "Displays the value as-is without localization"

### Why This Matters

Developers see two similar initializers and wonder "which one do I use?" The answer is: **they don't choose**.
Swift makes the choice based on what they pass. Our documentation must make this crystal clear, otherwise
developers think they need to make a conscious decision when they don't.

### Example Usage in Practice

```swift
Button("Save") { }              // Swift uses LocalizedStringKey variant
Button(userName) { }             // Swift uses StringProtocol variant
Button("\(count) items") { }     // Swift uses StringProtocol variant (interpolation creates String)
```

The third example is subtle but important: string interpolation produces a `String`, not a `LocalizedStringKey`,
so it uses the StringProtocol variant and won't localize. This is usually correct - you want to display "5 items",
not look up "5 items" as a translation key.

## Anti-Patterns to Avoid

1. ❌ Documentation that just repeats the method signature
2. ❌ Mechanically documenting parameters without explaining design decisions
3. ❌ Examples with unrelated complexity (async, navigation, styling all mixed)
4. ❌ Incomplete fragments for composition patterns (show the complete cycle!)
5. ❌ Vague guidance like "use this for buttons"
6. ❌ Missing information about available options
7. ❌ No explanation of when to use one variant vs another
8. ❌ Not explaining when NOT to use something
9. ❌ Failing to explain why optional parameters are optional
10. ❌ Legacy syntax or deprecated APIs
11. ❌ Obvious comments in code
12. ❌ Missing parameter documentation
13. ❌ No examples
14. ❌ Examples with placeholder names like `foo()` or `doSomething()`
15. ❌ Not being honest about how rare/common a use case is
16. ❌ Failing to explain architectural patterns (composition, delegation, etc.)
17. ❌ **Not explaining that Swift automatically chooses between LocalizedStringKey and StringProtocol variants**
18. ❌ **Making it sound like developers need to consciously choose between literal/variable initializers**
19. ❌ **Throwaway documentation for niche properties - only showing normal usage without direct access patterns**
20. ❌ **ONLY showing indirect/convenient usage without showing how to call the API directly (CRITICAL - always show both!)**
21. ❌ **Dismissing APIs as "rare" or "legacy" without researching actual use cases first**
22. ❌ **Assuming something isn't useful just because you can't immediately think of when to use it**
23. ❌ **Duplicating the same example across similar APIs with only trivial changes (like parameter names)**
24. ❌ **Not thinking about what makes each API variant genuinely different before writing examples**
25. ❌ **Missing examples for properties - EVERY symbol needs an example, including stored/computed properties**
26. ❌ **Assuming API behavior based on naming instead of verifying actual behavior**
27. ❌ **Not documenting gotchas and surprising defaults that trip developers up**
28. ❌ **Burying important gotchas in the middle of documentation instead of calling them out with "Important:" or similar**
29. ❌ **Writing academic API descriptions instead of solving developer problems**
30. ❌ **Not thinking about what developers will try that won't work**
31. ❌ **Missing copy-paste-able patterns that developers can immediately use**
32. ❌ **Showing floating code snippets without View context when it would help understanding**
33. ❌ **Just showing code without explaining what happens when it runs**
34. ❌ **Not explaining cause and effect chains (user action → state change → view update)**
35. ❌ **Missing the "what SwiftUI does for you" explanations**
36. ❌ **Using generic names like `ContentView` for everything instead of descriptive names**
37. ❌ **Examples with extraneous code, styling, or state that distracts from the concept**
38. ❌ **Using `foo`, `bar`, or meaningless variable names instead of descriptive ones**
39. ❌ **USING OLD APIS - `PreviewProvider`, `ObservableObject`, `NavigationView`, completion handlers, etc.**
40. ❌ **Not verifying you're using the iOS 17+ version of an API**
41. ❌ **Using deprecated modifiers like `.foregroundColor()` instead of `.foregroundStyle()`**
42. ❌ **EXAMPLES THAT WOULDN'T COMPILE - undefined variables, missing context, type errors**
43. ❌ **Not thinking through whether your example is actually valid Swift code**
44. ❌ **Vague wrappedValue/projectedValue docs that don't explain the mechanism or when to use direct access**
45. ❌ **Not explaining what Swift does behind the scenes with property wrapper syntax**
46. ❌ **Not calling out differences between property wrappers (State vs Binding projected values)**
47. ❌ **MISSING PARAMETER DOCUMENTATION - every function/initializer parameter must be documented**
48. ❌ **Using wrong format - Parameters (plural) vs Parameter (singular)**
49. ❌ **Adding documentation comments to extension declarations instead of just their members**
50. ❌ **Adding terrible examples just to have an example - garbage examples are worse than no example**
51. ❌ **Examples that no developer would ever actually write in real code**
52. ❌ **Lazy boilerplate documentation that doesn't explain WHY a symbol exists**
53. ❌ **Just describing what something does without explaining what it enables or unlocks**
54. ❌ **Not contrasting with how developers typically use the feature**
55. ❌ **Missing the "this is what makes X work" explanations for protocol conformances**
56. ❌ **Skipping examples for protocol conformance methods - they need examples too!**
57. ❌ **Getting lazy at the end of a file - document EVERY symbol from top to bottom**
58. ❌ **Assuming "boilerplate" or "inherited" methods don't need examples**
59. ❌ **Not documenting nested types (Value structs, Configuration enums, etc.) - they need examples too!**
60. ❌ **Only documenting the properties inside a nested type without documenting the type itself**
61. ❌ **Lazy enum case documentation - just showing the case passed to init without full View context**
62. ❌ **Enum cases without explanation of WHEN and WHY you'd use that specific case**
63. ❌ **One-line enum case examples instead of complete View examples showing real usage**
64. ❌ **Using labeled closure parameters instead of multiple trailing closures (onIncrement: {}, etc.)**
65. ❌ **Old closure syntax - not using modern multiple trailing closure syntax**
66. ❌ **Documentation with just a title and example, no discussion in between**
67. ❌ **Not explaining WHEN to use this variant, WHY it exists, or HOW it works**
68. ❌ **Missing the discussion that connects the summary to the example**
69. ❌ **PARTIAL FILE DOCUMENTATION - saying "I'll document the main parts" or "core features only"**
70. ❌ **Leaving any symbol undocumented in a file you opened to document**
71. ❌ **"I'll get to the rest later" - NO! Document EVERY symbol NOW or don't open the file**
72. ❌ **Floating code snippets without View context when View context would help**
73. ❌ **Not showing WHERE code actually goes - examples need full struct/body context**
74. ❌ **Lazy snippets like `var path = Path()` without wrapping in a View**

## Pre-Documentation Checklist

Before writing documentation for ANY symbol, verify:

**Research Phase:**
- [ ] Read Apple's official documentation for this symbol
- [ ] **Verify this is the iOS 17+ modern API (not deprecated or superseded)**
- [ ] Search Stack Overflow for common questions and gotchas
- [ ] Check if there are platform-specific differences
- [ ] Look for "doesn't work" or "unexpected behavior" patterns
- [ ] Identify what developers would naturally expect vs actual behavior

**Developer Pain Point Analysis:**
- [ ] What will developers try first that WON'T work?
- [ ] What assumptions will they make that are WRONG?
- [ ] What's the most common mistake with this API?
- [ ] What search terms would lead them here when stuck?
- [ ] What copy-paste-able pattern can you provide?

**For Similar APIs (like multiple initializers):**
- [ ] Can you explain WHEN to use each variant?
- [ ] Are your examples genuinely different contexts, not just renamed variables?
- [ ] Do you understand what makes each variant the right choice?

**Before Calling Something "Rare":**
- [ ] Have you researched actual use cases?
- [ ] Have you checked real-world code examples?
- [ ] Can you confirm it's genuinely uncommon and not just unfamiliar to you?

**Parameter Documentation:**
- [ ] **Did you document ALL parameters?**
- [ ] Did you use `- Parameters:` (plural) for multiple params?
- [ ] Did you use `- Parameter:` (singular) for single param?
- [ ] For optional parameters, did you explain WHY they're optional?

**Documentation Quality:**
- [ ] **Does EVERY symbol have discussion between summary and example?**
- [ ] **Does the discussion explain WHEN to use it, WHY it exists, and HOW it works?**
- [ ] Did you explain WHY this symbol exists, not just what it does?
- [ ] Did you explain what this symbol enables or unlocks?
- [ ] For protocol conformances, did you explain what they make possible?
- [ ] Did you use engaging language like "This is what makes X work" or "This is the magic that..."?
- [ ] Did you contrast with how developers typically use the feature?

**Example Quality:**
- [ ] **WOULD YOUR EXAMPLE ACTUALLY COMPILE? All variables defined? Types correct? Valid syntax?**
- [ ] Does EVERY symbol have at least one example? (types, methods, properties, initializers)
- [ ] **Did you document the ENTIRE file from top to bottom? No getting lazy at the end?**
- [ ] **Do nested types have documentation and examples? (Value structs, Configuration enums, etc.)**
- [ ] **Does EVERY enum case have its OWN complete example with full View context?**
- [ ] **Do enum case examples explain WHEN and WHY you'd use that specific case?**
- [ ] **Do protocol conformance methods have examples? (SetAlgebra, Collection, etc.)**
- [ ] Are examples realistic with meaningful names (not `foo()` or `doSomething()`)?
- [ ] For composition patterns, do you show the complete cycle?
- [ ] **For ANY symbol with indirect/convenient usage, do you show BOTH normal AND direct usage?**
- [ ] For properties with syntactic sugar, do you show both normal AND direct access?
- [ ] **Do examples show full View context (struct with body)? NOT floating snippets!**
- [ ] **Did you avoid lazy floating snippets like `var path = Path()` without View wrapper?**
- [ ] Do you explain what happens when the code runs (cause → effect)?
- [ ] Do you explain what SwiftUI does automatically behind the scenes?
- [ ] Are examples absolutely minimal - no extraneous styling, modifiers, or state?
- [ ] Do view names describe their purpose (SignInView, PlayerView, not ContentView for everything)?
- [ ] Are variable names descriptive (isEnabled, userName, not foo, temp, x)?
- [ ] **Are you using iOS 17+ modern APIs? (`#Preview`, `@Observable`, `NavigationStack`, etc.)**
- [ ] **Are you using modern modifiers? (`.foregroundStyle()` not `.foregroundColor()`)**
- [ ] **Are you using multiple trailing closure syntax? (Button { } label: { }, not action: { }, label: { })**
- [ ] **No completion handlers - only async/await?**

**Gotchas and Surprises:**
- [ ] Have you identified surprising defaults or behavior?
- [ ] Are gotchas marked prominently with **Important:** or similar?
- [ ] Do you explain WHY something works the way it does?

## Examples of Excellent Documentation

See these files for comprehensive examples following all these guidelines:
- `Sources/Swiftipedia/Views/Controls and Indicators/Button.swift` - Complete control documentation with all patterns
- `Sources/Swiftipedia/Views/Controls and Indicators/Toggle.swift` - Control showing consistent LocalizedStringKey/StringProtocol documentation
- `Sources/Swiftipedia/Data and Storage/Model Data/State.swift` - Property wrapper showing both normal and direct access patterns for wrappedValue/projectedValue
- `Sources/Swiftipedia/Data and Storage/Model Data/Binding.swift` - Complex type with custom initializers, protocol conformances, and advanced patterns
- `Sources/Swiftipedia/View Layout/Layout Fundamentals/Spacer.swift` - Layout component with comprehensive "when to use" vs "when NOT to use" guidance, plus prominent gotcha documentation

