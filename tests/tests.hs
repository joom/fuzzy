module Main where

import qualified Text.Fuzzy as F
import Test.HUnit

from :: [Assertion] -> Test
from xs = TestList (map TestCase xs)

tests :: Test
tests = TestList
  [
    TestLabel "test" $ TestList [
      TestLabel "should return true when fuzzy match" $ from [
        F.test "back" "imaback" @?= True
      , F.test "back" "bakck" @?= True
      , F.test "shig" "osh kosh modkhigow" @?= True
      , F.test "" "osh kosh modkhigow" @?= True
      ]
    , TestLabel "should return false when no fuzzy match" $ from [
        F.test "back" "abck" @?= False
      , F.test "okmgk" "osh kosh modkhigow" @?= False
      ]
    ]
  , TestLabel "match" $ TestList [
      TestLabel "should return a greater score for consecutive matches of pattern" $ from [
        (>) (F.score <$> F.match "abcd" "zabcd" "" "" id False)
            (F.score <$> F.match "abcd" "azbcd" "" "" id False)
        @?= True
      ]
    , TestLabel "should return the string as is if no pre/post and case sensitive" $ from [
        F.rendered <$> F.match "ab" "ZaZbZ" "" "" id True @?= Just "ZaZbZ"
      ]
    , TestLabel "should return Nothing on no match" $ from [
        F.match "ZEBRA!" "ZaZbZ" "" "" id False @?= Nothing
      ]
    , TestLabel "should be case sensitive is specified" $ from [
        F.match "hask" "Haskell" "" "" id True @?= Nothing
      ]
    , TestLabel "should be wrap pre and post around matches" $ from [
        F.rendered <$> F.match "brd" "bread" "<" ">" id True @?= Just "<b><r>ea<d>"
      ]
    ]
  , TestLabel "filter" $ TestList [
      TestLabel "should return list untouched when given empty pattern" $ from [
        map F.original (F.filter "" ["abc", "def"] "" "" id True) @?= ["abc", "def"]
      ]
    , TestLabel "should return the highest score first" $ from [
        (@?=) (head (F.filter "cb" ["cab", "acb"] "" "" id True) )
              (head (F.filter "cb" ["acb"] "" "" id True))
      ]
    ]
  ]

runTests ::  IO ()
runTests = do
  _ <- runTestTT tests
  return ()

-- | For now, main will run our tests.
main :: IO ()
main = runTests
