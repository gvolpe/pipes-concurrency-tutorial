pipes-concurrency-tutorial
==========================

### Notes:
Use `spawn` to merge two streams. It will return a pair (output, input) that can be later converted into a `Consumer` and a `Producer` respectively using `toOutput` and `fromInput`.

```haskell
spawn :: Buffer a -> IO (Output a, Input a)

toOutput :: (MonadIO m) => Output a -> Consumer a m ()

fromInput :: (MonadIO m) => Input a -> Producer a m ()
```

Use `spawn'` (with aposthrophe) to seal the mailbox when you're done to avoid relying on garbage collection (calls to `performGC` won't be necessary).

```haskell
(output, input, seal) <- spawn' buffer
```

Use either `unbounded` or `bounded n` as `Buffer`, the input value of `spawn`.

Use the `Monoid` instance of `Output` to combine different outputs and thus create a `Broadcast`.
