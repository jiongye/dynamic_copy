require 'spec_helper'

describe DynamicCopy do

  before do
    DynamicCopy.database.flushdb
    I18n.backend.store_translations('en', {:a => {:b => {:c => 'good'}}})
    I18n.backend.store_translations('en', {:d => {:e => {:f => ''}}})
    DynamicCopy.add_locale('cn')
    I18n.backend.store_translations('cn', {:d => {:e => {:f => 'very good'}}})
  end

  describe "DynamicCopy::I18nBackend#store_translations" do
    it "should not store key with empty value" do
      DynamicCopy.database.keys.should_not include('en.d.e.f')
    end
  end

  describe "self.available_deepest_keys(locale)" do
    before do
      @keys = DynamicCopy.available_deepest_keys('en')
    end

    it "should return the deepest 2 keys only" do
      @keys.size.should == 1
    end

    it "should include the key 'a.b.c'" do
      @keys.should include('a.b.c')
    end
  end

  describe "self.available_keys" do
    before do
      I18n.backend.store_translations('cn', {:d => {:e => {:g => 'good'}}})
      @keys = DynamicCopy.available_keys
    end

    it "should return 3 keys" do
      @keys.size.should == 3
    end

    it "should include the key 'd.e.g'" do
      @keys.should include('d.e.g')
    end

    it "should return the uniq keys" do
      I18n.backend.store_translations('en', {:d => {:e => {:g => 'not good'}}})
      @keys.size.should == 3
    end
  end

  describe "self.locale_value(locale, key)" do
    it "should return the correct locale value" do
      DynamicCopy.locale_value('cn', 'd.e.f').should == 'very good'
    end
  end

  describe "self.convert_to_hash(key, value)" do
    it "should return hash" do
      DynamicCopy.convert_to_hash('key', 'value').should == {'key' => 'value'}
    end

    it "shold return a hash given key and value" do
      DynamicCopy.convert_to_hash('a.b.c', 'good').should == {'a' => {'b' => {'c' => 'good'}}}
    end
  end

  describe "self.locales and self.add_locale(locale)" do
    before do
      DynamicCopy.clear_db!
    end

    it "should return 'en', the default locale if there is no locale keys available" do
      DynamicCopy.locales.should == ['en']
    end

    it "should return more locales when we add new one" do
      DynamicCopy.add_locale('cn')
      DynamicCopy.locales.should == ['en', 'cn']
    end

    it "should not add an exist locale" do
      DynamicCopy.add_locale('en')
      DynamicCopy.locales.should == ['en']
    end
  end

  describe "self.delete_locale(locale)" do
    before do
      DynamicCopy.delete_locale('cn')
    end

    it "should remove the locale from the available_locales key" do
      DynamicCopy.locales.should_not include('cn')
    end

    it "should remove the locale from the locale_names key" do
      DynamicCopy.locale_names.keys.should_not include('cn')
    end

    it "should also remove all translations with that locale" do
      DynamicCopy.database.keys('cn.*').should be_empty
    end
  end

end