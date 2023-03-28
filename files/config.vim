set runtimepath+=/usr/local/share/nvim
set nocompatible
filetype plugin on
filetype indent on
syntax on
set number
set relativenumber
set mouse=a
set nobackup
set nowb
set noswapfile
set nofoldenable
set showtabline=2
set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
set clipboard=unnamedplus
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>
set wildmenu
xnoremap <expr> p 'pgv"'.v:register.'y'
map <C-Left> <C-w>h
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l
map <S-Right> :tabn<CR>
map <S-Left>  :tabp<CR>
set backspace=indent,eol,start
set noexpandtab
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4
set belloff=all
set updatetime=100
set colorcolumn=80
au FileType gitcommit setlocal colorcolumn=72
set laststatus=2
set noshowmode
set hidden
set autoread
au FocusGained * :checktime
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
xnoremap <  <gv
xnoremap >  >gv
set splitright
set splitbelow
set history=1000
set winminheight=0
set nowrap
set nospell
set list

function! TUOSDESourceFileIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call plug#begin('/usr/share/nvim/runtime/plugged')
Plug 'nvim-lualine/lualine.nvim', { 'commit': '9d177b668c18781c53abde92116f141f3d84b04c' }
Plug 'tpope/vim-fugitive', { 'commit': '49cc58573e746d02024110d9af99e95994ea4b72' }
Plug 'airblade/vim-gitgutter', { 'commit': '400a12081f188f3fb639f8f962456764f39c6ff1' }
Plug 'easymotion/vim-easymotion', { 'commit': 'b3cfab2a6302b3b39f53d9fd2cd997e1127d7878' }
Plug 'kshenoy/vim-signature', { 'commit': '6bc3dd1294a22e897f0dcf8dd72b85f350e306bc' }
Plug 'conradirwin/vim-bracketed-paste', { 'commit': 'c4c639f3cacd1b874ed6f5f196fac772e089c932' }
Plug 'jeffkreeftmeijer/vim-numbertoggle', { 'commit': '075b7478777e694fbac330ee34a74590dad0fee1' }
Plug 'RRethy/vim-illuminate', { 'commit': '8fe150bd775f659da7e40ea2d3ad7473e6d29494' }
Plug 'ludovicchabant/vim-gutentags', { 'commit': '1337b1891b9d98d6f4881982f27aa22b02c80084' }
Plug 'tpope/vim-commentary', { 'commit': 'e87cd90dc09c2a203e13af9704bd0ef79303d755' }
Plug 'rbgrouleff/bclose.vim', { 'commit': '99018b4a2dd18aea1cbd3aa23565b01a0f8c5b73' }
Plug 'svermeulen/vim-cutlass', { 'commit': '7afd649415541634c8ce317fafbc31cd19d57589' }
Plug 'inkarkat/vim-ingo-library', { 'commit': '51703e0f5fc73836b8e5be222f6eebde1891a664' }
Plug 'inkarkat/vim-mark', { 'commit': '19757f529eab5bd3eb406ac03f62c961c75a17dc' }
Plug 'farmergreg/vim-lastplace', { 'commit': 'd522829d810f3254ca09da368a896c962d4a3d61' }
Plug 'rhysd/committia.vim', { 'commit': '1d288281586d1e6b52646a4c412df3dd3a2fe231' }
Plug 'machakann/vim-highlightedyank', { 'commit': '931cc6bd53e4a1fdbe592751f0e13c0e401f0a49' }
Plug 'preservim/tagbar', { 'commit': '6c3e15ea4a1ef9619c248c2b1eced56a47b61a9e' }
Plug 'nvim-lua/plenary.nvim', { 'commit': '4b7e52044bbb84242158d977a50c4cbcd85070c7' }
Plug 'nvim-telescope/telescope.nvim', { 'commit': '7a4ffef931769c3fe7544214ed7ffde5852653f6' }
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '24caa23402247cf03cfcdd54de8cdb8ed00690ba', 'do': ':TSUpdate' }
Plug 'folke/tokyonight.nvim', { 'commit': '62b4e89ea1766baa3b5343ca77d62c817f5f48d0' }
Plug 'sindrets/diffview.nvim', { 'commit': 'f32a7224096cca11c3c91b0dd412808e63f3d720' }
Plug 'renerocksai/telekasten.nvim', { 'commit': 'ff85b22fb4a14ec0e67abe70a00e9681b55d88db' }
Plug 'renerocksai/calendar-vim', { 'commit': 'a7e73e02c92566bf427b2a1d6a61a8f23542cc21' }
Plug 'nvim-tree/nvim-web-devicons', { 'commit': '3b1b794bc17b7ac3df3ae471f1c18f18d1a0f958' }
Plug 'luukvbaal/nnn.nvim', { 'commit': '17f05c306e6906b4b6cd477e603697fd352960e8' }
Plug 'FeiyouG/command_center.nvim', { 'commit': '0d820c438c871fe31ed942bc592a070da1564141' }
Plug 'ibhagwan/fzf-lua', { 'commit': '02bde5fae96772729004743f0f309c35c5182b83' }
call TUOSDESourceFileIfExists("/usr/share/nvim/additional_plugins.vim")
call plug#end()

lua << END
require("tokyonight").setup {
  style = "moon",
  light_style = "day",
  transparent = false,
  terminal_colors = true,
  styles = {
    sidebars = "dark",
    floats = "normal",
  },
  sidebars = { "qf", "help", "nnn", "tagbar" },
  day_brightness = 0.3,
  hide_inactive_statusline = true,
  dim_inactive = true,
  lualine_bold = false,
}
END

colorscheme tokyonight

set signcolumn=yes

let g:EasyMotion_off_screen_search = 0
let g:EasyMotion_verbose = 0

hi link illuminatedWord Visual

nnoremap <leader>cb :set background=<C-R>=&background == 'dark' ? 'light' : 'dark'<CR><CR>

let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_file_list_command = {
  \ 'markers': {
    \ '.git': 'git ls-files',
  \ },
\ }
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+ailmnS',
      \ ]

let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')

nnoremap x d
xnoremap x d

let g:mwDefaultHighlightingPalette = 'maximum'

nmap <leader>sh :split<CR>
nmap <leader>sv :vsplit<CR>

let g:vim_search_pulse_duration = 200

let g:tagbar_compact = 1
let g:tagbar_width = 70
let g:tagbar_silent = 1

call TUOSDESourceFileIfExists("/usr/share/nvim/additional_configuration.vim")

lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END

lua << END
require('diffview').setup {
  use_icons = false,
  file_panel = {
    listing_style = "list",
  },
}
END

lua << END
local home = vim.fn.expand("~/zettelkasten")
require('telekasten').setup {
    home = home,
    take_over_my_home = true,
    auto_set_filetype = true,
    dailies      = home .. '/' .. 'daily',
    weeklies     = home .. '/' .. 'weekly',
    templates    = home .. '/' .. 'templates',
    image_subdir = "img",
    extension    = ".md",
    new_note_filename = "title",
    uuid_type = "%Y%m%d%H%M",
    uuid_sep = "-",
    follow_creates_nonexisting = true,
    dailies_create_nonexisting = true,
    weeklies_create_nonexisting = true,
    journal_auto_open = false,
    template_new_note = home .. '/' .. 'templates/new_note.md',
    template_new_daily = home .. '/' .. 'templates/daily.md',
    template_new_weekly= home .. '/' .. 'templates/weekly.md',
    image_link_style = "markdown",
    sort = "filename",
    plug_into_calendar = true,
    calendar_opts = {
        weeknm = 1,
        calendar_monday = 1,
        calendar_mark = 'left-fit',
    },
    close_after_yanking = false,
    insert_after_inserting = true,
    tag_notation = "yaml-bare",
    command_palette_theme = "dropdown",
    show_tags_theme = "dropdown",
    subdirs_in_links = true,
    template_handling = "smart",
    new_note_location = "smart",
    rename_update_links = true,
    follow_url_fallback = nil,
}
END

lua << END
local builtin = require("nnn").builtin
require("nnn").setup {
	picker = {
		cmd = "nnn",
		style = {
			width = 0.4,
			height = 0.6,
			xoffset = 0.5,
			yoffset = 0.5,
			border = "single"
		},
		session = "",
	},
	auto_open = {
		setup = nil,
		tabpage = nil,
		empty = false,
		ft_ignore = {
			"gitcommit",
		}
	},
	auto_close = false,
	replace_netrw = picker,
	mappings = {
		{ "<C-t>", builtin.open_in_tab },
	},
	buflisted = false,
	quitcd = nil,
	offset = false,
}
END

lua << END
local telescope = require("telescope")
local command_center = require("command_center")
local noremap = { noremap = true }

command_center.add({
  {
    desc = "Open command_center",
    cmd = "<CMD>Telescope command_center<CR>",
    keys = {
      {"n", "<Space><Space>", noremap},
      {"v", "<Space><Space>", noremap},
    },
  },
}, command_center.mode.REGISTER_ONLY)

command_center.add({
  {
    desc = "Workspace files",
    cmd = "<CMD>FzfLua git_files<CR>",
    keys = { "n", "<Space>f", noremap },
    category = "git",
  },
  {
    desc = "Workspace files (all)",
    cmd = "<CMD>FzfLua files<CR>",
    keys = { "n", "<Space>F", noremap },
    category = "fzf",
  },
  {
    desc = "Buffer search",
    cmd = "<CMD>FzfLua blines<CR>",
    keys = { "n", "<Space>s", noremap },
    category = "rg",
  },
  {
    desc = "Workspace search",
    cmd = "<CMD>FzfLua grep_project<CR>",
    keys = { "n", "<Space>S", noremap },
    category = "rg",
  },
  {
    desc = "Workspace tags",
    cmd = "<CMD>FzfLua tags<CR>",
    keys = { "n", "<Space>T", noremap },
    category = "ctags",
  },
  {
    desc = "Buffer tags",
    cmd = "<CMD>FzfLua btags<CR>",
    keys = { "n", "<Space>t", noremap },
    category = "ctags",
  },
  {
    desc = "Buffer tags in sidebar",
    cmd = "<CMD>TagbarToggle<CR>",
    keys = { "n", "<Space>q", noremap },
    category = "ctags",
  },
  {
    desc = "Workspace commits",
    cmd = "<CMD>FzfLua git_commits<CR>",
    keys = { "n", "<Space>C", noremap },
    category = "git",
  },
  {
    desc = "Buffer commits",
    cmd = "<CMD>FzfLua git_bcommits<CR>",
    keys = { "n", "<Space>c", noremap },
    category = "git",
  },
  {
    desc = "Buffer blame",
    cmd = "<CMD>Git blame<CR>",
    keys = { "n", "<Space>b", noremap },
    category = "git",
  },
  {
    desc = "File manager",
    cmd = "<CMD>NnnPicker %:p:h<CR>",
    keys = { "n", "<Space>m", noremap },
    category = "nnn",
  },
  {
    desc = "Notes",
    cmd = "<CMD>Telekasten<CR>",
    keys = { "n", "<Space>n", noremap },
    category = "telekasten",
  },
  {
    desc = "Help",
    cmd = "<CMD>help tuosde<CR>",
    keys = { "n", "<Space>h", noremap },
    category = "help",
  },
})

telescope.setup {
  extensions = {
    command_center = {
      components = {
        command_center.component.DESC,
        command_center.component.CATEGORY,
        command_center.component.KEYS,
      },
      auto_replace_desc_with_cmd = false,
    }
  }
}

telescope.load_extension('command_center')
END

lua << END
require('fzf-lua').setup {
  "max-perf",
  winopts = {
    fullscreen       = true,
    preview = {
      vertical       = 'down:40%',
      horizontal     = 'right:40%',
      layout         = 'flex',
      flip_columns   = 120,
    },
  },
  files = {
    prompt            = 'Files: ',
    git_icons         = false,
    file_icons        = false,
    color_icons       = false,
  },
  git = {
    files = {
      prompt        = 'GitFiles: ',
      git_icons     = false,
      file_icons    = false,
      color_icons   = false,
    },
    commits = {
      prompt        = 'Commits: ',
    },
    bcommits = {
      prompt        = 'BCommits: ',
    },
  },
  grep = {
    prompt            = 'Rg: ',
    input_prompt      = 'Grep For: ',
    git_icons         = false,
    file_icons        = false,
    color_icons       = false,
  },
  tags = {
    prompt                = 'Tags: ',
    ctags_file            = nil,
    file_icons            = false,
    git_icons             = false,
    color_icons           = false,
  },
  btags = {
    prompt                = 'BTags: ',
    ctags_file            = nil,
    file_icons            = false,
    git_icons             = false,
    color_icons           = false,
  },
}
END
