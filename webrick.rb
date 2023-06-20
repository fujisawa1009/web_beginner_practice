# webrick.rb
require 'webrick'
require "erb"

server = WEBrick::HTTPServer.new({
                                   :DocumentRoot => './',
                                   :BindAddress => '127.0.0.1',
                                   :Port => 8000
                                 })

trap(:INT){
    server.shutdown
}

WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server.config[:MimeTypes]["erb"] = "text/html"

foods = [
  { id: 1, name: "りんご", category: "fruits" },
  { id: 2, name: "バナナ", category: "fruits" },
  { id: 3, name: "いちご", category: "fruits" },
  { id: 4, name: "トマト", category: "vegetables" },
  { id: 5, name: "キャベツ", category: "vegetables" },
  { id: 6, name: "レタス", category: "vegetables" },
]
server.mount_proc("/foods") do |req, res|
    template = ERB.new( File.read('./foods/index.erb') )
    # ここにロジックを書く
    @slect_params = req.query['category']
    if @slect_params.nil?
      @foods = foods
    elsif @slect_params == "all"
      @foods = foods
    else
        @foods.select{|f| f[:category] == @slect_params}
    end
    res.body << template.result( binding )
end
server.start
