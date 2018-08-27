#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */
  uint32_t idx = extract_index(address,_cache->get_config());
  vector<Cache::Block* > res = _cache->get_blocks_in_set(idx);
  for (auto& i : res){
    if (i->is_valid() && i->get_tag() == extract_tag(address,_cache->get_config())){
      _hits ++;
      return i;
    }
  }

  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  uint32_t idx = extract_index(address,_cache->get_config());
  vector<Cache::Block* > res = _cache->get_blocks_in_set(idx);
  auto lru = res[0];
  for (auto& i : res){

    if (!i->is_valid()){
      uint32_t tags = extract_tag(address,_cache->get_config());
      i->set_tag(tags);
      i->read_data_from_memory(_memory);
      i->mark_as_clean();
      i->mark_as_valid();
      return i;
    }
  }
  for (auto& i : res){
    if (i->get_last_used_time() < lru->get_last_used_time()){
      lru = i;
    }
  }
  if (lru->is_dirty()){
      lru->write_data_to_memory(_memory);  
  }
  uint32_t tags = extract_tag(address,_cache->get_config());
  lru->set_tag(tags);
  lru->read_data_from_memory(_memory);
  lru->mark_as_clean();
  lru->mark_as_valid();
  return lru;  
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  auto temp = find_block(address);
  if (temp == NULL){
    temp = bring_block_into_cache(address);
  }
  temp->set_last_used_time(_use_clock.get_count());
  _use_clock++;
  return temp->read_word_at_offset(extract_block_offset(address,_cache->get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
  auto temp = find_block(address);
  if (temp == NULL){
    if (_policy.is_write_allocate()){
      temp = bring_block_into_cache(address);
    }
    else{
      _memory->write_word(address,word);
      return;
    }
  }

    temp->set_last_used_time(_use_clock.get_count());
    _use_clock++;
    temp->write_word_at_offset(address, extract_block_offset(address,_cache->get_config()));
    if (_policy.is_write_back()){
      temp->mark_as_dirty();
    }
    else{
      _memory->write_word(address,word);
    }
  
}
