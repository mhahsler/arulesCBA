# Convert Transactions to a Data.Frame

Convert transactions back into data.frames by combining the items for
the same variable into a single column.

## Usage

``` r
transactions2DF(transactions, itemLabels = FALSE)
```

## Arguments

- transactions:

  an object of class
  [arules::transactions](https://rdrr.io/pkg/arules/man/transactions-class.html).

- itemLabels:

  logical; use the complete item labels (variable=level) as the levels
  in the data.frame? By default, only the levels are used.

## Value

Returns a data.frame.

## See also

Other preparation:
[`discretizeDF.supervised()`](http://michael.hahsler.net/arulesCBA/reference/discretizeDF.supervised.md),
[`mineCARs()`](http://michael.hahsler.net/arulesCBA/reference/mineCARs.md),
[`prepareTransactions()`](http://michael.hahsler.net/arulesCBA/reference/prepareTransactions.md)

## Author

Michael Hahsler

## Examples

``` r
data("iris")
iris_trans <- prepareTransactions(Species ~ ., iris)
iris_trans
#> transactions in sparse format with
#>  150 transactions (rows) and
#>  15 items (columns)

# standard conversion
iris_df <- transactions2DF(iris_trans)
head(iris_df)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 2  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 3  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 4  [-Inf,5.55) [2.95,3.35)  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 5  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa
#> 6  [-Inf,5.55) [3.35, Inf]  [-Inf,2.45)  [-Inf,0.8)  setosa

# use item labels in the data.frame
iris_df2 <- transactions2DF(iris_trans, itemLabels = TRUE)
head(iris_df2)
#>               Sepal.Length             Sepal.Width             Petal.Length
#> 1 Sepal.Length=[-Inf,5.55) Sepal.Width=[3.35, Inf] Petal.Length=[-Inf,2.45)
#> 2 Sepal.Length=[-Inf,5.55) Sepal.Width=[2.95,3.35) Petal.Length=[-Inf,2.45)
#> 3 Sepal.Length=[-Inf,5.55) Sepal.Width=[2.95,3.35) Petal.Length=[-Inf,2.45)
#> 4 Sepal.Length=[-Inf,5.55) Sepal.Width=[2.95,3.35) Petal.Length=[-Inf,2.45)
#> 5 Sepal.Length=[-Inf,5.55) Sepal.Width=[3.35, Inf] Petal.Length=[-Inf,2.45)
#> 6 Sepal.Length=[-Inf,5.55) Sepal.Width=[3.35, Inf] Petal.Length=[-Inf,2.45)
#>              Petal.Width        Species
#> 1 Petal.Width=[-Inf,0.8) Species=setosa
#> 2 Petal.Width=[-Inf,0.8) Species=setosa
#> 3 Petal.Width=[-Inf,0.8) Species=setosa
#> 4 Petal.Width=[-Inf,0.8) Species=setosa
#> 5 Petal.Width=[-Inf,0.8) Species=setosa
#> 6 Petal.Width=[-Inf,0.8) Species=setosa

# Conversion of transactions without variables in itemInfo
data("Groceries")
head(transactions2DF(Groceries), 2)
#>   frankfurter sausage liver loaf   ham  meat finished products organic sausage
#> 1       FALSE   FALSE      FALSE FALSE FALSE             FALSE           FALSE
#> 2       FALSE   FALSE      FALSE FALSE FALSE             FALSE           FALSE
#>   chicken turkey  pork  beef hamburger meat  fish citrus fruit tropical fruit
#> 1   FALSE  FALSE FALSE FALSE          FALSE FALSE         TRUE          FALSE
#> 2   FALSE  FALSE FALSE FALSE          FALSE FALSE        FALSE           TRUE
#>   pip fruit grapes berries nuts/prunes root vegetables onions herbs
#> 1     FALSE  FALSE   FALSE       FALSE           FALSE  FALSE FALSE
#> 2     FALSE  FALSE   FALSE       FALSE           FALSE  FALSE FALSE
#>   other vegetables packaged fruit/vegetables whole milk butter  curd dessert
#> 1            FALSE                     FALSE      FALSE  FALSE FALSE   FALSE
#> 2            FALSE                     FALSE      FALSE  FALSE FALSE   FALSE
#>   butter milk yogurt whipped/sour cream beverages UHT-milk condensed milk cream
#> 1       FALSE  FALSE              FALSE     FALSE    FALSE          FALSE FALSE
#> 2       FALSE   TRUE              FALSE     FALSE    FALSE          FALSE FALSE
#>   soft cheese sliced cheese hard cheese cream cheese  processed cheese
#> 1       FALSE         FALSE       FALSE         FALSE            FALSE
#> 2       FALSE         FALSE       FALSE         FALSE            FALSE
#>   spread cheese curd cheese specialty cheese mayonnaise salad dressing tidbits
#> 1         FALSE       FALSE            FALSE      FALSE          FALSE   FALSE
#> 2         FALSE       FALSE            FALSE      FALSE          FALSE   FALSE
#>   frozen vegetables frozen fruits frozen meals frozen fish frozen chicken
#> 1             FALSE         FALSE        FALSE       FALSE          FALSE
#> 2             FALSE         FALSE        FALSE       FALSE          FALSE
#>   ice cream frozen dessert frozen potato products domestic eggs rolls/buns
#> 1     FALSE          FALSE                  FALSE         FALSE      FALSE
#> 2     FALSE          FALSE                  FALSE         FALSE      FALSE
#>   white bread brown bread pastry roll products  semi-finished bread zwieback
#> 1       FALSE       FALSE  FALSE          FALSE                TRUE    FALSE
#> 2       FALSE       FALSE  FALSE          FALSE               FALSE    FALSE
#>   potato products flour  salt  rice pasta vinegar   oil margarine specialty fat
#> 1           FALSE FALSE FALSE FALSE FALSE   FALSE FALSE      TRUE         FALSE
#> 2           FALSE FALSE FALSE FALSE FALSE   FALSE FALSE     FALSE         FALSE
#>   sugar artif. sweetener honey mustard ketchup spices soups ready soups
#> 1 FALSE            FALSE FALSE   FALSE   FALSE  FALSE FALSE        TRUE
#> 2 FALSE            FALSE FALSE   FALSE   FALSE  FALSE FALSE       FALSE
#>   Instant food products sauces cereals organic products baking powder
#> 1                 FALSE  FALSE   FALSE            FALSE         FALSE
#> 2                 FALSE  FALSE   FALSE            FALSE         FALSE
#>   preservation products pudding powder canned vegetables canned fruit
#> 1                 FALSE          FALSE             FALSE        FALSE
#> 2                 FALSE          FALSE             FALSE        FALSE
#>   pickled vegetables specialty vegetables   jam sweet spreads meat spreads
#> 1              FALSE                FALSE FALSE         FALSE        FALSE
#> 2              FALSE                FALSE FALSE         FALSE        FALSE
#>   canned fish dog food cat food pet care baby food coffee instant coffee   tea
#> 1       FALSE    FALSE    FALSE    FALSE     FALSE  FALSE          FALSE FALSE
#> 2       FALSE    FALSE    FALSE    FALSE     FALSE   TRUE          FALSE FALSE
#>   cocoa drinks bottled water  soda misc. beverages fruit/vegetable juice syrup
#> 1        FALSE         FALSE FALSE           FALSE                 FALSE FALSE
#> 2        FALSE         FALSE FALSE           FALSE                 FALSE FALSE
#>   bottled beer canned beer brandy whisky liquor   rum liqueur
#> 1        FALSE       FALSE  FALSE  FALSE  FALSE FALSE   FALSE
#> 2        FALSE       FALSE  FALSE  FALSE  FALSE FALSE   FALSE
#>   liquor (appetizer) white wine red/blush wine prosecco sparkling wine
#> 1              FALSE      FALSE          FALSE    FALSE          FALSE
#> 2              FALSE      FALSE          FALSE    FALSE          FALSE
#>   salty snack popcorn nut snack snack products long life bakery product waffles
#> 1       FALSE   FALSE     FALSE          FALSE                    FALSE   FALSE
#> 2       FALSE   FALSE     FALSE          FALSE                    FALSE   FALSE
#>   cake bar chewing gum chocolate cooking chocolate specialty chocolate
#> 1    FALSE       FALSE     FALSE             FALSE               FALSE
#> 2    FALSE       FALSE     FALSE             FALSE               FALSE
#>   specialty bar chocolate marshmallow candy seasonal products detergent
#> 1         FALSE                 FALSE FALSE             FALSE     FALSE
#> 2         FALSE                 FALSE FALSE             FALSE     FALSE
#>   softener decalcifier dish cleaner abrasive cleaner cleaner toilet cleaner
#> 1    FALSE       FALSE        FALSE            FALSE   FALSE          FALSE
#> 2    FALSE       FALSE        FALSE            FALSE   FALSE          FALSE
#>   bathroom cleaner hair spray dental care male cosmetics make up remover
#> 1            FALSE      FALSE       FALSE          FALSE           FALSE
#> 2            FALSE      FALSE       FALSE          FALSE           FALSE
#>   skin care female sanitary products baby cosmetics  soap rubbing alcohol
#> 1     FALSE                    FALSE          FALSE FALSE           FALSE
#> 2     FALSE                    FALSE          FALSE FALSE           FALSE
#>   hygiene articles napkins dishes cookware kitchen utensil cling film/bags
#> 1            FALSE   FALSE  FALSE    FALSE           FALSE           FALSE
#> 2            FALSE   FALSE  FALSE    FALSE           FALSE           FALSE
#>   kitchen towels house keeping products candles light bulbs
#> 1          FALSE                  FALSE   FALSE       FALSE
#> 2          FALSE                  FALSE   FALSE       FALSE
#>   sound storage medium newspapers photo/film pot plants flower soil/fertilizer
#> 1                FALSE      FALSE      FALSE      FALSE                  FALSE
#> 2                FALSE      FALSE      FALSE      FALSE                  FALSE
#>   flower (seeds) shopping bags  bags
#> 1          FALSE         FALSE FALSE
#> 2          FALSE         FALSE FALSE

# Conversion of transactions prepared for classification
g2 <- prepareTransactions(`shopping bags` ~ ., Groceries)
head(transactions2DF(g2), 2)
#>   frankfurter sausage liver loaf   ham  meat finished products organic sausage
#> 1       FALSE   FALSE      FALSE FALSE FALSE             FALSE           FALSE
#> 2       FALSE   FALSE      FALSE FALSE FALSE             FALSE           FALSE
#>   chicken turkey  pork  beef hamburger meat  fish citrus fruit tropical fruit
#> 1   FALSE  FALSE FALSE FALSE          FALSE FALSE         TRUE          FALSE
#> 2   FALSE  FALSE FALSE FALSE          FALSE FALSE        FALSE           TRUE
#>   pip fruit grapes berries nuts/prunes root vegetables onions herbs
#> 1     FALSE  FALSE   FALSE       FALSE           FALSE  FALSE FALSE
#> 2     FALSE  FALSE   FALSE       FALSE           FALSE  FALSE FALSE
#>   other vegetables packaged fruit/vegetables whole milk butter  curd dessert
#> 1            FALSE                     FALSE      FALSE  FALSE FALSE   FALSE
#> 2            FALSE                     FALSE      FALSE  FALSE FALSE   FALSE
#>   butter milk yogurt whipped/sour cream beverages UHT-milk condensed milk cream
#> 1       FALSE  FALSE              FALSE     FALSE    FALSE          FALSE FALSE
#> 2       FALSE   TRUE              FALSE     FALSE    FALSE          FALSE FALSE
#>   soft cheese sliced cheese hard cheese cream cheese  processed cheese
#> 1       FALSE         FALSE       FALSE         FALSE            FALSE
#> 2       FALSE         FALSE       FALSE         FALSE            FALSE
#>   spread cheese curd cheese specialty cheese mayonnaise salad dressing tidbits
#> 1         FALSE       FALSE            FALSE      FALSE          FALSE   FALSE
#> 2         FALSE       FALSE            FALSE      FALSE          FALSE   FALSE
#>   frozen vegetables frozen fruits frozen meals frozen fish frozen chicken
#> 1             FALSE         FALSE        FALSE       FALSE          FALSE
#> 2             FALSE         FALSE        FALSE       FALSE          FALSE
#>   ice cream frozen dessert frozen potato products domestic eggs rolls/buns
#> 1     FALSE          FALSE                  FALSE         FALSE      FALSE
#> 2     FALSE          FALSE                  FALSE         FALSE      FALSE
#>   white bread brown bread pastry roll products  semi-finished bread zwieback
#> 1       FALSE       FALSE  FALSE          FALSE                TRUE    FALSE
#> 2       FALSE       FALSE  FALSE          FALSE               FALSE    FALSE
#>   potato products flour  salt  rice pasta vinegar   oil margarine specialty fat
#> 1           FALSE FALSE FALSE FALSE FALSE   FALSE FALSE      TRUE         FALSE
#> 2           FALSE FALSE FALSE FALSE FALSE   FALSE FALSE     FALSE         FALSE
#>   sugar artif. sweetener honey mustard ketchup spices soups ready soups
#> 1 FALSE            FALSE FALSE   FALSE   FALSE  FALSE FALSE        TRUE
#> 2 FALSE            FALSE FALSE   FALSE   FALSE  FALSE FALSE       FALSE
#>   Instant food products sauces cereals organic products baking powder
#> 1                 FALSE  FALSE   FALSE            FALSE         FALSE
#> 2                 FALSE  FALSE   FALSE            FALSE         FALSE
#>   preservation products pudding powder canned vegetables canned fruit
#> 1                 FALSE          FALSE             FALSE        FALSE
#> 2                 FALSE          FALSE             FALSE        FALSE
#>   pickled vegetables specialty vegetables   jam sweet spreads meat spreads
#> 1              FALSE                FALSE FALSE         FALSE        FALSE
#> 2              FALSE                FALSE FALSE         FALSE        FALSE
#>   canned fish dog food cat food pet care baby food coffee instant coffee   tea
#> 1       FALSE    FALSE    FALSE    FALSE     FALSE  FALSE          FALSE FALSE
#> 2       FALSE    FALSE    FALSE    FALSE     FALSE   TRUE          FALSE FALSE
#>   cocoa drinks bottled water  soda misc. beverages fruit/vegetable juice syrup
#> 1        FALSE         FALSE FALSE           FALSE                 FALSE FALSE
#> 2        FALSE         FALSE FALSE           FALSE                 FALSE FALSE
#>   bottled beer canned beer brandy whisky liquor   rum liqueur
#> 1        FALSE       FALSE  FALSE  FALSE  FALSE FALSE   FALSE
#> 2        FALSE       FALSE  FALSE  FALSE  FALSE FALSE   FALSE
#>   liquor (appetizer) white wine red/blush wine prosecco sparkling wine
#> 1              FALSE      FALSE          FALSE    FALSE          FALSE
#> 2              FALSE      FALSE          FALSE    FALSE          FALSE
#>   salty snack popcorn nut snack snack products long life bakery product waffles
#> 1       FALSE   FALSE     FALSE          FALSE                    FALSE   FALSE
#> 2       FALSE   FALSE     FALSE          FALSE                    FALSE   FALSE
#>   cake bar chewing gum chocolate cooking chocolate specialty chocolate
#> 1    FALSE       FALSE     FALSE             FALSE               FALSE
#> 2    FALSE       FALSE     FALSE             FALSE               FALSE
#>   specialty bar chocolate marshmallow candy seasonal products detergent
#> 1         FALSE                 FALSE FALSE             FALSE     FALSE
#> 2         FALSE                 FALSE FALSE             FALSE     FALSE
#>   softener decalcifier dish cleaner abrasive cleaner cleaner toilet cleaner
#> 1    FALSE       FALSE        FALSE            FALSE   FALSE          FALSE
#> 2    FALSE       FALSE        FALSE            FALSE   FALSE          FALSE
#>   bathroom cleaner hair spray dental care male cosmetics make up remover
#> 1            FALSE      FALSE       FALSE          FALSE           FALSE
#> 2            FALSE      FALSE       FALSE          FALSE           FALSE
#>   skin care female sanitary products baby cosmetics  soap rubbing alcohol
#> 1     FALSE                    FALSE          FALSE FALSE           FALSE
#> 2     FALSE                    FALSE          FALSE FALSE           FALSE
#>   hygiene articles napkins dishes cookware kitchen utensil cling film/bags
#> 1            FALSE   FALSE  FALSE    FALSE           FALSE           FALSE
#> 2            FALSE   FALSE  FALSE    FALSE           FALSE           FALSE
#>   kitchen towels house keeping products candles light bulbs
#> 1          FALSE                  FALSE   FALSE       FALSE
#> 2          FALSE                  FALSE   FALSE       FALSE
#>   sound storage medium newspapers photo/film pot plants flower soil/fertilizer
#> 1                FALSE      FALSE      FALSE      FALSE                  FALSE
#> 2                FALSE      FALSE      FALSE      FALSE                  FALSE
#>   flower (seeds) shopping bags  bags
#> 1          FALSE         FALSE FALSE
#> 2          FALSE         FALSE FALSE
```
