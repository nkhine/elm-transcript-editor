module Main exposing (Model, Msg(..), init, main, subscriptions, targetCurrentTime, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { videoState : String
    , currentTime : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Model "loading" 0, Cmd.none )



-- UPDATE


type Msg
    = CurrentTime Float
    | Loading
    | Playing
    | Paused
    | Seeking


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CurrentTime currentTime ->
            ( { model | currentTime = currentTime }, Cmd.none )

        Loading ->
            ( { model | videoState = "loading" }, Cmd.none )

        Paused ->
            ( { model | videoState = "paused" }, Cmd.none )

        Playing ->
            ( { model | videoState = "playing" }, Cmd.none )

        Seeking ->
            ( { model | videoState = "seeking" }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


targetCurrentTime : Json.Decoder Float
targetCurrentTime =
    Json.at [ "target", "currentTime" ] Json.float


view : Model -> Html Msg
view model =
    div []
        [ video
            [ src "https://download.ted.com/talks/KateDarling_2018S-950k.mp4"
            , on "timeupdate" (Json.map CurrentTime targetCurrentTime)
            , on "seek" (Json.map CurrentTime targetCurrentTime)
            , on "seek" (Json.succeed Seeking)
            , on "seeking" (Json.succeed Seeking)
            , on "seekend" (Json.succeed Paused)
            , on "playing" (Json.succeed Playing)
            , on "play" (Json.succeed Playing)
            , on "pause" (Json.succeed Playing)
            , on "ended" (Json.succeed Paused)
            , on "loadedmetadata" (Json.succeed Paused)
            , controls True
            ]
            []
        , div [] [ text (String.fromFloat model.currentTime) ]
        , div [] [ text model.videoState ]
        ]
