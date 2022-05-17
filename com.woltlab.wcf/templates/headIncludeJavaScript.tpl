{*
	DO NOT EDIT THIS FILE
*}

<script>
	var SID_ARG_2ND	= '';
	var WCF_PATH = '{@$__wcf->getPath()}';
	var WSC_API_URL = '{@$__wcf->getActivePath()}';
	{* The SECURITY_TOKEN is defined in wcf.globalHelper.js *}
	var LANGUAGE_ID = {@$__wcf->getLanguage()->languageID};
	var LANGUAGE_USE_INFORMAL_VARIANT = {if LANGUAGE_USE_INFORMAL_VARIANT}true{else}false{/if};
	var TIME_NOW = {@TIME_NOW};
	var LAST_UPDATE_TIME = {@LAST_UPDATE_TIME};
	var URL_LEGACY_MODE = false;
	var ENABLE_DEBUG_MODE = {if ENABLE_DEBUG_MODE}true{else}false{/if};
	var ENABLE_PRODUCTION_DEBUG_MODE = {if ENABLE_PRODUCTION_DEBUG_MODE}true{else}false{/if};
	var ENABLE_DEVELOPER_TOOLS = {if ENABLE_DEVELOPER_TOOLS}true{else}false{/if};
	var WSC_API_VERSION = {@WSC_API_VERSION};
	var PAGE_TITLE = '{PAGE_TITLE|phrase|encodeJS}';
	
	var REACTION_TYPES = {@$__wcf->getReactionHandler()->getReactionsJSVariable()};
	
	{if ENABLE_DEBUG_MODE}
		{* This constant is a compiler option, it does not exist in production. *}
		var COMPILER_TARGET_DEFAULT = {if !VISITOR_USE_TINY_BUILD || $__wcf->user->userID}true{else}false{/if};
	{/if}
</script>

{js application='wcf' file='require' bundle='WoltLabSuite.Core' core='true' hasTiny=true}
{js application='wcf' file='require.config' bundle='WoltLabSuite.Core' core='true' hasTiny=true}
{js application='wcf' file='require.linearExecution' bundle='WoltLabSuite.Core' core='true' hasTiny=true}
{js application='wcf' file='wcf.globalHelper' bundle='WoltLabSuite.Core' core='true' hasTiny=true}
{js application='wcf' file='3rdParty/tslib' bundle='WoltLabSuite.Core' core='true' hasTiny=true}
<script>
requirejs.config({
	baseUrl: '{@$__wcf->getPath()}js',
	urlArgs: 't={@LAST_UPDATE_TIME}'
	{hascontent}
	, paths: {
		{content}{event name='requirePaths'}{/content}
	}
	{/hascontent}
});
{* Safari ignores the HTTP cache headers for the back/forward navigation. *}
window.addEventListener('pageshow', function(event) {
	if (event.persisted) {
		window.location.reload();
	}
});
{event name='requireConfig'}
</script>
<script data-relocate="true">
	require(['Language', 'WoltLabSuite/Core/BootstrapFrontend', 'User'], function(Language, BootstrapFrontend, User) {
		Language.addObject({
			'__days': [ '{jslang}wcf.date.day.sunday{/jslang}', '{jslang}wcf.date.day.monday{/jslang}', '{jslang}wcf.date.day.tuesday{/jslang}', '{jslang}wcf.date.day.wednesday{/jslang}', '{jslang}wcf.date.day.thursday{/jslang}', '{jslang}wcf.date.day.friday{/jslang}', '{jslang}wcf.date.day.saturday{/jslang}' ],
			'__daysShort': [ '{jslang}wcf.date.day.sun{/jslang}', '{jslang}wcf.date.day.mon{/jslang}', '{jslang}wcf.date.day.tue{/jslang}', '{jslang}wcf.date.day.wed{/jslang}', '{jslang}wcf.date.day.thu{/jslang}', '{jslang}wcf.date.day.fri{/jslang}', '{jslang}wcf.date.day.sat{/jslang}' ],
			'__months': [ '{jslang}wcf.date.month.january{/jslang}', '{jslang}wcf.date.month.february{/jslang}', '{jslang}wcf.date.month.march{/jslang}', '{jslang}wcf.date.month.april{/jslang}', '{jslang}wcf.date.month.may{/jslang}', '{jslang}wcf.date.month.june{/jslang}', '{jslang}wcf.date.month.july{/jslang}', '{jslang}wcf.date.month.august{/jslang}', '{jslang}wcf.date.month.september{/jslang}', '{jslang}wcf.date.month.october{/jslang}', '{jslang}wcf.date.month.november{/jslang}', '{jslang}wcf.date.month.december{/jslang}' ], 
			'__monthsShort': [ '{jslang}wcf.date.month.short.jan{/jslang}', '{jslang}wcf.date.month.short.feb{/jslang}', '{jslang}wcf.date.month.short.mar{/jslang}', '{jslang}wcf.date.month.short.apr{/jslang}', '{jslang}wcf.date.month.short.may{/jslang}', '{jslang}wcf.date.month.short.jun{/jslang}', '{jslang}wcf.date.month.short.jul{/jslang}', '{jslang}wcf.date.month.short.aug{/jslang}', '{jslang}wcf.date.month.short.sep{/jslang}', '{jslang}wcf.date.month.short.oct{/jslang}', '{jslang}wcf.date.month.short.nov{/jslang}', '{jslang}wcf.date.month.short.dec{/jslang}' ],
			'wcf.clipboard.item.unmarkAll': '{jslang}wcf.clipboard.item.unmarkAll{/jslang}',
			'wcf.clipboard.item.markAll': '{jslang}wcf.clipboard.item.markAll{/jslang}',
			'wcf.clipboard.item.mark': '{jslang}wcf.clipboard.item.mark{/jslang}',
			'wcf.date.relative.now': '{jslang __literal=true}wcf.date.relative.now{/jslang}',
			'wcf.date.relative.minutes': '{jslang __literal=true}wcf.date.relative.minutes{/jslang}',
			'wcf.date.relative.hours': '{jslang __literal=true}wcf.date.relative.hours{/jslang}',
			'wcf.date.relative.pastDays': '{jslang __literal=true}wcf.date.relative.pastDays{/jslang}',
			'wcf.date.dateFormat': '{jslang}wcf.date.dateFormat{/jslang}',
			'wcf.date.dateTimeFormat': '{jslang}wcf.date.dateTimeFormat{/jslang}',
			'wcf.date.shortDateTimeFormat': '{jslang}wcf.date.shortDateTimeFormat{/jslang}',
			'wcf.date.hour': '{jslang}wcf.date.hour{/jslang}',
			'wcf.date.minute': '{jslang}wcf.date.minute{/jslang}',
			'wcf.date.timeFormat': '{jslang}wcf.date.timeFormat{/jslang}',
			'wcf.date.firstDayOfTheWeek': '{jslang}wcf.date.firstDayOfTheWeek{/jslang}',
			'wcf.global.button.add': '{jslang}wcf.global.button.add{/jslang}',
			'wcf.global.button.cancel': '{jslang}wcf.global.button.cancel{/jslang}',
			'wcf.global.button.close': '{jslang}wcf.global.button.close{/jslang}',
			'wcf.global.button.collapsible': '{jslang}wcf.global.button.collapsible{/jslang}',
			'wcf.global.button.delete': '{jslang}wcf.global.button.delete{/jslang}',
			'wcf.button.delete.confirmMessage': '{jslang __literal=true}wcf.button.delete.confirmMessage{/jslang}',
			'wcf.global.button.disable': '{jslang}wcf.global.button.disable{/jslang}',
			'wcf.global.button.disabledI18n': '{jslang}wcf.global.button.disabledI18n{/jslang}',
			'wcf.global.button.edit': '{jslang}wcf.global.button.edit{/jslang}',
			'wcf.global.button.enable': '{jslang}wcf.global.button.enable{/jslang}',
			'wcf.global.button.hide': '{jslang}wcf.global.button.hide{/jslang}',
			'wcf.global.button.insert': '{jslang}wcf.global.button.insert{/jslang}',
			'wcf.global.button.more': '{jslang}wcf.global.button.more{/jslang}',
			'wcf.global.button.next': '{jslang}wcf.global.button.next{/jslang}',
			'wcf.global.button.preview': '{jslang}wcf.global.button.preview{/jslang}',
			'wcf.global.button.reset': '{jslang}wcf.global.button.reset{/jslang}',
			'wcf.global.button.save': '{jslang}wcf.global.button.save{/jslang}',
			'wcf.global.button.search': '{jslang}wcf.global.button.search{/jslang}',
			'wcf.global.button.submit': '{jslang}wcf.global.button.submit{/jslang}',
			'wcf.global.button.upload': '{jslang}wcf.global.button.upload{/jslang}',
			'wcf.global.confirmation.cancel': '{jslang}wcf.global.confirmation.cancel{/jslang}',
			'wcf.global.confirmation.confirm': '{jslang}wcf.global.confirmation.confirm{/jslang}',
			'wcf.global.confirmation.title': '{jslang}wcf.global.confirmation.title{/jslang}',
			'wcf.global.decimalPoint': '{jslang}wcf.global.decimalPoint{/jslang}',
			'wcf.global.error.ajax.network': '{jslang __literal=true}wcf.global.error.ajax.network{/jslang}',
			'wcf.global.error.timeout': '{jslang}wcf.global.error.timeout{/jslang}',
			'wcf.global.error.title': '{jslang}wcf.global.error.title{/jslang}'
			'wcf.global.form.error.empty': '{jslang}wcf.global.form.error.empty{/jslang}',
			'wcf.global.form.error.greaterThan': '{jslang __literal=true}wcf.global.form.error.greaterThan{/jslang}',
			'wcf.global.form.error.lessThan': '{jslang __literal=true}wcf.global.form.error.lessThan{/jslang}',
			'wcf.global.form.error.multilingual': '{jslang}wcf.global.form.error.multilingual{/jslang}',
			'wcf.global.form.input.maxItems': '{jslang}wcf.global.form.input.maxItems{/jslang}',
			'wcf.global.language.noSelection': '{jslang}wcf.global.language.noSelection{/jslang}',
			'wcf.global.loading': '{jslang}wcf.global.loading{/jslang}',
			'wcf.global.noSelection': '{jslang}wcf.global.noSelection{/jslang}',
			'wcf.global.select': '{jslang}wcf.global.select{/jslang}',
			'wcf.page.jumpTo': '{jslang}wcf.page.jumpTo{/jslang}',
			'wcf.page.jumpTo.description': '{jslang}wcf.page.jumpTo.description{/jslang}',
			'wcf.global.page.pagination': '{jslang}wcf.global.page.pagination{/jslang}',
			'wcf.global.page.next': '{jslang}wcf.global.page.next{/jslang}',
			'wcf.global.page.previous': '{jslang}wcf.global.page.previous{/jslang}',
			'wcf.global.pageDirection': '{jslang}wcf.global.pageDirection{/jslang}',
			'wcf.global.reason': '{jslang}wcf.global.reason{/jslang}',
			'wcf.global.scrollUp': '{jslang}wcf.global.scrollUp{/jslang}',
			'wcf.global.success': '{jslang}wcf.global.success{/jslang}',
			'wcf.global.success.add': '{jslang}wcf.global.success.add{/jslang}',
			'wcf.global.success.edit': '{jslang}wcf.global.success.edit{/jslang}',
			'wcf.global.thousandsSeparator': '{jslang}wcf.global.thousandsSeparator{/jslang}',
			'wcf.page.pagePosition': '{jslang __literal=true}wcf.page.pagePosition{/jslang}',
			'wcf.style.changeStyle': '{jslang}wcf.style.changeStyle{/jslang}',
			'wcf.user.activityPoint': '{jslang}wcf.user.activityPoint{/jslang}',
			'wcf.global.button.markAllAsRead': '{jslang}wcf.global.button.markAllAsRead{/jslang}',
			'wcf.global.button.markAsRead': '{jslang}wcf.global.button.markAsRead{/jslang}',
			'wcf.user.panel.settings': '{jslang}wcf.user.panel.settings{/jslang}',
			'wcf.user.panel.showAll': '{jslang}wcf.user.panel.showAll{/jslang}',
			'wcf.menu.page': '{jslang}wcf.menu.page{/jslang}',
			'wcf.menu.page.button.toggle': '{jslang __literal=true}wcf.menu.page.button.toggle{/jslang}',
			'wcf.menu.user': '{jslang}wcf.menu.user{/jslang}',
			'wcf.global.button.showMenu': '{jslang}wcf.global.button.showMenu{/jslang}',
			'wcf.global.button.hideMenu': '{jslang}wcf.global.button.hideMenu{/jslang}',
			'wcf.date.datePicker': '{jslang}wcf.date.datePicker{/jslang}',
			'wcf.date.datePicker.previousMonth': '{jslang}wcf.date.datePicker.previousMonth{/jslang}',
			'wcf.date.datePicker.nextMonth': '{jslang}wcf.date.datePicker.nextMonth{/jslang}',
			'wcf.date.datePicker.month': '{jslang}wcf.date.datePicker.month{/jslang}',
			'wcf.date.datePicker.year': '{jslang}wcf.date.datePicker.year{/jslang}',
			'wcf.date.datePicker.hour': '{jslang}wcf.date.datePicker.hour{/jslang}',
			'wcf.date.datePicker.minute': '{jslang}wcf.date.datePicker.minute{/jslang}',
			'wcf.global.form.password.button.hide': '{jslang}wcf.global.form.password.button.hide{/jslang}',
			'wcf.global.form.password.button.show': '{jslang}wcf.global.form.password.button.show{/jslang}',
			'wcf.message.share': '{jslang}wcf.message.share{/jslang}',
			'wcf.message.share.facebook': '{jslang}wcf.message.share.facebook{/jslang}',
			'wcf.message.share.twitter': '{jslang}wcf.message.share.twitter{/jslang}',
			'wcf.message.share.reddit': '{jslang}wcf.message.share.reddit{/jslang}',
			'wcf.message.share.whatsApp': '{jslang}wcf.message.share.whatsApp{/jslang}',
			'wcf.message.share.linkedIn': '{jslang}wcf.message.share.linkedIn{/jslang}',
			'wcf.message.share.pinterest': '{jslang}wcf.message.share.pinterest{/jslang}',
			'wcf.message.share.xing': '{jslang}wcf.message.share.xing{/jslang}',
			'wcf.message.share.permalink': '{jslang}wcf.message.share.permalink{/jslang}',
			'wcf.message.share.permalink.bbcode': '{jslang}wcf.message.share.permalink.bbcode{/jslang}',
			'wcf.message.share.permalink.html': '{jslang}wcf.message.share.permalink.html{/jslang}',
			'wcf.message.share.socialMedia': '{jslang}wcf.message.share.socialMedia{/jslang}',
			'wcf.message.share.copy': '{jslang}wcf.message.share.copy{/jslang}',
			'wcf.message.share.copy.success': '{jslang}wcf.message.share.copy.success{/jslang}',
			'wcf.message.share.nativeShare': '{jslang}wcf.message.share.nativeShare{/jslang}',
			'wcf.global.button.rss': '{jslang}wcf.global.button.rss{/jslang}',
			'wcf.global.rss.copy': '{jslang}wcf.global.rss.copy{/jslang}',
			'wcf.global.rss.copy.success': '{jslang}wcf.global.rss.copy.success{/jslang}',
			'wcf.global.rss.accessToken.info': '{jslang}wcf.global.rss.accessToken.info{/jslang}',
			'wcf.global.rss.withoutAccessToken': '{jslang}wcf.global.rss.withoutAccessToken{/jslang}',
			'wcf.global.rss.withAccessToken': '{jslang}wcf.global.rss.withAccessToken{/jslang}'
			{if MODULE_LIKE}
				,'wcf.like.button.like': '{jslang}wcf.like.button.like{/jslang}',
				'wcf.like.button.dislike': '{jslang}wcf.like.button.dislike{/jslang}',
				'wcf.like.tooltip': '{jslang}wcf.like.jsTooltip{/jslang}',
				'wcf.like.summary': '{jslang}wcf.like.summary{/jslang}',
				'wcf.like.details': '{jslang}wcf.like.details{/jslang}',
				'wcf.reactions.react': '{jslang}wcf.reactions.react{/jslang}'
			{/if}
			
			{event name='javascriptLanguageImport'}
		});
		
		User.init(
			{@$__wcf->user->userID},
			{if $__wcf->user->userID}'{@$__wcf->user->username|encodeJS}'{else}''{/if},
			{if $__wcf->user->userID}'{@$__wcf->user->getLink()|encodeJS}'{else}''{/if}
		);
		
		BootstrapFrontend.setup({
			backgroundQueue: {
				url: '{link controller="BackgroundQueuePerform"}{/link}',
				force: {if $forceBackgroundQueuePerform|isset}true{else}false{/if}
			},
			enableUserPopover: {if $__wcf->getSession()->getPermission('user.profile.canViewUserProfile')}true{else}false{/if},
			executeCronjobs: {if $executeCronjobs}true{else}false{/if},
			{if ENABLE_SHARE_BUTTONS}
			    shareButtonProviders: [{implode from="\n"|explode:SHARE_BUTTONS_PROVIDERS item=shareButtonProvider}'{$shareButtonProvider}'{/implode}],
			{/if}
			styleChanger: {if $__wcf->getStyleHandler()->showStyleChanger()}true{else}false{/if}
		});
	});
	
	// prevent jQuery and other libraries from utilizing define()
	__require_define_amd = define.amd;
	define.amd = undefined;
</script>

{include file='__devtoolsLanguageChooser'}

{if ENABLE_DEBUG_MODE && ENABLE_DEVELOPER_TOOLS}
<script data-relocate="true">
	require(["WoltLabSuite/Core/Devtools/Style/LiveReload"], (LiveReload) => LiveReload.watch());
</script>
{/if}

{js application='wcf' lib='jquery' hasTiny=true}
{js application='wcf' lib='jquery-ui' hasTiny=true}
{js application='wcf' lib='jquery-ui' file='touchPunch' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' lib='jquery-ui' file='nestedSortable' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' lib='polyfill' file='focus-visible' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Assets' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF' bundle='WCF.Combined' hasTiny=true}

<script data-relocate="true">
	define.amd = __require_define_amd;
	$.holdReady(true);
	
	WCF.User.init(
		{@$__wcf->user->userID},
		{if $__wcf->user->userID}'{@$__wcf->user->username|encodeJS}'{else}''{/if}
	);
</script>

{js application='wcf' file='WCF.ACL' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Attachment' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.ColorPicker' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Comment' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.ImageViewer' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Label' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Location' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Message' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Poll' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Search.Message' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.User' bundle='WCF.Combined' hasTiny=true}
{js application='wcf' file='WCF.Moderation' bundle='WCF.Combined' hasTiny=true}

{event name='javascriptInclude'}

<noscript>
	<style>
		.jsOnly {
			display: none !important;
		}
		
		.noJsOnly {
			display: block !important;
		}
	</style>
</noscript>

<script data-relocate="true">
	$(function() {
		WCF.User.Profile.ActivityPointList.init();
		
		{if MODULE_TROPHY && $__wcf->session->getPermission('user.profile.trophy.canSeeTrophies')}
			require(['WoltLabSuite/Core/Ui/User/Trophy/List'], function (UserTrophyList) {
				new UserTrophyList();
			});
		{/if}
		
		{event name='javascriptInit'}
		
		{if ENABLE_POLLING && $__wcf->user->userID}
			require(['WoltLabSuite/Core/Notification/Handler'], function(NotificationHandler) {
				NotificationHandler.setup({
					icon: '{$__wcf->getStyleHandler()->getStyle()->getFaviconAppleTouchIcon()}',
				});
			});
		{/if}
	});
</script>

{include file='imageViewer'}
{include file='headIncludeJsonLd'}
