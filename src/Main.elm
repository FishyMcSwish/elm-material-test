module Main exposing (main)

import Browser
import DatePicker
import DatePicker.Types as DatePicker exposing (DateLimit(..))
import DateTime
import Html exposing (..)
import Html.Attributes exposing (type_)
import Material.Button exposing (buttonConfig, textButton)
import Material.TextField
    exposing
        ( textField
        , textFieldConfig
        )
import Material.Theme as Theme
import Time exposing (Month(..))


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
    , datePickerModel : DatePicker.Model
    , selectedDate : Maybe DateTime.DateTime
    , valid : Bool
    }


type Msg
    = ButtonClicked
    | GotInput TextInput String
    | MessageFromDatePicker DatePicker.Msg


type TextInput
    = NameInput
    | AgeInput


init : a -> ( Model, Cmd Msg )
init _ =
    ( { valid = True, name = "", age = Nothing, selectedDate = Nothing, datePickerModel = initialiseDatePicker }, Cmd.none )


initialiseDatePicker : DatePicker.Model
initialiseDatePicker =
    let
        today =
            DateTime.fromRawParts { day = 1, month = Oct, year = 2019 } { hours = 0, minutes = 0, seconds = 0, milliseconds = 0 }
                |> Maybe.withDefault (DateTime.fromPosix (Time.millisToPosix 0))

        ( date1, date2 ) =
            ( DateTime.fromRawParts { day = 1, month = Jan, year = 2019 } { hours = 0, minutes = 0, seconds = 0, milliseconds = 0 }
                |> Maybe.withDefault (DateTime.fromPosix (Time.millisToPosix 0))
            , DateTime.fromRawParts { day = 31, month = Dec, year = 2019 } { hours = 0, minutes = 0, seconds = 0, milliseconds = 0 }
                |> Maybe.withDefault (DateTime.fromPosix (Time.millisToPosix 0))
            )

        calendarConfig =
            { today = today
            , primaryDate = Nothing
            , dateLimit =
                DateLimit { minDate = date1, maxDate = date2 }
            }

        timePickerConfig =
            Nothing
    in
    DatePicker.initialise DatePicker.Single calendarConfig timePickerConfig


viewBody : Model -> Html Msg
viewBody model =
    div []
        -- [ form []
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
                    , valid = model.valid
                    , onInput = Just (GotInput AgeInput)
                }
            ]
        , div [] [ text (showSelectedDate model.selectedDate) ]
        , div [] [ Html.map MessageFromDatePicker (DatePicker.view model.datePickerModel) ]
        , div []
            [ Material.Button.raisedButton
                { buttonConfig | additionalAttributes = [], onClick = Just ButtonClicked }
                "Clear"
            ]
        ]



-- ]


showSelectedDate : Maybe DateTime.DateTime -> String
showSelectedDate maybeDate =
    case maybeDate of
        Just date ->
            let
                day =
                    DateTime.getDay date |> String.fromInt

                month =
                    case DateTime.getMonth date of
                        Jan ->
                            "January"

                        Feb ->
                            "February"

                        Mar ->
                            "March"

                        Apr ->
                            "April"

                        May ->
                            "May"

                        Jun ->
                            "June"

                        Jul ->
                            "July"

                        Aug ->
                            "August"

                        Sep ->
                            "September"

                        Oct ->
                            "October"

                        Nov ->
                            "November"

                        Dec ->
                            "December"

                year =
                    DateTime.getYear date |> String.fromInt
            in
            month ++ " " ++ day ++ ", " ++ year

        Nothing ->
            "Nothing selected"


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
            ( { model | valid = False }, Cmd.none )

        -- ( { model | name = "", age = Nothing }, Cmd.none )
        GotInput textInput string ->
            case textInput of
                NameInput ->
                    ( { model | name = string }, Cmd.none )

                AgeInput ->
                    ( { model | age = String.toInt string }, Cmd.none )

        MessageFromDatePicker subMsg ->
            let
                ( subModel, subCmd, extMsg ) =
                    DatePicker.update subMsg model.datePickerModel

                selectedDateTime =
                    case extMsg of
                        DatePicker.DateSelected dateTime ->
                            dateTime

                        DatePicker.None ->
                            model.selectedDate
            in
            ( { model | datePickerModel = subModel, selectedDate = selectedDateTime }
            , Cmd.map MessageFromDatePicker subCmd
            )


subscriptions model =
    Sub.none
