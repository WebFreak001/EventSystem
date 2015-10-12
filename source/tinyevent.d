module tinyevent;

alias Event(Args...) = void delegate(Args)[];

void emit(Args...)(void delegate(Args)[] events, Args args) {
	foreach(fn; events)
		fn(args);
}

unittest {
	Event!string onStringChange;
	onStringChange ~= (s) { assert(s == "Foo"); };
	onStringChange.emit("Foo");
}
