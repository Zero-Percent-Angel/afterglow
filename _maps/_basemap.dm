//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files/Blythe-small/blythe-depths.dmm"
		#include "map_files/Blythe-small/blythe-lower.dmm"
		#include "map_files/Blythe-small/blythe-surface.dmm"
		#include "map_files/Blythe-small/blythe-upper.dmm"
		#include "map_files/Tipton/Dungeons_1.dmm"
		#include "map_files/Tipton/Tipton-Underground-1.dmm"
		#include "map_files/Tipton/Tipton-Surface-2.dmm"
		#include "map_files/Tipton/Tipton-Sky-3.dmm"
		#include "map_files/Vegas Valley/Vegas_Valley_Sky.dmm"
		#include "map_files/Vegas Valley/Vegas_Valley_Surface.dmm"
		#include "map_files/Vegas Valley/Vegas_Valley_Underground.dmm"
		#ifdef TRAVISBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
