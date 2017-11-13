data Point =  Point Double Double
data Color = Black | Red | Green | Blue
data Style = Style Color
data Object = Line Point Point Style | Rectangle Point Point Style | Circle Point Double Style

styleToAttr::Style->String
styleToAttr (Style Black) = "stroke: black; fill: black;"
styleToAttr (Style Red)   = "stroke: red;   fill: red;"
styleToAttr (Style Green) = "stroke: green; fill: green;"
styleToAttr (Style Blue)  = "stroke: blue;  fill: blue;"

defaultStyle::Style
defaultStyle = Style(Black)

data Graphic = Empty | Graphic Object Graphic

single::Object->Graphic
single o = Graphic o

(<>)::Graphic->Graphic->Graphic
Empty <> t = t
(Graphic o g) <>  t = Graphic(o (g<>t))

objToSVG::Object->String
objToSVG (Line (Point x1 y1) (Point x2 y2) style) = "<line x1=\"" ++show x1
						 ++"\" y1=\"" ++show y1
						 ++"\" x2=\""++show x2
						 ++"\" y2=\""++show y2
						 ++"\" style=\""++styleToAttr(style)
						 ++"\" />"
objectToSVG (Rectangle (Point x1 y1) (Point x2 y2) style) = "<rect x1=\""++show x1
						 	  ++"\" y1=\"" ++show y1
						 	  ++"\" x2=\""++show x2
						 	  ++"\" y2=\""++show y2
						 	  ++"\" style=\""++styleToAttr(style)
						 	  ++"\" />"
objectTOSVG (Circle (Point x y) r style) = "<circle cx=\""++show x
					 ++"\" cy=\""++show y
					 ++"\" r=\""++show r
					 ++"\" style=\""++styleToAttr(style)
					 ++"\" />"

toSVG g = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
          ++ gToSVG g
	  ++ "</svg>"
	where
		gToSVG Empty = ""
		gToSCG (Graphic o g2) = objectToSVG o ++ gToSVG g2
