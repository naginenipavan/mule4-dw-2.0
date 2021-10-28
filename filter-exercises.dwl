%dw 2.0
output application/json

fun addNum(myArr:Array) = 
    myArr map ({num: $$} ++ $ )

--- 
/*
1. Remove odd values from [1,2,3,4,5]

Solved: 

[1,2,3,4,5] filter ( ($ mod 2) != 1)

2. Remove even indexes from [1,2,3,4,5]
[1,2,3,4,5] filter ( ($ mod 2) != 0 ) 

3. Remove objects in the input array where the status field of the object is "processed":
[
  {
    "id": 1,
    "status": "waiting"
  },
  {
    "id": 2,
    "status": "processed"
  },
  {
    "id": 3,
    "status": "waiting"
  }
]

Solved:
payload filter($.status != 'processed')

4. Remove values in the input array that are contained in this array: ["deleted", "processed"].
[
  "starting", 
  "waiting", 
  "deleted", 
  "processing", 
  "processed"
]

Solved:
payload -- ["deleted", "processed"]


*/

payload -- ["deleted", "processed"]






