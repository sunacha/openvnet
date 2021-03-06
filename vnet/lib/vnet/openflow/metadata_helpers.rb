# -*- coding: utf-8 -*-

module Vnet::Openflow

  module MetadataHelpers
    include Vnet::Constants::Openflow

    def md_create(options)
      metadata = 0
      metadata_mask = 0

      options.each { |key,value|
        case key
        when :clear_all
          metadata_mask = 0xffffffffffffffff
        when :collection, :match_collection, :write_collection
          metadata = metadata | value | METADATA_TYPE_COLLECTION
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :datapath, :match_datapath, :write_datapath
          metadata = metadata | value | METADATA_TYPE_DATAPATH
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :interface, :match_interface, :write_interface
          metadata = metadata | value | METADATA_TYPE_INTERFACE
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :local, :match_local, :write_local
          metadata = metadata | METADATA_FLAG_LOCAL
          metadata_mask = metadata_mask | METADATA_FLAG_LOCAL | METADATA_FLAG_REMOTE
        when :mac2mac, :match_mac2mac, :write_mac2mac
          metadata = metadata | METADATA_FLAG_MAC2MAC
          metadata_mask = metadata_mask | METADATA_FLAG_MAC2MAC
        when :network, :match_network, :write_network
          metadata = metadata | value | METADATA_TYPE_NETWORK
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :no_controller, :match_no_controller, :write_no_controller
          metadata = metadata | METADATA_FLAG_NO_CONTROLLER
          metadata_mask = metadata_mask | METADATA_FLAG_NO_CONTROLLER
        when :not_no_controller, :match_not_no_controller, :write_not_no_controller
          metadata = metadata
          metadata_mask = metadata_mask | METADATA_FLAG_NO_CONTROLLER
        when :remote, :match_remote, :write_remote
          metadata = metadata | METADATA_FLAG_REMOTE
          metadata_mask = metadata_mask | METADATA_FLAG_LOCAL | METADATA_FLAG_REMOTE
        when :reflection, :match_reflection, :write_reflection
          metadata = metadata | METADATA_FLAG_REFLECTION
          metadata_mask = metadata_mask | METADATA_FLAG_REFLECTION
        when :route, :match_route, :write_route
          metadata = metadata | value | METADATA_TYPE_ROUTE
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :route_link, :match_route_link, :write_route_link
          metadata = metadata | value | METADATA_TYPE_ROUTE_LINK
          metadata_mask = metadata_mask | METADATA_VALUE_MASK | METADATA_TYPE_MASK
        when :tunnel, :match_tunnel, :write_tunnel
          metadata = metadata | METADATA_FLAG_TUNNEL
          metadata_mask = metadata_mask | METADATA_FLAG_TUNNEL
        when :vif, :match_vif, :write_vif
          # Disable the vif flag until we actually need it.
          # metadata = metadata | METADATA_FLAG_VIF
          # metadata_mask = metadata_mask | METADATA_FLAG_VIF
        else
          raise("Unknown metadata type: #{key.inspect}")
        end
      }

      { :metadata => metadata, :metadata_mask => metadata_mask }
    end

    def md_has_flag(flag, value, mask = nil)
      mask = value if mask.nil?
      (value & (mask & flag)) == flag
    end
    
    def md_to_id(type, metadata)
      type_value = case type
                   when :network then METADATA_TYPE_NETWORK
                   when :interface then METADATA_TYPE_INTERFACE
                   else
                     return nil
                   end
      
      if metadata.nil? || (metadata & METADATA_TYPE_MASK) != type_value
        return nil
      end
      
      metadata & METADATA_VALUE_MASK
    end

  end

end
