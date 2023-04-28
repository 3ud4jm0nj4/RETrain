# Banana
![](https://i.imgur.com/5I8amuG.png)
Thử `nc` thì chương trình sẽ hỏi có bao nhiêu quả chuối:
![](https://i.imgur.com/gGDovBb.png)

Sau đó tải file bài cho được code bằng ngôn ngữ Erlang
![](https://i.imgur.com/hdmadKD.png)

Chúng ta sử dụng [tool này](https://github.com/michalmuskala/decompile) để decompile bằng lệnh:
`mix decompile Elixir.Bananas.beam --to expanded`
Sau đó ta được một file `Elixir.Bananas.ex`:
```python=
defmodule Bananas do
  defp to_integer([num, string]) do
    [:erlang.binary_to_integer(num), string]
  end

  defp to_integer(list) do
    list
  end

  defp print_flag(false) do
    IO.puts("Nope")
  end

  defp print_flag(true) do
    IO.puts(File.read!("flag.txt"))
  end

  def main(args) do
    print_flag(check(convert_input(IO.gets("How many bananas do I have?\n"))))
  end

  def main() do
    super([])
  end

  defp convert_input(string) do
    to_integer(String.split(String.trim(string)))
  end

  defp check([num, "bananas"]) do
    :erlang.==(:erlang.-(:erlang.*(:erlang.+(num, 5), 9), 1), 971)
  end

  defp check(_asdf) do
    false
  end
end
```

Nhìn dòng 31 thì cũng ta thấy được hàm check, hàm này check số chuối chúng ta nhập vào:

`(((chuối +5)*9))-1==971` => chuối bằng 103 và input đầu vào thêm chữ `bananas` đằng sau:

![](https://i.imgur.com/hEMcZ7u.png)

## flag
`actf{baaaaannnnananananas_yum}`