local overlayLayerRule = hl.layer_rule({
    name  = "no-anim-overlay",
    match = { namespace = "^my-overlay$" },
    no_anim = true,
})
    overlayLayerRule:set_enabled(false)