if (! instapaper_did_load) {
    var instapaper_did_load = true;
    var instapaper_embeds = [];
    var instapaper_did_init = false;
    var instapaper_vertical_offset = -2;
}

function instapaper_iframe(id, url, title, description)
{
    var i = document.createElement('iframe');
    i.setAttribute('src', 
        'http://www.instapaper.com/e?url=' + encodeURIComponent(url) + 
        '&title=' + encodeURIComponent(title) +
        '&description=' + encodeURIComponent(description)
    );
    i.setAttribute('border', '0');
    i.setAttribute('scrolling', 'no');
    i.setAttribute('width', '75');
    i.setAttribute('height', '16');
    i.setAttribute('allowTransparency', 'true');
    i.setAttribute('frameborder', '0');
    i.setAttribute('class', 'instapaper_iframe');
    i.setAttribute('id', id);
    i.setAttribute('style', 'margin-bottom: ' + instapaper_vertical_offset + 'px; z-index: 1338; border: 0px; background-color: transparent; overflow: hidden;');
    return i;
}

function instapaper_register()
{
    var oldonload = window.onload;
    if (typeof window.onload != 'function') {
        window.onload = instapaper_init;
    } else {
        window.onload = function() {
            if (oldonload) oldonload();
            instapaper_init();
        }
    }    
}

function instapaper_init()
{
    if (instapaper_did_init) return;
    instapaper_did_init = true;
    var el;
    for (var i = 0; i < instapaper_embeds.length; i++) {
        el = document.getElementById(instapaper_embeds[i][0]);
        el.parentNode.replaceChild(
            instapaper_iframe(
                instapaper_embeds[i][0], 
                instapaper_embeds[i][1], 
                instapaper_embeds[i][2],
                instapaper_embeds[i][3]
            ),
            el
        );
    }
}

function instapaper_embed(url, title, description)
{
    if (instapaper_embeds.length == 0) instapaper_register();

    if (! url) url = document.location.href;
    if (! title) title = document.title;
    if (! description) description = '';

    var id = 'instapaper_embed' + instapaper_embeds.length;
    instapaper_embeds[instapaper_embeds.length] = [id, url, title, description];
    document.write('<li id="' + id + '">&nbsp;</li>');
}


