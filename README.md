Dateish
=======
A simple date parser to parse date in the following format:



```
dateish = require('dateish')

--> 2013-06-12

dateish.parse("Something Something - 05/12/2013 20:12PM PST blah blah blah ")
Something Something Sun May 5, 2013
Something Something May 5, 2013
Something Something - 05/12/13 20:12PM PST blah blah blah
Something Something - May 12th, 2013 20:12PM PST blah blah blah
```

It'd extract the date and parse in US format (mm/dd/yyyy).  Also support mm/dd/yy format.

Usage
=====

```
npm install dateish
```

Development and Test
====================

```
npm test 
```


License
=======
BSD