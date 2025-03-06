return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "saghen/blink.cmp",
    },
    opts = {
        servers = {
            denols = {},
            lua_ls = {},
            rust_analyzer = {},
        },
    },
    config = function(_, opts)
        local lspconfig = require("lspconfig")
        for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end

        -- Alternatively, call setup directly for each LSP:
        --
        -- local capabilities = require('blink.cmp').get_lsp_capabilities()
        -- local lspconfig = require('lspconfig')
        -- lspconfig['lua-ls'].setup({ capabilities = capabilities })

        -- Create autocmd to run when LSP attaches to a buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                -- helper function to define LSP mappings
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("<leader>ca", vim.lsp.buf.code_action, "[A]ction", { "n", "x" })
                map("<leader>cd", vim.diagnostic.open_float, "[D]iagnostic")
                map("<leader>cr", vim.lsp.buf.rename, "[R]ename")

                local builtin = require("telescope.builtin")
                map("gd", builtin.lsp_definitions, "[G]oto [D]efinitions")
                map("gr", builtin.lsp_references, "[G]oto [R]eferences")
                map("gi", builtin.lsp_implementations, "[G]oto [I]mplementations")

                map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        -- Change diagnostic symbols in the sign column (gutter)
        if vim.g.have_nerd_font then
            local signs = { ERROR = "", WARN = "", INFO = "", HINT = "" }
            local diagnostic_signs = {}
            for type, icon in pairs(signs) do
                diagnostic_signs[vim.diagnostic.severity[type]] = icon
            end
            vim.diagnostic.config({ signs = { text = diagnostic_signs } })
        end
    end,
}
