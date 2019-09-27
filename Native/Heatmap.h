// Heatmap
// Francois "@Razoric480" Belair
//
// GDNative Godot Class that uses a floodfill algorithm. Radiating out from the player position, it covers the whole tilemap.
// Each step removed adds one to the layer count. This can then be used by agents for quick
// lookup based pathfinding, instead of calculating A-star paths or other, potentially more expensive pathfinding routines.

#ifndef HEATMAP_H
#define HEATMAP_H

#include <Godot.hpp>
#include <Node2D.hpp>
#include <vector>
#include <future>

namespace godot {
	//Forward declarations
	class TileMap;

	// HeatCell. Simple structure used by the `refresh_cells_heat` member function to contain both
	// position and current layer in the flood fill search.
	struct HeatCell {
		HeatCell(Vector2 t_position, int t_layer) {
			position = t_position;
			layer = t_layer;
		}
		Vector2 position;
		int layer;

		bool operator ==(HeatCell const& other) {
			return other.layer == layer && other.position == position;
		}

		bool operator !=(HeatCell const& other) {
			return other.layer != layer || other.position != position;
		}
	};

	class Heatmap : public Node2D {
		GODOT_CLASS(Heatmap, Node2D)

	public:
		Heatmap();
		~Heatmap();

		static void _register_methods();

		void _init();
		void _ready();
		void _draw();
		void _process(float delta);

		Vector2 best_direction_for(Vector2 t_location, bool t_is_world_location);
		unsigned int calculate_point_index(Vector2 t_point);
		unsigned int calculate_point_index_for_world_position(Vector2 t_world_position);

	private:
		void find_all_obstacles();
		Vector2 refresh_cells_heat(Vector2 t_cell_position);
		bool is_out_of_bounds(Vector2 t_position);
		void on_Events_player_moved(Node2D* t_player);
		void thread_done(Vector2 t_cell_position);

	private:
		NodePath m_pathfinding_tilemap;
		bool m_draw_debug;

		TileMap* m_grid;
		Rect2 m_map_limits;
		float m_x_min;
		float m_x_max;
		float m_y_min;
		float m_y_max;
		int m_max_heat;
		int m_max_heat_cache;
		bool m_updating;

		std::vector<int> m_cells_heat;
		std::vector<int> m_cells_heat_cache;
		std::vector<Vector2> m_obstacles;
		Vector2 m_last_player_cell_position;
		std::future<Vector2> m_future;
	};
}

#endif /* HEATMAP_H */
