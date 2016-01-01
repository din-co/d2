$ ->
  ($ '#country_based').click ->
    show_country()

  ($ '#state_based').click ->
    show_state()

  ($ '#postal_code_based').click ->
    show_postal_code()

  # Can't figure out how to fully override this file
  # so just always default to postal code for now

  ($ '#postal_code_based').click()

  # if ($ '#country_based').is(':checked')
  #   show_country()
  # else if ($ '#state_based').is(':checked')
  #   show_state()
  # else if ($ '#postal_code_based').is(':checked')
  #   show_postal_code()
  # else
  #   show_state()
  #   ($ '#state_based').click()

toggle_zone_type = (type, visible) ->
  ($ "##{type}_members :input").each ->
    ($ this).prop 'disabled', !visible

  ($ "##{type}_members").toggle(visible)

hide_zone_type = (type) ->
  toggle_zone_type(type, false)

show_zone_type = (type) ->
  toggle_zone_type(type, true)

show_country = ->
  hide_zone_type('state')
  hide_zone_type('postal_code')
  hide_zone_type('zone')

  show_zone_type('country')

show_state = ->
  hide_zone_type('country')
  hide_zone_type('postal_code')
  hide_zone_type('zone')

  show_zone_type('state')

show_postal_code = ->
  hide_zone_type('state')
  hide_zone_type('country')
  hide_zone_type('zone')

  show_zone_type('postal_code')
