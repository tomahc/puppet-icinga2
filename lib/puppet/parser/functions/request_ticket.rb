# vim: set ts=2 sw=2 sts=2 et :
#
# request_ticket.rb
#

module Puppet::Parser::Functions
  newfunction(:request_ticket, :type => :rvalue, :doc => <<-EOS
Returns a icinga2 dictionary/hash
*Examples:*

    request_ticket( { 'key' => 'value', 'nested' => { 'key' => 'value' } }, [] )

Would return:

    { "key" = "value", "nested" = { "key" = "value" } }

    ...which is icing2s' dictionary/hash syntax
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "request_ticket(): Wrong number of arguments " +
      "given (#{arguments.size}: at least 1)") if arguments.size == 0

    cn = arguments[0]

    stdin, stdout, stderr = Open3.popen3("sudo -H -u nagios icinga2 pki ticket --cn \'#{cn}\' 2>&1")
    return stdout.readlines.join(' ').gsub("\n", '')
  end
end
