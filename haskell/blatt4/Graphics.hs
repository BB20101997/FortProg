#!/usr/bin/ghci
module Graphics where

data Point =  Point Double Double
data Color = Black | Red | Green | Blue
data Style = Style Color
data Object = Line Point Point Style
            | Rectangle Point Point Style
            | Circle Point Double Style

styleToAttr::Style->String
styleToAttr (Style Black) = "stroke: black; fill: black;"
styleToAttr (Style Red)   = "stroke: red;   fill: red;"
styleToAttr (Style Green) = "stroke: green; fill: green;"
styleToAttr (Style Blue)  = "stroke: blue;  fill: blue;"

defaultStyle::Style
defaultStyle = Style(Black)

data Graphic = Empty | Graphic Object Graphic

single::Object->Graphic
single o = Graphic o Empty

(<>)::Graphic->Graphic->Graphic
Empty <> t = t
t <> Empty = t
(Graphic o g) <> t = (Graphic o (g<>t))

objToSVG::Object->String
objToSVG (Line (Point x1 y1) (Point x2 y2) style) = "<line x1=\"" ++show x1
                                                    ++"\" y1=\"" ++show y1
                                                    ++"\" x2=\""++show x2
                                                    ++"\" y2=\""++show y2
                                                    ++"\" style=\""++styleToAttr(style)
                                                    ++"\" />"
objToSVG (Rectangle (Point x1 y1) (Point x2 y2) style) = "<rect x=\""++show x1
                                                         ++"\" y=\"" ++show y1
                                                         ++"\" width=\""++show (abs (x2-x1))
                                                         ++"\" height=\""++show (abs(y2-y1))
                                                         ++"\" style=\""++styleToAttr(style)
                                                         ++"\" />"
objToSVG (Circle (Point x y) r style) = "<circle cx=\""++show x
                                           ++"\" cy=\""++show y
                                           ++"\" r=\""++show r
                                           ++"\" style=\""++styleToAttr(style)
                                           ++"\" />"

toSVG g = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
          ++ gToSVG g
          ++ "</svg>"
        where
                gToSVG Empty = ""
                gToSVG (Graphic o g2) = objToSVG o ++ gToSVG g2

rectangle::Double->Double->Graphic
rectangle with height = single (Rectangle (Point 0 0) (Point with height) defaultStyle)

circle::Double->Graphic
circle r = single (Circle (Point r r) r defaultStyle)

--Also useful to directly re-color Objects therefor decided to not put it in a where under colored
colorObject::Color->Object->Object
colorObject c (Line p1 p2 _) = (Line p1 p2 (Style c))
colorObject c (Rectangle p1 p2 _) = (Rectangle p1 p2 (Style c))
colorObject c (Circle p1 r _) = (Circle p1 r (Style c))

colored::Color->Graphic->Graphic
colored _ Empty = Empty
colored c (Graphic o g) = (Graphic (colorObject c o) (colored c g))
