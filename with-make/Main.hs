#!/usr/bin/env runhaskell
{- The example from graphics-drawingcombinators, with a default font.
-}

import Data.Monoid
import qualified Graphics.DrawingCombinators as Draw
import Graphics.DrawingCombinators ((%%))
import qualified Graphics.UI.SDL as SDL
import System.Environment(getArgs)

resX, resY :: Int
resX = 640
resY = 480

initScreen :: IO ()
initScreen = do
    SDL.init [SDL.InitTimer, SDL.InitVideo]
    SDL.setVideoMode resX resY 32 [SDL.OpenGL]
    return ()

unitText :: Draw.Font -> String -> Draw.Image Any
unitText font str = (Draw.translate (-1,0) %% Draw.scale (2/w) (2/w) %% Draw.text font str)
                        `mappend` 
                    Draw.tint (Draw.Color 1 0 0 1) (Draw.line (-1,0) (1,0))
    where
    w = Draw.textWidth font str

quadrants :: (Monoid a) => Draw.Image a -> Draw.Image a
quadrants img = mconcat [ 
    (Draw.translate (-0.5,0.5) %%), 
    (Draw.translate (0.5,0.5)   `Draw.compose` Draw.rotate (-pi/2) %%),
    (Draw.translate (0.5,-0.5)  `Draw.compose` Draw.rotate pi %%),
    (Draw.translate (-0.5,-0.5) `Draw.compose` Draw.rotate (pi/2) %%)] (Draw.scale 0.5 0.5 %% img)

circleText :: Draw.Font -> String -> Draw.Image Any
circleText font str = unitText font str `mappend` Draw.tint (Draw.Color 0 0 1 0.5) Draw.circle

waitClose :: IO ()
waitClose = do
  ev <- SDL.waitEvent
  case ev of
    SDL.Quit -> return ()
    _ -> waitClose

main :: IO ()
main = do
    initScreen
    args <- getArgs
    font <- Draw.openFont $ case args of
                             [fontName] -> fontName
                             _          -> "Georgia.ttf"
    let image = quadrants (circleText font "Hello, World!")
    Draw.clearRender image
    SDL.glSwapBuffers
    waitClose
    SDL.quit
    return ()
