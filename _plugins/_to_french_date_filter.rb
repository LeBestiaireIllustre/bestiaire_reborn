module Jekyll
    module FrenchDateFilter
        def to_french_date(date)
            months = ['Janvier','Février','Mars','Avril','Mai','Juin',
            'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
            elems = date.split('-')
            month = Integer(elems[1])
            elems[1] = months[month-1]
            return elems.join('&nbsp;')
        end
    end
end
Liquid::Template.register_filter(Jekyll::FrenchDateFilter)
