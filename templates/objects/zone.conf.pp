/* managed by puppet */

<%= @is_template ? "template" : "object" %> Zone "<%= @name %>" {

  <%= @check_command ? "check_command = \"#{check_command}\"" : '' -%>

  <%= @max_check_attempts ? "max_check_attempts = #{max_check_attempts}" : '' -%>

  <%= @check_interval ? "check_interval = #{check_interval}" : '' -%>

  <%= @retry_interval ? "retry_interval = #{retry_interval}" : '' -%>

  <%= @check_command ? "check_command = \"#{check_command}\"" : '' -%>

}


/* vim: set ts=2 sts=2 sw=2 et : */
