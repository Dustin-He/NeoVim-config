return {
    cmd = {
        "/Users/dustin/miniconda3/bin/pylsp"
    },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = false,
                    ignore = { 'E501' },
                    maxLineLength = 250
                },
                mccabe = {
                    enabled = false,
                },
                rope_completion = {
                    enabled = false,
                },
                autopep8 = {
                    enabled = true,
                },
                yapf = {
                    enabled = false,
                },
                pylint = {
                    enabled = true,
                    args = { "--disable=C,W1514,R1732",
                        "--load-plugins=pylint.extensions.check_elif,pylint.extensions.empty_comment,pylint.extensions.redefined_variable_type,pylint.extensions.redefined_loop_name,pylint.extensions.typing,pylint.extensions.mccabe" },
                },
                flake8 = {
                    enabled = false,
                    ignore = {
                        "E501",
                        "F401"
                    },
                    perFileIgnores = {
                        "__init__.py:F403",
                        "__init__.py:F405",
                        "__init__.py:E121",
                        "__init__.py:E126",
                        "__init__.py:E128",
                    }
                },
                pyflakes = {
                    enabled = false,
                },
            },
        }
    }
}
