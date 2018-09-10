#include <cassert>
#include <iostream>
#include <vector>

#include "TClass.h"

int main()
{
  static auto const vt = "std::vector<int>";
  auto const result = TClass::GetClass(vt);
  assert(result != nullptr);
}
