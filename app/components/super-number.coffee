parseNumber = (number)->
  value = parseFloat(number)
  if isNaN(value) then 0 else value

component = Ember.Component.extend
  classNames: ["super_number"]

  value: 0
  step: 1
  timer: null
  min: null
  max: null
  scale: 0

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
    method.call(Math, value, parseNumber(boundary))

  incrementBy: (value) ->
    nextValue = parseNumber(@get("value")) + value
    nextValue = @applyBoundaries(nextValue, "min")
    nextValue = @applyBoundaries(nextValue, "max")
    @set "value", nextValue.toFixed(@get("scale"))

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
