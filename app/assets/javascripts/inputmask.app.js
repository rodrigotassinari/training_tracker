Inputmask.extendAliases({'pt_date': {
  alias: 'dd/mm/yyyy',
  yearrange: { minyear: 2000, maxyear: 2099 }
}});
Inputmask.extendAliases({'en_date': {
  alias: 'mm/dd/yyyy',
  yearrange: { minyear: 2000, maxyear: 2099 }
}});

Inputmask.extendAliases({'pt_integer': {
  alias: 'integer',
  rightAlign: false,
  autoGroup: true
}});
Inputmask.extendAliases({'en_integer': {
  alias: 'integer',
  rightAlign: false,
  autoGroup: true
}});

Inputmask.extendAliases({'pt_decimal': {
  alias: 'decimal',
  radixPoint: ',',
  groupSeparator: '.',
  digits: 1,
  digitsOptional: false,
  integerOptional: false,
  rightAlign: false,
  autoGroup: true,
  decimalProtect: false
}});
Inputmask.extendAliases({'en_decimal': {
  alias: 'decimal',
  radixPoint: '.',
  groupSeparator: ',',
  digits: 1,
  digitsOptional: false,
  integerOptional: false,
  rightAlign: false,
  autoGroup: true,
  decimalProtect: false
}});

Inputmask.extendAliases({'pt_decimal2': {
  alias: 'pt_decimal',
  digits: 2
}});
Inputmask.extendAliases({'en_decimal2': {
  alias: 'en_decimal',
  digits: 2
}});

Inputmask.extendAliases({'pt_duration': {
  alias: 'hh:mm:ss'
}});
Inputmask.extendAliases({'en_duration': {
  alias: 'hh:mm:ss'
}});

$(document).on('ready page:load', function(event) {
  // apply non-idempotent transformations to the body

  $('input[data-mask]').each( function() {
    $(this).inputmask( $(this).data('mask') );
  });

});
