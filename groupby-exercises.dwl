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

1. Take the following two data structrures (let's assume these came from the invoice and allocation tables of a database):
%var invoices = [
  {
    "invoiceId": 1,
    "amount":    100 },
  {
    "invoiceId": 2,
    "amount":    200 },
  {
    "invoiceId": 3,
    "amount":    300 }]

%var allocations = [
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


*/


invoices map(val) -> {
    invoiceId: val.invoiceId,
    amount: val.amount,
    allocations: (allocations groupBy($.invoiceId))
}
