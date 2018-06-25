# Rubys object model is presented as a diagram in the readme file

# some interesting tidbits about ruby classes and runtime

puts self # => main 
class SelfTest
  puts self # => SelfTest
end
# when not in a class self is acutally attached to a main class thats created on 
# the fly by the ruby interpreter

class Thing
  def bar
    "foo"
  end

  def what_is_self
    self
  end
end

class SpecificThing < Thing; end

a = SpecificThing.new
puts a.bar

# a is the receiver and the bar is a method thats in the ancestral chain of a
puts a.class.ancestors # [SpecificThing, Thing, Object, Kernel, BasicObject]
# interpreter finds the method in Thing and executes it

puts a.what_is_self # #<SpecificThing:0x0.....>
# here the self is actually the object the method is called with AKA the receiver
# which is a and a is an instance of SpecificThing


# instance variables live on instance objects and instance methods live on Classes of which the object belongs to

module Mod1 ; end
module Mod2 ; end

class SuperSpecialThing < SpecificThing
  include Mod1
  prepend Mod2
end

SuperSpecialThing.ancestors # [Mod2, SuperSpecialThing, Mod1, SpecificThing, Thing, Object, Kernel, BasicObject]

# opening up classes and mokey patching things are often bad
# therefore Ruby2.0 + has refinements

module StringRefine
  refine String do
    def reverse
      "yeah...no"
    end
  end
end


puts "Taco".reverse # normal reverse - ocaT

# but we can temporarily patch reverse by Using StringRefine and this refinement exists only for the duration 
# of the existence of the then current self - main in this case (or the complete execution of this file).

using StringRefine

puts "Taco".reverse

class Tesst
  # if the using using StringRefine were here 
  # the next line would print "yeah...no" and line the line after this ckass ends would be normal reverse
  puts "nope".reverse
end
puts "tacocat".reverse