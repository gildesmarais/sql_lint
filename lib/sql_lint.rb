# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('postgresql' => 'PostgreSQL')
loader.setup


module SqlLint
end
