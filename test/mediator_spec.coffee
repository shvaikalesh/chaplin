'use strict'
sinon = require 'sinon'
{mediator, Model} = require '../build/chaplin'

describe 'mediator', ->
  it 'should be a simple object', ->
    expect(mediator).to.be.an 'object'

  it 'should be sealed', ->
    expect(mediator).to.be.sealed

  it 'should have seal method and be sealed', ->
    expect(mediator).to.respondTo 'seal'

  it 'should have Pub/Sub methods', ->
    expect(mediator).to.respondTo 'subscribe'
    expect(mediator).to.respondTo 'subscribeOnce'
    expect(mediator).to.respondTo 'unsubscribe'
    expect(mediator).to.respondTo 'publish'

  it 'should have readonly Pub/Sub and Resp/Req methods', ->
    methods = [
      'subscribe', 'subscribeOnce', 'unsubscribe', 'publish',
      'setHandler', 'execute', 'removeHandlers'
    ]

    for method in methods
      expect(mediator).to.have.ownPropertyDescriptor method,
        value: mediator[method]
        writable: false
        enumerable: true
        configurable: false

  it 'should publish messages to subscribers', ->
    spy = sinon.spy()
    eventName = 'foo'
    payload = 'payload'

    mediator.subscribe eventName, spy
    mediator.publish eventName, payload

    expect(spy).to.have.been.calledOnce
    mediator.unsubscribe eventName, spy

  it 'should publish messages to subscribers once', ->
    spy = sinon.spy()
    eventName = 'foo'
    payload = 'payload'

    mediator.subscribeOnce eventName, spy
    mediator.publish eventName, payload
    mediator.publish eventName, 'second'

    expect(spy).to.have.been.calledOnce
    expect(spy).to.have.been.calledWith payload

  it 'should allow to unsubscribe to events', ->
    spy = sinon.spy()
    eventName = 'foo'
    payload = 'payload'

    mediator.subscribe eventName, spy
    mediator.unsubscribe eventName, spy
    mediator.publish eventName, payload

    expect(spy).to.not.have.been.calledWith payload

  it 'should have response / request methods', ->
    expect(mediator).to.respondTo 'setHandler'
    expect(mediator).to.respondTo 'execute'
    expect(mediator).to.respondTo 'removeHandlers'

  it 'should allow to set and execute handlers', ->
    response = 'austrian'
    spy = sinon.stub().returns response
    name = 'ancap'

    mediator.setHandler name, spy
    expect(mediator.execute name).to.equal response