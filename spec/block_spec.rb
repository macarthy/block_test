require 'spec_helper'
require_relative '../lib/block'



describe Block do
  subject { Block.new('sandi') }
  describe 'sandi = Block.new("sandi")' do
    describe '#name' do
      it 'name should be sandi ' do
        expect(subject.name).to eq 'sandi'
      end
    end
  end

  describe '#is_a' do
    describe 'is_a.woman (dynamic key)' do
      before { subject.is_a.woman }

      it 'sandi.woman? should return true' do
        expect(subject.woman?).to be true
      end
    end
  end

  describe '#is_not_a' do
    describe 'is_not_a.man (dynamic key)' do
      before { subject.is_not_a.man }
      it 'sandi.man? should return false' do
        expect(subject.man?).to be false
      end
    end
  end
  describe '#has' do
    describe 'sandi.has(2).arms' do
      before do
        @sandi = Block.new('Sandi')
        @sandi.has(2).arms
      end

      it 'should define an arms method that is an array' do
        expect(@sandi.arms).to be_an_instance_of(Array)
      end

      it 'should populate 2 new Block instances within the array' do
        expect(@sandi.arms.size).to eq 2
        expect(@sandi.arms.all? { |o| o.instance_of?(Block) }).to be true
      end

      it 'should call each thing by its singular form (aka "arm")' do
        expect(@sandi.arms.first.name).to eq('arm')
      end

      it 'should have arm? == true  each arm instance' do
        expect(@sandi.arms.first.arm?).to eq true
      end
    end
  end

  describe 'jane.having(2).arms (alias)' do
    it 'should populate 2 new block instances within the array' do
      @sandi = Block.new('sandi')
      @sandi.having(2).arms

      expect(@sandi.arms.size).to eq(2)
      expect(@sandi.arms.all? { |o| o.instance_of?(Block) }).to be true
    end
  end

  describe 'sandi.has(1).head' do
    before do
      @sandi = Block.new('Sandi')
      @sandi.has(1).head
    end

    it 'should name the head block "head"' do
      expect(@sandi.head.name).to eq('head')
    end

    it 'should define head method that is a reference to a new Block' do
      expect(@sandi.head).to be_an_instance_of(Block)
    end
  end

  describe 'Sandi.has(1).head.having(2).eyes' do
    before do
      @sandi = Block.new('Sandi')
      @sandi.has(1).head.having(2).eyes
    end

    it 'should create 2 new Blocks on the head' do
      expect(@sandi.head.eyes.size).to eq 2
      expect(@sandi.head.eyes.first).to be_an_instance_of(Block)
    end

    it 'should name the eye Blocks "eye"' do
      expect(@sandi.head.eyes.first.name).to eq('eye')
    end
  end

  describe '#each' do
    describe 'Sandi.has(2).arms.each { having(5).fingers }' do
      before do
        @sandi = Block.new('Sandi')
        @sandi.has(2).arms.each { |arm| arm.having(5).fingers }
      end

      it 'should cause 2 arms to be created each with 5 fingers' do
        expect(@sandi.arms.first.fingers.size).to eq 5
        expect(@sandi.arms.last.fingers.size).to eq 5
      end
    end
  end

  describe '#is_the' do
    describe 'Sandi.is_the.parent_of.joe' do
      before do
        @sandi = Block.new('Sandi')
        @sandi.is_the.parent_of.joe
      end

      it 'should set Sandi.parent_of == "joe"' do
        expect(@sandi.parent_of).to  eq('joe')
      end
    end

    describe 'ensure dynamic usages' do
      before do
        @sandi = Block.new('Sandi')
      end

      it 'should set any name and value (Sandi.is_the.???.????)' do
        @sandi.is_the.mother_of.jim
        expect(@sandi.mother_of).to eq('jim')

        @sandi.is_the.master_of.judo
        expect(@sandi.master_of).to eq('judo')
      end
    end
  end


end
