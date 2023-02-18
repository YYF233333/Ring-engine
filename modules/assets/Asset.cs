using Godot;
using System;
using FluentResults;
using System.Text.Json;
using Godot.Collections;

// C# has GC, no need for Refcounted.
public abstract class Asset<T>
{
    public String name;
    public String path;

    public Asset(String name, String path)
    {
        this.name = name;
        this.path = path;
    }

    public abstract Result<T> try_load();
    public abstract Result try_store(T data);
}

public class ImageAsset : Asset<Texture2D>
{
    public ImageAsset(String name, String path) : base(name, path) { }
    public override Result<Texture2D> try_load()
    {
        var image = GD.Load<Texture2D>(path);
        if (image == null)
        {
            return Result.Fail(String.Format("Image {0} load fail.", name));
        }
        return Result.Ok(image);
    }

    public override Result try_store(Texture2D texture)
    {
        var image = texture.GetImage();
        var err = image.SavePng(path);
        if (err != Godot.Error.Ok)
        {
            return Result.Fail(String.Format("Image {0} save fail: {1}", name, err));
        }
        return Result.Ok();
    }
}

public class JsonAsset : Asset<Dictionary>
{
    public JsonAsset(String name, String path) : base(name, path) { }
    public override Result<Dictionary> try_load()
    {
        var json_string = FileAccess.GetFileAsString(path);
        if (json_string.Length == 0)
        {
            return Result.Fail(String.Format("Json file {0} load fail.", name));
        }
        return parse_json(json_string);
    }
    public override Result try_store(Dictionary data)
    {
        var json_string = Json.Stringify(data, "    ");
        var file = FileAccess.Open(path, FileAccess.ModeFlags.Write);
        if (file == null)
        {
            return Result.Fail(String.Format("Cannnot open file {0}: error code {1}",
                path, FileAccess.GetOpenError()));
        }
        file.StoreString(json_string);
        return Result.Ok();
    }

    public static Result<Dictionary> parse_json(String data)
    {
        var json = new Json();
        var parse_result = json.Parse(data);
        if (parse_result != Godot.Error.Ok)
        {
            return Result.Fail(String.Format("JSON Parse Error: {1} in {2} at line {3}",
                json.GetErrorMessage(), data, json.GetErrorLine()));
        }
        return Result.Ok(json.Data.As<Dictionary>());
    }
}