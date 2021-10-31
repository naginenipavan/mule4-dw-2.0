%dw 2.0
output application/json

var invoices = [
  {
    "invoiceId": 1,
    "amount":    100 },
  {
    "invoiceId": 2,
    "amount":    200 },
  {
    "invoiceId": 3,
    "amount":    300 }]

var allocations = [
  {
    "allocationId":     1,
    "invoiceId":        1,
    "allocationAmount": 50 },
  {
    "allocationId":     2,
    "invoiceId":        1,
    "allocationAmount": 50 },
  {
    "allocationId":     3,
    "invoiceId":        2,
    "allocationAmount": 100 },
  {
    "allocationId":     4,
    "invoiceId":        2,
    "allocationAmount": 100 },
  {
    "allocationId":     5,
    "invoiceId":        3,
    "allocationAmount": 150 },
  {
    "allocationId":     6,
    "invoiceId":        3,
    "allocationAmount": 150 }]

// below function used in exercise(3) 
fun mapInvoice(items) = {
    invoiceId: items[0].invoiceId,
    vendorName: items[0].vendorName,
    total: items[0].total,
    lineItems: items map() -> {
        item: $.lineItem,
        amount: $.lineItemAmount 
    }
}

--- 
/*
"groupBy"
groupBy is a function that takes in an array and returns an object, where each value of the object is an array. In addition to the input array, groupBy is passed a lambda that describes the group to which current object of the iteration belongs. The keys of the objects are the outputs of the lambda during the iteration. I think this is easier to see with an example:

1. Take the following two data structures (let's assume these came from the invoice and allocation tables of a database):
var invoices = [
  {
    "invoiceId": 1,
    "amount":    100 },
  {
    "invoiceId": 2,
    "amount":    200 },
  {
    "invoiceId": 3,
    "amount":    300 }]

var allocations = [
  {
    "allocationId":     1,
    "invoiceId":        1,
    "allocationAmount": 50 },
  {
    "allocationId":     2,
    "invoiceId":        1,
    "allocationAmount": 50 },
  {
    "allocationId":     3,
    "invoiceId":        2,
    "allocationAmount": 100 },
  {
    "allocationId":     4,
    "invoiceId":        2,
    "allocationAmount": 100 },
  {
    "allocationId":     5,
    "invoiceId":        3,
    "allocationAmount": 150 },
  {
    "allocationId":     6,
    "invoiceId":        3,
    "allocationAmount": 150 }]

And merge them to create the following:

[
  {
    "invoiceId":  1
    "amount":     100
    "allocations: [
      {
        "allocationId":     1,
        "invoiceId":        1,
        "allocationAmount": 50 },
      {
        "allocationId":     2,
        "invoiceId":        1,
        "allocationAmount": 50 }]},
  {
    "invoiceId":  2,
    "amount":     200,
    "allocations: [
      {
        "allocationId":     3,
        "invoiceId":        2,
        "allocationAmount": 100 },
      {
        "allocationId":     4,
        "invoiceId":        2,
        "allocationAmount": 100 }]},
  {
    "invoiceId":  3,
    "amount":     300,
    "allocations: [
      {
        "allocationId":     5,
        "invoiceId":        3,
        "allocationAmount": 150 },
      {
        "allocationId":     6,
        "invoiceId":        3,
        "allocationAmount": 150 }]}]


Solved:
Approach-1: Using groupBy

invoices map(invoice, ind) -> {
        invoiceId: invoice.invoiceId,
        amount: invoice.amount,
         allocations: (allocations groupBy $.invoiceId) 
            filterObject ($$ as Number == invoice.invoiceId) 
                pluck ($ map ($ - 'invoiceId'))
}


Approach-2: Using map and filters

invoices map(invoice, ind) -> {
        invoiceId: invoice.invoiceId,
        amount: invoice.amount,
        allocations: allocations filter ($.invoiceId == invoice.invoiceId) 
            map($ - 'invoiceId')
}

2. Convert the following into desired output:
Payload:
[
  {
    "id": 2,
    "test": "123"
  },
  {
    "id": 3,
    "something": "something"
  },
  {
    "id": 2,
    "something": "some123"
  },
  {
    "id": 3,
    "test": "098"
  },
  {
    "id": 4,
    "test": "faf"
  }
]

Output:
[
  {
    "id": 2,
    "test": "123",
    "something": "some123"
  },
  {
    "id": 3,
    "test": "098",
    "something": "something"
  },
  {
    "id": 4,
    "test": "faf"
  }
]

Solved: simplest approach using groupBy and reduce
(payload groupBy($.id) mapObject(val, key, ind) -> {
    (key): {id: key} ++ (val reduce(item, acc={}) -> acc ++ item) - 'id'
}) pluck $


3. Take the following CSV file,

invoiceId,vendorName,total,lineItem,lineItemAmount
1,Amazon,100,Sneakers,75
1,Amazon,100,Shirt,25
2,Walmart,38,Paper,10
2,Walmart,38,Towel,28

And transform it into the output:
[
  {
    "invoiceId":  1,
    "vendorName": "Amazon",
    "total":      100,
    "lineItems": [
      {
        "item":   "Sneakers",
        "amount": 75
      },
      {
        "item":   "Shirt",
        "amount": 25
      }
    ]
  },
  {
    "invoiceId":  2,
    "vendorName": "Walmart",
    "total":      38,
    "lineItems": [
      {
        "item":   "Paper",
        "amount": 10
      },
      {
        "item":   "Towel",
        "amount": 28
      }
    ]
  }
]

Sovled:
(payload groupBy($.invoiceId) mapObject(invoice, invKey, invInd) -> {
    (invKey): mapInvoice(invoice)
}) pluck $

4. Take the following input and sort it by whether or not "merchantName" is under 10 characters (let's assume your database's "merchantName" field is VARCHAR(10)):

Payload:
[
  { "merchantName": "HelloFresh"    },
  { "merchantName": "Amazon"        },
  { "merchantName": "Walmart"       },
  { "merchantName": "Guitar Center" }
]

You should get the following Output:
{
  "true": [
    { "merchantName": "Amazon"  },
    { "merchantName": "Walmart" },
  ],
  "false": [
    { "merchantName": "HelloFresh"    },
    { "merchantName": "Guitar Center" }
  ]
}

Solved:
payload groupBy(sizeOf($.merchantName) < 10 )


5. Convert the following xml into desired JSON format
Input:
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
keysOf(dataRoot) flatMap ((rootKey, index) -> 
    valuesOf(dataRoot[rootKey]) map ((order) -> 
        {
            orderNumber: order."ORDER_NUMBER",
            "type": upper(rootKey[-1]),
            message: order."MESSAGE"
        }
    )      
)



*/

