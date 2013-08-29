# -*- coding: utf-8 -*-

module Vnctl::Cli
  class Datapath < Base
    namespace :datapath
    api_suffix "/api/datapaths"
    register(C::Datapath::Network, "networks", "networks OPTION",
      "subcommand to manage networks in this datapath.")

    no_tasks {
      def self.add_modify_shared_options
        option_display_name
        option :is_connected, :type => :boolean, :desc => "Flag that detemines if the datapath is connected or not."
        option :dc_segment_id, :type => :string, :desc => "The datapath's dc segment id."
        option :node_id, :type => :string, :desc => "The node id for the datapath."
        option :ipv4_address, :type => :string, :desc => "Ipv4 address for the datapath."
        option :dpid, :type => :string, :desc => "Hexadecimal id for the datapath."
      end
    }

    option_uuid
    add_modify_shared_options
    define_add

    add_modify_shared_options
    define_modify

    define_show
    define_del

    class Network < Base
      namespace :networks
      api_suffix "/api/datapaths"

      desc "add DATAPATH_UUID NETWORK_UUID OPTIONS", "Adds a network to a datapath."
      option :broadcast_mac_addr, :type => :string, :required => true,
        :desc => "The broadcast mac address for mac2mac to use in this network."
      def add(datapath_uuid, network_uuid)
        puts post("#{suffix}/#{datapath_uuid}/networks/#{network_uuid}", :query => options)
      end

      desc "show DATAPATH_UUID", "Shows all networks in this datapath."
      def show(datapath_uuid)
        puts get("#{suffix}/#{datapath_uuid}/networks")
      end

      desc "show DATAPATH_UUID NETWORK_UUID", "Shows a specific network in this datapath."
      def show(datapath_uuid, network_uuid)
        puts get("#{suffix}/#{datapath_uuid}/networks/#{network_uuid}")
      end

      desc "del DATAPATH_UUID", "Removes a network from a datapath."
      def del(datapath_uuid, network_uuid)
        puts post("#{suffix}/#{uuid}/networks/#{network_uuid}")
      end
    end
  end
end
