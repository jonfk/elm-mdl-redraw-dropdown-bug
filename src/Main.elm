module Main exposing (..)

import Html exposing (Html, div, text)
import Material
import Material.Options as Options
import Material.Grid as Grid
import Material.Typography as Typography
import Material.Select as Select
import Material.Dropdown.Item as Item


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { mdl : Material.Model
    , searchInput : String
    , searchResults: List String }


initialModel : Model
initialModel =
    {mdl = Material.model
    , searchInput = ""
    , searchResults = []}


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = NoOp
    | Mdl (Material.Msg Msg)
    | SearchInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        SearchInput input ->
            let
                searchResults = List.repeat (String.length input) input
            in
            { model | searchInput = input , searchResults = searchResults} ! [ ]





-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Select.subs Mdl model.mdl



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text "Hello, world!"
        , text (toString model)
        , viewSearchbox model
        ]

viewSearchbox : Model -> Html Msg
viewSearchbox model =
    Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 2 ] [ Options.span [ Typography.title ] [ text "search" ] ]
        , Grid.cell [ Grid.size Grid.All 4 ]
            [ Select.render Mdl
                [ 0 ]
                model.mdl
                [ Select.value model.searchInput
                , Select.below
                , Options.onInput SearchInput
                ]
                (viewSearchResultItems model)
            ]
        , Grid.cell [ Grid.size Grid.All 6 ] []
        ]

viewSearchResultItems : Model -> List (Select.Item Msg)
viewSearchResultItems model =
    let
        items =
            List.map viewSearchResultItem model.searchResults
    in
        items

viewSearchResultItem : String -> Select.Item Msg
viewSearchResultItem item =
    Select.item [ Item.onSelect NoOp ] [ text <| item ]
