# WSDL4R - XMLSchema attribute definition for WSDL.
# Copyright (C) 2002, 2003  NAKAMURA, Hiroshi <nahi@ruby-lang.org>.

# This program is copyrighted free software by NAKAMURA, Hiroshi.  You can
# redistribute it and/or modify it under the same terms of Ruby's license;
# either the dual license version in 2003, or any later version.


require 'wsdl/info'


module WSDL
module XMLSchema


class Attribute < Info
  class << self
    def attr_reader_ref(symbol)
      name = symbol.to_s
      self.__send__(:define_method, name, proc {
        instance_variable_get("@#{name}") ||
          (refelement ? refelement.__send__(name) : nil)
      })
    end
  end

  attr_writer :use
  attr_writer :form
  attr_writer :name
  attr_writer :type
  attr_writer :default
  attr_writer :fixed

  attr_reader_ref :use
  attr_reader_ref :form
  attr_reader_ref :name
  attr_reader_ref :type
  attr_reader_ref :default
  attr_reader_ref :fixed

  attr_accessor :ref
  attr_accessor :arytype

  def initialize
    super
    @use = nil
    @form = nil
    @name = nil
    @type = nil
    @default = nil
    @fixed = nil
    @ref = nil
    @refelement = nil
    @arytype = nil
  end

  def refelement
    @refelement ||= root.collect_attributes[@ref]
  end

  def targetnamespace
    parent.targetnamespace
  end

  def parse_element(element)
    nil
  end

  def parse_attr(attr, value)
    case attr
    when RefAttrName
      @ref = value
    when UseAttrName
      @use = value.source
    when FormAttrName
      @form = value.source
    when NameAttrName
      @name = XSD::QName.new(targetnamespace, value.source)
    when TypeAttrName
      @type = value
    when DefaultAttrName
      @default = value.source
    when FixedAttrName
      @fixed = value.source
    when ArrayTypeAttrName
      @arytype = if value.namespace.nil?
          XSD::QName.new(XSD::Namespace, value.source)
        else
          value
        end
    else
      nil
    end
  end
end


end
end
