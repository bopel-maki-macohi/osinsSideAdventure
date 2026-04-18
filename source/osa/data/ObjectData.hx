package osa.data;

import json2object.JsonParser;

class ObjectData<T>
{
	public function new(file:String)
	{
		load(new JsonParser<T>().fromJson(file.readText()));
	}

    @:jignored
	public function load(data:T) {}
}
