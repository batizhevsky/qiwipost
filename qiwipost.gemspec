Gem::Specification.new do |s|
  s.name        = 'qiwipost'
  s.version     = "0.0.#{Date.today.to_s.gsub!('-','')}"
  s.date        =  Date.today.to_s
  s.summary     = "QiwiPost"
  s.description = "qiwipost.ru api gem"
  s.authors     = ["Leonid Batizhevsky"]
  s.email       = 'leonid.batizhevsky@yandex.ru'
  s.files       = ["lib/qiwipost.rb"]
  s.homepage    =
    'http://github.com/leonko/qiwipost'
end