dialog-polyfill.js is a polyfill for `<dialog>`.

`<dialog>` is an element for a popup box in a web page. See
[more information and demos](http://falken-testing.appspot.com/dialog/index.html)
and the
[HTML spec](http://www.whatwg.org/specs/web-apps/current-work/multipage/commands.html#the-dialog-element).

### Example

    <head>
      <script src="dialog-polyfill.js"></script>
      <link rel="stylesheet" type="text/css" href="dialog-polyfill.css">
    </head>
    <body>
      <dialog>I'm a dialog!</dialog>
      <script>
        var dialog = document.querySelector('dialog');
        dialogPolyfill.registerDialog(dialog);

        // Now dialog acts like a native <dialog>.
        dialog.showModal();
      </script>
    </body>

### ::backdrop

In native `<dialog>`, the backdrop is a pseudo-element:

    #mydialog::backdrop {
      background-color: green;
    }

With the polyfill, you do it like:

    #mydialog + .backdrop {
      background-color: green;
    }

### Known limitations

- Modality isn't bulletproof. For example, you can tab to inert elements.
- The polyfill `<dialog>` should always be a child of `<body>`.
- Polyfill top layer stacking can be ruined by playing with z-index.
- The polyfill `<dialog>` does not retain dynamically set CSS top/bottom values
upon close.
- Anchored positioning is not implemented. The native `<dialog>` in Chrome
doesn't have it either.
