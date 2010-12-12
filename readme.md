# Contact

A really tiny Sinatra application that e-mails POST-data. It is meant to be used as a callback for contact forms.

## Installation

As a Sinatra application, Contact requires a working installation of Ruby and Rubygems. Make sure you install the required gems first:

    $ gem install sinatra pony

Then you can simply run the application using Ruby:

    $ ruby contact.rb

...or refer to your web hosts documentation on running Rack apps using the supplied `config.ru` file.

## Description

In essence, this is a simple wrapper around the Pony gem. It allows you to submit a form from any website to this app, which will then use Pony to e-mail the data somewhere.

Where the data is sent depends on your configuration. A submitting form identifies itselfs with an API key. A simple configuration file associates a target address, return URL and other settings for that key. This way, only authorised forms can send mail using this app, and it can only be sent to pre-configured addresses.

The app provides some simple validation to prevent spammy abuse of the form, as well as message templating. You can associate a message template with an API key, wherein all POSTed values will be interpolated.

Example template:

    This was posted:
    name: {name}
    email: {email}

When someone POSTs `{ 'name' => 'foo', 'email' => 'bar', 'baz' => 'qux' }` this would result in following message:

    This was posted:
    name: foo
    email: bar

Apart from deployment targets, the configuration file is also used for defining return URLs and e-mail sending options for Pony.

## To do

This is still very much a work in progress. Here are some planned features:

* Catch all variables in a template (properly escaped)
* A simple front-end for managing deployment targets
* Ajax validations
* Storing e-mails, even invalid ones, in a database or logging system

## History

(unreleased)

## Credits

Author: Arjan van der Gaag <arjan@arjanvandergaag.nl>
URL: http://arjanvandergaag.nl

## License

Copyright (c) 2010 Arjan van der Gaag

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

