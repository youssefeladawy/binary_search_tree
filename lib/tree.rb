require_relative 'node'
require 'pry-byebug'

class Tree
  attr_accessor :array, :root

  def initialize(array)
    @array = array.uniq.sort
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

  def find(value, current_root = @root)
    return false if current_root.nil?

    if current_root.data == value
      return current_root
    end

    value < current_root.data ? find(value, current_root.left) : find(value, current_root.right)

    # if value < current_root.data
    #   return find(value, current_root.left)
    # else
    #   return find(value, current_root.right)
    # end

    # until current_root.nil?
    #   if value == current_root.data
    #     print 'found node is: '
    #     p current_root
    #     return current_root
    #   elsif value < current_root.data
    #     current_root = current_root.left
    #   else
    #     current_root = current_root.right
    #   end
    # end
    # "#{value} not found"
  end

  def insert(value, current_root = @root)
    return "#{value} already exists" if current_root.data == value

    if value < current_root.data
      current_root.left.nil? ? current_root.left = Node.new(value) : insert(value, current_root.left)
    else
      current_root.right.nil? ? current_root.right = Node.new(value) : insert(value, current_root.right)
    end
  end

  def parent_of(value, root = @root)
    return root if root.left.data == value unless root.left.nil?
    return root if root.right.data == value unless root.right.nil?

    value < root.data ? parent_of(value, root.left) : parent_of(value, root.right)

    # until root.nil?
    #   if value < root.data
    #     if root.left.data == value
    #       return root
    #     else
    #       root = root.left
    #     end
    #   else # value > node.data
    #     if root.right.data == value
    #       return root
    #     else
    #       root = root.right
    #     end
    #   end
    # end
  end

  def next_biggest(node)
    current_node = node
    current_node = current_node.left until current_node.left.nil?
    return current_node
  end

  def delete(value)
    node = find(value)
    parent_node = parent_of(value)
    if node.left.nil? && node.right.nil? # if node has no children delete it
      value < parent_node.data ? parent_node.left = nil : parent_node.right = nil
    elsif node.left.nil? || node.right.nil? # if node has one child just point the parent node to the grandchild
      value < parent_node.data ? parent_node.left = node.left || node.right : parent_node.right = node.left || node.right
    else
      next_biggest = next_biggest(node.right)
      delete(next_biggest.data)
      node.data = next_biggest.data

      # node_right = node.right
      # node_left = node_right.left
      # until node_left.left.nil?
      #   node_left = node_right.left
      # end
      # node.data = node_left.data
    end
  end

  # def level_order
  #   # return unless block_given?
  #   queue = []
  #   current_node = @root
  #   queue.push(current_node)
  #   until current_node.nil?
  #     # puts queue.each { |element| print "#{element.data}, "}
  #     queue.shift
  #     queue.push(current_node.left) unless current_node.left.nil?
  #     queue.push(current_node.right) unless current_node.right.nil?
  #     current_node = queue[0]
  #   end
  # end

  def level_order
    current_node = @root
    queue = [current_node]
    array = []
    until current_node.nil?
      block_given? ? yield(current_node) : array.push(current_node.data)
      queue.shift
      queue.push(current_node.left) unless current_node.left.nil?
      queue.push(current_node.right) unless current_node.right.nil?
      current_node = queue[0]
    end
    return array unless block_given?
  end

  def level_order_rec(queue = [], current_node = @root, container = [], &block)
    queue.push(current_node) unless queue.include?(current_node)
    block_given? ? block.call(current_node) : container.push(current_node.data)
    queue.shift
    queue.push(current_node.left) unless current_node.left.nil?
    queue.push(current_node.right) unless current_node.right.nil?
    return if queue.empty?

    level_order_rec(queue, queue[0], container, &block)
    return container unless block_given?
  end

  def preorder(current_root = @root, container = [], &block)
    return if current_root.nil?

    block_given? ? block.call(current_root) : container.push(current_root.data)
    preorder(current_root.left, container, &block)
    preorder(current_root.right, container, &block)

    return container unless block_given?
  end

  def inorder(current_root = @root, container = [], &block)
    return if current_root.nil?

    inorder(current_root.left, container, &block)
    block_given? ? block.call(current_root) : container.push(current_root.data)
    inorder(current_root.right, container, &block)

    return container unless block_given?
  end

  def postorder(current_root = @root, container = [], &block)
    return if current_root.nil?

    postorder(current_root.left, container, &block)
    postorder(current_root.right, container, &block)
    block_given? ? block.call(current_root) : container.push(current_root.data)

    return container unless block_given?
  end

  def height(current_node = @root)
    return -1 if current_node.nil?

    current_node = find(current_node) if current_node.is_a?(Integer)
    left_height = height(current_node.left)
    right_height = height(current_node.right)

    [left_height, right_height].max + 1
  end

  def depth(node = @root)
    node = find(node)
    return 'The node provided is not part of the tree' if node == false
    return 0 if node == @root

    counter = 1
    parent = parent_of(node.data)
    until parent == @root
      counter += 1
      parent = parent_of(parent.data)
    end
    counter
  end

  def balanced?
    left_height = height(@root.left)
    right_height = height(@root.right)

    (left_height - right_height).between?(-1, 1)
  end

  def rebalance
    return 'tree is already balanced' if balanced?

    # new_tree_array = []
    # self.level_order { |node| new_tree_array << node.data }
    @root = build_tree(level_order)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# tree = Tree.new(array)
# tree.pretty_print
# p tree.root
# p '-------------------------'
# puts tree.find(9)
# p '-------------------------'
# puts tree.find(6345)
# p '-------------------------'
# puts tree.find(6346)
# p '-------------------------'
# puts tree.find(63438)
# p '-------------------------'
# p tree.insert(9)
# p '-------------------------'
# p tree.insert(6)
# p '-------------------------'
# p tree.root
# p '--------------------------'

# puts tree.parent_of(1).data
# puts tree.parent_of(7).data
# puts tree.parent_of(5).data
# puts tree.parent_of(23).data
# puts tree.parent_of(6345).data
# puts tree.parent_of(324).data

# p tree.root
# p '--------------------------'
# tree.delete(4)
# p '--------------------------'
# p tree.root
# p '--------------------------'
# puts tree.parent_of(7).data
# p '--------------------------'
# tree.delete(7)
# p '--------------------------'
# p tree.root
# p '--------------------------'
# puts tree.parent_of(1).data
# p '--------------------------'
# tree.delete(1)
# p '--------------------------'
# p tree.root

# p tree.level_order
# p '--------------------------'
# puts tree.level_order {|node| print "#{node.data}, "}
# p '--------------------------'
# p tree.level_order_rec
# p '--------------------------'
# puts tree.level_order_rec {|node| print "#{node.data}, "}
# p tree.preorder
# puts tree.preorder {|node| print "#{node.data}, "}
# p tree.inorder
# puts tree.inorder {|node| print "#{node.data}, "}
# p tree.postorder
# puts tree.postorder {|node| print "#{node.data}, "}

# puts tree.height(4)
# puts tree.depth(8)
# puts tree.depth(67)
# puts tree.depth(3)
# puts tree.depth(1)
# puts tree.depth(2)
# puts tree.balanced?
# puts tree.rebalance
