camelwords.vim
==============

Vim defines two kinds of words - `words` and `WORDS` - corresponding to the
lowercase (`w`, `b`, `e`, `ge`) and uppercase (`W`, `B`, `E`, `gE`) motions.
This plugin defines a third kind - _camelwords_ - letting you navigate more
easily within CamelCase and snake\_case words.

Vim's help files defines as `word` as a sequence of letters, digits and
underscores (call these keywords), or a sequence of other non-blank
characters, separated with white space.  A camelword is much like a `word`,
but divides keywords into smaller parts.  The different parts are listed
below, in order of precedence.

* A _number_ consists of a sequence of digits.
* A _camelhump_ consists of an uppercase character followed by a sequence of
  lowercase characters.
* An _uppercase word_ consists of a sequence of uppercase characters.
* A _lowercase word_ consists of a sequence of lowercase characters.

Underscores are never treated as part of a camelword.

Installation
------------

Install as usual with your favorite plugin manager.  If you have no favorite
plugin manager, check out [Vundle](https://github.com/gmarik/Vundle.vim) or
[Pathogen](https://github.com/tpope/vim-pathogen).

Configuration
-------------

In order for the plugin to create any mappings, you have to tell it what keys
(or key sequences) you want it to use as corresponding to `w`, `b` and `e` for
`words`.  I recommend `<A-W>`, `<A-B>` and `<A-E>`.  Put the following in your
`.vimrc`:

    let g:camelwords_mapping_w = "<A-W>"
    let g:camelwords_mapping_b = "<A-B>"
    let g:camelwords_mapping_e = "<A-E>"

The plugin will then create mappings corresponding to `w`, `b`, `e`, `ge`,
`iw` and `aw`, using whatever keys you specified, and matching Vim's default
behavior as closely as possible (apart from operating on camelwords instead of
`words` of course).

Unfortunately, some setups have problems with mapping the ALT key.  On my Mac,
I have to write like this:

    let g:camelwords_mapping_w = "∑"
    let g:camelwords_mapping_b = "∫"
    let g:camelwords_mapping_e = "é"

The special characters are what I get when pressing `<A-W>` etc. in
insert-mode.  It is also possible to specify `w`, `b` and `e`, to have the
plugin take over Vim's native commands, should you so desire.

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
