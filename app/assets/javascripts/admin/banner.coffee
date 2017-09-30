$ ->
  if ($('#index_table_banners').length > 0)
    $('#index_table_banners tbody').sortable(
      update: (e, ui) ->
        itemId = ui.item.attr('id')
        prevId = ui.item.prev().attr('id')
        nextId = ui.item.next().attr('id')

        $.ajax
          url: "/admin/banners/#{itemId.substring(7)}/reposition"
          type: "POST"
          data:
            id      : itemId
            prev_id : prevId
            next_id : nextId
    );

  window.BannerEvent =
    bindFormEvents: ->
      @bindSuccessCallback();
      @SourceTypeSelect();

    SourceTypeSelect: ->
      $("select#banner_source_type").on "change", (e) ->
        switch this.value
          when 'video'
            $('div.races').hide();
            $('div.infos').hide();
            $('div.videos').show();
            $('#btn_search_videos').click();
            $('#input_search_videos').focus();
          when 'race'
            $('div.races').show();
            $('div.videos').hide();
            $('div.infos').hide();
            $('#btn_search_races').click();
            $('#input_search_races').focus();
          when 'info'
            $('div.infos').show();
            $('div.races').hide();
            $('div.videos').hide();
            $('#btn_search_infos').click();
            $('#input_search_infos').focus();
          else
            $('div.infos').hide();
            $('div.races').hide();
            $('div.videos').hide();

    bindSuccessCallback: ->
      that = @
      $('.search_races_form').on 'ajax:success', (e, data) ->
        $('.races tbody tr').remove();
        $(that.createRaces(data)).appendTo('.races tbody')
        that.sourceClick();

      $('.search_infos_form').on 'ajax:success', (e, data) ->
        $('.infos tbody tr').remove();
        $(that.createInfos(data)).appendTo('.infos tbody')
        that.sourceClick();

      $('.search_videos_form').on 'ajax:success', (e, data) ->
        $('.videos tbody tr').remove();
        $(that.createVideos(data)).appendTo('.videos tbody')
        that.sourceClick();

    sourceClick: ->
      $('.sources tbody tr').on 'click', (e) ->
        id = $(this).data('id')
        title = $(this).data('title')
        $('#banner_source_id').val(id)
        $('#banner_source_title').val(title)

    createRaces: (races) ->
      if races.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for race in races
        trs += "<tr data-id=#{race.id} data-title=#{race.name}>"
        trs += "<td>#{race.id}</td>"
        trs += "<td>#{race.name}</td>"
        trs += '/<tr>'
      trs

    createInfos: (infos) ->
      if infos.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for info in infos
        trs += "<tr data-id=#{info.id} data-title=#{info.title}>"
        trs += "<td>#{info.id}</td>"
        trs += "<td>#{info.title}</td>"
        trs += '/<tr>'
      trs

    createVideos: (vidoes) ->
      if vidoes.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for video in vidoes
        trs += "<tr data-id=#{video.id} data-title=#{video.name}>"
        trs += "<td>#{video.id}</td>"
        trs += "<td>#{video.name}</td>"
        trs += '/<tr>'
      trs