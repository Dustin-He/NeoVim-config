local vimtex = {{
    "lervag/vimtex",
    -- version="*",
    -- lazy = true,
    -- ft = {"tex", "bib"},
    init = function ()
        vim.cmd([[ 
            let g:vimtex_quickfix_mode = 0
            let g:tex_flavor = 'latex'
            let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
            let g:vimtex_view_general_options = '-r @line @pdf @tex'
            let g:vimtex_view_method = 'skim'
            let g:vimtex_view_skim_sync = 1
            let g:vimtex_view_skim_activate = 1
            let g:vimtex_view_automatic = 1
            let g:vimtex_compiler_latexmk = {'continuous' : 0}
            let g:vimtex_complete_enabled = 0
            let g:vimtex_syntax_enabled = 0
            let g:vimtex_compiler_latexmk_engines = {
                \'_'    : '-pdflatex',
            \}

            function ViewClean()
                VimtexView
                VimtexClean
            endfunction
            augroup vimtex_cmds
                autocmd!
                autocmd User VimtexEventCompileSuccess call ViewClean()
            augroup END
        ]])
    end
}}

return vimtex
