# The Mushroom Data Set (UCI)

The `Mushroom` data set includes descriptions of hypothetical samples
corresponding to 23 species of gilled mushrooms in the Agaricus and
Lepiota family. It contains information about 8123 mushrooms. 4208
(51.8\\ edible and 3916 (48.2\\ features plus the class attribute
(edible or not).

## Format

A data frame with 8123 observations on the following 23 variables.

- `Class`:

  a factor with levels `edible` `poisonous`

- `CapShape`:

  a factor with levels `bell` `conical` `flat` `knobbed` `sunken`
  `convex`

- `CapSurf`:

  a factor with levels `fibrous` `grooves` `smooth` `scaly`

- `CapColor`:

  a factor with levels `buff` `cinnamon` `red` `gray` `brown` `pink`
  `green` `purple` `white` `yellow`

- `Bruises`:

  a factor with levels `no` `bruises`

- `Odor`:

  a factor with levels `almond` `creosote` `foul` `anise` `musty` `none`
  `pungent` `spicy` `fishy`

- `GillAttached`:

  a factor with levels `attached` `free`

- `GillSpace`:

  a factor with levels `close` `crowded`

- `GillSize`:

  a factor with levels `broad` `narrow`

- `GillColor`:

  a factor with levels `buff` `red` `gray` `chocolate` `black` `brown`
  `orange` `pink` `green` `purple` `white` `yellow`

- `StalkShape`:

  a factor with levels `enlarging` `tapering`

- `StalkRoot`:

  a factor with levels `bulbous` `club` `equal` `rooted`

- `SurfaceAboveRing`:

  a factor with levels `fibrous` `silky` `smooth` `scaly`

- `SurfaceBelowRing`:

  a factor with levels `fibrous` `silky` `smooth` `scaly`

- `ColorAboveRing`:

  a factor with levels `buff` `cinnamon` `red` `gray` `brown` `orange`
  `pink` `white` `yellow`

- `ColorBelowRing`:

  a factor with levels `buff` `cinnamon` `red` `gray` `brown` `orange`
  `pink` `white` `yellow`

- `VeilType`:

  a factor with levels `partial`

- `VeilColor`:

  a factor with levels `brown` `orange` `white` `yellow`

- `RingNumber`:

  a factor with levels `none` `one` `two`

- `RingType`:

  a factor with levels `evanescent` `flaring` `large` `none` `pendant`

- `Spore`:

  a factor with levels `buff` `chocolate` `black` `brown` `orange`
  `green` `purple` `white` `yellow`

- `Population`:

  a factor with levels `brown` `yellow`

- `Habitat`:

  a factor with levels `woods` `grasses` `leaves` `meadows` `paths`
  `urban` `waste`

## Source

The data set was obtained from the UCI Machine Learning Repository at
<http://archive.ics.uci.edu/ml/datasets/Mushroom>.

## References

Alfred A. Knopf (1981). Mushroom records drawn from The Audubon Society
Field Guide to North American Mushrooms. G. H. Lincoff (Pres.), New
York.

## Examples

``` r

data(Mushroom)

summary(Mushroom)
#>        Class         CapShape       CapSurf        CapColor       Bruises    
#>  edible   :4208   bell   : 452   fibrous:2320   brown  :2283   no     :4748  
#>  poisonous:3915   conical:   4   grooves:   4   gray   :1840   bruises:3375  
#>                   flat   :3152   smooth :2555   red    :1500                 
#>                   knobbed: 828   scaly  :3244   yellow :1072                 
#>                   sunken :  32                  white  :1040                 
#>                   convex :3655                  buff   : 168                 
#>                                                 (Other): 220                 
#>       Odor        GillAttached    GillSpace      GillSize        GillColor   
#>  none   :3528   attached: 210   close  :6811   broad :5612   buff     :1728  
#>  foul   :2160   free    :7913   crowded:1312   narrow:2511   pink     :1492  
#>  spicy  : 576                                                white    :1202  
#>  fishy  : 576                                                brown    :1048  
#>  almond : 400                                                gray     : 752  
#>  anise  : 400                                                chocolate: 732  
#>  (Other): 483                                                (Other)  :1169  
#>      StalkShape     StalkRoot    SurfaceAboveRing SurfaceBelowRing
#>  enlarging:3515   bulbous:3776   fibrous: 552     fibrous: 600    
#>  tapering :4608   club   : 556   silky  :2372     silky  :2304    
#>                   equal  :1119   smooth :5175     smooth :4935    
#>                   rooted : 192   scaly  :  24     scaly  : 284    
#>                   NAs    :2480                                    
#>                                                                   
#>                                                                   
#>  ColorAboveRing ColorBelowRing    VeilType     VeilColor    RingNumber 
#>  white  :4463   white  :4383   partial:8123   brown :  96   none:  36  
#>  pink   :1872   pink   :1872                  orange:  96   one :7487  
#>  gray   : 576   gray   : 576                  white :7923   two : 600  
#>  brown  : 448   brown  : 512                  yellow:   8              
#>  buff   : 432   buff   : 432                                           
#>  orange : 192   orange : 192                                           
#>  (Other): 140   (Other): 156                                           
#>        RingType          Spore       Population      Habitat    
#>  evanescent:2776   white    :2388   brown : 400   woods  :3148  
#>  flaring   :  48   brown    :1968   yellow:1712   grasses:2148  
#>  large     :1296   black    :1871   NAs   :6011   leaves : 832  
#>  none      :  36   chocolate:1632                 meadows: 292  
#>  pendant   :3967   green    :  72                 paths  :1144  
#>                    buff     :  48                 urban  : 367  
#>                    (Other)  : 144                 waste  : 192  
```
