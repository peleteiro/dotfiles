# Editor
Pry.editor = 'vi'

# Alias
Pry.commands.alias_command 'q', 'quit' rescue nil
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

# https://github.com/hotchpotch/pry-clipboard
begin
  require 'pry-clipboard'

  # aliases
  Pry.config.commands.alias_command 'ch', 'copy-history'
  Pry.config.commands.alias_command 'cr', 'copy-result'
rescue LoadError => e
  warn "can't load pry-clipboard"
end
