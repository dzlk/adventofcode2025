# Day Template

## How to use this template

1. Copy this entire `day_template` folder to `dayXX` (e.g., `day01`, `day15`)
2. Rename files:
   - `day_template.gd` → `dayXX.gd`
   - `day_template.tscn` → `dayXX.tscn`
3. Update the scene file:
   - Open `dayXX.tscn` in a text editor
   - Change the script path from `res://days/day_template/day_template.gd` to `res://days/dayXX/dayXX.gd`
4. Update `dayXX.gd`:
   - Set `day_number` to the correct day
   - Set `day_title` to the problem title
   - Configure `test_data` with your test cases
   - Implement `solve_part1()` and `solve_part2()`
5. Add your inputs:
   - Put example input in `test_input.txt`
   - Put your personal input in `input.txt` (this won't be committed)
6. Open the scene in Godot and run it!

## Optional: Adding Visualization

To add visualization to your day:

1. Add a `CanvasLayer` or `Panel` to the scene for drawing
2. Create helper methods like `visualize_step()` in your script
3. Use `queue_redraw()` and `_draw()` for custom drawing
4. Add a "Step" button for step-by-step execution if needed

