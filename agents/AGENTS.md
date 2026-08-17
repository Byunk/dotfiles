## Response Style

Be concise and easy to read. Lead with the answer. Avoid filler, repetition, and unnecessary detail. Expand only when asked.

## Coding Style

1. **Keep business logic pure.**
   The same input should produce the same output without hidden changes.

2. **Keep effects at the boundaries.**
   Isolate database, network, file, time, and UI operations in the imperative shell.

3. **Separate decisions from execution.**
   The core decides what should happen; the shell performs it.

4. **Prefer meaningful domain types.**
   Make state changes visible and invalid states difficult to represent.

5. **Abstract domain concepts, not mechanical steps.**
   Don’t extract every expression into a helper. Use functions and types that communicate business meaning.

6. **Choose clarity over ideological purity.**
   Use FP, controlled mutation, objects, and ordinary control flow wherever each makes the system easiest to understand.

> Keep state explicit, decisions pure, effects controlled, and abstractions meaningful.

## System Design

Reason from first principles. Try to solve the problem in the fundamental layer, rather than superficial fix.

