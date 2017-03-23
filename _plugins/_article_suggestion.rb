#Copyright (c) Chedy Missaoui All rights reserved.
#Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
module Jekyll
    module GetArticleByIdFilter
        def get_article_by_id(articles, id)
            for article in articles
                if (article.data['article_id'] == id)
                    return article
                end
            end
            return ""
        end
    end
    module GetRandomIfEmpty
        def get_random_if_empty(suggested, allPosts)
            if (suggested.nil? or suggested.empty?)
                article_ids = allPosts.map {|p| p.data["article_id"]}
                result =  [article_ids[rand(0...article_ids.length)], article_ids[rand(0...article_ids.length)]]
                return result
            else
                return suggested
            end
        end
    end
end

Liquid::Template.register_filter(Jekyll::GetArticleByIdFilter)
Liquid::Template.register_filter(Jekyll::GetRandomIfEmpty)
