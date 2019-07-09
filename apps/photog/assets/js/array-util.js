//makes shallow copy of array, removes item at index, and returns new array
export function arrayRemove(array, index){
    const newArray = array.slice();
    newArray.splice(index, 1);
    return newArray;
}