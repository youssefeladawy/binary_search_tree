require_relative 'lib/node'
require_relative 'lib/tree'

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)

tree.pretty_print

puts tree.balanced?

puts 'Level order:'
puts tree.level_order {|node| print "#{node.data}, "}

puts 'Preorder: '
p tree.preorder

puts 'Inorder: '
p tree.inorder

puts 'Postorder: '
p tree.postorder

20.times do
  a = rand(100..200)
  tree.insert(a)
end

tree.pretty_print

puts "is the tree now balanced: #{tree.balanced?}"

puts 'rebalance tree'
tree.rebalance

tree.pretty_print

puts "is the tree now balanced: #{tree.balanced?}"

puts 'Level order:'
p tree.level_order

puts 'Preorder: '
p tree.preorder

puts 'Inorder: '
p tree.inorder

puts 'Postorder: '
p tree.postorder
