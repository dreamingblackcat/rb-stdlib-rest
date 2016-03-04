class DB
  def initialize(table_name, store)
    @store             = store
    @table_name        = table_name
    @store.transaction do
      @_id  = store[:_id] ||= 0
      @store[@table_name] ||= Hash.new
    end    
  end

  def << item
    @_id += 1
    item.id = @_id
    @store.transaction do
      @store[@table_name][@_id.to_s] = item 
    end
    item
  end

  def all
    items = []
    @store.transaction do
      @store[@table_name].each do|key, value|
        items << value
      end
    end
    items
  end

  def [] id
    item = nil
    @store.transaction do
      item = @store[@table_name][id.to_s]
    end
    item
  end

  def update id, update_params
    item = nil
    @store.transaction do
      item = @store[@table_name][id.to_s]
      @store.abort unless item
      update_params.each do|key, value|
        item[key] = value
      end
      @store[@table_name][id.to_s] = item
    end
    item
  end

  def delete id
    @store.transaction do
      table = @store[@table_name]
      table.delete(id.to_s)
      @store[@table_name] = table
    end
  end
  
end