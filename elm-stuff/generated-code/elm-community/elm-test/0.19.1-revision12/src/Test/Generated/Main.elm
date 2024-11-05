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
        , seed = 70419574430548
        , processes = 8
        , globs =
            []
        , paths =
            [ "/Users/jeremypaulepereira/Documents/CJ/photogroove/tests/PhotoGrooveTests.elm"
            ]
        }
        [ ( "PhotoGrooveTests"
          , [ Test.Runner.Node.check PhotoGrooveTests.decoderTest
            , Test.Runner.Node.check PhotoGrooveTests.slidHueSetsHue
            , Test.Runner.Node.check PhotoGrooveTests.sliders
            , Test.Runner.Node.check PhotoGrooveTests.noPhotosNoThumbnails
            ]
          )
        ]