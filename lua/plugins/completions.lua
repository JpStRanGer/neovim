return {
    -- ─── Snippet-motor ────────────────────────────────────────────────────────
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            -- Egen 'header'-snippet (garanterer at 'header' virker)
            local ls = require("luasnip")
            local s  = ls.s
            local t  = ls.text_node
            local i  = ls.insert_node
            ls.add_snippets("html", {
                s("header", { t("<header>"), i(0), t("</header>") }),
            })
        end,
    },

    -- ─── Ikonbibliotek for completion-menyen ──────────────────────────────────
    -- Viser ikon ved siden av hvert forslag (funksjon, variabel, klasse, osv.)
    { "onsails/lspkind.nvim" },

    -- ─── Hoveddel: nvim-cmp ───────────────────────────────────────────────────
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Kilde: LSP-forslag fra språkserveren
            "hrsh7th/cmp-nvim-lsp",
            -- Kilde: ord fra åpne buffere
            "hrsh7th/cmp-buffer",
            -- Kilde: filstier
            "hrsh7th/cmp-path",
            -- Kilde: kommandolinje-completions (brukes lenger ned)
            "hrsh7th/cmp-cmdline",
            -- Kobler LuaSnip til cmp
            "saadparwaiz1/cmp_luasnip",
            -- Ikonformatering
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- Scroll docs
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Manuell trigger: fang alle vanlige varianter for Ctrl+Space
                    ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }),
                    ["<C-@>"]     = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }), -- mange terminaler sender dette
                    ["<Nul>"]     = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }), -- Kitty / noen sendes som NUL

                    -- Bekreft / Avbryt
                    ["<CR>"]  = cmp.mapping.confirm({ select = true }), -- ENTER = velg forslag
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

                sources = cmp.config.sources({
                    { name = "nvim_lsp",               keyword_length = 1 }, -- LSP-forslag
                    { name = "luasnip",                keyword_length = 1 }, -- snippets
                    { name = "path"                                        }, -- filstier
                }, {
                    -- Andre gruppe: aktiveres bare når gruppe 1 ikke gir forslag
                    { name = "buffer", keyword_length = 3 }, -- ord fra bufferen
                }),

                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                -- Ikonformatering via lspkind
                formatting = {
                    format = lspkind.cmp_format({
                        mode     = "symbol_text", -- vis ikon + tekst
                        maxwidth = 50,
                        menu = {
                            nvim_lsp               = "[LSP]",
                            luasnip                = "[SNIP]",
                            buffer                 = "[BUF]",
                            path                   = "[PATH]",
                        },
                    }),
                },

                -- Vis det første forslaget som grå tekst inline mens du skriver
                experimental = {
                    ghost_text = true,
                },
            })

            -- ─── Kommandolinje-completions ─────────────────────────────────────
            -- "/" og "?" i søk: foreslå ord fra bufferen
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- ":" kommandomodus: foreslå filstier og kommandoer
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
