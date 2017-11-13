import Graphics

main::IO()
main = writeFile "graphic.svg" (toSVG graphic)

graphic::Graphic
graphic = rectangle 100 100 <> colored Red (circle 100)
