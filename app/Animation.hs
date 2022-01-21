module Animation where

import AnimationState
import AnimationDraw

import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State.Lazy


runAnimation :: Int -> ReaderT Env (StateT Status (WriterT String IO)) ()
runAnimation frameCount = if frameCount == 0 then do { return () } else do {
    -- Reader monad makes it possible that we don't pass read only state around
    env <- ask;
    -- State monad creates an illusion of mutable state
    status <- get;

    -- Performing IO work requires lifting 3 times into the writer/state/reader transformers
    lift $ lift $ lift $ draw env status;

    -- Now "change" the state
    put (next env status);

    -- Log the current status
    tell (show status);
    tell "\n";

    -- Run with one less frameCount
    runAnimation (frameCount - 1);
    return ()
}