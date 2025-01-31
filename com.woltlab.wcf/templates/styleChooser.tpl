<ol class="containerList styleList{if $styleList|count > 4} doubleColumned{/if}">
	{foreach from=$styleList item=style}
		<li data-style-id="{@$style->styleID}">
			<div class="box64">
				<span>
					<img src="{@$style->getPreviewImage()}" srcset="{@$style->getPreviewImage2x()} 2x" height="64" alt="">
				</span>
				<div class="details">
					<div class="containerHeadline">
						<h3>
							{$style->styleName}
							{if $style->styleID == $__wcf->getStyleHandler()->getStyle()->styleID}
								<span class="jsTooltip" title="{lang}wcf.style.currentStyle{/lang}">
									{icon name='circle-check'}
								</span>
							{/if}
						</h3>
					</div>
					{if $style->styleDescription}<small>{lang __optional=true}{@$style->styleDescription}{/lang}</small>{/if}
				</div>
			</div>
		</li>
	{/foreach}
</ol>