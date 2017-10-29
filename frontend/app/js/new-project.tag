<new-project>
  <h1>{opts.title}</h1>
  <hr/>

  <form onsubmit={create} class="form-inline pull-right">
    <div class="form-group">
      <input name="title" type="text" class="form-control" placeholder="Project Name">
      <input name="team" type="text" class="form-control" placeholder="Project Team">
    </div>

    <button class="btn btn-success">Save</button>
  </form>

  <script>
    var self = this

    create(e) {
      e.preventDefault();

      var url = opts.url + "/projects";

      var xmlhttp = new XMLHttpRequest()
      xmlhttp.open("POST", url, true)

      xmlhttp.onload = function() {
        if (xmlhttp.status >= 200 && xmlhttp.status < 400) {
          window.location.pathname = '/';
        }
      }

      xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xmlhttp.send(JSON.stringify({title: e.target.title.value, team: e.target.team.value}))
    }

  </script>
</new-project>
