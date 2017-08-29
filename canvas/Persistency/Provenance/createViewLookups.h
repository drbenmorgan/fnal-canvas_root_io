#ifndef canvas_Persistency_Provenance_createViewLookups_h
#define canvas_Persistency_Provenance_createViewLookups_h

#include "canvas/Persistency/Provenance/BranchDescription.h"
#include "canvas/Persistency/Provenance/type_aliases.h"

#include <utility>

namespace art {
  ViewLookup_t createViewLookups(ProductDescriptions const& descriptions);
}

#endif /* canvas_Persistency_Provenance_createViewLookups_h */

// Local Variables:
// mode: c++
// End:
