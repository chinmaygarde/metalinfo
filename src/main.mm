#include <Foundation/Foundation.h>
#include <Metal/Metal.h>
#include <iostream>
#include <sstream>

static_assert(__has_feature(objc_arc), "ARC must be enabled.");

namespace metalinfo {

struct Logger {
  Logger(bool is_error) : is_error_(is_error) {}

  ~Logger() {
    if (is_error_) {
      std::cerr << stream_.str() << std::endl;
    } else {
      std::cout << stream_.str() << std::endl;
    }
  }

  std::ostream& stream() { return stream_; }

 private:
  bool is_error_ = false;
  std::ostringstream stream_;
};

#define LOG metalinfo::Logger{false}.stream()
#define LOG_ERROR metalinfo::Logger{true}.stream()

std::string MTLSizeToString(MTLSize size) {
  return std::format("{} x {} x {}", size.width, size.height, size.depth);
}

std::string ToString(MTLReadWriteTextureTier location) {
  switch (location) {
    case MTLReadWriteTextureTierNone:
      return "MTLReadWriteTextureTierNone";
    case MTLReadWriteTextureTier1:
      return "MTLReadWriteTextureTier1";
    case MTLReadWriteTextureTier2:
      return "MTLReadWriteTextureTier2";
  }
  return "Unknown";
}

std::string ToString(MTLArgumentBuffersTier location) {
  switch (location) {
    case MTLArgumentBuffersTier1:
      return "MTLArgumentBuffersTier1";
    case MTLArgumentBuffersTier2:
      return "MTLArgumentBuffersTier2";
  }
  return "Unknown";
}

std::string ToString(MTLDeviceLocation location) {
  switch (location) {
    case MTLDeviceLocationBuiltIn:
      return "MTLDeviceLocationBuiltIn";
    case MTLDeviceLocationSlot:
      return "MTLDeviceLocationSlot";
    case MTLDeviceLocationExternal:
      return "MTLDeviceLocationExternal";
    case MTLDeviceLocationUnspecified:
      break;
  }
  return "MTLDeviceLocationUnspecified";
}

void DumpDivider(std::string section) {
  LOG << std::format("{:=^60}", std::format(" {} ", section));
}

void DumpArchitecture(MTLArchitecture* architecture) {
  LOG << "Architecture Name = " << architecture.name.UTF8String;
}

void DumpFamilySupport(id<MTLDevice> device) {
  DumpDivider("Family Support");
  LOG << "supportFamily(MTLGPUFamilyApple2) = "
      << [device supportsFamily:MTLGPUFamilyApple2];
  LOG << "supportFamily(MTLGPUFamilyApple3) = "
      << [device supportsFamily:MTLGPUFamilyApple3];
  LOG << "supportFamily(MTLGPUFamilyApple4) = "
      << [device supportsFamily:MTLGPUFamilyApple4];
  LOG << "supportFamily(MTLGPUFamilyApple5) = "
      << [device supportsFamily:MTLGPUFamilyApple5];
  LOG << "supportFamily(MTLGPUFamilyApple6) = "
      << [device supportsFamily:MTLGPUFamilyApple6];
  LOG << "supportFamily(MTLGPUFamilyApple7) = "
      << [device supportsFamily:MTLGPUFamilyApple7];
  LOG << "supportFamily(MTLGPUFamilyApple8) = "
      << [device supportsFamily:MTLGPUFamilyApple8];
  LOG << "supportFamily(MTLGPUFamilyApple9) = "
      << [device supportsFamily:MTLGPUFamilyApple9];
  LOG << "supportFamily(MTLGPUFamilyCommon1) = "
      << [device supportsFamily:MTLGPUFamilyCommon1];
  LOG << "supportFamily(MTLGPUFamilyCommon2) = "
      << [device supportsFamily:MTLGPUFamilyCommon2];
  LOG << "supportFamily(MTLGPUFamilyCommon3) = "
      << [device supportsFamily:MTLGPUFamilyCommon3];
  LOG << "supportFamily(MTLGPUFamilyMac1) = "
      << [device supportsFamily:MTLGPUFamilyMac1];
  LOG << "supportFamily(MTLGPUFamilyMac2) = "
      << [device supportsFamily:MTLGPUFamilyMac2];
  LOG << "supportFamily(MTLGPUFamilyMacCatalyst1) = "
      << [device supportsFamily:MTLGPUFamilyMacCatalyst1];
  LOG << "supportFamily(MTLGPUFamilyMacCatalyst2) = "
      << [device supportsFamily:MTLGPUFamilyMacCatalyst2];
  LOG << "supportFamily(MTLGPUFamilyMetal3) = "
      << [device supportsFamily:MTLGPUFamilyMetal3];
  LOG << "supportFamily(MTLGPUFamilyApple1) = "
      << [device supportsFamily:MTLGPUFamilyApple1];
}

void DumpCounterSet(id<MTLCounterSet> set) {
  DumpDivider(set.name.UTF8String);
  for (id<MTLCounter> counter in set.counters) {
    LOG << counter.name.UTF8String;
  }
}

void DumpDeviceInfo(id<MTLDevice> device) {
  DumpDivider(device.name.UTF8String);
  LOG << "name = " << device.name.UTF8String;
  LOG << "registryID = " << std::format("{:#x}", device.registryID);
  DumpArchitecture(device.architecture);
  LOG << "maxThreadsPerThreadgroup = "
      << MTLSizeToString(device.maxThreadsPerThreadgroup);
  LOG << "isLowPower = " << std::format("{}", device.isLowPower);
  LOG << "isHeadless = " << std::format("{}", device.isHeadless);
  LOG << "isRemovable = " << std::format("{}", device.isRemovable);
  LOG << "hasUnifiedMemory = " << std::format("{}", device.hasUnifiedMemory);
  LOG << "recommendedMaxWorkingSetSize = "
      << std::format("{} bytes", device.recommendedMaxWorkingSetSize);
  LOG << "location = " << std::format("{}", ToString(device.location));
  LOG << "locationNumber = " << std::format("{}", device.locationNumber);
  LOG << "maxTransferRate = " << std::format("{}", device.maxTransferRate);
  LOG << "isDepth24Stencil8PixelFormatSupported = "
      << std::format("{}", device.isDepth24Stencil8PixelFormatSupported);
  LOG << "readWriteTextureSupport = "
      << std::format("{}", ToString(device.readWriteTextureSupport));
  LOG << "argumentBuffersSupport = "
      << std::format("{}", ToString(device.argumentBuffersSupport));
  LOG << "areRasterOrderGroupsSupported = "
      << std::format("{}", device.areRasterOrderGroupsSupported);
  LOG << "supports32BitFloatFiltering = "
      << std::format("{}", device.supports32BitFloatFiltering);
  LOG << "supports32BitMSAA = " << std::format("{}", device.supports32BitMSAA);
  LOG << "supportsQueryTextureLOD = "
      << std::format("{}", device.supportsQueryTextureLOD);
  LOG << "supportsBCTextureCompression = "
      << std::format("{}", device.supportsBCTextureCompression);
  LOG << "supportsPullModelInterpolation = "
      << std::format("{}", device.supportsPullModelInterpolation);
  LOG << "areBarycentricCoordsSupported = "
      << std::format("{}", device.areBarycentricCoordsSupported);
  LOG << "supportsShaderBarycentricCoordinates = "
      << std::format("{}", device.supportsShaderBarycentricCoordinates);
  LOG << "currentAllocatedSize = "
      << std::format("{} bytes", device.currentAllocatedSize);
  LOG << "maxThreadgroupMemoryLength = "
      << std::format("{} bytes", device.maxThreadgroupMemoryLength);
  LOG << "maxArgumentBufferSamplerCount = "
      << std::format("{}", device.maxArgumentBufferSamplerCount);
  LOG << "areProgrammableSamplePositionsSupported = "
      << std::format("{}", device.areProgrammableSamplePositionsSupported);
  LOG << "supportsFunctionPointers = "
      << std::format("{}", device.supportsFunctionPointers);
  LOG << "supportsFunctionPointersFromRender = "
      << std::format("{}", device.supportsFunctionPointersFromRender);
  LOG << "supportsRaytracingFromRender = "
      << std::format("{}", device.supportsRaytracingFromRender);
  LOG << "supportsPrimitiveMotionBlur = "
      << std::format("{}", device.supportsPrimitiveMotionBlur);
  LOG << "shouldMaximizeConcurrentCompilation = "
      << std::format("{}", device.shouldMaximizeConcurrentCompilation);
  LOG << "maximumConcurrentCompilationTaskCount = "
      << std::format("{}", device.maximumConcurrentCompilationTaskCount);
  LOG << "peerGroupID = " << std::format("{}", device.peerGroupID);
  LOG << "peerIndex = " << std::format("{}", device.peerIndex);
  LOG << "peerCount = " << std::format("{}", device.peerCount);
  LOG << "supportsDynamicLibraries = "
      << std::format("{}", device.supportsDynamicLibraries);
  LOG << "supportsRenderDynamicLibraries = "
      << std::format("{}", device.supportsRenderDynamicLibraries);
  LOG << "supportsRaytracing = "
      << std::format("{}", device.supportsRaytracing);
  LOG << "sparseTileSizeInBytes = "
      << std::format("{} bytes", device.sparseTileSizeInBytes);
  LOG << "maxBufferLength = "
      << std::format("{} bytes", device.maxBufferLength);
  DumpFamilySupport(device);
  for (id<MTLCounterSet> counter_set in device.counterSets) {
    DumpCounterSet(counter_set);
  }
}

bool Main() {
  auto devices = MTLCopyAllDevices();
  if (devices.count == 0u) {
    LOG_ERROR << "No Metal devices found.";
    return false;
  }
  LOG << "Found " << devices.count << " Metal device(s).";
  for (id<MTLDevice> device in devices) {
    DumpDeviceInfo(device);
  }

  return true;
}

}  // namespace metalinfo

int main(int argc, char const* argv[]) {
  @autoreleasepool {
    return metalinfo::Main() ? EXIT_SUCCESS : EXIT_FAILURE;
  }
}
