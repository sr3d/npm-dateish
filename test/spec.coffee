dateish = require('..')
assert = require 'assert'

describe 'ParsableDate', ->
  parsableDate = undefined
  
  it "should add a month", ->
    monthishes = ["May", "05", "5", "May,"]
    for monthish in monthishes
      parsableDate = new dateish.ParsableDate
      assert.equal 1, parsableDate.addMonthish(monthish).length
      assert.equal 5, parsableDate.monthishes[0]

    monthishes = ["june", "06", "6", "jun"]
    for monthish in monthishes
      parsableDate = new dateish.ParsableDate
      assert.equal 1, parsableDate.addMonthish(monthish).length
      assert.equal 6, parsableDate.monthishes[0]

    monthishes = ["september", "sept", "sep", "9", "09", "9/"]
    for monthish in monthishes
      parsableDate = new dateish.ParsableDate
      assert.equal 1, parsableDate.addMonthish(monthish).length
      assert.equal 9, parsableDate.monthishes[0]



  it "should add a day", ->
    dayishes = ["01", "1", "1st"]
    for dayish in dayishes
      parsableDate = new dateish.ParsableDate
      assert.equal 1, parsableDate.addDayish(dayish).length
      assert.equal 1, parsableDate.dayishes[0]

    dayishes = ["02", "2", "2nd"]
    for dayish in dayishes
      parsableDate = new dateish.ParsableDate
      assert.equal 1, parsableDate.addDayish(dayish).length
      assert.equal 2, parsableDate.dayishes[0]

  it 'should parse 11th', ->
    parsableDate = new dateish.ParsableDate
    assert.equal 11, parsableDate.addDayish('11th')[0]

  it 'should parse 12th', ->
    parsableDate = new dateish.ParsableDate
    assert.equal 12, parsableDate.addDayish('12th')[0]

  it 'should parse 22nd', ->
    parsableDate = new dateish.ParsableDate
    assert.equal 22, parsableDate.addDayish('22nd')[0]

  it 'should parse 31st', ->
    parsableDate = new dateish.ParsableDate
    assert.equal 31, parsableDate.addDayish('31st')[0]


  it "should not add an invalid day", ->
    dayishes = ["may", "june", "32", "123", "0", "00"]
    for dayish in dayishes
      parsableDate = new dateish.ParsableDate
      assert.equal 0, parsableDate.addDayish(dayish).length


  it 'should parse year', ->
    yearishes = ['2013']
    for yearish in yearishes
      parsableDate = new dateish.ParsableDate
      assert.equal 2013, parsableDate.addYearish(yearish)[0]

    # yearishes = ['09', '2009']
    # for yearish in yearishes
    #   parsableDate = new dateish.ParsableDate
    #   assert.equal 2009, parsableDate.addYearish(yearish)[0]


  it 'should parse day of week', ->
    tokens = ['Sunday', 'sun']
    for token in tokens 
      parsableDate = new dateish.ParsableDate
      assert.equal 0, parsableDate.addDayOfWeekish(token)[0]

    tokens = ['saturday', 'Sat', 'Saturday']
    for token in tokens 
      # console.log("token: %o", token)
      parsableDate = new dateish.ParsableDate
      assert.equal 6, parsableDate.addDayOfWeekish(token)[0]


  it 'should not parse invalid day of week', ->
    tokens = ['blahday', 'asdfsunday', 'crappyday', 'satplat']
    for token in tokens 
      parsableDate = new dateish.ParsableDate
      assert.equal 0, parsableDate.addDayOfWeekish(token).length


describe 'should parse date', ->

  it 'should parse string leading in with some text', ->
    assert.equal '2013-05-05', dateish.parse('Something Something May 5, 2013')


  it 'should parse string with day of week', ->
    assert.equal '2013-05-05', dateish.parse('Something Something Sunday May 5, 2013')

  it 'should parse string with abbreviation day of week', ->
    assert.equal '2013-05-05', dateish.parse('Something Something Sun May 5, 2013')


  it 'should parse a different day Mon May 7, 2013', ->
    assert.equal '2013-05-07', dateish.parse('Something Something Mon May 7, 2013')

  it 'should parse day with time', ->
    assert.equal '2013-05-04', dateish.parse('Something Something Sat May 4, 2013 20:12PM')


  it 'should parse string with non-alphabetic characters', ->
    assert.equal '2013-05-04', dateish.parse('Something Something - May 4, 2013 20:12PM')
    
  it 'should parse string with invalid characters', ->
    assert.equal '2013-05-04', dateish.parse('Something Something - May 4th 2013 20:12PM')

  it 'should parse 05/02/2013 20:12PM PST', ->
    assert.equal '2013-05-02', dateish.parse('Something Something - 05/02/2013 20:12PM PST')


  it 'should parse 05/12/2013 20:12PM PST', ->
    assert.equal '2013-05-12', dateish.parse('Something Something - 05/12/2013 20:12PM PST blah blah blah')


  it 'should parse 05/12/13 20:12PM PST', ->
    assert.equal '2013-05-12', dateish.parse('Something Something - 05/12/13 20:12PM PST blah blah blah')


  it 'should parse May 12th, 2013 20:12PM PST', ->
    assert.equal '2013-05-12', dateish.parse('Something Something - May 12th, 2013 20:12PM PST blah blah blah')

  it 'should parse May 1st, 2013', ->
    assert.equal '2013-05-01', dateish.parse('Something Something - May 1st, 2013 20:12PM PST blah blah blah')

  it 'should parse April 1st, 2013', ->
    assert.equal '2013-04-01', dateish.parse('Something Something - April 1st, 2013 20:12PM PST blah blah blah')

  it 'should parse Apr 1st, 2013', ->
    assert.equal '2013-04-01', dateish.parse('Something Something - Apr 1st, 2013 20:12PM PST blah blah blah')

  it 'should parse Jun 2nd 2013', ->
    assert.equal '2013-06-02', dateish.parse('Something Something - Jun 2nd 2013 20:12PM PST blah blah blah')



  it 'should parse all dates', ->
    dates =
      "2013-06-12": [ "Jun 12th 2013", "June, 12 2013", "06/12/2013", "06.12.2013", "06/12/13" ]

    for date of dates 
      for dateString in dates[date]
        # console.log "parsing #{dateString}"
        assert.equal date, dateish.parse dateString

