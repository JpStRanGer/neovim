return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function ()
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Egen 'header'-snippet (garanterer at 'header' virker)
            local ls = require("luasnip")
            local s  = ls.s
            local t  = ls.text_node
            local i  = ls.insert_node
            ls.add_snippets("html", {
              s("header", { t("<header>"), i(0), t("</header>") }),
            })
        end
    },
    {
        "saadparwaiz1/cmp_luasnip",
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {},
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            vim.keymap.set("i", "<C-a>", function()
                print("got <C-a>")
            end)

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- Scroll docs
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    --  MANUELL TRIGGER: fang alle vanlige varianter for Ctrl+Space
                    ["<C-Space>"] = cmp.mapping.complete({  reason = cmp.ContextReason.Manual } ),
                    ["<C-@>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }), -- mange terminaler sender dette
                    ["<Nul>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }), -- Kitty / noen sendes som NUL

                    -- Bekreft / Avbryt
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- ENTER = velg forslag
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end,

                    ["<S-Tab>"] = function(fallback)
                       if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end,
                }),
                sources = {
                    { name = "nvim_lsp", keyword_length = 1 }, -- ← LSP-forslag
                    { name = "luasnip",  keyword_length = 1 }, -- ← forslag fra luasnip
                    { name = "buffer",   keyword_length = 1 }, --eneste kilde: teksten i bufferen
                    { name = "path" },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[SNIP]",
                            buffer = "[BUF]",
                            path = "[PATH]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },
}
