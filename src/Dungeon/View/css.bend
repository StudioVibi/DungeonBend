import Dungeon/View/assets_and_labels/_dungeon_bg as _dungeon_bg
import Dungeon/View/action_button_css as action_button_css
def base_css() -> String:
  ""
  ++ ":root{--bg:#ffffff;--surface:#f2f2f2;--surface-strong:#e3e3e3;--surface-border:#d2d2d2;--text:#111111;--text-muted:#555555;--accent:#202020;--danger:#c21c1c;--shadow:0 16px 40px rgba(17,17,17,0.08);--radius-lg:28px;--radius-md:20px;--radius-sm:14px;--header-icon-size:34px;--header-icon-gap:7px;--header-icon-size-mobile:30px;--header-icon-gap-mobile:6px;--dungeon-topbar-gap:80px;--dungeon-topbar-gap-mobile:6px;--dungeon-bg-fallback:#081516;--dungeon-level-value-offset-y:-8px;--deck-counter-width:75px;--deck-counter-anchor-height:40px;--deck-counter-anchor-height-mobile:36px;--deck-counter-visual-bottom:-16px;--deck-counter-visual-bottom-mobile:-15px;--menu-home-hero-offset-desktop:44px;--menu-home-hero-offset-mobile:150px;--topbar-min-height:48px;--menu-topbar-height:62px;--menu-topbar-height-mobile:58px;--topbar-leading-width:110px;--topbar-leading-width-mobile:88px;--topbar-resource-value-min-width:4ch;}"
  ++ "*{box-sizing:border-box;}html,body{margin:0;height:100%;min-height:100%;background:var(--bg);color:var(--text);font-family:'Avenir Next','Trebuchet MS',sans-serif;overflow:hidden;overscroll-behavior:none;position:fixed;width:100%;touch-action:none;}button,input,select{font:inherit;}button{cursor:pointer;}img{display:block;max-width:100%;}#app,.page{height:100svh;overflow:hidden;}"

def dungeon_scene_css() -> String:
  ""
  ++ ".page-preload-image{position:fixed;left:-9999px;top:-9999px;width:1px;height:1px;opacity:0;pointer-events:none;}.dungeon-scene{position:relative;width:100%;height:100svh;overflow:hidden;background-color:var(--dungeon-bg-fallback);background-image:url(\""
  ++ _dungeon_bg()
  ++ "\");background-size:cover;background-position:center center;background-repeat:no-repeat;}"

def shared_topbar_css() -> String:
  ""

  # --- topbar shell ---------------------------------------------------------
  ++ ".topbar{
       display: flex;
       align-items: center;
       justify-content: flex-start;
       min-height: var(--topbar-min-height);
     }"
  ++ ".topbar--menu-ui{
       width: 100%;
       height: var(--menu-topbar-height);
       min-height: var(--menu-topbar-height);
       align-items: center;
       justify-content: space-between;
       gap: 12px;
       padding: 0;
     }"

  # --- topbar slots / actions / stats containers ----------------------------
  ++ ".topbar__back{display: flex; align-items: center;}"
  ++ ".topbar__back>.bc-btn,
       .topbar__back>.menu-club-btn-wrap>.bc-btn,
       .topbar__back>.menu-club-btn-wrap>.db-action-button-wrap{width: auto; min-width: 0;}"
  ++ ".topbar__actions{
       display: flex;
       align-items: center;
       justify-content: flex-end;
       gap: 12px;
       min-width: 0;
     }"
  ++ ".topbar__content{
       display: flex;
       align-items: center;
       justify-content: flex-end;
       flex: 1 1 auto;
       min-width: 0;
       height: 100%;
     }"
  ++ ".topbar__stats{
       display: flex;
       align-items: center;
       justify-content: flex-end;
       gap: 14px;
       min-width: 0;
     }"
  ++ ".topbar__slot{
       display: flex;
       align-items: center;
       justify-content: flex-end;
       flex: 0 0 var(--topbar-leading-width);
       min-width: var(--topbar-leading-width);
       height: 100%;
     }"
  ++ ".topbar__slot--leading{justify-content: flex-start;}"
  ++ ".topbar__slot .bc-btn{width: auto; min-width: 0;}"
  ++ ".topbar__slot--placeholder{display: flex; visibility: hidden; pointer-events: none;}"
  ++ ".topbar-resource-row{display:flex;align-items:center;justify-content:flex-end;gap:14px;min-width:0;}"

  # --- resource row (icon + numeric value) ----------------------------------
  ++ ".topbar-resource{
       margin: 0;
       display: inline-grid;
       grid-template-columns: var(--header-icon-size) auto;
       align-items: center;
       column-gap: var(--header-icon-gap);
       min-height: var(--header-icon-size);
       min-width: 0;
       color: var(--text);
       white-space: nowrap;
     }"
  ++ ".topbar-resource__icon{
       width: var(--header-icon-size);
       height: var(--header-icon-size);
       object-fit: contain;
       flex: 0 0 auto;
     }"

  # --- topbar resource value (gold/booster numbers) -------------------------
  # Same outline + drop-shadow recipe used by the shared action button,
  # scaled to the smaller font size of the topbar.
  # Design tokens (tunables — override per modifier if needed):
  #   --topbar-resource-value-stroke-width     outline width (visible = HALF this; paint-order: stroke fill)
  #   --topbar-resource-value-stroke-color     outline color
  #   --topbar-resource-value-shadow-offset-y  cartoon drop-shadow Y offset (positive = DOWN)
  #   --topbar-resource-value-shadow-color     cartoon drop-shadow color
  ++ ".topbar-resource__value{
       --topbar-resource-value-stroke-width: 1.6px;
       --topbar-resource-value-stroke-color: #0a0e14;
       --topbar-resource-value-shadow-offset-y: 2px;
       --topbar-resource-value-shadow-color: #000;
       display: block;
       min-width: var(--topbar-resource-value-min-width);
       font-size: 1rem;
       font-weight: 900;
       line-height: 1;
       letter-spacing: 0;
       font-variant-numeric: tabular-nums;
       text-align: start;
       color: #fffdf4;
       -webkit-text-stroke: var(--topbar-resource-value-stroke-width) var(--topbar-resource-value-stroke-color);
       paint-order: stroke fill;
       filter: drop-shadow(0 var(--topbar-resource-value-shadow-offset-y) 0 var(--topbar-resource-value-shadow-color));
     }"

  # --- generic label/value stat (non-resource) ------------------------------
  ++ ".topbar-stat{
       margin: 0;
       display: inline-flex;
       align-items: baseline;
       gap: 6px;
       color: var(--text-muted);
       font-size: 0.72rem;
       font-weight: 700;
       letter-spacing: 0.06em;
       text-transform: uppercase;
       white-space: nowrap;
     }"
  ++ ".topbar-stat__value{color: var(--text); font-size: 0.92rem; letter-spacing: 0;}"

  # --- mobile tuning --------------------------------------------------------
  ++ "@media (max-width: 800px){
       .topbar--menu-ui{
         height: var(--menu-topbar-height-mobile);
         min-height: var(--menu-topbar-height-mobile);
         gap: 10px;
       }
       .topbar__actions,
       .topbar__stats,
       .topbar-resource-row{gap: 10px;}
       .topbar__slot{
         flex-basis: var(--topbar-leading-width-mobile);
         min-width: var(--topbar-leading-width-mobile);
       }
       .topbar-resource{
         grid-template-columns: var(--header-icon-size-mobile) auto;
         column-gap: var(--header-icon-gap-mobile);
         min-height: var(--header-icon-size-mobile);
       }
       .topbar-resource__icon{
         width: var(--header-icon-size-mobile);
         height: var(--header-icon-size-mobile);
       }
       .topbar-resource__value{font-size: 0.88rem;}
       .topbar-stat{font-size: 0.64rem;}
       .topbar-stat__value{font-size: 0.82rem;}
     }"

def menu_screen_css() -> String:
  ""
  ++ ".menu-screen{width:100%;height:100%;min-height:0;display:grid;grid-template-rows:auto minmax(0,1fr) auto;align-items:stretch;gap:14px;}.menu-screen__header,.menu-screen__body,.menu-screen__footer{min-width:0;display:grid;}.menu-screen__header{align-content:start;}.menu-screen__body{min-height:0;align-content:stretch;}.menu-screen__footer{align-content:end;justify-items:stretch;}"
  ++ "@media (max-width:800px){.menu-screen{gap:16px;}}"

def menu_home_css() -> String:
  ""
  # --- page shell + background
  ++ ".menu-home-page{position:relative;width:100%;height:100%;min-height:0;overflow:hidden;isolation:isolate;background-color:#60C5F7;}"
  ++ ".menu-home-page__content{position:relative;z-index:1;width:100%;height:100%;}"
  ++ ".menu-home-bg{position:fixed;inset:0;z-index:0;pointer-events:none;background-color:#60C5F7;}"
  ++ ".menu-home-bg .bc-image{width:100%!important;height:100%!important;object-fit:cover;object-position:center center;}"
  ++ ".menu-home-scene{width:100%;height:100%;min-height:0;}"
  ++ ".menu-home-headers{width:100%;display:grid;}"
  # --- generic menu stage container
  ++ ".menu-stage{display:grid;min-height:0;place-items:center;padding-block:8px;}"
  ++ ".menu-stage__content{width:100%;min-height:0;max-height:100%;display:grid;justify-items:center;align-content:center;}"
  ++ ".menu-stage--home{padding-block:0 8px;}"
  ++ ".menu-stage__content--home{align-content:stretch;}"
  # --- home layout
  ++ ".menu-home{width:100%;display:grid;justify-items:center;align-content:center;}"
  ++ ".menu-home__hero{position:relative;width:min(100%,420px);display:grid;place-items:center;margin-top:var(--menu-home-hero-offset-desktop);padding:20px 0 18px;}"
  ++ ".topbar--menu-home-mobile{display:none;}"
  # --- hero panel (portrait + info)
  ++ ".menu-hero-panel{width:100%;min-height:0;justify-items:center;align-content:center;gap:18px;}"
  ++ ".menu-hero-panel--desktop{display:grid;appearance:none;padding:0;border:0;background:transparent;color:inherit;font:inherit;text-align:inherit;cursor:pointer;}"
  ++ ".menu-hero-panel--mobile{display:none;}"
  ++ ".menu-hero-panel__portrait{width:min(100%,320px);min-height:0;max-height:clamp(220px,44vh,340px);display:grid;place-items:center;}"
  ++ ".menu-hero-panel__image{width:auto;height:auto;min-height:0;max-width:100%;max-height:100%;object-fit:contain;}"
  # --- hero info swap (default <-> change-character label)
  ++ ".menu-home-info{position:relative;width:100%;min-height:30px;display:grid;place-items:center;}"
  ++ ".menu-home-info__default,.menu-home-info__change{grid-area:1 / 1;display:grid;place-items:center;transition:opacity 140ms ease,transform 140ms ease;}"
  ++ ".menu-home-info__default--hud .hero-hud{width:min(100%,204px);}"
  ++ ".menu-home-info__change{opacity:0;pointer-events:none;transform:translateY(4px);}"
  ++ ".menu-home-info__change-label{position:relative;display:inline-flex;align-items:center;justify-content:center;min-height:28px;padding:0 14px;color:#ffffff;font-size:0.78rem;font-weight:900;letter-spacing:0.12em;text-transform:uppercase;isolation:isolate;}"
  ++ ".menu-home-info__change-label::before{content:'';position:absolute;inset:0;background:#111111;transform:scaleX(0);transform-origin:left center;z-index:-1;}"
  # --- upgrade button overlay
  ++ ".menu-home__upgrade{position:absolute;left:18%;top:42%;z-index:3;transform:translate(-62%,-72%);}"
  # --- bottom actions (booster + play)
  ++ ".menu-actions{width:100%;display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);align-items:end;gap:18px;}"
  ++ ".menu-actions__booster{width:min(100%,190px);justify-self:start;}"
  ++ ".menu-actions__primary{width:min(100%,220px);justify-self:end;display:grid;gap:12px;}"
  ++ ".menu-actions__slot,.menu-actions__slot>.bc-btn,.menu-actions__slot>.menu-club-btn-wrap,.menu-actions__slot>.menu-play-btn-wrap{width:100%;}"
  # --- hover/focus reveal of change-character label
  ++ "@media (hover:hover) and (pointer:fine){.menu-hero-panel--desktop:hover .menu-home-info__default,.menu-hero-panel--desktop:focus-visible .menu-home-info__default{opacity:0;transform:translateY(-4px);}.menu-hero-panel--desktop:hover .menu-home-info__change,.menu-hero-panel--desktop:focus-visible .menu-home-info__change{opacity:1;transform:translateY(0);}.menu-hero-panel--desktop:hover .menu-home-info__change-label::before,.menu-hero-panel--desktop:focus-visible .menu-home-info__change-label::before{animation:menu-marker-sweep 220ms cubic-bezier(0.18,0.8,0.18,1) both;}}"
  ++ "@keyframes menu-marker-sweep{0%{transform:scaleX(0);}100%{transform:scaleX(1);}}"
  # --- desktop tuning
  ++ "@media (min-width:801px){.menu-home__hero{width:min(100%,520px);}.menu-hero-panel__portrait{width:min(100%,380px);max-height:clamp(260px,50vh,400px);}.menu-home-info__default--hud .hero-hud{width:min(100%,236px);}.menu-actions{gap:24px;}.menu-actions__booster{width:min(100%,224px);}.menu-actions__primary{width:min(100%,244px);}}"
  # --- mobile tuning
  ++ "@media (max-width:800px){.topbar--menu-home-desktop,.menu-hero-panel--desktop{display:none;}.topbar--menu-home-mobile{display:flex;}.menu-hero-panel--mobile{display:grid;gap:14px;}.menu-home__hero{width:min(100%,320px);margin-top:var(--menu-home-hero-offset-mobile);padding:14px 0 16px;}.menu-hero-panel__portrait{width:min(100%,236px);max-height:clamp(176px,34vh,236px);}.menu-home-info__change{display:none;}.menu-home__upgrade{left:10%;top:42%;transform:translate(0,-76%);}.menu-actions{grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:12px;}.menu-actions__booster,.menu-actions__primary{width:100%;}.menu-actions__primary{gap:10px;}}"

def menu_secondary_button_css() -> String:
  ""

  # --- club/play button wrappers --------------------------------------------
  ++ ".menu-club-btn-wrap,.menu-play-btn-wrap{
       position: relative;
       display: inline-grid;
       max-width: 100%;
     }"
  ++ ".menu-club-btn-wrap--full,.menu-play-btn-wrap--full{
       display: grid;
       width: 100%;
     }"
  ++ ".menu-club-btn-wrap--fit,.menu-play-btn-wrap--fit{width: auto;}"
  ++ ".menu-club-btn-wrap--full>.bc-btn,
       .menu-play-btn-wrap--full>.bc-btn,
       .menu-club-btn-wrap--full>.db-action-button-wrap,
       .menu-play-btn-wrap--full>.db-action-button-wrap{width: 100%;}"

def menu_primary_button_css() -> String:
  ""

def button_press_css() -> String:
  ""
  ++ ".bc-btn,.bc-btn:hover,.bc-btn:active,.bc-btn:focus-visible{transition:none;}"

def character_roster_card_css() -> String:
  ""
  ++ ".character-roster-card{position:relative;appearance:none;width:100%;padding:0;border:0;background:transparent;color:inherit;font:inherit;text-align:center;cursor:pointer;}.character-roster-card>.bc-card{position:relative;width:100%;aspect-ratio:0.72;min-height:0;height:auto;background:transparent;border:0;border-radius:0;box-shadow:none;overflow:visible;transition:transform 120ms ease,filter 120ms ease;}.character-roster-card>.bc-card>.bc-card-body{height:100%;}.character-roster-card .bc-card-surface{overflow:visible;transition:filter 120ms ease;}.character-roster-card:hover>.bc-card{transform:translateY(-1px);}.character-roster-card--locked{opacity:0.74;}.character-roster-card--active .bc-card-surface{filter:drop-shadow(1px 0 0 rgba(17,17,17,0.82)) drop-shadow(-1px 0 0 rgba(17,17,17,0.82)) drop-shadow(0 1px 0 rgba(17,17,17,0.82)) drop-shadow(0 -1px 0 rgba(17,17,17,0.82)) drop-shadow(0 0 2px rgba(17,17,17,0.56));}.character-roster-card--selected .bc-card-surface{filter:drop-shadow(1px 0 0 rgba(116,182,70,0.9)) drop-shadow(-1px 0 0 rgba(116,182,70,0.9)) drop-shadow(0 1px 0 rgba(116,182,70,0.9)) drop-shadow(0 -1px 0 rgba(116,182,70,0.9)) drop-shadow(0 0 3px rgba(116,182,70,0.64));}.character-roster-card--active.character-roster-card--selected .bc-card-surface{filter:drop-shadow(1px 0 0 rgba(17,17,17,0.86)) drop-shadow(-1px 0 0 rgba(17,17,17,0.86)) drop-shadow(0 1px 0 rgba(17,17,17,0.86)) drop-shadow(0 -1px 0 rgba(17,17,17,0.86)) drop-shadow(2px 0 0 rgba(116,182,70,0.72)) drop-shadow(-2px 0 0 rgba(116,182,70,0.72)) drop-shadow(0 2px 0 rgba(116,182,70,0.72)) drop-shadow(0 -2px 0 rgba(116,182,70,0.72));}.character-roster-card__content{position:relative;display:block;width:100%;height:100%;}.character-roster-card__sr-label{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0 0 0 0);white-space:nowrap;border:0;}.character-roster-card__mask{position:absolute;inset:7px 5px 8px;display:block;overflow:hidden;}.character-roster-card__portrait{position:absolute;left:50%;bottom:5%;width:128%;height:92%;max-width:none;max-height:none;object-fit:contain;object-position:center bottom;transform:translateX(-50%);filter:drop-shadow(0 8px 12px rgba(17,17,17,0.18));}.character-roster-card__footer{position:absolute;left:0;right:0;bottom:-2px;z-index:2;display:grid;place-items:center;height:30%;min-height:0;padding:0 8%;border-top:0;background:linear-gradient(90deg,rgba(0,0,0,0) 0%,rgba(0,0,0,0.46) 28%,rgba(0,0,0,0.46) 72%,rgba(0,0,0,0) 100%);}.character-roster-card__level{display:block;color:#fff;font-size:0.9rem;font-weight:900;line-height:1;letter-spacing:0;text-align:center;font-variant-numeric:tabular-nums;-webkit-text-stroke:0.85px #06070a;paint-order:stroke fill;text-shadow:0 2px 0 #06070a,1px 0 0 #06070a,-1px 0 0 #06070a,0 -1px 0 #06070a;}.character-roster-card__upgrade{position:absolute;z-index:3;top:8%;right:9%;display:block;width:29%;max-width:42px;min-width:24px;aspect-ratio:54 / 66;filter:drop-shadow(0 3px 0 rgba(18,18,42,0.7));}.db-upgrade-jelly{animation:character-upgrade-jelly 1180ms cubic-bezier(0.2,0.82,0.2,1) infinite;transform-origin:50% 78%;}.character-roster-card__upgrade-icon{width:100%;height:100%;object-fit:contain;}.character-roster-card__image-wrap,.character-roster-card__image{display:none;}"
  ++ "@keyframes character-upgrade-jelly{0%,100%{transform:translateY(0) scale(1);}22%{transform:translateY(-9%) scale(0.94,1.08);}42%{transform:translateY(3%) scale(1.08,0.91);}62%{transform:translateY(-4%) scale(0.98,1.03);}78%{transform:translateY(1%) scale(1.02,0.98);}}"
  ++ "@media (min-width:801px){.character-roster-card>.bc-card{min-height:0;}.character-roster-card__level{font-size:0.76rem;}.character-roster-card__mask{inset:6px 5px 7px;}.character-roster-card__upgrade{top:8%;right:9%;}}"
  ++ "@media (max-width:800px){.character-roster-card{width:78px;justify-self:start;}.character-roster-card>.bc-card{min-height:0;}.character-roster-card__mask{inset:5px 5px 6px;}.character-roster-card__level{font-size:0.68rem;-webkit-text-stroke:0.75px #06070a;}.character-roster-card__upgrade{min-width:20px;}}"

def character_select_css() -> String:
  ""
  ++ ".character-select-headers{width:100%;display:grid;}.topbar--character-select-mobile{display:none;}.character-select-stage{display:grid;min-height:0;place-items:center;padding-block:8px;}.character-select-stage__content{width:100%;display:grid;justify-items:center;align-content:start;padding-top:8px;}.character-select{width:100%;display:grid;grid-template-columns:minmax(0,1fr);gap:24px;align-items:start;}.character-select__main,.character-select__side{min-width:0;display:grid;gap:16px;align-content:start;}.character-select__side{justify-items:stretch;}.character-select-footer{display:none;width:100%;justify-items:start;}.character-detail{width:100%;display:grid;}.character-detail__layout{display:grid;grid-template-columns:minmax(0,0.95fr) minmax(0,1.05fr);gap:16px;align-items:start;}.character-detail__portrait{width:min(100%,240px);height:clamp(220px,34vh,300px);display:grid;place-items:end center;justify-self:center;align-self:start;padding:0 10px;}.character-detail__image{width:auto;height:auto;max-width:100%;max-height:100%;object-fit:contain;object-position:center bottom;filter:drop-shadow(0 16px 28px rgba(17,17,17,0.16));}.character-detail__info{width:100%;display:grid;min-width:0;text-align:left;align-self:start;}.character-detail__stack{width:100%;display:flex;flex-direction:column;gap:20px;align-items:stretch;min-width:0;}.character-detail__name-outline,.character-detail__stats,.character-detail__lock-slot,.character-detail__ultimate-slot,.character-detail__upgrade-slot{width:100%;min-width:0;}.character-detail__name-outline{display:flex;align-items:baseline;justify-content:space-between;gap:12px;}.character-detail__name{flex:1 1 auto;min-width:0;padding:0 4px;color:#fff;font-size:1.2rem;font-weight:900;letter-spacing:0.01em;line-height:1.02;text-align:left;-webkit-text-stroke:4px #1d1d1d;paint-order:stroke fill;text-shadow:0 2px 0 #1d1d1d,1px 0 0 #1d1d1d,-1px 0 0 #1d1d1d,0 -1px 0 #1d1d1d;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden;}.character-detail__stats{display:flex;flex-wrap:wrap;align-items:center;justify-content:flex-start;gap:8px 16px;min-height:24px;}.character-detail__stat{margin:0;color:#b4482e;font-size:0.9rem;font-weight:900;letter-spacing:0.05em;line-height:1;text-transform:uppercase;white-space:nowrap;}.character-detail__lock-slot{display:grid;align-content:start;}.character-detail__locked{margin:0;display:inline-flex;align-items:center;justify-content:center;min-height:28px;padding:5px 10px;border-radius:999px;border:1px solid #efb2b2;background:#f4e6e6;color:var(--danger);font-size:0.72rem;font-weight:900;letter-spacing:0.08em;text-transform:uppercase;justify-self:start;}.character-detail__ultimate-slot{display:grid;align-content:start;min-height:102px;}.character-ultimate{width:100%;height:100%;display:grid;grid-template-rows:auto minmax(0,1fr);gap:8px;color:var(--text-muted);align-content:start;}.character-ultimate>.bc-text-label{letter-spacing:0;}.character-ultimate__body{display:grid;grid-template-columns:42px minmax(0,1fr);align-items:start;gap:10px;height:100%;}.character-ultimate__icon{width:42px;height:42px;object-fit:contain;}.character-ultimate__description{min-width:0;color:var(--text);overflow:hidden;}.character-ultimate__description .bc-text{font-size:0.74rem;font-weight:800;line-height:1.25;letter-spacing:0.01em;display:-webkit-box;-webkit-line-clamp:4;-webkit-box-orient:vertical;overflow:hidden;}.character-detail__upgrade-slot{display:grid;align-content:start;min-height:44px;}.character-upgrade{display:grid;justify-items:start;align-content:start;gap:0;height:auto;padding-top:0;}.character-upgrade__row{display:flex;align-items:center;gap:10px;flex-wrap:wrap;}.character-upgrade__price,.character-upgrade__max{margin:0;color:var(--text-muted);font-size:0.76rem;font-weight:900;letter-spacing:0.08em;line-height:1;text-transform:uppercase;}.character-upgrade__price{display:inline-flex;align-items:center;gap:6px;min-height:36px;padding:0 12px;border:1px solid var(--surface-border);border-radius:999px;background:rgba(255,255,255,0.82);}.character-upgrade__price-icon{width:20px;height:20px;object-fit:contain;flex:0 0 auto;}.character-upgrade__price-value{display:block;color:var(--text);}.character-upgrade__action>.bc-btn,.character-upgrade__action>.menu-club-btn-wrap>.bc-btn{width:auto;min-width:136px;}.character-roster{width:100%;display:grid;}.character-roster__grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;}.character-roster-card{appearance:none;width:100%;padding:0;border:0;background:transparent;color:inherit;font:inherit;text-align:center;cursor:pointer;}.character-roster-card>.bc-card{width:100%;height:100%;min-height:160px;transition:border-color 120ms ease,transform 120ms ease,box-shadow 120ms ease;}.character-roster-card>.bc-card>.bc-card-body{height:100%;padding:0;}.character-roster-card:hover>.bc-card{transform:translateY(-1px);}.character-roster-card--locked{opacity:0.74;}.character-roster-card--active>.bc-card{border-color:var(--accent);box-shadow:0 0 0 2px rgba(17,17,17,0.08),var(--shadow);}.character-roster-card--selected>.bc-card{border-color:#74b646;box-shadow:0 0 0 3px rgba(116,182,70,0.24),var(--shadow);}.character-roster-card__content{height:100%;display:grid;grid-template-rows:minmax(0,1fr) auto;}.character-roster-card__image-wrap{width:100%;min-height:0;display:grid;place-items:center;padding:12px 10px 8px;}.character-roster-card__image{width:auto;height:auto;max-width:100%;max-height:102px;object-fit:contain;}.character-roster-card__footer{display:flex;align-items:center;justify-content:center;min-height:36px;border-top:1px solid var(--surface-border);font-size:0.78rem;font-weight:900;letter-spacing:0.08em;line-height:1;text-transform:uppercase;}.character-boosters{width:100%;display:grid;justify-items:center;gap:8px;padding:0;border:0;border-radius:0;background:none;}.character-boosters__hint{margin:0;color:#8a8a8a;font-size:0.82rem;font-weight:700;line-height:1.35;text-align:center;}.character-boosters__action{display:flex;justify-content:center;}.character-boosters__action>.bc-btn,.character-boosters__action>.menu-club-btn-wrap{width:100%;}"
  ++ ".character-detail__stat-heart,.character-detail__stat-level{display:inline-flex;align-items:center;min-height:56px;}.character-detail__stat-heart .hero-hud__heart{gap:8px;}.character-detail__stat-heart .hero-hud__heart-image{width:42px;height:42px;}.character-detail__stat-heart .hero-hud__heart-value{font-size:1.5rem;color:#fffdf4;-webkit-text-stroke:4px #0a0e14;paint-order:stroke fill;filter:drop-shadow(0 2px 0 #000);}.character-detail__stat-level .hero-hud__level-chip{gap:8px;}.character-detail__stat-level .hero-hud__level-image{width:42px;height:42px;}.character-detail__stat-level .hero-hud__level-value{font-size:1.5rem;color:#fffdf4;-webkit-text-stroke:4px #0a0e14;paint-order:stroke fill;filter:drop-shadow(0 2px 0 #000);}"
  ++ "@media (min-width:801px){.character-detail__stat-heart .hero-hud__heart-image,.character-detail__stat-level .hero-hud__level-image{width:48px;height:48px;}.character-detail__stat-heart .hero-hud__heart-value,.character-detail__stat-level .hero-hud__level-value{font-size:1.62rem;}}"
  ++ "@media (max-width:800px){.character-detail__stat-heart,.character-detail__stat-level{min-height:50px;}.character-detail__stat-heart .hero-hud__heart-image,.character-detail__stat-level .hero-hud__level-image{width:36px;height:36px;}.character-detail__stat-heart .hero-hud__heart-value,.character-detail__stat-level .hero-hud__level-value{font-size:1.38rem;}}"
  ++ "@media (min-width:801px){.character-select{grid-template-columns:minmax(0,1.86fr) minmax(176px,196px);gap:58px;align-items:stretch;}.character-select__main{padding-right:0;}.character-select__side{width:100%;max-width:196px;justify-self:end;align-self:stretch;gap:14px;grid-template-rows:auto auto;padding:6px 0 6px 30px;border-left:1px solid rgba(17,17,17,0.14);}.character-detail__layout{grid-template-columns:minmax(0,1.08fr) minmax(0,0.92fr);gap:26px;align-items:stretch;min-height:clamp(360px,60vh,520px);}.character-detail__portrait{width:min(100%,400px);height:clamp(360px,60vh,520px);padding:0 18px 6px;}.character-detail__stack{gap:20px;}.character-detail__name{font-size:1.52rem;}.character-detail__stat{font-size:0.98rem;}.character-detail__ultimate-slot{min-height:118px;}.character-ultimate__description .bc-text{font-size:0.78rem;}.character-detail__upgrade-slot{min-height:48px;}.character-roster__grid{gap:8px;}.character-roster-card>.bc-card{min-height:132px;}.character-roster-card__image-wrap{padding:10px 8px 8px;}.character-roster-card__image{max-height:72px;}.character-roster-card__footer{min-height:30px;font-size:0.7rem;}.character-boosters__action>.bc-btn{min-width:0;}.character-boosters__hint{font-size:0.78rem;}}"
  ++ "@media (max-width:800px){.topbar--character-select-desktop{display:none;}.topbar--character-select-mobile{display:flex;}.character-select-stage{padding-block:0;}.character-select__main,.character-select__side{gap:16px;}.character-select__side{justify-items:stretch;padding-top:18px;border-top:1px solid rgba(17,17,17,0.12);}.character-select-footer{display:grid;}.character-detail{padding-top:8px;}.character-detail__layout{gap:12px;}.character-detail__portrait{width:min(100%,188px);height:clamp(196px,28vh,236px);padding:0 2px 2px;}.character-detail__name{font-size:1.02rem;}.character-detail__stat{font-size:0.78rem;}.character-ultimate__body{gap:8px;}.character-upgrade{padding-top:2px;}.character-upgrade__row{gap:8px;}.character-upgrade__price{min-height:32px;padding:0 10px;font-size:0.72rem;}.character-upgrade__price-icon{width:18px;height:18px;}.character-upgrade__action>.bc-btn{min-width:112px;}.character-roster,.character-boosters{width:100%;}.character-roster__grid{width:100%;grid-template-columns:repeat(auto-fill,78px);justify-content:start;gap:10px;}.character-roster-card{width:78px;justify-self:start;}.character-roster-card>.bc-card{min-height:108px;}.character-roster-card__image-wrap{padding:8px 6px 6px;}.character-roster-card__image{max-height:52px;}.character-roster-card__footer{min-height:24px;font-size:0.64rem;}.character-boosters{gap:8px;}.character-boosters__action>.bc-btn{width:auto;min-width:132px;}.character-boosters__hint{font-size:0.74rem;}}"

def hero_hud_css() -> String:
  ""
  ++ ".hero-hud{width:min(100%,252px);display:grid;grid-template-columns:auto auto;align-items:center;justify-content:center;column-gap:20px;}.hero-hud__level-chip{display:inline-flex;align-items:center;gap:6px;justify-self:start;}.hero-hud__level-image{width:28px;height:28px;object-fit:contain;}.hero-hud__level-value{color:#b4482e;font-size:1.02rem;font-weight:900;letter-spacing:0.04em;line-height:1;white-space:nowrap;}.hero-hud__hp{display:flex;align-items:center;justify-self:end;gap:8px;min-width:0;}.hero-hud__heart{display:inline-flex;align-items:center;gap:6px;}.hero-hud__heart-image{width:28px;height:28px;object-fit:contain;}.hero-hud__heart-value{color:#b4482e;font-size:1.02rem;font-weight:900;line-height:1;}.hero-hud__max .bc-text{color:#b4482e;font-size:1.02rem;font-weight:900;line-height:1;letter-spacing:0.01em;}"
  ++ "@media (max-width:800px){.hero-hud{width:min(100%,228px);column-gap:16px;}.hero-hud__level-image{width:24px;height:24px;}.hero-hud__level-value{font-size:0.94rem;}.hero-hud__heart-image{width:24px;height:24px;}.hero-hud__heart-value{font-size:0.92rem;}.hero-hud__max .bc-text{font-size:0.94rem;}}"

def boosters_css() -> String:
  ""
  ++ ".boosters-stage{display:grid;min-height:0;place-items:center;padding-block:8px;}.boosters-stage__content{width:100%;min-height:0;display:grid;justify-items:center;align-content:center;gap:18px;}.boosters-stage--reveal{padding-block:0;}.boosters-stage__content--reveal{height:100%;max-height:100%;align-content:center;}.boosters-actions{width:100%;display:grid;justify-items:center;}.boosters-actions__inner{width:min(100%,280px);display:grid;}.booster-reveal-panel{width:100%;min-height:0;display:grid;justify-items:center;align-content:center;gap:18px;}.booster-reveal-panel__visual{width:100%;display:grid;justify-items:center;}.booster-reveal-panel__meta{width:min(100%,280px);display:grid;gap:10px;}.booster-reveal-panel__footer{width:100%;display:flex;justify-content:flex-end;padding-top:18px;}.booster-reveal-panel__action{width:min(100%,168px);}.booster-reveal-panel__action>.bc-btn{width:100%;font-weight:700;letter-spacing:0.04em;text-transform:uppercase;background:rgba(255,255,255,0.42);color:var(--text-muted);border-color:rgba(17,17,17,0.12);box-shadow:none;}.booster-reveal-panel__action>.bc-btn:hover{background:rgba(255,255,255,0.56);color:var(--text);border-color:rgba(17,17,17,0.16);box-shadow:none;}.booster-reveal-panel__action>.bc-btn:active{background:rgba(255,255,255,0.68);color:var(--text);border-color:rgba(17,17,17,0.2);box-shadow:none;}.reveal-meta{display:grid;gap:8px;}.reveal-meta__top{display:grid;grid-template-columns:minmax(0,1fr) auto;align-items:end;gap:12px;}.reveal-name{margin:0;color:var(--text);font-size:1.12rem;font-weight:900;font-style:italic;letter-spacing:0.01em;line-height:1;text-transform:uppercase;}.reveal-copies{margin:0;color:#b7b7b7;font-size:0.92rem;font-weight:800;letter-spacing:0.04em;line-height:1;text-transform:uppercase;white-space:nowrap;text-align:right;}.reveal-stat{margin:0;color:var(--text);white-space:nowrap;}.reveal-stat--detail{font-size:0.98rem;font-weight:900;letter-spacing:0.02em;line-height:1.05;text-transform:uppercase;text-align:left;}.reveal-stat--empty{display:block;min-height:1rem;visibility:hidden;}.reveal-position{margin:0;color:var(--text-muted);font-size:0.82rem;font-weight:800;letter-spacing:0.08em;text-transform:uppercase;white-space:nowrap;}.booster-visual{width:min(100%,280px);aspect-ratio:0.72;display:grid;place-items:center;padding:18px;border-radius:var(--radius-lg);background:#c62626;box-shadow:var(--shadow);}.booster-visual--pack{background:none;box-shadow:none;padding:0;aspect-ratio:auto;}.booster-visual__pack-img{width:100%;height:auto;object-fit:contain;filter:drop-shadow(0 12px 24px rgba(17,17,17,0.16));}.booster-visual--revealed{grid-template-rows:minmax(0,1fr) auto;align-content:stretch;background:linear-gradient(180deg,#fdf8ef 0%,#f3ede3 100%);border:1px solid var(--surface-border);max-height:clamp(320px,52vh,400px);}.booster-visual--midum{padding:0;background:none;border:0;box-shadow:none;}.booster-visual--midum>.bc-card{width:100%;height:100%;box-shadow:var(--shadow);overflow:visible;background:transparent;}.booster-visual--midum>.bc-card>.bc-card-body{height:100%;}.booster-visual__detail{width:100%;height:100%;display:grid;grid-template-rows:minmax(0,1fr) auto;justify-items:center;align-items:center;gap:14px;}.booster-visual__detail--midum{position:relative;padding:0;overflow:visible;}.booster-visual__frame{width:100%;display:grid;place-items:center;}.booster-visual__frame-bg,.booster-visual__image,.booster-visual__frame-border{grid-area:1 / 1;}.booster-visual__frame-bg{z-index:0;width:88.235294%;height:auto;object-fit:contain;pointer-events:none;image-rendering:-webkit-optimize-contrast;}.booster-visual__frame-border{z-index:2;width:100%;height:auto;object-fit:contain;pointer-events:none;image-rendering:-webkit-optimize-contrast;}.booster-visual__image{position:relative;z-index:1;width:auto;height:auto;max-width:100%;max-height:180px;object-fit:contain;filter:drop-shadow(0 12px 24px rgba(17,17,17,0.16));}.booster-visual__image--midum{transform:translateY(-12px);}.booster-visual__stat{margin:0;display:inline-flex;align-items:center;justify-content:center;min-height:34px;padding:6px 12px;border-radius:999px;background:#fff;border:1px solid var(--surface-border);color:var(--text);font-size:0.78rem;font-weight:800;letter-spacing:0.04em;text-transform:uppercase;}.booster-visual__nav{width:100%;display:grid;grid-template-columns:auto 1fr auto;align-items:center;gap:10px;}.booster-visual__nav>.bc-btn{width:auto;min-width:0;}.booster-visual__index{margin:0;color:var(--text-muted);font-size:0.78rem;font-weight:800;letter-spacing:0.08em;text-transform:uppercase;text-align:center;}.boosters-stage__open{display:grid;justify-items:center;}.boosters-stage__buy{width:min(100%,280px);}.boosters-stage__buy>.bc-btn{width:100%;}.boosters-stage__price{margin:0;color:var(--text);font-size:0.92rem;font-weight:800;letter-spacing:0.08em;text-transform:uppercase;}"
  ++ "@media (min-width:801px){.boosters-stage__content{gap:24px;}.boosters-actions__inner{width:min(100%,300px);}.booster-visual--pack{width:min(100%,340px);}}"
  ++ "@media (max-width:800px){.booster-reveal-panel{gap:14px;}.booster-reveal-panel__meta{width:min(100%,248px);}.booster-reveal-panel__footer{padding-top:26px;}.booster-reveal-panel__action{width:min(100%,156px);}.reveal-meta{gap:6px;}.reveal-name{font-size:1rem;}.reveal-copies{font-size:0.82rem;}.reveal-stat--detail{font-size:0.88rem;}.reveal-position{font-size:0.82rem;}.booster-visual{width:min(100%,248px);padding:14px;}.booster-visual--revealed{max-height:clamp(280px,48vh,360px);}.booster-visual--midum{padding:0;}.booster-visual__detail--midum{padding:0;}.booster-visual__image{max-height:156px;}.booster-visual__image--midum{transform:translateY(-9px);}.booster-visual__nav{gap:8px;}.boosters-stage__buy{width:min(100%,260px);}}"

def board_layout_css() -> String:
  ""
  ++ ".board{position:relative;display:block;width:min(100%,clamp(540px,calc(540px + (100vw - 600px) * 0.2),620px),calc((100svh - clamp(180px,calc(180px + (100vw - 600px) * 0.1),220px)) * 0.81548));touch-action:none;transition:transform 140ms ease,filter 140ms ease;}.board>.bc-grid{width:100%;}.board .bc-grid-content-cell{overflow:hidden;}.board .bc-grid-content-cell-inner{width:100%;height:100%;overflow:hidden;}.board--over{transform:scale(0.985);filter:blur(1px);}.ultimate-action{width:min(100%,clamp(540px,calc(540px + (100vw - 600px) * 0.2),620px),calc((100svh - clamp(180px,calc(180px + (100vw - 600px) * 0.1),220px)) * 0.81548));}.ultimate-action>.bc-btn{width:100%;letter-spacing:0.08em;text-transform:uppercase;}.dungeon-pause-action{position:fixed;top:calc(env(safe-area-inset-top,0px) + 24px);right:calc(env(safe-area-inset-right,0px) + 20px);z-index:12;display:grid;justify-items:end;pointer-events:auto;}.dungeon-pause-action>.bc-btn{min-width:0;letter-spacing:0.08em;text-transform:uppercase;}.game-over-modal{position:absolute;inset:0;display:grid;place-items:center;padding:16px;opacity:0;pointer-events:none;background:rgba(17,17,17,0);transition:opacity 140ms ease,background-color 140ms ease;}.game-over-modal--visible{opacity:1;pointer-events:auto;background:rgba(17,17,17,0.32);}.game-over-modal>.bc-card{width:min(100%,280px);}.game-over-card{display:grid;gap:12px;justify-items:center;text-align:center;}.game-over-card__action{width:100%;}.game-over-card__action>.bc-btn{width:100%;}.game-over-card__actions{width:100%;display:grid;justify-items:center;gap:12px;padding-top:4px;}.game-over-card__primary,.game-over-card__secondary{width:min(100%,280px);justify-self:center;}.game-over-card__primary>.bc-btn,.game-over-card__secondary>.bc-btn{width:100%;}.game-over-card__eyebrow{margin:0;color:var(--danger);font-size:0.74rem;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;}.game-over-card__title{margin:0;font-size:1.4rem;line-height:1;}.game-over-card__body{margin:0;color:var(--text-muted);font-size:0.92rem;line-height:1.35;}"
  ++ "@media (max-width:800px){.dungeon-pause-action{display:none;}.game-over-modal>.bc-card{width:min(100%,240px);}}"

def layout_css() -> String:
  button_press_css()
  ++ action_button_css()
  ++ shared_topbar_css()
  ++ menu_screen_css()
  ++ menu_home_css()
  ++ menu_secondary_button_css()
  ++ menu_primary_button_css()
  ++ character_select_css()
  ++ character_roster_card_css()
  ++ hero_hud_css()
  ++ boosters_css()
  ++ board_layout_css()

def ultimate_preview_css() -> String:
  ""
  ++ ".screen-root-stack{position:relative;width:100%;height:100%;}.ultimate-preview-scene{position:relative;min-height:100%;display:grid;grid-template-rows:auto minmax(0,1fr) auto;gap:0;background:#ffffff;isolation:isolate;}.ultimate-preview-topbar,.ultimate-preview-footer{position:relative;z-index:3;}.ultimate-preview-topbar{padding:0 14px;}.ultimate-preview-content{position:fixed;inset:0;z-index:1;pointer-events:none;background:#ffffff;}.ultimate-preview-footer{display:grid;justify-items:center;gap:0;padding:0 14px 18px;}.ultimate-preview-footer__action{width:min(100%,320px);}.ultimate-preview-footer__action>.bc-btn{width:100%;}.ultimate-cinematic-overlay{position:fixed;inset:0;z-index:40;overflow:hidden;pointer-events:auto;background:transparent;}.ultimate-cutin-stage{position:absolute;inset:0;width:100vw;height:100svh;overflow:hidden;pointer-events:none;isolation:isolate;--ultimate-cutin-band-height:28%;--ultimate-cutin-character-width:min(34vw,340px);--ultimate-cutin-desktop-y-offset:10%;--ultimate-cutin-mobile-y-offset:30%;}.ultimate-cutin{position:absolute;inset:0;pointer-events:none;}.ultimate-cutin__trail,.ultimate-cutin__bar,.ultimate-cutin__flash,.ultimate-cutin__hero{position:absolute;opacity:0;will-change:transform,opacity;}.ultimate-cutin__trail{left:-10%;top:50%;width:120%;height:9%;transform:translate3d(-120%,-50%,0) skewX(-18deg);background:linear-gradient(90deg,rgba(44,129,255,0) 0%,rgba(44,129,255,0.14) 24%,rgba(255,255,255,0.52) 50%,rgba(44,129,255,0.14) 76%,rgba(44,129,255,0) 100%);filter:blur(10px);}.ultimate-cutin__bar{left:-12%;top:50%;width:124%;height:var(--ultimate-cutin-band-height);transform:translate3d(-128%,-50%,0) skewX(-10deg);border-radius:18px;overflow:hidden;box-shadow:0 18px 44px rgba(10,33,92,0.18);}.ultimate-cutin__bar::after{content:'';position:absolute;inset:0;background:linear-gradient(90deg,rgba(8,17,63,0.18) 0%,rgba(255,255,255,0.08) 24%,rgba(255,255,255,0.18) 50%,rgba(8,17,63,0.12) 100%);mix-blend-mode:screen;}.ultimate-cutin__banner{width:100%;height:100%;object-fit:cover;}.ultimate-cutin__flash{top:50%;left:-18%;width:72%;height:12%;transform:translate3d(-140%,-50%,0) skewX(-18deg);background:linear-gradient(90deg,rgba(255,255,255,0) 0%,rgba(255,255,255,0.96) 50%,rgba(255,255,255,0) 100%);filter:blur(2px);}.ultimate-cutin__hero{left:5%;bottom:var(--ultimate-cutin-desktop-y-offset);width:var(--ultimate-cutin-character-width);transform:translate3d(-48%,16%,0) scale(0.8);transform-origin:left bottom;filter:drop-shadow(0 18px 22px rgba(9,20,58,0.16));}"
  ++ ".ultimate-cutin-stage--play-a .ultimate-cutin__trail{animation:ultimate-trail-sweep-a 1120ms ease-out both;}.ultimate-cutin-stage--play-b .ultimate-cutin__trail{animation:ultimate-trail-sweep-b 1120ms ease-out both;}.ultimate-cutin-stage--play-a .ultimate-cutin__bar{animation:ultimate-banner-sweep-a 1120ms cubic-bezier(0.2,0.76,0.18,1) both;}.ultimate-cutin-stage--play-b .ultimate-cutin__bar{animation:ultimate-banner-sweep-b 1120ms cubic-bezier(0.2,0.76,0.18,1) both;}.ultimate-cutin-stage--play-a .ultimate-cutin__flash{animation:ultimate-flash-sweep-a 1120ms ease-out both;}.ultimate-cutin-stage--play-b .ultimate-cutin__flash{animation:ultimate-flash-sweep-b 1120ms ease-out both;}.ultimate-cutin-stage--play-a .ultimate-cutin__hero{animation:ultimate-hero-pop-a 1120ms cubic-bezier(0.18,0.8,0.18,1) both;}.ultimate-cutin-stage--play-b .ultimate-cutin__hero{animation:ultimate-hero-pop-b 1120ms cubic-bezier(0.18,0.8,0.18,1) both;}"
  ++ "@keyframes ultimate-trail-sweep-a{0%{opacity:0;transform:translate3d(-120%,-50%,0) skewX(-18deg) scaleX(0.72);}14%{opacity:0.76;}34%{opacity:1;transform:translate3d(6%,-50%,0) skewX(-18deg) scaleX(1);}68%{opacity:0.64;}100%{opacity:0;transform:translate3d(140%,-50%,0) skewX(-18deg) scaleX(1.1);}}"
  ++ "@keyframes ultimate-trail-sweep-b{0%{opacity:0;transform:translate3d(-120%,-50%,0) skewX(-18deg) scaleX(0.72);}14%{opacity:0.76;}34%{opacity:1;transform:translate3d(6%,-50%,0) skewX(-18deg) scaleX(1);}68%{opacity:0.64;}100%{opacity:0;transform:translate3d(140%,-50%,0) skewX(-18deg) scaleX(1.1);}}"
  ++ "@keyframes ultimate-banner-sweep-a{0%{opacity:0;transform:translate3d(-128%,-50%,0) skewX(-10deg) scaleX(0.94);}14%{opacity:1;}28%{opacity:1;transform:translate3d(-6%,-50%,0) skewX(-10deg) scaleX(1.02);}66%{opacity:1;transform:translate3d(-2%,-50%,0) skewX(-10deg) scaleX(1.01);}100%{opacity:0;transform:translate3d(112%,-50%,0) skewX(-10deg) scaleX(1.04);}}"
  ++ "@keyframes ultimate-banner-sweep-b{0%{opacity:0;transform:translate3d(-128%,-50%,0) skewX(-10deg) scaleX(0.94);}14%{opacity:1;}28%{opacity:1;transform:translate3d(-6%,-50%,0) skewX(-10deg) scaleX(1.02);}66%{opacity:1;transform:translate3d(-2%,-50%,0) skewX(-10deg) scaleX(1.01);}100%{opacity:0;transform:translate3d(112%,-50%,0) skewX(-10deg) scaleX(1.04);}}"
  ++ "@keyframes ultimate-flash-sweep-a{0%{opacity:0;transform:translate3d(-140%,-50%,0) skewX(-18deg) scaleX(0.84);}18%{opacity:0;}32%{opacity:0.92;transform:translate3d(16%,-50%,0) skewX(-18deg) scaleX(1);}54%{opacity:0.44;}100%{opacity:0;transform:translate3d(146%,-50%,0) skewX(-18deg) scaleX(1.18);}}"
  ++ "@keyframes ultimate-flash-sweep-b{0%{opacity:0;transform:translate3d(-140%,-50%,0) skewX(-18deg) scaleX(0.84);}18%{opacity:0;}32%{opacity:0.92;transform:translate3d(16%,-50%,0) skewX(-18deg) scaleX(1);}54%{opacity:0.44;}100%{opacity:0;transform:translate3d(146%,-50%,0) skewX(-18deg) scaleX(1.18);}}"
  ++ "@keyframes ultimate-hero-pop-a{0%{opacity:0;transform:translate3d(-48%,16%,0) scale(0.8) rotate(-8deg);}20%{opacity:0;}38%{opacity:1;transform:translate3d(0,0,0) scale(1.04) rotate(1deg);}72%{opacity:1;transform:translate3d(0,0,0) scale(1) rotate(0deg);}100%{opacity:0;transform:translate3d(18%,4%,0) scale(1.02) rotate(1deg);}}"
  ++ "@keyframes ultimate-hero-pop-b{0%{opacity:0;transform:translate3d(-48%,16%,0) scale(0.8) rotate(-8deg);}20%{opacity:0;}38%{opacity:1;transform:translate3d(0,0,0) scale(1.04) rotate(1deg);}72%{opacity:1;transform:translate3d(0,0,0) scale(1) rotate(0deg);}100%{opacity:0;transform:translate3d(18%,4%,0) scale(1.02) rotate(1deg);}}"
  ++ "@media (max-width:800px){.ultimate-preview-topbar{padding:0 12px;}.ultimate-cutin__trail{width:132%;height:10%;left:-14%;}.ultimate-cutin__bar{left:-18%;width:136%;height:24%;}.ultimate-cutin__hero{left:2%;bottom:var(--ultimate-cutin-mobile-y-offset);width:min(52vw,210px);}.ultimate-preview-footer{padding:0 12px 16px;}.ultimate-preview-footer__action{width:min(100%,280px);}}"

def dungeon_topbar_css() -> String:
  ""
  ++ ".topbar--dungeon{display:grid;grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);align-items:start;width:100%;min-height:72px;gap:var(--dungeon-topbar-gap);padding-top:0;}.dungeon-topbar__left,.dungeon-topbar__center,.dungeon-topbar__right{min-width:0;display:flex;align-items:flex-start;}.dungeon-topbar__left{justify-self:start;justify-content:flex-start;}.dungeon-topbar__center{justify-self:center;justify-content:center;}.dungeon-topbar__right{justify-self:end;justify-content:flex-end;}"
  ++ ".dungeon-resource{margin:0;display:inline-grid;grid-template-columns:var(--header-icon-size) auto;align-items:center;column-gap:var(--header-icon-gap);min-height:40px;min-width:0;color:var(--text);white-space:nowrap;}.dungeon-resource__icon{width:var(--header-icon-size);height:var(--header-icon-size);object-fit:contain;flex:0 0 auto;}.dungeon-resource__value{display:block;min-width:0;font-size:1rem;font-weight:900;line-height:1;letter-spacing:0;text-align:left;}.dungeon-resource--gold{grid-template-columns:auto auto;}.dungeon-resource--gold .dungeon-resource__icon{width:60px;height:60px;max-width:none;}.dungeon-resource--gold .dungeon-resource__value,.dungeon-resource--deck .dungeon-resource__value{color:#ffffff;}.dungeon-resource--deck{grid-template-columns:auto auto;align-items:center;column-gap:10px;}.dungeon-resource--deck .dungeon-resource__value{text-align:right;}.dungeon-resource__deck-visual{position:relative;display:block;width:var(--deck-counter-width);min-width:var(--deck-counter-width);height:var(--deck-counter-anchor-height);overflow:visible;}.dungeon-resource__deck-visual .bc-image{position:absolute;left:0;bottom:var(--deck-counter-visual-bottom);width:100%;height:auto;}"
  ++ ".dungeon-level{display:grid;justify-items:center;align-content:start;gap:0;min-width:209px;text-align:center;}.dungeon-level__badge-frame,.dungeon-level__value-frame{display:grid;place-items:center;position:relative;}.dungeon-level__badge-frame{z-index:2;}.dungeon-level__value-frame{z-index:1;margin-top:0;}.dungeon-level__badge-art,.dungeon-level__badge-text,.dungeon-level__value-art,.dungeon-level__value-text{grid-area:1 / 1;}.dungeon-level__badge-art,.dungeon-level__value-art{pointer-events:none;}.dungeon-level__badge-art .bc-image,.dungeon-level__value-art .bc-image{width:auto!important;height:auto!important;}.dungeon-level__badge-text{display:inline-flex;align-items:center;justify-content:center;padding:0 24px;color:#ffffff;font-size:1.3rem;font-weight:900;line-height:1;letter-spacing:0;text-transform:uppercase;white-space:nowrap;-webkit-text-stroke:0.7px #323C9F;paint-order:stroke fill;text-shadow:0 1px 0 #323C9F,1px 0 0 #323C9F,-1px 0 0 #323C9F,0 -1px 0 #323C9F;transform:translateY(-1px);}.dungeon-level__value-text{display:flex;align-items:center;justify-content:center;min-width:0;color:var(--text);font-size:1.92rem;font-weight:900;line-height:0.9;letter-spacing:0;transform:translateY(var(--dungeon-level-value-offset-y));}"
  ++ "@media (max-width:800px){.topbar--dungeon{grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);min-height:66px;gap:var(--dungeon-topbar-gap-mobile);}.dungeon-resource{grid-template-columns:var(--header-icon-size-mobile) auto;column-gap:var(--header-icon-gap-mobile);min-height:36px;}.dungeon-resource__icon{width:var(--header-icon-size-mobile);height:var(--header-icon-size-mobile);}.dungeon-resource__value{font-size:0.9rem;}.dungeon-resource--deck{grid-template-columns:auto auto;column-gap:8px;}.dungeon-resource__deck-visual{height:var(--deck-counter-anchor-height-mobile);}.dungeon-resource__deck-visual .bc-image{bottom:var(--deck-counter-visual-bottom-mobile);}.dungeon-level{min-width:209px;gap:0;}.dungeon-level__value-frame{margin-top:0;}.dungeon-level__badge-text{padding:0 24px;font-size:1.3rem;-webkit-text-stroke:0.6px #323C9F;}.dungeon-level__value-text{font-size:1.64rem;}}"

def card_row_scale_css() -> String:
  ""
  ++ ".board .bc-grid-content-row:nth-child(1){--row-scale:0.8072;}.board .bc-grid-content-row:nth-child(2){--row-scale:0.9036;}.board .bc-grid-content-row:nth-child(3){--row-scale:1;}.board .card__art{transform:scale(var(--row-scale,1));transform-origin:center;}"

def cards_css() -> String:
  ""
  ++ ".board-slot{position:relative;display:grid;width:100%;height:100%;}.board-slot>*{position:relative;z-index:1;width:100%;height:100%;}.board-slot::before{content:'';position:absolute;inset:-3px;border-radius:var(--radius-md);opacity:0;pointer-events:none;z-index:2;}.bc-card{width:100%;}.board .bc-grid-content-cell,.board .bc-grid-content-cell-inner{background:transparent;}.board .bc-card{min-height:0;background:transparent;border-color:transparent;box-shadow:none;background-image:none;}.board .bc-card-body{height:100%;}.board .bc-card,.board .bc-card *{pointer-events:none;}.board .bc-card-surface{display:none;}.card{position:relative;display:flex;min-height:170px;flex-direction:column;justify-content:space-between;padding:12px;background:transparent;border:0;border-radius:0;box-shadow:none;overflow:visible;}.card--tile{justify-content:flex-start;}.board .card{min-height:0;padding:0;background:transparent;border:0;box-shadow:none;display:grid;grid-template-columns:1fr;grid-template-rows:80% 20%;justify-items:stretch;align-content:stretch;width:100%;height:100%;container-type:size;container-name:tile;}.board .bc-card-body>.card{height:100%;}.card__art-wrap{display:flex;flex:1;align-items:center;justify-content:center;padding:16px 10px;}.card__art-wrap--stacked{position:relative;overflow:hidden;}.card__art-layer{display:flex;align-items:center;justify-content:center;}.card__art-layer--base{position:relative;z-index:1;width:100%;height:100%;}.card__art-layer--fx{position:absolute;inset:0;z-index:2;pointer-events:none;}.card__art{width:100%;max-width:116px;max-height:116px;object-fit:contain;}.card__label{font-size:0.95rem;font-weight:700;text-align:center;}.card__label--tile{padding-right:6px;}.card__badge{display:inline-flex;align-items:center;justify-content:center;min-height:34px;padding:6px 10px;border-radius:999px;background:#fff;border:1px solid var(--surface-border);font-size:0.78rem;font-weight:700;}.card__badge--hp{color:var(--danger);}.card__badge--dmg{color:#0f63c9;}.card__info{display:flex;align-items:center;justify-content:space-between;gap:2cqmin;padding:0 2cqmin;min-width:0;}.board .card__art-wrap{padding:0;width:100%;min-width:0;min-height:0;}.board .card__art{display:block;height:100%;width:auto;max-width:100%;max-height:100%;object-fit:contain;}.board .card__label{font-size:clamp(0.64rem,2vw,0.82rem);line-height:1.05;}.board .card__label--tile{margin-bottom:6px;}.board .card__badge{min-height:0;padding:2.5cqmin 5cqmin;font-size:10cqmin;line-height:1.1;border-radius:999px;}.card__empty{display:grid;flex:1;place-items:center;color:var(--text-muted);font-weight:700;letter-spacing:0.06em;text-transform:uppercase;}"

def fx_css() -> String:
  ""
  ++ ".board-slot--impact-a::before{animation:slot-impact-a 280ms ease-out;border:2px solid rgba(194,28,28,0.62);}.board-slot--impact-b::before{animation:slot-impact-b 280ms ease-out;border:2px solid rgba(194,28,28,0.62);}.board-slot--kill-a::before{animation:slot-kill-a 360ms ease-out;border:2px solid rgba(194,28,28,0.8);}.board-slot--kill-b::before{animation:slot-kill-b 360ms ease-out;border:2px solid rgba(194,28,28,0.8);}.card__badge--hp-heal-a{animation:badge-heal-pulse-a 320ms ease-out;}.card__badge--hp-heal-b{animation:badge-heal-pulse-b 320ms ease-out;}.card__badge--hp-hurt-a{animation:badge-hurt-pulse-a 300ms ease-out;}.card__badge--hp-hurt-b{animation:badge-hurt-pulse-b 300ms ease-out;}.card__badge--dmg-up-a,.card__badge--dmg-up-b,.card__badge--dmg-down-a,.card__badge--dmg-down-b{will-change:transform;}.card__badge--dmg-up-a{animation:dmg-badge-up-a 280ms ease-out;}.card__badge--dmg-up-b{animation:dmg-badge-up-b 280ms ease-out;}.card__badge--dmg-down-a{animation:dmg-badge-down-a 260ms ease-out;}.card__badge--dmg-down-b{animation:dmg-badge-down-b 260ms ease-out;}"
  ++ "@keyframes slot-impact-a{0%{opacity:0;transform:scale(0.98);box-shadow:0 0 0 0 rgba(194,28,28,0);}30%{opacity:1;transform:scale(1.01);box-shadow:0 0 0 7px rgba(194,28,28,0.14);}100%{opacity:0;transform:scale(1.02);box-shadow:0 0 0 12px rgba(194,28,28,0);}}"
  ++ "@keyframes slot-impact-b{0%{opacity:0;transform:scale(0.98);box-shadow:0 0 0 0 rgba(194,28,28,0);}30%{opacity:1;transform:scale(1.01);box-shadow:0 0 0 7px rgba(194,28,28,0.14);}100%{opacity:0;transform:scale(1.02);box-shadow:0 0 0 12px rgba(194,28,28,0);}}"
  ++ "@keyframes slot-kill-a{0%{opacity:0;transform:scale(0.96);box-shadow:0 0 0 0 rgba(194,28,28,0);}24%{opacity:1;transform:scale(1.02);box-shadow:0 0 0 10px rgba(194,28,28,0.18);}100%{opacity:0;transform:scale(1.05);box-shadow:0 0 0 16px rgba(194,28,28,0);}}"
  ++ "@keyframes slot-kill-b{0%{opacity:0;transform:scale(0.96);box-shadow:0 0 0 0 rgba(194,28,28,0);}24%{opacity:1;transform:scale(1.02);box-shadow:0 0 0 10px rgba(194,28,28,0.18);}100%{opacity:0;transform:scale(1.05);box-shadow:0 0 0 16px rgba(194,28,28,0);}}"
  ++ "@keyframes badge-heal-pulse-a{0%{transform:scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}35%{transform:scale(1.08);box-shadow:0 0 0 8px rgba(15,99,201,0.14);}100%{transform:scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}}"
  ++ "@keyframes badge-heal-pulse-b{0%{transform:scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}35%{transform:scale(1.08);box-shadow:0 0 0 8px rgba(15,99,201,0.14);}100%{transform:scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}}"
  ++ "@keyframes badge-hurt-pulse-a{0%{transform:scale(1);box-shadow:0 0 0 rgba(194,28,28,0);}35%{transform:scale(0.96);box-shadow:0 0 0 9px rgba(194,28,28,0.16);}100%{transform:scale(1);box-shadow:0 0 0 rgba(194,28,28,0);}}"
  ++ "@keyframes badge-hurt-pulse-b{0%{transform:scale(1);box-shadow:0 0 0 rgba(194,28,28,0);}35%{transform:scale(0.96);box-shadow:0 0 0 9px rgba(194,28,28,0.16);}100%{transform:scale(1);box-shadow:0 0 0 rgba(194,28,28,0);}}"
  ++ "@keyframes dmg-badge-up-a{0%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}35%{transform:translateY(-2px) scale(1.08);box-shadow:0 0 0 7px rgba(15,99,201,0.14);}100%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}}"
  ++ "@keyframes dmg-badge-up-b{0%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}35%{transform:translateY(-2px) scale(1.08);box-shadow:0 0 0 7px rgba(15,99,201,0.14);}100%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(15,99,201,0);}}"
  ++ "@keyframes dmg-badge-down-a{0%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(12,18,28,0);}35%{transform:translateY(1px) scale(0.94);box-shadow:0 0 0 7px rgba(12,18,28,0.12);}100%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(12,18,28,0);}}"
  ++ "@keyframes dmg-badge-down-b{0%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(12,18,28,0);}35%{transform:translateY(1px) scale(0.94);box-shadow:0 0 0 7px rgba(12,18,28,0.12);}100%{transform:translateY(0) scale(1);box-shadow:0 0 0 rgba(12,18,28,0);}}"

def deck_screens_css() -> String:
  ""
  ++ ":root{--deck-tile-w-desktop:88px;--deck-tile-w-mobile:72px;--deck-tile-radius:var(--radius-md);--deck-grid-gap-desktop:14px;--deck-grid-gap-mobile:10px;--deck-list-cover-bg:#f7efe1;--deck-stage-max-width-desktop:1000px;--deck-list-max-width-desktop:1000px;--deck-list-card-w-desktop:140px;--deck-grid-mobile-max-width:calc(6 * var(--deck-tile-w-mobile) + 5 * var(--deck-grid-gap-mobile));--deck-detail-main-columns:2fr;--deck-detail-side-columns:1fr;--deck-detail-side-min-width:260px;--deck-grid-justify-desktop:start;--deck-grid-justify-mobile:center;--deck-tile-art-frame-width:60%;--deck-tile-art-frame-height:80%;}"
  ++ ".deck-chrome-headers{width:100%;display:grid;}.topbar--deck-chrome-mobile{display:none;}.deck-chrome-trailing{display:flex;align-items:center;gap:14px;justify-content:flex-end;min-width:0;}.deck-chrome-footer{display:flex;justify-content:flex-end;align-items:center;gap:10px;width:100%;}.deck-chrome-footer__action{min-width:140px;}.deck-chrome-footer__action>.bc-btn{width:100%;}.deck-chrome-footer__back{display:none;}"
  ++ ".deck-stage{display:grid;align-content:start;justify-items:center;width:100%;min-height:0;padding:8px;}.deck-stage__content{width:100%;max-width:var(--deck-stage-max-width-desktop);margin-inline:auto;display:grid;align-content:start;min-height:0;gap:18px;padding-top:18px;}.deck-list{width:100%;display:grid;justify-items:center;gap:18px;}.deck-list__grid{display:grid;grid-template-columns:repeat(auto-fit,var(--deck-list-card-w-desktop));gap:var(--deck-grid-gap-desktop);width:min(100%,var(--deck-list-max-width-desktop));justify-content:center;}.deck-list-card{position:relative;display:grid;grid-template-rows:1fr auto;gap:6px;padding:10px;border-radius:var(--radius-md);background:var(--surface);border:2px solid var(--surface-border);min-height:170px;cursor:pointer;transition:transform 120ms ease,border-color 120ms ease;}.deck-list-card:hover{transform:translateY(-2px);}.deck-list-card--active{border-color:var(--accent);box-shadow:0 0 0 2px rgba(32,32,32,0.16);}.deck-list-card--initial{background:var(--deck-list-cover-bg);}.deck-list-card--selected{border-color:var(--danger);box-shadow:0 0 0 2px rgba(194,28,28,0.24);}.deck-list-card--create{background:transparent;border:2px dashed var(--surface-border);display:grid;place-items:center;align-content:center;gap:6px;color:var(--text-muted);font-weight:800;letter-spacing:0.06em;text-transform:uppercase;cursor:pointer;}.deck-list-card__plus{font-size:2rem;line-height:1;}.deck-list-card__label{font-size:0.78rem;}.deck-list-card__body{display:grid;grid-template-rows:1fr auto auto;gap:4px;background:transparent;border:0;padding:0;cursor:pointer;color:inherit;text-align:center;width:100%;}.deck-list-card__cover{display:grid;place-items:center;background:var(--surface-strong);border-radius:var(--radius-sm);min-height:96px;overflow:hidden;padding:6px;}.deck-list-card__cover .bc-image{width:100%!important;height:100%!important;object-fit:contain;object-position:center bottom;}.deck-list-card__name{font-size:0.84rem;font-weight:800;color:var(--text);}.deck-list-card__count{font-size:0.74rem;color:var(--text-muted);font-weight:700;letter-spacing:0.04em;}.deck-list-card__bullet{position:absolute;top:8px;right:8px;width:22px;height:22px;border-radius:999px;border:2px solid var(--text-muted);background:#fff;display:grid;place-items:center;cursor:pointer;padding:0;}.deck-list-card__bullet--checked{border-color:var(--danger);background:var(--danger);}.deck-list-card__bullet-dot{display:block;width:10px;height:10px;border-radius:999px;background:#fff;opacity:0;}.deck-list-card__bullet--checked .deck-list-card__bullet-dot{opacity:1;}.deck-list-card__active-badge{position:absolute;bottom:8px;left:8px;font-size:0.6rem;font-weight:900;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);background:#fff;padding:2px 6px;border-radius:999px;border:1px solid var(--surface-border);}.deck-list-delete-action{display:grid;justify-items:center;width:min(100%,280px);}.deck-list-delete-action>.bc-btn{width:100%;}"
  ++ ".deck-sleeve-picker{position:relative;z-index:6;display:inline-grid;align-items:center;}.deck-sleeve-picker__layer{position:absolute;inset:0;overflow:visible;}.deck-sleeve-picker__backdrop{position:fixed;inset:0;border:0;padding:0;background:transparent;}.deck-sleeve-picker__menu{position:absolute;display:flex;align-items:center;gap:8px;padding:8px 10px;border:1px solid var(--surface-border);border-radius:999px;background:#fff;box-shadow:0 10px 24px rgba(17,17,17,0.16);white-space:nowrap;z-index:1;}.deck-sleeve-picker--card{position:absolute;top:8px;right:8px;}.deck-sleeve-picker__menu--card{top:calc(100% + 6px);right:0;}.deck-sleeve-picker--detail{flex:0 0 auto;}.deck-sleeve-picker__menu--detail{top:calc(100% + 8px);left:50%;transform:translateX(-50%);}.deck-sleeve-dot{appearance:none;display:block;border:0;padding:0;border-radius:999px;background-repeat:no-repeat;background-position:center center;background-size:cover;box-shadow:0 0 0 1px rgba(17,17,17,0.18),0 5px 12px rgba(17,17,17,0.14);cursor:pointer;}.deck-sleeve-dot--trigger{width:16px;height:16px;}.deck-sleeve-dot--option{width:18px;height:18px;}.deck-sleeve-dot--selected{box-shadow:0 0 0 2px var(--accent),0 6px 14px rgba(17,17,17,0.16);}.deck-sleeve-dot--blue{background-image:url(\"assets/ui/menu/deck-blue.png\");}.deck-sleeve-dot--chromatic{background-image:url(\"assets/ui/menu/deck-cromatico.png\");}"
  ++ ".deck-detail{display:grid;grid-template-columns:minmax(0,var(--deck-detail-main-columns)) minmax(var(--deck-detail-side-min-width),var(--deck-detail-side-columns));row-gap:14px;column-gap:24px;width:100%;align-items:start;}.deck-detail__main{display:grid;gap:14px;min-width:0;align-content:start;}.deck-detail__title-row{grid-column:1/-1;display:flex;align-items:baseline;justify-content:space-between;gap:12px;flex-wrap:wrap;}.deck-detail__deck-name-row{position:relative;display:flex;align-items:center;gap:10px;min-width:0;}.deck-detail__deck-name{margin:0;font-size:1.2rem;font-weight:900;letter-spacing:0.02em;}.deck-detail__deck-count{font-size:0.84rem;font-weight:900;letter-spacing:0.06em;text-transform:uppercase;color:var(--text-muted);}.deck-detail__picker-title{font-size:0.84rem;font-weight:900;letter-spacing:0.06em;text-transform:uppercase;color:var(--text);}.deck-section{display:grid;gap:8px;}.deck-section__header{display:flex;align-items:baseline;gap:8px;}.deck-section__title{display:inline-flex;align-items:baseline;gap:8px;background:transparent;border:0;padding:0;cursor:pointer;color:inherit;}.deck-section__label{font-weight:900;text-transform:uppercase;letter-spacing:0.04em;font-size:0.84rem;color:var(--text);}.deck-section__count{font-size:0.78rem;color:var(--text-muted);font-weight:800;}.deck-section__grid,.deck-pool__grid{display:grid;width:100%;grid-template-columns:repeat(auto-fit,var(--deck-tile-w-desktop));gap:var(--deck-grid-gap-desktop);justify-content:var(--deck-grid-justify-desktop);}.deck-tile{position:relative;display:grid;place-items:center;width:var(--deck-tile-w-desktop);aspect-ratio:1 / 1;border-radius:var(--deck-tile-radius);background:var(--surface);border:1px solid var(--surface-border);padding:6px;cursor:pointer;transition:transform 120ms ease,border-color 120ms ease;}.deck-tile:hover{transform:translateY(-2px);border-color:var(--accent);}.deck-tile--static{cursor:default;}.deck-tile--static:hover{transform:none;border-color:var(--surface-border);}.deck-tile--depleted{opacity:0.4;cursor:not-allowed;}.deck-tile--empty{background:transparent;border:2px dashed var(--surface-border);color:var(--text-muted);font-size:1.4rem;font-weight:900;}.deck-tile__art-wrap{display:grid;justify-items:center;align-items:end;width:100%;height:100%;}.deck-tile__art{display:block;width:var(--deck-tile-art-frame-width);height:var(--deck-tile-art-frame-height);max-width:none;max-height:none;object-fit:cover;object-position:center bottom;}.deck-tile__plus{font-size:1.6rem;line-height:1;color:var(--text-muted);}.deck-tile__badge{position:absolute;bottom:4px;right:4px;font-size:0.6rem;font-weight:800;background:#fff;border:1px solid var(--surface-border);border-radius:999px;padding:1px 6px;color:var(--text);}.deck-detail__side{padding:14px 0 0 24px;border-left:1px solid rgba(17,17,17,0.08);min-width:0;}.deck-pool{display:grid;gap:10px;}.deck-pool__header{display:flex;align-items:baseline;justify-content:space-between;gap:8px;}.deck-pool__title{margin:0;font-size:0.84rem;font-weight:900;text-transform:uppercase;letter-spacing:0.04em;color:var(--text);}.deck-picker{display:contents;}.deck-picker__preview{display:none;}.deck-pool-empty{display:grid;place-items:center;min-height:160px;padding:24px;border:2px dashed var(--surface-border);border-radius:var(--radius-md);color:var(--text-muted);text-align:center;}.deck-pool-empty__text{margin:0;font-size:0.86rem;font-weight:800;letter-spacing:0.04em;line-height:1.35;}.deck-tile--target{border-color:var(--accent);box-shadow:0 0 0 2px var(--accent);animation:deck-tile-target-pulse 1.6s ease-in-out infinite;}.deck-tile--target .deck-tile__plus{color:var(--accent);}@keyframes deck-tile-target-pulse{0%,100%{box-shadow:0 0 0 2px var(--accent);}50%{box-shadow:0 0 0 5px rgba(32,32,32,0.22);}}@media (hover:hover) and (pointer:fine){.deck-tile--filled:hover{background:rgba(194,28,28,0.92);border-color:var(--danger);transform:none;}.deck-tile--filled:hover .deck-tile__art{opacity:0.18;}.deck-tile--filled:hover::after{content:'';position:absolute;inset:0;display:grid;place-items:center;font-size:1.6rem;color:#fff;background-image:url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6'></path><path d='M10 11v6'></path><path d='M14 11v6'></path><path d='M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2'></path></svg>\");background-size:32px 32px;background-repeat:no-repeat;background-position:center;}}.deck-tile--armed{background:rgba(194,28,28,0.92);border-color:var(--danger);box-shadow:0 0 0 2px rgba(194,28,28,0.55);animation:deck-tile-armed-pulse 1.2s ease-in-out infinite;}.deck-tile--armed .deck-tile__art{opacity:0.18;}.deck-tile--armed::after{content:'';position:absolute;inset:0;display:grid;place-items:center;background-image:url(\"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='white' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='3 6 5 6 21 6'></polyline><path d='M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6'></path><path d='M10 11v6'></path><path d='M14 11v6'></path><path d='M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2'></path></svg>\");background-size:32px 32px;background-repeat:no-repeat;background-position:center;}@keyframes deck-tile-armed-pulse{0%,100%{box-shadow:0 0 0 2px rgba(194,28,28,0.55);}50%{box-shadow:0 0 0 5px rgba(194,28,28,0.35);}}.deck-detail__picker-title-block{display:flex;flex-direction:column;align-items:flex-end;gap:2px;text-align:right;}.deck-detail__picker-progress{font-size:0.7rem;font-weight:700;letter-spacing:0.04em;color:var(--text-muted);text-transform:none;}"
  ++ "@media (max-width:800px){.topbar--deck-chrome-desktop{display:none;}.topbar--deck-chrome-mobile{display:flex;}.deck-list__grid{grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:var(--deck-grid-gap-mobile);width:100%;}.deck-list-card{min-height:148px;}.deck-list-card__cover{min-height:78px;}.deck-detail{grid-template-columns:minmax(0,1fr);row-gap:14px;column-gap:14px;}.deck-detail__main{display:grid;justify-items:center;}.deck-detail__deck-panel{width:min(100%,var(--deck-grid-mobile-max-width));}.deck-detail__main--picker-open{display:none;}.deck-detail__side{display:none;border-left:0;padding:0;}.deck-stage--picker-open .deck-stage__content{grid-template-rows:auto 1fr;height:100%;min-height:0;}.deck-stage--picker-open .deck-detail{grid-template-rows:auto 1fr;height:100%;min-height:0;}.deck-stage--picker-open .deck-detail__side{display:grid;grid-template-rows:minmax(0,1fr) minmax(0,1fr);gap:12px;height:100%;min-height:0;}.deck-stage--picker-open .deck-picker__preview{display:grid;justify-items:center;align-content:start;overflow-y:auto;min-height:0;}.deck-stage--picker-open .deck-picker__pool{overflow-y:auto;min-height:0;align-content:start;display:grid;justify-items:center;}.deck-stage--picker-open .deck-picker__preview>.deck-section,.deck-stage--picker-open .deck-picker__pool>.deck-pool{width:min(100%,var(--deck-grid-mobile-max-width));}.deck-section__header,.deck-pool__header{width:100%;}.deck-section__grid,.deck-pool__grid{grid-template-columns:repeat(auto-fit,var(--deck-tile-w-mobile));gap:var(--deck-grid-gap-mobile);justify-content:start;}.deck-tile{width:var(--deck-tile-w-mobile);}.deck-chrome-footer{flex-wrap:nowrap;justify-content:flex-end;gap:10px;align-items:center;}.deck-chrome-footer__action{flex:1 1 auto;min-width:0;}.deck-chrome-footer__back{display:flex;flex:0 0 auto;margin-right:auto;}}"

def css() -> String:
  base_css()
  ++ layout_css()
  ++ ultimate_preview_css()
  ++ dungeon_scene_css()
  ++ dungeon_topbar_css()
  ++ cards_css()
  ++ card_row_scale_css()
  ++ fx_css()
  ++ deck_screens_css()
