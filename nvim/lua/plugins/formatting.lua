return {
	{
		"stevearc/conform.nvim",
		opts = function()
			local opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					fish = { "fish_indent" },
					sh = { "shfmt" },
					go = { "goimports", "gofmt" },
					python = { "isort", "black" },
				},
				formatters = {
					black = {
						prepend_args = { "--fast" },
					},
				},
			}
			return opts
		end,
	},
}
