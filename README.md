# Stalker.js

Stalker.js is a generic and unobtrusive web interaction tracking library.

It stays back-end vendor agnostic by allowing developers configure their own vendor strategies.

And it stays unobtrusive by examining UI element behaviors to figure out what to track, rather than requiring UI elements to sign up for tracking, which breaks encapsulation and introduces coupling. Custom non-UI events are also supported.

## API

The API has two parts, defining events and defining server communication strategies.

### Defining Events: UI Elements' Behaviors

    <a data-behavior='{ "type": "users table", "action": "new user button" }'>New User</a>

Stalker finds all UI elements with the data-behavior attribute, listens for click events, and submits events based on the JSON value. Currently only the click event is supported.

### Defining Events: Custom

This is a simple

    Stalker.submit({ ... });

Meant to provide flexibility for non-UI events and ease of integration with legacy systems, as well as to provide shim for features Stalker does not support.

### Defining Server Communication Strategies

    Stalker.server.addStrategy(function (data) {
      if (!mixpanel) return;
      mixpanel.register({ 'Page Title': document.title });

      data.type !== 'time' && mixpanel.track(data.type, data);
    });
