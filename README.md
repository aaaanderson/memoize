# memoize
figuring out memoization with mixins or inheritance or something

# Design choices

## Wrapping vs. inheritance vs. metaprogramming
* I knew from the start that I didn't want to use metaprogramming. In my experience, excessive enthusiasm for throwing around functions leads to really funky bugs, or in the worst case security issues. If there's an equally clean, more explicit solution, I'm going to go for it.
* I'm new to Ruby, so I preferred a mixin over inheritance. In my experience, class creation and inheritance rules are subtle and take a while to really get comfortable with. A mixin seemed simpler.
* As I worked this out, I learned that inclusion (class-level mixins) gave me some weird relationships between the different functions. I wanted to be able to call `ImportantThing.call()` from `Memoize.call()`, and the method lookup path was preventing this.
* That left us with an object-level mixin which (at implementation level) wraps the object's call() method. Because an object-level mixin's methods "bind more tightly" than methods of the object's class, `super` within `Memoize.call()` would now be `ImportantThing.call()`.

There were supporting benefits to mixin-based wrapping at an object level.

* Additional flexibility in deciding whether to use memoization for a given `ImportantThing`. Perhaps this module is sometimes used in a nondeterministic context; perhaps the space costs of a lookup table are sometimes inappropriate.

## Weaknesses

* This will bloat code a bit for any users of the new module; they have to explicitly extend their object.
* There is a brittle interface for lookup table entry identity. I assume that all functions we want to memoize will be named `call` (which is part of the spec, but in real life I might want to be more extensible). I assume that `args.join(" ")` is an appropriate unique identifier for a set of arguments.
* I do a check for my module variable (the lookup table) in every call to `Memoizer.call()`. That's a little inefficient, but (being new to Ruby) I had a few failed attempts at extending `initialize()`. In real life, I would come back once the extra check became a performance issue. 
