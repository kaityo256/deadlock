def search
  s = 100
  e = 1000000
  while e != s && e != s + 1
    n = (e + s) / 2
    if system("gtimeout 1 mpirun -np 2 ./a.out #{n} > /dev/null")
      puts "#{n} OK"
      s = n
    else
      puts "#{n} NG"
      e = n
    end
  end
end

search
