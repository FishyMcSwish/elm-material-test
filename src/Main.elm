module Main exposing (main)

import Browser
import Html exposing (..)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = "app", body = [ viewBody model ] }
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Int


type Msg
    = NoOp


init : a -> ( Model, Cmd Msg )
init _ =
    ( 1, Cmd.none )


viewBody : Model -> Html Msg
viewBody model =
    div [] [ text "this is an elm app" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( 1, Cmd.none )


subscriptions model =
    Sub.none
