hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = true, workspace = "w[tv1]" },
    border_size = 3,
    rounding    = 0,
})
hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = true , workspace = "f[1]" },
    border_size = 3,
    rounding    = 0,
})
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
hl.window_rule({
   
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})