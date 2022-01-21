module Main where

import Animation
import AnimationState
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.State
import System.Environment (getArgs)

parseArgs :: [String] -> (Env, Status)
parseArgs [frameX, frameY, posX, posY, dirX, dirY] = (Env (read frameX, read frameY), Status (read posX, read posY) (read dirX, read dirY))
parseArgs _ = error "The correct format to use binary is ./Animate frameX frameY posX posY dirX dirY"

main :: IO ()
main = do {
    args <- getArgs;
    (env,status) <- return (parseArgs args);

    -- Implementation Notes --
    -- To make it easier to run, we can simply hard code the arguments here
    -- (env,status) <- return (parseArgs ["10", "10", "4", "3", "1", "1"]);

    -- This clear the original content in the log file
    writeFile "log.txt" [];

    -- This will loop indefinitely
    loop env status;

    return ();
}

loop :: Env -> Status -> IO ()
loop env status = do {
    -- Implementation Notes --
    -- Here is the heart of the transformation to use MonadTransformer
    -- Note that the frameCount is hard coded to 1 here, 
    ((_,newStatus),log) <- runWriterT (runStateT (runReaderT (runAnimation 1) env) status);

    -- Implementation Notes --
    -- The writer monad accumulated some log messages, time to save it to a file
    appendFile "log.txt" log;
    loop env newStatus;
    return ()
}
