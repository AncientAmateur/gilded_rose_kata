class UpdateItem
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def call
    update
  end

  private
  def update
    item.quality += quality_modifier
    item.sell_in += sell_in_modifier

    item.quality = 50 if item.quality > 50
    item.quality = 0 if item.quality < 0
  end

  def quality_modifier
    return item.sell_in < 1 ? -2 : -1
  end

  def sell_in_modifier
    -1
  end
end

class UpdateAgedBrie < UpdateItem

  private
  def quality_modifier
    item.sell_in < 1 ? 2 : 1
  end
end

class UpdateLegendary < UpdateItem

  private
  def update
  end
end

class UpdateBackstagePasses < UpdateItem

  private
  def quality_modifier
    return -item.quality if item.sell_in < 1
    return 2 if (6..10).include? item.sell_in
    return 3 if (1..5).include? item.sell_in
    1
  end
end

class UpdateConjured < UpdateItem

  private
  def quality_modifier
    item.sell_in < 1 ? -4 : -2
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
