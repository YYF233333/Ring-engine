import os
import json

ASSET_FOLDER = "assets"

def scan_global_assets(root: str):
    assets = {}
    for root, dirs, files in os.walk(root):
        for file in files:
            if file.startswith("_"):
                continue
            path = os.path.join("res://", root, file).replace("\\", "/")
            name, ext = os.path.splitext(file)
            if ext == ".json":
                assets[name] = [path, "JSON"]
            elif ext == ".png" or ext == ".jpg" or ext == ".webp":
                assets[name] = [path, "IMAGE"]
    return assets

def scan_groups(root: str):
    groups = {}
    for root, dirs, files in filter(lambda x: len(x[1]) == 0, os.walk("assets")):
        group_name = os.path.split(root)[1]
        if groups.get(group_name) == None:
            groups[group_name] = []
        for file in files:
            name, ext = os.path.splitext(file)
            if not file.startswith("_"):
                groups[group_name].append(name)
            else:
                file = file[1:]
                path = os.path.join("res://", root, file).replace("\\", "/")
                
                if ext == ".json":
                    asset = [name, path, "JSON"]
                elif ext == ".png" or ext == ".jpg" or ext == ".webp":
                    asset = [name, path, "IMAGE"]

                groups[group_name].append(asset)
    return groups

if __name__ == "__main__":
    assets = scan_global_assets(ASSET_FOLDER)

    data = json.dumps(assets, indent=4)

    with open("config/assets.json", "w", encoding="utf-8") as f:
        f.write(data)
    
    groups = scan_groups(ASSET_FOLDER)
    
    data = json.dumps(groups, indent=4)

    with open("config/groups.json", "w", encoding="utf-8") as f:
        f.write(data)
    