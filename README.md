# Tiny Event System

Its just 35 lines of code + unittests and it supports regular events & cancelable events!

Usage:

```d
import tinyevent;

// Regular event
Event!string onStringChange;
static assert(isEvent!onStringChange);
static assert(isEmittable!onStringChange);
onStringChange ~= (str) { /* Handle new string */ };
onStringChange.emit("Foo");
```

```d
import tinyevent;

// Cancelable
Cancelable!bool onQuit;
static assert(isCancelable!onQuit);
static assert(isEmittable!onQuit);
onQuit ~= (force) { return force || !saved; }

// When pressing X:
if(!onQuit.emit(false))
	showUnsavedChangesDialog();
else
	exit();
```
