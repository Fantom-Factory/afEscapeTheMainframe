using afIoc
using fwt

** (Service) - 
** An eventing strategy for Reflux Apps.
** 
** To receive events, classes must first register themselves with 'EventHub'. 
** Given 'MyEvents' is an event mixin: 
** 
**   syntax: fantom
**   class MyService : MyEvents {
**       new make(EventHub eventHub) {
**           eventHub.register(this)
**       }
** 
**       override Void onEvent() { ... }
**   } 
** 
** Note that instances of 'Panels', 'Views' and 'GlobalCommands' are already automatically added 
** to 'EventHub' by default. 
@Js
mixin EventHub {

	** Registers an object to receive events. 
	** The object must implement one or more contributed event types else an 'ArgErr' is thrown. 
	abstract Void register(Obj eventSink, Bool checked := true)

	abstract Void deregister(Obj eventSink)

	** Fires an event. There should be very little need to call this directly. 
	** Just '@Inject' the service and call the event method instead! 
	abstract Void fireEvent(Method method, Obj?[]? args := null)
	
	** Fires an event after the given delay. 
	abstract Void fireEventIn(Duration delay, Method method, Obj?[]? args := null)

}

@Js
const class EventTypes {
	const Type[]	eventTypes 
	
	private new make(Type[] eventTypes) {
		this.eventTypes = eventTypes
	}
}

@Js
internal class EventHubImpl : EventHub {
	@Inject private Log			log
	@Inject private EventTypes	eventTypes
			private Obj[]		eventSinks	:= [,]
	
	private new make(|This| in) {
		in(this)
	}

	// TODO: save into map of sinks, for optomidation
	override Void register(Obj eventSink, Bool checked := true) {
		if (!eventTypes.eventTypes.any { eventSink.typeof.fits(it) })
//			if (checked) throw ArgNotFoundErr("EventSink ${eventSink.typeof} does not implement a contributed EventType", eventTypes.eventTypes); else return
			if (checked) throw ArgErr("EventSink ${eventSink.typeof} does not implement a contributed EventType"); else return

		eventSinks.add(eventSink)
	}

	override Void deregister(Obj eventSink) {
		eventSinks.remove(eventSink)
	}

	override Void fireEvent(Method method, Obj?[]? args := null) {
		// TODO: queue up events to prevent infinite recursion
		check
			:= eventTypes.eventTypes.find { it.fits(method.parent) }
//			?: throw ArgNotFoundErr("Method '${method.qname}' does not belong to an event type", eventTypes.eventTypes)
			?: throw ArgErr("Method '${method.qname}' does not belong to an event type")
		
		sinks := eventSinks.findAll { it.typeof.fits(method.parent) }
		
		sinks.each {
			try	method.callOn(it, args)
			catch (Err err)
				log.err(err.msg, err)
		}
	}
	
	override Void fireEventIn(Duration delay, Method method, Obj?[]? args := null) {
		Desktop.callLater(delay) |->| { fireEvent(method, args) }
	}
}
