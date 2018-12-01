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
    | Loaded
    | Playing
    | Paused
    | Seeking
    | Stopped
    | Ended


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CurrentTime currentTime ->
            ( { model | currentTime = currentTime }, Cmd.none )

        Loading ->
            ( { model | videoState = "loading" }, Cmd.none )

        Loaded ->
            ( { model | videoState = "loaded" }, Cmd.none )

        Paused ->
            ( { model | videoState = "paused" }, Cmd.none )

        Playing ->
            ( { model | videoState = "playing" }, Cmd.none )

        Seeking ->
            ( { model | videoState = "seeking" }, Cmd.none )

        Stopped ->
            ( { model | videoState = "stopped" }, Cmd.none )

        Ended ->
            ( { model | videoState = "ended" }, Cmd.none )



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
            , on "seekend" (Json.succeed Ended)
            , on "playing" (Json.succeed Playing)
            , on "play" (Json.succeed Playing)
            , on "pause" (Json.succeed Paused)
            , on "ended" (Json.succeed Ended)
            , on "loadedmetadata" (Json.succeed Loaded)
            , controls True
            ]
            []
        , div [] [ text (String.fromFloat model.currentTime) ]
        , div [] [ text model.videoState ]
        ]
