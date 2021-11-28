# Game of Life in Cairo

I haven't been able to get output working, but I know it's working in the inside.

Compiling this the usual way won't likely work for you. But I could get it working in [Cairo Playground](https://www.cairo-lang.org/playground). You can just copy and paste the code and see for yourself.

You can see it in the memory trace. A very crude initialization in the following format in the function `initialize_7x7_array`, to make a "blinker".

```
.......
.......
..xxx..
.......
.......
```

I've seen in memory that it computes the following two states afterwards:

```
.......
...x...
...x...
...x...
.......
```

```
.......
.......
..xxx..
.......
.......
```

So it does behave as a [blinker](https://conwaylife.com/wiki/Blinker).

## TODO
- Learn how to get output working
- Make something to render the output
- Streamline getting the initial state (with input?) and try a larger map

## Why did you do this

I just wanted to get familiar with Cairo, I had an idea that was too ambitious and I ended up dropping it for Game of Life, which was supposed to be simpler. Ran into many learnings in the process.

I don't see how this could be useful in any way at all.