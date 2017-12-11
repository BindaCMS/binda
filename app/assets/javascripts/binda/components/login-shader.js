class Shader {
    constructor(){}

    isSet()
    {
        if ( $('#background-shader').length > 0 ) { return true }
        else { return false }
    }

    // SETUP SHADER
    setup () {

        let Container          = PIXI.Container,
            autoDetectRenderer = PIXI.autoDetectRenderer,
            loader             = PIXI.loader,
            resources          = PIXI.loader.resources,
            Sprite             = PIXI.Sprite

        // Create a container object called the `stage`
        this.stage    = new Container()

        // Create 'renderer'
        this.renderer = PIXI.autoDetectRenderer( window.innerWidth, window.innerHeight )

        // //Add the canvas to the HTML document

        document.getElementById('background-shader').appendChild(this.renderer.view)


        this.renderer.backgroundColor     = 0xFF00FF

        // canvas full window
        this.renderer.view.style.position = "fixed"
        this.renderer.view.style.display  = "block"

        let fragmentShader = document.getElementById("fragmentShader").innerHTML

        let currentTime = Math.sin( Date.now() ) + 0.5

        this.uniforms = {
            uTime        : { type: '1f', value: 0.0 },
            uCurrentTime : { type: '1f', value: currentTime },
            uMouse       : { type: '2f', value: [ window.innerWidth, window.innerHeight ] },
            uWindowSize  : { type: '2f', value: [ window.innerWidth, window.innerHeight ] }
        }

        this.customShader = new PIXI.AbstractFilter(null, fragmentShader, this.uniforms)
        this.drawRectagle()
    }


    // DRAW RECTANGLE
    drawRectagle() {

        this.rectangle = new PIXI.Graphics()

        // Set the default background color wo if browser doesn't support the filter we still see the primary color
        let colorWithHash = '#FF00FF'
        const colorWith0x = '0x' + colorWithHash.slice( 1, 7 )
        this.rectangle.beginFill( colorWith0x )

        // Create the background rectanlge
        this.rectangle.drawRect( 0, 0, window.innerWidth, window.innerHeight )
        this.rectangle.endFill()

        // Setup the filter (shader)
        this.rectangle.filters = [ this.customShader ]

        // Add background to stage
        this.stage.addChild( this.rectangle )
    }


    // START ANIMATION
    start() { animate() }


    // MOUSE UPDATE
    mouseUpdate( event ) {

        // If uniforms haven't been set yet don't do anything and exit
        if ( typeof this.uniforms === 'undefined' ) return

        // udpate mouse coordinates for the shader
        this.customShader.uniforms.uMouse = [ event.pageX, event.pageY ]
    }


    // RESIZE
    resize() {

        // let scale = scaleToWindow( this.renderer.view )
        let prevWidth  = this.renderer.view.style.width
        let prevHeight = this.renderer.view.style.height
        this.renderer.view.style.width    = window.innerWidth + "px"
        this.renderer.view.style.height   = window.innerHeight + "px"
        this.customShader.uniforms.uWindowSize = [ window.innerWidth, window.innerHeight ]

        // Plese check this out ↴↴↴
        // this.rectangle.scale.x = window.innerWidth / prevWidth
        // this.rectangle.scale.y = window.innerHeight / prevHeight
    }
}


export let _Shader = new Shader()


// ANIMATE
// -------
function animate() {

    // start the timer for the next animation loop
    requestAnimationFrame( animate )
    _Shader.customShader.uniforms.uTime += 0.01
    // this is the main render call that makes pixi draw your container and its children.
    _Shader.renderer.render( _Shader.stage )
}

// CONVERT HEX TO RGB COLORS
// -------------------------
function hexToShaderRgb( hex ) {

    // Precision of the float number
    var precision = 100
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b
    })

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    return result ? {
        // Get a number between 0.00 and 1.00
        r: Math.round( parseInt(result[1], 16) * precision / 255 ) / precision,
        g: Math.round( parseInt(result[2], 16) * precision / 255 ) / precision,
        b: Math.round( parseInt(result[3], 16) * precision / 255 ) / precision
    } : null;
}


// REQUEST ANIMATION POLYFILL
// --------------------------
// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
// http://my.opera.com/emoller/blog/2011/12/20/requestanimationframe-for-smart-er-animating
// requestAnimationFrame polyfill by Erik Möller. fixes from Paul Irish and Tino Zijdel
// MIT license
(function() {
    var lastTime = 0;
    var vendors = ['ms', 'moz', 'webkit', 'o'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
                timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };

    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());


// Mozilla MDN optimized resize
// https://developer.mozilla.org/en-US/docs/Web/Events/resize
(function() {
    var throttle = function(type, name, obj) {
        obj = obj || window;
        var running = false;
        var func = function() {
            if (running) { return; }
            running = true;
            requestAnimationFrame(function() {
                obj.dispatchEvent(new CustomEvent(name));
                running = false;
            });
        };
        obj.addEventListener(type, func);
    };

    /* init - you can init any event */
    throttle("resize", "optimizedResize");
})();

