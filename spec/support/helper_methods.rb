##
# Donate Your Account (donateyouraccount.com)
# Copyright (C) 2014  Kyle Shank (kyle.shank@gmail.com)
# http://www.gnu.org/licenses/agpl.html
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

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