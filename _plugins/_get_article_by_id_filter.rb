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
end

Liquid::Template.register_filter(Jekyll::GetArticleByIdFilter)
