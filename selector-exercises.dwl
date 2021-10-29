%dw 2.0
output application/json
ns html http://www.w3.org/TR/html4/
---
/*

References from: 
1) Dataweave Selectors: https://docs.mulesoft.com/dataweave/2.3/dataweave-selectors
2) Dataweave cookbook: https://docs.mulesoft.com/dataweave/2.3/dataweave-cookbook-extract-data

1. single-value | .keyName | Any type of value that belongs to a matching key
Usage: payload.message

2. Multi-value | .*keyName | Array of values of any matching keys
Usage: payload.*message

3. Descendants | ..keyName | Array of values of any matching descendant keys
Usage: payload...childMsg

4. Key-value pair | .&keyName | Object with the matching key; different to selector type#1 (i.e. single value selector)

Usage:
payload.root.*employee.&firstname

Output:
[
  {
    "firstname": "Naveen"
  },
  {
    "firstname": "Naveen1"
  }
]

5. Index | [<index>] | Value of any type at selected array index
Usages: 
payload.message[2]  //from string
payload.messages[1] //from array

6. Range | [<index> to <index>] | Array with values from selected indexes
Usages: 
payload.message [1 to 3]
payload.messages [0 to 1]

7. XML attribute | @, .@keyName | String value of the selected attribute
Input: 
<root>
    <h:employee id="123" role="Developer"  xmlns:h="http://www.w3.org/TR/html4/">
        <h:firstname gender="male">Naveen</h:firstname>
        <h:lastname>Gaddameedi</h:lastname>
        <h:address>32 Lawrenny Avenue,  Leckwith</h:address>
    </h:employee>
    <h:employee id="124" role="Developer"  xmlns:h="http://www.w3.org/TR/html4/">
        <h:firstname gender="male">Naveen1</h:firstname>
        <h:lastname>Gaddameedi1</h:lastname>
        <h:address>33 Lawrenny Avenue,  Leckwith</h:address>
    </h:employee>
</root>

Usage:
payload.root.employee.@

Output:
{
  "id": "abc",
  "role": "Developer"
}

8. Namespace | keyName.# | String value of the namespace for the selected key

Usage:
payload.root.html#employee

9. Key present | keyName?, keyName.@type? | Boolean (true if the selected key of an object or XML attribute is present, false if not)

Usage:
payload.root.employee?

Output: true

10. Assert present | keyName! | String: Exception message if the key is not present

Usage:
payload.root.employee1!

Output: 
(Excetion): There is no key named 'employee1'


11. Filter  | [?(boolean_expression)] | Array or object containing key-value pairs if the DataWeave expression returns true. Otherwise, returns the value null.

Usage:
payload.root.*employee[?($.firstname == 'Naveen')]

Output: Return first employee from the above input (i.e. #7)

12. Metadata | .^someMetadata | Returns the value of specified metadata for a Mule payload, variable, or attribute. The selector can return the value of class (.^class), content length (.^contentLength), encoding (.^encoding), mime type (.^mimeType), media type (.^mediaType), raw (.^raw), and custom (.^myCustomMetadata) metadata. For details, see Extract Data.
*/
payload.root.*employee.&firstname