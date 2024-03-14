# llama.cpp test build

```makefile
llm: ../test.cpp llm.o	ggml.o llama.o $(COMMON_DEPS) console.o grammar-parser.o $(OBJS)
	$(CXX) $(CXXFLAGS) -c $< -o $(call GET_OBJ_FILE, $<)
	$(CXX) $(CXXFLAGS) $(filter-out %.h $<,$^) $(call GET_OBJ_FILE, $<) -o ../llm $(LDFLAGS)
	../llm

llm.o:../llm.cpp ../llm.h llama.h ggml.h $(COMMON_H_DEPS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

libllm.so: llm.o ggml.o llama.o $(COMMON_DEPS) console.o grammar-parser.o $(OBJS)
	$(CXX) $(CXXFLAGS) -shared -fPIC -o $@ $^ $(LDFLAGS)
```