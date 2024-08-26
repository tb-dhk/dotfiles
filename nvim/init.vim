set rtp +=~/.config/nvim

call plug#begin('~/.vim/plugged')

Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

call plug#end()

colorscheme catppuccin

" write code below to source this file automatically
autocmd BufWritePost init.vim source %
