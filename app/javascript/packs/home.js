window.Home = {
  init() {
    this.redirectToDetailItem();
    this.handleLoadMore();
  },

  redirectToDetailItem() {
     var load = function (href, title) {
      $.ajax({
        url: '/detail',
        type: 'GET',
        dataType: 'script',
        data: {
          href: encodeURI(href),
          title: title
        },
        success: function(){
          history.pushState(null, title, '/detail');
        }
      });
    };
    $('body').on('click', '.link-item',function(event){
      const href = $(event.target).data('href');
      const title = $(event.target).data('title');
      load(href, title);
    });
  },

  handleLoadMore() {
    $(".btn-load-more").on("click", function(data) {
      $('.link-to-load').toggleClass('d-none')
      $('.spinner-border').toggleClass('d-none')
    })
  }
}