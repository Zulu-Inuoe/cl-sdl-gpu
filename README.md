# cl-sdl-gpu

## Overview

Common Lisp bindings to the [SDL_gpu](https://github.com/grimfang4/sdl-gpu) library, and a couple of useful macros and utilities.

## Notes:

Unlike some other binding libraries, no returned pointers are set up for finalization (see [trivial-garbage](https://common-lisp.net/project/trivial-garbage/).
This is meant to be a minimal fluff wrapper only.