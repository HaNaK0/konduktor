import re as re
from dataclasses import dataclass
from pathlib import Path

@dataclass
class ComponentType:
    type_name: str
    full_name: str

def build_components():
    lines = []
    with open("ecs/component.lua") as f:
       lines = list(f)

    components = read_tag(lines)
    components.insert(0, ComponentType("Entity", "Entity"))

    Path("lib/generated/").mkdir(exist_ok=True, parents=True)

    with open("lib/generated/components.lua",mode="w") as f:
        f.write("---@meta ComponentCollection\n")
        f.write("--Generated using build.py\n\n")

        f.write("---@class ComponentCollection\n")
        for componentType in components:
            f.write(f"---@field {componentType.type_name} {componentType.full_name}\n")

        f.write("\n---@alias ComponentType\n")
        for componentType in components:
            f.write(f"---| \'\"{componentType.type_name}\"\'\n")

__tag_pattern = re.compile(r"---@(\w*)|\s+\n?")
def read_tag(input: list[str]) -> list[ComponentType]:
   if len(input) == 0:
       return list()

   tag_match = __tag_pattern.match(input[0]) 
   if tag_match is None:
       raise Exception(f"unexpected symbol: {input[0]}")
    
   if tag_match.group(1) == "class":
       return [read_class(input[0][tag_match.end():])] + read_tag(input[1:])

   return read_tag(input[1:])

__class_pattern = re.compile(r"((.*)Component):|Component")
def read_class(input: str) -> ComponentType:
    match = __class_pattern.match(input.strip())
    
    if match is None:
        raise Exception(f"Unexpected symbols in class {input}")

    if match.group(1) is None:
        return ComponentType("Component", "Component")

    return ComponentType(match.group(2), match.group(1))

if __name__ == "__main__":
    build_components()
