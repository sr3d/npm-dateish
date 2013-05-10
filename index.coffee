MONTHISH = /\bJAN|FEB|MAR|APR[IL]?|MAY|JUNE?|JULY?|AUG[UST]|SEPT?|OCT|NOV|DEC|\b0?[1-9]\b|\b11\b|\b12\b/i
MONTHISH_MAP = 
  1:  [/0?1/, /\bjan/]
  2:  [/0?2/, /\bfeb/]
  3:  [/0?3/, /\bmar/]
  4:  [/0?4/, /\bapr/]
  5:  [/0?5/, /\bmay/]
  6:  [/0?6/, /\bjun/]
  7:  [/0?7/, /\bjul/]
  8:  [/0?8/, /\baug/]
  9:  [/0?9/, /\bsep/]
  10: [/0?10/, /\boct/]
  11: [/0?11/, /\bnov/]
  12: [/0?12/, /\bdec/]

DAY_OF_WEEK_MAP = 
  0:  [/\bsun\b|\bsunday\b/i ]
  1:  [/\bmon\b|\bmonday\b/i ]
  2:  [/\btue\b|\tuesday\b/i]
  3:  [/\bwed\b|\wednesday\b/i]
  4:  [/\bthu\b|\thursday\b/i]
  5:  [/\bfri\b|\friday\b/i]
  6:  [/\bsat\b|\bsaturday\b/i]  



puts = log = console.log

class ParsableDate
  constructor: ->
    @monthishes = []
    @dayishes = []
    @yearishes = []
    @dayOfWeekishes = []

    @literalMonth = false
    @tokens = []

  strip: (token) ->
    token.trim().replace(/[^\d\w]/g,'').toLowerCase()



  addYearish: (token) ->
    token = @strip(token)
    @tokens.push token

    year = undefined

    fullYear = false 
    if token.length == 2
      year = parseInt( "20" + token, 10)
    else if token.length == 4
      year = parseInt(token, 10)
      fullYear = true

    if year <= (new Date()).getFullYear()
      # log "Add yearish", year
      @yearishes = [ year ]

    @yearishes

  addMonthish: (token) ->
    return @monthishes if @literalMonth 
    token = @strip token

    @tokens.push token

    for month of MONTHISH_MAP
      # console.log month
      for regexp in MONTHISH_MAP[month]
        # console.log(regexp)
        if regexp.test token
          # log "Add Monthish", token
          @monthishes.push +month
          @literalMonth = /jan|feb|mar|apr[il]|may|jun|jul|aug|sep|oct|nov|dec/i.test token 
          # puts "@literalMonth", @literalMonth
          break

    @monthishes


  addDayish: (token) ->
    token = @strip(token).replace(/st|nd|th/ig, '')

    @tokens.push token

    day = parseInt token, 10
    if 0 < day < 32
      # log "Add Dayish", token
      @dayishes.push day
    @dayishes


  addDayOfWeekish: (token) ->
    # puts "addDayOfWeekish token: ", token
    token = token.trim().toLowerCase()

    for dayOfWeek of DAY_OF_WEEK_MAP
      for regexp in DAY_OF_WEEK_MAP[dayOfWeek] 
        if regexp.test token
          @dayOfWeekishes.push +dayOfWeek
          break
    @dayOfWeekishes


  possibleDates: () ->
    possibleDates = []

    for year in @yearishes
      if year.length == 2
        year = "20#{year}"

      for month in @monthishes
        for day in @dayishes
          possibleDate = "#{year}-#{@pad0(month)}-#{@pad0(day)}"
          # puts possibleDate
          dateValue = Date.parse possibleDate
          if dateValue
            dateValue = new Date dateValue
            # check with date 
            if @dayOfWeekishes.length > 0
              if @dayOfWeekishes.indexOf dateValue.getDay() > -1
                possibleDates.push(possibleDate)
            else
              possibleDates.push possibleDate

    @dedup possibleDates


  pad0: (value) ->
    if value < 10 then "0#{value}" else value


  dedup: (dates) ->
    map = {}
    unique = []
    for date in dates
      map[date] ?= 0
      map[date] += 1

    for date of map
      unique.push { value: date, count: map[date]}

    unique.sort (a,b) -> b - a

    # puts unique

    unique[0]?.value
    

  parsable: ->
    @dayishes.length > 0 and @monthishes.length > 0 and @yearishes.length > 0 


  # check if we have yymmdd format 
  _dateInTwoDigitsFormat: ->
    for token in @tokens 
      return false if token.toString().length > 2

ParsableDate.isMonthish = (token) ->
  # puts MONTHISH.test token
  MONTHISH.test token

ParsableDate.isDayish = (token) ->
  0 < parseInt(token, 10) < 32

ParsableDate.isYearish = (token) ->
  /\d{2}|\d{4}/.test token

ParsableDate.isDayOfWeekish = (token) ->
  /sun|mon|tue|wed|thu|fri|sat/i.test token


parse = (str) ->
  tokens = str.split /[^\d\w\^\:]/
  parsableDate = new ParsableDate()
  # i = 0
  len = tokens.length
  
  # puts tokens
  hasDay = hasMonth = hasYear = false

  while tokens.length > 0 # and not parsableDate.parsable()
    token = tokens.splice(0,1)?[0]

    # console.log("parsing token: %o[ ", token, "]")

    if ParsableDate.isDayOfWeekish token 
      parsableDate.addDayOfWeekish token 

    if ParsableDate.isYearish token 
      parsableDate.addYearish token 

    if not hasMonth and ParsableDate.isMonthish token
      parsableDate.addMonthish token 
      hasMonth = true 
      continue

    if ParsableDate.isDayish token
      parsableDate.addDayish token
      hasDay = true

  return parsableDate.possibleDates()

exports.parse = parse

exports.ParsableDate = ParsableDate