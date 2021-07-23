# Article Database

`Article Database` (`Articledb`) is a searchable citation and article (PDF) database application for MacOS. `Articledb` turns web-based [adb](https://github.com/kriztioan/adb) into a standalone MacOS application. It does this by being both a web browser and a web-server. The web server capabilities are provided by embedding [civetweb](https://github.com/civetweb/civetweb). `Articledb` is written using `Objective-C`.

 There is tight integration with the [NASA Astrophysics Data System](https://ui.adsabs.harvard.edu/) (`ADS`) through their web API ([free token needed](https://ui.adsabs.harvard.edu/user/account/login)). This allows easy importing of citations and papers (PDF) into `Articledb`. In addition, citations can be imported using [DOIs](https://www.doi.org/), which relies on the services provided by [Crossref](https://www.crossref.org). Existing  [BibTeX](http://www.bibtex.org/Format/) bibliographies can be directly imported into `Articledb` as well.

Citations can be exported as [BibTeX](http://www.bibtex.org/Format/), [MSWord](https://docs.microsoft.com/en-us/office/vba/word/concepts/working-with-word/working-with-bibliographies), and text. [PDFjs](https://mozilla.github.io/pdf.js/) is included to view article PDFs directly from within `Articledb`.

Optionally, `Articledb` translates [BibTeX](http://www.bibtex.org/Format/) journal abbreviations from a bibliography database file that provides mnemonics, e.g., those used by the [ADS](http://adsabs.harvard.edu/abs_doc/aas_macros.html).

There are a number of tools for organizing and maintaining `Articledb`. These include a duplicates record finder, re-indexing, and a DOI finder for records missing one (via [crossref](api.crossref.org)). Furthermore, one can list all keywords and authors in present in `Articledb`.

The look of `Articledb` is theme-able, with a number of themes pre-installed. See [adb](https://github.com/kriztioan/adb) for more details.

## Usage

Building `Articledb` has the following dependencies:

1. `Xcode`
2. `cmake`
3. `GNU` C++ compiler
4. `jemalloc`
5. `openssl`
6. `rapidjson`

The application can be build using `Xcode` or from the command line with:

```shell
xcodebuild build
```

For the latter, the `Articledb` application is found in the `build/Release` folder as `Articledb.app`.

## Notes

1. The web server port number is set  to `7878` by default, but can be changed under ``→`Preferences`, which will sync it with [adb](https://github.com/kriztioan/adb). However, changing the port number from within [adb](https://github.com/kriztioan/adb) at `Config→General→Base URL` will *not* sync with the web server.
2. The PEM certificate file used by `Articledb` defaults to `/private/etc/ssl/cert.pem`, change if needed under `Config→DOI CrossRef→PEM`.
3. The `GNU` C++ compiler is hardcoded to `g++-11` in `adb/CMakeLists.txt`, change if needed.
4. The `OPENSSL_ROOT_DIR` is hardcoded to `/usr/local/Cellar/openssl@1.1/1.1.1k/` in `adb/CMakeLists.txt`, change if needed.

## BSD-3 License

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
