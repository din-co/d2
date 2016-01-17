didScroll = undefined
lastScrollTop = 0
delta = 5
navbarHeight = $('.main-nav').outerHeight()

hasScrolled = ->
  st = $(this).scrollTop()
  # Make sure they scroll more than delta
  if Math.abs(lastScrollTop - st) <= delta
    return
  # If they scrolled down and are past the navbar, add class .nav-up.
  # This is necessary so you never see what is "behind" the navbar.
  if st > lastScrollTop and st > navbarHeight
    # Scroll Down
    $('.main-nav').addClass 'main-nav--hidden'
  else
    # Scroll Up
    if st + $(window).height() < $(document).height()
      $('.main-nav').removeClass 'main-nav--hidden'
  lastScrollTop = st
  return

$(window).scroll (event) ->
  didScroll = true
  return

setInterval (->
  if didScroll
    hasScrolled()
    didScroll = false
  return
), 250
