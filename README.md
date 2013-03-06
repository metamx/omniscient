# Stalker.js

Stalker.js is an event management library that: 

1. translates UI interactions into chronological events that make sence to humans, based on semantic markup and meaningful context labeling.

2. and then executes user configured event handlers.

For instance, it can be used to track events and send them to analytic vendors.

When it catches an event on body, in the capuring phase, Stalker examines the target element, walks up until finding a parent with the "event-context", then puts together the event-context with semnatic markup information to record the event. Custom non-UI events are also supported.

## Getting Started

The library is in build/stalker.js

To edit source, run

    grunt

then edit the source files in src directory.

Install grunt via

    sudo npm install -g grunt-cli

## API

The API has two parts, defining events and defining event handlers.

### Defining Events: UI Elements' Behaviors

Simple example:

    <div class="user-management" data-context="user management panel">
      <p>Manage Users Here</p>
      <button>Add</button>
      <button data-behavior="nothing happened here!">Delete All</button>
    </div>

Clicking the first button will result in Stalker generate the event:

    {
      "context": ["user management panel"],
      "action": "Add"
    }

Clicking the second button will result in Stalker generate the event:

    {
      "context": ["user management panel"],
      "action": "nothing happened here!"
    }

Context is an array of data-context attributes taking from parent elements of the firing element, in the order of higher up to lower down. If none is found, context is set to "global". By default, events with "global" context do not trigger handlers, but the user can manually override that with Stalker.init.

Action is in the innerText of the firing element. Setting data-behavior on the firing element overrides element inner text.

Example of walking up:

    <div class="user-management" data-context="user management panel">
      <p>Manage Users Here</p>
      <a><span>Add</span></a>
      <button data-behavior="nothing happened here!">Delete All</button>
    </div>

Here, clicking on the Add span does not trigger a Stalker event by default, but Stalker is smart enough to walk up the DOM tree and find that the span is nested under a anchor element. So it will behave as if the anchor triggered the event, but use the span's text node as action.

Example of tag masking:

    <div class="user-management" data-context="user management panel">
      <p>Manage Users Here</p>
      <span data-semantic-tag="button">Add</span>
      <button data-behavior="nothing happened here!">Delete All</button>
    </div>

Similarly, clicking on the span will cause Stalker to treat it as a button.

Example of walking down:

    <div class="user-management" data-context="user management panel">
      <p>Manage Users Here</p>
      <a>
        <span class="cal-bears">
          <span>Add</span>
        <span>
      </a>
      <button data-behavior="nothing happened here!">Delete All</button>
    </div>

Here, if the span.cal-bears element gets clicked, Stalker will first walk up to find the anchor, then decide to walk down to the span with text Add. to figure out the action. If the anchor has a data-behavior, it overrides the text to become the action.

### Defining Events: Custom

Example:

    Stalker.submit({ ... });

Simply pass in the event data.

This is meant to provide flexibility for non-UI events and ease of integration with legacy systems, as well as to provide shim for features Stalker does not support.

### Defining Event Handlers

Dummy example:

    Stalker.addHandler(function (data, ev) {
      console.log(JSON.stringify(data));
      console.log(ev);
      console.log(this + '\n');
    });

Example with mixpanel:

    Stalker.addHandler(function (data, ev) {
      // "this" is bound to the firing element
      if (!mixpanel) return;
      mixpanel.register({ 'Page Title': document.title });

      if (data.type !== 'time') mixpanel.track(data.context, data.action);
    });

In the parameters, data is the event data, and "this" is bound to the firing element.

### Complex Events

For complex events that also send state data from other elements. Use custom event tracking.

## Initialization

    Stalker.init({
      tags: ['a', 'button', ... ],
      global: true|false
    });

This can be done whenever after the Stalker library has been loaded. Since Stalker listens to event capturing on body, the init function does not have to be reinvoked everytime new UI elements are added.

Tags default to anchor and button.

Global defaults to false.