return {
	{
		"folke/tokyonight.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				style = "moon",
				transparent = true,
			}
		end,
	},
}