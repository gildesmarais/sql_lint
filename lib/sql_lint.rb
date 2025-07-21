# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect('postgresql' => 'PostgreSQL')
loader.setup

# Top-level namespace for the SqlLint gem.
#
# This module serves as the root namespace and sets up autoloading for
# the gem's components using Zeitwerk.
module SqlLint
end
