--module Lize where
module Main where

import Control.Monad
import Control.Applicative ((<$>))
import System.Directory
import System.FilePath
import Data.List
import qualified Data.Map as Map


data Lan l = Lan { head :: String
                 , lead :: String
                 , tail :: String}
             deriving (Show)

exts = [("C/C++", [".c", ".cpp", ".h", ".hpp", ".cxx", ".hxx"]),
        ("Script", [".py", ".pl", ".pm", ".sh"]),
        ("Haskell", [".hs"]),
        ("Lisp", [".scm"])]

comments = [("C/C++", ["/*", " *", " */"]), 
            ("Script", ["", "# ", ""]),
            ("Haskell", ["", "-- ", ""]),
            ("Lisp", ["", ";; ", ""])]

toLan :: FilePath -> Maybe String
toLan ext = fst <$> find (\p->ext `elem` (snd p)) exts 

--createComments filename, language, author, year?
--createComments :: FilePath -> String ->

walk :: FilePath -> IO [FilePath]
walk dir = do
  names <- getDirectoryContents dir
  paths <- forM (filter (`notElem` [".", ".."]) names) $ \name -> do
             let path = dir </> name
             isDir <- doesDirectoryExist path
             if isDir then walk path else return [path]
  return (concat paths)

main = do
  items <- walk "."
  putStrLn $ show items
  