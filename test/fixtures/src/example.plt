---
message: hello
---
.container
  @background: #eee
  # Hello, world
  p
    .btn
      $click: alert(message) 
      Click me

