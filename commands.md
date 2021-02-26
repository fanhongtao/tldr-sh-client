`find {{root_path}} -name '{{*.ext}}' -exec {{wc -l {} }}\;`
`find {{root_path}} -name '{{*.ext}}'`
`wget --limit-rate={{300k}} --tries={{100}} {{https://example.com/somepath/}}\`

`{{arguments_source}} | xargs sh -c "{{command1}} && {{command2}} | {{command3}}"`
`find . -name {{'*.backup'}} -print0 | xargs -0 rm -v`

