/**
 * LOGIN FORM
 * 
 * https://tympanus.net/Development/MinimalForm/
 * https://github.com/codrops/MinimalForm/blob/master/js/stepsForm.js
 */

class LoginForm {

  constructor()
  {
  	this.current = 0
  	this.isFilled = false
  }

  isSet()
  {
    if ( $('.login--form').length > 0 ) { return true }
    else { return false }
  }

  setEvents () 
  {
  	this.$form = $('.login--form')
  	this.$questions = $('ol.login--questions > li')
  	this.questionsCount = this.$questions.length
		this.$nextButton = $('button.login--next')

		// Mark the first question as the current one
  	this.$questions.first().addClass('login--current')
		
		//disable form autocomplete
		this.$form.attr('autocomplete', 'off')

		let self = this
	

		// first input
		let firstInput = this.$questions.get(this.current).querySelector( 'input, textarea, select' )

		// focus
		let onFocusStart = function() 
		{
			firstInput.removeEventListener( 'focus', onFocusStart )
			self.$nextButton.addClass('login--show')
		}
		// show the next question control first time the input gets focused
		firstInput.addEventListener('focus', onFocusStart )

		// show next question
		this.$nextButton.on('click', function( event ) 
		{
			event.preventDefault()
			self._nextQuestion()
		} )

		// pressing enter will jump to next question
		this.$form.on('keydown', function( event ) 
		{
			let keyCode = event.keyCode || event.which
			// enter
			if( keyCode === 13 ) 
			{
				event.preventDefault()
				self._nextQuestion()
			}
		})
  }

  _nextQuestion() 
  {
		// check if form is filled
		if( this.current === this.questionsCount - 1 ) 
		{
			this.isFilled = true
		}

  	// current question
		let currentQuestion = this.$questions.get(this.current)

		// increment current question iterator
		++this.current

		if( !this.isFilled ) 
		{
			// add class "show-next" to form element (start animations)
			this.$form.addClass('login--show-next')

			// remove class "current" from current question and add it to the next one
			// current question
			var nextQuestion = this.$questions.get(this.current)
			$(currentQuestion).removeClass('login--current')
			$(nextQuestion).addClass('login--current')
		}

		// after animation ends, remove class "show-next" from form element and change current question placeholder
		let self = this
		let onEndTransition = function() 
		{
			if( self.isFilled ) 
			{
				self.$form.submit()
			}
			else 
			{
				self.$form.removeClass('login--show-next')
				// force the focus on the next input
				nextQuestion.querySelector( 'input, textarea, select' ).focus()
			}
		}

		setTimeout( onEndTransition, 400 ) // Wait for CSS transition to complete
	}
}

export let _LoginForm = new LoginForm()