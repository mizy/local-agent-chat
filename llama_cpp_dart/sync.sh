cd src/llama.cpp
git fetch origin && git reset --hard origin/master
echo '
llm: ../test.cpp llm.o	ggml.o llama.o $(COMMON_DEPS) console.o grammar-parser.o $(OBJS)
	$(CXX) $(CXXFLAGS) -c $< -o $(call GET_OBJ_FILE, $<)
	$(CXX) $(CXXFLAGS) $(filter-out %.h $<,$^) $(call GET_OBJ_FILE, $<) -o ../llm $(LDFLAGS)
	../llm

llm.o:../llm.cpp ../llm.h llama.h ggml.h $(COMMON_H_DEPS)
	$(CXX) $(CXXFLAGS) -c $< -o $@

libllm.so: llm.o ggml.o llama.o $(COMMON_DEPS) console.o grammar-parser.o $(OBJS)
	$(CXX) $(CXXFLAGS) -shared -fPIC -o $@ $^ $(LDFLAGS)
' >> Makefile
# this is only for llm-test task in Makefile,not for build ios or macos app, cause c++ binary need the flag to build and macos or ios will load default metallib that build by xcode
sed -i '' '1i\
LLAMA_METAL_EMBED_LIBRARY := 1 
' Makefile
sed -e '/#include "ggml-common.h"/r ggml-common.h' -e '/#include "ggml-common.h"/d' < ggml-metal.metal > ggml-metal-embed.metal
cp ggml-metal-embed.metal ../../macos/Classes
cp ggml-metal-embed.metal ../../ios/Classes
