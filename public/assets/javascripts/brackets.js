// Generated by CoffeeScript 1.7.1
(function() {
  var nameTeam, send_put;

  nameTeam = function(target) {
    var t, _i, _len, _ref, _results;
    _ref = $(target);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      t = _ref[_i];
      _results.push(send_put(t));
    }
    return _results;
  };

  send_put = function(target) {
    var newName, node;
    newName = target.value;
    node = $(target).closest('td').data('node');
    return $.ajax({
      type: 'PUT',
      url: $(target).closest('form').attr('action'),
      data: {
        'team[name]': newName,
        'bracket[node]': node
      }
    });
  };

  $(function() {
    return $('input#bracket_teams_attributes_name').on('change', (function(_this) {
      return function(e) {
        return nameTeam(e.target);
      };
    })(this));
  });

}).call(this);
