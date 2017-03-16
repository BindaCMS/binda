export let message = "I'm a message"

export class Name {
	
	constructor( name )
	{
		this.name = name
	}

	sayYourName()
	{
		alert( 'My name is ' + this.name )
	}
}