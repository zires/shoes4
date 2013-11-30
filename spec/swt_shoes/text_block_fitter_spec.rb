require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_fitter'

describe Shoes::Swt::TextBlockFitter do
  let(:parent_dsl) { double(width: 100, height: 200) }

  let(:dsl)        { double(parent: parent_dsl) }
  let(:text_block) { double(dsl: dsl) }

  subject { Shoes::Swt::TextBlockFitter.new(text_block) }

  before(:each) do
    with_siblings(dsl)
    text_block.stub(:generate_layout)
  end

  describe "determining space from siblings" do
    describe "when all alone" do
      it "should be the parent's width" do
        subject.available_space.should == [100, 200]
      end
    end

    describe "when second sibling" do
      it "should be width from end of sibling" do
        with_siblings(double(width: 50, height: 20), dsl)
        subject.available_space.should == [50, 20]
      end
    end

    pending "when siblings are on different lines" do
      describe "should handle that correctly" do
        # TODO
      end
    end
  end

  describe "layout generation" do
    it "should be delegated to the text block" do
      expect(text_block).to receive(:generate_layout).with(100)
      subject.generate_layout(text_block, 100)
    end
  end

  describe "fit it in" do
    let(:bounds) { double(width: 100, height: 50)}
    let(:layout) { double(get_bounds: bounds) }

    before(:each) do
      text_block.stub(:generate_layout) { layout }
    end

    it "should return first layout if it fits" do
      expect(subject.fit_it_in).to eq(layout)
    end

    it "should not fit in first layout" do
      bounds.stub(width: 50)
      with_siblings(double(width:50, height: 20), dsl)

      expect(subject.fit_it_in).to eq(nil)
    end
  end

  def with_siblings(*args)
    parent_dsl.stub(:contents) { args }
  end
end