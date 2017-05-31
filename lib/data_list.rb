module DataList

  mattr_accessor :wrapper_tag
  @@wrapper_tag = :div

  mattr_accessor :heading_tag
  @@heading_tag = :h3

  mattr_accessor :subheading_tag
  @@subheading_tag = :p

  mattr_accessor :text_tag
  @@text_tag = :span
end

include DataList
include DataList::DataListHelper

#require 'data_list/data_list_builder'
#require 'data_list/data_list_helper'

ActiveSupport.on_load(:action_view) do
  include DataList::DataListHelper
end