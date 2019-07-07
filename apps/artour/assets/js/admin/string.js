function smartCapitalize(s, position=0){
    const prepositions = new Set([
        'the',
        'of',
        'a',
    ]);
    if(position > 0 && prepositions.has(s)){
        return s;
    }
    
    return s.charAt(0).toUpperCase() + s.slice(1)
}

export function titleizeStringArray(stringArray){
    return stringArray.map((s, i)=>{
        return smartCapitalize(s, i);
    }).join(' ');
}