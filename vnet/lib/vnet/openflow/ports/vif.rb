# -*- coding: utf-8 -*-

module Vnet::Openflow::Ports

  module Vif
    include Vnet::Openflow::FlowHelpers

    attr_accessor :interface_id

    def port_type
      :vif
    end

    def cookie(tag = nil)
      value = self.port_number | COOKIE_TYPE_PORT
      tag.nil? ? value : (value | (tag << COOKIE_TAG_SHIFT))
    end

    def install
      flows = []
      flows << flow_create(:classifier,
                           priority: 2,
                           match: {
                             :in_port => self.port_number,
                           },
                           write_metadata: {
                             :interface => @interface_id,
                             :local => nil,
                           },
                           goto_table: TABLE_INTERFACE_CLASSIFIER)
      flows << flow_create(:default,
                           table: TABLE_INTERFACE_VIF,
                           priority: 30,
                           match_metadata: {
                             :interface => @interface_id
                           },
                           actions: {
                             :output => self.port_number
                           })

      @dp_info.add_flows(flows)
    end

  end

end
