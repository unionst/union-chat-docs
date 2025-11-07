# Documentation Task Prompt

Copy and paste this into a new Cursor chat to document SwiftUI symbols:

---

I need you to add comprehensive documentation to a Swift file following our project's documentation standards.

**Required Reading:**
1. First, read `/Users/bls/Developer/swiftipedia/DOCUMENTATION_STYLE_GUIDE.md` - this is our complete style guide
2. Then, read `/Users/bls/Developer/swiftipedia/Sources/Swiftipedia/Views/Controls and Indicators/Button.swift` - this is the gold standard reference implementation

**Your Task:**
Document all symbols in: `[PASTE FILE PATH HERE]`

**Critical Requirements:**
- Follow the style guide exactly - especially the Golden Rule about crystal-clear complete documentation
- Every symbol needs at least one clear example
- Explain WHY optional parameters are optional
- Be honest about how common/rare use cases are
- For composition patterns, show the complete cycle (define → compose → use)
- Explain when NOT to use something, not just when to use it
- Never mechanically document parameters - explain design decisions
- Use modern Swift syntax only (iOS 17+, async/await, trailing closures)
- NO obvious comments in code

**If You're Unsure:**
- Use web search to look up the symbol on Apple's documentation
- Check Stack Overflow for real-world usage patterns
- Look at other similar files in the codebase for consistency
- Ask me questions if something is unclear about the symbol's purpose

**Remember:**
Documentation is about sharing wisdom and guiding decision-making, not just describing APIs.

---

After pasting this, replace `[PASTE FILE PATH HERE]` with the actual file you want documented.

