
def fixture(file, context = nil)
  strip = context.try(:delete, :strip)
  file += '.erb' if context && !file.ends_with?('.erb')

  fixture = File.read(File.expand_path("../fixtures/#{file}", File.dirname(__FILE__)))
  fixture = ErbOpenStruct.new(context).render(fixture) if context
  fixture = fixture.gsub(/^\s*/, "").gsub(/\n{2,}/, "\n") if strip
  fixture
end

def xml_fixture(file, context = nil)
  file += '.xml' unless file.include?('.xml')
  Wbxml.xml_to_wbxml(fixture(file, context))
end

def json_fixture(file, context = nil)
  file += '.json' unless file.include?('.json')
  fixture(file, context)
end

def txt_fixture(file, context = nil)
  file += '.txt' unless file.include?('.txt')
  fixture(file, context)
end

class ErbOpenStruct < OpenStruct
  def render(template)
    ERB.new(template).result(binding)
  end
end