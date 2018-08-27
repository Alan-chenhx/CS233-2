#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
	uint32_t tag_size = _cache_config.get_num_tag_bits();
	uint32_t idx_size = _cache_config.get_num_index_bits();
	uint32_t off_size = _cache_config.get_num_block_offset_bits();
	if (tag_size == 32) return _tag;
	return (_tag << (idx_size + off_size)) + (_index << off_size);
}
