class ItemUpdater
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    item.quality += quality_modifier
    item.sell_in += sell_in_modifier

    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end

  private
  def quality_modifier
    item.sell_in < 1 ? -2 : -1
  end

  def sell_in_modifier
    -1
  end
end

class AgedBrieUpdater < ItemUpdater

  private
  def quality_modifier
    item.sell_in < 1 ? 2 : 1
  end
end

class LegendaryUpdater < ItemUpdater
  def update
  end
end

class BackstagePassUpdater < ItemUpdater

  private
  def quality_modifier
    return -item.quality if item.sell_in < 1
    return 2 if (6..10).include? item.sell_in
    return 3 if (1..5).include? item.sell_in
    1
  end
end

class ConjuredUpdater < ItemUpdater

  private
  def quality_modifier
    item.sell_in < 1 ? -4 : -2
  end
end

class UpdateItem
  def self.call(item)
    updater = case item.name
    when "Aged Brie"
      AgedBrieUpdater.new(item)
    when "Sulfuras, Hand of Ragnaros"
      LegendaryUpdater.new(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstagePassUpdater.new(item)
    when /^Conjured /
      ConjuredUpdater.new(item)
    else
      ItemUpdater.new(item)
    end

    updater.update
  end
end

def update_quality(items)
  items.each do |item|
    UpdateItem.(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
