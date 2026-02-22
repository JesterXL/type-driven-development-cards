module Main exposing (main)

import Browser
import Html exposing (Html, a, div, h1, li, main_, nav, p, span, text, ul)
import Html.Attributes exposing (class, href)


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
        [ nav [ class "bg-white border-b border-gray-200 dark:bg-gray-900 dark:border-gray-700" ]
            [ div [ class "max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4" ]
                [ a [ href "#", class "flex items-center space-x-3 rtl:space-x-reverse" ]
                    [ span [ class "w-8 h-8 rounded bg-blue-700 inline-block" ] []
                    , span [ class "self-center text-2xl font-semibold whitespace-nowrap dark:text-white" ] [ text "Flowbite Header" ]
                    ]
                , ul [ class "font-medium flex flex-row space-x-8 rtl:space-x-reverse text-sm" ]
                    [ li []
                        [ a [ href "#", class "block py-2 px-3 text-white bg-blue-700 rounded-sm md:bg-transparent md:text-blue-700 md:p-0" ] [ text "Home" ] ]
                    , li []
                        [ a [ href "#", class "block py-2 px-3 text-gray-900 rounded-sm hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0 dark:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent md:dark:hover:text-blue-500" ] [ text "Company" ] ]
                    , li []
                        [ a [ href "#", class "block py-2 px-3 text-gray-900 rounded-sm hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0 dark:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent md:dark:hover:text-blue-500" ] [ text "Marketplace" ] ]
                    , li []
                        [ a [ href "#", class "block py-2 px-3 text-gray-900 rounded-sm hover:bg-gray-100 md:hover:bg-transparent md:hover:text-blue-700 md:p-0 dark:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent md:dark:hover:text-blue-500" ] [ text "Contact" ] ]
                    ]
                ]
            ]
        , main_ [ class "max-w-screen-xl mx-auto px-4 py-16" ]
            [ h1 [ class "text-4xl font-bold mb-3" ] [ text "Elm + Tailwind + Flowbite Style" ]
            , p [ class "text-lg text-gray-600 dark:text-gray-300" ] [ text "Run npm start and npm run styles in watch mode to keep this page updated." ]
            ]
        ]
