module AnimationDraw where

import AnimationState
import Control.Concurrent (threadDelay)
import System.Process (system)

clearScreen :: IO ()
-- Implementation Notes --
-- This is a new implementation that will work on Windows
-- feel free to change it back to the ANSI escape code version if that works for you
clearScreen = do { system "clear"; return () }

drawStatus :: Env -> Status -> String
drawStatus env@(Env (_, height)) status =
  unlines $ reverse $ map (drawRow env status) [-1..height+1]

drawRow :: Env -> Status -> Int -> String
drawRow env@(Env (width, _)) status row = map (\col -> charAt env status (col, row)) [-1..width+1]

charAt :: Env -> Status -> Vector -> Char
charAt (Env (width, height)) (Status (posX, posY) _) (x, y)
  | (posX, posY) == (x, y) = 'o'
  | y < 0 || y > height = '-'
  | x < 0 || x > width = '|'
  | otherwise = ' '

draw :: Env -> Status -> IO()
draw env status = clearScreen >> putStr (drawStatus env status) >> threadDelay 1000000