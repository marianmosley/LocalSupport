class LogInForm extends React.Component {
  constructor (props) {
    super(props);
    this.handleOpenFormClick = this.handleOpenFormClick.bind(this);
    this.handleSignUpToggle = this.handleSignUpToggle.bind(this);
    this.handleSignUpSubmit = this.handleSignUpSubmit.bind(this);
    this.handleRememberableCheck = this.handleRememberableCheck.bind(this);
    this.render = this.render.bind(this);
    this.state = {
      isShowingForm: false,
      isShowingLogInForm: true,
      isRememberable: props.isRememberable
    };
  }

  handleOpenFormClick() {
    this.setState({
      isShowingForm: !this.state.isShowingForm
    });
  }

  handleSignUpToggle() {
    this.setState({
      isShowingLogInForm: !this.state.isShowingLogInForm
    });
  }

  handleSignUpSubmit(e) {
    e.preventDefault();
    console.log('submitting signup');
    $.ajax({
      url: this.props.signUpURL,
      dataType: 'json',
      method: 'POST',
      data: {
        user: {
          email: this.refs.signUpEmail.value,
          password: this.refs.signUpPassword.value,
          password_confirmation: this.refs.signUpPasswordConfirmation.value
        }
      }
    }).then( response => {
      console.log("Good job submitting Sign Up form", response);
      this.setState({
        isShowingForm: false
      });
    }).fail( response => {
      this.setState({
        errors: JSON.parse(response.responseText).errors
      });
      console.log("Error submitting Sign Up form", response);
    });
  }

  handleRememberableCheck() {
    this.setState({
      isRememberable: !this.state.isRememberable
    });
  }

  renderLogInForm() {
    return (
      <form>
        <label>Email Address</label>
        <input type='text' className='block col-12 mb1 field' />
        <label>Password</label>
        <input type='password' className='block col-12 mb1 field' />
        <label className='block col-12 mb2'>
          <input type='checkbox' onChange={this.handleRememberableCheck} checked={this.state.isRememberable} />
          Remember Me
        </label>
        <button type='submit' className='btn btn-primary'>Sign In</button>
        <a className='px1'>Forgot password?</a>
        <a onClick={this.handleSignUpToggle} className='block py2'>New organisation? Sign up</a>
      </form>
    );
  }

  renderSignUpForm() {
    return (
      <form>
        <label>Email Address</label>
        <input ref='signUpEmail' type='text' className='block col-12 mb1 field' />
        <label>Password</label>
        <input ref='signUpPassword' type='password' className='block col-12 mb1 field' />
        <label>Confirm Password</label>
        <input ref='signUpPasswordConfirmation' type='password' className='block col-12 mb1 field' />
        <button onClick={this.handleSignUpSubmit} type='submit' className='btn btn-primary'>Sign Up</button>
        {this.renderErrors()}
        <a onClick={this.handleSignUpToggle} className='block py2'>Already a member? Log in</a>
      </form>
    );
  }

  renderErrors() {
    if (this.state.errors) {
      return (
        <ul>
          {_.map(this.state.errors, (values, key) => _.map(values, (val) => <li>{key}: {val}</li>))}
        </ul>
      );
    }
    // "{"errors":{"email":["is invalid"],"password_confirmation":["doesn't match Password"],"password":["is too short (minimum is 8 characters)"]}}"
  }

  renderForm() {
    if (this.state.isShowingForm) {
      return (
        <div className='absolute bg-white border rounded py2 px2'>
          {this.state.isShowingLogInForm ? this.renderLogInForm() : this.renderSignUpForm()}
        </div>
      );
    }
  }

  render() {
    return (
      <div className='relative'>
        <a onClick={this.handleOpenFormClick} className='btn py2 black muted'>Login</a>
        {this.renderForm()}
      </div>
    );
  }
}

LogInForm.propTypes = {
  signInURL: React.PropTypes.string.isRequired,
  signUpURL: React.PropTypes.string.isRequired,
  isRememberable: React.PropTypes.bool.isRequired
};
