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

    -- This clears the original content in the log file
    writeFile "log.txt" [];

    -- This will loop indefinitely until terminated by user
    loop env status;

    return ();
}

loop :: Env -> Status -> IO ()
loop env status = do {
   
    -- This is where MonadTransformers are used
    ((_,newStatus),log) <- runWriterT (runStateT (runReaderT (runAnimation 1) env) status);

    -- Writer monad accumulates the log messages then saves it to a file "log.txt"
    appendFile "log.txt" log;
    loop env newStatus;
    return ()
}
