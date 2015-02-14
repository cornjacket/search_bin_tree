  class Node
    # parent is useful for backtracing up to root
    # note that the visited field is useful for graphs where loops
    # need to be identified.
    attr_accessor :value, :visited, :parent, :children

    def initialize(args = {})
      @parent = args.fetch(:parent, nil)
      @visited = false
      @children = []
    end


    def to_s
	  str = ""
	  str += "< Node: #{value} "
	  str += parent.nil? ? "parent: Nil " : "parent: #{parent.value} "
    children_str = ""
    children_str += "Children : "
    children.each_with_index do |child, i| 
      child_value = (child.nil?) ? "Nil" : child.value
      children_str << " Child #{i} = #{child_value}\n" 
    end
    children_str += ">\n"
	  str += children.empty? ? "No children >\n\n" : children_str
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
          current.children[0] = Node.new(:parent => current) if !current.children[0]
          current = current.children[0]
        else
          # check right subtree if it exists
          current.children[1] = Node.new(:parent => current) if !current.children[1]
          current = current.children[1]
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
      # visited not strictly necessary for future proofs it
      if current.visited == false
        return current if current.value == value
        current.children.each { |child| next_node.push child if child } 
      end
    end
    nil
  end

# TODO - since depth_first and breadth_first look so alike now, i think
# they should be merged into a common search function where I pass
# in the pop or shift
  def depth_first_search(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil
    next_node = [tree]
    while !next_node.empty?
      current = next_node.pop
      if verbose
        puts "current = #{current}"
        puts "head = #{next_node[0]}"
      end
      # visited not strictly necessary for future proofs it      
      if current.visited == false
        current.visited = true
        return current if current.value == value
        current.children.each { |child| next_node.push child if child } 
      end
    end
    nil
  end

#=begin THIS REALLY SHOULDN'T BE IN THE BASE CLASS. IN DERIVED CLASS
  def dfs_rec(tree, value, args = {})
    verbose = args.fetch(:verbose, false)
    return nil if tree == nil 
    return nil if tree.visited == true
    tree.visited = true
    return tree if tree.value == value
    puts "current = #{tree}" if verbose
    left = dfs_rec(tree.children[0], value, args)
    return left if left != nil
    right = dfs_rec(tree.children[1], value, args)
    return right # if right != nil
  end
#=end

  ary = [23, 7, 8, 4, 3, 5, 9, 67, 6345, 324]
  #tree = build_tree(ary )#, :verbose => true ) #, :random_draw => true)
  #puts "Build tree completed."
  
  #puts "Breadth first search"
  #print breadth_first_search(tree, 324 )#, :verbose => true)
 

  ## NEED TO FULLY TRACE DEPTH
  #tree = build_tree(ary ) #, :verbose => true ) #, :random_draw => true)
  #puts "Depth first search"
  #print depth_first_search(tree, 4 )#, :verbose => true)
  
  puts "Recursive"
  tree = build_tree(ary ) #, :verbose => true ) #, :random_draw => true)  
  print dfs_rec(tree, 324 )#, :verbose => true).inspect

