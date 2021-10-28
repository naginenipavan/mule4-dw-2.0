%dw 2.0
output application/json

fun addNum(myArr:Array) = 
    myArr map ({num: $$} ++ $ )

--- 
/*
1. Take the following object and transform all the values to uppercase:
{
  "one":   "two",
  "three": "four",
  "five":  "six"
}

Solved:
payload mapObject () -> {
    ($$): upper($)
}

2. Take the object from exercise #1 and transform all the keys to uppercase.

Solved:
payload mapObject () -> {
    (upper($$)): $
}

3. Remove all of the key:value pairs from the following object where the value is null (do not use the skipOnNull directive):
{
  "one":   "two",
  "three": null,
  "five":  null
}

Solved:
payload mapObject () -> {
    (($$): $) if($ != null)
}

*/

payload mapObject () -> {
    (($$): $) if($ != null)
}







