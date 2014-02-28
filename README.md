
# color-theme-approximate

Better degration for color theme in terminal.
Inspired by: Vim's CSApprox
<http://www.vim.org/scripts/script.php?script_id=2390>

Color themes usually defined in 24bit, while terminals normally
only support 256 colors (8bit). Emacs' default degration algorithm doesn't
work well in some systems, especially Linux. This package provides a better
degration results by alter the default degrading algorithm.

Preview with [Twilight Anti-Bright Theme](preview/twilight-anti-bright.png) by
[Jim Myhrberg](https://github.com/jimeh)

![Twilight Anti-Bright Theme](https://github.com/tungd/color-theme-approximate/raw/master/preview/twilight-anti-bright.png)

Note that I only encountered the problem in Linux, on Mac OS X the degration
seems to work so you don't need this package.

## Installation and Usage

### Emacs 24

* Install the package via [MELPA](http://melpa.milkbox.net/), or add the package's
  directory to `load-path`

* Add to your Emacs init file:

        (color-theme-approximate-on)

Note: I test this only on Emacs 24.1 and above. Pull requests for supporting
other versions are welcomed.

## Credits

Tung Dao <me@tungdao.com>

## License

[BSD](http://opensource.org/licenses/BSD-3-Clause)
