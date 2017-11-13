<projects-list>
  <h1>{opts.title}</h1>
  <hr/>
  

  <errors></errors>

  <messages></messages>

  <div if={ !voted }>

    <form onsubmit={ add } class="form-inline">
      <div class="form-group">
        <input name="name" type="text" class="form-control" placeholder="Email" value={email}>
      </div>

      <button class="btn btn-success">Send</button>

      <button onclick={ resetForm } class="btn btn-danger">Cancel</button>
    </form>

    <div class="clearfix"></div>
    <hr/>

    <div class="list-group">
      <a href="#" class="list-group-item { active: points > 0 }" each={ opts.projects.filter(whatShow) } onclick={ parent.toggle }>
      <span class="badge" if={ points > 0 }>{ points }</span>
        <h4 class="list-group-item-heading">{ title }</h4>
        <p class="list-group-item-text">{ team }</p>
      </a>
    </div>
  </div>

  <div if={ voted }>
    <h3>Thank you for your vote!</h3>
  </div>

  <script>
    var self = this

    this.items = opts.projects

    this.user = this.email = ""

    this.errors = []
    this.messages = []
    this.votes = []

    this.voted = false

    function pointsFor(item, votes) {
      var index = votes.indexOf(item)
      if(index >= 0) {
        return 5 - index * 2
      }
    }

    setEmail(email) {
      self.user = self.email = email
      self.update()
    }

    function send() {
      votesSent = 0
      for(i in self.votes) {
        var item = self.votes[i]

        var xmlhttp = new XMLHttpRequest()
        xmlhttp.open("POST", opts.url, true)

        xmlhttp.onload = function() {
          if (xmlhttp.status >= 200 && xmlhttp.status < 400) {
            votesSent++
            if (votesSent == 1) {
              self.voted = true
              reset()
            }
          }
        }

        xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xmlhttp.send(JSON.stringify({voter: self.user, points: item.points, projectId: item.id}))
      }
    }

    add(e) {
      error = false

      if (self.votes.length < 3) {
        self.errors.push({message: "Select 3 projects first!"})
        error = true
      }

      self.setEmail(e.target.name.value);

      if (!error) {
        var xmlhttp = new XMLHttpRequest();
        var url = opts.url + "/" + self.user + "/allowed";

        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            send()
          }
          if (xmlhttp.readyState == 4 && xmlhttp.status == 405) {
            self.errors.push({message: "You have already voted!"})
            self.update()
          }
        }
        xmlhttp.open("GET", url, true)
        xmlhttp.send()
      }
    }

    whatShow(item) {
      return !item.hidden
    }

    resetForm(e) {
      reset()
    }

    function reset() {
      self.errors = []
      self.votes = []
      self.user = self.email = ""
      for(i in self.items) {
        self.items[i].points = 0
      }
      self.update()
    }

    toggle(e) {
      var item = e.item

      if (this.votes.length < 3 && this.votes.indexOf(item) < 0) {
        this.votes.push(item)
        item.points = pointsFor(item, this.votes)
      }
    }
  </script>
</projects-list>

<errors>
  <div class="alert alert-danger" role="alert" each={ parent.errors }>
    <a href="#" class="close" onclick={close}>&times;</a>
    {message}
  </div>

  <script>
    var self = this

    close(e) {
      var index = self.parent.errors.indexOf(e.item);
      if (index > -1) {
        self.parent.errors.splice(index, 1);
      }
    }
  </script>
</errors>

<messages>
  <div class="alert alert-danger" role="alert" each={ parent.messages }>
    <a href="#" class="close" onclick={close}>&times;</a>
    {message}
  </div>

  <script>
    var self = this

    close(e) {
      var index = self.parent.messages.indexOf(e.item);
      if (index > -1) {
        self.parent.messages.splice(index, 1);
      }
    }
  </script>
</messages>
