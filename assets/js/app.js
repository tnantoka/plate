var app = new Vue({
  el: '#app',
  data: data,

  ready: function() {
    prettyPrint();
  },

  methods: {
    alert: function(message) {
      alert(message);
    },
  },
});

