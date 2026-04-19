;extends

; --- 1-char header: |, >
((block_scalar) @injection.content
  (#match? @injection.content "^[|>]\s*\n")
  (#offset! @injection.content 0 1 0 0)
  (#match? @injection.content "#!(.*bash|/bin/sh)")
  (#set! injection.language "bash"))

((block_scalar) @injection.content
  (#match? @injection.content "^[|>]\s*\n")
  (#offset! @injection.content 0 1 0 0)
  (#match? @injection.content "#!.*fish")
  (#set! injection.language "fish"))

; --- 2-char header: |-, |+, >-, >+
((block_scalar) @injection.content
  (#match? @injection.content "^[|>][+-]\s*\n")
  (#offset! @injection.content 0 2 0 0)
  (#match? @injection.content "#!(.*bash|/bin/sh)")
  (#set! injection.language "bash"))

((block_scalar) @injection.content
  (#match? @injection.content "^[|>][+-]\s*\n")
  (#offset! @injection.content 0 2 0 0)
  (#match? @injection.content "#!.*fish")
  (#set! injection.language "fish"))
