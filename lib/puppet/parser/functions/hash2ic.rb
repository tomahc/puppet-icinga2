# vim: set ts=2 sw=2 sts=2 et :
#
# hash2ic.rb
#

module Puppet::Parser::Functions
  newfunction(:hash2ic, :type => :rvalue, :doc => <<-EOS
Returns a icinga2 dictionary/hash
*Examples:*

    hash2ic( { 'key' => 'value', 'nested' => { 'key' => 'value' } }, [] )

Would return:

    { "key" = "value", "nested" = { "key" = "value" } }

    ...which is icing2s' dictionary/hash syntax
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hash2ic(): Wrong number of arguments " +
      "given (#{arguments.size}: at least 1)") if arguments.size == 0

    puppethash = arguments[0]
    storage = arguments[1]

    hash2ic = Proc.new do |arg1,arg2|
      is_first = true
      arg2.push '{ '

      arg1.each do |k,v|
        key = "\"#{k}\" ="

        if not is_first
          arg2.push ', '
        end

        arg2.push key
        if v.is_a? Hash
          hash2ic.call(v, arg2)

        elsif v.is_a? Array
          arg2.push v.to_s

        else
          val = "\"#{v}\""
          arg2.push val
        end

        is_first = false
      end

      arg2.push '} '
    end

    return hash2ic.call(puppethash,storage)
  end
end
