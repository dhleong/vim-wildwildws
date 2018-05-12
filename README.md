wildwildws
==========

*A better way to wrangle websockets*

## What?

wildwildws (pronounced "Wild Wild Wess") is a Vim plugin inspired by
[vial-http][1] that lets you establish and maintain a Websocket connection
from the comfort of a Vim buffer. wildwildws supports sending HTTP headers
with the initial request, and any paragraph in the buffer can be sent
as text to the connection, and responses are echo'd in a separate window.

## How?

First, install with your favorite method. You'll also need [wildwildws-d][2],
which is available via npm. I like [vim-plug][3], which can do both:

```vim
Plug 'dhleong/vim-wildwildws', {'do': 'npm i -g wildwildws-d'}
```

Once installed, you can either create a file that ends in `.wwws`, or
pass an url to the `:WWWS` command, which will do a tiny bit of setup
for you:

```vim
:WWWS ws://demos.kaazing.com/echo
```

Either way, your `.wwws` file needs to contain a line that looks like this:

```javascript
URI: ws://demos.kaazing.com/echo
```

This tells wildwildws where to connect. With this in your file, wildwildws by default will automatically connect for you when you save the file.

Once connected, simply press the enter key in normal mode to send the
paragraph under the cursor to the connection. Easy!

Output from the server is printed in a separate buffer that is opened
for you. It's a normal buffer, so you can navigate to it and manipulate
its text in all the normal Vim ways.

wildwildws will automatically dispose the output window when you close
the `.wwws` buffer, and will also disconnect for you. If you need to
disconnect sooner, a `:Disconnect` command is provided.

### Headers

If you need to send headers along with your initial HTTP request, you can
just put them on their own lines, much like the `URI:` directive. For example:

```javascript
URI: ws://localhost:3000/api/ws
Authorization: Token {"username":"Bar"}
X-Format: compressed
```

will send the `Authorization` and `X-Format` headers. Also easy!

### Commands

`:Send` will send all the arguments as-is to the server as text.

`:Disconnect`
`:Connect` both do what you'd expect.

### Options

See [this file][4] for all the options with explanations. Help files to
come... eventually.

### Functions

If you want to write your own mappings, `wwws#conn#Open()` and
`wwws#conn#Close()` open and close the connection for the current
`.wwws` buffer, respectively. `wwws#conn#Send()` accepts a single
string and sends it directly.

[1]: https://github.com/baverman/vial-http
[2]: https://github.com/dhleong/wildwildws-d
[3]: https://github.com/junegunn/vim-plug
[4]: https://github.com/dhleong/vim-wildwildws/blob/master/plugin/wwws.vim
