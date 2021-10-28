%dw 2.0
output application/json

fun addNum(myArr:Array) = 
    myArr map ({num: $$} ++ $ )

--- 
/* 
1. Add 1 to each value in the array [1,2,3,4,5]

Solved: [1,2,3,4,5] map ($+1)

2. Get a list of ids from: 
Input: 
[
  { "id": 1, "name": "Archer" },
  { "id": 2, "name": "Cyril"  },
  { "id": 3, "name": "Pam"    }
]

Solved: payload.*id

3. Take the following input:
[
  { "name": "Archer" },
  { "name": "Cyril"  },
  { "name": "Pam"    }
]
And generate the input for question #2 (i.e. add an incrementing id field).

Solved:
payload map() -> {
    id: $$,
    name: $.name
}

4. Given what you've learned from question #3, take the following input:
[
  { 
    "name": "Archer",
    "jobs": [
      { "type": "developer" },
      { "type": "investor"  },
      { "type": "educator"  } 
    ] 
  },
  {
    "name": "Cyril",
    "jobs": [
      { "type": "developer"    },
      { "type": "entrepreneur" },
      { "type": "lion tamer"   }
    ]
  } 
]
Create an incrementing num field on the root object, and an incrementing num field for each object in the jobs array. Here's the desired output (order of the fields does not matter):
[
  { 
    "num":  1
    "name": "Archer",
    "jobs": [
      { "num": 1, "type": "developer" },
      { "num": 2, "type": "investor"  },
      { "num": 3, "type": "educator"  } 
    ] 
  },
  {
    "num":  2
    "name": "Cyril",
    "jobs": [
      { "num": 1, "type": "developer"    },
      { "num": 2, "type": "entrepreneur" },
      { "num": 3, "type": "lion tamer"   }
    ]
  } 
]

Solved:

*/

payload map () -> {
    num: $$,
    name: $.name,
    jobs: $.jobs map(val, key) -> {
        num: key,
        'type': val.'type'
    }
}





















