return {
	{
		"stevearc/conform.nvim",
		opts = function()
			local opts = {
				formatters_by_ft = {
					go = { "goimports", "gofmt" },
					python = { "isort", "black" },
				},
			}
			return opts
		end,
	},
}
