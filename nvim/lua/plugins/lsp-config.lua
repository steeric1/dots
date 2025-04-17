return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "intelephense" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.intelephense.setup({
				capabilities = capabilities,
				settings = {
					intelephense = {
						files = {
							maxSize = 5000000,
						},
					},
				},
			})

			-- KEYMAPS
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

			local fzfCa = function()
				require("fzf-lua").lsp_code_actions({
					winopts = {
						relative = "cursor",
						width = 0.6,
						height = 0.6,
						row = 1,
						preview = { vertical = "up:70%" },
					},
				})
			end

			vim.keymap.set({ "n", "v" }, "<leader>ca", fzfCa, {})
			-- /KEYMAPS

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			vim.o.signcolumn = "yes"
		end,
	},
}
