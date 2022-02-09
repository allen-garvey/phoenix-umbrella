//makes shallow copy of array, removes item at index, and returns new array
export function arrayRemove(array, index){
    const newArray = array.slice();
    newArray.splice(index, 1);
    return newArray;
}

// mutates array so item at source index is moved to destIndex
//https://stackoverflow.com/questions/5306680/move-an-array-element-from-one-array-position-to-another/6470794
export function arrayMove(array, sourceIndex, destIndex){
    array.splice(destIndex, 0, array.splice(sourceIndex, 1)[0]);
}

// returns a new copy of the array.
// places the items at index keys after the index
export function batchReorderArray(array, indexKeys, index){
    const indexes = Object.keys(indexKeys)
        .filter(key => indexKeys[key])
        .map(key => parseInt(key))
        .sort()
        .reverse();

    const copy = array.filter((item, i) => !(i in indexKeys));
    const batchedItems = indexes.map(index => array[index]);

    copy.splice(index, 0, ...batchedItems);
    return copy;
}
