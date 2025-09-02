-- Normalize buffer numbers for LSP requests. Some plugins pass
-- `vim.api.nvim_get_current_buf` directly which results in "bufnr:
-- expected number, got function" when the LSP client makes a request.
local client = require("vim.lsp.client")
local orig_request = client.request
client.request = function(self, method, params, handler, bufnr)
    if type(bufnr) == "function" then
        bufnr = bufnr()
    end
    if type(bufnr) ~= "number" then
        bufnr = vim.api.nvim_get_current_buf()
    end
    return orig_request(self, method, params, handler, bufnr)
end

return {
    -- {
    --     "git@github.com:hrsh7th/cmp-nvim-lua.git",
    --     -- "rsh7th/cmp-nvim-lua",
    -- },
    -- {
    --     "hrsh7th/cmp-path",
    -- },
    -- {
    --     "hrsh7th/cmp-buffer",
    -- },
    { "hrsh7th/cmp-nvim-lsp" },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",

        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local ls = require("luasnip")
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
            -- vim.keymap.set({ "i" }, "<C-K>", function()
            --     ls.expand()
            -- end, { silent = true })
            -- vim.keymap.set({ "i", "s" }, "<C-L>", function()
            --     ls.jump(1)
            -- end, { silent = true })
            -- vim.keymap.set({ "i", "s" }, "<C-J>", function()
            --     ls.jump(-1)
            -- end, { silent = true })
            --
            -- vim.keymap.set({ "i", "s" }, "<C-E>", function()
            --     if ls.choice_active() then
            --         ls.change_choice(1)
            --     end
            -- end, { silent = true })

            cmp.setup({
                experimental = {
                    ghost_text = true,
                },
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-q>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    -- { name = "vsnip" }, -- For vsnip users.
                    { name = "luasnip" }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                }, {
                    { name = "buffer" },
                }),

            })
            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },
}
