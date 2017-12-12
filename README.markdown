camelwords.vim
==============

Vim defines two kinds of words - `words` and `WORDS` - corresponding to the
lowercase (`w`, `b`, `e`, `ge`) and uppercase (`W`, `B`, `E`, `gE`) motions.
This plugin defines a third kind - _camelwords_ - letting you navigate more
easily within CamelCase and snake\_case words.

Vim's help files describe a `word` as a sequence of letters, digits and
underscores (call these keywords), or a sequence of other non-blank
characters, separated with white space.  A camelword is much like a `word`,
but divides keywords into smaller parts.  The different parts are listed
below, in order of precedence.

* _Numbers_ consist of a sequence of digits.
* _Camelhumps_ consist of an uppercase character followed by a sequence of
  lowercase characters.
* _Uppercase words_ consist of a sequence of uppercase characters.
* _Lowercase words_ consist of a sequence of lowercase characters.

Underscores are never treated as part of a camelword.

Below are some examples. The top line shows where the `words` are, the bottom
line shows where the camelwords are.

    ┌───────────┐  ┌─────────────┐  ┌─────┐  ┌───────────┐  ┌────────┐
    CamelCaseWord  snake_case_word  OpenSSL  SOME_CONSTANT  123testing
    └───┘└──┘└──┘  └───┘ └──┘ └──┘  └──┘└─┘  └──┘ └──────┘  └─┘└─────┘

Installation
------------

Install as usual with your favorite plugin manager.  If you have no favorite
plugin manager, check out [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen).

Configuration
-------------

You can specify what keys (or key sequences) you want it use as corresponding
to `w`, `b` and `e` for `words`.  I recommend using Alt-W, Alt-B and Alt-E,
which can unfortunately be a problem to map on some setups.  The default is to
use a sequence that gives those mappings in a standard terminal.  Set these
globals in your `.vimrc` to customize (shown is the default):

    let g:camelwords_mapping_w = "w"
    let g:camelwords_mapping_b = "b"
    let g:camelwords_mapping_e = "e"

The plugin will then create mappings corresponding to `w`, `b`, `e`, `ge`,
`iw` and `aw`, using whatever keys you specified, and matching Vim's default
behavior as closely as possible (apart from operating on camelwords instead of
`words`, of course).

On my Mac, I have to write like this:

    let g:camelwords_mapping_w = "∑"
    let g:camelwords_mapping_b = "∫"
    let g:camelwords_mapping_e = "é"

The special characters are what I get when pressing `<A-W>` etc. in insert
mode.  Please note that those are what I get with a Danish keyboard, it might
not work to just copy the above. Please consult the internet if you cannot get
the ALT mappings to work, it probably has nothing to do with this plugin.

If you cannot get the ALT mappings to work, or if you prefer otherwise it is
of course possible to specify whichever sequences you like.  Some people might
like to use something like `<leader>w`, etc.  It is also possible to specify
`w`, `b` and `e`, to have the plugin take over Vim's native commands, should
you so desire.

Credits
-------

This plugin was inspired by Kevin Le's
[CamelCaseMotion](https://github.com/bkad/CamelCaseMotion),
a fork of Ingo Karkat's
[plugin](http://www.vim.org/scripts/script.php?script_id=1905)
of the same name, itself inspired by
[Vim Tip #1016](http://vim.wikia.com/wiki/Moving_through_camel_case_words),
by Anthony Van Ham.  I have reused and refined some of the techniques used by
them.
