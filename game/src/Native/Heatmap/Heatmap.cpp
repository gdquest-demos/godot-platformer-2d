#include "Heatmap.h"
#include <TileMap.hpp>
#include <SceneTree.hpp>
#include <Viewport.hpp>
#include <deque>
#include <TileSet.hpp>
#include <algorithm>

namespace godot {
	inline float lerp(const float& a, const float& b, const float& t) {
		return a + t * (b - a);
	}

	void Heatmap::_register_methods() {
		//public
		register_method("_ready", &Heatmap::_ready);
		register_method("_draw", &Heatmap::_draw);
		register_method("_process", &Heatmap::_process);
		register_method("best_direction_for", &Heatmap::best_direction_for);
		register_method("calculate_point_index", &Heatmap::calculate_point_index);
		register_method("calculate_point_index_for_world_position", &Heatmap::calculate_point_index_for_world_position);

		//semi-private
		register_method("_on_Events_player_moved", &Heatmap::on_Events_player_moved);

		//properties
		register_property<Heatmap, NodePath>("pathfinding_tilemap", &Heatmap::m_pathfinding_tilemap, NodePath());
		register_property<Heatmap, bool>("draw_debug", &Heatmap::m_draw_debug, false);
	}

	Heatmap::Heatmap() : m_draw_debug(false), m_grid(nullptr), m_max_heat(0), m_max_heat_cache(0),
		m_x_max(0), m_y_max(0), m_x_min(0), m_y_min(0), m_updating(false) {
	}

	Heatmap::~Heatmap() {
	}

	void Heatmap::_init() {
	}

	void Heatmap::_ready() {
		m_grid = (TileMap*)get_node(m_pathfinding_tilemap);
		if (m_grid == nullptr) {
			Godot::print_error("No tilemap found for Heatmap node.", __FUNCTION__, __FILE__, __LINE__ - 2);
			return;
		}

		m_map_limits = m_grid->get_used_rect();
		m_x_min = m_map_limits.position.x;
		m_x_max = m_map_limits.size.x - m_map_limits.position.x;
		m_y_min = m_map_limits.position.y;
		m_y_max = m_map_limits.size.y - m_map_limits.position.y;

		unsigned int highest_index = calculate_point_index(m_map_limits.size - m_map_limits.position);
		m_cells_heat.resize(highest_index);
		m_cells_heat_cache.resize(highest_index);
		for (unsigned int i = 0; i < highest_index; ++i) {
			m_cells_heat[i] = -1;
		}

		find_all_obstacles();

		get_tree()->get_root()->find_node("Events", true, false)->connect("player_moved", this, "_on_Events_player_moved");
	}

	//For every cell in 2D array, check the heat and draw a rectangle colored according to its distance from the goal,
	//get the direction it points to, and draw a simple vector line.
	void Heatmap::_draw() {
		if (!m_draw_debug) {
			return;
		}

		Rect2 tile;
		Vector2 cell_size = m_grid->get_cell_size();
		tile.set_size(cell_size);
		cell_size /= 2;

		for (int y = int(m_y_min); y<int(m_y_max); ++y) {
			for (int x = int(m_x_min); x<int(m_x_max); ++x) {
				Vector2 point = Vector2(float(x), float(y));
				Vector2 world_position = m_grid->map_to_world(point);
				tile.set_position(world_position);

				unsigned int cell_index = calculate_point_index(point);
				int heat = m_cells_heat[cell_index];
				if (heat == -1) {
					continue;
				}
				float proportion = lerp(0.0f, 1.0f, float(heat) / float(m_max_heat));

				draw_rect(tile, Color(1.0f - proportion, 0, proportion, 0.75f), true);

				world_position += cell_size;
				Vector2 direction = best_direction_for(point, false);
				draw_rect(Rect2(world_position.x - 5, world_position.y - 5, 10, 10), Color(0, 1, 0), false);
				draw_line(world_position, world_position + (direction * 20), Color(1, 1, 1));
			}
		}
	}

	void Heatmap::_process(float delta) {
		if (!m_updating) {
			return;
		}

		//Seeing if future::get is ready to deliver data or if the thread is still crunching numbers.
		//_Is_Ready is not yet standardized, so we check with as immediate a timeout as we can.
		if (m_future.wait_for(std::chrono::seconds(0)) == std::future_status::ready) {
			Vector2 player_cell_position = m_future.get();
			thread_done(player_cell_position);
		}
	}

	//for the 3x3 grid surrounding the cell, find the one with the least heat that isn't -1 (invalid), and return a vector
	//that points in its direction. Note that there could be multiple tiles with the same heat, which could cause
	Vector2 Heatmap::best_direction_for(Vector2 t_location, bool t_is_world_location) {
		Vector2 point = t_is_world_location ? m_grid->world_to_map(t_location) : t_location;
		Vector2 world_location = t_is_world_location ? t_location : m_grid->map_to_world(point);
		unsigned int cell_index = calculate_point_index(point);

		if (cell_index < 0 || cell_index >= m_cells_heat.size()) {
			return (m_last_player_cell_position - world_location).normalized();
		}

		Vector2 best_neighbor = point;
		int best_heat = m_cells_heat[cell_index];
		if (best_heat == -1) {
			return (m_last_player_cell_position - world_location).normalized();
		}

		for (int y = 0; y < 3; ++y) {
			for (int x = 0; x < 3; ++x) {
				Vector2 point_relative = Vector2(point.x + float(x) - 1.0f, point.y + float(y) - 1.0f);

				if (is_out_of_bounds(point_relative) || std::find(m_obstacles.begin(), m_obstacles.end(), point_relative) != m_obstacles.end()) {
					continue;
				}

				unsigned int point_relative_index = calculate_point_index(point_relative);
				if (point_relative_index == cell_index) {
					continue;
				}

				if (point_relative_index >= 0 && point_relative_index < m_cells_heat.size()) {
					int heat = m_cells_heat[point_relative_index];

					if (heat == -1) {
						continue;
					}

					if (heat <= best_heat) {
						best_heat = heat;
						best_neighbor = point_relative;
					}
				}
			}
		}

		Vector2 world_neighbor = m_grid->map_to_world(best_neighbor);
		Vector2 direction = (world_neighbor - world_location).normalized();
		if (direction.length_squared() == 0) {
			return (m_last_player_cell_position - world_location).normalized();
		}
		return direction;
	}

	unsigned int Heatmap::calculate_point_index(Vector2 t_point) {
		return int((t_point.x - m_map_limits.position.x) + m_map_limits.size.x * (t_point.y - m_map_limits.position.y));
	}

	unsigned int Heatmap::calculate_point_index_for_world_position(Vector2 t_world_position) {
		return calculate_point_index(m_grid->world_to_map(t_world_position));
	}

	//Runs through every cell and checks if the autotile bitmask of that cell covers the entire cell.
	//If so, it is an obstacle. This does mean that thin corners can seem traversable, even though
	//they wouldn't be.
	void Heatmap::find_all_obstacles() {
		Ref<TileSet> tileset = m_grid->get_tileset();
		Array tile_ids = tileset->get_tiles_ids();

		//TODO: Account for non-autotile tilesets.
		for (int y = m_y_min; y < m_y_max; ++y) {
			for (int x = m_x_min; x < m_x_max; ++x) {
				int cell_id = m_grid->get_cell(x, y);
				if (cell_id == -1 || !tile_ids.has(cell_id)) {
					continue;
				}
				int cell_bitmask = tileset->autotile_get_bitmask(cell_id, m_grid->get_cell_autotile_coord(x, y));
				TileSet::BitmaskMode mode = tileset->autotile_get_bitmask_mode(cell_id);

				int all_covered = 325; //Bitmask is the sum of TileSet::BitmaskMode enum flags.
				if (mode == TileSet::BITMASK_3X3 || mode == TileSet::BITMASK_3X3_MINIMAL) {
					all_covered = 495;
				}

				if (cell_bitmask == all_covered) {
					m_obstacles.push_back(Vector2(x, y));
				}
			}
		}
	}

	//Breadth-first search using a queue.
	Vector2 Heatmap::refresh_cells_heat(Vector2 t_cell_position) {
		std::deque<HeatCell> queue;
		//We begin with 4 cells of goals instead of 1 - this alleviates the problem of multiple cells
		//having the same amount of heat.
		queue.push_back(HeatCell(Vector2(t_cell_position.x, t_cell_position.y), 0));
		queue.push_back(HeatCell(Vector2(t_cell_position.x - 1, t_cell_position.y), 0));
		queue.push_back(HeatCell(Vector2(t_cell_position.x - 1, t_cell_position.y - 1), 0));
		queue.push_back(HeatCell(Vector2(t_cell_position.x, t_cell_position.y - 1), 0));
		m_max_heat_cache = 0;

		while (!queue.empty()) {
			HeatCell cell = queue.front();
			queue.pop_front();

			Vector2 position = cell.position;
			int layer = cell.layer;

			unsigned int index = calculate_point_index(position);
			if (index < 0 || index >= m_cells_heat_cache.size()) {
				continue;
			}
			m_cells_heat_cache[index] = layer;
			if (layer > m_max_heat_cache) {
				m_max_heat_cache = layer;
			}

			for (int y = 0; y < 3; ++y) {
				for (int x = 0; x < 3; ++x) {
					Vector2 point = Vector2(position.x + float(x) - 1.0f, position.y + float(y) - 1.0f);
					unsigned int cell_index = calculate_point_index(point);
					HeatCell new_cell = HeatCell(point, layer + 1);

					if (   cell_index != index
						&& cell_index >= 0 && cell_index < m_cells_heat_cache.size()
						&& m_cells_heat_cache[cell_index] == -1
						&& !is_out_of_bounds(point)
						&& std::find(queue.begin(), queue.end(), new_cell) == queue.end()
						&& std::find(m_obstacles.begin(), m_obstacles.end(), point) == m_obstacles.end()) {

						queue.push_back(new_cell);
					}
				}
			}
		}

		return t_cell_position;
	}

	//Copies the cached, thread specific versions that were used into those used by the main thread.
	void Heatmap::thread_done(Vector2 t_cell_position) {
		m_updating = false;

		m_max_heat = m_max_heat_cache;
		for (int i = 0; i < m_cells_heat.size(); ++i) {
			m_cells_heat[i] = m_cells_heat_cache[i];
		}
		m_last_player_cell_position = t_cell_position;

		update();
	}

	bool Heatmap::is_out_of_bounds(Vector2 t_position) {
		return t_position.x < m_x_min || t_position.y < m_y_min
			|| t_position.x > m_x_max || t_position.y > m_y_max;
	}

	void Heatmap::on_Events_player_moved(Node2D* t_player) {
		if (m_updating) {
			return;
		}

		Vector2 player_cell_position = m_grid->world_to_map(t_player->get_global_position());
		bool out_of_bounds = is_out_of_bounds(player_cell_position);
		Vector2 difference = player_cell_position - m_last_player_cell_position;

		if (!out_of_bounds && (difference.x != 0 || difference.y != 0)) {
			for (int i = 0; i < m_cells_heat_cache.size(); ++i) {
				m_cells_heat_cache[i] = -1;
			}

			m_updating = true;

			// Launch an immediate new thread with ::launch::async.
			// Without that flag, it waits for a future.get()/wait() before starting work.
			m_future = std::async(std::launch::async, &Heatmap::refresh_cells_heat, this, player_cell_position);
		}
	}
}