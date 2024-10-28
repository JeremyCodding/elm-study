module PhotoGroove exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Random
-- pagina 110 do PDF seção 2.2
-- elm make src/PhotoGroove.elm --output app.js

type ThumbnailSize
    = Small
    | Medium
    | Large

type Status
    = Loading
    | Loaded (List Photo) String
    | Errored String

type alias Photo =
    { url : String }

type alias Model =
    { status : Status
    , chosenSize : ThumbnailSize
    }

type Msg
    = ClickedPhoto String
    | ClickedSize ThumbnailSize
    | ClickedSurpriseMe
    | GotRandomPhoto Photo
    | GotPhotos (Result Http.Error String)

urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"

photoListUrl : String
photoListUrl =
    "http://elm-in-action.com/list-photos"

view : Model -> Html Msg
view model =
    div [ class "content" ] <|
        case model.status of
            Loaded photos selectedUrl ->
                viewLoaded photos selectedUrl model.chosenSize
            Loading ->
                []
            Errored errorMessage ->
                [ text ("Error: " ++ errorMessage) ]
        

viewLoaded : List Photo -> String -> ThumbnailSize -> List (Html Msg)
viewLoaded photos selectedUrl chosenSize =
    [ h1 [] [ text "Photo Groove" ]
    , button
        [ onClick ClickedSurpriseMe ]
        [ text "Surprise Me!" ]
    , h3 [] [ text "Thumbnail Size:" ]
    , div [ id "choose-size" ]
        (List.map viewSizeChooser [ Small, Medium, Large ])
    , div [ id "thumbnails", class (sizeToString chosenSize) ]
        (List.map (viewThumbnail selectedUrl) photos)
    , img
        [ class "large"
        , src (urlPrefix ++ "large/" ++ selectedUrl)
        ]
        []
    ]

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb =
    img
        [ src (urlPrefix ++ thumb.url)
        , classList [ ( "selected", selectedUrl == thumb.url ) ]
        , onClick (ClickedPhoto thumb.url)
        ]
        []

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size) ] []
        , text (sizeToString size)
        ]

sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
    Small ->
        "small"
    Medium ->
        "med"
    Large ->
        "large"

initialModel : Model
initialModel =
    { status = Loading
    , chosenSize = Medium
    }

-- getPhotoUrl : Int -> String
-- getPhotoUrl index =
--     case Array.get index photoArray of
--         Just photo ->
--             photo.url
--         Nothing ->
--             ""

-- randomPhotoPicker : Random.Generator Int
-- randomPhotoPicker =
--     Random.int 0 (Array.length photoArray - 1)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotRandomPhoto photo ->
            ( { model | status = selectUrl photo.url model.status }, Cmd.none )
        ClickedPhoto url ->
            ( { model | status = selectUrl url model.status }, Cmd.none )
        ClickedSize size ->
            ( { model | chosenSize = size }, Cmd.none )
        ClickedSurpriseMe ->
            case model.status of
                Loaded (firstPhoto :: otherPhotos) _ ->
                    Random.uniform firstPhoto otherPhotos
                        |> Random.generate GotRandomPhoto
                        |> Tuple.pair model
                Loaded [] _ ->
                    ( model, Cmd.none )
                Loading ->
                    ( model, Cmd.none )
                Errored errorMessage ->
                    ( model, Cmd.none )
        GotPhotos result ->
            case result of
                Ok responseStr ->
                    case String.split "," responseStr of
                        (firstUrl :: _) as urls ->
                            let
                                photos =
                                    List.map Photo urls
                            in
                            ( { model | status = Loaded photos firstUrl }, Cmd.none )
                        [] ->
                            ( { model | status = Errored "0 photos found" }, Cmd.none )
                        
                Err httpError ->
                    ( { model | status = Errored "Server error!" }, Cmd.none )

selectUrl : String -> Status -> Status
selectUrl url status =
    case status of
        Loaded photos _ ->
            Loaded photos url
        Loading ->
            status --thought
        Errored errorMessage ->
            status

main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }