var host = /http[s]*:\/\/([^\/^:]+)/.exec(location.href)[1]
var flashvars = { 
  rtmp_url: ('rtmp://' + host)
}

var current_uuid
var state = 'disconnected'

// RTMP events
function onCallState(uuid, state) {
  current_uuid = uuid
  if(state == 'RINGING')
    ringing()
  else if(state == 'ACTIVE')
    talking()
  else if(state == 'HANGUP')
    hangedup()
}

function onDisconnected() {
  disconnected()

  // Reconnect
  setTimeout(function() {
    $("#flash")[0].connect()
  }, 3000)
}

function onDebug(message) {
}

function checkMic() {
  try {
    return !$("#flash")[0].isMuted()
  } catch(err) {
    return false
  }
}

function onConnected(sessionid) {
  if (!checkMic())
    $('#flash')[0].showPrivacy()
  else {
    if (swfobject.ua.ie) {
      $("#flash").css("top", "-500px")
      $("#flash").css("left", "-500px")
    } else {
      $("#flash").css("visibility", "hidden")
    }

    connected()
  }
}

// Init
$(document).ready(function() {
  swfobject.embedSWF("/freeswitch.swf", "flash", "250", "150", "9.0.0", "/expressInstall.swf", flashvars, {allowScriptAccess: 'always'}, [])
    $('#call').live('click', call_number)
    $('#hangup').live('click', hangup)
})

// Actions
function call_number() {
  if(state == 'connected')
    $("#flash")[0].makeCall("blah-"+$('#call_to').val(), null, [])
}

function hangup() {
  if(state == 'ringing' || state == 'talking') {
    $("#flash")[0].hangup(current_uuid)
    hangedup()    
  }
}

function flash_settings() {
  if (swfobject.ua.ie) {
    $("#flash").css("top", "auto")
    $("#flash").css("left", "auto")
  } else {
    $("#flash").css("visibility", "visible")
  }
  $('#flash')[0].showPrivacy()
}

// States
function disconnected() {
  state = 'disconnected'
  $('#state').text('Инициализация').addClass('active')
}

function connected() {
  state = 'connected'
  $('#state').text('Готово к вызовам').removeClass('active')
}

function ringing() {
  state = 'ringing'
  $('#state').text('Идёт вызов').addClass('active')
}

function talking() {
  state = 'talking'
}

function hangedup() {
  connected()
}
