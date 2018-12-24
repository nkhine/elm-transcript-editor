module Main exposing (main)

import Browser
import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html


type Page
    = InputPage


type Msg
    = NoOp
    | ChangePlanText String
    | SubmitPlan


type alias Flags =
    ()



---- MODEL ----


type alias Model =
    { currPage : Page
    , currPlanText : String
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { currPage = InputPage
      , currPlanText = ""
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


inputPage : Model -> Element Msg
inputPage model =
    column
        [ width (px 800)
        , spacingXY 0 10
        , centerX
        ]
        [ Input.multiline
            [ height (px 300)
            , Border.width 1
            , Border.rounded 3
            , Border.color lightCharcoal
            , padding 3
            ]
            { onChange = ChangePlanText
            , text = model.currPlanText
            , placeholder = Nothing
            , label =
                Input.labelAbove [] <|
                    text "Paste the EXPLAIN output in JSON format:"
            , spellcheck = False
            }
        , Input.button
            [ Background.color green
            , Border.color darkGreen
            , Border.rounded 3
            , Border.widthEach { bottom = 3, top = 0, right = 0, left = 0 }
            , Font.bold
            , Font.color white
            , paddingXY 20 6
            , alignRight
            , width (px 200)
            , height (px 40)
            ]
            { onPress = Just SubmitPlan
            , label = el [ centerX ] <| text "Go!"
            }
        ]



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Elm transcription editor"
    , body =
        [ layout [] <|
            column [ width fill, spacingXY 0 20 ]
                [ navBar
                , inputPage model
                ]
        ]
    }


blue : Color
blue =
    rgb255 52 101 164


navBar : Element Msg
navBar =
    row
        [ width fill
        , paddingXY 60 10
        , Border.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
        , Border.color blue
        ]
        [ el [ alignLeft ] <| text "Editor"
        , el [ alignRight ] <| text "Menu"
        ]



--     div
--     []
--     [ img [ src "/logo.svg" ] []
--     , h1 [] [ text "ESHOT API" ]
--     ]
---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
