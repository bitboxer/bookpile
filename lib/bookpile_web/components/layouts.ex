defmodule BookpileWeb.Layouts do
  use BookpileWeb, :html

  embed_templates "../templates/layout/*"

  attr :rest, :global
  def site_footer(assigns) do
    ~H"""
    <footer class="landing-footer" {@rest}>
      <span>bookpile.org · A small open project</span>
      <span class="footer-tagline">An ISBN is the only thing we ask for.</span>
    </footer>
    """
  end
end
