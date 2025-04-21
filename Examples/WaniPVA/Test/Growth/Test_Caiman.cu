#include "gtest/gtest.h"
#include "gmock/gmock.h"

int main(int argc, char **argv) {
   std::cout << "Run" << std::endl;

  ::testing::InitGoogleMock(&argc, argv);
  return RUN_ALL_TESTS();
}
