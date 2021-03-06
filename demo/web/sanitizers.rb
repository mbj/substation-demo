class Demo
  module Web

    module Sanitizers

      ID_TRAP = Ducktrap.build do
        custom do
          forward { |input| input.merge(:id => nil) }
          inverse { |input| input = input.dup; input.delete(:id); input }
        end
      end

      NEW_PERSON = Ducktrap.build do
        primitive(Hash)
        hash_transform do
          fetch_key('name') do
            primitive(String)
            dump_key(:name)
          end
        end
        add(ID_TRAP)
        anima_load(Models::Person)
      end

      LOAD_PERSON = Ducktrap.build do
        primitive(Hash)
        hash_transform do
          fetch_key('id') do
            primitive(String)
            dump_key(:id)
          end
        end
        custom do
          forward { |input| input[:id].to_i }
          inverse { |input| { :id => input.to_s } }
        end
      end
    end
  end
end
