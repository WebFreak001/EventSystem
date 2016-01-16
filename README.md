# Tiny Event System

Its just 20 lines of code and it supports regular events & cancelable events!

Usage:

```d
import tinyevent;

// Regular event
Event!string onStringChange;
onStringChange ~= (str) { /* Handle new string */ };
onStringChange.emit("Foo");
```

```d
import tinyevent;

// Cancelable
Cancelable!bool onQuit;
onQuit ~= (force) { return force || !saved; }

// When pressing X:
if(!onQuit.emit(false))
	showUnsavedChangesDialog();
else
	exit();
```
