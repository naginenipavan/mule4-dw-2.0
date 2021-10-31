%dw 2.0
output application/json

var dataRoot = payload.root filterObject ( not isEmpty($) )

fun mapRows(key, rows) =
    rows map
        {
            "type": key[-1],
            "orderNumber":$.ORDER_NUMBER,
            "message": $.MESSAGE
        }

---
/* 

1. Convert the following xml into desired JSON format
Payload:
<root>
   <TYPE_A>
      <row id="0">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>123</ORDER_NUMBER>
      </row>
   </TYPE_A>
   <TYPE_B/>
   <TYPE_C>
      <row id="0">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>123</ORDER_NUMBER>
      </row>
      <row id="1">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>789</ORDER_NUMBER>
      </row>
      <row id="2">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>555</ORDER_NUMBER>
      </row>
   </TYPE_C>
   <TYPE_D>
      <row id="0">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>555</ORDER_NUMBER>
      </row>
      <row id="1">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>123</ORDER_NUMBER>
      </row>
      <row id="2">
         <MESSAGE>Unique Message</MESSAGE>
         <ORDER_NUMBER>789</ORDER_NUMBER>
      </row>
   </TYPE_D>
</root>

Output:
[  
  {
    "orderNumber": "123",
    "type": "A",
    "message": "Unique Message"
  },
  {
    "orderNumber": "123",
    "type": "C",
    "message": "Unique Message"
  },
  {
    "orderNumber": "789",
    "type": "C",
    "message": "Unique Message"
  },
  {
    "orderNumber": "555",
    "type": "C",
    "message": "Unique Message"
  },
  {
    "orderNumber": "555",
    "type": "D",
    "message": "Unique Message"
  },
  {
    "orderNumber": "123",
    "type": "D",
    "message": "Unique Message"
  },
  {
    "orderNumber": "789",
    "type": "D",
    "message": "Unique Message"
  }
]

Solved: 
Approach-1: using flatMap and map

keysOf(dataRoot) flatMap ((rootKey, index) -> 
    valuesOf(dataRoot[rootKey]) map ((order) -> 
        {
            orderNumber: order."ORDER_NUMBER",
            "type": upper(rootKey[-1]),
            message: order."MESSAGE"
        }
    )      
)

Approach-2: alternative dynamic solution using do
(dataRoot mapObject do {
    var keyType = ($$)[-1]
    var rows = $.*row
    ---
    (keyType): rows map() -> {
        message: $.MESSAGE,
        orderNumber: $.'ORDER_NUMBER',
        'type': keyType
    }
} pluck $ reduce(items, acc=[]) -> acc ++ items ) 
// flatMap($)  ---> simple flatMap solution to flatten the array of arrays into single array without needing of reduce function as above

Approach-3: more dynamic and excellent using flatten and custom method

flatten(payload.root pluck mapRows($$, $.row))

 */


