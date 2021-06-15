class UniversalScrapService
    def initialize(url)
        @url = url
    end 

    def call
        page = MetaInspector.new(@url)

        {
            name: page.best_title,
            photo: page.images.best
        }
    end
end 