breed [BlueAnts bAnt]
breed [RedAnts rAnt]
breed [YellowAnts yAnt]

globals

   [
     R1
     R2
     R3
     R4
     R5
     Var
     A
     A1
     A2
     B
     B1
     B2
     C
     C1
     C2
     AA1
     AA2
     AA
     AB1
     AB2
     AB
     AC1
     AC2
     AC
     BA1
     BA2
     BA
     BB1
     BB2
     BBB
     BC1
     BC2
     BC
     CA1
     CA2
     CAA
     CB1
     CB2
     CB
     CC1
     CC2
     CC
     BB-Contact1
     BR-Contact1
     BY-Contact1
     RB-Contact1
     RR-Contact1
     RY-Contact1
     YB-Contact1
     YR-Contact1
     YY-Contact1
     BB-Contact2
     BR-Contact2
     BY-Contact2
     RB-Contact2
     RR-Contact2
     RY-Contact2
     YB-Contact2
     YR-Contact2
     YY-Contact2
     BB-Contact
     BR-Contact
     BY-Contact
     RB-Contact
     RR-Contact
     RY-Contact
     YB-Contact
     YR-Contact
     YY-Contact
     totalMoniter
     Moniter1
     Moniter2
     B-B
     B-R
     B-Y
     R-B
     R-R
     R-Y
     Y-B
     Y-R
     Y-Y
     Time
     ;total-antennations
     nearest-ant
     nest-Blue
     nest-Red
     nest-Yellow
     X1
     Y1
     Global-contact-from-blue
     Global-contact-from-red
     Global-contact-from-yellow
     Inform-Noninform-contact
     Inform-Noninform-contact1
     Inform-Noninform-contact2
     Inform-Noninform-contact-rate

     Totalinformed1
     Totalinformed2

     Ratio
     ]

BlueAnts-own [
   ;oppo-neighbor
  counterclock
  Neighbor-number
   neighbor
  S?
  home?
  BB
  BR
  BY
  switch-position?
  Contact-From-Blue
  Contact-From-Red
  Contact-From-Yellow
  special

  ]


RedAnts-own[
   ;oppo-neighbor
  counterclock
  Neighbor-number
   neighbor
  S?
  home?
  RB
  RR
  RY
  switch-position?
  Contact-From-Blue
  Contact-From-Red
  Contact-From-Yellow
  ]

YellowAnts-own[
   ;oppo-neighbor
  counterclock
  Neighbor-number
   neighbor
  S?
  home?
  YB
  YR
  YY
  switch-position?
  Contact-From-Blue
  Contact-From-Red
  Contact-From-Yellow
  ]

patches-own[
  Blueantsnest?
  Redantsnest?
  Yellowantsnest?
  ant?
  ant
  neighbor-patch
  patch-count?
  neighbor-ant
  ]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to setup

  clear-all
  patch-setup
  ants-setup



  reset-timer
  reset-ticks


end


to patch-setup
  ask patches with [(pxcor <= -34 + (Number-of-BlueAnts + 40) ^ 0.5 and pycor >= 34 - (Number-of-BlueAnts + 40) ^ 0.5)]
  [set pcolor brown
   set Blueantsnest? 1]
  ask patches with [(pxcor >= 34 - (Number-of-RedAnts + 40) ^ 0.5 and pycor >= 34 - (Number-of-RedAnts + 40) ^ 0.5)]
  [set pcolor brown
    set Redantsnest? 1]
  ask patches with [(pxcor >= -1 + ((Number-of-YellowAnts + 40) ^ 0.5) / -2 and pxcor <= ((Number-of-YellowAnts + 40) ^ 0.5) / 2 + 1 and pycor <= -34 + (Number-of-YellowAnts + 40) ^ 0.5)]
  [set pcolor brown
    set Yellowantsnest? 1]


end

to ants-setup

set-default-shape turtles "bug"

  create-RedAnts Number-of-RedAnts

  ask RedAnts
    [ifelse random 1000 < BRandomlyWalkingP * 1000 [set home? 0][set home? 1]
      ifelse (random 1000) + 1 > BInfectP * 1000 [set S? 1 set color pink][set S? 0 set color red]
  setxy random-xcor random-ycor
  if line = True
    [Pen-down]]


  create-YellowAnts Number-of-YellowAnts

  ask YellowAnts
    [ifelse random 1000 < CRandomlyWalkingP * 1000 [set home? 0][set home? 1]
     ifelse (random 1000) + 1 > CinfectP * 1000 [set S? 1 set color white][set S? 0 set color yellow ]

  setxy random-xcor random-ycor
  if line = True
    [Pen-down]]

    create-BlueAnts 1

     ask blueants [set special 1]

  create-BlueAnts Number-of-BlueAnts - 1

  ask BlueAnts



     [ifelse random 1000 < ARandomlyWalkingP * 1000 [set home? 0][set home? 1]
     ifelse (random 1000) + 1 > AinfectP * 1000 [set S? 1 set color green][set S? 0 set color blue ]
     setxy random-xcor random-ycor
     ;ask blueants with [home? = 1][move-to one-of patches with [blueantsnest? = 1 and ant? = 0]]
     if line = True
    [Pen-down]
    ]

     ask BlueAnts with [special = 1]

     [setxy 0 0
     set S? 0 set home? 0 set color blue ]


end



to go

  ;ask turtles [set oppo-neighbor turtles-on neighbors4]




    patch-count
    ask patches with [patch-count? = 1][ifelse turtles-here = nobody [set neighbor-ant count turtles-on neighbors][set neighbor-ant count turtles-on neighbors + 1]]





    ask turtles[set switch-position? 0]
    if (remainder time 1000) = 0 [
    set moniter1 count turtles with [color = red or color = blue or color = yellow]
    set Inform-Noninform-contact1 Inform-Noninform-contact
    set Totalinformed1 count turtles with [S? = 0]
    set AA1 sum [BB] of blueants
    set AB1 sum [BR] of blueants
    set AC1 sum [BY] of blueants
    set BA1 sum [RB] of redants
    set BB1 sum [RR] of redants
    set BC1 sum [RY] of redants
    set CA1 sum [YB] of yellowants
    set CB1 sum [YR] of yellowants
    set CC1 sum [YY] of yellowants
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    set BB-Contact1 sum [Contact-From-Blue] of blueants
    set BR-Contact1 sum [Contact-From-Red] of blueants
    set BY-Contact1 sum [Contact-From-Yellow] of blueants
    set RB-Contact1 sum [Contact-From-Blue] of redants
    set RR-Contact1 sum [Contact-From-Red] of redants
    set RY-Contact1 sum [Contact-From-Yellow] of redants
    set YB-Contact1 sum [Contact-From-Blue] of yellowants
    set YR-Contact1 sum [Contact-From-Red] of yellowants
    set YY-Contact1 sum [Contact-From-Yellow] of yellowants
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    set A1 count blueants with [S? = 0]
    set B1 count redants with [S? = 0]
    set C1 count yellowants with [S? = 0]]
    set Var variance [neighbor-ant / 5] of patches with [patch-count? = 1]
     ;set mean-crowd mean [neighbor-number] of turtles

    set Time Time + 1


    ask patches[ifelse count turtles-here > 0[set ant? 1][set ant? 0]]


    ifelse(random 100 <= 33)[

    ask one-of BlueAnts
    [
      if recovery? = True[ if (S? = 0 and random 10000 <= RecA * 100)[set S? 1 set color green ]]

      if any? other turtles-on neighbors4
      [Antennate-Blue]
      if switch-position? = 0 [ifelse home? = 1[blue-drift-walk]
                       [random-walk]]
       ]]
    [

      ifelse(random 100 > 50)[

   ask one-of RedAnts
    [if recovery? = True[ if (S? = 0 and random 10000 <= RecB * 100)
          [set S? 1 set color pink ]]


           if any? other turtles-on neighbors4
      [Antennate-Red]
      if switch-position? = 0 [ifelse home? = 1[red-drift-walk]
                       [random-walk]]
            ]]

    [

    ask one-of YellowAnts
    [ if recovery? = True[if (S? = 0 and random 10000 <= RecC * 100)[set S? 1 set color white ]]
      if any? other turtles-on neighbors4
      [Antennate-yellow]

            if switch-position? = 0 [ifelse home? = 1[yellow-drift-walk]
                       [random-walk]]
           ;ifelse home? = 1 and switch-position? = 0 [yellow-drift-walk]
                       ;[random-walk]
    ]]]

    if (remainder Time 1000) = 0 [
    set totalmoniter moniter1 - moniter2


    set AA AA1 - AA2
    set AB AB1 - AB2
    set AC AC1 - AC2
    set BA BA1 - BA2
    set BBB BB1 - BB2
    set BC BC1 - BC2
    set CAA CA1 - CA2
    set CB CB1 - CB2
    set CC CC1 - CC2
    set A A1 - A2
    set B B1 - B2
    set C C1 - C2
    set BB-Contact BB-Contact1 - BB-Contact2
    set BR-Contact BR-Contact1 - BR-Contact2
    set BY-Contact BY-Contact1 - BY-Contact2
    set RB-Contact RB-Contact1 - RB-Contact2
    set RR-Contact RR-Contact1 - RR-Contact2
    set RY-Contact RY-Contact1 - RY-Contact2
    set YB-Contact YB-Contact1 - YB-Contact2
    set YR-Contact YR-Contact1 - YR-Contact2
    set YY-Contact YY-Contact1 - YY-Contact2
    set Inform-Noninform-contact-rate Inform-Noninform-contact1 - Inform-Noninform-contact2


      ]




    if (remainder Time 1000) = 0 [
    set moniter2 count turtles with [color = red or color = blue or color = yellow]
    set Totalinformed2 Totalinformed1
    set Inform-Noninform-contact2 Inform-Noninform-contact
    set AA2 AA1
    set AB2 AB1
    set AC2 AC1
    set BA2 BA1
    set BB2 BB1
    set BC2 BC1
    set CA2 CA1
    set CB2 CB1
    set CC2 CC1
    set A2 A1
    set B2 B1
    set C2 C1
    set BB-Contact2 BB-Contact1
    set BR-Contact2 BR-Contact1
    set BY-Contact2 BY-Contact1
    set RB-Contact2 RB-Contact1
    set RR-Contact2 RR-Contact1
    set RY-Contact2 RY-Contact1
    set YB-Contact2 YB-Contact1
    set YR-Contact2 YR-Contact1
    set YY-Contact2 YY-Contact1
    set moniter2 moniter1
    ]

   tick

end

to patch-count
  ask patches
  [ifelse (pxcor = 0 and pycor = 0) or (pxcor mod 3 = 0 and pycor mod 3 = 0)[set patch-count? 1][set patch-count? 0] ]
end

to random-walk
ifelse one-of neighbors4 with [ant? = 0] != nobody
[set heading towards one-of neighbors4 with [ant? = 0] forward 1][stop]

end

to blue-drift-walk
  ifelse min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and Blueantsnest? = 1]] != nobody
[set heading towards min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and Blueantsnest? = 1]] forward 1][stop]
end


to red-drift-walk
  ifelse min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and Redantsnest? = 1]] != nobody
[set heading towards min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and Redantsnest? = 1]] forward 1] [stop]

end


to yellow-drift-walk
  ifelse min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and yellowantsnest? = 1]] != nobody
[set heading towards min-one-of neighbors4 with [ant? = 0][distance one-of patches with [ant? = 0 and yellowantsnest? = 1]] forward 1] [stop]

end

to Antennate-blue

  if any? other turtles-on neighbors4
   [
    find-nearest-ant
    if(random 100 > (1 - (count turtles-on neighbors4 / 4)) * 100)
    [
      Blue-Count
    ]

  ]

end


to Antennate-Red

  if any? other turtles-on neighbors4
   [ find-nearest-ant
    if(random 100 > (1 - (count turtles-on neighbors4 / 4)) * 100)
   [
    Red-Count] ]

end


to Antennate-Yellow

    if any? other turtles-on neighbors4
   [ find-nearest-ant
    if(random 100 > (1 - (count turtles-on neighbors4 / 4)) * 100)
   [
   Yellow-Count]]
end



to switch
   set X1 xcor set Y1 ycor set switch-position? 1
   set xcor [xcor] of nearest-ant set ycor [ycor] of nearest-ant
   ask nearest-ant [set xcor X1 set ycor Y1]
  if [color = green or color = blue] of nearest-ant [set Contact-From-Blue Contact-From-Blue + 1]
  if [color = red or color = pink] of nearest-ant [set Contact-From-Red Contact-From-Red + 1]
  if [color = yellow or color = white] of nearest-ant [set Contact-From-Yellow Contact-From-Yellow + 1]

end



to Blue-Count

    switch


       if([color = Blue] of nearest-ant and color = green) and random 100 > (1 - AInfectRate) * 100
          [set color blue
           set S? 0
           set BB BB + 1
           set Inform-Noninform-contact Inform-Noninform-contact + 1
           ;set oppo-neighbor oppo-neighbor + 1

           ]

       if [color = green] of nearest-ant and color = blue and random 100 > (1 - AInfectRate) * 100
          [
           ask nearest-ant [set color blue set S? 0 set BB BB + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
             ;set oppo-neighbor oppo-neighbor + 1
           ]]

        if [color = Red] of nearest-ant and color = green and random 100 > (1 - BInfectRate) * 100
           [set color blue
            set S? 0
            set BR BR + 1
            set Inform-Noninform-contact Inform-Noninform-contact + 1
            ;set oppo-neighbor oppo-neighbor + 1

            ]

        if [color = pink] of nearest-ant and color = blue and random 100 > (1 - AInfectRate) * 100
           [
            ask nearest-ant [set color red set S? 0 set RB RB + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]
            ;set oppo-neighbor oppo-neighbor + 1

            ]

        if [color = Yellow] of nearest-ant and color = green and random 100 > (1 - CInfectRate) * 100
          [set color blue
           set S? 0
           set BY BY + 1
           set Inform-Noninform-contact Inform-Noninform-contact + 1
          ;set oppo-neighbor oppo-neighbor + 1
           ]

        if [color = white] of nearest-ant and color = blue and random 100 > (1 - AInfectRate) * 100
          [
           ask nearest-ant [set color yellow set S? 0 set YB YB + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]

           ;set oppo-neighbor oppo-neighbor + 1
           ]

end


to Red-Count
      switch

        if [color = Blue] of nearest-ant and color = pink and random 100 > (1 - AInfectRate) * 100
             [set color red
              set S? 0
              set RB RB + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = green] of nearest-ant and color = red and random 100 > (1 - BInfectRate) * 100
             [
              ask nearest-ant [set color blue set S? 0 set BR BR + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = Red] of nearest-ant and color = pink and random 100 > (1 - BInfectRate) * 100
             [set color red
              set S? 0
              set RR RR + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
              ;set oppo-neighbor oppo-neighbor + 1
              ]

         if [color = pink] of nearest-ant and color = red and random 100 > (1 - BInfectRate) * 100
             [
              ask nearest-ant [set color red set S? 0 set RR RR + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = Yellow] of nearest-ant and color = pink and random 100 > (1 - CInfectRate) * 100
             [set color red
              set S? 0
              set RY RY + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = white] of nearest-ant and color = red and random 100 > (1 - BInfectRate) * 100
             [
              ask nearest-ant [set color yellow set S? 0 set YR YR + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]

              ;set oppo-neighbor oppo-neighbor + 1
              ]

end


to Yellow-Count
       switch
        if [color = Blue] of nearest-ant and color = white and random 100 > (1 - AInfectRate) * 100
             [set color yellow
              set S? 0
              set YB YB + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = green] of nearest-ant and color = yellow and random 100 > (1 - CInfectRate) * 100
             [
              ask nearest-ant [set color blue set S? 0 set BY BY + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1 ]
              ;set oppo-neighbor oppo-neighbor + 1
              ]

        if [color = Red] of nearest-ant and color = white and random 100 > (1 - BInfectRate) * 100
             [set color yellow
              set S? 0
              set YR YR + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
             ; set oppo-neighbor oppo-neighbor + 1
]

        if [color = pink] of nearest-ant and color = yellow and random 100 > (1 - CInfectRate) * 100
             [
              ask nearest-ant [set color red set S? 0 set RY RY + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1 ]
              ;set oppo-neighbor oppo-neighbor + 1
              ]


        if [color = Yellow] of nearest-ant and color = white and random 100 > (1 - CInfectRate) * 100
             [set color yellow
              set S? 0
              set YY YY + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1
             ; set oppo-neighbor oppo-neighbor + 1
              ]

       if [color = white] of nearest-ant and color = yellow and random 100 > (1 - CInfectRate) * 100
             [
              ask nearest-ant [set color yellow set S? 0 set YY YY + 1 set Inform-Noninform-contact Inform-Noninform-contact + 1]
              ;set oppo-neighbor oppo-neighbor + 1
              ]

end



to find-nearest-ant
  set neighbor turtles-on neighbors4
  set neighbor-number count neighbor

  set nearest-ant one-of neighbor
end
@#$#@#$#@
GRAPHICS-WINDOW
165
10
516
382
34
34
4.94203
1
10
1
1
1
0
0
0
1
-34
34
-34
34
0
0
1
ticks
30.0

BUTTON
7
12
160
45
NIL
setup
NIL
1
T
OBSERVER
NIL
X
NIL
NIL
1

SLIDER
2
82
159
115
Number-of-BlueAnts
Number-of-BlueAnts
0
300
61
1
1
NIL
HORIZONTAL

SLIDER
2
116
159
149
Number-of-RedAnts
Number-of-RedAnts
0
300
62
1
1
NIL
HORIZONTAL

SWITCH
-3
489
160
522
line
line
1
1
-1000

BUTTON
7
47
160
80
NIL
go
T
1
T
OBSERVER
NIL
Z
NIL
NIL
1

SLIDER
2
150
158
183
Number-of-YellowAnts
Number-of-YellowAnts
0
300
60
1
1
NIL
HORIZONTAL

SWITCH
-5
523
159
556
Recovery?
Recovery?
1
1
-1000

SLIDER
-2
557
159
590
RecA
RecA
0
100
0
0.1
1
NIL
HORIZONTAL

SLIDER
0
592
159
625
RecB
RecB
0
100
0
0.1
1
NIL
HORIZONTAL

SLIDER
-1
625
157
658
RecC
RecC
0
100
0
0.1
1
NIL
HORIZONTAL

SLIDER
3
184
158
217
AInfectRate
AInfectRate
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
3
219
160
252
BInfectRate
BInfectRate
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
3
253
161
286
CInfectRate
CInfectRate
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
3
287
162
320
ARandomlyWalkingP
ARandomlyWalkingP
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
2
321
160
354
BRandomlyWalkingP
BRandomlyWalkingP
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
0
355
161
388
CRandomlyWalkingP
CRandomlyWalkingP
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
0
389
161
422
AInfectP
AInfectP
0
1
0
0.01
1
NIL
HORIZONTAL

SLIDER
1
422
160
455
BInfectP
BInfectP
0
1
0
0.01
1
NIL
HORIZONTAL

SLIDER
2
454
161
487
CInfectP
CInfectP
0
1
0
0.01
1
NIL
HORIZONTAL

PLOT
783
135
1044
255
 contact rate (total)
NIL
NIL
0.0
10.0
0.0
0.1
true
false
"" ""
PENS
"total" 1.0 0 -16777216 true "" "if (remainder time 1000) = 0\n [ plotxy Time (BB-Contact + RR-Contact + YY-Contact + YB-Contact + YR-Contact + RB-Contact + RY-Contact + BR-Contact + BY-Contact) / 1000]"

PLOT
783
13
1044
133
Contact-rate (Inf vs Noninf)
NIL
NIL
0.0
10.0
0.0
0.01
true
false
"" ""
PENS
"Inform-Noninform" 1.0 0 -16777216 true "" "if (remainder time 1000) = 0\n [ plotxy Time (Inform-Noninform-contact2 - Inform-Noninform-contact1) / 1000]"

PLOT
522
258
1044
378
SpatialHeterogeneity
NIL
NIL
0.0
10.0
0.0
0.01
true
false
"" ""
PENS
"SHD" 1.0 0 -16777216 true "" "if (remainder time 1000) = 0 \n[plotxy Time Var]"

PLOT
520
13
780
133
Information rate (within, cross, total)
NIL
NIL
0.0
10.0
0.0
0.01
true
true
"" ""
PENS
"within" 1.0 0 -13840069 true "" "if (remainder time 1000) = 0\n [ plotxy Time (AA + BBB + CC) / 1000]"
"cross" 1.0 0 -2674135 true "" "if (remainder time 1000) = 0\n [ plotxy Time (CAA + CB  + BA + BC + AB + AC) / 1000]"
"total" 1.0 0 -16777216 true "" "if (remainder time 1000) = 0\n  [ plotxy Time (AA + BBB + CC + CAA + CB + BA + BC + AB + AC) / 1000]"

PLOT
520
135
780
255
information dynamci
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if (remainder time 1000) = 0 \n[plotxy Time (count turtles with [S? = 0])]"

@#$#@#$#@
## WHAT IS IT?

This is a simulation designed to measure the interactions among ants in an ant colony working on a different task.  Each ant group has a different task being represented by a different color.  There is an antennation (ant communication) counter among different groups. An ant undergoes an antennation depending on its orientation, probability of communicating with that task group, and the distance to the other ant.

## HOW IT WORKS

The user can input the number of ants working on each task.  There is a slider that allows the user to change the wiggle angle (the wiggle angle increases or deacrease how much the ants move at an angle as oppossed to a straight line).

## HOW TO USE IT

The slider number of ants allows you to change the number of ants working on each task. By turning the slider "line" on/off shows or suppress the path each ant has taken.  By increaseng the wiggle angle slider makes the ants walk more in a curve path.

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 105 191 90
Circle -7500403 true true 120 137 60
Circle -7500403 true true 120 85 60
Line -7500403 true 135 100 105 30
Line -7500403 true 165 105 195 30
Line -7500403 true 105 135 135 150
Line -7500403 true 120 225 90 240
Line -7500403 true 180 225 210 240
Line -7500403 true 165 150 195 135

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1 (control)" repetitions="1" runMetricsEveryStep="true">
    <setup>reset-timer</setup>
    <go>go</go>
    <exitCondition>a = 1</exitCondition>
    <metric>total-antennations</metric>
    <metric>Blue-Blue</metric>
    <metric>Blue-Red</metric>
    <metric>Blue-Yellow</metric>
    <metric>Red-Blue</metric>
    <metric>Red-Red</metric>
    <metric>Red-Yellow</metric>
    <metric>Yellow-Blue</metric>
    <metric>Yellow-Red</metric>
    <metric>Yellow-Yellow</metric>
    <metric>timer</metric>
    <enumeratedValueSet variable="antennation-radius">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-BlueAnts">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-YellowAnts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-RedAnts">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BlueSpeed">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RedSpeed">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="YellowSpeed">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-blue">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-red">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-yellow">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SightAngle">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="antennation-radius">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Pbswitch">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Final Experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup
reset-timer</setup>
    <go>go</go>
    <exitCondition>timer &gt;= 120</exitCondition>
    <metric>Blue-Blue</metric>
    <metric>Blue-Red</metric>
    <metric>Blue-Yellow</metric>
    <metric>Red-Blue</metric>
    <metric>Red-Red</metric>
    <metric>Red-Yellow</metric>
    <metric>Yellow-Blue</metric>
    <metric>Yellow-Red</metric>
    <metric>Yellow-Yellow</metric>
    <metric>total-antennations</metric>
    <metric>timer</metric>
    <metric>PBlue-Blue</metric>
    <metric>PBlue-Red</metric>
    <metric>PBlue-Yellow</metric>
    <metric>PRed-Blue</metric>
    <metric>PRed-Red</metric>
    <metric>PRed-Yellow</metric>
    <metric>PYellow-Blue</metric>
    <metric>PYellow-Red</metric>
    <metric>PYellow-Yellow</metric>
    <metric>P-total</metric>
    <metric>timer</metric>
    <enumeratedValueSet variable="SightAngle">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-BlueAnts">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-RedAnts">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-YellowAnts">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BlueSpeed">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RedSpeed">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="YellowSpeed">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-blue">
      <value value="38"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-red">
      <value value="69"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="wiggle-yellow">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Pbswitch">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BlueAnts-xcor">
      <value value="-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BlueAnts-ycor">
      <value value="-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Tb">
      <value value="96"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RedAnts-xcor">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RedAnts-ycor">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TR">
      <value value="97"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="YellowAnts-xcor">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="YellowAnts-ycor">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="TY">
      <value value="98"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <final>export-plot "Antennate-Rate-of-Blueants" (word "Antennate-Rate-of-Blueants" random-float 10000 ".csv")
export-plot "Antennate-Rate-of-Redants" (word "Antennate-Rate-of-Redants" random-float 10000 ".csv")
export-plot "Antennate-Rate-of-Yellowants" (word "Antennate-Rate-of-Yellowants" random-float 10000 ".csv")
export-plot "Information-Transmission-rate-of-Blueants" (word "Information-Transmission-rate-of-Blueants" random-float 10000 ".csv")
export-plot "Information-Transmission-rate-of-Redants" (word "Information-Transmission-rate-of-Redants" random-float 10000 ".csv")
export-plot "Information-Transmission-rate-of-Yellowants" (word "Information-Transmission-rate-of-Yellowants" random-float 10000 ".csv")
export-plot "SpatialHeteogeneity" (word "SpatialHeteogeneity" random-float 10000 ".csv")
export-plot "Information-dynamic" (word "Information-dynamic" random-float 10000 ".csv")</final>
    <timeLimit steps="100000"/>
    <enumeratedValueSet variable="CInfectRate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BInfectP">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BRandomlyWalkingP">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Recovery?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ARandomlyWalkingP">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CRandomlyWalkingP">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RecC">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="CInfectP">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-YellowAnts">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AInfectRate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AInfectP">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="BInfectRate">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RecA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RecB">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-BlueAnts">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Number-of-RedAnts">
      <value value="60"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
