return {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
        spec = {
            { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>f", group = "[F]ind" },
            { "<leader>t", group = "[T]oggle" },
            { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
            { "<leader>w", group = "[W]orkspace" },
        },
    },
}
