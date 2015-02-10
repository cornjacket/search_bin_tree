
  class Node
  	# i don't see the need for a parent link. the bfs and dfs store the parent
    # info in the stack and queue, respectively.
  	# i suppose the parent could be usefull in order to create a to_s function
  	# for easier debugging.
    # note that the visited field is not strictly necessary. it was included
    # due to my first implementation for depth_first_search which used
    # an implementation based on a graph data structure which could have
    # loops, making it necessary to keep track of redundant node pushes.
    attr_accessor :value, :visited, :parent, :left_child, :right_child

    def initialize(args = {})
      @parent = args.fetch(:parent, nil)
      @visited = false
    end

    def to_s
	  str = ""
	  str += "< Node: #{value} "
	  str += parent.nil? ? "parent: Nil " : "parent: #{parent.value} "
	  str += left_child.nil? ? "left_child: Nil " : "left_child: #{left_child.value} "
	  str += right_child.nil? ? "right_child: Nil >\n" : "right_child: #{right_child.value} >\n"
	  str
    end

  end # class Node

  def build_tree(ary, args = {})
    random_draw = args.fetch(:random_draw, false)
    verbose = args.fetch(:verbose, false)
    length = ary.length
    tree = Node.new
    while !ary.empty?

      if (random_draw)
        new_value = ary.delete_at(rand(length))
        length -= 1 # calling ary.length repeatedly seems poor style
      else
        new_value = ary.shift
      end
      current = tree      
      found = false
      puts "Inserting #{new_value}"
      puts current if verbose
      while !found
        if current.value == nil
          current.value = new_value
          found = true          
        elsif new_value <= current.value
          # check left subtree if it exists
          current.left_child = Node.new(:parent => current) if !current.left_child
          current = current.left_child
        else
          # check right subtree if it exists
          current.right_child = Node.new(:parent => current) if !current.right_child
          current = current.right_child
        end # if current.value
        puts current if verbose
      end # while !found
    end # while !ary.empty?
    tree
  end # def build_tree

  def breadth_first_search(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil
    next_node = [tree]
    while !next_node.empty?
      current = next_node.shift # dequeue
      if verbose
        puts "current = #{current}"
        puts "head = #{next_node[0]}"
      end
      return current if current.value == value      
      next_node.push current.left_child if current.left_child
      next_node.push current.right_child if current.right_child
    end
    nil
  end

# this was my first implementation which after review appears very
# suboptimal. This is because it uses a visited field for the Node 
# object. The visited field makes sense for a graph data structure per
# the video that was assigned but is not necessary for a bst since
# the stack inherently provides this mechanism.
  def depth_first_search(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil
    done = false
    current = tree
    next_node = []
    while !done
      next_node.push(current) unless current.visited
      current.visited = true
      if verbose
        puts "current = #{current}"
        puts "top_of_the_stack = #{next_node[-1]}"
      end
      if current.value == value
        return current
      elsif (current.left_child && !current.left_child.visited) # has a left child
        current = current.left_child
      elsif (current.right_child && !current.right_child.visited)
        current = current.right_child
      else
        current = next_node.pop
        done = current.nil?
      end
    end # while !done
    nil
  end

# TODO - since depth_first and breadth_first look so alike now, i think
# they should be merged into a common search function where I pass
# in the pop or shift
  def depth_first_search2(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil
    next_node = [tree]
    while !next_node.empty?
      current = next_node.pop
      if verbose
        puts "current = #{current}"
        puts "head = #{next_node[0]}"
      end
      return current if current.value == value      
      next_node.push current.left_child if current.left_child
      next_node.push current.right_child if current.right_child
    end
    nil
  end

  def dfs_rec(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil
    return tree if tree.value == value
    puts "current = #{tree}" if verbose
    left = dfs_rec(tree.left_child, value, args)
    return left if left != nil
    right = dfs_rec(tree.right_child, value, args)
    return right # if right != nil
  end

  #print build_tree([1, 2]).inspect #, 2, 3, 4, 5, 6, 7, 8])
  ary = [23, 7, 8, 4, 3, 5, 9, 67, 6345, 324]
  tree = build_tree(ary, :verbose => true ) #, :random_draw => true)
  
  puts "Build tree completed."
  #print breadth_first_search(tree, 324, :verbose => true)
  #print depth_first_search(tree, 324, :verbose => true)
 
  puts "First"
  print depth_first_search(tree, 4, :verbose => true)
  puts "Second"
  print depth_first_search2(tree, 4, :verbose => true)
  puts "Recursive"
  print dfs_rec(tree, 323, :verbose => true).inspect

