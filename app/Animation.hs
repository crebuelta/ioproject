module Animation where

import AnimationState
import AnimationDraw

import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State.Lazy


runAnimation :: Int -> ReaderT Env (StateT Status (WriterT String IO)) ()
runAnimation frameCount = if frameCount == 0 then do { return () } else do {
    env <- ask;
    status <- get;
    lift $ lift $ lift $ draw env status;

    -- Now change the state
    put (next env status);

    -- Log the current status
    tell (show status);
    tell "\n";

    -- Run with one less frameCount
    runAnimation (frameCount - 1);
    return ()
}