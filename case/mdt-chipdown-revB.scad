//---------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This will generate a projectbox for a "MDT Chipdown rev.A"
//
//  Version 3.0 (02-12-2023)
//
// This design is parameterized based on the size of a PCB.
//---------------------------------------------------------
include <./library/YAPPgenerator_v3.scad>

// Note: length/lengte refers to X axis, 
//       width/breedte to Y, 
//       height/hoogte to Z

/*
      padding-back|<------pcb length --->|<padding-front
                            RIGHT
        0    X-as ---> 
        +----------------------------------------+   ---
        |                                        |    ^
        |                                        |   padding-right 
        |                                        |    v
        |    -5,y +----------------------+       |   ---              
 B    Y |         | 0,y              x,y |       |     ^              F
 A    - |         |                      |       |     |              R
 C    a |         |                      |       |     | pcb width    O
 K    s |         |                      |       |     |              N
        |         | 0,0              x,0 |       |     v              T
      ^ |   -5,0  +----------------------+       |   ---
      | |                                        |    padding-left
      0 +----------------------------------------+   ---
        0    X-as --->
                          LEFT
*/

//-- which half do you want to print?
printBaseShell    = true;
printLidShell     = true;
printSwitchExtenders  = false;


myPcb = "./models/mdt-chipdown-revB.stl";
myDispPcb = "./models/3_2tft.stl";
offsetDisp = 11+1.6;

if (true)
{
  translate([-31.4, -45.7, 5.1]) 
  {
    rotate([0,0,90]) color("lightgray") import(myPcb);
  }
  
  translate([66.0, 93.6, offsetDisp-3.4]) 
  {
    rotate([90,0,-90]) color("lightgray") import(myDispPcb);
  }
  
}

//-- Edit these parameters for your own board dimensions
wallThickness       = 2;
basePlaneThickness  = 2;
lidPlaneThickness   = 2;

//-- Total height of box = basePlaneThickness + lidPlaneThickness 
//--                     + baseWallHeight + lidWallHeight
//-- space between pcb and lidPlane :=
//--      (baseWallHeight+lidWall_heigth) - (standoff_heigth+pcbThickness)
//--      (6.2 + 4.5) - (3.5 + 1.5) ==> 5.7
baseWallHeight    = 14;
lidWallHeight     = 4.1;

//-- pcb dimensions
pcbLength         = 79.6;
pcbWidth          = 94;
pcbThickness      = 1.6;
                            
//-- padding between pcb and inside wall
paddingFront      = 0.5;
paddingBack       = 0.5;
paddingRight      = 0.5;
paddingLeft       = 0.5;

//-- ridge where base and lid off box can overlap
//-- Make sure this isn't less than lidWallHeight
ridgeHeight       = 4;
ridgeSlack          = 0.2;
roundRadius       = 4.0;
boxType             = 3; // was 0 

//-- How much the PCB needs to be raised from the base
//-- to leave room for solderings and whatnot
standoffHeight    = 3;
standoffPinDiameter = 2.9;
standoffDiameter  = 6.5;

// Set the layer height of your printer
printerLayerHeight  = 0.1; // 0.2


//-- C O N T R O L -------------//-> Default ---------
showSideBySide      = false;     //-> true
previewQuality      = 5;        //-> from 1 to 32, Default = 5
renderQuality       = 8;        //-> from 1 to 32, Default = 8
onLidGap            = 0;
shiftLid            = 1;
hideLidWalls        = false;    //-> false
colorLid            = "yellow";  
alphaLid                  = 0.6;
hideBaseWalls       = false;    //-> false
colorBase           = "blue";
alphaBase           = 0.4;
showPCB             = false;
showSwitches        = false;
showPCBmarkers      = false;
showShellZero       = false;
showCenterMarkers   = false;
inspectX            = 0;        //-> 0=none (>0 from Back)
inspectY            = 0;        //-> 0=none (>0 from Right)
inspectZ            = 0.0;        //-> 0=none (>0 from Bottom)
inspectXfromBack    = false;     //-> View from the inspection cut foreward
inspectYfromLeft    = true;     //-> View from the inspection cut to the right
inspectZfromTop     = true;    //-> View from the inspection cut down
//-- C O N T R O L ---------------------------------------


//===================================================================
// *** PCB Supports ***
// Pin and Socket standoffs 
//-------------------------------------------------------------------
//  Default origin =  yappCoordPCB : pcb[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx
//    (1) = posy
//   Optional:
//    (2) = Height to bottom of PCB : Default = standoffHeight
//    (3) = PCB Gap : Default = -1 : Default for yappCoordPCB=pcbThickness, yappCoordBox=0
//    (4) = standoffDiameter    Default = standoffDiameter;
//    (5) = standoffPinDiameter Default = standoffPinDiameter;
//    (6) = standoffHoleSlack   Default = standoffHoleSlack;
//    (7) = filletRadius (0 = auto size)
//    (n) = { <yappBoth> | yappLidOnly | yappBaseOnly }
//    (n) = { yappHole, <yappPin> } // Baseplate support treatment
//    (n) = { <yappAllCorners> | yappFrontLeft | yappFrontRight | yappBackLeft | yappBackRight }
//    (n) = { yappCoordBox, <yappCoordPCB> }  
//    (n) = { yappNoFillet }
//-------------------------------------------------------------------
pcbStands = 
[
  [3.25, 3.25, yappBoth, yappPin, yappAllCorners], // pcb corners
/*  [32.05, 4.06, yappBoth, yappHole, yappFrontLeft, yappFrontRight, yappNoFillet], // front 
  [45.16, 4.06, yappBoth, yappPin, yappBackLeft, yappBackRight, yappNoFillet], // back
  */
];

/*connectors   =  
[
    [4.06, 4.06, 0, 3.5, 5, 3, 5, yappCoordPCB],
    [pcbLength-4.06, 4.06, 0, 3.5, 5, 3, 5, yappCoordPCB],
    [pcbLength-4.06, pcbWidth-4.06, 0, 3.5, 5, 3, 5, yappCoordPCB],
    [4.06, pcbWidth-4.06, 0, 3.5, 5, 3, 5, yappCoordPCB],
];*/

//===================================================================
//  *** Cutouts ***
//    There are 6 cutouts one for each surface:
//      cutoutsBase (Bottom), cutoutsLid (Top), cutoutsFront, cutoutsBack, cutoutsLeft, cutoutsRight
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//                        Required                Not Used        Note
//                      +-----------------------+---------------+------------------------------------
//  yappRectangle       | width, length         | radius        |
//  yappCircle          | radius                | width, length |
//  yappRoundedRect     | width, length, radius |               |     
//  yappCircleWithFlats | width, radius         | length        | length=distance between flats
//  yappCircleWithKey   | width, length, radius |               | width = key width length=key depth
//  yappPolygon         | width, length         | radius        | yappPolygonDef object must be provided
//
//  Parameters:
//   Required:
//    (0) = from Back
//    (1) = from Left
//    (2) = width
//    (3) = length
//    (4) = radius
//    (5) = shape : {yappRectangle | yappCircle | yappPolygon | yappRoundedRect | yappCircleWithFlats | yappCircleWithKey}
//  Optional:
//    (6) = depth : Default = 0/Auto : 0 = Auto (plane thickness)
//    (7) = angle : Default = 0
//    (n) = { yappPolygonDef } : Required if shape = yappPolygon specified -
//    (n) = { yappMaskDef } : If a yappMaskDef object is added it will be used as a mask for the cutout.
//    (n) = { [yappMaskDef, hOffset, vOffst, rotation] } : If a list for a mask is added it will be used as a mask for the cutout. With the Rotation and offsets applied. This can be used to fine tune the mask placement within the opening.
//    (n) = { <yappCoordBox> | yappCoordPCB }
//    (n) = { <yappOrigin>, yappCenter }
//  (n) = { yappLeftOrigin, <yappGlobalOrigin> } // Only affects Top(lid), Back and Right Faces
//-------------------------------------------------------------------
cutoutsLid =  
[
    [72.6, 15.5, 0, 0, 4.0, yappCircle, yappCenter, yappCoordPCB], // ENC1
    [72.6, 78.5, 0, 0, 4.0, yappCircle, yappCenter, yappCoordPCB], // ENC2
];
              
//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
cutoutsBase =   
[
];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
cutoutsBack = 
[
    [76.8, 4.2, 14.8, 8, 1, yappRoundedRect, yappCenter, yappCoordPCB], // USB Host
    [56.4, 1.8, 10, 4, 1.5, yappRoundedRect, yappCenter, yappCoordPCB], // usb-c
    [38.7, 3.2, 0, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Midi in
    [25.6, 3.2, 0, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Audio
    [12.9, 3.2, 0, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Midi out
];

ridgeExtBack = 
[
    [71.9, 14.8, 7.8, yappCoordBox], // up on usb-a
    [53.9, 10.0, 8.8, yappCoordBox], // up on usb-c
    [38.2, 6, 9.8, yappCoordBox], // Midi in
    [25.1, 6, 9.8, yappCoordBox], // Midi out
    [12.4, 6, 9.8, yappCoordBox], // Audio out
];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
cutoutsFront = 
[
    [55.0, 1.2, 14.4, 2, 1, yappRoundedRect, yappCenter, yappCoordPCB], // SD1
    [36.5, 1.2, 14.4, 2, 1, yappRoundedRect, yappCenter, yappCoordPCB], // SD1
];

ridgeExtFront = 
[
    //[54.8, 14.4, 13.8, yappCoordBox], // SD
];


//-- right plane  -- origin is pcb[0,0,0]
// (0) = posX
// (1) = posZ
cutoutsRight = 
[
    [51.1, 3.7, 0, 0, 2.2, yappCircle, yappCenter, yappCoordPCB], // B1
    [21.1, 3.7, 0, 0, 2.2, yappCircle, yappCenter, yappCoordPCB], // B2
    [41.4, 3.7, 0, 0, 1.55, yappCircle, yappCenter, yappCoordPCB], // Led1
    [36.1, 3.7, 0, 0, 1.55, yappCircle, yappCenter, yappCoordPCB], // Led2
    [30.8, 3.7, 0, 0, 1.55, yappCircle, yappCenter, yappCoordPCB], // Led3
];

ridgeExtRight = 
[
    [51.1, 4.4, 3.7, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // B1
    [21.1, 4.4, 3.7, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // B2
    [41.4, 3.2, 3.7, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Led1
    [36.1, 3.2, 3.7, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Led2
    [30.8, 3.2, 3.7, 0, 3.0, yappCircle, yappCenter, yappCoordPCB], // Led3
];

//-- right plane  -- origin is pcb[0,0,0]
// (0) = posX
// (1) = posZ
cutoutsLeft = 
[
];


//===================================================================
//  *** Snap Joins ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    (0) = posx | posy
//    (1) = width
//    (n) = yappLeft / yappRight / yappFront / yappBack (one or more)
//   Optional:
//    (n) = { <yappOrigin> | yappCenter }
//    (n) = { yappSymmetric }
//    (n) = { yappRectangle } == Make a diamond shape snap
//-------------------------------------------------------------------
snapJoins   =   
[
    [5, 5,  yappLeft, yappRight, yappSymmetric],
];

//===================================================================
//  *** Labels ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   (0) = posx
//   (1) = posy/z
//   (2) = rotation degrees CCW
//   (3) = depth : positive values go into case (Remove) negative valies are raised (Add)
//   (4) = plane {yappLeft | yappRight | yappFront | yappBack | yappTop | yappBottom}
//   (5) = font
//   (6) = size
//   (7) = "label text"
//-------------------------------------------------------------------
labelsPlane = [
//    [60, 3, 90, 0.2, yappLid, "Fixedsys Excelsior:style=bold", 50, "GO"],

/*    [18, 18.5, 0, 0.2, yappRight, "Fixedsys Excelsior:style=bold", 3, "TAPE"],
    [79, 20.5, 0, 0.2, yappBack, "Fixedsys Excelsior:style=bold", 3, "SND"],
    [88, 20.5, 0, 0.2, yappBack, "Fixedsys Excelsior:style=bold", 3, "POWER"],
    [11, 2.5, 0, 0.2, yappFront, "Fixedsys Excelsior:style=bold", 3, "SD1"],
    [58, 2.5, 0, 0.2, yappFront, "Fixedsys Excelsior:style=bold", 3, "SD2"]*/
];

//===================================================================
//  *** Display Mounts ***
//    add a cutout to the lid with mounting posts for a display
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   Required:
//    p(0) = posx
//    p(1) = posy
//    p[2] : displayWidth = overall Width of the display module
//    p[3] : displayHeight = overall Height of the display module
//    p[4] : pinInsetH = Horizontal inset of the mounting hole
//    p[5] : pinInsetV = Vertical inset of the mounting hole
//    p[6] : pinDiameter,
//    p[7] : postOverhang  = Extra distance towards outside of pins to move the post for the display to sit on - 0 = centered : pin Diameter will move the post to align to the outside of the pin (moves it half the distance specified for compatability : -pinDiameter will move it in.
//    p[8] : walltoPCBGap = Distance from the display PCB to the surface of the screen
//    p[9] : pcbThickness  = Thickness of the display module PCB
//    p[10] : windowWidth = opening width for the screen
//    p[11] : windowHeight = Opening height for the screen
//    p[12] : windowOffsetH = Horizontal offset from the center for the opening
//    p[13] : windowOffsetV = Vertical offset from the center for the opening
//    p[14] : bevel = Apply a 45degree bevel to the opening
// Optionl:
//    p[15] : rotation
//    p[16] : snapDiameter : default = pinDiameter*2
//    p[17] : lidThickness : default = lidPlaneThickness
//    n(a) = { <yappOrigin>, yappCenter } 
//    n(b) = { <yappCoordBox> | yappCoordPCB | yappCoordBoxInside }
//    n(c) = { <yappGlobalOrigin>, yappAltOrigin } // Only affects Top(lid), Back and Right Faces
//    n(d) = [yappPCBName, "XXX"] : Specify a PCB. Defaults to [yappPCBName, "Main"]
//    n(e) = {yappSelfThreading} : Replace the pins with self threading holes
//-------------------------------------------------------------------
displayMounts =
[
    [38.4,49, 57, 49.2, 0,0,0,0,0,0, 49.2, 80.1, 0,0, 0,0,0, 0.0, yappCenter  ], 
];

//===================================================================
//  *** Images ***
//-------------------------------------------------------------------
//  Default origin = yappCoordBox: box[0,0,0]
//
//  Parameters:
//   p(0) = posx
//   p(1) = posy/z
//   p(2) = rotation degrees CCW
//   p(3) = depth : positive values go into case (Remove) negative values are raised (Add)
//   p(4) = { yappLeft, yappRight, yappFront, yappBack, yappLid, yappBase } : plane
//   p(5) = "image filename.svg"
//  Optional:
//   p(6) = Scale : Default = 1 : ratio to scale image by (making it larger or smaller)
//-------------------------------------------------------------------
imagesPlane =
[
[ 73.5, 47, 90, 0.8, yappLid, "./models/logo.svg", 0.07 ]
];

YAPPgenerate();
