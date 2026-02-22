module Main exposing (main)

import Browser
import Html exposing (Html, a, div, h1, li, main_, nav, p, span, text, ul, p, text, h5, code)
import Html.Attributes exposing (class, href)

type alias CardContent =
    { href : String
    , title : String
    , description : String
    , example : String
    }

main : Program () () Never
main =
    Browser.sandbox
        { init = ()
        , update = \_ model -> model
        , view = view
        }


view : () -> Html Never
view _ =
    div [ class "dark min-h-screen bg-gray-50 text-gray-900 dark:bg-gray-900 dark:text-white" ]
        [ 
        main_ [ class "max-w-screen-xl mx-auto px-4 py-16" ]
            [ h1 [ class "text-4xl font-bold mb-3" ] [ text "Elm + Tailwind + Flowbite Style" ]
            , p [ class "text-lg text-gray-600 dark:text-gray-300" ] [ text "Run npm start and npm run styles in watch mode to keep this page updated." ]
            ]
        , div [ class "grid grid-cols-4 gap-4"][
            card1Front
            , card1Back
        ]
        ]

viewCard : CardContent -> Html msg
viewCard card =
    a
        [ href card.href
        , class "bg-neutral-primary-soft block max-w-sm p-6 border border-default rounded-base shadow-xs hover:bg-neutral-secondary-medium"
        ]
        [ h5
            [ class "mb-3 text-2xl font-semibold tracking-tight text-heading leading-8" ]
            [ text card.title ]
        , p [ class "text-body" ] [ text card.description ]
        , p [ class "mt-3 text-body text-sm font-mono" ]
            [ code [] [ text card.example ] ]
        ]


card1Front : Html msg
card1Front =
    viewCard
        { href = "https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/"
        , title = "Parse, Don't Validate"
        , description = "Transform untyped data into typed structures at system boundaries. Once parsed, trust the types internally."
        , example = "`const user = UserSchema.parse(json)` at the boundary, then `user.name` and `user.email` are guaranteed valid everywhere"
        }


card1Back : Html msg
card1Back =
    viewCard
        { href = "#"
        , title = "Shotgun Parsing"
        , description = "Validation logic scattered throughout codebase, checking the same fields repeatedly in different places, inconsistent handling of invalid data."
        , example = "`if (json.name && typeof json.name === 'string' && json.email && json.email.includes('@')) { ... }` repeated in 5 different files"
        }