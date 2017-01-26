module Door
  def open?
    @open
  end

  def open
    puts 'OPENING DOOR'
    @open = true
  end

  def close
    puts 'CLOSING DOOR'
    @open = false
  end
end
