module Test.Generated.Main exposing (main)

import PhotoGrooveTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport UseColor
        , seed = 384077526093234
        , processes = 8
        , globs =
            []
        , paths =
            [ "/Users/jeremypaulepereira/Documents/CJ/photogroove/tests/PhotoGrooveTests.elm"
            ]
        }
        [ ( "PhotoGrooveTests"
          , [ Test.Runner.Node.check PhotoGrooveTests.suite
            , Test.Runner.Node.check PhotoGrooveTests.decoderTest
            ]
          )
        ]