class UpdateItem
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def call
    item.quality += quality_modifier
    item.sell_in += sell_in_modifier
  end

  private
  def quality_modifier
    return 0 if item.quality < 1
    return -2 if item.sell_in < 1
    -1
  end

  def sell_in_modifier
    -1
  end
end

class UpdateAgedBrie < UpdateItem

  private
  def quality_modifier
    return 0 if item.quality >= 50
    return 2 if item.sell_in < 1 && item.quality < 49
    1
  end
end

class UpdateLegendary < UpdateItem

  private
  def quality_modifier
    0
  end

  def sell_in_modifier
    0
  end
end

class UpdateBackstagePasses < UpdateItem

  private
  def quality_modifier
    return -item.quality if item.sell_in < 1
    return 0 if item.quality >= 50
    return 2 if (6..10).include? item.sell_in
    return 3 if (1..5).include? item.sell_in
    1
  end
end

class UpdateConjured < UpdateItem

  private
  def quality_modifier
    return 0 if item.quality < 1
    return -4 if item.sell_in < 1
    -2
  end
end

class ItemUpdater
  def self.call(item)
    updater = case item.name
    when "Aged Brie"
      UpdateAgedBrie.new(item)
    when "Sulfuras, Hand of Ragnaros"
      UpdateLegendary.new(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      UpdateBackstagePasses.new(item)
    when /Conjured/
      UpdateConjured.new(item)
    else
      UpdateItem.new(item)
    end

    updater.call
  end
end

def update_quality(items)
  items.each do |item|
    ItemUpdater.call(item)
  end
end

######### DO NOT CHANGE BELOW #########

Item = Struct.new(:name, :sell_in, :quality)
