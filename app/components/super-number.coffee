component = Ember.Component.extend
  classNames: ["super_number"]

  value: 0
  step: 1
  timer: null

  didInsertElement: ->
    @$("a").on "click", false
    @$("a").on "mouseup mouseleave", => @send "stopIterating"
    @$(".increment").on "mousedown", => @send "startIncrementing"
    @$(".decrement").on "mousedown", => @send "startDecrementing"

  increment: -> @incrementProperty "value", @get("step")
  decrement: -> @decrementProperty "value", @get("step")

  startLoop: (methodName) ->
    method = => @[methodName]()
    method.call()
    @set "timer", setInterval(method, 200)

  actions:
    startIncrementing: -> @startLoop "increment"
    startDecrementing: -> @startLoop "decrement"
    stopIterating: -> clearInterval @get("timer")

`export default component`
