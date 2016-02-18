Rails.application.config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do

  # Pages from old site that have an equivalent on the new site: r301 '/old', '/new'
  # r301 '/menu',               '/#menu'
  r301 %r{^/menu(?:.*?)(\?.*)?}, '/$1#menu' # /menu and /menu/dish-name, including malformed /menu&2015-07-09 stuff
  r301 '/how-it-works',         '/#how-din-works'
  r301 '/onboarding/signup',    '/signup'
  r301 '/company/about',        '/about'
  r301 '/legal/privacy',        '/privacy'
  r301 '/company/contact',      '/help'
  r301 '/thanksgiving',         '/#menu'
  r301 '/legal/tos',            '/terms'
  r301 '/reset',                '/password/recover'
  r301 '/learn-more',           '/#how-din-works'
  r301 '/info',                 '/#how-din-works'
  r301 '/pricing',              '/#how-din-works'

  # Pages from old site that will likely return in a new form but don't yet exist: r302 '/old', '/new'
  r302 %r{/blog.*},     '/'
  r302 '/restaurants',  '/'
  r302 '/company/jobs', '/'
  r302 '/company/team', '/'
end
