
  class Node
  	# since this is a tree and not a graph, i don't see the need for a
  	# parent link. after all, the bfs and dfs store the parent information
  	# in the stack and queue, respectively.
  	# i suppose the parent could be usefull in order to create a to_s function
  	# for easier debugging.
    attr_accessor :value, :parent, :left_child, :right_child

    def initialize(args = {})
      @parent = args.fetch(:parent, nil)
    end

    def to_s
	  str = ""
	  str += "< Node: #{value} "
	  str += parent.nil? ? "parent: Nil " : "parent: #{parent.value} "
	  str += left_child.nil? ? "left_child: Nil " : "left_child: #{left_child.value} "
	  str += right_child.nil? ? "right_child: Nil >\n" : "right_child: #{right_child.value} >\n"
	  str
    end
  end

  def build_tree(ary, args = {})
    random_draw = args.fetch(:random_draw, false)
    puts "random_draw = #{random_draw}"
    length = ary.length
    tree = Node.new
    while !ary.empty?

      if (random_draw)
        #position = rand(length)
        #puts "random location = #{position}, length = #{length}"
        new_value = ary.delete_at(rand(length))
        length -= 1 # calling ary.length repeatedly seems poor style
      else
        new_value = ary.shift
      end
      puts "New entry = #{new_value}"
      current = tree      
      found = false
      while !found

        if current.value == nil
          current.value = new_value
          found = true          
        elsif new_value <= current.value
          # check left subtree if it exists
          current.left_child = Node.new(:parent => current) if current.left_child == nil
          current = current.left_child
        else
          # check right subtree if it exists
          current.right_child = Node.new(:parent => current) if current.right_child == nil
          current = current.right_child
        end # if current.value
      end # while !found

    end # while !ary.empty?
    tree
  end # def build_tree

  #print build_tree([1, 2]).inspect #, 2, 3, 4, 5, 6, 7, 8])
  print build_tree([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324],:random_draw => true).inspect

