{-# LANGUAGE ForeignFunctionInterface #-}

module HSMain where

import Main

foreign export ccall hs_main :: IO ()

hs_main :: IO ()
hs_main = main
