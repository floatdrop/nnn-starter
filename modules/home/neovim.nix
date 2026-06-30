{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # We don't use the Ruby/Python remote-plugin providers; opt out explicitly
    # (also matches the new home-manager defaults and silences the warning).
    withRuby = false;
    withPython3 = false;

    # LSP servers + tools, provided by Nix instead of mason.
    extraPackages = with pkgs; [
      lua-language-server
      nil # nix LSP
      nixd # nix LSP (alt, richer)
      pyright
      rust-analyzer
      typescript-language-server
      svelte-language-server # svelte / sveltekit LSP (svelteserver)
      vscode-langservers-extracted # html, css, json + eslint servers
      gopls # go LSP
      go # gopls shells out to the go toolchain
      zls # zig LSP
      zig # zls shells out to the zig toolchain
      stylua
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      # Treesitter grammars precompiled by Nix (no runtime :TSInstall needed).
      nvim-treesitter.withAllGrammars

      # LSP + completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip

      # Fuzzy finding
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim

      # UI / QoL
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      oil-nvim
      comment-nvim
      nvim-autopairs
      nvim-web-devicons
    ];

    initLua = ''
      -- ── Sane defaults ─────────────────────────────────────────────────────
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      local o = vim.opt
      o.number = true
      o.relativenumber = true
      o.expandtab = true
      o.shiftwidth = 2
      o.tabstop = 2
      o.smartindent = true
      o.ignorecase = true
      o.smartcase = true
      o.termguicolors = true
      o.signcolumn = "yes"
      o.undofile = true
      o.scrolloff = 8
      o.clipboard = "unnamedplus"

      -- ── Plugins ───────────────────────────────────────────────────────────
      -- nvim-treesitter "main" branch: there is no more `.configs` module or
      -- `.setup{}`. Parsers are provided by Nix (withAllGrammars) and live on
      -- the runtimepath, so we start treesitter per buffer. Where a parser is
      -- available we also use treesitter-based indentation (experimental on the
      -- main branch); other filetypes keep Neovim's smartindent, set above.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
      require("gitsigns").setup()
      require("lualine").setup({ options = { theme = "auto", globalstatus = true } })
      require("which-key").setup()
      require("Comment").setup()
      require("nvim-autopairs").setup()
      require("oil").setup()

      -- Telescope
      local telescope = require("telescope")
      telescope.setup()
      pcall(telescope.load_extension, "fzf")
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent dir" })

      -- Completion
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })

      -- LSP (Neovim 0.11+ native API). nvim-lspconfig now only ships the server
      -- definitions under lsp/ on the runtimepath; we set shared options for all
      -- servers via the "*" config and enable the ones we want.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.enable({
        "nil_ls", "lua_ls", "pyright", "rust_analyzer", "ts_ls", "gopls", "zls",
        "svelte", "html", "cssls", "jsonls", "eslint",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gr", builtin.lsp_references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    '';
  };
}
