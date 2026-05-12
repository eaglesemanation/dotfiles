;extends

((block_scalar) @injection.content
  (#offset! @injection.content 0 1 0 0)
  (#set-lang-from-match! @injection.content "#![%a%d%p]*[ /](%a*)")
  (#not-has-ancestor? @injection.content block_scalar))

((block_scalar) @injection.content
  (#offset! @injection.content 0 1 0 0)
  (#set-lang-from-match! @injection.content "#%s*vim:[%a%d%p]*ft=(%a+):?")
  (#not-has-ancestor? @injection.content block_scalar))
