#!/bin/bash
if ! command -v mmdc &> /dev/null; then
    npm install -g @mermaid-js/mermaid-cli\n
fi
file="$1"  # 这里替换为你的文件名或通过参数传入
dir=$(dirname "$file")
filename=$(basename "$file" .md)
today=$(date +%Y%m%d)
output_dir="$dir/output"
mkdir -p "$output_dir"
targetfile="${filename}_${today}.md"

mmdc -i "$file" -o "$output_dir/$targetfile"