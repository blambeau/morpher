# encoding: UTF-8

require 'morpher'
extend Morpher::NodeHelpers

class Address
  include Anima.new(:street)
end

class Person
  include Anima.new(:address)
end

node = s(:block,
  s(:guard, s(:primitive, Hash)),
  s(:hash_transform,
    s(:symbolize_key, 'street',
      s(:guard, s(:primitive, String))
    )
  ),
  s(:anima_load, Address)
)

ADDRESS_EVALUATOR = Morpher.evaluator(node)

node = s(:block,
  s(:guard, s(:primitive, Hash)),
  s(:hash_transform,
    s(:symbolize_key, 'address',
      ADDRESS_EVALUATOR.node
    )
  ),
  s(:anima_load, Person)
)

PERSON_EVALUATOR = Morpher.evaluator(node)
