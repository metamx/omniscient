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

Example markup:

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

Tags default to link and button.

Global defaults to false.