# 単一責務性の違反指数（SRP）
#
# 参考 : http://ni66ling.hatenadiary.jp/entry/2015/06/25/000444
#

#   SRP＝R＋U＋((L/100)－5)
#     R：修正リビジョンのユニーク数
#     U：修正ユーザのユニーク数
#     L：モジュールのライン数
function get_SRP() {
  local target_filepath=$1
  echo $(( \
    $(git --no-pager blame --line-porcelain $target_filepath | sed -n 's/^summary //p' | sort | uniq -c | sort -rn | wc -l) + \
    $(git --no-pager blame --line-porcelain $target_filepath | sed -n 's/^author //p' | sort | uniq -c | sort -rn | wc -l) + \
    ( $(cat $target_filepath | wc -l) / 100 - 5) \
  )) $target_filepath
}

# SRPが酷い順（大きい順）に "SRP ファイル名" を標準出力
for file in `git ls-files src/main/java/ | grep -E '\.java$'`; do
  get_SRP $file
done | sort -k1,1 -nr 

