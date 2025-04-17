return {
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
			hint_enable = false,
			hint_prefix = "🐾 ",
            floating_window = true,
            always_trigger = true,
		},
		-- or use config
		-- config = function(_, opts) require'lsp_signature'.setup({you options}) end
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
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
			-- Set up nvim-cmp.
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			local snippet_entry_filter = function()
				local context = require("cmp.config.context")
				return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						entry_filter = snippet_entry_filter,
					},
					{
						name = "luasnip",
						entry_filter = snippet_entry_filter,
					},
				}, {
					{ name = "buffer" },
				}),
				enabled = function()
					local disabled = false
					disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
					disabled = disabled or (vim.fn.reg_recording() ~= "")
					disabled = disabled or (vim.fn.reg_executing() ~= "")
					disabled = disabled or require("cmp.config.context").in_treesitter_capture("comment")
					return not disabled
				end,
				formatting = {
					format = function(entry, vim_item)
						-- Remove the LSP function label like "Function"
						vim_item.menu = nil
						return vim_item
					end,
				},
			})
		end,
	},
}
