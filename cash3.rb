require 'csv'

@finish_num = nil
@report_num = nil


def load_the_db
  order_list = CSV.table('products.csv')
  index = 0
  order_list.each do |row|
    puts "#{(index + 1)}) Add item - #{order_list[index][:retail_price]} - #{order_list[index][:name]} "
    index += 1
  end
  puts "#{index += 1}) Complete Sale"
    @finish_num = index.to_s
  puts "#{index += 1}) Reporting"
    @report_num = index.to_s
  return order_list
end


def prompt(text)
  puts text + "\n"
  print "> "
  input =gets.chomp
  puts "\n"
  input
end


def is_num?(maybe_num)
   !!/^\d*\.?\d{0,2}/.match(maybe_num)
end

def get_due
  due = prompt("Make a selection:")
  if  !(is_num?(due))|| (due > @report_num)
    get_due
  elsif due.include?(@finish_num)
    return "done"
  end
  due.to_f
end

def get_input(text)
  tend = prompt (text)
  if  !(is_num?(tend))
      get_input
  end
  tend.to_f
end

def subtotal(arrayin)
  arrayin.inject(0) {|sum, val| sum + val }
end

def process_orders
  due = ''
  order_list = []
  until due == 'done'
    due = get_due()
    order_list << due if due.class != String
    puts "Subtotal: #{format_money(subtotal(order_list))}"
  end
  print_items(order_list)
end

def print_items(order_list)
  puts "Here are your item prices:\n "
  order_list.each do |item|
    puts "#{format_money(item)}"
  end

  puts "The total amount due is #{format_money(subtotal(order_list))}\n " + "\n"

  order_list
end

def format_money(value)
  sprintf("$%.2f", value)
end

def ringup(due, tend)
  if due <= tend
    puts "=====Thank You!====="
    puts "Change due is #{format_money(tend - due)} "
    puts Time.now.strftime('%m/%d/%y   %l:%m%p')
    puts "=" *20
  else
    puts "WARNING: Customer still owes $#{format_money(due - tend)}! Exiting..."
  end

end

def hash_order(hash, item, quantity, subtotal)


end

def display_order(hash)

end


def write_order (quantity_hash, db)
  var = "retail_report"
   CSV.open("cash3_reports/#{var}", 'w') do |csv|
      quantity_hash.each do |quant|
        csv << [ db[:sku][quant[0]], quant[1], db[:name][quant[0]], db[:wholesale_price][quant[0]], db[:retail_price][quant[0]]]
      end
  end
end

def daily_report
  db = load_the_db
  order_list = CSV.table('cash3_reports/retail_report')
  index = 0
  order_list.each do |row|
    puts "#{(index + 1)}) Add item - #{order_list[index][:retail_price]} - #{order_list[index][:name]} "
    index += 1
  end

end

daily_report

def accounting
  puts "Welcome to James' coffee emporium!\n" + "\n"

  db = load_the_db
  order_list = Hash.new(0)
  subtotal = 0


  while true
    selection = get_due
    break if selection == 'done'
    quantity = get_input("How many?")
    subtotal += (db[:retail_price][selection-1]) * quantity
    order_list[selection] += quantity
    puts "Subtotal: " + format_money(subtotal) + "\n"

  end

  puts "===Sale Complete==="
  order_list.each do |item|
    puts "#{format_money(db[:retail_price][item[0]- 1] * item[1])}- #{item[1]} #{ db[:name][item[0]-1]}"
  end
  puts "Subtotal: " + format_money(subtotal) + "\n" + "\n"
  write_order(order_list, db)

  tend = get_input("What is the amount tendered?")

  ringup(subtotal, tend)


end

#accounting
#ringup subtotal(process_orders), get_input
