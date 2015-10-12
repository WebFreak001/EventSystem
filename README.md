# Tiny Event System

Its just 10 lines of code (including unittests)!

Usage:

```D
Event!string onStringChange;
onStringChange ~= (str) { /* Handle new string */ };
onStringChange.emit("Foo");
```
