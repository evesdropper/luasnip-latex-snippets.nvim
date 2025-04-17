# LuaSnip-LaTeX-Snippets

A set of preconfigured snippets for LaTeX for the snippet engine [LuaSnip](https://github.com/L3MON4D3/LuaSnip).

> ⚠️ **Note**: My implementation is based on [VimTeX](https://github.com/lervag/vimtex) for a portion of the functionality; see the acknowledgements section for alternatives if VimTeX is not an option. I'm also hoping to adopt treesitter support later on, as mentioned a while ago in [this issue](https://github.com/evesdropper/luasnip-latex-snippets.nvim/issues/1).

https://github.com/evesdropper/luasnip-latex-snippets.nvim/assets/82856360/8649e3ea-ea81-4f80-aa28-dc9c51cd4642

## Todo
I had some ideas, but I haven't had the time to work on them. I've just written them down. Feel free to remind me or take charge of a particular issue if I don't complete these in the next few months. The hope is that this is backwards compatible so as to not break previous configs.
- [ ] Treesitter support (there's a convenient [snippet in LuaSnip wiki](https://github.com/L3MON4D3/LuaSnip/wiki/Misc#mathematical-context-detection-for-conditional-expansion-without-relying-on-vimtexs-in_mathzone) that can be leveraged); conditional snippets will be updated to use VimTeX first, then Treesitter as a fallback.
- [ ] Configuration
    - [ ] Enabling/disabling snippets/groups of snippets
    - [ ] Changing triggers for snippets
- [ ] Exposing the [scaffolding](./lua/luasnip-latex-snippets/luasnippets/tex/utils/scaffolding.lua) functions as a way to generate custom snippets. I want to say that this technically already exists, you can probably require this plugin's utils and use the scaffolding to create your own snippets, though I haven't tried it yet. It would be nicer in conjunction with enabling/disabling snippets as it is possible to disable these snippets entirely and make your own from scaffolding.

---

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

See Todo from above first. Also, add more snippets. Ideally would also like to expand this to more languages, allow for better user experience in the future; feel free to make a PR to help contribute your own ideas.

## Acknowledgements
Some similar snippet resources:
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets/)
- [LuaSnip-snippets.nvim](https://github.com/molleweide/LuaSnip-snippets.nvim)
- [luasnip-latex-snippets.nvim](https://github.com/iurimateus/luasnip-latex-snippets.nvim) (Same repo name, different author/snippets)
- [Gilles Castel's LaTeX Snippets](https://github.com/gillescastel/latex-snippets)

Additionally, I would like to thank Max Mehta for bringing up the idea of creating this plugin and the creator of LuaSnip, [L3MON4D3](https://github.com/L3MON4D3), for helping me debug some of the early stages of the plugin. There are also functions scattered throughout the code which are not made by me, so I've posted acknowledgements for those in the comments of the code.
