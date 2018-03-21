function export_data_to_file()
  game.print("Export started")
  data = {}
  table.insert(data, export_recipes())
  write_to_file("{\n" .. table.concat(data, ",\n") .. "\n}")
  game.print("Export complete")
  game.print("File location: C:/Users/<username>/AppData/Roaming/Factorio/script-output/export.json")
end

function export_recipes()
  recipes = {}
  for name, recipe in pairs(game.recipe_prototypes) do
    recipe_lines = {}
    table.insert(recipe_lines, '\t\t"name": ' .. '"' .. recipe.name .. '"')

    input_lines = {}
    for k, input in pairs(recipe.ingredients) do
      local amount = input.amount
                     or input.amount_min
                     or input.amount_max
      table.insert(input_lines, '\t\t\t"' .. input.name .. '": ' .. amount)
    end
    table.insert(recipe_lines, '\t\t"inputs":\n\t\t{' .. table.concat(input_lines, ",\n") .. "\n\t\t}")

    output_lines = {}
    for k, output in pairs(recipe.products) do
      local amount = output.amount
                     or output.amount_min
                     or output.amount_max
      table.insert(output_lines, '\t\t\t"' .. output.name .. '": ' .. amount)
    end
    table.insert(recipe_lines, '\t\t"outputs":\n\t\t{\n' .. table.concat(output_lines, ",\n") .. "\n\t\t}")
    table.insert(recipe_lines, '\t\t"energy": ' .. recipe.energy)
    table.insert(recipes, "\t{\n" .. table.concat(recipe_lines, ",\n") .. "\n\t}")
  end
  return '\t"recipes": [\n' .. table.concat(recipes, ',\n') .. "]"
end

function write_to_file( string )
  local save_path = "export.json"
  game.remove_path(save_path)
  game.write_file(save_path, string, true)
end

script.on_init(
 function ()
  commands.add_command("export", "Exports data to a JSON file in scripts/output folder", function(e)
    export_data_to_file()
  end)
 end
)
