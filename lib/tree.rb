require_relative 'node'

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array
    @root = build_tree(@array)
  end

  def build_tree(array)
    return nil if array.empty?
  
    midpoint = array.length / 2
    root = Node.new(array[midpoint])
    # tree = Tree.new(array, root)
    # p tree
    root.left = build_tree(array[0, midpoint])
    root.right = build_tree(array[midpoint + 1, array.length - 1])
    
    root
  end
end


# def build_tree(array)
#   return nil if array.empty?
#   # sort and remove duplicates

#   midpoint = array.length / 2
#   root = Node.new(array[midpoint])
#   # tree = Tree.new(array, root)
#   # p tree
#   root.left = build_tree(array[0, midpoint])
#   root.right = build_tree(array[midpoint + 1, array.length - 1])

#   root
# end
# array = [1, 2, 3, 4, 5, 6, 7]
array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
sorted_array = array.uniq.sort
tree = Tree.new(sorted_array)
p tree
puts '-----'
p tree.root
puts '----'
puts tree.root
# p sorted_array
# p build_tree(sorted_array)
# puts build_tree(sorted_array).data
# array = [1, 2, 3, 4, 5, 6, 7]
# tree = Tree.new(array, build_tree(array))
# p tree
# puts tree

# [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# [1, 3, 4, 5, 7, 8, 9, 23, 67, 324, 6345]
