//jquery-like dom manipulation functions

//http://stackoverflow.com/questions/22100853/dom-pure-javascript-solution-to-jquery-closest-implementation
export function closest(el, fn) {
    return el && (
        fn(el) ? el : closest(el.parentNode, fn)
    );
}