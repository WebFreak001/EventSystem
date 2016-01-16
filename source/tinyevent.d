module tinyevent;

/// Defines a regular event
alias Event(Args...) = void delegate(Args)[];
/// Defines a cancelable event by returning false to cancel
alias Cancelable(Args...) = bool delegate(Args)[];

/// Calls all functions in a regular event
void emit(Args...)(void delegate(Args)[] events, Args args) {
	foreach(fn; events)
		fn(args);
}

/// Calls all functions in a cancelable event
bool emit(Args...)(bool delegate(Args)[] events, Args args) {
	foreach(fn; events)
		if(!fn(args))
			return false;
	return true;
}

///
unittest {
	Event!string onStringChange;
	onStringChange ~= (s) { assert(s == "Foo"); };
	onStringChange.emit("Foo");
}

///
unittest {
	Cancelable!int onIntChange;
	int changed = 0;
	onIntChange ~= (i) { if(i > 5) return false; changed++; return true; };
	onIntChange ~= (i) { if(i > 4) return false; changed++; return true; };
	onIntChange ~= (i) { if(i > 3) return false; changed++; return true; };
	assert(onIntChange.emit(2));
	assert(changed == 3);
	
	changed = 0;
	assert(!onIntChange.emit(4));
	assert(changed == 2);
}