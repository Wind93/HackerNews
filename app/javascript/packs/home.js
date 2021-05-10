window.Home = {
  init() {
    this.redirectToDetailItem()
  },

  redirectToDetailItem() {
    $('body').on('click', '.link-item',function(event){
      const href = $(event.target).data('href');
      const title = $(event.target).data('title')
      $.ajax({
        url: '/detail',
        type: 'GET',
        dataType: 'script',
        data: {
          href: encodeURI(href),
          title: title
        },
      })
    })
  }
}