module SwapsetsHelper
  def show_set(set)
    render :partial => (set.swap.deadline < Time.now) ? "poll" : "basic"
  end
end
