module Jekyll
    module ColumnListFilter
        def column_list(flatList, columnsCount)
            columnsCount = Integer(columnsCount)
            result = []
            for i in (0...columnsCount)
                result.push([])
            end

            for i in (0...flatList.length).step(columnsCount)
                for j in (0...columnsCount)
                    unless (flatList[i+j].nil?)
                        result[j].push(flatList[i+j])
                    end
                end
            end
            return result
        end
    end
end

Liquid::Template.register_filter(Jekyll::ColumnListFilter)
