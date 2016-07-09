# MAC address label printer

Simple Ruby script to create a MAC address label in three different formats
(1D barcode, textual and as QR Code).

By default it creates PDF files in DIN A5 format, suitable for easy visibility.
There are no configuration options (yet), but the code should be simple enough to
perfom miniscule changes on an "as needed" basis.


## Dependencies

As per usual, install Ruby and Bundler. Ruby 2.3 is recommended, but 2.0+
should work as well. Then install the dependencies with:

    $ bundle install


## Quickstart

The `label.rb` creates a PDF file for each argument passed, i.e.:

    $ ./label.rb 12:34:56:78:90:AB 00:11:22:33:44:55
    Written 12:34:56:78:90:AB to 1234567890AB.pdf
    Written 00:11:22:33:44:55 to 001122334455.pdf

You can then print it via `lp`:

    $ lp -p $PRINTER_NAME -o media=a5 1234567890AB.pdf 001122334455.pdf
    request id is PRINTER-NAME-42 (2 file(s))


## History

This script was built as an internal library at [Digineo GmbH](https://www.digineo.de)
and made publicly available in 2016.


## License (MIT)

Copyright (c) 2016 Dominik Menke `<dom plus oss at digineo dot de`, Digineo GmbH

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
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
