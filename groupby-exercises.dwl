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

2. Convert the following xml into desired JSON format
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

