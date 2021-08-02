import { PureComponent } from 'react'

import './stylesheets/index.scss'

import Table from './Table'

class App extends PureComponent {

  state = {
    feedbackText: ""
  }

  updateFeedback = (text: string) => {
    this.setState({feedbackText: text})
  }

  render = () =>
    <div className="app">
      <Table  updateText = {this.updateFeedback}/>
      <h4>{this.state.feedbackText}</h4>
    </div>
}

export default App
