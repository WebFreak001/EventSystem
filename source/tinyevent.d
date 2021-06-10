module tinyevent;

/// Defines a regular event
alias Event(Args...) = void delegate(Args)[];
/// Defines a cancelable event by returning false to cancel
alias Cancelable(Args...) = bool delegate(Args)[];

/// Calls all functions in a regular event
void emit(T : void delegate(Args), Args...)(T[] events, Args args) {
	foreach(fn; events)
		fn(args);
}

/// Calls all functions in a cancelable event
bool emit(T : bool delegate(Args), Args...)(T[] events, Args args) {
	foreach(fn; events)
		if(!fn(args))
			return false;
	return true;
}

/// Returns true if the type or variable is an Event!(...)
enum bool isEvent(T) = isEvent!(T.init);
/// ditto
enum bool isEvent(alias v) = is(typeof(v.length)) && is(typeof(v) : void delegate(Args)[], Args...);
/// Returns true if the type or variable is a Cancelable!(...)
enum bool isCancelable(T) = isCancelable!(T.init);
/// ditto
enum bool isCancelable(alias v) = is(typeof(v.length)) && is(typeof(v) : bool delegate(Args)[], Args...);
/// Returns true if the type or variable is an Event or Cancelable
enum bool isEmittable(T) = isEmittable!(T.init);
/// ditto
enum bool isEmittable(alias v) = is(typeof(v.length)) && is(typeof(v) : Ret delegate(Args)[], Ret, Args...)
		&& (is(Ret == bool) || is(Ret == void));

///
unittest {
	Event!string onStringChange;
	static assert (isEvent!onStringChange);
	static assert (isEvent!(typeof(onStringChange)));
	static assert (!isCancelable!onStringChange);
	static assert (!isCancelable!(typeof(onStringChange)));
	static assert (isEmittable!onStringChange);
	static assert (isEmittable!(typeof(onStringChange)));
	onStringChange ~= (s) { assert(s == "Foo"); };
	onStringChange.emit("Foo");
}

///
unittest {
	Cancelable!int onIntChange;
	static assert (!isEvent!onIntChange);
	static assert (!isEvent!(typeof(onIntChange)));
	static assert (isCancelable!onIntChange);
	static assert (isCancelable!(typeof(onIntChange)));
	static assert (isEmittable!onIntChange);
	static assert (isEmittable!(typeof(onIntChange)));
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

// safety tests
@system unittest {
	void delegate(string, int, bool) @system [] eventSystem;
	eventSystem.emit("", 1, true);
}

@safe unittest {
	void delegate(string, int, bool) @trusted [] eventTrusted;
	eventTrusted.emit("", 1, true);
	void delegate(string, int, bool) @safe [] eventSafe;
	eventSafe.emit("", 1, true);
}

@safe nothrow unittest {
	void delegate(string, int, bool) @safe nothrow [] eventSafe;
	eventSafe.emit("", 1, true);
}

unittest {
	string s;
	static assert (!isEvent!s);
	int i;
	static assert (!isEvent!i);
	void fn(int i) {
	}
	static assert (!isEvent!fn);
	static assert (isEvent!([&fn]));
	void function()[] fns;
	static assert (!isEvent!fns);
	void delegate()[] dels;
	static assert (isEvent!dels);
	Event!int e;
	static assert (isEvent!e);
	Cancelable!int c;
	static assert (isCancelable!c);
	static assert (isEmittable!e && isEmittable!c);
	Event!() en;
	static assert (isEvent!en);
	Cancelable!() cn;
	static assert (isCancelable!cn);
	Event!(Event!int, int, string, Object) em;
	static assert (isEvent!em);
	Cancelable!(Object, string, void function(int, string)) cm;
	static assert (isCancelable!cm);
}