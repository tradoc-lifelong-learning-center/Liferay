<#--
Application display templates can be used to modify the look of a
specific application.

Please use the left panel to quickly add commonly used variables.
Autocomplete is also available and can be invoked by typing "${".
-->


<style>

table.podcasts {
  font-family: "Open Sans", sans-serif;
  line-height: 1.25;
}

table.podcasts {
  border: 1px solid #ccc;
  border-collapse: collapse;
  margin: 0;
  padding: 0;
  width: 100%;
  /*table-layout: fixed;*/
}

table.podcasts caption {
  font-size: 1.5em;
  margin: .5em 0 .75em;
}

table.podcasts tr {
  /*background-color: #f8f8f8;*/
  border: 1px solid #ddd;
  padding: .35em;
}

table.podcasts th,
table.podcasts td {
  padding: .625em;
  text-align: center;
}

table.podcasts th {
  font-size: .85em;
  letter-spacing: .1em;
  text-transform: uppercase;
}

.podcasts__stream-container{
  /*min-width:300px;*/
}

.podcast__desc-title{
  font-weight:bold;
}

@media screen and (max-width: 1100px) {
  table.podcasts {
    border: 0;
  }

  table.podcasts caption {
    font-size: 1.3em;
  }

  table.podcasts thead {
    border: none;
    clip: rect(0 0 0 0);
    height: 1px;
    margin: -1px;
    overflow: hidden;
    padding: 0;
    position: absolute;
    width: 1px;
  }

  table.podcasts tr {
    border-bottom: 3px solid #ddd;
    display: block;
    margin-bottom: .625em;
  }

  table.podcasts td {
    border-bottom: 1px solid #ddd;
    display: block;
    font-size: .8em;
    text-align:left;
  }

  table.podcasts td.podcasts__stream-container{
   text-align:center;
  }

  table.podcasts td.podcasts__download-container{
   text-align:right;
  }

  table.podcasts td:last-child {
    border-bottom: 0;
  }

  audio{
    /*transform: scale(.75);*/
    max-width:100%;
  }

}


</style>

<table class="podcasts">
  <thead>
    <tr>
      <th scope="col">Description</th>
      <th scope="col">Stream</th>
      <th scope="col">Download</th>
    </tr>
  </thead>
  <tbody>

<#if entries?has_content>
	<#list entries as curEntry>

	<#assign url>${curEntry.getAssetRenderer().getURLDownload(themeDisplay)}</#assign>

  <tr>
    <td scope="row" data-label="Description" class="podcasts__description-container">
      <p class="podcast__desc-title">${curEntry.getTitle(locale)}</p>
      <p class="podcast__desc-para">${curEntry.getDescription()}</p>
    </td>
    <td data-label="Stream" class="podcasts__stream-container">
      <audio controls>
          <source src="${url}" type="audio/mp3">
          You browser doesn't support the HTML5 audio tag!
        </audio>
      </td>
    <td data-label="Download" class="podcasts__download-container">
      <a href="${url}">Download</a>
    </td>
  </tr>


	</#list>
</#if>

    </tbody>
</table>