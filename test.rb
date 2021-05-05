require 'metainspector'

page = MetaInspector.new('https://www.bellesdemeures.com/annonces/vente/tt-2-tb-2-pl-42709/156789567/?m=homepage-dernieres_annonces_vues-annonces')
p page.title               # title of the page from the head section, as string
p page.best_title          # best title of the page, from a selection of candidates
# p Review.new(content: page.description, score: 0, room_id: id, user_id: current_user.id)          # returns the meta description
p page.best_description    # returns the first non-empty description between the following candidates: standard meta description, og:description, twitter:description, the first long paragraph
p page.images.best