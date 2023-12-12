# Snippets

Temp snippet document until I get a solution made with LuaSnip's `snippet_list`. It may be a bit terse, so feel free to make an issue or reformat it.

> :warning: **Warning:** As mentioned in the README, most snippets require [VimTeX](https://github.com/lervag/vimtex) for the condition/show-condition to work.

## `commands.lua`

### Labels/References
- `alab`: add label, of the form `\label{${1:type}:${2:number}}$0`
- `[acCer]ref`: add reference of the form `\(auto|c|C|eqn)ref{${1:type}:${2:number}}$0`
    * `cref/Cref` requires the `cleveref` package

### Single-Command Snippets
All of them are of the form `\COMMAND_NAME{$1}$0`, with those with `*` also having labels of the form `\label{type:${1:number}}`

- `sec(*)`, `ssec(*)`, `sssec(*)`*: section, subsection, subsubsection respectively. Add `*` for the starred commands.
- `sq`, `qq`: enquote* and enquote (single and double quotes). Requires `csquotes` package.
- `bf`, `it`, `ttt`, `sc`, `tu`, `tov`: Text modifications (bold, italic, typewriter, small caps, underline, and overline).

## `environments.lua`

`beg` creates a generic environment snippet.

```tex
\begin{$1}
$0
\end{$1}
```

`-i` creates the itemize environment, and there's a choice of which bullet point to set (either default or custom bullets with `\item []` notation).

```tex
\begin{itemize}
\item ${1:[$2]|}
\end{itemize}
```

`-e` deals with the enumerate environment. This one is a bit more involved than the itemize environment snippet, as it allows you to choose which labels and provides two defaults, lowercase roman numerals and lowercase alphabetical characters.
```tex
\begin{enumerate}${1:|[label=${2:(\alph*)|(\roman*)|}]}
\item ${3:[$4]|}
\end{enumerate}
```

`--`, `!-` are the accompanying commands for bullet points, which map to `\item` and `\item []` respectively. These only work at the beginning of the line in itemize/enumerate environments.


## `math.lua`

### Entering Math Mode
- `mk`: inline math `$$1$$0`
- `dm`: display math
- `ali`: align(|*|ed)
- `gat`: gather(|*|ed)
- `eqn`: equation(|*)

### Useful Math Dynamic Snippets
`[bBpvV]mat(%d)x(%d)(a|r)`: creates a dxd matrix, either augmented or not. Requires [this fix](https://tex.stackexchange.com/a/2238) for augments.

For instance, `bmat2x2r` creates:
```tex
\begin{bmatrix}
$1 & $2 \\
$3 & $4 \\
\end{bmatrix}
```

`(%d)?cases`: creates a cases array with d rows; if no input is supplied it defaults to 2 rows.

For instance, `3cases` creates:
```tex
\begin{cases}
$1 & $2 \\
$3 & $4 \\
$5 & $6 
\end{cases}
```

## `math-commands.lua`
These are somewhat self-explanatory unless someone convinces me otherwise.

## `delimiters.lua`

`lr(aAbBcmp)` creates a snippet of the form `\left[delim] $1 \right[delim] $0`; delimiters are created following this table:

```lua
-- brackets
local brackets = {
	a = { "\\langle", "\\rangle" },
	A = { "Angle", "Angle" },
	b = { "brack", "brack" },
	B = { "Brack", "Brack" },
	c = { "brace", "brace" },
	m = { "|", "|" },
	p = { "(", ")" },
}
```
