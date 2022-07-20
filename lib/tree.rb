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
