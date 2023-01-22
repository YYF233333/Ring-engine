import os
import json

ASSET_FOLDER = "assets"
GLOBAL_IDENTIFIER = ".global"

def generate_asset(path_abs: str):
    no_ext, ext = os.path.splitext(path_abs)
    _, name = os.path.split(no_ext)
    asset = {"path": os.path.join("res://", path_abs).replace("\\", "/")}
    if ext == ".json":
        asset["type"] = "JSON"
    elif ext == ".tscn" or ext == ".scn":
        asset["type"] = "SCENE"
    elif ext == ".png" or ext == ".jpg" or ext == ".webp":
        asset["type"] = "IMAGE"
    else:
        return None
    return asset

def scan_folder(path: str) -> dict:
    group = {"type": "GROUP"}
    if os.path.exists(os.path.join(path, GLOBAL_IDENTIFIER)):
        group["global"] = True
    members = {}
    for file in os.listdir(path):
        name, ext = os.path.splitext(file)
        file_path_abs = os.path.join(path, file)
        if os.path.isdir(file_path_abs):
            members[name] = scan_folder(file_path_abs)
        else:
            name = name.removeprefix("_")
            asset = generate_asset(file_path_abs)
            if asset != None:
                members[name] = asset
    group["members"] = members
    return group

if __name__ == "__main__":
    assets = scan_folder(ASSET_FOLDER)["members"]

    data = json.dumps(assets, indent=4, ensure_ascii=False)

    with open("config/assets.json", "w", encoding="utf-8") as f:
        f.write(data)
    