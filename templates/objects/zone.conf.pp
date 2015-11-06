/* managed by puppet */

object Zone "<%= @name %>" {

  <%= @endpoints ? "endpoints = \"#{endpoints.to_s}\"" : '' -%>

  <%= @parent ? "parent = \"#{parent}\"" : '' -%>

  <%= @global ? "global = #{global}" : '' -%>
}


/* vim: set ts=2 sts=2 sw=2 et : */
