# llama.cpp 架构

## 1.binding
- 1.1. llama.h 主要的功能函数
- 1.2  common/sampling.h 采样函数,不用自己再写一遍 
- 1.3  common.h tokenize等工具函数

## 2. 流程
- 2.1 生成llama_model,ctx
- 2.3 llama_tokenize 分词&token --> embd_inp

# flutter plugin
+ podspec内需要用.m和.mm
+ 不要在一个文件内引入多个cpp文件,会符号重复
+ .metal文件需要再podspec中指定静态文件