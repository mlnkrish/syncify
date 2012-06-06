require "set"

module Syncify

  class Synchronizer
    def initialize source,dest
      @source = source
      @dest = dest
    end

    def synchronize
      source_contents = @source.all_md5
      dest_contents = @dest.cached_md5
      if dest_contents.nil?
        actions = {:add => source_contents.keys.to_set, :mod => Set.new, :del => Set.new}
        dest_contents = {}
      else
        actions = find_actions source_contents,dest_contents
      end

      actions[:add].each do |to_add|
        begin
          puts "adding #{to_add}"
          @dest.add to_add,@source.get_path(to_add)
          dest_contents[to_add] = source_contents[to_add]
        rescue Exception => e
          puts "unable to add ."
        end
      end

      actions[:del].each do |to_del|
        begin
          puts "deleting #{to_del}"
          @dest.delete to_del  
          dest_contents.delete to_del
        rescue Exception => e
          puts "unable to del ."
        end
        
      end

      actions[:mod].each do |to_mod|
        begin
          puts "modifiying #{to_mod}"
          @dest.modify to_mod,@source.get_path(to_mod)
          dest_contents[to_add] = source_contents[:to_add]
        rescue Exception => e
          puts "unable to mod ."
        end
      end
      @dest.write_cache dest_contents
    end

    def find_actions source_contents,dest_contents
      actions = {:add => Set.new,:del => Set.new,:mod => Set.new}
      source_keys = source_contents.keys.to_set
      dest_keys = dest_contents.keys.to_set
      actions[:add] = (source_keys - dest_keys)
      actions[:del] = (dest_keys - source_keys)

      source_contents.each do |sk,sv|
        if dest_contents.has_key?(sk) && sv != dest_contents[sk]
          actions[:mod].add sk
        end
      end
      actions
    end
  end
end