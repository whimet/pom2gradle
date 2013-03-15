require 'xmlsimple'
file = (ARGV.length > 0 ? ARGV[0] : nil) || 'test.xml'
project = XmlSimple.xml_in(file, { 'ForceArray' => false })

puts "apply plugin: 'java'"
puts "apply plugin: 'war'"
puts ''
puts 'repositories {'
puts '  mavenCentral()'
puts '}'
puts ''

puts 'ext {'
project['properties'].each { |k, v|
  puts "  #{k.gsub(/[.-]/, '_')} = '#{v}'"
}
puts '}'

puts ''
puts 'dependencies {'

for d in project['dependencies']['dependency']
  scope = d['scope'] || 'compile'
  scope = 'providedCompile' if scope == 'provided'
  scope = 'testCompile' if scope == 'test'

  print "  #{scope}(\"#{d['groupId']}:#{d['artifactId']}:#{d['version'].gsub(/[.-]/, '_')}\")"
  if d['exclusions']
    e = d['exclusions']['exclusion']
    puts " {\n    exclude group: '#{e['groupId']}', module: '#{e['artifactId']}' \n  }"
  else
    puts ''
  end
end

puts '}'