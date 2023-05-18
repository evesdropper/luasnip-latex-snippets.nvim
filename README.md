# LuaSnip-LaTeX-Snippets

A set of preconfigured snippets for LaTeX for the snippet engine [LuaSnip](https://github.com/L3MON4D3/LuaSnip).

https://github.com/evesdropper/luasnip-latex-snippets.nvim/assets/82856360/8649e3ea-ea81-4f80-aa28-dc9c51cd4642

## Idea
I’ve created my share of smart snippets for LaTeX, and it might be nice to provide some solid defaults for people using snippets out of the box. Despite this, I would probably recommend others to make their own snippets if they can as the process is far more enjoyable and rewarding. But someone can tell me the same about creating a Neovim plugin while I’m sorely tempted to pay someone off to do the work for me because I really can’t deal with the development process, so do what makes you happy, I guess.


## Installation

Use the package manager of your choice, or don't.

**Lazy.nvim**
```lua
{
    "evesdropper/luasnip-latex-snippets.nvim",
},
```

**Packer.nvim**
```lua
use {
    "evesdropper/luasnip-latex-snippets.nvim",
},
```

## Snippets
See [snippets.md](./snippets.md) for the time being.

## Development Plans

Of course, add more snippets. Ideally would also like to expand this to more languages, allow for better user experience in the future; feel free to make a PR to help contribute your own ideas.

## Acknowledgements
Some similar snippet resources:
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets/)
- [LuaSnip-snippets.nvim](https://github.com/molleweide/LuaSnip-snippets.nvim)
- [luasnip-latex-snippets.nvim](https://github.com/iurimateus/luasnip-latex-snippets.nvim) (Same repo name, different author/snippets)
- [Gilles Castel's LaTeX Snippets](https://github.com/gillescastel/latex-snippets)

Additionally, I would like to thank Max Mehta for bringing up the idea of creating this plugin and the creator of LuaSnip, [L3MON4D3](https://github.com/L3MON4D3), for helping me debug some of the early stages of the plugin. There are also functions scattered throughout the code which are not made by me, so I've posted acknowledgements for those in the comments of the code.
