`find {{root_path}} -name '{{*.ext}}' -exec {{wc -l {} }}\;`
`find {{root_path}} -name '{{*.ext}}'`
`wget --limit-rate={{300k}} --tries={{100}} {{https://example.com/somepath/}}\`

`{{arguments_source}} | xargs sh -c "{{command1}} && {{command2}} | {{command3}}"`
`find . -name {{'*.backup'}} -print0 | xargs -0 rm -v`

`7z a {{encrypted.7z}} -p{{password}} -mhe=on {{archived.7z}}`
`zip -r -{{9}} {{compressed.zip}} {{path/to/directory}}`
`ab -n {{100}} {{url}}`
`ack bar "{{[bB]ar \d+}}" {{path/to/file}}`
`echo '{{3}}' | ajson '{{2 * pi * $}}'`

`adb reverse tcp:{{remote_port}} tcp:{{local_port}}`
`alias {{word}}="{{command}}"`
`alias {{la}}="{{ls -a}}"`
`alex *.md !{{example.md}}`
`ansible-doc --type {{plugin_type}} --list`
