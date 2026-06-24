-- ── Tsumiki layer rules (blur + compositor hints) ─────────────────────
-- These are required by Tsumiki for blur and animations to work correctly.

hl.layer_rule({ name = "tsumiki-blur",              match = { namespace = "^tsumiki$" },              blur = true,  xray = false, blurpopups = true,  ignorezero = true })
hl.layer_rule({ name = "tsumiki-fabric-blur",       match = { namespace = "^fabric$" },               blur = true,  xray = false, blurpopups = true,  ignorezero = true })
hl.layer_rule({ name = "tsumiki-launcher-blur",     match = { namespace = "^launcher$" },             blur = true,  xray = false, blurpopups = true,  ignorezero = true, noanim = false })
hl.layer_rule({ name = "tsumiki-notifications-blur",match = { namespace = "^tsumiki-notifications$" },blur = true,  xray = false, blurpopups = true,  ignorezero = true, noanim = true })
hl.layer_rule({ name = "tsumiki-gtk-blur",          match = { namespace = "gtk-layer-shell" },        blur = true,  ignorezero = true })
hl.layer_rule({ name = "tsumiki-launcher-anim",     match = { namespace = "^launcher$" },             animation = "popin" })
