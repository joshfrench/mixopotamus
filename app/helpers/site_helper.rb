module SiteHelper
  def get_trivia
    @sent = Confirmation.count
    @members = User.count
    @swaps = Swap.count
  end
end
