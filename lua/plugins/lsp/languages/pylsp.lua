return {
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
                pyflakes = {
                    enabled = false,
                },
                rope_completion = {
                    enabled = false,
                },
                autopep8 = {
                    enabled = false,
                },
                yapf = {
                    enabled = true,
                },
                flake8 = {
                    enabled = true,
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
            }
        }
    }
}
