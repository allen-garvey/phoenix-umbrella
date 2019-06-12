const apiUrlBase = '/api';

function getJson(url){
	return fetch(url).then((response)=>{ 
		return response.json();
	}).then((json)=>{
		return json.data;
	});
}

export default {
    apiUrlBase,
    getJson,
};