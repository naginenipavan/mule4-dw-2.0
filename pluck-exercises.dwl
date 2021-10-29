%dw 2.0
output application/json

--- 
/*
1. Get a list of the values from the following:
{
  "one":   "two",
  "three": "four",
  "five":  "six"
}

Solved:
payload pluck($)

2. Get a list of the keys from the object in question #1

Solved:
payload pluck($$)

3. Using the object in question #1, create this:
[
  {"one":   "two" },
  {"three": "four"},
  {"five":  "six" }
]

Solved:
payload pluck(($$): $)

4. Using the object in question #1, create this:
[
  ["one",   "two" ],
  ["three", "four"],
  ["five",  "six" ]
]

Solved:
payload pluck([$$, $])
*/

payload pluck([$$, $])







