# nilガードについて

# nilガードとは中身がnilであるオブジェクトに対してメソッドを実行しようとしたときに出るエラーを回避する方法である。
# nilガードを行うには、ぼっち演算子と呼ばれる「 &. 」を用いた記法を利用する。
# (nilガードを行う方法はいくつがあるので、現場で使える Ruby on Rails 5速習実践ガイドのP47を参照すること)


# ぼっち演算子の使い方

# 説明のためにオブジェクトを作成するためのクラスとメソッドを用意しておく
class Number

  attr_accessor :first_number
  attr_accessor :second_number

  def initialize(first_number:, second_number:)
    self.first_number = first_number
    self.second_number = second_number
  end

  def sum
     first_number + second_number   # returnは省略
  end

end


# 本来はここで上記のクラスから
# numbers = Number.new(first_number: 6, second_number: 4)
# のようにオブジェクトを作成するが、ここでは
numbers = nil
# のようにオブジェクトが代入される変数にnilを代入しておく。
# (numbersという変数そのものが存在しないわけではなく、
#  numbersの中身が存在しない(nilである)という意味なので変数numbersは定義しなくてはならない)

# ここで下記のif文を実行すると
# if numbers.sum == 10
#   puts("合計値は一致します")
# end
# 実行結果は undefined method `sum' for nil:NilClass (NoMethodError) というエラーが出る。
# これは中身がnilであるnumbersに対してメソッド(sumメソッド)は使えないという意味である。
# このエラーを回避するためには、上記のif文をさらにnumbersがnilであるかどうかというif文で包んで
if numbers   # 正確には numbers != nil だが省略できる模様
  if numbers.sum == 10
    puts("合計値は一致します")
  end
end
# とする必要がある。
# 実行結果は 何も出力されないがエラーは回避される。


# 上記のif文をぼっち演算子を使って書き換えると
if numbers&.sum == 10
  puts("合計値は一致します")
end
# のようになる。
# 実行結果は 何も出力されないがエラーは回避される。

# ぼっち演算子はオブジェクトに対してメソッドを実行する際の「 . 」を「 &. 」にして使用する。
# (上記の場合は numbers.sum でなく numbers&.sum とすることでぼっち演算子を使用している)
# ぼっち演算子を使用することでメソッドの実行対象のオブジェクトがnilだった場合に、
# メソッド実行後の値をnilとして返すことができる(通常はnilでなくエラーが返ってしまう)
# つまり上記の例でいうと numbers&.sum のnumbersの中身がnilだった場合は、
# 「 numbers&.sum 」全体の戻り値としてnilを返し、numbersの中身がnilでなかった場合は、
# 普通にnumbersに対してsumメソッドを実行するということになる。
# このようにすることでif文を入れ子にすることなく簡潔にNoMethodErrorというエラーを回避することができる。