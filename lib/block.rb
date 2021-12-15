# impor to handle any plural/singular conversions
require 'active_support/core_ext/string'




class Block
  include Enumerable

  BOOLEAN_METHODS = %i[is_a is_not_a]
  PROP_METHODS = %i[is_the being_the and_the]
  ARRAY_METHONS = [:has]
  METHOD_METHODS = [:can]

  ALL_METHODS = BOOLEAN_METHODS + PROP_METHODS + ARRAY_METHONS + METHOD_METHODS

  def initialize(name)
    @name = name
    @current_stack = []
    @props = {}
    set_prop(name.to_sym, true)
    @last_object = self
    @idx = 0
  end

  def query_properties(method)
    key = method.to_s.sub('?', '').to_sym
    @props.key?(key) ? @props[key] : false
  end

  def get_binding
    binding
  end

  def each(&block)
    if @idx == @last_object.length
      @idx = 1
      nil
    else
      element = @last_object[@idx]
      b = element.get_binding
      yield element.instance_eval(&block)
    end
  end

  def set_prop(prop, value)
    @props.store(prop.to_sym, value)
    @props[prop]
  end

  def run_builtin(method)
    attribute_name = method.to_s[0..-1].to_sym
    single_attribute_name = attribute_name.to_s.singularize
    method = @current_stack.last.first

    if @current_stack.last.first == :being_the
      @current_stack << [:awaiting_value, attribute_name.to_sym]
      return self
    end

    return set_prop(attribute_name, true) if method == :is_a

    return set_prop(attribute_name, false) if method == :is_not_a

    if method == :has
      num = @current_stack.last.last

      if num == 1
        set_prop(single_attribute_name.to_sym, Block.new(single_attribute_name))

      else
        blocks = []
        num.times do
          thisblock = Block.new(single_attribute_name)
          blocks << thisblock
        end
        set_prop(attribute_name, blocks)

      end

    end # :has
  end

  def method_missing(method, *_args)
    if method.to_s.end_with?('?')
      query_properties(method)
    elsif @props.key?(method.to_sym)
      query_properties(method.to_sym)

    elsif method.to_s.end_with?('_of')
      something_of(method)
    elsif !@current_stack.empty? && ALL_METHODS.include?(@current_stack.last.first)
      run_builtin(method)
    else
      run_non_builtin(method)
    end
  end

  def run_non_builtin(method)
    last_method_called  = @current_stack.last.first
    last_argument       = @current_stack.last.last
    if last_method_called == :something_of
      relation = last_argument
      set_prop(relation.to_sym, method.to_s)
    end

    if last_method_called == :awaiting_value
      @current_stack << [:setting_value, method]
      set_proc(last_argument, method)
      self
    end
  end

  def being_the
    @current_stack << [:being_the, '']
    self
  end

  def something_of(method)
    @current_stack << [:something_of, method]
    self
  end

  def is_a
    @current_stack << [:is_a]
    self
  end

  def is_not_a
    @current_stack << [:is_not_a]
    self
  end

  def is_the
    @current_stack << [:is_the]
    self
  end

  def has(num)
    @current_stack << [:has, num]
    self
  end

  def having(num)
    has(num)
  end

  def can
    @current_stack << [:can]
    self
  end

  def to_s
    "<name: #{name} #{self.class} #{@b} >"
  end

  attr_reader :name

  # TODO: make the magic happen
end
