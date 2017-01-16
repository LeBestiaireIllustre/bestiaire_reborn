module Jekyll
    module ColumnListFilter
        
        class Column
            attr_reader :images, :positioning
            def initialize(images, positioning)
                @images = images
                @positioning = positioning
            end

            def to_liquid(*args) 
                {
                    'images' => @images,
                    'positioning' => @positioning
                }
            end
        end
        
        def column_list(flatList, columnsCount)
            columnsCount = Integer(columnsCount)
            result = []
            for i in (0...columnsCount)
                if (i < (columnsCount / 2))
                    result.push(Column.new([], 'left'))
                else 
                    result.push(Column.new([], 'right'))
                end
            end

            for i in (0...flatList.length).step(columnsCount)
                for j in (0...columnsCount)
                    unless (flatList[i+j].nil?)
                        result[j].images.push(flatList[i+j])
                    end
                end
            end
            return result
        end
    end
end

Liquid::Template.register_filter(Jekyll::ColumnListFilter)
