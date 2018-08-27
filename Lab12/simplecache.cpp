#include "simplecache.h"
#include <iostream>
using namespace std;
int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	vector<SimpleCacheBlock> retval = _cache[index];
	for (auto& i : retval){
		if (tag == i.tag() && i.valid()){
			return i.get_byte(block_offset);
		}
	}
  	return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
	vector<SimpleCacheBlock>& retval = _cache[index];
	for (auto& i: retval){
		if (i.valid() == 0){
			i.replace(tag, data);
 			return;
		}
	}
	cout << "end" <<endl;
	retval[0].replace(tag,data);

}
