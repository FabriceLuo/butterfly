local opts = {
    scope = 'line',
    modes = { 'i', 'ic', 'ix', 'R', 'Rc', 'Rx', 'Rv', 'Rvc', 'Rvx' },
    blending = {
        threshold = 0.75,
        colorcode = '#000000',
        hlgroup = {
            'Normal',
            'background',
        },
    },
    warning = {
        alpha = 0.4,
        offset = 0,
        colorcode = '#FF0000',
        hlgroup = {
            'Error',
            'background',
        },
    },
    extra = {
        follow_tw = nil,
    },
}

require('deadcolumn').setup(opts) -- Call the setup function
