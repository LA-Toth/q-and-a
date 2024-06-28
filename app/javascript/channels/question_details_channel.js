import consumer from "channels/consumer"

consumer.subscriptions.create("QuestionDetailsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("connected")

  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('Received', data)
    // Called when there's incoming data on the websocket for this channel
    const dynTopic = document.getElementById("dynTopic")
    const dynQuestion = document.getElementById("dynQuestion")
    dynTopic.textContent = data.topic === data.completed_value ? 'Completed' : data.topic
    dynQuestion.textContent = data.question === data.completed_value ? 'Completed' : data.question
  }
});
