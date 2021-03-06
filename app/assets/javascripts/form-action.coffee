get_hash_for = (object, scopes)->
  if typeof scopes == "string"
    scopes = [scopes]
  if !scopes || !scopes.length
    return object

  res = {}
  for scope in scopes
    for k, v of object
      res["#{scope}[#{k}]"] = v

  res

objectifyForm = (formArray)-> #serialize data function
  returnArray = {};
  for item in formArray
    returnArray[item['name']] = item['value']

  return returnArray;


submit_form = (form, e)->
  if e && e.preventDefault
    e.preventDefault()

  if !$(form).valid()
    return false

  $form = $(form)
  url = $form.attr("action")
  console.log "form action: ", url

  $('button.reserve-btn, button.corner-btn').addClass('success')
  setTimeout(
    ->
      $('button.reserve-btn, button.corner-btn').removeClass('success')
      $("input").add($("textarea"))
      $(form).find('input, textarea').filter(
        ()->
          return true if this.tagName.toLowerCase() == "textarea"
          $input = $(this)
          type = $input.attr("type")
          type != "radio" && type != "checkbox"
      ).val('')
    3000
  )


  data = {}
  data[$form.attr("data-resource-name")] = objectifyForm($form.serializeArray())

  $.ajax({
    url: url
    type: "post"
    data: data
  })

  false

$document.ready ->

  rules = {
    name:
      required: true,
      minlength: 3
    phone:
      required: true,
  }

  $("form.call-me-form, form.reservation-form").each(->

    $(this).validate({
      rules: rules
      submitHandler: submit_form
    })
  )




$document.on "submit", "form.reservation-form", (e)->
  submit_form($(this), e)
