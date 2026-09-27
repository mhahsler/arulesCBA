# The Lymphography Domain Data Set (UCI)

This is lymphography domain obtained from the University Medical Centre,
Institute of Oncology, Ljubljana, Yugoslavia. It was repeatedly used in
the machine learning literature.

## Format

A data frame with 147 observations on the following 19 variables.

- `class`:

  a factor with levels `normalfind` `metastases` `malignlymph`
  `fibrosis`

- `lymphatics`:

  a factor with levels `normal` `arched` `deformed` `displaced`

- `blockofaffere`:

  a factor with levels `no` `yes`

- `bloflymphc`:

  a factor with levels `no` `yes`

- `bloflymphs`:

  a factor with levels `no` `yes`

- `bypass`:

  a factor with levels `no` `yes`

- `extravasates`:

  a factor with levels `no` `yes`

- `regenerationof`:

  a factor with levels `no` `yes`

- `earlyuptakein`:

  a factor with levels `no` `yes`

- `lymnodesdimin`:

  a factor with levels `0` `1` `2` `3`

- `lymnodesenlar`:

  a factor with levels `1` `2` `3` `4`

- `changesinlym`:

  a factor with levels `bean` `oval` `round`

- `defectinnode`:

  a factor with levels `no` `lacunar` `lacmarginal` `laccentral`

- `changesinnode`:

  a factor with levels `no` `lacunar` `lacmargin` `laccentral`

- `changesinstru`:

  a factor with levels `no` `grainy` `droplike` `coarse` `diluted`
  `reticular` `stripped` `faint`

- `specialforms`:

  a factor with levels `no` `chalices` `vesicles`

- `dislocationof`:

  a factor with levels `no` `yes`

- `exclusionofno`:

  a factor with levels `no` `yes`

- `noofnodesin`:

  a factor with levels `0-9` `10-19` `20-29` `30-39` `40-49` `50-59`
  `60-69` `>=70`

## Source

The data set was obtained from the UCI Machine Learning Repository at
<http://archive.ics.uci.edu/ml/datasets/Lymphography>.

## References

This lymphography domain was obtained from the University Medical
Centre, Institute of Oncology, Ljubljana, Yugoslavia. Thanks go to M.
Zwitter and M. Soklic for providing the data. Please include this
citation if you plan to use this database.

## Examples

``` r

data("Lymphography")

summary(Lymphography)
#>          class        lymphatics blockofaffere bloflymphc bloflymphs bypass   
#>  normalfind : 2   normal   : 2   no :66        no :121    no :140    no :111  
#>  metastases :81   arched   :67   yes:81        yes: 26    yes:  7    yes: 36  
#>  malignlymph:60   deformed :46                                                
#>  fibrosis   : 4   displaced:32                                                
#>                                                                               
#>                                                                               
#>                                                                               
#>  extravasates regenerationof earlyuptakein lymnodesdimin lymnodesenlar
#>  no :72       no :137        no : 44       0:141         1:13         
#>  yes:75       yes: 10        yes:103       1:  3         2:71         
#>                                            2:  3         3:43         
#>                                            3:  0         4:20         
#>                                                                       
#>                                                                       
#>                                                                       
#>  changesinlym      defectinnode    changesinnode  changesinstru   specialforms
#>  bean : 6     no         : 3    no        : 6    faint   :44    no      :27   
#>  oval :76     lacunar    :48    lacunar   :42    coarse  :31    chalices:43   
#>  round:65     lacmarginal:46    lacmargin :75    diluted :28    vesicles:77   
#>               laccentral :50    laccentral:24    droplike:19                  
#>                                                  grainy  :14                  
#>                                                  stripped: 7                  
#>                                                  (Other) : 4                  
#>  dislocationof exclusionofno  noofnodesin
#>  no :49        no : 31       0-9    :57  
#>  yes:98        yes:116       10-19  :36  
#>                              20-29  :18  
#>                              30-39  :10  
#>                              40-49  : 8  
#>                              50-59  : 8  
#>                              (Other):10  
```
