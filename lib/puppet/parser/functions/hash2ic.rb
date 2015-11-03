# vim: set ts=2 sw=2 sts=2 et :
#
# hash2ic.rb
#

module Puppet::Parser::Functions
  newfunction(:hash2ic, :type => :rvalue, :doc => <<-EOS
Returns a icinga2 hash
*Examples:*

    makedirs('/tmp/somedir','a/deeper/dir')

Would return:

    ['/tmp/somedir','/tmp/somedir/a', '/tmp/somedir/a/deeper', ... aso.. ]
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hash2ic(): Wrong number of arguments " +
      "given (#{arguments.size}: at least 1)") if arguments.size == 0

    puppethash = arguments[0]
    storage = arguments[1]

    puppethash.each do |k,v|
        key = "\"#{k}\" ="
        if storage.empty?
            storage.push '{ '
        end

        storage.push key

        if v.is_a? Hash
            storage.push '{ '
            hash2ic v, storage

        elsif v.is_a? Array
            val = v.to_s + ' }' + ' ,'
        else
            val = "\"#{v}\"" + ' }' + ' ,'
        end
        storage.push val
    end
    return storage + ['}']
  end
end
