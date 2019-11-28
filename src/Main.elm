module Main exposing (main)

import Browser
import Html exposing (..)
import Material.Button exposing (buttonConfig, textButton)
import Material.TextField
    exposing
        ( textField
        , textFieldConfig
        )
import Material.Theme as Theme


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = "app", body = [ viewBody model ] }
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { name : String
    , age : Maybe Int
    }


type Msg
    = ButtonClicked
    | GotInput TextInput String


type TextInput
    = NameInput
    | AgeInput


init : a -> ( Model, Cmd Msg )
init _ =
    ( { name = "", age = Nothing }, Cmd.none )


viewBody : Model -> Html Msg
viewBody model =
    div []
        [ div []
            [ textField
                { textFieldConfig
                    | label = Just "Enter Name"
                    , value = model.name
                    , onInput = Just (GotInput NameInput)
                }
            ]
        , div []
            [ textField
                { textFieldConfig
                    | label = Just "Enter Age"
                    , value = getYourAge model.age
                    , onInput = Just (GotInput AgeInput)
                }
            ]
        , div []
            [ Material.Button.raisedButton
                { buttonConfig | onClick = Just ButtonClicked }
                "Clear"
            ]
        ]


getYourAge : Maybe Int -> String
getYourAge intMaybe =
    case intMaybe of
        Just int ->
            String.fromInt int

        Nothing ->
            ""


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ButtonClicked ->
            ( { model | name = "", age = Nothing }, Cmd.none )

        GotInput textInput string ->
            case textInput of
                NameInput ->
                    ( { model | name = string }, Cmd.none )

                AgeInput ->
                    ( { model | age = String.toInt string }, Cmd.none )


subscriptions model =
    Sub.none
