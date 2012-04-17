class Chef
  module Cloudera
    module RecipeExt
      def find_cloudera_namenode(environment = nil)
        if node.run_list.include?("recipes[cloudera::hadoop_namenode")
          node
        else
          search_string = "recipes:cloudera\:\:hadoop_namenode"
          search_string << " AND chef_environment:#{environment}" if environment
          search(:node, search_string).first
        end
      end
    end
  end
end

Chef::Recipe.send(:include, Chef::Cloudera::RecipeExt)
