//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files/Blythe-small/blythe-depths.dmm"
		#include "map_files/Blythe-small/blythe-lower.dmm"
		#include "map_files/Blythe-small/blythe-surface.dmm"
		#include "map_files/Blythe-small/blythe-upper.dmm"
		#ifdef TRAVISBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
