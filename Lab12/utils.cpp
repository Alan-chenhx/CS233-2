#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	uint32_t tag = cache_config.get_num_tag_bits();
  	return address >> (32 - tag);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	uint32_t idx = cache_config.get_num_index_bits();
	uint32_t tag = cache_config.get_num_tag_bits();
	if (tag >= 32)
		return 0;
  	return address << (tag) >> (32-idx);
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	uint32_t offset = cache_config.get_num_block_offset_bits();
	if (offset >= 32)
		offset = 31;
  	return address & ((1<<offset)-1);
}
