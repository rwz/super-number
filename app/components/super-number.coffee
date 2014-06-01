parseNumber = (number) ->
  value = parseFloat(String(number).replace(/[^\d.-]/, ''))
  if isNaN(value) then 0 else value

component = Ember.Component.extend
  classNames: ["super_number"]

  value: 0
  step: 1
  timer: null
  min: null
  max: null
  scale: 0
  precision: null
  formatString: null

  init: ->
    @_super arguments...

    @set "step", parseNumber(@get("step"))

    if max = @get("max")
      @set "max", parseNumber(max)

    if min = @get("min")
      @set "min", parseNumber(min)

    if min and max
      throw "Min >= max, doesn't make sense" if @get("min") >= @get("max")

    if @get("loop") and (!min or !max)
      throw "Loop is only possible with both min and max provided"

    @set "scale", ~~parseInt(@get("scale"), 10)

    throw "Scale < 0, doesn't make sense" if @get("scale") < 0


    unless @get("formatString")
      formatString = ".#{@get("scale")}f"

      if precision = @get("precision")
        precision = ~~parseInt(precision, 10)
        @set "precision", precision
        formatString = "0#{precision}#{formatString}"

      formatString = "%#{formatString}"

      @set "formatString", formatString

    @set "value", @format(parseNumber(@get("value")))

  format: (number) -> sprintf(@get("formatString"), number)

  didInsertElement: ->
    @$("a").on "click", false
    @$("a").on "mouseup mouseleave", => @send "stop"
    @$(".increment").on "mousedown", => @send "startIncrementing"
    @$(".decrement").on "mousedown", => @send "startDecrementing"

  applyBoundaries: (value, name) ->
    boundary = @get(name)
    return value unless boundary?
    methodName = if name is "min" then "max" else "min"
    method = Math[methodName]
    method.call(Math, value, boundary)

  incrementBy: (value) ->
    nextValue = parseNumber(@get("value")) + value

    if @get("loop") and nextValue > @get("max")
      nextValue = @get("min")
    else if @get("loop") and nextValue < @get("min")
      nextValue = @get("max")
    else
      nextValue = @applyBoundaries(nextValue, "min")
      nextValue = @applyBoundaries(nextValue, "max")

    @set "value", @format(nextValue)

  increment: -> @incrementBy parseNumber(@get("step"))
  decrement: -> @incrementBy parseNumber(@get("step")) * -1

  start: (methodName) ->
    method = => @[methodName]()
    method.call()
    @set "timer", setInterval(method, 200)

  actions:
    startIncrementing: -> @start "increment"
    startDecrementing: -> @start "decrement"
    stop: -> clearInterval @get("timer")

`export default component`
