pipes-concurrency-tutorial
==========================

### Notes:
Use `spawn` to merge two streams. It will return a pair (output, input) that can later be converted into a `Consumer` and a `Producer` respectively using `toOutput` and `fromInput`.

```haskell
spawn :: Buffer a -> IO (Output a, Input a)

toOutput :: (MonadIO m) => Output a -> Consumer a m ()

fromInput :: (MonadIO m) => Input a -> Producer a m ()
```

